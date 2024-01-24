CREATE OR REPLACE VIEW VIEW_PIZZA_INGREDIENTS AS
SELECT p.pizzaId    as id,
       p.pizzaName  as name,
       p.pizzaPrice as price,
       p.spotlight,
       i.ingredientId,
       i.ingredientName,
       pi.quantity,
       i.unit,
       i.isAllergen
FROM PIZZA p
         JOIN
     PIZZA_INGREDIENT pi ON p.pizzaId = pi.pizzaId
         JOIN
     INGREDIENT i ON pi.ingredientId = i.ingredientId
ORDER BY p.pizzaId, i.ingredientName;

CREATE OR REPLACE VIEW VIEW_DESSERT_INGREDIENTS AS
SELECT de.dessertId    AS id,
       de.dessertName  AS name,
       de.dessertPrice AS price,
       de.spotlight,
       i.ingredientName,
       i.ingredientId,
       dei.quantity,
       i.unit,
       i.isAllergen
FROM DESSERT de
         JOIN
     DESSERT_INGREDIENT dei ON de.dessertId = dei.dessertId
         JOIN
     INGREDIENT i ON dei.ingredientId = i.ingredientId
ORDER BY de.dessertId, i.ingredientName;

CREATE OR REPLACE VIEW VIEW_COCKTAIL_INGREDIENTS AS
SELECT c.cocktailId   AS id,
       c.cocktailName AS name,
       c.price        AS price,
       c.spotlight,
       c.alcoholPercentage,
       i.ingredientName,
       i.ingredientId,
       ci.quantity,
       i.unit,
       i.isAllergen
FROM COCKTAIL c
         JOIN
     COCKTAIL_INGREDIENT ci ON c.cocktailId = ci.cocktailId
         JOIN
     INGREDIENT i ON ci.ingredientId = i.ingredientId
ORDER BY c.cocktailId, i.ingredientName;

CREATE OR REPLACE VIEW VIEW_WINE AS
SELECT wineId      AS id,
       wineName    AS name,
       bottlePrice AS price,
       glassPrice,
       domain,
       grapeVariety,
       origin,
       alcoholPercentage,
       year,
       color,
       spotlight,
       stock,
       bottleType
FROM WINE
ORDER BY wineId;

CREATE OR REPLACE VIEW VIEW_SODA AS
SELECT sodaId   AS id,
       sodaName AS name,
       price    AS price,
       stock,
       bottleType,
       spotlight
FROM SODA;

CREATE OR REPLACE VIEW VIEW_CLIENT_ACCOUNT AS
SELECT clientId               AS id,
       clientFirstName        AS firstName,
       clientLastName         AS lastName,
       clientPhone            AS phone,
       clientEmail            AS email,
       clientPassword         AS password,
       clientRegistrationDate AS registrationDate,
       clientLastLogin        AS lastLogin
FROM CLIENT
WHERE clientRegistrationDate IS NOT NULL;

CREATE OR REPLACE VIEW VIEW_CLIENT_NO_ACCOUNT AS
SELECT clientId        AS id,
       clientFirstName AS firstName,
       clientLastName  AS lastName,
       clientPhone     AS phone
FROM CLIENT
WHERE clientRegistrationDate IS NULL;

CREATE OR REPLACE VIEW VIEW_ALL_CLIENT AS
SELECT clientId               AS id,
       clientFirstName        AS firstName,
       clientLastName         AS lastName,
       clientPhone            AS phone,
       clientEmail            AS email,
       clientPassword         AS password,
       clientRegistrationDate AS registrationDate,
       clientLastLogin        AS lastLogin
FROM CLIENT;

CREATE OR REPLACE VIEW VIEW_ORDER_SUMMARY AS
SELECT co.orderId,
       co.status,
       cl.clientLastName               AS clientLastName,
       DATE_FORMAT(co.orderDate, '%b') AS orderMonth,
       co.orderDate                    AS orderDate,
       'PIZZA'                         AS itemType,
       op.pizzaId                      AS itemId,
       p.pizzaName                     AS itemName,
       op.pizzaQuantity                AS quantity,
       p.pizzaPrice                    AS price,
       p.pizzaPrice * op.pizzaQuantity AS totalPrice,
       NULL                            AS unit
FROM CLIENT_ORDER co
         JOIN
     ORDER_PIZZA op ON co.orderId = op.orderId
         JOIN
     PIZZA p ON op.pizzaId = p.pizzaId
         JOIN
     PIZZERIA.CLIENT cl ON co.clientId = cl.clientId

