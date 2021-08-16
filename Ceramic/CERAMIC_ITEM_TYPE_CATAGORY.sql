SELECT
ORGANIZATION_ID,
ORGANIZATION_CODE,
ITEM_CODE,
DESCRIPTION,
PRIMARY_UNIT_OF_MEASURE,
ITEM_TYPE,
ITEM_CATEGORY,
CATEGORY_CODE
--,ITM.*
FROM
APPS.XXAKG_BIEE_ORGITEMMASTER ITM
WHERE 1=1
AND ORGANIZATION_ID=99
AND ITEM_CATEGORY IN ('INGREDIENT','FINISH GOODS','INDIRECT MATERIAL')
--AND PRIMARY_UNIT_OF_MEASURE='Piece'
--AND ORGANIZATION_CODE='CER'
--AND USER_ITEM_TYPE='FG' --IN ('')
--AND ITEM_CODE=:P_ITEM_CODE
--AND ITEM_TYPE=:P_ITEM_TYPE




------------------------------------------------------------------------------------------------



SELECT
MIC.CATEGORY_ID,
MIC.ORGANIZATION_ID,
MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
MSI.DESCRIPTION,
MSI.PRIMARY_UOM_CODE,
MC.SEGMENT1 ITEM_CATEGORY,
MC.SEGMENT2 ITEM_TYPE
FROM
APPS.MTL_SYSTEM_ITEMS_B MSI,
APPS.MTL_ITEM_CATEGORIES MIC,
APPS.MTL_CATEGORIES MC
WHERE 1=1
AND MIC.CATEGORY_ID=MC.CATEGORY_ID
AND MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID
AND MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID
AND MC.SEGMENT2 IS NOT NULL
AND MSI.ORGANIZATION_ID=99
--AND MC.SEGMENT2 IN ('FLUSING MECHANISM FOR STELLA')
--AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('WCLA.STLP.0001')

----------------------------------ITEM--------------------------------------------------------

SELECT
*
FROM
APPS.MTL_SYSTEM_ITEMS_B MSI
WHERE 1=1
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3='SCRP.BAG0.0006'
AND MSI.ORGANIZATION_ID=101




------------------------------------------------------------------------------------------------

select 
msi.organization_id,
(select organization_code from apps.mtl_parameters where organization_id=msi.organization_id) org_code,
msi.inventory_item_id,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code ,
msi.description,
msi.primary_uom_code,
mtc.segment1||'|'||mtc.segment2 item_categories
--,msi.secondary_uom_code,msi.dual_uom_control,msi.tracking_quantity_ind,
--msi.enabled_flag,item_type,msi.customer_order_flag,msi.customer_order_enabled_flag,msi.inventory_item_flag,msi.shippable_item_flag,msi.so_transactions_flag,msi.returnable_flag,msi.invoiceable_item_flag,msi.invoice_enabled_flag,msi.costing_enabled_flag,msi.creation_date 
from
apps.mtl_system_items_b msi,
apps.mtl_item_categories mtic,
apps.mtl_categories mtc
where 1=1
and mtic.category_id=mtc.category_id
and mtic.organization_id=msi.organization_id and mtic.inventory_item_id=msi.inventory_item_id
and mtc.structure_id=101
--and msi.organization_id=99
--and msi.primary_uom_code='PCS'
--and mtc.segment1 in  ('INGREDIENT','FINISH GOODS','INDIRECT MATERIAL')
and msi.segment1||'.'||msi.segment2||'.'||msi.segment3=:item_code--'FLSR.FLSR.0013'
--and mtc.segment1||'|'||mtc.segment2=
--'FINISH GOODS|SEAT COVER- VERSO SOFT'
--'INGREDIENT|SEAT COVER- VERSO SOFT'
--'INGREDIENT|FLUSING MECHANISM FOR STELLA'
--'FINISH GOODS|FLUSING MECHANISM FOR STELLA'
