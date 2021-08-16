select 
    aia.invoice_num,
    aia.doc_sequence_value,
--    aia.project_id,
    pja.name project_name,
--    aia.task_id,
    pt.task_number,
    pt.task_name,
--    aida.distribution_line_number,
    gcc.segment1 company,gcc.segment2 cost_center,gcc.segment3 natural_account,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 acc_code_combination,
    sum(nvl(aida.base_amount,aida.amount)) amount
--    aida.*
from
    ap.ap_invoices_all aia,
    ap.ap_invoice_distributions_all aida,
    pa.pa_projects_all pja,
    pa.pa_tasks pt,
    gl.gl_code_combinations gcc
where
    aia.set_of_books_id=2022
    and aia.org_id=87
    and aia.invoice_id=aida.invoice_id
    and aia.org_id=aida.org_id
    and aia.project_id=pja.project_id(+)
    and aia.task_id=pt.task_id(+)
    and aida.dist_code_combination_id=gcc.code_combination_id
    and trunc(aida.accounting_date)<'01-APR-2015'
    and gcc.segment1 in ('1220')
--    and gcc.segment2 in ('PRJCT')
    and gcc.segment3 in ('2030102')
--    and aia.doc_sequence_value=214035298
--    and rownum<10
group by
    aia.invoice_num,
    aia.doc_sequence_value,
--    aia.project_id,
    pja.name,
--    aia.task_id,
    pt.task_number,
    pt.task_name,
--    aida.distribution_line_number,
    gcc.segment1,gcc.segment2,gcc.segment3,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5