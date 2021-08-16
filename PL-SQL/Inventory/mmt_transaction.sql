--select  
--    ORGANIZATION_CODE,
--ITEM_CODE,
--DESCRIPTION,
--PRIMARY_UOM_CODE,
--LOT_NUMBER,
--sum(nvl(primary_qty,0)) QTY
--from (

select
--    *
    mmt.transaction_id,
    mmt.reason_id,
    mmt.rcv_transaction_id,
    mmt.trx_source_line_id,
    mtt.transaction_type_name,
    mmt.transaction_source_id,
    mmt.transaction_source_name,
    mc.segment1 item_category,
    mc.segment2 item_type,
    mmt.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
--    msi.segment2 dia,
    msi.primary_uom_code,
    msi.secondary_uom_code,
    mtln.lot_number,
    mmt.SHIPMENT_NUMBER,
    ood1.organization_code,
    ood2.organization_code transfer_organization,
    mmt.subinventory_code,
    mmt.transfer_subinventory,
    mil.segment1||'.'||mil.segment2||'.'||mil.segment3 item_Locator,
    mmt.transaction_date,
    mmt.distribution_account_id,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 dist_acc_code,
    mmt.transaction_reference,
    to_char(trunc(mmt.transaction_date),'MON-YYYY') Txn_period,
--    trunc(mmt.transaction_date) txn_date,
--    mmt.transaction_quantity,
    mmt.prior_costed_quantity,mmt.prior_cost,
    nvl(mtln.primary_quantity,mmt.primary_quantity) primary_qty,
    nvl(mtln.transaction_quantity,mmt.transaction_quantity) transaction_qty,
    mmt.transaction_uom,
    nvl(mtln.secondary_transaction_quantity,mmt.secondary_transaction_quantity) secondary_transaction_qty,
    apps.fnc_get_item_cost(mmt.transfer_organization_id,mmt.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')) dest_item_cost,
    apps.fnc_get_item_cost(mmt.organization_id,mmt.inventory_item_id,to_char(trunc(mmt.transaction_date),'MON-YY')) source_item_cost,
    nvl(mmt.transaction_cost,mmt.actual_cost) txn_cost
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
    gl.gl_code_combinations gcc
where
--    mmt.transaction_id in ()
--    and 
--    ood1.legal_entity=ood2.legal_entity
--    and 
    ood1.legal_entity=23279
    and 
    ood1.operating_unit=85
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id
    and ood1.organization_id=mmt.organization_id
    and mmt.organization_id in (101) 
--    and ood1.organization_code in ('SPS')
    and mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.transfer_organization_id=ood2.organization_id(+)
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_set_id=1
    and mic.category_id=mc.category_id
    and mmt.transaction_id=mtln.transaction_id(+)
    and mmt.locator_id=mil.inventory_location_id(+)
--    and mmt.reason_id is null
--    and mtln.lot_number='G.VSCN.9/1'
--    and mc.segment1 in ('WIP','FINISH GOODS')
--    and mc.segment1 in ('INGREDIENT')
--    and mc.segment1 in ('WIP','FINISH GOODS')
--    and mc.segment1 in ('FINISH GOODS')
--    and mc.segment2 like '%GRINDING MEDIA%'
--    and mc.segment2 like '%CAST%'
--    and mc.segment2 like '%UNPACKED%'
--    and mc.segment2 like '%WORKING%'
--    and mc.segment2 like '%HR COIL%'
--    and mmt.transaction_source_type_id=5
--    and mmt.transaction_source_name like ('%LOAN%')
--    and mmt.transaction_source_id='10521203'
--    and mmt.trx_source_line_id=9103548
--    and trunc(mmt.transaction_date) between '01-JUL-2017' and '31-JUL-2017'-->'01-AUG-2016'--<'01-DEC-2016'--<'01-NOV-2016'----
--    and msi.inventory_item_id=14014
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('DRCT.GYPS.0001')--('CN26.0V07.3201')--('WMLD.LTAP.0002')
--    and msi.segment1 in ('GPNF','GPCG')
--    and upper(msi.description) like '%TYRE%MICRO%195%R%'
--    and mmt.logical_transaction is null
--    and mmt.subinventory_code like '%CER-PACKIN%'----'CER%CEN%'---
--    and (mmt.subinventory_code in ('CER-MOLD')
--    and mmt.transfer_subinventory in ('CER-MKTR')--='W MLD LINE'
--    and mmt.subinventory_code in ('W MLD LINE')--)--'UPCKD FG'--'CER-FG STR'
--    and mmt.subinventory_code in ('CER-MOLD')
--    and mmt.subinventory_code='BUFR TNK 6'
--    and nvl(mtln.primary_quantity,mmt.primary_quantity)>0
--    and logical
--    and mmt.transaction_type_id in (98,99)
--   and trunc(mmt.creation_date) between '01-JAN-2015' and '30-SEP-2015' 
--   and mmt.primary_quantity<0
--    and trunc(mmt.transaction_date) between '01-JAN-2016' and '31-OCT-2017'--'29-FEB-2016'--<'01-APR-2016'--<'01-JUL-2016'---<'01-JUL-2016'--='31-AUG-2016'--
--    and trunc(mmt.transaction_date) <'01-JUL-2017'--between '01-JAN-2017' and '28-FEB-2017'--<'01-APR-2016'--<'01-JUL-2016'---<'01-JUL-2016'--='31-AUG-2016'--
--    and ood2.organization_code='D11'
--    and mmt.transaction_type_id=63
--    and to_char(trunc(mmt.transaction_date),'MON-YY') in ('FEB-17')
--    and mtt.transaction_type_name in ('WIP Completion','WIP Completion Return')
--    and mtt.transaction_type_name like '%RMA%'
--      and mtt.transaction_type_name in ('Direct Org Transfer')
--    and mtt.transaction_type_name in ('WIP Issue','WIP Return')
--    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous issue','Miscellaneous receipt')
    and mtt.TRANSACTION_TYPE_NAME in ('Subinventory Transfer')--,'Miscellaneous issue')--
--        and mtt.TRANSACTION_TYPE_NAME in ('Sales order issue')--,'RMA Return','RMA Receipt','COGS Recognition')---('COGS Recognition')---
--        and mtt.TRANSACTION_TYPE_NAME in ('Average cost update')
        and mmt.distribution_account_id=gcc.code_combination_id(+)
