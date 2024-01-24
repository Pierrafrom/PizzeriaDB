DELIMITER //
CREATE OR REPLACE PROCEDURE UserLogin(IN inputEmail VARCHAR(254),
                                      OUT userID INT, OUT hashedPassword CHAR(60))
BEGIN
    SELECT id,
           password
    INTO userID,
        hashedPassword
    FROM VIEW_CLIENT_ACCOUNT
    WHERE email = inputEmail;
    IF userID IS NULL THEN
        SET userID = -1;
        SET hashedPassword = '';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE RegisterOrUpdateClient(
    IN inputFirstName VARCHAR(30),
    IN inputLastName VARCHAR(30),
    IN inputEmail VARCHAR(254),
    IN inputPhone VARCHAR(20),
    IN inputPassword CHAR(60),
    OUT p_clientID INT
)
BEGIN
    SET p_clientID = -1;

    -- Verify if a client with the given email already exists in the view
    SELECT id
    INTO p_clientID
    FROM VIEW_CLIENT_NO_ACCOUNT
    WHERE firstName = inputFirstName
      AND lastName = inputLastName
      AND phone = inputPhone;

    IF p_clientID != -1 THEN
        -- Update the existing client
        UPDATE CLIENT
        SET clientEmail            = inputEmail,
            clientPassword         = inputPassword,
            clientRegistrationDate = CURRENT_TIMESTAMP,
            clientLastLogin        = CURRENT_TIMESTAMP
        WHERE clientId = p_clientID;

    ELSE
        -- Create a new client

        INSERT INTO CLIENT (clientFirstName, clientLastName, clientPhone, clientEmail, clientPassword)
        VALUES (inputFirstName, inputLastName, inputPhone, inputEmail, inputPassword);

        SET p_clientID = LAST_INSERT_ID();

    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdateLastLogin(IN p_clientID INT)
BEGIN
    -- Verify if a client with the given ID exists in the view
    IF EXISTS (SELECT 1 FROM VIEW_CLIENT_ACCOUNT WHERE id = p_clientID) THEN
        -- Met à jour le dernier timestamp de connexion
        UPDATE CLIENT
        SET clientLastLogin = CURRENT_TIMESTAMP
        WHERE clientId = p_clientID;
    ELSE
        -- If no client is found, signal an error
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No client found with the provided ID in VIEW_CLIENT_ACCOUNT';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE CheckEmailExists(IN inputEmail VARCHAR(255), OUT emailExists BOOLEAN)
BEGIN
    -- Verify if a client with the given email already exists in the view
    SELECT EXISTS(SELECT 1
                  FROM VIEW_CLIENT_ACCOUNT
                  WHERE email = inputEmail)
    INTO emailExists;
END //

DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdatePizzaStock(IN p_pizzaId SMALLINT UNSIGNED, IN p_quantity SMALLINT UNSIGNED,
                                             IN p_operation ENUM ('ADD', 'REMOVE'))
BEGIN
    DECLARE finished INT DEFAULT FALSE;
    DECLARE v_ingredientId INT UNSIGNED;
    DECLARE v_requiredQuantity DECIMAL(10, 2);
    DECLARE ingredient_cursor CURSOR FOR
        SELECT ingredientId, quantity
        FROM VIEW_PIZZA_INGREDIENTS
        WHERE id = p_pizzaId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;

    OPEN ingredient_cursor;

    stock_update_loop:
    LOOP
        FETCH ingredient_cursor INTO v_ingredientId, v_requiredQuantity;
        IF finished THEN
            LEAVE stock_update_loop;
        END IF;

        IF p_operation = 'ADD' THEN
            UPDATE INGREDIENT
            SET ingredientQuantity = ingredientQuantity + (v_requiredQuantity * p_quantity)
            WHERE ingredientId = v_ingredientId;
        ELSEIF p_operation = 'REMOVE' THEN
            UPDATE INGREDIENT
            SET ingredientQuantity = ingredientQuantity - (v_requiredQuantity * p_quantity)
            WHERE ingredientId = v_ingredientId;
        END IF;
    END LOOP;

    CLOSE ingredient_cursor;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdateDessertStock(IN p_dessertId SMALLINT UNSIGNED, IN p_quantity SMALLINT UNSIGNED,
                                               IN p_operation ENUM ('ADD', 'REMOVE'))
