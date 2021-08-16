select 
    a.period_name,
    b.company_code,
    a.organization_id,
    a.PO_NUMBER,
    b.LC_NUMBER, 
    sum(nvl(a.COST_ADJUSTMENT_WITHOUT_GRN,0))  WITHOUT_GRN, 
    sum(nvl(a.COST_ADJUSTMENT_WITH_GRN,0)) WITH_GRN
from 
    apps.XXAKG_ITEM_LC_COST_DETAILS a, 
    apps.xxakg_lc_details b 
where
    b.ledger_id=2025 and
    a.po_number in ('I/COU/000270') 
    and a.lc_id=b.lc_id 
    and b.company_code in ('2110','2120','2200','2300','2400')
group by 
    a.period_name,
    b.company_code,a.organization_id , a.PO_NUMBER,b.LC_NUMBER
order by
    TO_DATE (a.period_name, 'MON-YY'),
    a.po_number
            