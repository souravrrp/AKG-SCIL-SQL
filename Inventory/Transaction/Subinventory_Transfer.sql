    select
    mtt.transaction_type_name,
    TO_CHAR(mmt.transaction_date) transaction_date,
    mmt.transaction_source_name,
    mmt.SHIPMENT_NUMBER,
    mmt.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
    msi.primary_uom_code,
--    msi.secondary_uom_code,
    mtln.lot_number,
    mc.segment1 item_category,
    mc.segment2 item_type,
    ood1.organization_code,
    OOD1.ORGANIZATION_NAME,
    ood2.organization_code transfer_organization,
    mmt.subinventory_code,
    mmt.transfer_subinventory,
    to_char(trunc(mmt.transaction_date),'MON-YYYY') Txn_period,
    nvl(mtln.primary_quantity,mmt.primary_quantity) primary_qty,
    nvl(mtln.transaction_quantity,mmt.transaction_quantity) transaction_qty
    ,mmt.transaction_uom
--    ,wsh.shipment_priority_code DO_NUMBER
--    ,WSH.RELEASED_STATUS_NAME DELIVERY_STATUS
    ,mmt.TRANSACTION_REFERENCE
------------------------------------------------------------------------------------------------------------
--        ,mmt.transaction_quantity
--    mil.segment1||'.'||mil.segment2||'.'||mil.segment3 item_Locator,
--    mmt.prior_costed_quantity,
--    mmt.prior_cost,
--    nvl(mtln.primary_quantity,mmt.primary_quantity) primary_qty,
--    nvl(mtln.transaction_quantity,mmt.transaction_quantity) transaction_qty,
--    nvl(mtln.secondary_transaction_quantity,mmt.secondary_transaction_quantity) secondary_transaction_qty,
--    apps.fnc_get_item_cost(mmt.transfer_organization_id,mmt.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')) dest_item_cost,
--    apps.fnc_get_item_cost(mmt.organization_id,mmt.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')) source_item_cost,
--    nvl(mmt.transaction_cost,mmt.actual_cost) txn_cost
--    mmt.*
from
    inv.mtl_material_transactions mmt,
    inv.mtl_transaction_lot_numbers mtln,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    inv.mtl_transaction_types mtt,
    apps.org_organization_definitions ood1,
    apps.org_organization_definitions ood2,
    inv.mtl_item_locations mil,
    gl.gl_code_combinations gcc,
    apps.wsh_deliverables_v wsh
where 1=1
    and mmt.trx_source_line_id=wsh.source_line_id(+)
    and ood1.operating_unit=85
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and ood1.organization_id=mmt.organization_id
--    and mmt.organization_id in (1525) 
--    and ood1.organization_code in ('G09')
    and mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.transfer_organization_id=ood2.organization_id(+)
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_set_id=1
    and mic.category_id=mc.category_id
    and mmt.transaction_id=mtln.transaction_id(+)
    and mmt.locator_id=mil.inventory_location_id(+)
    and mmt.distribution_account_id=gcc.code_combination_id(+)
--    and mmt.logical_transaction is null
--    and mmt.transfer_subinventory in ('G27-STAGIN')--='W MLD LINE'
    AND mmt.subinventory_code='DUMMY FG'
        and trunc(mmt.transaction_date) between '30-SEP-2018' and '08-OCT-2018'
--    and to_char(trunc(mmt.transaction_date),'MON-YY') in ('SEP-18')
--    and to_char(trunc(mmt.transaction_date),'RRRR') in ('2018')
--    and mmt.SHIPMENT_NUMBER='TO/SCOU/082666'
--    and wsh.shipment_priority_code=:p_shipment_priority_code
--    and mtt.TRANSACTION_TYPE_NAME in ('Sales Order Pick')
--    and mtt.TRANSACTION_TYPE_NAME in ('Sales order issue')
--    and mtt.transaction_type_name in ('Direct Org Transfer')
--    and mtt.TRANSACTION_TYPE_NAME in ('Subinventory Transfer')
--    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous receipt')
--    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous issue')
--    and mtt.transaction_type_name in ('WIP Completion','WIP Completion Return')
--    and mtt.transaction_type_name like ('RMA Receipt','RMA Return')
--    and mtt.transaction_type_name in ('WIP Issue','WIP Return')
--    and mtt.TRANSACTION_TYPE_NAME in ('COGS Recognition')
--    and mtt.TRANSACTION_TYPE_NAME in ('Average cost update')
--    and mmt.transaction_source_name in ('SCRAP_STOCK_RECEIVE_FOR_DELIVERY_JUNE_2018')
--AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.OBAG.0001')
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.SBAG.0001','CMNT.SBAG.0003','CMNT.PBAG.0001','CMNT.PBAG.0003','CMNT.OBAG.0001','CMNT.SBLK.0001','CMNT.PBLK.0001','CMNT.OBLK.0001','CMNT.CBAG.0001','CMNT.CBLK.0001','CMNT.CBAG.0003')
--    and mmt.reason_id is null
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
AND ORGANIZATION_CODE=:P_ORGANIZATION_CODE--'SCI'
--AND OPERATING_UNIT=:P_OPERATING_UNIT--85
AND MSI.DISABLE_DATE IS NULL