BEGIN
    DECLARE finished INT DEFAULT FALSE;
    DECLARE v_ingredientId INT UNSIGNED;
    DECLARE v_requiredQuantity DECIMAL(10, 2);
    DECLARE ingredient_cursor CURSOR FOR
        SELECT ingredientId, quantity
        FROM VIEW_DESSERT_INGREDIENTS
        WHERE id = p_dessertId;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = TRUE;

    OPEN ingredient_cursor;

    stock_update_loop:
    LOOP
        FETCH ingredient_cursor INTO v_ingredientId, v_requiredQuantity;
        IF finished THEN
            LEAVE stock_update_loop;
        END IF;

        IF p_operation = 'ADD' THEN
            UPDATE INGREDIENT
            SET ingredientQuantity = ingredientQuantity + (v_requiredQuantity * p_quantity)
            WHERE ingredientId = v_ingredientId;
        ELSEIF p_operation = 'REMOVE' THEN
            UPDATE INGREDIENT
            SET ingredientQuantity = ingredientQuantity - (v_requiredQuantity * p_quantity)
            WHERE ingredientId = v_ingredientId;
        END IF;
    END LOOP;

    CLOSE ingredient_cursor;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdateCocktailStock(IN p_cocktailId SMALLINT, IN p_quantity INT,
                                                IN p_operation ENUM ('ADD', 'REMOVE'))
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_ingredientId INT;
    DECLARE v_ingredientQuantity DECIMAL(10, 2);

    DECLARE cursor_ingredients CURSOR FOR
        SELECT ci.ingredientId, ci.quantity
        FROM COCKTAIL_INGREDIENT ci
        WHERE ci.cocktailId = p_cocktailId;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    OPEN cursor_ingredients;

    read_loop:
    LOOP
        FETCH cursor_ingredients INTO v_ingredientId, v_ingredientQuantity;
        IF v_done THEN
            LEAVE read_loop;
        END IF;

        IF p_operation = 'ADD' THEN
            UPDATE INGREDIENT
            SET ingredientQuantity = ingredientQuantity + (p_quantity * v_ingredientQuantity)
            WHERE ingredientId = v_ingredientId;
        ELSEIF p_operation = 'REMOVE' THEN
            UPDATE INGREDIENT
            SET ingredientQuantity = ingredientQuantity - (p_quantity * v_ingredientQuantity)
            WHERE ingredientId = v_ingredientId;
        END IF;
    END LOOP;

    CLOSE cursor_ingredients;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdateSodaStock(IN p_sodaId SMALLINT UNSIGNED, IN p_quantity SMALLINT UNSIGNED,
                                            IN p_operation ENUM ('ADD', 'REMOVE'))
BEGIN
    DECLARE current_stock SMALLINT UNSIGNED;
    DECLARE exit handler for sqlexception
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @p_sqlstate = RETURNED_SQLSTATE,
                @p_errno = MYSQL_ERRNO,
                @p_message = MESSAGE_TEXT;
            -- Insert an alert with detailed error description
            INSERT INTO ALERT (alertType, alertMessage)
            VALUES ('TRIGGER_ERROR', CONCAT('Error in UpdateSodaStock for Soda ID: ', p_sodaId,
                                            '; SQLSTATE: ', @p_sqlstate,
                                            '; Error No: ', @p_errno,
                                            '; Message: ', @p_message));
        END;

    SELECT stock INTO current_stock FROM SODA WHERE sodaId = p_sodaId;

    IF p_operation = 'ADD' THEN
        UPDATE SODA
        SET stock = stock + p_quantity
        WHERE sodaId = p_sodaId;
    ELSEIF p_operation = 'REMOVE' THEN
        IF current_stock >= p_quantity THEN
            UPDATE SODA
            SET stock = stock - p_quantity
            WHERE sodaId = p_sodaId;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock to remove';
        END IF;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdateWineStock(IN p_wineId SMALLINT UNSIGNED, IN p_quantity SMALLINT UNSIGNED,
                                            IN p_operation ENUM ('ADD', 'REMOVE'))
