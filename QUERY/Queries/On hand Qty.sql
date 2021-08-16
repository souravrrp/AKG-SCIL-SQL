SELECT moq.organization_id,
            ood.organization_code,
            mc.segment1 Item_Category,
            mc.segment2 item_type,
               moq.inventory_item_id,
               msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
               msi.description,
               msi.primary_uom_code,
               moq.subinventory_code,
               moq.lot_number,
               SUM (moq.primary_transaction_quantity) target_qty,
--               apps.fnc_get_item_cost(moq.organization_id,moq.inventory_item_id,'APR-15') item_cost,
               SUM (moq.SECONDARY_TRANSACTION_QUANTITY) s_target_qty
FROM 
          apps.mtl_onhand_quantities_detail moq,
          inv.mtl_system_items_b msi,
          inv.mtl_item_categories mic,
          inv.mtl_categories_b mc,
          apps.org_organization_definitions ood
where
    moq.organization_id=ood.organization_id
    and ood.organization_code='CER'
    and moq.organization_id=msi.organization_id
    and moq.inventory_item_id=msi.inventory_item_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
--    and mc.segment1 in ('FINISH GOODS')
--    and mc.segment1 in ('MECHANICAL')
    and msi.segment1||'.'||msi.segment2||'.'||MSI.SEGMENT3 in ('DRCT.CLAY.0005')
    and moq.subinventory_code='CER-SP FLR'
--    and msi.segment1 = 'TYRE'
--    and moq.lot_number not like  ('%MAY-2015%')          
group by
    moq.organization_id,
        ood.organization_code,
        mc.segment1,
        mc.segment2,
               moq.inventory_item_id,
               msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
               msi.description,
               msi.primary_uom_code,
               moq.lot_number,
               moq.subinventory_code
order by
    SUM (moq.primary_transaction_quantity) desc
                   