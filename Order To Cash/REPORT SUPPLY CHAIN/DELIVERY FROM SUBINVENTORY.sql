SELECT
MMT.*
FROM
APPS.WSH_DELIVERY_DETAILS WSH
,INV.MTL_MATERIAL_TRANSACTIONS MMT
,INV.MTL_TRANSACTION_TYPES MTT
WHERE 1=1
AND MMT.TRX_SOURCE_LINE_ID=WSH.SOURCE_LINE_ID
AND MMT.TRANSACTION_TYPE_ID=MTT.TRANSACTION_TYPE_ID
--AND MTT.TRANSACTION_TYPE_NAME IN ('Sales order issue')
AND MTT.TRANSACTION_TYPE_NAME IN ('Sales Order Pick')
AND SHIPMENT_PRIORITY_CODE='DO/SCOU/1442196'