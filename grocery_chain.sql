CREATE TABLE grocery_chain
(
groceryID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
storeAddress VARCHAR,
FOREIGN KEY (storeAddress) REFERENCES store(storeAddress)
);
CREATE TABLE delivery_routes
(
routeID INTEGER PRIMARY KEY NOT NULL,
days TEXT,
startTime TIME,
endTime TIME,
maxSpace INTEGER
);
CREATE TABLE store
(
storeAddress VARCHAR PRIMARY KEY NOT NULL,
routeID INTEGER NOT NULL,
FOREIGN KEY (routeID) REFERENCES delivery_routes(routeID)
);
CREATE TABLE postal_areas
(
postalCode VARCHAR(5) PRIMARY KEY NOT NULL,
routeID INTEGER NOT NULL,
FOREIGN KEY (routeID) REFERENCES delivery_routes(routeID)
);
CREATE TABLE customer
(
customerID PRIMARY KEY NOT NULL,
customerName TEXT,
postalCode VARCHAR(5),
FOREIGN KEY (postalCode) REFERENCES postal_areas(postalCode)
);
CREATE TABLE order_data
(
orderID VARCHAR(10) PRIMARY KEY NOT NULL,
boxNumber INTEGER,
allowSubstitution BOOLEAN,
customerID INTEGER,
FOREIGN KEY (customerID) REFERENCES customer(customerID)
);
CREATE TABLE collector
(
collectorName TEXT PRIMARY KEY NOT NULL,
workDays TEXT,
workStart TIME,
workEnd TIME ,
maxNorders INTEGER
);
CREATE TABLE collector_order_list
(
ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
collectorName TEXT,
orderID VARCHAR(10),
FOREIGN KEY (orderID) REFERENCES order_data(orderID),
FOREIGN KEY (collectorName) REFERENCES collector(collectorName)
);
CREATE TABLE orders_database
(
ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
orderID VARCHAR(10),
orderDate DATETIME,
FOREIGN KEY (orderID) REFERENCES order_data(orderID)
);
CREATE TABLE basket
(
ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
orderID VARCHAR(10),
productName VARCHAR,
status TEXT,
FOREIGN KEY (orderID) REFERENCES order_data(orderID),
FOREIGN KEY (productName) REFERENCES product(productName)
);
CREATE TABLE product
(
productName VARCHAR PRIMARY KEY NOT NULL,
productQuantity INTEGER,
units TINYTEXT,
availability BOOLEAN,
storageCond VARCHAR,
dietID INTEGER,
FOREIGN KEY (storageCond) REFERENCES package_type(storageCond),
FOREIGN KEY (dietID) REFERENCES special_diet(dietID)
);

CREATE TABLE substitution
(
SubID INTEGER NOT NULL,
substitutionName VARCHAR NOT NULL,
productName VARCHAR,
FOREIGN KEY (productName) REFERENCES product(productName),
PRIMARY KEY (SubID, substitutionName)
);

