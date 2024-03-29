SELECT NVL (R.REGION_NAME, 'Not Defined') REGION_NAME, DC.FROM_WAREHOUSE_ID,
DECODE(DC.FROM_WAREHOUSE_ID, 101, OD.ORGANIZATION_CODE, OD.ORGANIZATION_NAME) WAREHOUSE, ORDER_NUMBER,
SUM(SHIPPED_QUANTITY) 
FROM APPS.XXAKG_DISTRIBUTION_COST DC,
          APPS.XXAKG_DISTRIBUTOR_BLOCK_M R,
          APPS.ORG_ORGANIZATION_DEFINITIONS OD
WHERE DC.CUSTOMER_ID = R.CUSTOMER_ID
AND      DC.ORG_ID = R.ORG_ID 
AND      DC.FROM_WAREHOUSE_ID = OD.ORGANIZATION_ID
AND ACTUAL_SHIPMENT_DATE BETWEEN :P_DATE_FROM AND :P_DATE_TO
GROUP BY NVL (R.REGION_NAME, 'Not Defined'), DC.FROM_WAREHOUSE_ID, DECODE(DC.FROM_WAREHOUSE_ID, 101, OD.ORGANIZATION_CODE, OD.ORGANIZATION_NAME)
,ORDER_NUMBER
HAVING NVL (R.REGION_NAME, 'Not Defined') = :P_REGION
AND DECODE(DC.FROM_WAREHOUSE_ID, 101, OD.ORGANIZATION_CODE, OD.ORGANIZATION_NAME) = :P_GHAT
ORDER BY 1, 3, 4
