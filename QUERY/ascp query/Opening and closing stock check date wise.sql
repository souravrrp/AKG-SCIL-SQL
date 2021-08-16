SELECT 
     oq.inventory_item_id,
     msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_Code,
     msi.description Item_Description,
     msi.primary_uom_code,
     mc.segment1 Item_Category,
     mc.segment2 Item_Type,       
     oq.organization_id,
     ood.organization_code,
     oq.subinventory_code,
     SUM (target_qty) P_cls_qty,
--     apps.fnc_get_item_cost(oq.organization_id,oq.inventory_item_id,'JAN-15') Item_cost,
     SUM (s_target_qty) s_cls_qty
FROM (  SELECT organization_id,
               subinventory_code,
               inventory_item_id,
               SUM (primary_transaction_quantity) target_qty,
               SUM (SECONDARY_TRANSACTION_QUANTITY) s_target_qty
          FROM apps.mtl_onhand_quantities_detail moq
          GROUP BY organization_id,
               subinventory_code,
               inventory_item_id
        UNION
        SELECT organization_id,
               subinventory_code,
               inventory_item_id,
               -SUM (primary_quantity) target_qty,
               -SUM (SECONDARY_TRANSACTION_QUANTITY)
                  s_target_qty
          FROM apps.mtl_material_transactions mmt
         WHERE trunc(transaction_date) >=trunc(NVL (:p_date_from+1,SYSDATE))
               AND (mmt.Logical_Transaction = 2 OR mmt.Logical_Transaction IS NULL)
      GROUP BY organization_id,
               subinventory_code,
               inventory_item_id) oq,
      inv.mtl_system_items_b msi,
      inv.mtl_item_categories mic,
      inv.mtl_categories_b mc,
      apps.org_organization_definitions ood
where
    oq.inventory_item_id=msi.inventory_item_id
    and oq.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and oq.organization_id=ood.organization_id
    --and ood.operating_unit=84
    and ood.organization_code='CER'
    and SUBINVENTORY_CODE='RF FG'
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('DRCT.CLNK.0001')
--    and ood.organization_id=504
--    and mc.segment1 in ('INGREDIENT','INDIRECT MATERIAL','WIP','FINISH GOODS')
--    and mc.segment1 in ('WIP','FINISH GOODS')
--    and mc.segment2 in ('CANDY','GIFT ITEM-CANDY')
--    and regexp_like(mc.segment1, 'SCRAP%')
--    and msi.inventory_item_id in (343409)
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('CMNT.OBLK.0001')
--    and oq.subinventory_code='BEV - STGN'
--    and mc.segment1 in ('CIVIL')
--    and rownum<10
GROUP BY
    oq.inventory_item_id,
     msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
     msi.description,
     mc.segment1,
     mc.segment2,
     msi.primary_uom_code,
     oq.organization_id,
     ood.organization_code,
     oq.subinventory_code
--  HAVING SUM (target_qty) <> 0
