DECLARE
    CURSOR cursorStore IS 
    SELECT STORE_ID, STORE_NAME
    FROM TRANSACTIONS T;
    TYPE storeR IS TABLE OF cursorStore%ROWTYPE INDEX BY BINARY_INTEGER;
    storeRecord         storeR;
    
BEGIN
OPEN cursorStore;
    LOOP
    FETCH cursorStore BULK COLLECT INTO storeRecord LIMIT 50;
    EXIT WHEN storeRecord.COUNT = 0;
    FOR iter IN 1 .. storeRecord.COUNT
        LOOP
       
        DECLARE
            CUR INTEGER;
        BEGIN
            SELECT COUNT(*) INTO CUR FROM "STORE" WHERE STORE_ID=storeRecord (iter).STORE_ID;
            IF  NOT CUR > 0 THEN
--                dbms_output.put_line(storeRecord (iter).STORE_ID);
                Insert into "STORE" (STORE_ID,STORE_NAME) 
                values (storeRecord (iter).STORE_ID,storeRecord (iter).STORE_NAME);
            END IF;
        END;

        END LOOP;   
    END LOOP;
CLOSE cursorStore;
END;



