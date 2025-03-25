CREATE TABLE orders(
OrderID INT PRIMARY KEY,
Date DATE,
CustomerID VARCHAR(250),
ProdNumber VARCHAR(250),
Quantity VARCHAR(250)
);

ALTER TABLE orders
ALTER COLUMN Date TYPE TEXT;

UPDATE orders
SET Date = TO_DATE(Date, 'MM/DD/YYYY');

SELECT*FROM orders



CREATE TABLE customers(
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(250),
LastName VARCHAR(250),
CustomerEmail VARCHAR(250),
CustomerPhone VARCHAR(250),
CustomerAddress VARCHAR(250),
CustomerCity VARCHAR(250),
CustomerState VARCHAR(250),
CustomerZip VARCHAR(250)
);

CREATE TABLE product_category(
CategoryID INT PRIMARY KEY,
CategoryName VARCHAR(250),
CategoryAbbreviation VARCHAR(250)
);

CREATE TABLE products(
ProdNumber VARCHAR(250),
ProdName VARCHAR(250),
Category VARCHAR(250),
Price VARCHAR(250)
);



SELECT Price FROM products WHERE Price LIKE '%,%';
UPDATE products
SET Price = REPLACE(Price, ',', '.')
WHERE Price LIKE '%,%';

ALTER TABLE products
ALTER COLUMN Price TYPE NUMERIC USING Price::NUMERIC(10,2);


SELECT*FROM products


ALTER TABLE orders
ALTER COLUMN customerid TYPE INTEGER USING customerid::INTEGER;

ALTER TABLE products
ALTER COLUMN category TYPE INTEGER USING category::INTEGER;

ALTER TABLE products 
ADD CONSTRAINT products_pkey PRIMARY KEY (ProdNumber);


-- Membuat relasi tabel ERD
ALTER TABLE orders
ADD CONSTRAINT fk_customerid
FOREIGN KEY (CustomerID)
REFERENCES customers(CustomerID);

ALTER TABLE orders
ADD CONSTRAINT fk_prodnum
FOREIGN KEY (ProdNumber)
REFERENCES products(ProdNumber);

ALTER TABLE products
ADD CONSTRAINT fk_category
FOREIGN KEY (Category)
REFERENCES product_category(CategoryID);


CREATE TABLE master AS 
WITH master AS (
    SELECT 
        c.CustomerEmail AS cust_email,       
        c.CustomerCity AS cust_city,         
        o.Date AS order_date,                
        o.Quantity::INTEGER AS order_qty,     
        p.ProdName AS product_name,          
        p.Price AS product_price,            
        pc.CategoryName AS category_name,    
        (o.Quantity::INTEGER * p.Price) AS total_sales 
    FROM orders o
    JOIN customers c ON o.CustomerID = c.CustomerID  -- 
    JOIN products p ON o.ProdNumber = p.ProdNumber   
    JOIN product_category pc ON p.Category = pc.CategoryID 
)
SELECT * 
FROM master
ORDER BY order_date ASC;

