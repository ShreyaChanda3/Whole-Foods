SET @message = '';

CALL UpdateProductDescription(56, 'New description12345', @message);

SELECT @message;




SET @warehousename_address = '';

CALL FIND_WAREHOUSES_FOR_A_GIVEN_PRODUCT(96, @warehousename_address);

SELECT @warehousename_address AS WarehouseName_Address;