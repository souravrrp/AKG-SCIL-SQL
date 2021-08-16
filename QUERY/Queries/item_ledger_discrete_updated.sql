select
    b.item_category,
    b.item_type,
    b.item_code,
    b.description,
    a.*
from
  (SELECT mic.category_id,
         mmt.transaction_id,
         mmt.inventory_item_id,
         mmt.organization_id,
         ood.organization_code,
         lt.lot_number,
         mmt.transaction_date,
         mmt.transaction_type_id,
         mmt.created_by,
         mmt.creation_date,
         mmt.last_updated_by,
         mmt.last_update_date,
--         CASE
--            WHEN lt.lot_number IS NOT NULL THEN SUM (lt.primary_quantity)
--            ELSE SUM (mmt.primary_quantity)
--         END
        mmt.primary_quantity+mmt.prior_costed_quantity
            AS qty,
--         MAX (Actual_Cost) AS Actual_cost,
        mmt.new_cost item_cost,
         MMT.SUBINVENTORY_CODE,
         mp.PROCESS_ENABLED_FLAG,
         CASE
            WHEN lt.lot_number IS NOT NULL
            THEN
               SUM (lt.secondary_transaction_quantity)
            ELSE
               SUM (mmt.secondary_transaction_quantity)
         END
            AS secondary_qty
    FROM inv.mtl_material_transactions mmt,
         inv.mtl_transaction_lot_numbers lt,
         inv.mtl_item_categories mic,
         inv.mtl_parameters mp,
         --         gmf.cm_cmpt_dtl cst,
         --         apps.cm_cldr_mst_v cdl,
         apps.org_organization_definitions ood
   WHERE     (mmt.Logical_Transaction = 2 OR mmt.Logical_Transaction IS NULL)
         AND mmt.transaction_id = lt.transaction_id(+)
         AND mmt.inventory_item_id = mic.inventory_item_id
         AND mmt.organization_id = mic.organization_id
         AND mp.organization_id = mmt.organization_id
         AND ood.organization_id = mmt.organization_id
         and ood.legal_entity=23280
         and ood.operating_unit=86
--          AND mmt.organization_id = 504
         --         AND mmt.organization_id = cst.organization_id(+)
         --         AND mmt.inventory_item_id = cst.inventory_item_id(+)
         --         AND cst.period_id = cdl.period_id
         --         AND cdl.CALENDAR_CODE =
         --               'AKG' || TO_CHAR (mmt.TRANSACTION_DATE, 'RRRR')
         --         AND cdl.PERIOD_code =
         --               TRIM ('0' FROM TO_CHAR (mmt.TRANSACTION_DATE, 'MM'))
         --         AND cdl.legal_entity_id = odd.legal_entity
         AND mic.category_set_id = 1
--AND  mmt.inventory_item_id=155380 and mmt.organization_id=95 
--    and TRUNC(mmt.transaction_date)<'01-DEC-2014'
--AND mmt.SUBINVENTORY_CODE='AGL - CTL'
--AND mmt.inventory_item_id = 481558
GROUP BY mic.category_id,
         mmt.transaction_id,
         mmt.inventory_item_id,
         mmt.organization_id,
         ood.organization_code,
         lt.lot_number,
         mmt.transaction_date,
         mmt.transaction_type_id,
         --         PROCESS_ENABLED_FLAG,
         mmt.created_by,
         mmt.creation_date,
         mmt.last_updated_by,
         mmt.last_update_date,
         MMT.SUBINVENTORY_CODE,
         mmt.primary_quantity,mmt.prior_costed_quantity,
         mp.PROCESS_ENABLED_FLAG,mmt.new_cost) a,
(select
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    mc.segment1 Item_category,
    mc.segment2 item_type,
    max(mmt.transaction_date) last_txn_date
from
    inv.mtl_system_items_b msi,
    inv.mtl_material_transactions mmt,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    apps.org_organization_definitions ood
where
    mmt.inventory_item_id=msi.inventory_item_id
    and mmt.organization_id=msi.organization_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_set_id=1
    and mic.category_id=mc.category_id
    and mmt.organization_id=ood.organization_id
    and ood.legal_entity=23280
    and ood.operating_unit=86
--    and mmt.organization_id=504
--    and trunc(mmt.transaction_date)<'01-DEC-2014'
--    and rownum<10    
group by msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,mc.segment1,
    mc.segment2) b
where
    a.inventory_item_id=b.inventory_item_id
    and a.transaction_date=b.last_txn_date
--    and b.item_code='PRIN.STAT.2384'
    and a.qty<>0
--    and b.ITEM_CATEGORY='MECHANICAL'
--    and rownum<10
    