CREATE TABLE product_price
(
ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
productPrice INTEGER,
validityPeriodStart DATE,
validityPeriodEnd DATE,
productName VARCHAR,
FOREIGN KEY (productName) REFERENCES product(productName)
);
CREATE TABLE package_type
(
storageCond VARCHAR PRIMARY KEY  NOT NULL,
packageType VARCHAR
);
CREATE TABLE store_assortment
(
ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
storeAddress VARCHAR,
productName VARCHAR,
FOREIGN KEY (storeAddress) REFERENCES store(storeAddress)
FOREIGN KEY (productName) REFERENCES product(productName)
);
CREATE TABLE nutritional_components
(
ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
energy INTEGER,
energy_unit TINYTEXT,
fat INTEGER,
carbohydrates INTEGER,
proteins INTEGER,
others_unit TINYTEXT,
productName VARCHAR,
FOREIGN KEY (productName) REFERENCES product(productName)
);
CREATE TABLE recipe_list
(
recipeName TINYTEXT PRIMARY KEY NOT NULL,
recipeInstuctions VARCHAR,
dietID INTEGER,
FOREIGN KEY (dietID) REFERENCES special_diet(dietID)
);
CREATE TABLE special_diet
(
dietID INTEGER PRIMARY KEY NOT NULL,
dietName TINYTEXT
);
CREATE TABLE ingredients
(
ingredientName TINYTEXT PRIMARY KEY NOT NULL,
ingredientUnits TINYTEXT,
ingredientQuantity INTEGER,
recipeName TINYTEXT,
FOREIGN KEY (recipeName) REFERENCES recipe_list(recipeName)
);
CREATE TABLE ratio 
(
productName VARCHAR, 
productAmount INTEGER,
FOREIGN KEY (productName) REFERENCES product(productName)
);
CREATE TABLE ordering 
(
rawName VARCHAR, 
sequenceID INTEGER,
FOREIGN KEY (rawName) REFERENCES raw_material(rawName)
);
CREATE TABLE raw_material
(
rawName TEXT PRIMARY KEY NOT NULL,
rawUnits TINYTEXT,
productName VARCHAR,
FOREIGN KEY (productName) REFERENCES product(productName)
);

--- INSERTIONS

INSERT INTO collector
VALUES  ('Alisher', 'Monday, Wednesday, Friday', '09:00:00', '16:00:00', 10),
        ('Dias', 'Monday, Friday, Saturday, Sunday', '08:00:00', '22:00:00', 15),
        ('Sanzhar', 'Monday, Tuesday, Thursday', '12:00:00', '14:00:00', 2);
    
INSERT INTO delivery_routes 
VALUES (550, 'Monday, Wednesday, Friday', '10:00', '14:00', 15),
        (555, 'Monday, Tuesday, Wednesday', '14:00', '18:00', 20),
        (510, 'Tuesday, Thursday, Saturday', '16:00', '20:00', 14);

INSERT INTO store 
VALUES  ('Jamerantaival 11A', 510),
        ('Jamerantaival 11B', 555),
        ('Jamerantaival 11C', 550);

INSERT INTO grocery_chain (storeAddress)
VALUES  ('Jamerantaival 11A'),
        ('Jamerantaival 11B'),
        ('Jamerantaival 11C');

INSERT INTO postal_areas
VALUES  ('02150', 555),
        ('02700', 510),
        ('00370', 550);
        
INSERT INTO customer
VALUES  (791678, 'Nikolai', '02150'),
        (786667, 'Peter', '00370'),
        (791649, 'Robin', '02700');

INSERT INTO order_data
VALUES  ('OID69686', 2, FALSE, 786667),
        ('OID76921', 3, FALSE, 786667),
        ('OID56604', 1, TRUE, 791678);
        
INSERT INTO orders_database (orderID, orderDate)
VALUES  ('OID76921', '2018-08-30 18:47'),
        ('OID69686', '2019-10-11 12:58'),
        ('OID56604', '2021-01-01 08:25');
        
UPDATE orders_database
SET orderDate = '2020-12-29 08:25'
WHERE orderID = 'OID56604';
        
INSERT INTO collector_order_list (collectorName, orderID)
VALUES  ('Dias', 'OID69686'),
        ('Sanzhar', 'OID56604'),
        ('Dias', 'OID76921');
        
INSERT INTO special_diet -- do suda
VALUES  (1, 'Keto'),
        (2, 'Paleo'),
        (3, 'Low-Carb');
        
INSERT INTO package_type
VALUES  ('Normal', 'Plastic bag'),
        ('Refrigerator', 'plastic bottle'),
        ('Fridge', 'Plastic container');
        
INSERT INTO recipe_list
VALUES  ('Chicken', 'Cook it!', 2),
        ('Zoodles', ' Combine zuccini and noodles!', 1),
        ('Eggs and vegetables', 'Fry in butter or coconut oil!', 3);
        
        
