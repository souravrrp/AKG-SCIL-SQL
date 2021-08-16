select distinct 
        mtt.organization_code
        ,mtt.organization_name
        ,mtt.subinventory_code
        ,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item
        ,msi.description
        ,mtt.transaction_quantity
        ,mtt.transaction_uom
        ,mtt.secondary_transaction_quantity
        ,mtt.secondary_unit_of_measure
        ,mtt.overcompletion_transaction_qty
        ,mtt.transaction_type_name
        ,mtt.transaction_date
        ,mtt.transaction_header_id
        ,mtt.transaction_temp_id
        ,mtt.transaction_mode_m
        ,mtt.process_flag
        ,mtt.transaction_status_m
        ,mtt.error_code
        ,mtt.error_explanation
        ,mil.segment1||'.'||mil.segment2||'..' location
        ,mtt.transfer_subinventory
        ,mtt.transfer_org_code
        ,mtt.transfer_to_location
        ,mtt.transaction_action_name
        ,mtt.transaction_source_type_name
        ,mtt.transaction_source_id
        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 distribution_account
        ,mtt.transaction_cost
        ,mtt.transaction_reference
        ,mtt.reason_name
        ,mtt.lot_number
        ,mtt.lot_expiration_date
        ,mtt.serial_number
        ,mtt.shipment_number
        ,mtt.transfer_cost
        ,mtt.transportation_cost
        ,mtt.transportation_account
        ,mtt.freight_code
        ,mtt.containers
        ,mtt.waybill_airbill
        ,mtt.expected_arrival_date
        ,ppa.name project
        ,pt.task_number
        ,mtt.expenditure_type
from apps.mtl_transactions_temp_all_v mtt
        ,apps.mtl_system_items msi
        ,apps.mtl_item_locations mil
        ,apps.gl_code_combinations gcc
        ,apps.pa_projects_all ppa
        ,apps.pa_tasks pt
where 1=1
        and organization_code='SCS'
--        and msi.segment1||'.'||msi.segment2||'.'||msi.segment3='BRND.GIFT.0048'
        and msi.inventory_item_id=mtt.inventory_item_id
        and msi.organization_id=mtt.organization_id
        and mtt.locator_id=mil.inventory_location_id(+)
        and mtt.distribution_account_id=gcc.code_combination_id(+)
        and mtt.source_project_id=ppa.project_id(+)
        and mtt.source_task_id=pt.task_id(+)

select * from apps.mtl_system_items
where segment1||'.'||segment2||'.'||segment3='BRND.GIFT.0048'