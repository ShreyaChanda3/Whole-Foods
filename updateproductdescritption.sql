CREATE PROCEDURE UpdateProductDescription (
  IN product_Id INT,
  IN NewWebDescription VARCHAR(255),
  OUT message VARCHAR(255)
)
BEGIN
  DECLARE rowCount INT;

  -- Check if the product exists
  SELECT COUNT(*) INTO rowCount FROM product WHERE ProductID = product_Id;
  
  IF rowCount = 0 THEN
    SET message = 'Product does not exist.';
  ELSE
    -- Update the product description
    UPDATE product SET webdescription = NewWebDescription WHERE Productid = product_Id;
    
    SET message = 'Product description updated successfully.';
  END IF;

 END 


