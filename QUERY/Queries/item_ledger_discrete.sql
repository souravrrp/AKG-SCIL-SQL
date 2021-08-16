/* Formatted on 12/24/2014 11:04:07 PM (QP5 v5.136.908.31019) */
  SELECT mic.category_id,
         mmt.transaction_id,
         mmt.inventory_item_id,
         mmt.organization_id,
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
        mmt.transaction_quantity
--        mmt.primary_quantity+mmt.prior_costed_quantity
            AS qty,
--         MAX (Actual_Cost) AS Actual_cost,
        mmt.actual_cost,
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
         apps.org_organization_definitions odd
   WHERE     (mmt.Logical_Transaction = 2 OR mmt.Logical_Transaction IS NULL)
         AND mmt.transaction_id = lt.transaction_id(+)
         AND mmt.inventory_item_id = mic.inventory_item_id
         AND mmt.organization_id = mic.organization_id
         AND mp.organization_id = mmt.organization_id
         AND odd.organization_id = mmt.organization_id
          AND mmt.organization_id = 92
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
    and TRUNC(mmt.transaction_date)<'01-DEC-2014'
--AND mmt.SUBINVENTORY_CODE='AGL - CTL'
AND mmt.inventory_item_id = 55174
GROUP BY mic.category_id,
         mmt.transaction_id,
         mmt.inventory_item_id,
         mmt.organization_id,
         lt.lot_number,
         mmt.transaction_date,
         mmt.transaction_type_id,
         --         PROCESS_ENABLED_FLAG,
         mmt.created_by,
         mmt.creation_date,
         mmt.last_updated_by,
         mmt.last_update_date,
         MMT.SUBINVENTORY_CODE,
         mp.PROCESS_ENABLED_FLAG,
         mmt.transaction_quantity,mmt.actual_cost