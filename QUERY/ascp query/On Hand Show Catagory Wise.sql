SELECT moq.organization_id,
            ood.organization_code,
            mc.segment1 Item_Category,
            mc.segment2 item_type,
               moq.inventory_item_id,
               msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
               msi.description,
              -- substr(msi.segment2,1,2) item,
               --substr(msi.segment2,3,2) item_color,
               msi.primary_uom_code,
               moq.subinventory_code,
               moq.lot_number,
              -- moq.ORIG_DATE_RECEIVED,
               SUM (moq.primary_transaction_quantity) target_qty,
--               apps.fnc_get_item_cost(moq.organization_id,moq.inventory_item_id,'JUN-16') item_cost,
               SUM (moq.SECONDARY_TRANSACTION_QUANTITY) s_target_qty
FROM 
          apps.mtl_onhand_quantities_detail moq,
          inv.mtl_system_items_b msi,
          inv.mtl_item_categories mic,
          inv.mtl_categories_b mc,
          apps.org_organization_definitions ood
where
    moq.organization_id=ood.organization_id
    and ood.organization_code in ('CER')
    and moq.organization_id=msi.organization_id
    and moq.inventory_item_id=msi.inventory_item_id
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_id=mc.category_id
    and ood.legal_entity=23279
    and ood.operating_unit=83
--    and moq.subinventory_code like '%CER%SCRAP%'
--    and mc.segment1 not in ('INGREDIENT','INDIRECT MATERIAL','WIP','FINISH GOODS','PROCESS SCRAP','GENERAL SCRAP')
--    and mc.segment1 in ('WIP','FINISH GOODS')
--    and mc.segment2 in ('GRINDING MEDIA')---like ('%WORK%MOULD%')
     --and mc.segment2 like 'READY PIECE%'
    -- and msi.segment1 like '%RP%'
   and msi.segment1||'.'||msi.segment2||'.'||MSI.SEGMENT3 in ('RPWB.AGNP.0001')
--    and upper(msi.description) like 'UNPACKED%WATER%TANK%MARCE%NORMAL% B' 
    and mic.category_set_id=1
--    and moq.subinventory_code ='SLIP TANK'--'BUFR TNK 9'--like 'W MLD LINE' --'%MOLD%'---'%SFLOOR%'----=
--    and msi.segment1 = 'TYRE'
--    and moq.lot_number in  ('UWCA-28-AUG-2016-4')          
group by
    moq.organization_id,
        ood.organization_code,
        mc.segment1,
        mc.segment2,
       moq.inventory_item_id,
       msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
       msi.description,
       --substr(msi.segment2,1,2),
      -- substr(msi.segment2,3,2),
       msi.primary_uom_code,
       moq.lot_number,
       --moq.ORIG_DATE_RECEIVED,
       moq.subinventory_code
order by
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    lot_number,
    SUM (moq.primary_transaction_quantity) desc
