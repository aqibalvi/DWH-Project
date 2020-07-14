SET SERVEROUTPUT ON;
DECLARE   
    CURSOR cursorFactTable IS 
    SELECT T.TRANSACTION_ID,T.PRODUCT_ID, T.CUSTOMER_ID, T.T_DATE, T.QUANTITY, T.STORE_ID, M.SUPPLIER_ID,M.PRICE
    FROM TRANSACTIONS T, MASTERDATA M
    WHERE T.PRODUCT_ID = M.PRODUCT_ID
    ORDER BY (T.TRANSACTION_ID);
    TYPE factTableR IS TABLE OF cursorFactTable%ROWTYPE INDEX BY BINARY_INTEGER;
    factTableRecord         factTableR;
    
BEGIN
OPEN cursorFactTable;
    LOOP
    FETCH cursorFactTable BULK COLLECT INTO factTableRecord LIMIT 50;
    EXIT WHEN factTableRecord.COUNT = 0;
    FOR iter IN 1 .. factTableRecord.COUNT
        LOOP
        DECLARE
          CUR INTEGER;
        BEGIN   
                Insert into "FACTTABLE" (TRANSACTION_ID,PRODUCT_ID, CUSTOMER_ID, SUPPLIER_ID, STORE_ID, T_DATE, PRICE, QUANTITY, TOTALSALES)
                Values (factTableRecord (iter).TRANSACTION_ID, factTableRecord (iter).PRODUCT_ID, factTableRecord (iter).CUSTOMER_ID, 
                        factTableRecord (iter).SUPPLIER_ID, factTableRecord (iter).STORE_ID, 
                        factTableRecord (iter).T_DATE, factTableRecord (iter).PRICE, 
                        factTableRecord (iter).QUANTITY, factTableRecord (iter).PRICE*factTableRecord (iter).QUANTITY);
        END;
        END LOOP;   
    END LOOP;
CLOSE cursorFactTable;
END;