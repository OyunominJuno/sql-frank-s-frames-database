#------------------------------------------Database----------------------------------------------
DROP DATABASE IF EXISTS frank;
CREATE DATABASE IF NOT EXISTS frank;
USE frank;

#------------------------------------------Tables------------------------------------------------
CREATE TABLE IF NOT EXISTS frame
(
	FrameId			INT											PRIMARY KEY	AUTO_INCREMENT,
    FrameName 		VARCHAR(45)									NOT NULL,
    FrameColor 		ENUM('Gold','Silver','Black','White')		NOT NULL,
    FrameWidth		FLOAT(4,2)									NOT NULL,
    FramePricePLF	DECIMAL(5,2)						NOT NULL
);

CREATE TABLE IF NOT EXISTS glass
(
	GlassId			INT											PRIMARY KEY	AUTO_INCREMENT,
    GlassStyle 		VARCHAR(45)									NOT NULL,
    GlassPricePSF	DECIMAL(4,2)								NOT NULL										
);

CREATE TABLE IF NOT EXISTS customer
(
	CustomerId		INT											NOT NULL	AUTO_INCREMENT,
	CustomerName	VARCHAR(45)									NOT NULL,
    CustomerPhone	CHAR(10)									NULL,
    CONSTRAINT PRIMARY KEY (CustomerId)
);

CREATE INDEX cust_phone_idx
ON customer (CustomerPhone);

CREATE TABLE IF NOT EXISTS mat
(
	MatId			INT											PRIMARY KEY	AUTO_INCREMENT,
    MatColor 		ENUM('White','Gray','Black','Sand')			NOT NULL,
    MatPricePSF		DECIMAL(4,2)								NOT NULL										
);

CREATE TABLE IF NOT EXISTS poster
(
	PosterId		INT											PRIMARY KEY	AUTO_INCREMENT,
    PosterName		VARCHAR(45)									NOT NULL,
    PosterPrice		DECIMAL(5,2)								NOT NULL,
    PosterWidth 	FLOAT(5,2)									NULL,
    PosterHeight	FLOAT(5,2)									NULL
);

CREATE TABLE IF NOT EXISTS supplier
(
	SupplierId		INT											PRIMARY KEY	AUTO_INCREMENT,
    SupplierName	VARCHAR(45)									NOT NULL,
    SupplierPhone	CHAR(10)									NOT NULL
);

CREATE TABLE IF NOT EXISTS postersupplier
(
	PosterId		INT											NOT NULL,
    SupplierId		INT											NOT NULL,
    CONSTRAINT PRIMARY KEY (PosterId, SupplierId),
    CONSTRAINT poster_id_fk	
    FOREIGN KEY (PosterId)
    REFERENCES poster (PosterId),
    CONSTRAINT supplier_id_fk
    FOREIGN KEY (SupplierId)
    REFERENCES supplier (SupplierId)
);

CREATE TABLE IF NOT EXISTS `order`
(
	OrderId			INT											PRIMARY KEY		AUTO_INCREMENT,
    CustomerId 		INT											NOT NULL,
    PosterId 		INT											NOT NULL,
    MatId 			INT											NOT NULL,
    FrameId 		INT											NOT NULL,
    GlassId 		INT											NOT NULL,
    OrderPromised	DATE										NOT NULL,
    OrderPrice		DECIMAL(6,2)								NOT NULL,
    CONSTRAINT customer_id_fk
    FOREIGN KEY (CustomerId)
    REFERENCES customer (CustomerId),
    
    CONSTRAINT poster_posterId_fk
    FOREIGN KEY (PosterId)
    REFERENCES poster (PosterId),
    
    CONSTRAINT mat_id_fk
    FOREIGN KEY (MatId)
    REFERENCES mat (MatId),
    
    CONSTRAINT frame_id_fk
    FOREIGN KEY (FrameId)
    REFERENCES frame (FrameId),
    
    CONSTRAINT glass_id_fk
    FOREIGN KEY (GlassId)
    REFERENCES glass (GlassId)
);

