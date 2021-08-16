select 
    gps.calendar_code,
    gps.period_code,
    ood.organization_code,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,
    msi.description,
    CAL.*
    --cal.COST_LEVEL,--CAL.TRANS_DATE,
    --CAL.TRANS_QTY,CAL.COST_AMT
from
    apps.CM_ACST_LED cal,
    gmf.gmf_period_statuses gps,
    apps.org_organization_definitions ood,
    inv.mtl_system_items_b msi
where
    cal.period_id=gps.period_id
    and gps.calendar_code='AKG2017'
    and gps.period_code='6'
    and cal.organization_id=ood.organization_id
    and ood.operating_unit=83
    and cal.inventory_item_id=msi.inventory_item_id
    and cal.organization_id=msi.organization_id
--    and cal.inventory_item_id=24409
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('COVR.PLST.0014')
    and ood.organization_id=99
--    and COST_CMPNTCLS_ID=2
--    and source_ind=24
--    and rownum<10    