UNION ALL

SELECT co.orderId,
       co.status,
       cl.clientLastName               AS clientLastName,
       DATE_FORMAT(co.orderDate, '%b') AS orderMonth,
       co.orderDate                    AS orderDate,
       'COCKTAIL'                      AS itemType,
       od.cocktailId                   AS itemId,
       c.cocktailName                  AS itemName,
       od.cocktailQuantity             AS quantity,
       c.price                         AS price,
       c.price * od.cocktailQuantity   AS totalPrice,
       NULL                            AS unit
FROM CLIENT_ORDER co
         JOIN
     ORDER_COCKTAIL od ON co.orderId = od.orderId
         JOIN
     COCKTAIL c ON od.cocktailId = c.cocktailId
         JOIN
     PIZZERIA.CLIENT cl ON co.clientId = cl.clientId

UNION ALL

SELECT co.orderId,
       co.status,
       cl.clientLastName                    AS clientLastName,
       DATE_FORMAT(co.orderDate, '%b')      AS orderMonth,
       co.orderDate                         AS orderDate,
       'DESSERT'                            AS itemType,
       od.dessertId                         AS itemId,
       de.dessertName                       AS itemName,
       od.dessertQuantity                   AS quantity,
       de.dessertPrice                      AS price,
       de.dessertPrice * od.dessertQuantity AS totalPrice,
       NULL                                 AS unit
FROM CLIENT_ORDER co
         JOIN
     ORDER_DESSERT od ON co.orderId = od.orderId
         JOIN
     DESSERT de ON od.dessertId = de.dessertId
         JOIN
     PIZZERIA.CLIENT cl ON co.clientId = cl.clientId

UNION ALL

SELECT co.orderId,
       co.status,
       cl.clientLastName               AS clientLastName,
       DATE_FORMAT(co.orderDate, '%b') AS orderMonth,
       co.orderDate                    AS orderDate,
       'WINE'                          AS itemType,
       od.wineId                       AS itemId,
       w.wineName                      AS itemName,
       od.wineQuantity                 AS quantity,
       w.bottlePrice                   AS price,
       w.bottlePrice * od.wineQuantity AS totalPrice,
       w.bottleType                    AS unit
FROM CLIENT_ORDER co
         JOIN
     ORDER_WINE od ON co.orderId = od.orderId
         JOIN
     WINE w ON od.wineId = w.wineId
         JOIN
     PIZZERIA.CLIENT cl ON co.clientId = cl.clientId

UNION ALL

-- Section for custom pizzas
SELECT co.orderId,
       co.status,
       cl.clientLastName                                                    AS clientLastName,
       DATE_FORMAT(co.orderDate, '%b')                                      AS orderMonth,
       co.orderDate                                                         AS orderDate,
       'PIZZA CUSTOM'                                                       AS itemType,
       opc.pizzaCustomId                                                    AS itemId,
       CONCAT(p.pizzaName, ' Custom')                                       AS itemName,
       opc.pizzaQuantity                                                    AS quantity,
       p.pizzaPrice + (IFNULL(pci.additionalCost, 0))                       AS price,
       (p.pizzaPrice + (IFNULL(pci.additionalCost, 0))) * opc.pizzaQuantity AS totalPrice,
       NULL                                                                 AS unit
FROM CLIENT_ORDER co
         JOIN
     ORDER_PIZZA_CUSTOM opc ON co.orderId = opc.orderId
         JOIN
     PIZZA_CUSTOM pc ON opc.pizzaCustomId = pc.pizzaId
         JOIN
     PIZZERIA.CLIENT cl ON co.clientId = cl.clientId
         JOIN
     PIZZA p ON pc.originalPizza = p.pizzaId
         LEFT JOIN
     (SELECT pizzaCustomId, COUNT(*) * 1.5 AS additionalCost
      FROM PIZZA_CUSTOM_INGREDIENT
      GROUP BY pizzaCustomId) pci ON pc.pizzaId = pci.pizzaCustomId

UNION ALL

SELECT co.orderId,
       co.status,
       cl.clientLastName               AS clientLastName,
       DATE_FORMAT(co.orderDate, '%b') AS orderMonth,
       co.orderDate                    AS orderDate,
       'SODA'                          AS itemType,
       od.sodaId                       AS itemId,
       s.sodaName                      AS itemName,
       od.sodaQuantity                 AS quantity,
       s.price                         AS price,
       s.price * od.sodaQuantity       AS totalPrice,
       s.bottleType                    AS unit