BEGIN
    DECLARE current_stock SMALLINT UNSIGNED;
    DECLARE exit handler for sqlexception
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @p_sqlstate = RETURNED_SQLSTATE,
                @p_errno = MYSQL_ERRNO,
                @p_message = MESSAGE_TEXT;
            -- Insert an alert with detailed error description
            INSERT INTO ALERT (alertType, alertMessage)
            VALUES ('TRIGGER_ERROR', CONCAT('Error in UpdateWineStock for Wine ID: ', p_wineId,
                                            '; SQLSTATE: ', @p_sqlstate,
                                            '; Error No: ', @p_errno,
                                            '; Message: ', @p_message));
        END;

    SELECT stock INTO current_stock FROM WINE WHERE wineId = p_wineId;

    IF p_operation = 'ADD' THEN
        UPDATE WINE
        SET stock = stock + p_quantity
        WHERE wineId = p_wineId;
    ELSEIF p_operation = 'REMOVE' THEN
        IF current_stock >= p_quantity THEN
            UPDATE WINE
            SET stock = stock - p_quantity
            WHERE wineId = p_wineId;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock to remove';
        END IF;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE OR REPLACE PROCEDURE GetUserOrCreate(IN p_phone VARCHAR(20), IN p_firstName VARCHAR(50),
                                            IN p_lastName VARCHAR(50),
                                            OUT p_clientId INT)
BEGIN
    -- Check if the user already exists
    SELECT clientId
    INTO p_clientId
    FROM CLIENT
    WHERE clientPhone = p_phone
      AND clientFirstName = p_firstName
      AND clientLastName = p_lastName;

    -- If the user doesn't exist, insert and get the new ID
    IF p_clientId IS NULL THEN
        INSERT INTO CLIENT (clientPhone, clientFirstName, clientLastName)
        VALUES (p_phone, p_firstName, p_lastName);

        SET p_clientId = LAST_INSERT_ID();
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE GetOrCreateAddress(IN p_streetNumber VARCHAR(10), IN p_street VARCHAR(100),
                                               IN p_city VARCHAR(100),
                                               IN p_postalCode VARCHAR(20), IN p_latitude DECIMAL(10, 7),
                                               IN p_longitude DECIMAL(10, 7), OUT p_addressId INT)
BEGIN
    -- Check if the address already exists based on GPS coordinates
    SELECT addressId
    INTO p_addressId
    FROM ADDRESS
    WHERE latitude = p_latitude
      AND longitude = p_longitude;

    -- If the address doesn't exist, insert it and get the new ID
    IF p_addressId IS NULL THEN
        INSERT INTO ADDRESS (addressNumber, street, city, postalCode, countryCode, latitude, longitude)
        VALUES (p_streetNumber, p_street, p_city, p_postalCode, 'FR', p_latitude, p_longitude);

        SET p_addressId = LAST_INSERT_ID();
    END IF;
END //
DELIMITER ;


DELIMITER //

