select
    pb.*
from
    apps.xxakg_inv_pbal_wcstc pb,
    apps.org_organization_definitions ood
where
    pb.legal_entity_id=23279
    and pb.organization_id=ood.organization_id
    and ood.operating_unit=85
    and pb.period_year='2014'
    and pb.period_num='8'
--    rownum<10    



select
    gl.item_category_segment1,
    gl.item_category_segment2,
    gl.item_code_segment1||'.'||gl.item_code_segment2||'.'||gl.item_code_segment3 Item_Code,
    sum(nvl(debits,0)) -sum(nvl(credits,0)) balance
--    gl.*
from
    apps.xxakg_gl_details_statement_mv gl
where
        gl.company='2110'
        and gl.account='2050101'
        and trunc(gl.voucher_date) <'01-SEP-2014'
--        and gl.item_category_segment1 is null
group by
    gl.item_category_segment1,
    gl.item_category_segment2,
    gl.item_code_segment1||'.'||gl.item_code_segment2||'.'||gl.item_code_segment3        