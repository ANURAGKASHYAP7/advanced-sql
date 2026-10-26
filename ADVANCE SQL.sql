create database advance_sql;
use advance_sql;
/*Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
 answer -A Common Table Expression (CTE) is a temporary, named result set that is defined using the WITH keyword and can be used within a single SQL statement.
CTEs improve SQL query readability by breaking complex queries into smaller, simpler, and more understandable parts. They make queries easier to maintain, debug, and reuse within the same statement
/*Q2. Why are some views updatable while others are read-only? Explain with an example.
In SQL, a view is a virtual table created using a SELECT statement. Some views are updatable because they directly represent rows from a single table,
 while others are read-only because their structure makes it difficult to identify which original rows should be changed.*/
 /*Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?
 Answer:
A stored procedure is a set of SQL statements saved in a database that can be executed whenever needed.
Advantages of stored procedures:
1. Code Reusability: We can use the same SQL code multiple times without writing it again.
2. Time Saving: It reduces repeated work.
3. Easy Maintenance: We can update the procedure in one place.
4. Security: Permissions can be given to execute a procedure without directly allowing access to underlying tables.*/
/* Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential
Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.
Answer:
A trigger is a special SQL code that automatically executes when a specific event, such as INSERT, UPDATE, or DELETE, occurs on a table.

Purpose of triggers:
1. Automatically perform actions when data changes.
2. Maintain data consistency.
3. Keep records of changes made to a table.*/
/*
Q5. Explain the need for data modelling and normalization when designing a database.
Answer:

Data Modelling: Data modelling is the process of planning how data will be stored, organized, and connected in a database. It helps create a clear and efficient database structure.

Normalization: Normalization is the process of organizing data into tables to reduce data duplication and maintain data consistency.

Need for data modelling and normalization:
1. Reduces Data Duplication: Avoids storing the same information repeatedly.
2. Maintains Data Consistency: Keeps data accurate and consistent.
3. Improves Organization: Makes data easier to manage and understand.
4. Prevents Data Anomalies: Reduces problems during insertion, updating, and deletion of data.*/


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Furniture', 2500),
(4, 'Desk', 'Furniture', 5500);


CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');

/*6 write a cte to calculate the total revenue for each product 
 (Revenues = Price × Quantity), and return only products where  revenue > 3000.*/
 with ProductRevenue AS (
 select 
 p.ProductID,
 p.ProductName,
 p.Price * s.Quantity AS Revenue
 from Products p
 join Sales s
 on p.ProductId=s.ProductID
 )
 select * from ProductRevenue
 where Revenue > 3000;
 # Q7. Create a view named vw_CategorySummary that shows:
 #Category, TotalProducts, AveragePrice
CREATE VIEW vw_CategorySummary As 
SELECT Category,count(*) as totalproducts,
AVG(Price) AS AveragePrice from products
group by Category;
SELECT * FROM vw_CategorySummary;
# Q8  create an updatable view containing ProductID, ProductName, and Price.
 #Then update the price of ProductID = 1 using the view
 CREATE VIEW vw_ProductDetails AS
SELECT ProductID, ProductName, Price
FROM Products;
UPDATE vw_ProductDetails
Set Price = 1500
where ProductID = 1;
SELECT * FROM  vw_ProductDetails;
# Q9. Create a stored procedure that accepts a category name and returns all products belonging to that
# category.
DELIMITER //
create PROCEDURE GetProductsbyCategory(IN cat_name varchar(50))
BEGIN
     SELECT * FROM Products
     where category = cat_name;
END //
DELIMITER ;
CALL GetProductsbyCategory('Electronics');
/ Q10 *Create an AFTER DELETE trigger on the Products table that archives deleted product records into a ProductArchive table. 
The archive table should store ProductID, ProductName, Category, Price, and DeletedAt (timestamp).*/
CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //
CREATE TRIGGER after_product_delete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
INSERT INTO ProductArchive
      (ProductID,ProductName,Category,Price)
      VALUES
            (OLD.ProductID,OLD.ProductName,OLD.Category,OLD.Price);
END //
DELIMITER ;
INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES (5, 'Test Product', 'Testing', 100);
DELETE FROM Products
WHERE ProductID = 5;
SELECT * FROM ProductArchive;