--        and mtln.lot_number='173F25F19'
--        and gcc.segment3='4020109'
--    and mtt.transaction_source_type_id=5
    and mmt.logical_transaction is null
--    and mmt.transaction_type_id in (12,21)--105
--    and mmt.shipment_number in ('ITR/PRT/2656')
--    and mmt.transaction_id in (116898374)
--    and mmt.rcv_transaction_id in ()
--    and mmt.transaction_set_id in ()
--    and mmt.transaction_id in  (select distinct voucher_number--*
--from
--    apps.xxakg_gl_details_statement_mv
--where
--    company='2200'
--    and account='2050103'
--    and je_source='INV'
--    and je_category='Miscellaneous Transaction'--'OPM/OM Shipments'
----    and trunc(voucher_date) <'01-MAR-2015'
--    )
--    and mmt.transaction_id in (120122163)    
--    and (mmt.transaction_id in (115382806)
--    or mmt.transfer_transaction_id in (115382806))
------    and mmt.transaction_source_type_id=5
--    and mtt.transaction_type_name like 'Misc%'
--    and mmt.transaction_source_id in (1593701)
--    and mmt.transaction_source_name in ('SCI_FG_STOCK_REC_RM_NOT_RCV')
--    and mmt.transaction_source_name in ('CST_ZERO_MO_ADJ_DEC_2016')
--    and mmt.transaction_source_name in ('GRIND_MEDIA_CONSUMPTION_OCT_2016')
--    and mmt.transaction_source_name in ('MISC_STCOK_RCV_FOR_EXTRA_DLV_SEP_2017')--like ('%MOVE%ORDER%')
--    and mmt.transaction_quantity>0
--    and mmt.transaction_source_name in ('MRB_CTS_SHORT_STOCK_ADJUSTMENT_JUN_2016','MRB_SLAB_SHORT_STOCK_ADJUSTMENT_JUN_2016')
--    and  (mmt.transaction_id in (98863279,99478640,99478753,99478834) or mmt.transfer_transaction_id in (98863279,99478640,99478753,99478834))
--    and mmt.rcv_transaction_id in (1444944)
--    and mmt.inventory_item_id=271652
--    and mmt.transaction_id in (118423132,118423146)
--    and mmt.transaction_source_id in (1816887)
--    and mmt.rcv_transaction_id in (1701661) 
--    and rownum<10    
order by 
    mmt.transaction_id,
    mmt.transaction_date

--)
--group by
--    ORGANIZATION_CODE,
--ITEM_CODE,
--DESCRIPTION,
--PRIMARY_UOM_CODE,
--LOT_NUMBER
--where
--    txn_cost=0