#--------------------------------------Values---------------------------------------------
INSERT frame
VALUES 	(1001, 'Thin marble', 'White', 34.1, 17.0),
		(1002, 'Wide-metal', 'Silver', 76.7, 11.10),
        (1003, 'Royal', 'Gold', 20.0, 110.10),
        (DEFAULT, 'Thin-plain', 'Black', 35.0, 12.00),
        (DEFAULT, 'Dark-shadow', 'Black', 5.0, 22.0),
        (DEFAULT, 'Pattern', 'Gold', 25.0, 110.0);
        
INSERT glass
VALUES  (2001, 'Plain-clear', 15.0),
		(2002, 'Black tint', 20.0),
        (DEFAULT, 'Pattern', 35.0),
        (DEFAULT, 'Half and half', 30.0),
        (DEFAULT, 'Burned thoroughly', 45.0);
        
INSERT customer
VALUES  (3001, 'Kelly Black', '2067890345'),
		(3002, 'Sabina Astete', '2068989456'),
        (3003, 'Kim Jun', NULL),
        (DEFAULT, 'Oyunomin Mun', '2066989680'),
        (DEFAULT, 'Danny Hirata', '3547878900'),
        (DEFAULT, 'Susan Brad', '2066778345'),
        (DEFAULT, 'Kelly Ashworth', '8082323456');
        
INSERT mat 
VALUES  (4001, 'Gray', 18.99),
		(4002, 'White', 21.0),
        (4003, 'Black', 18.99),
        (DEFAULT, 'Sand', 18.99);
        
INSERT poster
VALUES  (5001, 'Movie poster', 840.0, 300.50, 780.0),
		(5002, 'Portrait', 120.0, NULL, NULL),
        (DEFAULT, 'Ant-Man poster', 350.0, 500.0, 800.0),
        (DEFAULT, 'Book cover', 150.0, 200.0, 430.0),
        (DEFAULT, 'My Hero Academia', 890.0, 756.0, 850.0);
        
INSERT supplier
VALUES  (DEFAULT, 'Any Material LLC', '8084567477'),
		(DEFAULT, 'Blick', '2065757890'),
        (DEFAULT, 'Antique Shop', '2068989123'),
        (DEFAULT, 'Seattle Fabrics', '2062626206'),
        (DEFAULT, 'JOANN Material LLC', '7088989900');
        
INSERT postersupplier
VALUES  (5001, 2), 
		(5002, 1),
        (5005, 3),
        (5004, 2),
        (5005, 1),
        (5003, 3), 
        (5003, 5);
        
INSERT `order`
VALUES  (6001, 3001, 5002, 4003, 1002, 2001, '2018-05-04', 1550.78),
		(6002, 3002, 5002, 4001, 1001, 2002, '2018-01-31', 7800.45),
        (6003, 3001, 5001, 4002, 1001, 2001, '2018-05-05', 908.67),
        (DEFAULT, 3003, 5004, 4004, 1001, 2005, '2018-08-01', 1317.89),
        (DEFAULT, 3005, 5005, 4001, 1005, 2003, '2016-06-22', 560.0), 
        (DEFAULT, 3004, 5002, 4004, 1004, 2002, '2017-12-26', 8918.45);

#--------------------------------Queries--------------------------------------
SELECT OrderId, CustomerName, PosterName, SupplierName
FROM customer
	JOIN `order`
		USING (CustomerId)
	JOIN poster	
		USING (PosterId)
	JOIN postersupplier 
		USING (PosterId)
	JOIN supplier
		USING (SupplierId)
WHERE CustomerId = 3002;

SELECT *
FROM frame
	JOIN `order`
		USING (FrameId)
	JOIN mat
		USING (MatId)
WHERE OrderId = 6001;

SELECT CustomerId, CustomerName, OrderId, OrderPrice, GlassStyle, GlassId
FROM customer 
	JOIN `order`
		USING (CustomerId)
	JOIN glass
		USING (GlassId)
WHERE CustomerPhone IS NOT NULL;

SELECT  FrameName AS 'Sold Frame', FramePricePLF, 
		GlassStyle AS 'Sold Glass', GlassPricePSF
FROM frame
	JOIN `order`
		USING (FrameId)
	JOIN glass
		USING (GlassId);