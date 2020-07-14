DECLARE
    CURSOR cursorProduct IS 
    SELECT T.PRODUCT_ID ,M.PRODUCT_NAME
    FROM TRANSACTIONS T, MASTERDATA M
    WHERE  T.PRODUCT_ID = M.PRODUCT_ID
    ORDER BY (T.TRANSACTION_ID);
    TYPE productR IS TABLE OF cursorProduct%ROWTYPE INDEX BY BINARY_INTEGER;
    productRecord         productR;
    
BEGIN
OPEN cursorProduct;
    LOOP
    FETCH cursorProduct BULK COLLECT INTO productRecord LIMIT 50;
    EXIT WHEN productRecord.COUNT = 0;
    FOR iter IN 1 .. productRecord.COUNT
        LOOP
       
        DECLARE
            CUR INTEGER;
        BEGIN
            SELECT COUNT(*) INTO CUR FROM "PRODUCT" WHERE PRODUCT_ID=productRecord (iter).PRODUCT_ID;
            IF  NOT CUR > 0 THEN
                Insert into "PRODUCT" (PRODUCT_ID,PRODUCT_NAME) 
                values (productRecord (iter).PRODUCT_ID,productRecord (iter).PRODUCT_NAME);
            END IF;
        END;

        END LOOP;   
    END LOOP;
CLOSE cursorProduct;
END;