CREATE OR REPLACE PROCEDURE CreateOrderForClient(
    IN p_phone VARCHAR(20),
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_streetNumber VARCHAR(10),
    IN p_street VARCHAR(100),
    IN p_city VARCHAR(100),
    IN p_postalCode VARCHAR(20),
    IN p_latitude DECIMAL(10, 7),
    IN p_longitude DECIMAL(10, 7),
    OUT p_orderId INT
)
BEGIN
    DECLARE v_clientId INT;
    DECLARE v_addressId INT;

    -- Call GetUserOrCreate to get or create the client
    CALL GetUserOrCreate(p_phone, p_firstName, p_lastName, v_clientId);

    -- Call GetOrCreateAddress to get or create the address
    CALL GetOrCreateAddress(p_streetNumber, p_street, p_city, p_postalCode, p_latitude, p_longitude, v_addressId);

    -- Create the order with the retrieved or created client and address IDs
    INSERT INTO CLIENT_ORDER (clientId, addressId)
    VALUES (v_clientId, v_addressId);

    SET p_orderId = LAST_INSERT_ID();
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE AddPizzaToOrder(
    IN p_orderId INT,
    IN p_pizzaId SMALLINT UNSIGNED,
    IN p_pizzaQuantity SMALLINT UNSIGNED
)
BEGIN
    INSERT INTO ORDER_PIZZA (orderId, pizzaId, pizzaQuantity)
    VALUES (p_orderId, p_pizzaId, p_pizzaQuantity);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE AddDessertToOrder(
    IN p_orderId INT,
    IN p_dessertId SMALLINT UNSIGNED,
    IN p_dessertQuantity SMALLINT UNSIGNED
)
BEGIN
    INSERT INTO ORDER_DESSERT (orderId, dessertId, dessertQuantity)
    VALUES (p_orderId, p_dessertId, p_dessertQuantity);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE AddWineToOrder(
    IN p_orderId INT,
    IN p_wineId SMALLINT UNSIGNED,
    IN p_wineQuantity SMALLINT UNSIGNED
)
BEGIN
    INSERT INTO ORDER_WINE (orderId, wineId, wineQuantity)
    VALUES (p_orderId, p_wineId, p_wineQuantity);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE AddCocktailToOrder(
    IN p_orderId INT,
    IN p_cocktailId SMALLINT UNSIGNED,
    IN p_cocktailQuantity SMALLINT UNSIGNED
)
BEGIN
    INSERT INTO ORDER_COCKTAIL (orderId, cocktailId, cocktailQuantity)
    VALUES (p_orderId, p_cocktailId, p_cocktailQuantity);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE AddSodaToOrder(
    IN p_orderId INT,
    IN p_sodaId SMALLINT UNSIGNED,
    IN p_sodaQuantity SMALLINT UNSIGNED
)
BEGIN
    INSERT INTO ORDER_SODA (orderId, sodaId, sodaQuantity)
    VALUES (p_orderId, p_sodaId, p_sodaQuantity);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE AddCustomPizzaToOrder(
    IN p_orderId INT,
    IN p_customPizzaId SMALLINT UNSIGNED,
    IN p_pizzaQuantity SMALLINT UNSIGNED
)
BEGIN
    INSERT INTO ORDER_PIZZA_CUSTOM (orderId, pizzaCustomId, pizzaQuantity)
    VALUES (p_orderId, p_customPizzaId, p_pizzaQuantity);
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdateOrderStatus(IN p_orderId INT,
                                              IN newStatus ENUM ( 'INGREDIENT_OUT_OF_STOCK',
                                                  'PIZZA_DELIVERED',
                                                  'PIZZA_DELIVERED_LATE',
                                                  'PIZZA_READY',
                                                  'TRIGGER_ERROR'
                                                  ))
BEGIN
    UPDATE CLIENT_ORDER
    SET status = newStatus
    WHERE orderId = p_orderId;

    IF newStatus = 'DELIVERED' THEN
        UPDATE CLIENT_ORDER
        SET deliveryDate = CURRENT_TIMESTAMP
        WHERE orderId = p_orderId;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdateIngredientStock(IN p_ingredientId INT, IN p_quantity DECIMAL(10, 2))
BEGIN
    UPDATE INGREDIENT
    SET ingredientQuantity = p_quantity
    WHERE ingredientId = p_ingredientId;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE ReplaceWineStock(IN p_wineId INT, IN p_quantity INT)
BEGIN
    UPDATE WINE
    SET stock = p_quantity
    WHERE wineId = p_wineId;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE ReplaceSodaStock(IN p_sodaId INT, IN p_quantity INT)