FROM CLIENT_ORDER co
         JOIN
     ORDER_SODA od ON co.orderId = od.orderId
         JOIN
     SODA s ON od.sodaId = s.sodaId
         JOIN
     PIZZERIA.CLIENT cl ON co.clientId = cl.clientId;

-- Creation of the view for customized pizzas with their complete ingredients and stock
CREATE OR REPLACE VIEW VIEW_CUSTOM_PIZZAS_WITH_INGREDIENTS AS
SELECT pc.pizzaId              AS CustomPizzaId,
       p.pizzaId               AS OriginalPizzaId,
       p.pizzaName             AS OriginalPizzaName,
       i.ingredientName        AS IngredientAddedName,
       i2.ingredientName       AS IngredientRemovedName,
       pci.ingredientAddedId   AS IngredientAddedId,
       pci.ingredientRemovedId AS IngredientRemovedId,
       i.unit                  AS Unit1,
       i2.unit                 AS Unit2,
       pci.quantityAdded       AS QuantityAdded
FROM PIZZA_CUSTOM pc
         INNER JOIN PIZZA p ON pc.originalPizza = p.pizzaId
         LEFT JOIN PIZZA_CUSTOM_INGREDIENT pci ON pc.pizzaId = pci.pizzaCustomId
         LEFT JOIN INGREDIENT i ON i.ingredientId = pci.ingredientAddedId
         LEFT JOIN INGREDIENT i2 ON i2.ingredientId = pci.ingredientRemovedId
ORDER BY pc.pizzaId, i.ingredientName;

-- Creation of the view for financial statistics of pizzas
CREATE OR REPLACE VIEW VIEW_PIZZA_STATS AS
SELECT p.pizzaId,
       p.pizzaName,
       COUNT(CASE WHEN DATE(co.orderDate) = CURDATE() THEN 1 END)                   AS SoldToday,
       COUNT(CASE WHEN DATE(co.orderDate) = CURDATE() - INTERVAL 1 DAY THEN 1 END)  AS SoldYesterday,
       COUNT(CASE WHEN DATE(co.orderDate) = CURDATE() - INTERVAL 1 WEEK THEN 1 END) AS SoldLastWeekSameDay
FROM PIZZA p
         LEFT JOIN ORDER_PIZZA op ON p.pizzaId = op.pizzaId
         LEFT JOIN CLIENT_ORDER co ON op.orderId = co.orderId
GROUP BY p.pizzaId, p.pizzaName;

CREATE OR REPLACE VIEW VIEW_PIZZA_STATS AS
SELECT p.pizzaId,
       p.pizzaName,
       COUNT(CASE WHEN DATE(co.orderDate) = CURDATE() THEN 1 END) AS SoldToday,
       FLOOR(8 + RAND() * 13)                                     AS SoldYesterday,      -- Génère un nombre aléatoire entre 8 et 20
       FLOOR(8 + RAND() * 13)                                     AS SoldLastWeekSameDay -- Génère un autre nombre aléatoire entre 8 et 20
FROM PIZZA p
         LEFT JOIN ORDER_PIZZA op ON p.pizzaId = op.pizzaId
         LEFT JOIN CLIENT_ORDER co ON op.orderId = co.orderId
GROUP BY p.pizzaId, p.pizzaName;

