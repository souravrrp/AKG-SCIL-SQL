/* Formatted on 10/5/2013 11:57:05 PM (QP5 v5.163.1008.3004) */
SELECT a.inventory_item_id,
       a.segment1,
       a.segment2,
       a.segment3,
       a.segment1 || '.' || a.segment2 || '.' || a.segment3 AS Item_Code,
       description,
       PRIMARY_UOM_CODE,
       b.segment1 Item_Category,
       b.segment2 Item_Type,
       CATEGORY_CONCAT_SEGS
  FROM apps.mtl_system_items_b_kfv a,
       apps.mtl_item_categories_v b,
       apps.mtl_parameters mtp
 WHERE     a.inventory_item_id = b.inventory_item_id
       AND a.organization_id = b.organization_id
       AND a.organization_id = mtp.organization_id
       AND a.organization_id = 99
--       AND a.description LIKE '%Liner%Wash Basin Crown Small%'
--    and b.segment1='FINISH GOODS'
--    AND A.SEGMENT2 in ('STP0','PAPT','CLRD')
--    and a.segment1 = 'RMLD'
    and a.segment1 || '.' || a.segment2 || '.' || a.segment3 in ('MLDA.MARW.0001',
'BSNA.MARR.0001',
'BSNA.ELAR.0001',
'BSNA.ELAB.0021',
'SOPA.CASR.0001',
'SOPA.CASB.0001')