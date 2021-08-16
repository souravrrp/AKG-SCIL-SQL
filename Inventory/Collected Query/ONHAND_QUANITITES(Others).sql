select  ood.organization_code,MSI.INVENTORY_ITEM_ID,
   msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
  msi.description,
  moqd.subinventory_code,
     MC.SEGMENT1 item_category
   ,MC.SEGMENT2 item_type,
--mil.segment1||'.'||mil.segment2||'.'||mil.segment3 Line_No,
   moqd.lot_number,
sum(moqd.primary_transaction_quantity) as "onhand_qty",
  msi.PRIMARY_UOM_CODE
  --,moqd.TRANSACTION_UOM_CODE
from
    inv.mtl_onhand_quantities_detail moqd,
    inv.mtl_system_items_b msi,
    APPS.MTL_ITEM_CATEGORIES MIC,
    APPS.MTL_CATEGORIES MC,apps.org_organization_definitions ood
  -- Inv.mtl_item_locations mil
where
    moqd.organization_id=msi.organization_id
    and moqd.inventory_item_id=msi.inventory_item_id
    AND MIC.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
    AND MIC.CATEGORY_SET_ID=1
    AND MIC.CATEGORY_ID=MC.CATEGORY_ID
        AND moqd.organization_id=mIC.organization_id
        AND moqd.organization_id=ood.organization_id
        AND msi.organization_id=ood.organization_id
    --and msi.segment1='CRCL'
    and ood.organization_code='AKC'
    --AND ROWNUM<20
   -- AND MSI.SEGMENT1<>'TYRE'
--and mc.SEGMENT1 not in ('FINISH GOODS')--,'INGREDIENT','TRADING')
and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('TYRE.RDBB.0001')--',
--and moqd.locator_id=mil.inventory_location_id
--and subinventory_code='PSU - RM'
--AND LOT_NUMBER LIKE '200705031%'
--and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 iN ('TYRE.CIVL.0004','TYRE.ARMY.0004')
GROUP BY ood.organization_code,MSI.INVENTORY_ITEM_ID,
   msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ,
    msi.description,
    moqd.subinventory_code,
     MC.SEGMENT1
   ,MC.SEGMENT2,
  --mil.segment1||'.'||mil.segment2||'.'||mil.segment3 Line_No,
  -- mil.segment1||'.'||mil.segment2||'.'||mil.segment3 ,
   moqd.lot_number,msi.PRIMARY_UOM_CODE
   ORDER BY MSI.INVENTORY_ITEM_ID
