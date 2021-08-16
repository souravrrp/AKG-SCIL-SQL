SELECT moq.organization_id,
               moq.inventory_item_id,
               msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
               msi.description,
               moq.lot_number,
               moq.subinventory_code,
               SUM (moq.primary_transaction_quantity) target_qty,
--               apps.fnc_get_item_cost(moq.organization_id,moq.inventory_item_id,'JAN-15') item_cost,
               SUM (moq.SECONDARY_TRANSACTION_QUANTITY) s_target_qty
FROM 
          apps.mtl_onhand_quantities_detail moq,
          inv.mtl_system_items_b msi,
          apps.org_organization_definitions ood
where
    moq.organization_id=ood.organization_id
    and ood.organization_code='CER'
    and moq.organization_id=msi.organization_id
    and moq.inventory_item_id=msi.inventory_item_id
--    and msi.segment1||'.'||msi.segment2||'.'||MSI.SEGMENT3 = 'RPWB.CNMI.0001'
--    and msi.segment1||'.'||msi.segment2||'.'||MSI.SEGMENT3 in ('CMNT.SBLK.0001')
     --and msi.segment1 = 'RPWB'
     --and msi.segment2 like 'IM%'
--    and moq.lot_number in ()          
group by
    moq.organization_id,
               moq.inventory_item_id,
               msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
               msi.description,
               moq.lot_number,
               moq.subinventory_code



 SELECT 
    segment1||'.'||segment2||'.'||segment3 Item_code,
    description
FROM
     inv.mtl_system_items_b
 WHERE
     segment1 = 'RPAP'
     and segment2 like 'OR%'
 GROUP BY
    segment1||'.'||segment2||'.'||segment3,
    description