
----------Query#1-----------

SELECT * FROM
(
select PRODUCT_NAME, max(TOTALSALES) as Highest_Sales
from PRODUCT P, FACTTABLE F, DATETABLE D
WHERE P.PRODUCT_ID = F.PRODUCT_ID
AND D.T_YEAR = '2016'
group by PRODUCT_NAME
ORDER BY MAX(F.TOTALSALES) DESC
) A
WHERE rownum <= 1;


----------Query#2-----------

SELECT * FROM
(
  SELECT S.SUPPLIER_NAME, MAX(F.TOTALSALES) "TotalSales"
    FROM FACTTABLE F, DATETABLE D, SUPPLIER S
    WHERE T_MONTH = '8'
GROUP BY s.supplier_name
ORDER BY MAX(F.TOTALSALES) DESC
) A
WHERE rownum <= 3;

----------Query#3-----------

SELECT * FROM
(
  SELECT S.STORE_NAME, MAX(F.TOTALSALES) "TotalSales"
    FROM FACTTABLE F, DATETABLE D, STORE S
    WHERE T_MONTH = '8'
    AND T_YEAR = '2016'
GROUP BY s.store_name
ORDER BY MAX(F.TOTALSALES) DESC
) A
WHERE rownum <= 3;


----------Query#4-----------

SELECT COUNT(QUANTITY), P.PRODUCT_NAME
FROM TRANSACTIONS T, PRODUCT P
WHERE p.product_id = t.product_id
AND P.PRODUCT_NAME = 'Melon'
GROUP BY P.PRODUCT_NAME;


----------Query#5-----------


select P.PRODUCT_NAME,
    CASE WHEN D.T_QUARTER = 1 THEN 1 END as Q1_2016,
    CASE WHEN D.T_QUARTER = 2 THEN 2 END as Q2_2016,
    CASE WHEN D.T_QUARTER = 3 THEN 3 END as Q3_2016,
    CASE WHEN D.T_QUARTER = 4 THEN 4 END as Q4_2016
    from PRODUCT P, DATETABLE D;









