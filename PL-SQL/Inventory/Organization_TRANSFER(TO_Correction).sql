SELECT
    mtt.transaction_type_name,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
    msi.primary_uom_code,
    ood.organization_code,
    OOD.ORGANIZATION_NAME,
    mmt.subinventory_code,
    mmt.transfer_subinventory,
    TO_CHAR(mmt.transaction_date) transaction_date,
    to_char(trunc(mmt.transaction_date),'MON-YYYY') Txn_period,
    mmt.transaction_quantity
  ,mmt.TRANSACTION_REFERENCE
from
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    inv.mtl_transaction_types mtt,
    apps.org_organization_definitions ood
where 1=1
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and ood.organization_id=mmt.organization_id
    and mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.transaction_source_type_id=mtt.transaction_source_type_id
    and mmt.transaction_action_id=mtt.transaction_action_id
    and mmt.logical_transaction is null
    AND mmt.TRANSACTION_REFERENCE IS NOT NULL
    AND     OOD.OPERATING_UNIT=85--:P_ORG_ID
--    AND     (:P_WAREHOUSE_ID IS NULL OR (OOD.organization_id = :P_WAREHOUSE_ID))
--    AND     (:P_WAREHOUSE_CODE IS NULL OR (OOD.organization_code = :P_WAREHOUSE_CODE))
    AND msi.primary_uom_code IN ('BAG','MTN')
--        and mmt.SHIPMENT_NUMBER IN ('TO/SCOU/078100')
--    AND mmt.subinventory_code='DUMMY FG'
--    and mmt.transfer_subinventory LIKE ('%DUMMY FG%')
--    and mmt.transfer_subinventory LIKE ('%'||:P_SUBINVENTORY_ORG||'%STORE%')
--    and mmt.transfer_subinventory LIKE ('%'||:P_SUBINVENTORY_ORG||'%STAGIN%')
--        AND TO_CHAR (mmt.transaction_date, 'DD-MON-RR') =:P_Transaction_Date--'30-AUG-18'
--       AND TRUNC(MMT.TRANSACTION_DATE)>'28-FEB-2018'
--    AND TO_CHAR (mmt.transaction_date, 'DD-MON-RR') ='23-OCT-18'
--    AND TO_CHAR (mmt.transaction_date, 'MON-RR') =:P_PERIOD_NAME-- 'JAN-18'
--    AND TO_CHAR (mmt.transaction_date, 'RRRR') =:P_YEAR-- '2018'
--    and wsh.shipment_priority_code=:p_DO_NUMBER
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.SBAG.0001','CMNT.SBAG.0003','CMNT.PBAG.0001','CMNT.PBAG.0003','CMNT.OBAG.0001','CMNT.SBLK.0001','CMNT.PBLK.0001','CMNT.OBLK.0001','CMNT.CBAG.0001','CMNT.CBLK.0001','CMNT.CBAG.0003')
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('CMNT.SBAG.0001','CMNT.SBAG.0003')--('CN26.0V07.3201')--('WMLD.LTAP.0002')
--    and mtt.TRANSACTION_TYPE_NAME in ('Sales Order Pick')
--    and mtt.TRANSACTION_TYPE_NAME in ('Sales order issue')
    and mtt.TRANSACTION_TYPE_NAME in ('Direct Org Transfer')
--    and mtt.TRANSACTION_TYPE_NAME in ('Subinventory Transfer')
--    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous receipt')
--    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous issue')
--    and mmt.TRANSACTION_REFERENCE in ('[Mail: Mr. Shohel 23-OCT-18;MTO/SCOU/059698;TO/SCOU/084899]')
order by 
    mmt.transaction_id,
    mmt.transaction_date
    
    
    
    
--------------------------------ORGANIZATION DETIALS-----------------------------------


