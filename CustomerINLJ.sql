DECLARE
    CURSOR cursorCustomer IS 
    SELECT CUSTOMER_ID, CUSTOMER_NAME
    FROM TRANSACTIONS T
    ORDER BY (T.TRANSACTION_ID);
    TYPE customerR IS TABLE OF cursorCustomer%ROWTYPE INDEX BY BINARY_INTEGER;
    customerRecord         customerR;
    
BEGIN
OPEN cursorCustomer;
    LOOP
    FETCH cursorCustomer BULK COLLECT INTO customerRecord LIMIT 50;
    EXIT WHEN customerRecord.COUNT = 0;
    FOR iter IN 1 .. customerRecord.COUNT
        LOOP
       
        DECLARE
            CUR INTEGER;
        BEGIN
            SELECT COUNT(*) INTO CUR FROM "CUSTOMER" WHERE CUSTOMER_ID=customerRecord (iter).CUSTOMER_ID;
            IF  NOT CUR > 0 THEN
                Insert into "CUSTOMER" (CUSTOMER_ID,CUSTOMER_NAME) values (customerRecord (iter).CUSTOMER_ID,customerRecord (iter).CUSTOMER_NAME);
            END IF;
        END;
            

        END LOOP;   
    END LOOP;
CLOSE cursorCustomer;
END;