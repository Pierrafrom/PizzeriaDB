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
    IF p_operation = 'ADD' THEN
        UPDATE SODA
        SET stock = stock + p_quantity
        WHERE sodaId = p_sodaId;
    ELSEIF p_operation = 'REMOVE' THEN
        UPDATE SODA
        SET stock = stock - p_quantity
        WHERE sodaId = p_sodaId;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE UpdateWineStock(IN p_wineId SMALLINT UNSIGNED, IN p_quantity SMALLINT UNSIGNED,
                                            IN p_operation ENUM ('ADD', 'REMOVE'))
BEGIN
    IF p_operation = 'ADD' THEN
        UPDATE WINE
        SET stock = stock + p_quantity
        WHERE wineId = p_wineId;
    ELSEIF p_operation = 'REMOVE' THEN
        UPDATE WINE
        SET stock = stock - p_quantity
        WHERE wineId = p_wineId;
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
CREATE OR REPLACE PROCEDURE UpdateIngredientStock(IN p_ingredientId INT, IN p_quantity DECIMAL(10, 2),
                                                  IN p_operation ENUM ('ADD', 'REMOVE'))
BEGIN
    IF p_operation = 'ADD' THEN
        UPDATE INGREDIENT
        SET ingredientQuantity = ingredientQuantity + p_quantity
        WHERE ingredientId = p_ingredientId;
    ELSEIF p_operation = 'REMOVE' THEN
        UPDATE INGREDIENT
        SET ingredientQuantity = ingredientQuantity - p_quantity
        WHERE ingredientId = p_ingredientId;
    END IF;
END //
DELIMITER ;
