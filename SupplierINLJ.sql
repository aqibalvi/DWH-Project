DECLARE   
    CURSOR cursorSupplier IS 
    SELECT M.SUPPLIER_ID,M.SUPPLIER_NAME
    FROM MASTERDATA M
    ORDER BY (M.SUPPLIER_ID);
    TYPE supplierR IS TABLE OF cursorSupplier%ROWTYPE INDEX BY BINARY_INTEGER;
    supplierRecord         supplierR;
    
BEGIN
OPEN cursorSupplier;
    LOOP
    FETCH cursorSupplier BULK COLLECT INTO supplierRecord LIMIT 50;
    EXIT WHEN supplierRecord.COUNT = 0;
    FOR iter IN 1 .. supplierRecord.COUNT
        LOOP
        DECLARE
          CUR INTEGER;
        BEGIN     
            SELECT COUNT(*) INTO CUR FROM "SUPPLIER" WHERE SUPPLIER_ID=supplierRecord (iter).SUPPLIER_ID;
            IF  NOT CUR > 0 THEN
                Insert into "SUPPLIER" (SUPPLIER_ID,SUPPLIER_NAME) 
                values (supplierRecord (iter).SUPPLIER_ID,supplierRecord (iter).SUPPLIER_NAME);
            END IF;
        END;
        END LOOP;   
    END LOOP;
CLOSE cursorSupplier;
END;