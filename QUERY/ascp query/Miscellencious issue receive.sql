select mmt.transaction_id,mtt.transaction_type_name,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item, msi.description, MC.SEGMENT1 ITEM_CATEGORY,MC.SEGMENT2 ITEM_TYPE,mmt.TRANSACTION_SOURCE_NAME, mmt.transaction_date,SUBINVENTORY_CODE, mmt.TRANSACTION_UOM, mmt.TRANSACTION_QUANTITY
from apps.mtl_material_transActions mmt, inv.mtl_transaction_types mtt, apps.mtl_system_items_b msi,APPS.MTL_ITEM_CATEGORIES MIC,APPS.MTL_CATEGORIES_B MC
where mmt.organization_id=99 and mmt.created_by=10558 
and mmt.transaction_type_id = mtt.transaction_type_id
AND MIC.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
AND MIC.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MIC.CATEGORY_ID=MC.CATEGORY_ID
AND MIC.CATEGORY_SET_ID=1
--and mmt.creation_date>='01-OCT-2016'
and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('COVR.PLST.0012')
--and mmt.TRANSACTION_DATE BETWEEN '01-MAR-2017' and '31-MAR-2017'
--AND TRANSACTION_SOURCE_NAME LIKE '%RF_%'
and mmt.inventory_item_id=msi.inventory_item_id and mmt.organization_id=msi.organization_id


