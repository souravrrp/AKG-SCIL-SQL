---------------------------**LOT_DETAILS**--------------------------------------
SELECT
MLN.INVENTORY_ITEM_ID
,OOD.ORGANIZATION_CODE WHAREHOUSE_ORG_CODE
,MLN.ORGANIZATION_ID
,MLN.LOT_NUMBER
,MLN.CREATION_DATE
,MLN.ORIGINATION_DATE
--,( SELECT FU.USER_NAME FROM APPS.FND_USER FU WHERE FU.USER_ID=MLN.CREATED_BY) EMPLOYEE_ID
,APPS.XXAKG_COM_PKG.GET_USER_NAME(MLN.CREATED_BY) ||'-'|| APPS.XXAKG_COM_PKG.GET_EMP_NAME_FROM_USER_ID(MLN.CREATED_BY) CREATED_BY_USER
,MLN.*
FROM
INV.MTL_LOT_NUMBERS MLN
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE 1=1
AND OOD.ORGANIZATION_ID=MLN.ORGANIZATION_ID
AND MLN.LOT_NUMBER=:P_LOT_NUMBER    --IN --


---------------------------**LOT_TRANSACTION**----------------------------------
SELECT
MTLN.TRANSACTION_ID
,MTLN.INVENTORY_ITEM_ID
,MTLN.ORGANIZATION_ID
,MTLN.TRANSACTION_DATE
,MTLN.TRANSACTION_SOURCE_TYPE_ID
,MTLN.TRANSACTION_SOURCE_NAME
,MTLN.TRANSACTION_QUANTITY
,MTLN.PRIMARY_QUANTITY
,MTLN.LOT_NUMBER
,MTLN.ORIGINATION_DATE
,MTLN.*
FROM
INV.MTL_TRANSACTION_LOT_NUMBERS MTLN
WHERE 1=1
AND MTLN.LOT_NUMBER = :P_LOT_NUMBER --IN --


SELECT
*
FROM
APPS.MTL_TRANSACTION_LOT_VAL_V MTLT