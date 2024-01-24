DROP TABLE IF EXISTS ORDER_PIZZA;
DROP TABLE IF EXISTS ORDER_PIZZA_CUSTOM;
DROP TABLE IF EXISTS ORDER_DESSERT;
DROP TABLE IF EXISTS ORDER_WINE;
DROP TABLE IF EXISTS ORDER_COCKTAIL;
DROP TABLE IF EXISTS ORDER_SODA;
DROP TABLE IF EXISTS ORDER_PROCESSING;
DROP TABLE IF EXISTS CLIENT_ORDER;
DROP TABLE IF EXISTS PIZZA_INGREDIENT;
DROP TABLE IF EXISTS PIZZA_CUSTOM_INGREDIENT;
DROP TABLE IF EXISTS COCKTAIL_INGREDIENT;
DROP TABLE IF EXISTS DESSERT_INGREDIENT;
DROP TABLE IF EXISTS PIZZA_CUSTOM;
DROP TABLE IF EXISTS PIZZA;
DROP TABLE IF EXISTS COCKTAIL;
DROP TABLE IF EXISTS DESSERT;
DROP TABLE IF EXISTS DISCOUNT;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS CLIENT_ADDRESS;
DROP TABLE IF EXISTS CLIENT;
DROP TABLE IF EXISTS INGREDIENT;
DROP TABLE IF EXISTS WINE;
DROP TABLE IF EXISTS SODA;
DROP TABLE IF EXISTS ADDRESS;
DROP TABLE IF EXISTS ALERT;

-- Create all tables
CREATE TABLE CLIENT
(
    clientId               INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    clientFirstName        VARCHAR(30) NOT NULL,
    clientLastName         VARCHAR(30) NOT NULL,
    clientPhone            VARCHAR(20) NOT NULL,
    clientEmail            VARCHAR(254) UNIQUE,
    clientPassword         CHAR(60),
    clientRegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    clientLastLogin        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT CHK_Email_Password CHECK (
        (clientEmail IS NOT NULL AND clientPassword IS NOT NULL)
            OR (clientEmail IS NULL AND clientPassword IS NULL)
        )
);

CREATE TABLE
    PIZZA
