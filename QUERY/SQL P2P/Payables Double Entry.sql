select *
from
    (
    select
        move_number
        ,count(doc_sequence_value) voucher 
    from
        (
        select distinct
        aida.attribute2 move_number
        ,aia.doc_sequence_value
        from
            apps.ap_invoices_all aia
            ,apps.ap_invoice_distributions_all aida
        where 1=1
--          and aia.doc_sequence_value = 219263010
            and aia.invoice_id = aida.invoice_id
            and aia.org_id = aida.org_id
            and aia.cancelled_date is null
            and (aida.reversal_flag='N' or aida.reversal_flag is null)
            and aia.org_id = 82
            and aida.attribute_category = 'Trip Extra Charges'
            and aida.period_name = 'JUL-19'
--          and aida.attribute2 = 'MO/SCOU/1375246'    
        )
group by 
    move_number)
    where voucher!=1