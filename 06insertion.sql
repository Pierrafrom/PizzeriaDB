INSERT INTO ADDRESS (street, addressNumber, postalCode, city, countryCode, latitude, longitude)
VALUES ('Chem. de Bellevue', 7, '91190', 'Gif-sur-Yvette', 'FR', 48.695852, 2.120649),            -- 1
       ('Rue du 8 Mai 1945', 32, '91190', 'Gif-sur-Yvette', 'FR', 48.697835, 2.120216),           -- 2
       ('Rue de la Ferme', 1, '91190', 'Gif-sur-Yvette', 'FR', 48.694865, 2.119341),              -- 3
       ('Av. Albert', 9, '78470', 'Saint-Rémy-lès-Chevreuse', 'FR', 48.706498, 2.067292),         -- 4
       ('All. du Verger', 3, '91400', 'Gometz-la-Ville', 'FR', 48.627482, 2.160893),              -- 5
       ('Rue des Peupliers', 15, '78180', 'Montigny-le-Bretonneux', 'FR', 48.773615, 2.030547),   -- 6
       ('Av. des Chênes', 22, '78000', 'Versailles', 'FR', 48.797263, 2.130823),                  -- 7
       ('Rue de la Mairie', 8, '78990', 'Élancourt', 'FR', 48.757672, 1.956935),                  -- 8
       ('Boulevard Descartes', 12, '78180', 'Montigny-le-Bretonneux', 'FR', 48.780417, 2.041967), -- 9
       ('Rue de la République', 5, '91220', 'Brétigny-sur-Orge', 'FR', 48.604579, 2.310636),      -- 10
       ('Av. du Général Leclerc', 18, '91190', 'Gif-sur-Yvette', 'FR', 48.695322, 2.118908),      -- 11
       ('Rue de la Division Leclerc', 7, '78460', 'Chevreuse', 'FR', 48.707166, 2.040801),        -- 12
       ('Rue Victor Hugo', 2, '91120', 'Palaiseau', 'FR', 48.714239, 2.254248),                   -- 13
			 ('Main Street', 123, '12345', 'Springfield', 'US', 40.7128, -74.0060),                     -- 14
       ('Second Street', 456, '23456', 'Shelbyville', 'US', 41.8781, -87.6298),                   -- 15
       ('Third Avenue', 789, '34567', 'Ogdenville', 'US', 34.0522, -118.2437),                    -- 16
       ('Fourth Blvd', 101, '45678', 'North Haverbrook', 'US', 37.7749, -122.4194),               -- 17
       ('Fifth Lane', 202, '56789', 'Capital City', 'US', 39.9526, -75.1652);                     -- 18

INSERT INTO INGREDIENT (ingredientName,
                        ingredientDescription,
                        ingredientQuantity,
                        isAllergen,
                        unit)