INSERT INTO product
VALUES  ('Chicken', 5, 'kg', FALSE, 'Fridge', 2),
        ('Egg', 12, 'pcs', FALSE, 'Fridge', 3),
        ('Bread', 20, 'pcs', TRUE, 'Normal', 3),
        ('Milk', 8, 'pcs', TRUE, 'Fridge', 1),
        ('Water', 1, 'pcs', TRUE, 'Normal', 1);
        
INSERT INTO substitution 
VALUES  (1, 'Fish', 'Chicken'),
        (2, 'Turkey', 'Chicken'),
        (3, 'Meat', 'Chicken'),
        (4, 'Water', 'Milk');

INSERT INTO substitution 
VALUES 
        (5, 'Pita bread', 'Bread');
        
INSERT INTO store_assortment (storeAddress, productName)
VALUES  ('Jamerantaival 11A', 'Chicken'),
        ('Jamerantaival 11B', 'Chicken'),
        ('Jamerantaival 11A', 'Milk'),
        ('Jamerantaival 11C', 'Egg');

INSERT INTO raw_material
VALUES  ('Flour', 'kg', 'Bread'),
        ('Yeast', 'kg', 'Bread'),
        ('Water', 'kg', 'Milk');

INSERT INTO ratio
VALUES  ('Milk', 1),
        ('Egg', 3),
        ('Chicken', 4);
        
INSERT INTO product_price (productPrice, validityPeriodStart, validityPeriodEnd, productName)
VALUES  (10, '2019-07-09', '2019-09-01', 'Chicken'),
        (15, '2020-02-01', '2020-12-30', 'Bread'),
        (5, '2019-10-01', '2019-10-10', 'Milk');

INSERT INTO product_price (productPrice, validityPeriodStart, validityPeriodEnd, productName)
VALUES  (7.5, '2019-07-09', '2020-12-30', 'Chicken'),
        (2.4, '2019-10-01', '2020-12-30', 'Milk');

INSERT INTO ordering
VALUES  ('Flour', 1),
        ('Yeast', 2),
        ('Water', 3);
        
INSERT INTO ingredients
VALUES  ('Salt', 'tbsp', 2, 'Zoodles'),
        ('Pepper', 'tbsp', 1, 'Chicken'),
        ('Noodles', 'kg', 1, 'Zoodles');

INSERT INTO nutritional_components (energy, energy_unit, fat, carbohydrates, proteins, others_unit, ProductName)
VALUES  (100, 'kJ', 20, 80, 63, 'per 100g', 'Chicken'),
        (300, 'kJ', 120, 100, 63, 'per 100g', 'Bread'),
        (80, 'kJ', 15, 64, 82, 'per 100g', 'Milk');
        
INSERT INTO basket (orderID, productName, status)
VALUES  ('OID69686', 'Milk', 'Collected'),
        ('OID56604', 'Bread', 'Delivered'),
        ('OID76921', 'Chicken', 'Not delivered'),
        ('OID69686', 'Bread', 'Not collected');
        
INSERT INTO basket (orderID, productName, status)
VALUES  ('OID56604', 'Chicken', 'Delivered'),
        ('OID56604', 'Milk', 'Delivered'),
        ('OID56604', 'Milk', 'Not delivered');



--- INDEXES

CREATE UNIQUE INDEX product_price_index ON product_price (
    productPrice
);
CREATE UNIQUE INDEX product_index ON product (
    productName
);
CREATE UNIQUE INDEX collector_index ON collector (
    collectorName
);
CREATE UNIQUE INDEX postal_codes_index ON customer (
    postalCode
);

--- VIEWS
CREATE VIEW product_and_price AS 
SELECT product.productName, product_price.productPrice 
FROM product 
JOIN product_price
ON product.productName == product_price.productName;

CREATE VIEW recipe_and_diet AS 
SELECT recipe_list.recipeName, special_diet.dietName FROM recipe_list 
JOIN special_diet
ON recipe_list.dietID == special_diet.dietID;