BEGIN
    UPDATE SODA
    SET stock = p_quantity
    WHERE sodaId = p_sodaId;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE CreateCustomPizza(
    IN p_originalPizzaId SMALLINT UNSIGNED,
    IN p_addedIngredient1 INT UNSIGNED,
    IN p_addedIngredient2 INT UNSIGNED,
    IN p_addedIngredient3 INT UNSIGNED,
    IN p_removedIngredient1 INT UNSIGNED,
    IN p_removedIngredient2 INT UNSIGNED,
    IN p_removedIngredient3 INT UNSIGNED,
    OUT p_customPizzaId SMALLINT UNSIGNED
)
BEGIN
    DECLARE my_custom_error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @p_sqlstate = RETURNED_SQLSTATE, @p_message = MESSAGE_TEXT;
            SET my_custom_error_message = CONCAT('Custom Error: ', @p_message);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = my_custom_error_message;
        END;

    INSERT INTO PIZZA_CUSTOM (originalPizza) VALUES (p_originalPizzaId);
    SET p_customPizzaId = LAST_INSERT_ID();

    -- Add the ingredients
    IF p_addedIngredient1 <> 40 AND p_addedIngredient1 > 0 THEN
        INSERT INTO PIZZA_CUSTOM_INGREDIENT (pizzaCustomId, ingredientAddedId, quantityAdded, ingredientRemovedId)
        VALUES (p_customPizzaId, p_addedIngredient1, 50, 40);
    END IF;
    IF p_addedIngredient2 <> 40 AND p_addedIngredient2 > 0 THEN
        INSERT INTO PIZZA_CUSTOM_INGREDIENT (pizzaCustomId, ingredientAddedId, quantityAdded, ingredientRemovedId)
        VALUES (p_customPizzaId, p_addedIngredient2, 50, 40);
    END IF;
    IF p_addedIngredient3 <> 40 AND p_addedIngredient3 > 0 THEN
        INSERT INTO PIZZA_CUSTOM_INGREDIENT (pizzaCustomId, ingredientAddedId, quantityAdded, ingredientRemovedId)
        VALUES (p_customPizzaId, p_addedIngredient3, 50, 40);
    END IF;

    -- Remove the ingredients
    IF p_removedIngredient1 <> 40 AND p_removedIngredient1 > 0 THEN
        INSERT INTO PIZZA_CUSTOM_INGREDIENT (pizzaCustomId, ingredientAddedId, quantityAdded, ingredientRemovedId)
        VALUES (p_customPizzaId, 40, 0, p_removedIngredient1);
    END IF;
    IF p_removedIngredient2 <> 40 AND p_removedIngredient2 > 0 THEN
        INSERT INTO PIZZA_CUSTOM_INGREDIENT (pizzaCustomId, ingredientAddedId, quantityAdded, ingredientRemovedId)
        VALUES (p_customPizzaId, 40, 0, p_removedIngredient2);
    END IF;
    IF p_removedIngredient3 <> 40 AND p_removedIngredient3 > 0 THEN
        INSERT INTO PIZZA_CUSTOM_INGREDIENT (pizzaCustomId, ingredientAddedId, quantityAdded, ingredientRemovedId)
        VALUES (p_customPizzaId, 40, 0, p_removedIngredient3);
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE OR REPLACE PROCEDURE AdminLogin(IN inputEmail VARCHAR(255),
                                       OUT outUserID INT,
                                       OUT outHashedPassword CHAR(60))