VALUES ('Tomato sauce', 'Used as a base for various pizzas', 5000, FALSE, 'ML'),              -- 1
       ('Garlic', 'Aromatic seasoning', 500, FALSE, 'G'),                                     -- 2
       ('Oregano', 'Common pizza seasoning', 200, FALSE, 'G'),                                -- 3
       ('Olive oil', 'Used for flavoring and garnishing', 2000, FALSE, 'ML'),                 -- 4
       ('Mozzarella', 'A type of cheese commonly used on pizzas', 10000, TRUE, 'G'),          -- 5
       ('Fresh basil', 'Aromatic herb for flavor', 300, FALSE, 'G'),                          -- 6
       ('Pepperoni', 'Spicy salami used as a topping', 5000, TRUE, 'G'),                      -- 7
       ('Gorgonzola', 'A variety of blue cheese', 2000, TRUE, 'G'),                           -- 8
       ('Parmesan', 'Hard, granular cheese used for garnishing', 2000, TRUE, 'G'),            -- 9
       ('Goat cheese', 'Cheese made from goat\'s milk', 1500, TRUE, 'G'),                     -- 10
       ('Ham', 'Cured meat used as a topping', 5000, TRUE, 'G'),                              -- 11
       ('Pineapple', 'Fruit used as a topping on some pizzas', 3000, FALSE, 'G'),             -- 12
       ('Red peppers', 'Vegetable used for spicy flavoring', 1000, FALSE, 'G'),               -- 13
       ('Mushrooms', 'Fungi used as a common pizza topping', 2000, FALSE, 'G'),               -- 14
       ('Bell peppers', 'Mild flavored vegetable used as topping', 1000, FALSE, 'G'),         -- 15
       ('Onions', 'Vegetable used for flavoring', 1000, FALSE, 'G'),                          -- 16
       ('Black olives', 'Fruit used as a topping', 1000, FALSE, 'G'),                         -- 17
       ('Tomatoes', 'Fruit used as a topping or base', 2000, FALSE, 'G'),                     -- 18
       ('Parma ham', 'Dry-cured ham from the Parma region', 3000, TRUE, 'G'),                 -- 19
       ('Artichokes', 'Vegetable used as a topping', 1000, FALSE, 'G'),                       -- 20
       ('Tequila', 'Cocktail with tequila, lime juice, and ginger beer', 10000, FALSE, 'ML'), -- 21
       ('Vodka', 'Pure and crystalline vodka, for timeless elegance.', 10000, FALSE, 'ML'),   -- 22
       ('Grenadine', 'Vibrant grenadine syrup, bursting with flavor.', 5000, FALSE, 'ML'),    -- 23
       ('Orange juice', 'Refreshing orange juice, packed with zest', 10000, FALSE, 'ML'),     -- 24
       ('Ginger beer', 'Spicy ginger beer with a kick', 5000, FALSE, 'ML'),                   -- 25
       ('Tonic', 'Tonic with quinine', 5000, FALSE, 'ML'),                                    -- 26
       ('Gin', 'Original Gin', 10000, TRUE, 'ML'),                                            -- 27
       ('Lemon', 'Yellow lemon', 500, TRUE, 'G'),                                             -- 28
       ('Lime', 'Green lemon', 500, TRUE, 'G'),                                               -- 29
       ('Ladyfingers', 'Ladyfingers biscuits', 10000, FALSE, 'G'),                            -- 30
       ('Mascarpone cheese', 'Creamy Mascarpone cheese', 10000, TRUE, 'G'),                   -- 31
       ('Coffee', 'Coffee', 10000, FALSE, 'G'),                                               -- 32
       ('Panna cotta', 'Panna cotta', 10000, FALSE, 'G'),                                     -- 33
       ('Red berries', 'Fresh red berries', 5000, FALSE, 'G'),                                -- 34
       ('Mango', 'Mango jelly', 5000, FALSE, 'G'),                                            -- 35
       ('Banana', 'Banana', 5000, FALSE, 'G'),                                                -- 36
       ('Apple', 'Apple', 5000, FALSE, 'G'),                                                  -- 37
       ('Orange', 'Orange', 5000, FALSE, 'G'),                                                -- 38
       ('Cherry', 'Cherry', 5000, FALSE, 'G');                                                -- 39

INSERT INTO PIZZA (pizzaName, pizzaPrice, spotlight)
VALUES ('Marinara', 9.99, FALSE),
       ('Margherita', 10.99, TRUE),
       ('Pepperoni', 12.99, TRUE),
       ('Quattro Formaggi (Four Cheese)', 13.99, TRUE),
       ('Hawaiian', 13.99, FALSE),
       ('Diavola', 13.99, FALSE),
       ('Vegetarian', 14.99, FALSE),
       ('Calzone', 14.99, FALSE),
       ('Prosciutto e Funghi', 14.99, TRUE),
       ('Quattro Stagioni (Four Seasons)', 15.99, FALSE);

