select
    to_char(trunc(voucher_date),'MON-YY') Period,
    organization_code,
    company,
    cost_center,
    account,
    inter_project,
    future,
    voucher_number,
    je_source,
    je_category,
    transaction_type,
    item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3 Item_code,
    inventory_item_name,
    item_category_segment1 item_category,
    item_category_segment2 item_type,
    sum(nvl(debits,0)) Dr,
    sum(nvl(credits,0)) Cr,
    sum(nvl(debits,0)) - sum(nvl(credits,0)) Balance
from
    apps.xxakg_gl_details_statement_mv
--    apps.xxakg_gl_dtl_dmv_2022
where
    ledger_id=2022
    and company in ('1160')
--    and cost_center in ('AUTOM','HOAUTO')
--    and account in ('2050104')
--    and trunc(voucher_date) <'01-APR-2015'--between '01-MAR-2015' and '31-MAR-2015'
    and organization_code='CCP'
    and item_category_segment1 in ('MECHANICAL')
--    and item_category_segment2 like  ('GIFT ITEM%')
--    and je_source='CST'
--    and je_category='Inventory'
--    and voucher_number=214066411
--    and je_category='OPM Shipments'--'OPM/OM Shipments'
--    and item_category_segment1 in ('CIVIL','ELECTRICAL','IT','MECHANICAL','MECHANICAL-UNLOADING','PRINTING AND STATIONARY','TOOLS')
    and item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3 in ('PLTE.SSPT.0166')
group by
    to_char(trunc(voucher_date),'MON-YY'),
    organization_code,
    company,
    cost_center,
    account,
    inter_project,
    future,
    voucher_number,
    je_source,
    je_category,
    transaction_type,
    item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3,
    inventory_item_name,
    item_category_segment1,
    item_category_segment2     
    
    
    
select
--    *
    to_char(trunc(voucher_date),'MON-YY') Period,
    je_source,
    je_category,
    voucher_number,
    voucher_date,
    organization_id,
    organization_code,
    item_category_segment1,
    item_category_segment2,
    item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3 Item_code,
    inventory_item_name,
    sum(nvl(debits,0)) Dr,
    sum(nvl(credits,0)) Cr,
    sum(nvl(debits,0)) - sum(nvl(credits,0)) Balance
from
    apps.xxakg_gl_details_statement_mv
where
    ledger_id=2041
    and company='5112'
    and account='4020109'
    and trunc(voucher_date) between '01-JAN-2015' and '28-FEB-2015'
--    and organization_id=101
    and je_source='INV'
group by
    je_source,
    je_category,
    voucher_number,
    voucher_date,
    organization_id,
    organization_code,
    item_category_segment1,
    item_category_segment2,
    item_code_segment1||'.'||item_code_segment2||'.'||item_code_segment3,
    inventory_item_name               