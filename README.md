# Whole Foods Database Management System

## Overview

This project addresses the inconsistencies between product descriptions on the Whole Foods website and their packaging. By implementing a robust database system, Whole Foods can ensure consistency in product descriptions, enhance consumer satisfaction, and streamline inventory management.

## Project Objectives

- **Store comprehensive product information**: Including web descriptions, packaging descriptions, classifications, prices, and supplier details.
- **Ensure consistency**: Between web and packaging descriptions.
- **Provide management tools**: For employees to manage and update product information.
- **Assist in inventory management**: By tracking product quantities across various store locations.

## Database Design

The database design includes the following key entities:

- **Warehouse**
- **Employee**
- **Supplier**
- **Product**
- **Inventory**
- **Store Location**
- **Product-Store Location Relationship**
- **Store Location-Supplier Relationship**

### Entity-Relationship Diagram (ERD)

For a detailed look at the ERD and the structure of each table, refer to the ER Diagram PDF included in this repository.

## Database Implementation

The database was implemented using MySQL, translating the ERD into a set of tables with appropriate attributes, primary keys, and foreign keys. Key tables include:

- **Warehouse**: Stores information about warehouses.
- **Employee**: Stores employee details.
- **Supplier**: Stores supplier information.
- **Product**: Stores product details.
- **Inventory**: Manages inventory data.
- **Store Location**: Stores store location details.
- **Product-Store Location Relationship**: Manages the relationship between products and store locations.
- **Store Location-Supplier Relationship**: Manages the relationship between store locations and suppliers.

### Normalization

The tables were normalized to ensure data integrity and consistency.

## Stored Procedures

### UpdateProductDescription

Updates the web description of a product.
```sql
DELIMITER //
CREATE PROCEDURE UpdateProductDescription(
    IN product_Id INT,
    IN NewWebDescription TEXT,
    OUT message VARCHAR(255)
)
BEGIN
    UPDATE Product
    SET WebDescription = NewWebDescription
    WHERE ProductID = product_Id;
    SET message = 'Product description updated successfully.';
END //
DELIMITER //
```

### Find_Warehouses_For_a_Given_Product

Returns warehouses associated with a specified product.
```sql
DELIMITER //
CREATE PROCEDURE Find_Warehouses_For_a_Given_Product(
    IN product_Id INT,
    OUT warehousename_address TEXT
)
BEGIN
    SELECT CONCAT(Name, ', ', Address) INTO warehousename_address
    FROM Warehouse
    WHERE WarehouseID IN (
        SELECT Warehouse_WarehouseID
        FROM Inventory
        WHERE Product_ProductID = product_Id
    );
END //
DELIMITER //
```


How to Use
Set Up the Database: Run the Whole Foods Final script.sql file to create the database schema and populate it with sample data.
Execute Stored Procedures: Use the Store procedures calls.sql file to call and test the stored procedures.
Update Product Descriptions: Use the updateproductdescritption.sql script to update product descriptions as needed.
Find Warehouses: Use the FIND_WAREHOUSES_FOR_A_GIVEN_PRODUCT.sql script to find warehouses storing a specific product.

Conclusion
The implementation of the Whole Foods Database Management System successfully addresses the issue of inconsistent product descriptions between the website and packaging. By providing a unified platform for managing product information, the system enhances customer satisfaction through accurate and reliable product details.

Key benefits of this system include:

Consistency: Ensures web descriptions match packaging descriptions, reducing customer confusion.
Efficiency: Streamlines internal processes by providing employees with tools to manage and update product information easily.
Inventory Management: Facilitates accurate tracking of product quantities across various store locations, ensuring optimal stock levels.
The system's robust design, including normalized tables and stored procedures, guarantees data integrity and efficient data retrieval. The use of MySQL provides a reliable and scalable foundation for this database management system.

Overall, this project exemplifies the effective use of database management techniques to solve real-world business problems, demonstrating significant improvements in operational efficiency and customer satisfaction for Whole Foods. The comprehensive documentation and scripts provided ensure that the system can be easily maintained and expanded in the future.
