DECLARE   
    CURSOR cursorDate IS 
    SELECT T_DATE
    FROM TRANSACTIONS T
    ORDER BY (T.PRODUCT_ID);
    TYPE dateR IS TABLE OF cursorDate%ROWTYPE INDEX BY BINARY_INTEGER;
    dateRecord         dateR;
    
BEGIN
OPEN cursorDate;
    LOOP
    FETCH cursorDate BULK COLLECT INTO dateRecord LIMIT 50;
    EXIT WHEN dateRecord.COUNT = 0;
    FOR iter IN 1 .. dateRecord.COUNT
        LOOP
        DECLARE
          CUR INTEGER;
        BEGIN     
            SELECT COUNT(*) INTO CUR FROM "DATETABLE" WHERE T_DATE=dateRecord (iter).T_DATE;
            IF  NOT CUR > 0 THEN
                Insert into "DATETABLE" (T_DATE, T_DAY,T_YEAR,T_MONTH,T_QUARTER) 
                values (dateRecord (iter).T_DATE, EXTRACT(DAY from dateRecord (iter).T_DATE), 
                EXTRACT(YEAR from dateRecord (iter).T_DATE),
                EXTRACT(MONTH from dateRecord (iter).T_DATE),
                TO_CHAR(dateRecord (iter).T_DATE, 'Q'));
            END IF;
        END;
        END LOOP;   
    END LOOP;
CLOSE cursorDate;
END;