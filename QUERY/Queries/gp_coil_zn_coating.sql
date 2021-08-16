select *
from
    apps.org_organization_definitions ood
where
    organization_code in ('AGL','SGL','ACL')    


select mc.segment1, mc.segment2,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code, msi.description,mln.lot_number,decode(substr(mln.lot_number,3,2),'3F','CGL-3','1F','NOF-1','2F','NOF-2','4F','NOF-4') production_line,abs(nvl(mtln.transaction_quantity,mmt.transaction_quantity)) transfer_quantity,
        mln.attribute10 gp_coil_width,mln.attribute1 gp_coil_length,mln.attribute7 cr_cgl_weight,mln.grade_code gp_coil_grade--,mln.* 
from
    inv.mtl_material_transactions mmt,
    inv.mtl_system_items_b msi,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    inv.mtl_transaction_lot_numbers mtln,
    inv.mtl_lot_numbers mln
where
    mmt.transaction_type_id=3
    and mmt.organization_id in (95,97)
    and mmt.transfer_organization_id=464
    and mmt.transaction_id=mtln.transaction_id(+)
    and mtln.lot_number=mln.lot_number(+)
    and mtln.inventory_item_id=mln.inventory_item_id
    and mtln.organization_id=mln.organization_id(+)
    and msi.inventory_item_id=mmt.inventory_item_id
    and msi.organization_id=mmt.organization_id    
    and trunc(mmt.transaction_date) between :p_from_date and :p_to_date
    and msi.inventory_item_id=mic.inventory_item_id
    and msi.organization_id=mic.organization_id
    and mic.category_set_id=1
    and mic.category_id=mc.category_id
    and mln.attribute_category='WIP|GP COIL'