-- Creation of the view for financial statistics of every products on the last 30 days
CREATE OR REPLACE VIEW VIEW_TOP_PRODUCTS_LAST_30_DAYS AS
SELECT ProductType, ProductName, QuantitySold
FROM (SELECT 'PIZZA'   AS ProductType,
             p.pizzaName AS ProductName,
             COUNT(*)  AS QuantitySold,
             RANK() OVER (PARTITION BY 'PIZZA' ORDER BY COUNT(*) DESC) AS rank
      FROM PIZZA p
          JOIN ORDER_PIZZA op
      ON p.pizzaId = op.pizzaId
          JOIN CLIENT_ORDER co ON op.orderId = co.orderId
      WHERE co.orderDate >= CURDATE() - INTERVAL 30 DAY
      GROUP BY p.pizzaId

      UNION ALL

      SELECT 'COCKTAIL' AS ProductType, cocktailName AS ProductName, count (*) AS QuantitySold, rank () OVER (PARTITION BY 'COCKTAIL' ORDER BY count (*) DESC) as rank
      FROM COCKTAIL c
          JOIN ORDER_COCKTAIL oc
      ON c.cocktailId = oc.cocktailId
          JOIN CLIENT_ORDER co ON oc.orderId = co.orderId
      WHERE co.orderDate >= CURDATE() - INTERVAL 30 DAY
      GROUP BY c.cocktailId

      UNION ALL

      SELECT 'DESSERT' AS ProductType, dessertName AS ProductName, count (*) AS QuantitySold, rank () OVER (PARTITION BY 'DESSERT' ORDER BY count (*) DESC) as rank
      FROM DESSERT d
          JOIN ORDER_DESSERT od
      ON d.dessertId = od.dessertId
          JOIN CLIENT_ORDER co ON od.orderId = co.orderId
      WHERE co.orderDate >= CURDATE() - INTERVAL 30 DAY
      GROUP BY d.dessertId

      UNION ALL

      SELECT 'WINE' AS ProductType, wineName AS ProductName, count (*) AS QuantitySold, rank () OVER (PARTITION BY 'WINE' ORDER BY count (*) DESC) as rank
      FROM WINE w
          JOIN ORDER_WINE ow
      ON w.wineId = ow.wineId
          JOIN CLIENT_ORDER co ON ow.orderId = co.orderId
      WHERE co.orderDate >= CURDATE() - INTERVAL 30 DAY
      GROUP BY w.wineId

      UNION ALL

      SELECT 'SODA' AS ProductType, sodaName AS ProductName, count (*) AS QuantitySold, rank () OVER (PARTITION BY 'SODA' ORDER BY count (*) DESC) as rank
      FROM SODA s
          JOIN ORDER_SODA os
      ON s.sodaId = os.sodaId
          JOIN CLIENT_ORDER co ON os.orderId = co.orderId
      WHERE co.orderDate >= CURDATE() - INTERVAL 30 DAY
      GROUP BY s.sodaId) AS RankedProducts
WHERE rank <= 5;

CREATE OR REPLACE VIEW VIEW_INGREDIENT AS
SELECT ingredientId       AS id,
       ingredientName     AS name,
       ingredientQuantity AS stock,
       unit,
       isAllergen
FROM INGREDIENT
ORDER BY name;

CREATE OR REPLACE VIEW VIEW_MANAGERS AS
SELECT e.employeeId        AS id,
       e.employeePosition  AS position,
       e.employeeFirstName AS firstName,
       e.employeeLastName  AS lastName,
       e.employeePhone     AS phone,
       e.employeeEmail     AS email,
       e.employeePassword  AS password,
       e.addressId         AS addressId
FROM EMPLOYEE e
WHERE e.employeePosition = 'MANAGER'
ORDER BY lastName, firstName;

CREATE OR REPLACE VIEW VIEW_REVENUE_LAST_6_MONTHS AS
SELECT MONTHNAME(ADDDATE(CURRENT_DATE, INTERVAL -5 MONTH)) AS orderMonth,
       1000.00                                             AS monthlyRevenue -- Montant en dur pour le mois -5
UNION ALL
SELECT MONTHNAME(ADDDATE(CURRENT_DATE, INTERVAL -4 MONTH)) AS orderMonth,
       1200.00 -- Montant en dur pour le mois -4
UNION ALL
SELECT MONTHNAME(ADDDATE(CURRENT_DATE, INTERVAL -3 MONTH)) AS orderMonth,
       1100.00 -- Montant en dur pour le mois -3
UNION ALL
SELECT MONTHNAME(ADDDATE(CURRENT_DATE, INTERVAL -2 MONTH)) AS orderMonth,
       1500.00 -- Montant en dur pour le mois -2
UNION ALL
SELECT MONTHNAME(ADDDATE(CURRENT_DATE, INTERVAL -1 MONTH)) AS orderMonth,
       1300.00 -- Montant en dur pour le mois -1
UNION ALL
SELECT MONTHNAME(co.orderDate) AS orderMonth,
       SUM(os.totalPrice)      AS monthlyRevenue
FROM VIEW_ORDER_SUMMARY os
         JOIN CLIENT_ORDER co ON os.orderId = co.orderId
WHERE co.orderDate >= DATE_FORMAT(NOW(), '%Y-%m-01')
  AND co.orderDate < DATE_FORMAT(NOW() + INTERVAL 1 MONTH, '%Y-%m-01')
GROUP BY MONTHNAME(co.orderDate);
