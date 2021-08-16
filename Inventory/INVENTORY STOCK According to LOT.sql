select --*
 moqd.ORGANIZATION_ID
,OOD.ORGANIZATION_NAME
,moqd.SUBINVENTORY_CODE
,MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3 ITEM_CODE
,msib.SEGMENT1 item
,SUM (moqd.primary_transaction_quantity) on_hand
,SUM (moqd.secondary_transaction_quantity) secondary_onhand
,msib.PRIMARY_UOM_CODE
,moqd.secondary_uom_code
,moqd.LOT_NUMBER
,(SELECT EXPIRATION_DATE FROM APPS.MTL_LOT_NUMBERS WHERE LOT_NUMBER=moqd.LOT_NUMBER
AND inventory_item_id =MOQD.inventory_item_id AND organization_id =MOQD.organization_id )LOT_EXPIRY_DATE
FROM
 APPS.mtl_onhand_quantities_detail moqd
,APPS.mtl_system_items_b msib
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
   WHERE 1 = 1
   AND OOD.ORGANIZATION_ID=101
   AND MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3 IN ('CMNT.SBAG.0001')
     --AND moqd.organization_id = 143
     /*AND moqd.subinventory_code = 'R DRY HALA'
     AND moqd.inventory_item_id = 9095
     AND moqd.owning_organization_id = 143
     AND moqd.planning_organization_id = 143*/
     AND moqd.INVENTORY_ITEM_ID=msib.INVENTORY_ITEM_ID
     AND moqd.organization_id=msib.organization_id
     AND OOD.organization_id=msib.organization_id
group by
moqd.ORGANIZATION_ID
,moqd.SUBINVENTORY_CODE
,MSIB.SEGMENT1||'.'||MSIB.SEGMENT2||'.'||MSIB.SEGMENT3
,msib.SEGMENT1   
,moqd.secondary_uom_code
,moqd.LOT_NUMBER
,msib.PRIMARY_UOM_CODE
,OOD.ORGANIZATION_NAME
,MOQD.inventory_item_id
