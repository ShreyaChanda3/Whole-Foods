-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb_1
-- -----------------------------------------------------

 DROP DATABASE IF EXISTS mydb_1;
CREATE DATABASE mydb_1 CHARACTER SET UTF8MB4 COLLATE utf8mb4_general_ci;
USE mydb_1;

-- -----------------------------------------------------
-- Table `mydb_1`.`Warehouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_1`.`Warehouse` (
  `WarehouseID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(200) NOT NULL,
  `Address` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`WarehouseID`),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE,
  UNIQUE INDEX `Address_UNIQUE` (`Address` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb_1`.`Employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_1`.`Employee` (
  `EmployeeID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Phone` VARCHAR(45) NOT NULL,
  `Role` VARCHAR(100) NOT NULL,
  `Warehouse_WarehouseID` INT NOT NULL,
  PRIMARY KEY (`EmployeeID`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE,
  UNIQUE INDEX `Phone_UNIQUE` (`Phone` ASC) VISIBLE,
  UNIQUE INDEX `EmployeeID_UNIQUE` (`EmployeeID` ASC) VISIBLE,
  INDEX `fk_Employee_Warehouse1_idx` (`Warehouse_WarehouseID` ASC) VISIBLE,
  CONSTRAINT `fk_Employee_Warehouse1`
    FOREIGN KEY (`Warehouse_WarehouseID`)
    REFERENCES `mydb_1`.`Warehouse` (`WarehouseID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



-- -----------------------------------------------------
-- Table `mydb_1`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_1`.`Supplier` (
  `SupplierID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(100) NOT NULL,
  `PhoneNumber` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`SupplierID`),
  UNIQUE INDEX `Address_UNIQUE` (`Address` ASC) VISIBLE,
  UNIQUE INDEX `PhoneNumber_UNIQUE` (`PhoneNumber` ASC) VISIBLE,
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb_1`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_1`.`Product` (
  `ProductID` INT NOT NULL AUTO_INCREMENT,
  `ProductName` VARCHAR(100) NOT NULL,
  `WebDescription` TEXT NOT NULL,
  `Category` VARCHAR(225) NOT NULL,
  `Price` DECIMAL(10,2) NOT NULL,
  `PackagingDescription` TEXT NOT NULL,
  `Supplier_SupplierID` INT NOT NULL,
  PRIMARY KEY (`ProductID`, `Supplier_SupplierID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE `mydb_1`.`Product` ADD UNIQUE INDEX `idx_product` (`ProductID`, `Supplier_SupplierID`);

-- -----------------------------------------------------
-- Table `mydb_1`.`Inventory`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `mydb_1`.`Inventory` (
  `InventoryID` INT NOT NULL AUTO_INCREMENT,
  `Quantity` INT NOT NULL,
  `Product_ProductID` INT NOT NULL,
  `Product_Supplier_SupplierID` INT NOT NULL,
 PRIMARY KEY (`InventoryID`),
  INDEX `fk_Inventory_Product1_idx` (`Product_ProductID` ASC, `Product_Supplier_SupplierID` ASC),
  CONSTRAINT `fk_Inventory_Product1`
    FOREIGN KEY (`Product_ProductID`, `Product_Supplier_SupplierID`)
    REFERENCES `mydb_1`.`Product` (`ProductID`, `Supplier_SupplierID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
-- -----------------------------------------------------
-- Table `mydb_1`.`StoreLocation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_1`.`StoreLocation` (
  `StoreID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  `Inventory_InventoryID` INT NOT NULL,
  PRIMARY KEY (`StoreID`),
  UNIQUE INDEX `idx_address` (`Address`),
  CONSTRAINT `fk_StoreLocation_Inventory`
    FOREIGN KEY (`Inventory_InventoryID`)
    REFERENCES `mydb_1`.`Inventory` (`InventoryID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb_1`.`Product_has_StoreLocation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_1`.`Product_has_StoreLocation` (
  `Product_ProductID` INT NOT NULL,
  `StoreLocation_StoreID` INT NOT NULL,
  PRIMARY KEY (`Product_ProductID`, `StoreLocation_StoreID`),
  INDEX `fk_Product_has_StoreLocation_StoreLocation1_idx` (`StoreLocation_StoreID` ASC) VISIBLE,
  CONSTRAINT `fk_Product_has_StoreLocation_Product1`
    FOREIGN KEY (`Product_ProductID`)
    REFERENCES `mydb_1`.`Product` (`ProductID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Product_has_StoreLocation_StoreLocation1`
    FOREIGN KEY (`StoreLocation_StoreID`)
    REFERENCES `mydb_1`.`StoreLocation` (`StoreID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `mydb_1`.`StoreLocation_has_Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_1`.`StoreLocation_has_Supplier` (
  `StoreLocation_StoreID` INT NOT NULL,
  `Supplier_SupplierID` INT NOT NULL,
  PRIMARY KEY (`StoreLocation_StoreID`, `Supplier_SupplierID`),
  CONSTRAINT `fk_StoreLocation_has_Supplier_StoreLocation`
    FOREIGN KEY (`StoreLocation_StoreID`)
    REFERENCES `mydb_1`.`StoreLocation` (`StoreID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_StoreLocation_has_Supplier_Supplier`
    FOREIGN KEY (`Supplier_SupplierID`)
    REFERENCES `mydb_1`.`Supplier` (`SupplierID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- Add index to Employee table
ALTER TABLE `mydb_1`.`Employee`
ADD INDEX `idx_Employee` (`EmployeeID`, `Warehouse_WarehouseID`);

-- Add index to Inventory table
ALTER TABLE `mydb_1`.`Inventory`
ADD INDEX `idx_Inventory` (`InventoryID`, `Product_ProductID`, `Product_Supplier_SupplierID`);
-- -----------------------------------------------------
-- Table `mydb_1`.`Employee_has_Inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_1`.`Employee_has_Inventory` (
  `Employee_EmployeeID` INT NOT NULL,
  `Employee_Warehouse_WarehouseID` INT NOT NULL,
  `Inventory_InventoryID` INT NOT NULL,
  `Inventory_Product_ProductID` INT NOT NULL,
  `Inventory_Product_Supplier_SupplierID` INT NOT NULL,
  PRIMARY KEY (`Employee_EmployeeID`, `Employee_Warehouse_WarehouseID`, `Inventory_InventoryID`, `Inventory_Product_ProductID`, `Inventory_Product_Supplier_SupplierID`),
  CONSTRAINT `fk_Employee_has_Inventory_Employee`
    FOREIGN KEY (`Employee_EmployeeID`, `Employee_Warehouse_WarehouseID`)
    REFERENCES `mydb_1`.`Employee` (`EmployeeID`, `Warehouse_WarehouseID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Employee_has_Inventory_Inventory`
    FOREIGN KEY (`Inventory_InventoryID`, `Inventory_Product_ProductID`, `Inventory_Product_Supplier_SupplierID`)
    REFERENCES `mydb_1`.`Inventory` (`InventoryID`, `Product_ProductID`, `Product_Supplier_SupplierID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- --------------------------------------------------
-- Inserting values in Product Table 
-- --------------------------------------------------

INSERT INTO `mydb_1`.`Product` (`ProductID`, `ProductName`, `WebDescription`, `Category`, `Price`, `PackagingDescription`, `Supplier_SupplierID`)
 VALUES (56, 'Organic Coconut Oil', 'Premium Cold-Pressed Coconut Oil, extracted from fresh coconuts with a smooth and creamy texture. Perfect for cooking, baking, and skincare.', 'Cooking Oil', 12.99, '100% Pure Coconut Oil, made from organic coconuts. Ideal for cooking, baking, and natural beauty care.', 1),
  (22, 'Grass-Fed Beef', 'Tender and flavorful grass-fed beef sourced from local farms. Raised without antibiotics or hormones for a healthier option.', 'Meat', 19.99, 'Premium grass-fed beef, hand-selected for exceptional quality. Perfect for grilling or roasting.', 2),
  (89, 'Organic Kale', 'Fresh and nutrient-rich organic kale, packed with vitamins and antioxidants. Great for salads, smoothies, and sautés.', 'Produce', 3.99, 'Certified organic kale, grown with sustainable farming practices. Crisp and delicious.', 3),
  (75, 'Gluten-Free Pasta', 'Delicious gluten-free pasta made from a blend of rice flour and quinoa. Cooks to perfection with a satisfying texture.', 'Pasta', 6.49, 'Premium gluten-free pasta, carefully crafted with high-quality ingredients. Enjoy the taste without the gluten.', 4),
  (96, 'Organic Blueberries', 'Plump and juicy organic blueberries bursting with sweetness. Packed with antioxidants and perfect for snacking or adding to recipes.', 'Produce', 4.99, 'Handpicked organic blueberries, grown without synthetic pesticides. Indulge in nature''s sweet treats.', 3),
  (63, 'Free-Range Eggs', 'Farm-fresh free-range eggs from happy hens raised in spacious and natural environments. Rich in protein and essential nutrients.', 'Dairy & Eggs', 5.99, 'Free-range eggs from local farms, where the hens roam freely. The best eggs for your breakfast.', 5),
  (37, 'Organic Quinoa', 'Versatile organic quinoa with a nutty flavor and a delicate texture. A nutritious grain alternative for various dishes.', 'Grains & Rice', 8.99, 'Premium organic quinoa, sustainably sourced from trusted farmers. Elevate your meals with this wholesome grain.', 6),
  (18, 'Cold-Pressed Juice', 'Freshly pressed juices made from a blend of organic fruits and vegetables. Revitalize your body with a burst of natural goodness.', 'Beverages', 7.99, 'Cold-pressed juices made with love and care. Pure and refreshing to quench your thirst.', 7),
  (29, 'Natural Peanut Butter', 'Creamy and delicious natural peanut butter made from 100% roasted peanuts. No added sugar or preservatives.', 'Spreads & Condiments', 4.49, 'Smooth and creamy peanut butter made from carefully selected peanuts. The perfect spread for your favorite snacks.', 8),
  (10, 'Organic Baby Spinach', 'Tender organic baby spinach leaves, packed with nutrients and freshness. Ideal for salads, smoothies, and sautés.', 'Produce', 3.49, 'Organic baby spinach leaves, harvested at the peak of freshness. A delightful addition to your healthy meals.', 3);

-- --------------------------------------------------
-- Inserting values in Warehouse Table 
-- --------------------------------------------------

INSERT INTO `mydb_1`.`Warehouse` (`WarehouseID`,`Name`, `Address`)
VALUES ('2','Whole Foods Market Northeast Distribution Center', 'West Bridgewater, Massachusetts');
INSERT INTO `mydb_1`.`Warehouse` (`WarehouseID`,`Name`, `Address`)
VALUES ('6','Whole Foods Market Midwest Distribution Center', 'University Park, Illinois');
INSERT INTO `mydb_1`.`Warehouse` (`WarehouseID`,`Name`, `Address`)
VALUES ('8','Whole Foods Market Rocky Mountain Distribution Center', 'Thornton, Colorado');
INSERT INTO `mydb_1`.`Warehouse` (`WarehouseID`,`Name`, `Address`)
VALUES ('10','Whole Foods Market Pacific Northwest Distribution Center', 'Tacoma, Washington');
INSERT INTO `mydb_1`.`Warehouse` (`WarehouseID`,`Name`, `Address`)
VALUES ('12','Whole Foods Market Southwest Distribution Center', 'Austin, Texas');
INSERT INTO `mydb_1`.`Warehouse` (`WarehouseID`,`Name`, `Address`)
VALUES ('7','Whole Foods Market South Distribution Center', 'Alpharetta, Georgia');
INSERT INTO `mydb_1`.`Warehouse` (`WarehouseID`,`Name`, `Address`)
VALUES ('15','Whole Foods Market Mid-Atlantic Distribution Center', 'Landover, Maryland');
INSERT INTO `mydb_1`.`Warehouse` (`WarehouseID`,`Name`, `Address`)
VALUES ('11','Whole Foods Market Florida Distribution Center', 'Pompano Beach, Florida');

-- --------------------------------------------------
-- Inserting values in Employee Table 
-- --------------------------------------------------
INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('223','John Davis', 'john.davis@gmail.com', '657 397 4545', 'Store Manager', 12);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('43','Jane Jeffrey', 'jane.jeffrey@outlook.com', '9876543210', 'Cashier', 15);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('89','Michael Smith', 'michael.smith@gmail.com.com', '4567892673', 'Assistant Manager', 8);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('153','Emily Johnson', 'emily.johnson@gmail.com', '8901234567', 'Stock Clerk', 11);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('55','Olivia Lewis', 'andrew.lewis@gmail.com', '9786578901', 'Customer Service Representative', 7);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('105','Andrew Moore', 'andrew.moore@yahoo.com', '6734019345', 'Produce Specialist', 12);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('45','Ava White', 'ava.white@gmail.com', '9456729812', 'Receiving Supervisor', 10);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('12','Sophia Brown', 'sophia.brown@eoutlook.com', '7891028856', 'Bakery Chef', 7);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('77','James Anderson', 'james.anderson@gmail.com', '9013648578', 'Store manager', 2);

INSERT INTO `mydb_1`.`Employee` (`EmployeeID`,`Name`, `Email`, `Phone`, `Role`, `Warehouse_WarehouseID`)
VALUES ('10','Isabella Young', 'isabella.young@gmail.com', '5674401554', 'Meat Department Manager', 8);

-- --------------------------------------------------
-- Inserting values in Supplier Table 
-- --------------------------------------------------

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('30','Teton Waters Ranch', '123 Main St, Denver, CO', '595-383-4833', 'info@tetonwatersranch.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('80','Rhythm Superfoods', '456 Elm St, Austin, TX', '553-987-6543', 'info@rhythmsuperfoods.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('70','Driscoll''s', 'Watsonville, California, USA', '923-451-7520', 'info@driscolls.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('5', 'Taste Republic', '123 Main St, Brooklyn, NY', '535-129-4307', 'info@tasterepublic.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('15','Organic Valley', '123 Organic Ave, La Farge, WI', '535-398-4237', 'info@organicvalley.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('45','Ancient Harvest', '456 Quinoa St, Boulder, CO', '555-987-6543', 'info@ancientharvest.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('25','Evolution Fresh', '123 Citrus Ave, Rancho Cucamonga, CA', '539-138-6932', 'info@evolutionfresh.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('60','Nature\'s Path Organic', '123 Organic Ave, Richmond, BC', '555-987-6943', 'info@naturespath.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('40','Organic Girl', '456 Green Way, Salinas, CA', '592-292-4207', 'info@organicgirl.com');

INSERT INTO `mydb_1`.`Supplier` (`SupplierID`,`Name`, `Address`, `PhoneNumber`, `Email`)
VALUES ('90','Dr. Bronners', 'Vista, California, United States', '367-388-6043', 'info@drbronners.com');

-- --------------------------------------------------
-- Inserting values in Inventory Table 
-- --------------------------------------------------

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (464,100, 56, 90);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (2,50, 96, 5);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (928,75,10, 40);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (67,200, 75, 70);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (90,150, 22, 30);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (60,80, 29, 60);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (178,120, 18, 25);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (216,90, 63, 15);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (78,60, 89, 80);

INSERT INTO `mydb_1`.`Inventory` (`InventoryID`,`Quantity`, `Product_ProductID`, `Product_Supplier_SupplierID`)
VALUES (15,110, 37, 45);

-- --------------------------------------------------
-- Inserting values in Store Location Table 
-- --------------------------------------------------

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('555','Whole Foods Market - New York City', '10 Columbus Circle, New York, NY', 928);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('58','Whole Foods Market - Chicago', '1550 N Kingsbury St, Chicago, IL', 78);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('126','Whole Foods Market - Los Angeles', '6350 W 3rd St, Los Angeles, CA', 90);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('45','Whole Foods Market - Seattle', '2210 Westlake Ave, Seattle, WA', 15);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('231','Whole Foods Market - Austin', '525 N Lamar Blvd, Austin, TX', 60);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('540','Whole Foods Market - Atlanta', '650 Ponce de Leon Ave NE, Atlanta, GA', 67);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('68','Whole Foods Market - Washington D.C.', '1440 P St NW, Washington, D.C.', 178);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('380','Whole Foods Market - Miami', '299 SE 3rd Ave, Miami, FL', 464);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('90','Whole Foods Market - Boston', '348 Harrison Ave, Boston, MA', 2);

INSERT INTO `mydb_1`.`StoreLocation` (`StoreID`,`Name`, `Address`, `Inventory_InventoryID`)
VALUES ('79','Whole Foods Market - San Francisco', '399 4th St, San Francisco, CA', 216);


-- Query: Retrieve all products from a specific category.
SELECT * FROM Product WHERE Category = 'Produce';

-- Retrieve the quantity and product IDs
SELECT `Quantity`, `Product_ProductID` FROM `Inventory` WHERE `Quantity` > 100;


SELECT p.ProductName, SUM(i.Quantity) AS TotalQuantity
FROM Product p
INNER JOIN Inventory i ON p.ProductID = i.Product_ProductID
GROUP BY p.ProductName;


SELECT e.Name AS EmployeeName, e.Role, w.Name AS WarehouseName
FROM Employee e
INNER JOIN Warehouse w ON e.Warehouse_WarehouseID = w.WarehouseID;


SELECT Product.ProductName, Product.Category, Warehouse.Address
FROM Product 
INNER JOIN Inventory ON Product.ProductID = Inventory.Product_ProductID
INNER JOIN Warehouse ON Inventory.Product_Supplier_SupplierID = Warehouse.WarehouseID;

-- Get the names and addresses of all store locations along with the name and email of their respective store managers
SELECT s.Name, s.Address, e.Name AS ManagerName, e.Email AS ManagerEmail
FROM StoreLocation s
JOIN Employee e ON e.Warehouse_WarehouseID = s.Inventory_InventoryID
WHERE e.Role = 'Store Manager';