SELECT
OOD.OPERATING_UNIT,
OOD.ORGANIZATION_NAME,
OOD.ORGANIZATION_CODE,
OOD.ORGANIZATION_ID,
MSI.SECONDARY_INVENTORY_NAME SUBINVENTORY_CODE,
MSI.DESCRIPTION SUBINVENTORY_NAME,
OOD.BUSINESS_GROUP_ID,
OOD.SET_OF_BOOKS_ID,
OOD.CHART_OF_ACCOUNTS_ID
--,OOD.*
--,MSI.*
FROM
APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
APPS.MTL_SECONDARY_INVENTORIES MSI
WHERE 1=1
AND MSI.ORGANIZATION_ID=OOD.ORGANIZATION_ID
--OPERATING UNIT: LEDGER_ID--MASTER_ORG
--ORGANIZATION_NAME--ORGANIZATION_CODE
--ORGANIZATION_ID: SUB-LEDGER_ID
--BUSINESS_GROUP_ID: INVENTORY_ID
--AND OOD.ORGANIZATION_ID=:P_ORGANIZATION_ID--101
--AND ORGANIZATION_CODE IN ('SCI')
AND (   :P_OPERATING_UNIT IS NULL
            OR (OOD.OPERATING_UNIT = :P_OPERATING_UNIT))
AND (   :P_ORGANIZATION_CODE IS NULL
            OR (OOD.ORGANIZATION_CODE = :P_ORGANIZATION_CODE))
AND     (:P_ORG_NAME IS NULL OR (UPPER(OOD.ORGANIZATION_NAME) LIKE UPPER('%'||:P_ORG_NAME||'%') ))
--AND OPERATING_UNIT=:P_OPERATING_UNIT--85
AND MSI.DISABLE_DATE IS NULL


-----------------------------Checking--------------------------------------------------------

SELECT
    mtt.transaction_type_name,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
    msi.primary_uom_code,
    ood.organization_code,
    OOD.ORGANIZATION_NAME,
    mmt.subinventory_code,
    mmt.transfer_subinventory,
    TO_CHAR(mmt.transaction_date) transaction_date,
    to_char(trunc(mmt.transaction_date),'MON-YYYY') Txn_period,
    mmt.transaction_quantity
  ,mmt.TRANSACTION_REFERENCE
from
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    inv.mtl_transaction_types mtt,
    apps.org_organization_definitions ood
where 1=1
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and ood.organization_id=mmt.organization_id
    and mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.transaction_source_type_id=mtt.transaction_source_type_id
    and mmt.transaction_action_id=mtt.transaction_action_id
    and mmt.logical_transaction is null
    AND mmt.TRANSACTION_REFERENCE IS NOT NULL
    AND     OOD.OPERATING_UNIT=85--:P_ORG_ID
--    AND     (:P_WAREHOUSE_ID IS NULL OR (OOD.organization_id = :P_WAREHOUSE_ID))
--    AND     (:P_WAREHOUSE_CODE IS NULL OR (OOD.organization_code = :P_WAREHOUSE_CODE))
    AND msi.primary_uom_code IN ('BAG','MTN')
--    AND mmt.subinventory_code='DUMMY FG'
--    and mmt.transfer_subinventory LIKE ('%DUMMY FG%')
--    and mmt.transfer_subinventory LIKE ('%'||:P_SUBINVENTORY_ORG||'%STORE%')
--    and mmt.transfer_subinventory LIKE ('%'||:P_SUBINVENTORY_ORG||'%STAGIN%')
--        AND TO_CHAR (mmt.transaction_date, 'DD-MON-RR') ='11-SEP-18'
--    AND TO_CHAR (mmt.transaction_date, 'MON-RR') =:P_PERIOD_NAME-- 'JAN-18'
--    AND TO_CHAR (mmt.transaction_date, 'RRRR') =:P_YEAR-- '2018'
--    and wsh.shipment_priority_code=:p_DO_NUMBER
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.SBAG.0001','CMNT.SBAG.0003','CMNT.PBAG.0001','CMNT.PBAG.0003','CMNT.OBAG.0001','CMNT.SBLK.0001','CMNT.PBLK.0001','CMNT.OBLK.0001','CMNT.CBAG.0001','CMNT.CBLK.0001','CMNT.CBAG.0003')
AND mtt.TRANSACTION_TYPE_NAME in ('Direct Org Transfer')
AND mmt.TRANSACTION_REFERENCE LIKE  ('%'||:TO_NUMBER||'%') 
order by 
    mmt.transaction_id,
    mmt.transaction_date
    
    
