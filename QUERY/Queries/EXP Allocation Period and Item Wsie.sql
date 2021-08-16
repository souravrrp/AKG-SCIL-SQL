select
    gam.alloc_code,
    gps.calendar_code,
    gps.period_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
    msi.description,
    gad.period_qty,
    gad.percent_allocation,
    gad.allocated_expense_amt--,
--    gad.*
from
    gmf.gl_aloc_mst gam,
    gmf.gl_aloc_bas gab,
    gmf.gl_aloc_dtl gad,
    gmf.gmf_period_statuses gps,
    inv.mtl_system_items_b msi
where
    gam.legal_entity_id=23280
    and gam.alloc_id=gab.alloc_id
    and gab.DELETE_MARK<>1
    and gab.alloc_id=gad.alloc_id
    and gab.line_no=gad.line_no
    and gab.inventory_item_id=msi.inventory_item_id
    and gab.organization_id=msi.organization_id
    and gam.legal_entity_id=gps.legal_entity_id
    and gad.period_id=gps.period_id
    and gps.calendar_code='AKG2015'
    and gps.period_code='1'
--    and gam.alloc_code='FACTORY_OVERHEAD_CER'
