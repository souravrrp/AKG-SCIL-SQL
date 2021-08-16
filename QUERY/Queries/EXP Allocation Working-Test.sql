select
    gam.alloc_code,
    gae.line_no,
    gcc_f.segment1||'.'||gcc_f.segment2||'.'||gcc_f.segment3||'.'||gcc_f.segment4||'.'||gcc_f.segment5 From_account,
    gcc_t.segment1||'.'||gcc_t.segment2||'.'||gcc_t.segment3||'.'||gcc_t.segment4||'.'||gcc_t.segment5 To_account
from
    apps.gl_aloc_mst gam,
    apps.gl_aloc_exp gae,
    gl.gl_code_combinations gcc_f,
    gl.gl_code_combinations gcc_t
where
    gam.legal_entity_id=23279
    and gam.alloc_code='FACTORY_OVERHEAD_CER'
    and gam.alloc_id=gae.alloc_id
    and gae.from_account_id=gcc_f.code_combination_id
    and gae.to_account_id=gcc_t.code_combination_id
    and gae.delete_mark<>1
order by gae.line_no


select
    gam.alloc_code,
    gps.calendar_code,
    gps.period_code,
    gad.line_no,
    gcc1.segment1||'.'||gcc1.segment2||'.'||gcc1.segment3||'.'||gcc1.segment4||'.'||gcc1.segment5 From_account,
    gcc2.segment1||'.'||gcc2.segment2||'.'||gcc2.segment3||'.'||gcc2.segment4||'.'||gcc2.segment5 To_account,
    sum(gad.allocated_expense_amt) alloc_amnt
--    gad.*
--    calendar_code,
--    period_code,
--    account_id,
--    sum(amount)
from
    apps.gl_aloc_mst gam,
    apps.gl_aloc_dtl gad,
    apps.gl_aloc_exp gae,
    gl.gl_code_combinations gcc1,
    gl.gl_code_combinations gcc2,
    gmf.gmf_period_statuses gps
where
--    gad.alloc_id=42
--    and 
    gam.alloc_id=gad.alloc_id
    and gad.alloc_id=gae.alloc_id
    and gad.line_no=gae.line_no
    and gae.from_account_id=gcc1.code_combination_id
    and gae.to_account_id=gcc2.code_combination_id
    and gad.period_id=gps.period_id
    and gps.legal_entity_id=23280
    and gps.calendar_code='AKG2014'
    and gps.period_code='12'
    and gae.delete_mark<>1
    and gam.alloc_code='LONG_OVERHEAD'
--    and gcc1.segment3='4030101'
--    and gcc2.segment3='4030101'
--    and rownum<10
group by
    gam.alloc_code,
    gps.calendar_code,
    gps.period_code,
    gad.line_no,
    gcc1.segment1||'.'||gcc1.segment2||'.'||gcc1.segment3||'.'||gcc1.segment4||'.'||gcc1.segment5,
    gcc2.segment1||'.'||gcc2.segment2||'.'||gcc2.segment3||'.'||gcc2.segment4||'.'||gcc2.segment5
having sum(gad.allocated_expense_amt)<>0
order by gps.calendar_code,
    gps.period_code,gad.line_no     




select
    *
from
    gl.gl_code_combinations
where
    code_combination_id=164830
    
    
select
    *
from
    apps.xxakg_gl_details_statement_mv
where
    company='2200'
    and account='4030150'    
    and trunc(voucher_date) between '01-NOV-2014' and '30-NOV-2014'      
    
    
      