INSERT INTO PIZZA_INGREDIENT (pizzaId, ingredientId, quantity)
VALUES
    -- Marinara
    (1, 1, 150),  -- Tomato sauce
    (1, 2, 5),    -- Garlic
    (1, 3, 3),    -- Oregano
    (1, 4, 10),   -- Olive oil
    -- Margherita
    (2, 1, 150),  -- Tomato sauce
    (2, 5, 100),  -- Mozzarella
    (2, 6, 10),   -- Fresh basil
    (2, 4, 10),   -- Olive oil
    -- Pepperoni
    (3, 1, 150),  -- Tomato sauce
    (3, 5, 100),  -- Mozzarella
    (3, 7, 50),   -- Pepperoni
    -- Quattro Formaggi (Four Cheese)
    (4, 5, 75),   -- Mozzarella
    (4, 8, 50),   -- Gorgonzola
    (4, 9, 50),   -- Parmesan
    (4, 10, 50),-- Goat cheese
    -- Hawaiian
    (5, 1, 150),  -- Tomato sauce
    (5, 5, 100),  -- Mozzarella
    (5, 11, 70),  -- Ham
    (5, 12, 60),  -- Pineapple
    -- Diavola
    (6, 1, 150),  -- Tomato sauce
    (6, 5, 100),  -- Mozzarella
    (6, 7, 50),   -- Pepperoni
    (6, 13, 30),  -- Red peppers
    -- Vegetarian
    (7, 1, 150),  -- Tomato sauce
    (7, 5, 100),  -- Mozzarella
    (7, 14, 50),  -- Mushrooms
    (7, 15, 30),  -- Bell peppers
    (7, 16, 30),  -- Onions
    (7, 17, 30),  -- Black olives
    (7, 18, 40),  -- Tomatoes
    -- Calzone (Note: Quantities may be doubled if it's larger than a regular pizza)
    (8, 1, 150),  -- Tomato sauce
    (8, 5, 200),  -- Mozzarella
    (8, 11, 70),  -- Ham
    (8, 14, 50),  -- Mushrooms
    -- Prosciutto e Funghi
    (9, 1, 150),  -- Tomato sauce
    (9, 5, 100),  -- Mozzarella
    (9, 19, 70),  -- Parma ham
    (9, 14, 50),  -- Mushrooms
    -- Quattro Stagioni (Four Seasons)
    (10, 1, 150), -- Tomato sauce
    (10, 5, 100), -- Mozzarella
    (10, 11, 50), -- Ham
    (10, 20, 30), -- Artichokes
    (10, 17, 30), -- Black olives
    (10, 14, 50);-- Mushrooms

INSERT INTO WINE (wineName,
                  glassPrice,
                  bottlePrice,
                  domain,
                  grapeVariety,
                  origin,
                  alcoholPercentage,
                  year,
                  color,
                  spotlight,
                  stock,
                  bottleType)
VALUES ('Nero d\'Avola', 7.0, 40.0, 'Nero d\'Avola', 'amira', 'Italia', 13.0, 2020, 'RED', FALSE, 100, 'BOTTLE'), -- 1
       ('Borgo SanLeo', 5.0, 28.0, 'Borgo SanLeo', 'chianti', 'Italia', 12.5, 2019, 'RED', FALSE, 100,
        'BOTTLE'),                                                                                                -- 2
       ('Montecampo', 6.0, 30.0, 'Montecampo', 'Nebbiolo', 'Italia', 13.5, 2018, 'RED', FALSE, 100,
        'BOTTLE'),                                                                                                -- 3
       ('Sancerre', 8.0, 45.0, 'Lagache', 'Sauvignon', 'France', 12.0, 2016, 'WHITE', FALSE, 100, 'BOTTLE'),      -- 4
       ('Sicilia', 6.0, 35.0, 'Don Corleone', 'Pettruzio', 'Italia', 11.5, 2019, 'WHITE', TRUE, 100,
        'BOTTLE'),                                                                                                -- 5
       ('Gamay', 5.0, 32.0, 'Domaine Henry', 'Gamay', 'France', 12.8, 2021, 'RED', FALSE, 100, 'BOTTLE'),         -- 6
       ('Chinon', 7.0, 38.0, 'Domaine de la blanche', 'Malbec', 'France', 13.2, 2018, 'RED', TRUE, 100,
        'BOTTLE'),                                                                                                -- 7
       ('Cote du Rhone', 6.0, 33.0, 'Chapoutier', 'pinot noir', 'France', 14.0, 2019, 'RED', FALSE, 100,
        'BOTTLE'),                                                                                                -- 8
       ('Cahors', 5.0, 31.0, 'Duc de Cahors', 'Madiran', 'France', 13.0, 2020, 'RED', FALSE, 100, 'BOTTLE');
-- 9

INSERT INTO SODA (sodaName, price, stock, bottleType, spotlight)
VALUES ('Coca Cola', 4.0, 100, 'CAN', FALSE),          -- 1
       ('Limonade Sicilia', 4.0, 100, 'CAN', FALSE),   -- 2
       ('Limonade Aranciata', 4.0, 100, 'CAN', FALSE), -- 3
       ('Coca Cola Zero', 4.0, 100, 'CAN', FALSE),     -- 4
       ('Lipton Ice Tea', 4.0, 100, 'CAN', FALSE);
-- 5

INSERT INTO COCKTAIL (cocktailName, price, alcoholPercentage, spotlight)
VALUES ('Mexico Mule', 9.0, 16, FALSE),      -- 1
       ('Gin tonic', 11.0, 17, FALSE),       -- 2
       ('Tequila Sunrise', 10.0, 18, FALSE), -- 3
       ('Moscow mule', 8.0, 19, FALSE);
-- 4

INSERT INTO COCKTAIL_INGREDIENT (cocktailId, ingredientId, quantity)
VALUES (1, 27, 50), -- Mexico Mule
       (1, 25, 150),
       (1, 29, 50),
       (2, 27, 50), -- Gin tonic
       (2, 26, 100),
       (3, 21, 50), -- Tequila Sunrise
       (3, 23, 30),
       (3, 24, 120),
       (4, 22, 50), -- Moscow Mule
       (4, 25, 150),
       (4, 28, 20);

INSERT INTO `DESSERT` (`dessertName`, `dessertPrice`, `spotlight`)
VALUES ('Panna cotta with red berries', 10.0, FALSE), -- 1
       ('Panna cotta with mango', 10.0, FALSE),       -- 2
       ('Fruit Salad', 10.0, FALSE),                  -- 3
       ('Tiramisu', 10.0, FALSE); -- 4

INSERT INTO `DESSERT_INGREDIENT` (`dessertId`, `ingredientId`, `quantity`)
VALUES (1, 34, 300), -- Panna cotta with red berries
       (1, 35, 150),
       (2, 35, 300), -- Panna cotta with mango
       (2, 36, 150),
       (3, 37, 100), -- Fruit Salad
       (3, 38, 100),
       (3, 39, 100),
       (4, 32, 200), -- Tiramisu
       (4, 33, 200),
       (4, 34, 200);

INSERT INTO EMPLOYEE (employeePosition, employeeFirstName, employeeLastName, employeeEmail, employeePassword,
                      employeePhone, addressId)
VALUES ('DELIVERY_PERSON', 'Vito', 'Corleone', 'vito.corleone@email.com', '$2y$10$t9Uzz/8ZElYpGVplhEVT6uJ5tk75C7QdKRO5XyFWeAb7NyDv2wGVq', '+33775550681', 1),
       ('DELIVERY_PERSON', 'Michael', 'Corleone', 'michael.corleone@email.com', '$2y$10$DMOB3vO7q5mCbLxLQAH4Ju8ozMCQ/.h8sR1o9M676nm2pUO3Ztgy6', '+33655504415', 2),
       ('DELIVERY_PERSON', 'Santino', 'Corleone', 'santino.corleone@email.com', '$2y$10$.5N52uOGUVu8VRdV5zRht.Wg/IbtW2MsN4y.qSmR0gTQT7UzaCoIG', '+33775550306', 3),
       ('DELIVERY_PERSON', 'Tom', 'Hagen', 'tom.hagen@email.com', '$2y$10$j9AooWmrxpAMiQZz4cYsyOhjFv0jRTgLdUAbFTLekhr4Y0id/Qh.a', '+33700555917', 4),
       ('DELIVERY_PERSON', 'Fredo', 'Corleone', 'fredo.corleone@email.com', '$2y$10$vDol.blnFNAxVTNBjhXETe2vQum.BAXP.WFuwQUOFKqb9ZSOCNXee', '+33700555620', 5),
       ('DELIVERY_PERSON', 'Clemenza', 'Peter', 'clemenza.peter@email.com', '$2y$10$Y.s7wCVyTfywvHz7pOllaOKL0U8eny9Yoty2krLI.65oYjs3.vWom', '+33655510178', 6),
       ('DELIVERY_PERSON', 'Tessio', 'Salvatore', 'tessio.salvatore@email.com', '$2y$10$LbfjF4fA/UPRrLUu3To1durOwjtMESagNH.NnGioaecedBXSg.CNO', '+33700555130', 7),
       ('DELIVERY_PERSON', 'Luca', 'Brasi', 'luca.brasi@email.com', '$2y$10$qJhABnd.BZMdcedVa17J8.d6i38NzH/7aREh6ZozEYMO/A8FxC4YG', '+33700555721', 8),
       ('DELIVERY_PERSON', 'Carlo', 'Rizzi', 'carlo.rizzi@email.com', '$2y$10$xjyHDgGqMhwleLNFiOtwDu5ZN7D8a9Lfk9IQUMViFu1r7WdE250xW', '+33755551750', 9),
       ('DELIVERY_PERSON', 'Johnny', 'Fontane', 'johnny.fontane@email.com', '$2y$10$1yW3fYPoTRyVtShsBfHw7.ue22uu7FGwZ13.811nb/o0oxqkzRbQ2', '+33700555611', 10),
       ('PIZZA_MAKER', 'Emilio', 'Barzini', 'emilio.barzini@email.com', '$2y$10$RlSJnlDHZyUZoMiMiDg6eeAZYKG.VNYfSmgjL/xAOfmlncyDEv0Ge', '+33745555755', 11),
       ('PIZZA_MAKER', 'Ottilio', 'Cuneo', 'ottilio.cuneo@email.com', '$2y$10$Xd24ZxX45oSWIr3v9kvqQeqI1MIsAxXSGij6aYuNX/N2ZLAthDPsG', '+33735558128', 12),
       ('PIZZA_MAKER', 'Philip', 'Tattaglia', 'philip.tattaglia@email.com', '$2y$10$0AZDE2h9ntNyYL03xyUaWuiROloqct9jtB8L1qgn5U9oevWs0PR6W', '+33755553689', 13);

INSERT INTO CLIENT (clientFirstName, clientLastName, clientPhone, clientPassword, clientEmail)
VALUES ('John', 'Doe', '+33700555564', '$2y$10$YTuQBhpoBrFwSc/Kvlo7WO0xz9WC/RYX0VyXDZavlXZyMtz4AtPN.', 'johndoe@email.com'),
       ('Sanji', 'Vinsmoke', '+33655586801', '$2y$10$YE6cLkFvItuUcFmqlpOl0eRsAdBogPCbTjYr64A5nhXvo6i9HlhY.', 'sanjivinsmoke@one-piece.com'),
       ('Alice', 'Johnson', '+33700555292', '$2y$10$XNOcl1bOJ4bqoab8ui8QOuH9PELONujTbx2lGvqt8BgCdoMyZ6wA2', 'alicejohnson@email.com'),
       ('Charlie', 'Davis', '+33775550167', '$2y$10$MIEkqkALYJwhDC9t6X7IK.uDK2bCU4MR15pnItgRmAz09T2JpSGWO', 'charliedavis@email.com'),
       ('Eikichi', 'Onizuka', '+33695698324', '$2y$10$BSOGRlqzU2CQbw1ESDUX0OJ1/UmjfZJpRvFuFnPWLFD9/Cr.ozvmC', 'greatteacher@gtomail.com');


INSERT INTO CLIENT (clientFirstName, clientLastName, clientPhone)
VALUES ('Bob', 'Brown', '+33700555658'),
	     ('Alice', 'Johnson', '+33665948547'),
       ('Charlie', 'Smith', '+33784576123'),
       ('Eva', 'Martinez', '+33659847212'),
       ('David', 'White', '+33715266147'),
       ('Sophie', 'Lee', '+33632564585'),
       ('Luffy', 'Monkey D', '+33748541232');

INSERT INTO CLIENT_ORDER (orderDate, addressId, clientId) VALUES
    (CURDATE(), 1, 1),
    (CURDATE(), 18, 5),
    (CURDATE(), 15, 10),
    (CURDATE(), 14, 1),
    (CURDATE(), 15, 2),
    (CURDATE() - INTERVAL 1 DAY, 16, 3),
    (CURDATE() - INTERVAL 1 DAY, 17, 4),
    (CURDATE() - INTERVAL 1 DAY, 18, 5),
    (CURDATE() - INTERVAL 1 DAY, 11, 6),
    (CURDATE() - INTERVAL 1 DAY, 12, 7),
    (CURDATE() - INTERVAL 1 DAY, 13, 8),
    (CURDATE() - INTERVAL 1 WEEK, 14, 9),
    (CURDATE() - INTERVAL 1 WEEK, 16, 11),
    (CURDATE() - INTERVAL 1 WEEK, 17, 12),
    (CURDATE() - INTERVAL 1 WEEK, 18, 3),
    (CURDATE() - INTERVAL 1 WEEK, 5, 4),
    (CURDATE() - INTERVAL 1 WEEK, 2, 2);

INSERT INTO ORDER_PIZZA (pizzaId, orderId, pizzaQuantity)
VALUES (1, 1, 2),
       (2, 2, 3),
       (3, 3, 1),
       (4, 4, 2),
       (5, 5, 3),
       (6, 6, 2),
       (7, 7, 1),
       (8, 8, 3),
       (9, 9, 2),
       (10, 10, 1),
       (6, 11, 2),
       (7, 12, 1),
       (8, 13, 3),
       (9, 14, 2),
       (10, 15, 1);

INSERT INTO ORDER_DESSERT (dessertId, orderId, dessertQuantity)
VALUES (1, 1, 1),
       (2, 2, 2),
       (3, 3, 1),
       (4, 4, 1),
       (4, 5, 2),
       (1, 6, 2),
       (2, 7, 1),
       (3, 8, 3),
       (4, 9, 2),
       (1, 10, 1),
       (1, 11, 2),
       (2, 12, 1),
       (3, 13, 3),
       (4, 14, 2),
       (1, 15, 1);

INSERT INTO ORDER_WINE (wineId, orderId, wineQuantity)
VALUES (1, 1, 1),
       (2, 2, 2),
       (3, 3, 1),
       (4, 4, 1),
       (5, 5, 2),
       (1, 6, 1),
       (2, 7, 2),
       (3, 8, 1),
       (4, 9, 2),
       (5, 10, 1),
       (1, 11, 1),
       (2, 12, 2),
       (3, 13, 1),
       (4, 14, 2),
       (5, 15, 1);

INSERT INTO ORDER_SODA (sodaId, orderId, sodaQuantity)
VALUES (1, 1, 1),
       (2, 2, 2),
       (3, 3, 1),
       (4, 4, 1),
       (5, 5, 2),
       (1, 6, 2),
       (2, 7, 1),
       (3, 8, 3),
       (4, 9, 2),
       (5, 10, 1),
       (1, 11, 2),
       (2, 12, 1),
       (3, 13, 3),
       (4, 14, 2),
       (5, 15, 1);

INSERT INTO ORDER_COCKTAIL (cocktailId, orderId, cocktailQuantity)
VALUES (1, 1, 1),
       (2, 2, 2),
       (3, 3, 1),
       (4, 4, 1),
       (4, 5, 2),
       (1, 6, 1),
       (2, 7, 2),
       (3, 8, 1),
       (4, 9, 2),
       (1, 10, 1),
       (1, 11, 1),
       (2, 12, 2),
       (3, 13, 1),
       (4, 14, 2),
       (1, 15, 1);

-- Insert data into PIZZA_CUSTOM
INSERT INTO PIZZA_CUSTOM (originalPizza)
VALUES (2),  -- Margherita
       (4); -- Quattro Formaggi

-- Insert data into PIZZA_CUSTOM_INGREDIENT
INSERT INTO PIZZA_CUSTOM_INGREDIENT (pizzaCustomId, ingredientAddedId, quantityAdded, ingredientRemovedId, quantityRemoved)
VALUES
    (1, 7, 50, 5, 100),   -- Customizing Margherita: Add Pepperoni (50g), Remove Mozzarella (100g)
    (2, 8, 30, 10, 50);  -- Customizing Quattro Formaggi: Add Gorgonzola (30g), Remove Mozzarella (50g)


INSERT INTO ORDER_PIZZA_CUSTOM (pizzaCustomId, orderId, pizzaQuantity) VALUES (1, 1, 2);
INSERT INTO ORDER_PIZZA_CUSTOM (pizzaCustomId, orderId, pizzaQuantity) VALUES (2, 2, 3);