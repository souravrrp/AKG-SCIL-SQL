select *
from apps.mtl_material_transactions
where INVENTORY_ITEM_ID=24440
and shipment_number in ('ITR/PRT/13348')
--and subinventory_code='SCS-BRAND'
--and transfer_subinventory='SCS-REGION'
--and transaction_id=98319142
order by TRANSACTION_DATE desc

select * from apps.mtl_item_locations
where INVENTORY_LOCATION_ID=5563

SELECT * FROM APPS.mtl_txn_request_headers

SELECT * FROM apps.po_headers_all
where segment1='L/SCOU/022168'

select * from apps.MTL_ONHAND_TOTAL_MWB_V
where locator_id is not null

select * from apps.mtl_system_items msi
where msi.segment1||'.'||msi.segment2||'.'||msi.segment3='BRND.GIFT.0079'

select * from apps.org_organization_definitions

select * from apps.per_people_f
where employee_number=4017

select * from apps.fnd_user
where user_id=2372

select * from apps.mtl_transaction_types
where TRANSACTION_TYPE_ID in (3,18)

select distinct ----mmt.*,
        msi.inventory_item_id
        ,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item
        ,msi.description
        ,mmt.subinventory_code subinventory
--        ,mmt.locator_id
        ,mil.segment1||'.'||mil.segment2||'..' location
--        ,mmt.transfer_subinventory
--        ,mil1.segment1||'...' transfer_locator
--        ,ood1.organization_code transfer_org
        ,ood.organization_name owning_party
        ,mmt.transaction_date
--        ,mmt.transaction_id
        ,mmt.transaction_quantity
        ,mmt.transaction_UOM
--        ,mmt.primary_quantity
--        ,mmt.actual_cost
--        ,mmt.transaction_cost
--        ,mmt.prior_cost
--        ,mmt.new_cost
--        ,mmt.transaction_source_type_id
        ,mtst.transaction_source_type_name
        ,mtt.transaction_type_name
--        ,mmt.transaction_source_name
        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
        ,pha.segment1 po_number
        ,pha.created_by
        ,ppf.full_name po_creator
--        ,rsh.receipt_num
--        ,rsh.shipment_num
        ,mtrh.request_number
        ,mtrh.created_by
        ,ppf2.full_name mo_creator
from 
        apps.mtl_material_transactions mmt
        ,apps.mtl_transaction_types mtt
        ,apps.mtl_item_locations mil
        ,apps.mtl_item_locations mil1
        ,apps.mtl_system_items msi
        ,apps.org_organization_definitions ood
        ,apps.org_organization_definitions ood1
        ,apps.mtl_txn_source_types mtst    
        ,apps.po_headers_all pha   
--        ,apps.rcv_transactions rt
--        ,apps.rcv_shipment_headers rsh
        ,apps.mtl_txn_request_headers mtrh        
        ,apps.mtl_txn_request_lines mtrl
        ,apps.gl_code_combinations gcc
        ,apps.fnd_user fu
        ,apps.fnd_user fu2
        ,apps.per_people_f ppf
        ,apps.per_people_f ppf2
where 1=1
        and msi.inventory_item_id=mmt.inventory_item_id
        and msi.organization_id=mmt.organization_id
        and mmt.organization_id=ood.organization_id
        and msi.organization_id=ood.organization_id
        and mmt.transfer_organization_id=ood1.organization_id(+)
        and mmt.transaction_type_id=mtt.transaction_type_id
        and mmt.transaction_source_type_id=mtt.transaction_source_type_id
        and mmt.transaction_source_type_id=mtst.transaction_source_type_id
        and mmt.distribution_account_id=gcc.code_combination_id
        and
         (
        mmt.transaction_source_id=pha.po_header_id(+)
--        and mmt.rcv_transaction_id=rt.transaction_id
--        and mmt.source_line_id=rt.transaction_id
--        and rt.shipment_header_id=rsh.shipment_header_id
                and
               (
               mmt.transaction_source_id=mtrh.header_id(+)
               and mmt.trx_source_line_id=mtrl.line_id(+)
               and mmt.move_order_line_id=mtrl.line_id(+)
               and mtrh.organization_id(+)=mmt.organization_id
                )
            )
        and mmt.locator_id=mil.inventory_location_id(+)
        and mmt.organization_id=mil.organization_id(+)
        and mmt.locator_id=mil1.inventory_location_id(+)
        and mmt.organization_id=mil1.organization_id(+)
        and pha.created_by=fu.user_id(+)
        and fu.user_name=ppf.employee_number(+)
        and mtrh.created_by=fu2.user_id(+)
        and fu2.user_name=ppf2.employee_number(+)
--        and mmt.locator_id is not null
        and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('BRND.GIFT.0097')
--        and mmt.subinventory_code='SCS-BRAND'
--        and mmt.transaction_id=84828725
--        and pha.created_by=15359
--        and mtrh.created_by=4022        
        and mmt.subinventory_code like ('SCS-BRAND')
--        and pha.segment1 in ('I/COU/000979')
--        and mtst.transaction_source_type_name in ('Inventory')
--        and mtt.transaction_type_name in ('Miscellaneous receipt','Miscellaneous issue')
--        and mmt.transaction_date between '01-APR-2018' and '01-MAY-2018'
--        and mmt.transaction_date = '30-SEP-2018' 
--        and ood.operating_unit in (85)
--        and sysdate between ppf.effective_start_date and ppf.effective_end_date
--        and sysdate between ppf2.effective_start_date and ppf2.effective_end_date

select * from apps.mtl_lot_numbers
where INVENTORY_ITEM_ID in ('526383')
and ORGANIZATION_ID in ('99')


select 
    *
from
    apps.rcv_shipment_headers rsh
    ,apps.rcv_transactions rt
where 1=1
--    and attribute_category in ('Lime Stone Mother Vessel List')
    and rsh.shipment_num like ('ITR/PRT/%')
    and rsh.shipment_header_id = rt.shipment_header_id
    and rsh.ship_to_org_id = rt.organization_id



select * from apps.mtl_material_transactions
where 1=1
    and rcv_transaction_id in (2819905)