--------------------------TRANSFER_FROMAT----------------------------------------------

SELECT
--TDL.TO_NUMBER,
TDL.ITEM_NUMBER,
--TDL.FROM_SUBINV FROM_SUBINVENTORY,
--TDL.TO_SUBINV TO_SUBINVENTORY,
TDL.TO_SUBINV FROM_SUBINVENTORY,
TDL.FROM_SUBINV TO_SUBINVENTORY,
TDL.UOM_CODE,
TDL.QUANTITY,
--'[Mail: Mr. Asraf Amin 21-SEP-19;'||TMH.MOV_ORDER_NO||';'||TDL.TO_NUMBER||']' DESCRIPTION
--'[Mail: Mr. Enayet 21-SEP-19;'||TMH.MOV_ORDER_NO||';'||TDL.TO_NUMBER||']' DESCRIPTION
--'[Mail: Mr. Shohel 21-SEP-19;'||TMH.MOV_ORDER_NO||';'||TDL.TO_NUMBER||']' DESCRIPTION
--'[Mail: Mr. Shohel 21-SEP-19;'||TMH.MOV_ORDER_NO||';'||TDL.TO_NUMBER||'; Change Item (SP Stitch to SP)]' DESCRIPTION
--'[Mail: Mr. Shohel 21-SEP-19;'||TMH.MOV_ORDER_NO||';'||TDL.TO_NUMBER||'; Partially Transact]' DESCRIPTION
'[Mail: Mr. Majhar 01-SEP-19;'||TMH.MOV_ORDER_NO||';'||TDL.TO_NUMBER||']' DESCRIPTION
FROM
XXAKG.XXAKG_TO_MO_HDR TMH,
APPS.XXAKG_TO_MO_DTL TMD,
APPS.XXAKG_TO_DO_HDR TDH,
XXAKG.XXAKG_TO_DO_LINES TDL
WHERE 1=1
AND TMH.ORG_ID=85
AND TMD.TO_HDR_ID=TDL.TO_HDR_ID
AND TDH.TO_HDR_ID=TDL.TO_HDR_ID
AND TMD.MOV_ORD_HDR_ID=TMH.MOV_ORD_HDR_ID
--AND TDL.TO_INV='G06'
--AND TDH.TO_STATUS='GENERATED'
--AND TMH.MOV_ORDER_STATUS='CONFIRMED'
--AND TMH.MOV_ORDER_NO='MTO/SCOU/054916'
AND TDL.TO_NUMBER IN ('TO/SCOU/103685',
'TO/SCOU/103432',
'TO/SCOU/103431',
'TO/SCOU/103971',
'TO/SCOU/104075'
)
--='TO/SCOU/078937'
--AND TO_CHAR (TMH.MOV_ORDER_DATE, 'MON-RR') =:P_PERIOD_NAME-- 'JAN-18'
--AND TO_CHAR (TMH.MOV_ORDER_DATE, 'RRRR') =:P_YEAR-- '2018'
ORDER BY TO_SUBINV
    
    
    
    
-------------------------On Hand-------------------------------------------------------------

