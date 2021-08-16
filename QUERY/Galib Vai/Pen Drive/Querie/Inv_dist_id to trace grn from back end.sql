select
    aia.doc_sequence_value,
--    aid.*
    aid.INVOICE_DISTRIBUTION_ID,
    aid.distribution_line_number,
    aid.amount,
    aid.ATTRIBUTE_CATEGORY,
    aid.attribute1,
    aid.attribute2,
    aid.attribute5
from 
    ap.ap_invoices_all aia,
    ap.ap_invoice_distributions_all aid
where
    aia.invoice_id=aid.invoice_id
    and aid.set_of_books_id=2025
--    and aid.period_name='SEP-13'
    and aia.DOC_SEQUENCE_VALUE in (213168306)
--    and aid.distribution_line_number=1
--    and aid.amount>0
order by
    aid.INVOICE_DISTRIBUTION_ID,
    aid.distribution_line_number
    
        
    
select
    *
from
    ap.ap_invoice_distributions_all aid
where
    rownum<10                
    
    
---- LC_ID
select * from APPS.XXAKG_LC_DETAILS 
where 
    LC_NUMBER='235513010042'
    