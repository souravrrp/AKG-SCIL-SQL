select
--    *
    gl.je_source,
    gl.je_category,
    gl.voucher_number,
    gl.voucher_date,
    gl.company,
    gl.cost_center,
    gl.account,
    gl.inter_project,
    gl.future,
    gl.company||'.'||gl.cost_center||'.'||gl.account||'.'||gl.inter_project||'.'||gl.future Code_Combination,
    gl.acctdesc,
--    nvl(debits,0) Dr,
--    nvl(credits,0) Cr,
    sum(nvl(debits,0)-nvl(credits,0)) Balance
from
    apps.xxakg_gl_details_statement_mv gl,
    apps.gl_aloc_exp gae ,
    apps.gl_aloc_mst gam
where
    gl.company='2110'
    and gl.account='4030101'
    and trunc(gl.voucher_date) between '01-APR-2014' and '30-APR-2014'
    and gam.legal_entity_id=23279
    and gam.alloc_id=gae.alloc_id
    and gae.from_account_id=gl.company||'.'||gl.cost_center||'.'||gl.account||'.'||gl.inter_project||'.'||gl.future
group by
    gl.je_source,
    gl.je_category,
    gl.voucher_number,
    gl.voucher_date,
    gl.company,
    gl.cost_center,
    gl.account,
    gl.inter_project,
    gl.future,
    gl.company||'.'||gl.cost_center||'.'||gl.account||'.'||gl.inter_project||'.'||gl.future,
    gl.acctdesc        