SELECT
OOD.OPERATING_UNIT,
OOD.ORGANIZATION_NAME,
OOD.ORGANIZATION_CODE,
OOD.ORGANIZATION_ID,
OHQD.SUBINVENTORY_CODE,
--MSI.DESCRIPTION SUBINVENTORY_NAME,
OHQD.LOT_NUMBER,
MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3 ITEM_CODE,
MSIB.DESCRIPTION,
--OHQD.INVENTORY_ITEM_ID,
SUM(OHQD.PRIMARY_TRANSACTION_QUANTITY) as "ONHAND_QUANTITY",
OHQD.TRANSACTION_UOM_CODE UOM_CODE
FROM
APPS.MTL_ONHAND_QUANTITIES_DETAIL OHQD,
APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
--APPS.MTL_SECONDARY_INVENTORIES MSI,
APPS.MTL_SYSTEM_ITEMS_B MSIB
WHERE 1=1
AND MSIB.ORGANIZATION_ID=OOD.ORGANIZATION_ID
AND OHQD.ORGANIZATION_ID=OOD.ORGANIZATION_ID
--AND MSI.ORGANIZATION_ID=OOD.ORGANIZATION_ID
AND OHQD.INVENTORY_ITEM_ID=MSIB.INVENTORY_ITEM_ID
AND OOD.OPERATING_UNIT=85--:P_OPERATING_UNIT
AND OOD.ORGANIZATION_CODE='G13'--:P_ORGANIZATION_CODE
--AND OHQD.ORGANIZATION_ID=:P_ORGANIZATION_ID-- IN ('101','113','1345','1346')
--AND OHQD.SUBINVENTORY_CODE='BAG CEMENT'
--AND MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3 IN ('CMNT.SBAG.0001')
AND MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3 IN ('CMNT.SBAG.0001','CMNT.SBAG.0003','CMNT.PBAG.0001','CMNT.PBAG.0003','CMNT.OBAG.0001','CMNT.SBLK.0001','CMNT.PBLK.0001','CMNT.OBLK.0001','CMNT.CBAG.0001','CMNT.CBLK.0001','CMNT.CBAG.0003')
GROUP BY
OOD.OPERATING_UNIT,
MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3,
MSIB.DESCRIPTION,
OHQD.INVENTORY_ITEM_ID,
OHQD.LOT_NUMBER,
OHQD.SUBINVENTORY_CODE,
--MSI.DESCRIPTION,
OHQD.TRANSACTION_UOM_CODE,
OOD.ORGANIZATION_ID,
OOD.ORGANIZATION_CODE,
OOD.ORGANIZATION_NAME
    

------------------------TO_DETILAS---------------------------------------------------------

SELECT
TDL.TO_NUMBER,
--TDH.TO_STATUS,
TMH.MOV_ORDER_NO,
--TMH.MOV_ORDER_STATUS,
TDL.ITEM_NUMBER,
--TDL.ITEM_DESCRIPTION,
--TDL.UOM_CODE,
TMH.FROM_INV,
TDL.TO_INV,
TMH.FINAL_DESTINATION,
TMH.TRANSPORT_MODE,
TMH.VEHICLE_NO
--TMH.INITIAL_GATE_IN,
--TMH.GATE_OUT,
--TMH.GATE_IN
,TO_CHAR(TDH.TO_DATE) To_DATE
,TO_CHAR(TMH.MOV_ORDER_DATE) MTO_DATE
,TDL.FROM_SUBINV
,TDL.TO_SUBINV
,TDL.QUANTITY
,TDH.TO_STATUS TO_STATUS
,TMH.MOV_ORDER_STATUS MTO_STATUS
--,TDH.*
FROM
XXAKG.XXAKG_TO_MO_HDR TMH,
APPS.XXAKG_TO_MO_DTL TMD,
APPS.XXAKG_TO_DO_HDR TDH,
XXAKG.XXAKG_TO_DO_LINES TDL
WHERE 1=1
AND TMH.ORG_ID=85
AND TMD.TO_HDR_ID=TDL.TO_HDR_ID
AND TDH.TO_HDR_ID=TDL.TO_HDR_ID
AND TMD.MOV_ORD_HDR_ID=TMH.MOV_ORD_HDR_ID
AND TDH.TO_STATUS='CONFIRMED'
--AND TMH.MOV_ORDER_STATUS='CONFIRMED'
--AND TMH.MOV_ORDER_NO='MTO/SCOU/054916'
AND TDL.TO_NUMBER IN ('TO/SCOU/103685',
'TO/SCOU/103432',
'TO/SCOU/103431',
'TO/SCOU/103971',
'TO/SCOU/104075'
)   
--AND TO_CHAR (TMH.MOV_ORDER_DATE, 'MON-RR') =:P_PERIOD_NAME-- 'JAN-18'
--AND TO_CHAR (TMH.MOV_ORDER_DATE, 'RRRR') =:P_YEAR-- '2018'
--AND TMH.FROM_INV='SCI'
--AND TDL.TO_INV='G10'
AND EXISTS (SELECT 1 FROM INV.MTL_MATERIAL_TRANSACTIONS MMT WHERE MMT.SHIPMENT_NUMBER=TDL.TO_NUMBER)
ORDER BY TDL.TO_INV
