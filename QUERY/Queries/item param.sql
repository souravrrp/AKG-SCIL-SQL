/* Formatted on 10/5/2013 11:57:05 PM (QP5 v5.163.1008.3004) */
SELECT a.inventory_item_id,
       a.segment1,
       a.segment2,
       a.segment3,
       a.segment1 || '.' || a.segment2 || '.' || a.segment3 AS Item_Code,
       description,
       PRIMARY_UOM_CODE,
       a.INVENTORY_ITEM_STATUS_CODE,
       b.segment1 Item_Category,
       b.segment2 Item_Type,
       CATEGORY_CONCAT_SEGS
  FROM apps.mtl_system_items_b a,
       apps.mtl_item_categories_v b,
       apps.mtl_parameters mtp
 WHERE     a.inventory_item_id = b.inventory_item_id
       AND a.organization_id = b.organization_id
       AND a.organization_id = mtp.organization_id
       AND a.organization_id = 606
--       AND a.description in ()
--    and b.segment1='FINISH GOODS'
--    AND A.SEGMENT2 in ('STP0','PAPT','CLRD')
--    and a.segment1 = 'RMLD'
    and a.segment1 || '.' || a.segment2 || '.' || a.segment3 in ('ELEC.ELEC.0819')
order by 6