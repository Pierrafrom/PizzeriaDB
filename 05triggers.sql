DELIMITER //
CREATE OR REPLACE TRIGGER before_client_insert
    BEFORE INSERT
    ON CLIENT
    FOR EACH ROW
BEGIN
    IF NEW.clientEmail IS NULL THEN
        SET NEW.clientRegistrationDate = NULL;
        SET NEW.clientLastLogin = NULL;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER IngredientQuantityAlert
    AFTER UPDATE
    ON INGREDIENT
    FOR EACH ROW
BEGIN
    DECLARE alertMessage VARCHAR(200);

    IF NEW.ingredientQuantity < 1000 AND (NEW.unit = 'ML' OR NEW.unit = 'G') THEN
        SET alertMessage =
                CONCAT('Ingredient "', NEW.ingredientName, '" is running low (', NEW.ingredientQuantity, ' ', NEW.unit,
                       ').');
        INSERT INTO ALERT (alertType, alertMessage) VALUES ('INGREDIENT_OUT_OF_STOCK', alertMessage);
    ELSEIF NEW.ingredientQuantity < 5 AND (NEW.unit = 'KG' OR NEW.unit = 'L') THEN
        SET alertMessage =
                CONCAT('Ingredient "', NEW.ingredientName, '" is running low (', NEW.ingredientQuantity, ' ', NEW.unit,
                       ').');
        INSERT INTO ALERT (alertType, alertMessage) VALUES ('INGREDIENT_OUT_OF_STOCK', alertMessage);
    ELSEIF NEW.ingredientQuantity < 1000 AND NEW.unit = 'MG' THEN
        SET alertMessage =
                CONCAT('Ingredient "', NEW.ingredientName, '" is running low (', NEW.ingredientQuantity, ' ', NEW.unit,
                       ').');
        INSERT INTO ALERT (alertType, alertMessage) VALUES ('INGREDIENT_OUT_OF_STOCK', alertMessage);
    ELSEIF NEW.ingredientQuantity < 500 AND NEW.unit = 'CL' THEN
        SET alertMessage =
                CONCAT('Ingredient "', NEW.ingredientName, '" is running low (', NEW.ingredientQuantity, ' ', NEW.unit,
                       ').');
        INSERT INTO ALERT (alertType, alertMessage) VALUES ('INGREDIENT_OUT_OF_STOCK', alertMessage);
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER after_order_pizza_insert
    AFTER INSERT
    ON ORDER_PIZZA
    FOR EACH ROW
BEGIN
    DECLARE exit handler for sqlexception
        BEGIN
            -- Insert the alert in case of error
            INSERT INTO ALERT (alertType, alertMessage)
            VALUES ('TRIGGER_ERROR', CONCAT('Error while updating stock for pizza ID: ', NEW.pizzaId));
        END;
    -- update the stock of the pizza
    CALL UpdatePizzaStock(NEW.pizzaId, NEW.pizzaQuantity, 'REMOVE');
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER after_order_dessert_insert
    AFTER INSERT
    ON ORDER_DESSERT
    FOR EACH ROW
BEGIN
    DECLARE exit handler for sqlexception
        BEGIN
            -- Insert the alert in case of error
            INSERT INTO ALERT (alertType, alertMessage)
            VALUES ('TRIGGER_ERROR', CONCAT('Error while updating stock for dessert ID: ', NEW.dessertId));
        END;

    -- Uodate the stock of the dessert
    CALL UpdateDessertStock(NEW.dessertId, NEW.dessertQuantity, 'REMOVE');
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER after_order_cocktail_insert
    AFTER INSERT
    ON ORDER_COCKTAIL
    FOR EACH ROW
BEGIN
    DECLARE exit handler for sqlexception
        BEGIN
            -- Insert the alert in case of error
            INSERT INTO ALERT (alertType, alertMessage)
            VALUES ('TRIGGER_ERROR', CONCAT('Error while updating stock for cocktail ID: ', NEW.cocktailId));
        END;

    -- Update the stock of the cocktail
    CALL UpdateCocktailStock(NEW.cocktailId, NEW.cocktailQuantity, 'REMOVE');
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER after_order_wine_insert
    AFTER INSERT
    ON ORDER_WINE
    FOR EACH ROW
BEGIN
    DECLARE exit handler for sqlexception
        BEGIN
            -- Insert the alert in case of error
            INSERT INTO ALERT (alertType, alertMessage)
            VALUES ('TRIGGER_ERROR', CONCAT('Error while updating stock for wine ID: ', NEW.wineId));
        END;

    -- Update the stock of the wine
    CALL UpdateWineStock(NEW.wineId, NEW.wineQuantity, 'REMOVE');
END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER after_order_soda_insert
    AFTER INSERT
    ON ORDER_SODA
    FOR EACH ROW
BEGIN
    DECLARE exit handler for sqlexception
        BEGIN
            -- Insert the alert in case of error
            INSERT INTO ALERT (alertType, alertMessage)
            VALUES ('TRIGGER_ERROR', CONCAT('Error while updating stock for soda ID: ', NEW.sodaId));
        END;

    -- Update the stock of the soda
    CALL UpdateSodaStock(NEW.sodaId, NEW.sodaQuantity, 'REMOVE');
END;
//
DELIMITER ;