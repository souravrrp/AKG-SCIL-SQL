SELECT
*
FROM
APPS.MTL_MATERIAL_TRANSACTIONS
WHERE 1=1
AND ORGANIZATION_ID=604
--AND INVENTORY_ITEM_ID=24403
--AND SHIPMENT_NUMBER='TO/SCOU/067998'
--AND TRANSACTION_TYPE_ID=2
AND ROWNUM<=2
--AND TRANSACTION_DATE BETWEEN '01-AUG-2017' AND '09-SEP-2017'

SELECT
*
FROM
APPS.MTL_TRX_TYPES_VIEW 
WHERE 1=1
--JOINED BY TRANSACTION_TYPE_ID, 
--CONDITIONED BY TRASACTION_SOURCE_TYPE_ID, TRANSACTION_ACTION_ID
--FIND OUT TRANSACTION_TYPE_NAME, TRANSACTION_SOURCE_TYPE_NAME, DESCRIPTION,
AND TRANSACTION_TYPE_ID=3


SELECT
*
FROM
APPS.MTL_MATERIAL_TRANSACTIONS
--TRANSACTION_ID, INVENTORY_ITEM_ID, ORGANIZATION_ID, SUBINVENTORY_CODE, TRANSACTION_TYPE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, TRANSACTION_DATE, SOURCE_LINE_ID,

SELECT
*
FROM
APPS.MTL_TRANSACTIONS_INTERFACE
WHERE 1=1
--TRANSACTION_HEADER_ID,INVENTOTRY_ITEM_ID, SHIPMENT_NUMBER,
--ORGANIZATION_ID, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, TRANSACTION_UOM, TRANSACTION_DATE, TRANSFER_SUBINVENTORY, TRANSFER_ORAGANIZATION, 
--ERROR_EXPLANATION, ERRROR_CODE


SELECT
*
FROM
INV.MTL_TRANSACTION_LOT_NUMBERS
--JOINED BY TRANSACTION_ID, 
--SEARCH BY INVENTORY_ITEM_ID, ORGANIZATION_ID, 
--FIND OUT TRANSACTION_DATE, PRIMARY_QUANTITY, TRANSACTION_QUANTITY, LOT_NUMBER, SECONDER_TRANSACTION_QUANTITY, 
--CONDITIONED BY TRANSACTION_SOURCE_NAME, TRASACTION_SOURCE_TYPE_ID,


SELECT
*
FROM
INV.MTL_TRANSACTION_TYPES
--JOINED BY TRANSACTION_TYPE_ID, TRANSACTION_TYPE_NAME, DESCRIPTION, 
--CONDITIONED BY TRASACTION_SOURCE_TYPE_ID, 
WHERE 1=1
--AND TRANSACTION_TYPE_ID=64
AND TRANSACTION_SOURCE_TYPE_ID='4'

SELECT
*
FROM
INV.MTL_ITEM_LOCATIONS
--JOINED BY INVENTORY_LOCATION_ID, ORGANIZATION_ID, 
--CONDITIONED BY INVENTORY_LOCATION_TYPE, 
--FIND OUT SUBINVENTORY_CODE,SEGMENT1, SEGMENT2, SEGMENT3


SELECT * FROM APPS.RCV_TRANSACTIONS_INTERFACE
--   SET processing_mode_code = 'BATCH'
 WHERE 1=1
   AND transaction_type = 'RECEIVE'
   AND processing_status_code IN ('ERROR','COMPLETED')-- 'PENDING'
   AND processing_mode_code = 'IMMEDIATE'
   AND transaction_status_code IN ('ERROR','PENDING')
   AND to_organization_id = '101'