BEGIN
    SET outUserID = -1;

    SELECT id, password
    INTO outUserID, outHashedPassword
    FROM VIEW_MANAGERS
    WHERE email = inputEmail;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE CreatePizzaWithIngredients(
    IN p_pizzaName VARCHAR(50),
    IN p_pizzaPrice DECIMAL(5, 2),
    IN p_spotlight BOOLEAN,
    IN p_ingredientId1 INT,
    IN p_quantity1 DECIMAL(5, 2),
    IN p_ingredientId2 INT,
    IN p_quantity2 DECIMAL(5, 2),
    IN p_ingredientId3 INT,
    IN p_quantity3 DECIMAL(5, 2),
    IN p_ingredientId4 INT,
    IN p_quantity4 DECIMAL(5, 2),
    IN p_ingredientId5 INT,
    IN p_quantity5 DECIMAL(5, 2),
    IN p_ingredientId6 INT,
    IN p_quantity6 DECIMAL(5, 2),
    IN p_ingredientId7 INT,
    IN p_quantity7 DECIMAL(5, 2),
    IN p_ingredientId8 INT,
    IN p_quantity8 DECIMAL(5, 2),
    OUT p_newId INT
)
BEGIN
    DECLARE my_custom_error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @p_sqlstate = RETURNED_SQLSTATE, @p_message = MESSAGE_TEXT;
            SET my_custom_error_message = CONCAT('Custom Error: ', @p_message);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = my_custom_error_message;
        END;

    START TRANSACTION;

    INSERT INTO PIZZA(pizzaName, pizzaPrice, spotlight) VALUES (p_pizzaName, p_pizzaPrice, p_spotlight);
    SET p_newId = LAST_INSERT_ID();

    IF p_ingredientId1 IS NOT NULL THEN
        INSERT INTO PIZZA_INGREDIENT(pizzaId, ingredientId, quantity) VALUES (p_newId, p_ingredientId1, p_quantity1);
    END IF;
    IF p_ingredientId2 IS NOT NULL THEN
        INSERT INTO PIZZA_INGREDIENT(pizzaId, ingredientId, quantity) VALUES (p_newId, p_ingredientId2, p_quantity2);
    END IF;
    IF p_ingredientId3 IS NOT NULL THEN
        INSERT INTO PIZZA_INGREDIENT(pizzaId, ingredientId, quantity) VALUES (p_newId, p_ingredientId3, p_quantity3);
    END IF;
    IF p_ingredientId4 IS NOT NULL THEN
        INSERT INTO PIZZA_INGREDIENT(pizzaId, ingredientId, quantity) VALUES (p_newId, p_ingredientId4, p_quantity4);
    END IF;
    IF p_ingredientId5 IS NOT NULL THEN
        INSERT INTO PIZZA_INGREDIENT(pizzaId, ingredientId, quantity) VALUES (p_newId, p_ingredientId5, p_quantity5);
    END IF;
    IF p_ingredientId6 IS NOT NULL THEN
        INSERT INTO PIZZA_INGREDIENT(pizzaId, ingredientId, quantity) VALUES (p_newId, p_ingredientId6, p_quantity6);
    END IF;
    IF p_ingredientId7 IS NOT NULL THEN
        INSERT INTO PIZZA_INGREDIENT(pizzaId, ingredientId, quantity) VALUES (p_newId, p_ingredientId7, p_quantity7);
    END IF;
    IF p_ingredientId8 IS NOT NULL THEN
        INSERT INTO PIZZA_INGREDIENT(pizzaId, ingredientId, quantity) VALUES (p_newId, p_ingredientId8, p_quantity8);
    END IF;
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE CreateDessertWithIngredients(
    IN p_dessertName VARCHAR(50),
    IN p_dessertPrice DECIMAL(5, 2),
    IN p_spotlight BOOLEAN,
    IN p_ingredientId1 INT,
    IN p_quantity1 DECIMAL(5, 2),
    IN p_ingredientId2 INT,
    IN p_quantity2 DECIMAL(5, 2),
    IN p_ingredientId3 INT,
    IN p_quantity3 DECIMAL(5, 2),
    IN p_ingredientId4 INT,
    IN p_quantity4 DECIMAL(5, 2),
    IN p_ingredientId5 INT,
    IN p_quantity5 DECIMAL(5, 2),
    IN p_ingredientId6 INT,
    IN p_quantity6 DECIMAL(5, 2),
    IN p_ingredientId7 INT,
    IN p_quantity7 DECIMAL(5, 2),
    IN p_ingredientId8 INT,
    IN p_quantity8 DECIMAL(5, 2),
    OUT p_newId INT
)
BEGIN
    DECLARE my_custom_error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @p_sqlstate = RETURNED_SQLSTATE, @p_message = MESSAGE_TEXT;
            SET my_custom_error_message = CONCAT('Custom Error: ', @p_message);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = my_custom_error_message;
        END;

    START TRANSACTION;

    INSERT INTO DESSERT(dessertName, dessertPrice, spotlight)
    VALUES (p_dessertName, p_dessertPrice, p_spotlight);
    SET p_newId = LAST_INSERT_ID();

    IF p_ingredientId1 IS NOT NULL THEN
        INSERT INTO DESSERT_INGREDIENT(dessertId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId1, p_quantity1);
    END IF;
    IF p_ingredientId2 IS NOT NULL THEN
        INSERT INTO DESSERT_INGREDIENT(dessertId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId2, p_quantity2);
    END IF;
    IF p_ingredientId3 IS NOT NULL THEN
        INSERT INTO DESSERT_INGREDIENT(dessertId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId3, p_quantity3);
    END IF;
    IF p_ingredientId4 IS NOT NULL THEN
        INSERT INTO DESSERT_INGREDIENT(dessertId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId4, p_quantity4);
    END IF;
    IF p_ingredientId5 IS NOT NULL THEN
        INSERT INTO DESSERT_INGREDIENT(dessertId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId5, p_quantity5);
    END IF;
    IF p_ingredientId6 IS NOT NULL THEN
        INSERT INTO DESSERT_INGREDIENT(dessertId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId6, p_quantity6);
    END IF;
    IF p_ingredientId7 IS NOT NULL THEN
        INSERT INTO DESSERT_INGREDIENT(dessertId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId7, p_quantity7);
    END IF;
    IF p_ingredientId8 IS NOT NULL THEN
        INSERT INTO DESSERT_INGREDIENT(dessertId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId8, p_quantity8);
    END IF;
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE CreateCocktailWithIngredients(
    IN p_cocktailName VARCHAR(50),
    IN p_price DECIMAL(5, 2),
    IN p_alcoholPercentage DECIMAL(4, 2),
    IN p_spotlight BOOLEAN,
    IN p_ingredientId1 INT,
    IN p_quantity1 DECIMAL(5, 2),
    IN p_ingredientId2 INT,
    IN p_quantity2 DECIMAL(5, 2),
    IN p_ingredientId3 INT,
    IN p_quantity3 DECIMAL(5, 2),
    IN p_ingredientId4 INT,
    IN p_quantity4 DECIMAL(5, 2),
    IN p_ingredientId5 INT,
    IN p_quantity5 DECIMAL(5, 2),
    IN p_ingredientId6 INT,
    IN p_quantity6 DECIMAL(5, 2),
    IN p_ingredientId7 INT,
    IN p_quantity7 DECIMAL(5, 2),
    IN p_ingredientId8 INT,
    IN p_quantity8 DECIMAL(5, 2),
    OUT p_newId INT
)
BEGIN
    DECLARE my_custom_error_message VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @p_sqlstate = RETURNED_SQLSTATE, @p_message = MESSAGE_TEXT;
            SET my_custom_error_message = CONCAT('Custom Error: ', @p_message);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = my_custom_error_message;
        END;

    START TRANSACTION;

    INSERT INTO COCKTAIL(cocktailName, price, alcoholPercentage, spotlight)
    VALUES (p_cocktailName, p_price, p_alcoholPercentage, p_spotlight);
    SET p_newId = LAST_INSERT_ID();

    IF p_ingredientId1 IS NOT NULL THEN
        INSERT INTO COCKTAIL_INGREDIENT(cocktailId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId1, p_quantity1);
    END IF;
    IF p_ingredientId2 IS NOT NULL THEN
        INSERT INTO COCKTAIL_INGREDIENT(cocktailId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId2, p_quantity2);
    END IF;
    IF p_ingredientId3 IS NOT NULL THEN
        INSERT INTO COCKTAIL_INGREDIENT(cocktailId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId3, p_quantity3);
    END IF;
    IF p_ingredientId4 IS NOT NULL THEN
        INSERT INTO COCKTAIL_INGREDIENT(cocktailId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId4, p_quantity4);
    END IF;
    IF p_ingredientId5 IS NOT NULL THEN
        INSERT INTO COCKTAIL_INGREDIENT(cocktailId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId5, p_quantity5);
    END IF;
    IF p_ingredientId6 IS NOT NULL THEN
        INSERT INTO COCKTAIL_INGREDIENT(cocktailId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId6, p_quantity6);
    END IF;
    IF p_ingredientId7 IS NOT NULL THEN
        INSERT INTO COCKTAIL_INGREDIENT(cocktailId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId7, p_quantity7);
    END IF;
    IF p_ingredientId8 IS NOT NULL THEN
        INSERT INTO COCKTAIL_INGREDIENT(cocktailId, ingredientId, quantity)
        VALUES (p_newId, p_ingredientId8, p_quantity8);
    END IF;
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE CreateWine(
    IN p_wineName VARCHAR(50),
    IN p_glassPrice DECIMAL(5, 2),
    IN p_bottlePrice DECIMAL(6, 2),
    IN p_domain VARCHAR(50),
    IN p_grapeVariety VARCHAR(50),
    IN p_origin VARCHAR(50),
    IN p_alcoholPercentage DECIMAL(4, 2),
    IN p_year SMALLINT,
    IN p_color ENUM ('RED', 'WHITE', 'ROSE'),
    IN p_spotlight BOOLEAN,
    IN p_stock SMALLINT UNSIGNED,
    IN p_bottleType ENUM ('BOTTLE', 'PICCOLO', 'MAGNUM', 'JEROBOAM', 'REHOBOAM', 'MATHUSALEM'),
    OUT p_newId INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET p_newId = -1;
        END;

    START TRANSACTION;

    INSERT INTO WINE(wineName, glassPrice, bottlePrice, domain, grapeVariety, origin,
                     alcoholPercentage, year, color, spotlight, stock, bottleType)
    VALUES (p_wineName, p_glassPrice, p_bottlePrice, p_domain, p_grapeVariety, p_origin,
            p_alcoholPercentage, p_year, p_color, p_spotlight, p_stock, p_bottleType);

    SET p_newId = LAST_INSERT_ID();
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE CreateSoda(
    IN p_sodaName VARCHAR(50),
    IN p_price DECIMAL(5, 2),
    IN p_stock SMALLINT UNSIGNED,
    IN p_bottleType ENUM ('BOTTLE', 'CAN'),
    IN p_spotlight BOOLEAN,
    OUT p_newId INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET p_newId = -1;
        END;

    START TRANSACTION;

    INSERT INTO SODA(sodaName, price, stock, bottleType, spotlight)
    VALUES (p_sodaName, p_price, p_stock, p_bottleType, p_spotlight);

    SET p_newId = LAST_INSERT_ID();
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE CreateIngredient(
    IN p_ingredientName VARCHAR(50),
    IN p_ingredientDescription VARCHAR(100),
    IN p_ingredientQuantity DECIMAL(10, 2),
    IN p_isAllergen BOOLEAN,
    IN p_unit ENUM ('G', 'KG', 'ML', 'L', 'CL', 'MG'),
    OUT p_newId INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET p_newId = -1;
        END;

    START TRANSACTION;

    INSERT INTO INGREDIENT(ingredientName, ingredientDescription, ingredientQuantity, isAllergen, unit)
    VALUES (p_ingredientName, p_ingredientDescription, p_ingredientQuantity, p_isAllergen, p_unit);

    SET p_newId = LAST_INSERT_ID();
    COMMIT;
END //
DELIMITER ;

DELIMITER //

CREATE OR REPLACE PROCEDURE DeleteItem(IN itemId INT, IN itemType VARCHAR(10))
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;
    CASE itemType
        WHEN 'PIZZA' THEN DELETE FROM PIZZA WHERE pizzaId = itemId;
        WHEN 'DESSERT' THEN DELETE FROM DESSERT WHERE dessertId = itemId;
        WHEN 'COCKTAIL' THEN DELETE FROM COCKTAIL WHERE cocktailId = itemId;
        WHEN 'WINE' THEN DELETE FROM WINE WHERE wineId = itemId;
        WHEN 'INGREDIENT' THEN DELETE FROM INGREDIENT WHERE ingredientId = itemId;
        WHEN 'SODA' THEN DELETE FROM SODA WHERE sodaId = itemId;
        ELSE SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid item type';
        END CASE;
    SET FOREIGN_KEY_CHECKS = 1;
END //

DELIMITER ;

DELIMITER //

CREATE OR REPLACE PROCEDURE ToggleSpotlight(IN itemId INT, IN itemType VARCHAR(10))
BEGIN
    CASE itemType
        WHEN 'PIZZA' THEN UPDATE PIZZA SET spotlight = NOT spotlight WHERE pizzaId = itemId;
        WHEN 'DESSERT' THEN UPDATE DESSERT SET spotlight = NOT spotlight WHERE dessertId = itemId;
        WHEN 'COCKTAIL' THEN UPDATE COCKTAIL SET spotlight = NOT spotlight WHERE cocktailId = itemId;
        WHEN 'WINE' THEN UPDATE WINE SET spotlight = NOT spotlight WHERE wineId = itemId;
        WHEN 'SODA' THEN UPDATE SODA SET spotlight = NOT spotlight WHERE sodaId = itemId;
        ELSE SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid item type';
        END CASE;
END //

DELIMITER ;