(
    pizzaId    SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    pizzaName  VARCHAR(50)           NOT NULL,
    pizzaPrice DECIMAL(5, 2)         NOT NULL,
    spotlight  BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE ADDRESS
(
    addressId     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    addressNumber SMALLINT UNSIGNED,
    street        VARCHAR(100)   NOT NULL,
    postalCode    VARCHAR(15)    NOT NULL,
    city          VARCHAR(50)    NOT NULL,
    countryCode   CHAR(2)        NOT NULL,
    latitude      DECIMAL(10, 8) NOT NULL,
    longitude     DECIMAL(11, 8) NOT NULL
);

CREATE TABLE
    CLIENT_ORDER
(
    orderId      INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    orderDate    DATETIME                                                            DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deliveryDate DATETIME                                                            DEFAULT NULL,
    status       ENUM ('PENDING', 'PREPARATION', 'SHIPPED', 'DELIVERED', 'CANCELED') DEFAULT 'PENDING'         NOT NULL,
    addressId    INT UNSIGNED                                                                                  NOT NULL,
    clientId     INT UNSIGNED                                                                                  NOT NULL,
    FOREIGN KEY (addressId) REFERENCES ADDRESS (addressId),
    FOREIGN KEY (clientId) REFERENCES CLIENT (clientId)
);

CREATE TABLE
    INGREDIENT
(
    ingredientId          INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    ingredientName        VARCHAR(50)                             NOT NULL,
    ingredientDescription VARCHAR(100),
    ingredientQuantity    DECIMAL(10, 2)                          NOT NULL,
    isAllergen            BOOLEAN                                 NOT NULL DEFAULT FALSE,
    unit                  ENUM ('G', 'KG', 'ML', 'L', 'CL', 'MG') NOT NULL
);

CREATE TABLE
    PIZZA_CUSTOM
(
    pizzaId       SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    originalPizza SMALLINT UNSIGNED,
    FOREIGN KEY (originalPizza) REFERENCES PIZZA (pizzaId)
);

CREATE TABLE
    ALERT
(
    alertId      INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    alertDate    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    alertType    ENUM ( 'INGREDIENT_OUT_OF_STOCK',
        'PIZZA_DELIVERED',
        'PIZZA_DELIVERED_LATE',
        'PIZZA_READY',
        'TRIGGER_ERROR'
        )                  NOT NULL,
    alertMessage VARCHAR(200),
    seen        BOOLEAN   NOT NULL DEFAULT FALSE
);

CREATE TABLE
    EMPLOYEE
(
    employeeId        SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    employeePosition  ENUM ('MANAGER', 'PIZZA_MAKER', 'DELIVERY_PERSON') NOT NULL,
    employeeFirstName VARCHAR(30)                                        NOT NULL,
    employeeLastName  VARCHAR(30)                                        NOT NULL,
    employeeEmail     VARCHAR(254) UNIQUE                                NOT NULL,
    employeePassword  CHAR(60)                                           NOT NULL, -- Hashed password
    employeePhone     VARCHAR(20) UNIQUE                                 NOT NULL,
    addressId         INT UNSIGNED                                       NOT NULL,
    FOREIGN KEY (addressId) REFERENCES ADDRESS (addressId)
);

CREATE TABLE WINE
(
    wineId            SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    wineName          VARCHAR(50)                                                                NOT NULL,
    glassPrice        DECIMAL(5, 2),
    bottlePrice       DECIMAL(6, 2)                                                              NOT NULL,
    domain            VARCHAR(50),
    grapeVariety      VARCHAR(50),
    origin            VARCHAR(50),
    alcoholPercentage DECIMAL(4, 2),
    year              SMALLINT,
    color             ENUM ('RED', 'WHITE', 'ROSE')                                              NOT NULL,
    spotlight         BOOLEAN DEFAULT FALSE                                                      NOT NULL,
    stock             SMALLINT UNSIGNED                                                          NOT NULL,
    bottleType        ENUM ('BOTTLE', 'PICCOLO', 'MAGNUM', 'JEROBOAM', 'REHOBOAM', 'MATHUSALEM') NOT NULL
);

CREATE TABLE COCKTAIL
(
    cocktailId        SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    cocktailName      VARCHAR(50)           NOT NULL,
    price             DECIMAL(5, 2)         NOT NULL,
    alcoholPercentage DECIMAL(4, 2)         NOT NULL,
    spotlight         BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE SODA
(
    sodaId     SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    sodaName   VARCHAR(50)            NOT NULL,
    price      DECIMAL(5, 2)          NOT NULL,
    stock      SMALLINT UNSIGNED      NOT NULL,
    bottleType ENUM ('BOTTLE', 'CAN') NOT NULL,
    spotlight  BOOLEAN DEFAULT FALSE  NOT NULL
);

CREATE TABLE
    DESSERT
(
    dessertId    SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    dessertName  VARCHAR(50)           NOT NULL,
    dessertPrice DECIMAL(5, 2)         NOT NULL,
    spotlight    BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE
    DISCOUNT
(
    discountId         INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    discountPercentage DECIMAL(5, 2) NOT NULL,
    expiryDate         DATE,
    used               BOOLEAN DEFAULT FALSE,
    reason             VARCHAR(100),
    useCode            INT           NOT NULL UNIQUE,
    clientId           INT UNSIGNED,
    FOREIGN KEY (clientId) REFERENCES CLIENT (clientId)
);

CREATE TABLE
    ORDER_PROCESSING
(
    orderId    INT UNSIGNED,
    employeeId SMALLINT UNSIGNED,
    FOREIGN KEY (orderId) REFERENCES CLIENT_ORDER (orderId),
    FOREIGN KEY (employeeId) REFERENCES EMPLOYEE (employeeId)
);

CREATE TABLE
    CLIENT_ADDRESS
(
    clientId     INT UNSIGNED,
    addressId    INT UNSIGNED,
    addressLabel VARCHAR(20), -- Ex: Home, Work, ...
    PRIMARY KEY (clientId, addressId),
    FOREIGN KEY (clientId) REFERENCES CLIENT (clientId),
    FOREIGN KEY (addressId) REFERENCES ADDRESS (addressId)
);

CREATE TABLE
    PIZZA_INGREDIENT
(
    pizzaId      SMALLINT UNSIGNED,
    ingredientId INT UNSIGNED,
    quantity     DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (pizzaId, ingredientId),
    FOREIGN KEY (pizzaId) REFERENCES PIZZA (pizzaId),
    FOREIGN KEY (ingredientId) REFERENCES INGREDIENT (ingredientId)
);

CREATE TABLE
    PIZZA_CUSTOM_INGREDIENT
(
    pizzaCustomId       SMALLINT UNSIGNED,
    ingredientAddedId   INT UNSIGNED  NULL,
    ingredientRemovedId INT UNSIGNED  NULL,
    quantityAdded       DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (pizzaCustomId, ingredientAddedId, ingredientRemovedId),
    FOREIGN KEY (pizzaCustomId) REFERENCES PIZZA_CUSTOM (pizzaId),
    FOREIGN KEY (ingredientAddedId) REFERENCES INGREDIENT (ingredientId),
    FOREIGN KEY (ingredientRemovedId) REFERENCES INGREDIENT (ingredientId)
);

CREATE TABLE
    COCKTAIL_INGREDIENT
(
    cocktailId   SMALLINT UNSIGNED,
    ingredientId INT UNSIGNED,
    quantity     DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (cocktailId, ingredientId),
    FOREIGN KEY (cocktailId) REFERENCES COCKTAIL (cocktailId),
    FOREIGN KEY (ingredientId) REFERENCES INGREDIENT (ingredientId)
);

CREATE TABLE
    DESSERT_INGREDIENT
(
    ingredientId INT UNSIGNED,
    dessertId    SMALLINT UNSIGNED,
    quantity     DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (ingredientId, dessertId),
    FOREIGN KEY (ingredientId) REFERENCES INGREDIENT (ingredientId),
    FOREIGN KEY (dessertId) REFERENCES DESSERT (dessertId)
);


CREATE TABLE
    ORDER_PIZZA
(
    pizzaId       SMALLINT UNSIGNED,
    orderId       INT UNSIGNED,
    pizzaQuantity SMALLINT UNSIGNED,
    PRIMARY KEY (pizzaId, orderId),
    FOREIGN KEY (pizzaId) REFERENCES PIZZA (pizzaId),
    FOREIGN KEY (orderId) REFERENCES CLIENT_ORDER (orderId)
);

CREATE TABLE
    ORDER_PIZZA_CUSTOM
(
    pizzaCustomId SMALLINT UNSIGNED,
    orderId       INT UNSIGNED,
    pizzaQuantity SMALLINT UNSIGNED,
    PRIMARY KEY (pizzaCustomId, orderId),
    FOREIGN KEY (pizzaCustomId) REFERENCES PIZZA_CUSTOM (pizzaId),
    FOREIGN KEY (orderId) REFERENCES CLIENT_ORDER (orderId)
);

CREATE TABLE
    ORDER_DESSERT
(
    orderId         INT UNSIGNED,
    dessertId       SMALLINT UNSIGNED,
    dessertQuantity SMALLINT UNSIGNED,
    PRIMARY KEY (orderId, dessertId),
    FOREIGN KEY (orderId) REFERENCES CLIENT_ORDER (orderId),
    FOREIGN KEY (dessertId) REFERENCES DESSERT (dessertId)
);

CREATE TABLE
    ORDER_WINE
(
    orderId      INT UNSIGNED,
    wineId       SMALLINT UNSIGNED,
    wineQuantity SMALLINT UNSIGNED,
    PRIMARY KEY (orderId, wineId),
    FOREIGN KEY (orderId) REFERENCES CLIENT_ORDER (orderId),
    FOREIGN KEY (wineId) REFERENCES WINE (wineId)
);

CREATE TABLE
    ORDER_COCKTAIL
(
    orderId          INT UNSIGNED,
    cocktailId       SMALLINT UNSIGNED,
    cocktailQuantity SMALLINT UNSIGNED,
    PRIMARY KEY (orderId, cocktailId),
    FOREIGN KEY (orderId) REFERENCES CLIENT_ORDER (orderId),
    FOREIGN KEY (cocktailId) REFERENCES COCKTAIL (cocktailId)
);

CREATE TABLE
    ORDER_SODA
(
    orderId      INT UNSIGNED,
    sodaId       SMALLINT UNSIGNED,
    sodaQuantity SMALLINT UNSIGNED,
    PRIMARY KEY (orderId, sodaId),
    FOREIGN KEY (orderId) REFERENCES CLIENT_ORDER (orderId),
    FOREIGN KEY (sodaId) REFERENCES SODA (sodaId)
);