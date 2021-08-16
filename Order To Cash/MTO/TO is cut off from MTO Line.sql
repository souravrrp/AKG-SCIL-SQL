select
    mmt.transaction_id,
    mtt.transaction_type_name,
    mmt.transaction_source_name,
    mc.segment1 item_category,
    mc.segment2 item_type,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
--    msi.segment2 dia,
    msi.primary_uom_code,
    mtln.lot_number,
    mmt.SHIPMENT_NUMBER,
    ood1.organization_code,
    ood2.organization_code transfer_organization,
    mmt.subinventory_code,
    mmt.transfer_subinventory,
    mmt.transaction_date,
    mmt.transaction_reference,
    to_char(trunc(mmt.transaction_date),'MON-YYYY') Txn_period,
--    trunc(mmt.transaction_date) txn_date,
--    mmt.transaction_quantity,
    nvl(mtln.primary_quantity,mmt.primary_quantity) primary_qty,
    nvl(mtln.transaction_quantity,mmt.transaction_quantity) transaction_qty,
    mmt.transaction_uom
--,mtt.transaction_source_type_id
  ,wsh.shipment_priority_code DO_NUMBER
  ,mmt.ATTRIBUTE3 MTO_NUMBER
  --,MMT.*
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
--    and ood2.organization_code='G12'
--    and mmt.organization_id in (1525) 
    and ood1.organization_code in ('SCI')
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
--    and to_char(trunc(mmt.transaction_date),'MON-YY') in ('SEP-18')
    and to_char(trunc(mmt.transaction_date),'RRRR') in ('2019')
    --and mmt.SHIPMENT_NUMBER='TO/SCOU/001152'
--    and wsh.shipment_priority_code=:p_shipment_priority_code
--    and mtt.TRANSACTION_TYPE_NAME in ('Sales Order Pick')
--    and mtt.TRANSACTION_TYPE_NAME in ('Sales order issue')
--    and mtt.transaction_type_name in ('Direct Org Transfer')
--    and mtt.TRANSACTION_TYPE_NAME in ('Subinventory Transfer')
--    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous receipt','Miscellaneous issue')
--    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous issue')
--    and mtt.transaction_type_name in ('WIP Completion','WIP Completion Return')
--    and mtt.transaction_type_name like ('RMA Receipt','RMA Return')
--    and mtt.transaction_type_name in ('WIP Issue','WIP Return')
--    and mtt.TRANSACTION_TYPE_NAME in ('COGS Recognition')
--    and mtt.TRANSACTION_TYPE_NAME in ('Average cost update')
--    and mmt.transaction_source_name in ('SCRAP_STOCK_RECEIVE_FOR_DELIVERY_JUNE_2018')
--    AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.OBAG.0001')
--    AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.SBAG.0001','CMNT.SBAG.0003','CMNT.PBAG.0001','CMNT.PBAG.0003','CMNT.OBAG.0001','CMNT.SBLK.0001','CMNT.PBLK.0001','CMNT.OBLK.0001','CMNT.CBAG.0001','CMNT.CBLK.0001','CMNT.CBAG.0003')
--    and mmt.reason_id is null
--    and mtln.lot_number='G.VSCN.9/1'
--    and mc.segment1 in ('WIP')
--    and mc.segment1 in ('INGREDIENT')
--    and mc.segment1 in ('FINISH GOODS')
--    and mc.segment2 like '%GRINDING MEDIA%'
--    and msi.segment1 in ('GPNF','GPCG')
--    and upper(msi.description) like '%TYRE%MICRO%195%R%'
--    and mmt.subinventory_code in ('CER-MOLD'%)
--    and nvl(mtln.primary_quantity,mmt.primary_quantity)>0
--    and mmt.primary_quantity<0
--    and trunc(mmt.transaction_date)>'30-APR-2018'-- between '01-JAN-2016' and '31-OCT-2017'--'29-FEB-2016'--<'01-APR-2016'--<'01-JUL-2016'---<'01-JUL-2016'--='31-AUG-2016'--
--    and wsh.shipment_priority_code='DO/SCOU/1194725'
--    and mmt.transaction_id in (161208652)
--    and gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5='2110.NUL.4020107.9999.00'
--    and mmt.transaction_source_id='10521203'
--    and mmt.trx_source_line_id=9103548
--    and msi.inventory_item_id='206571'
--    and mmt.transaction_type_id in (98,99)
--    and mtt.transaction_source_type_id=5
--    and  od1.legal_entity=ood2.legal_entity
--    and  ood1.legal_entity=23279
--    and mmt.transaction_type_id in (12,21)--105
--    and mmt.rcv_transaction_id in ()
--    and mmt.transaction_set_id in ()
AND EXISTS(SELECT 1 FROM APPS.XXAKG_TO_MO_HDR TMH WHERE TMH.MOV_ORDER_STATUS IN ('CONFIRMED','GENERATED') AND TMH.MOV_ORDER_NO=MMT.ATTRIBUTE3)
AND NOT EXISTS(SELECT 1 FROM APPS.XXAKG_TO_MO_DTL TMD WHERE TMD.TO_NUMBER=MMT.SHIPMENT_NUMBER)
order by 
    mmt.transaction_id,
    mmt.transaction_date