--- USE CASES

--- Search for recipes or products that are suitable for the chosen special diet

SELECT productName
FROM product
JOIN special_diet
ON special_diet.dietID = product.dietID 
WHERE special_diet.dietName = 'Low-Carb';

--- Retrieve information on old orders already shipped

SELECT orderID
FROM order_data
JOIN orders_database
ON order_data.orderID == orders_database.orderID
WHERE order_data.customerID = '786667'
AND orders_database.orderDate LIKE '2018-08-30%';

--- Make a list for the collector with the products included in the order, their quantities and information on the storage temperature of each product

SELECT productName, productQuantity, product.units, storageCond
FROM product
JOIN basket, order_data, orders_database
ON product.productName == basket.productName
AND basket.orderID = order_data.orderID
AND order_data.orderID = orders_database.orderID
WHERE order_data.customerID= '786667'
AND orders_database.orderDate LIKE '2018-08-30%';

--- Investigate which products in the order have already been collected and what still needs to be collected

SELECT productName, status
FROM basket
WHERE basket.orderID = 'OID69686'
AND basket.status = 'Collected' OR basket.status = 'Not collected' ;

--- Calculate the total price of the order, taking into account possible product replacements, discounts, and products not delivered at all

SELECT SUM(productPrice) 
FROM product_price
JOIN product, basket, orders_database
ON product.productName == product_price.productName
AND product.productName == basket.productName
AND orders_database.orderID == basket.orderID
WHERE 
(product.availability IS TRUE
OR
product.productName IN
(SELECT productName
FROM product
WHERE productName IN
(
SELECT substitutionName
FROM substitution
JOIN basket, order_data
ON basket.productName = substitution.productName
WHERE basket.orderID = 'OID56604'
AND order_data.allowSubstitution = 1
)
)
)
AND basket.status = 'Delivered'
AND basket.orderID = 'OID56604'
AND orders_database.orderDate <= product_price.validityPeriodEnd;

--- Storage conditions for a specific product from specific order

SELECT basket.orderID, product.productName, product.storageCond FROM basket
JOIN
product ON basket.productName == product.productName;

--- Product information

SELECT energy, energy_unit, fat, carbohydrates, proteins, others_unit, product.productName FROM nutritional_components
JOIN
product ON product.productName == nutritional_components.productName;

--- Ingredients for the recipe

SELECT ingredientName
FROM ingredients
WHERE recipeName = 'Zoodles';

--- Make a list showing which products in the order have been replaced and with which product each of them has been replaced.

SELECT order_data.orderID, basket.productName AS 'Replaced', 
substitution.substitutionName AS 'Replaced with' 
FROM basket
JOIN substitution 
ON basket.productName == substitution.productName
JOIN order_data 
ON basket.orderID == order_data.orderID
WHERE order_data.allowSubstitution == 1
GROUP BY basket.productName;

--- Number of customers during specific period

SELECT COUNT(DISTINCT customerID)
FROM order_data
JOIN orders_database
ON orders_database.orderID = order_data.orderID
WHERE orderDate > '2019-08-30'
AND orderDate < '2020-12-29';

--- Order delivery information

SELECT order_data.orderID, collector_order_list.collectorName, 
postal_areas.postalCode, postal_areas.routeID 
FROM collector_order_list
JOIN order_data ON collector_order_list.orderID == order_data.orderID
JOIN customer ON order_data.customerID == customer.customerID
JOIN postal_areas ON customer.postalCode == postal_areas.postalCode
JOIN delivery_routes ON delivery_routes.routeID == postal_areas.routeID;

--- Product type and storage condition

SELECT product.productName, product.storageCond, package_type.packageType FROM product, package_type
ON product.storageCond == package_type.storageCond;

--- Collector - order - box number

SELECT orderID, boxNumber
FROM order_data
JOIN collector_order_list
ON collector_order_list.orderID = order_data.orderID
WHERE collectorName = 'Dias';
