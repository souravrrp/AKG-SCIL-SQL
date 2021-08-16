select
    gam.alloc_code,
    gps.calendar_code,
    gps.period_code,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5,
--    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code,
--    msi.description,
--    gad.period_qty,
--    gad.percent_allocation,
    gad.allocated_expense_amt--,
--    gad.*
from
    gmf.gl_aloc_mst gam,
    gmf.gl_aloc_exp gae,
    gmf.gl_aloc_dtl gad,
    gmf.gmf_period_statuses gps,
--    inv.mtl_system_items_b msi
    gl.gl_code_combinations gcc
where
    gam.legal_entity_id=23280
    and gam.alloc_id=gae.alloc_id
    and gae.DELETE_MARK<>1
    and gae.alloc_id=gad.alloc_id
    and gae.line_no=gad.line_no
    and gae.from_account_id=gcc.code_combination_id
--    and gae.inventory_item_id=msi.inventory_item_id
--    and gae.organization_id=msi.organization_id
    and gam.legal_entity_id=gps.legal_entity_id
    and gad.period_id=gps.period_id
    and gps.calendar_code='AKG2015'
    and gps.period_code='3'
--    and gam.alloc_code='LONG_OVERHEAD'
