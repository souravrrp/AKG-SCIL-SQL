select 
    aia.invoice_num,
    aia.doc_sequence_value,
--    aida.distribution_line_number,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 acc_code_combination,
    sum(nvl(aida.base_amount,aida.amount)) amount
--    aida.*
from
    ap.ap_invoices_all aia,
    ap.ap_invoice_distributions_all aida,
    gl.gl_code_combinations gcc
where
    aia.set_of_books_id=2022
    and aia.org_id=86
    and aia.invoice_id=aida.invoice_id
    and aida.dist_code_combination_id=gcc.code_combination_id
    and trunc(aida.accounting_date)<'01-APR-2015'
    and gcc.segment1 in ('1160')
    and gcc.segment2 in ('PRJCT')
    and gcc.segment3 in ('2030102')
--    and aia.doc_sequence_value=214035298
--    and rownum<10
group by
    aia.invoice_num,
    aia.doc_sequence_value,
--    aida.distribution_line_number,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5