select distinct
--        aid.* 
        hou.name operating_unit
        ,ai.invoice_id
        ,ai.doc_sequence_value
        ,aps.vendor_name
        ,ai.invoice_type_lookup_code
--        ,ai.payment_status_flag
--        ,nvl(ai.payment_status_flag,'N') payment_status_flag
        ,decode(ai.payment_status_flag,
                'Y','Paid',
                'N','Unpaid') payment_status
        ,ai.invoice_amount header_amount
        ,ai.amount_paid
        ,aid.accounting_date
        ,aid.invoice_distribution_id
        ,aid.distribution_line_number
        ,aid.line_type_lookup_code
        ,aid.amount
--        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
--        ,lc.lc_number
        ,aid.attribute_category
        ,aid.attribute1 type_of_charges
        ,aid.attribute2 move_number
        ,moh.transport_mode
--        ,pha.segment1 po_number
--        ,pda.destination_type_code
        ,ai.cancelled_date
        ,ail.discarded_flag
        ,ail.cancelled_flag
        ,aid.reversal_flag
--        ,pha.cancel_flag
--        ,pla.cancel_flag
--        ,pda.gl_cancelled_date
from 
        apps.ap_invoices_all ai
        ,apps.ap_invoice_lines_all ail
        ,apps.ap_invoice_distributions_all aid
        ,apps.ap_suppliers aps
        ,apps.hr_operating_units hou
--        ,apps.gl_code_combinations gcc
--        ,apps.xxakg_lc_details lc
--        ,apps.po_headers_all pha
--        ,apps.po_lines_all pla
--        ,apps.po_distributions_all pda
        ,apps.xxakg_mov_ord_hdr moh
where 1=1
        and ai.org_id=82
--        and aid.attribute2='MO/SCOU/1051702'
--        and ai.doc_sequence_value in (218129626)
--        and gcc.segment1 in ('2110')
--        and gcc.segment3 in ('2050107')
--        and pha.segment1 in ('I/SCOU/000899')
        and aid.accounting_date>='01-JAN-2017'        
        and aid.attribute_category='Trip Extra Charges'
        and moh.transport_mode='Company Truck'
--        and ai.invoice_amount-ai.amount_paid>0
        and ai.invoice_id=aid.invoice_id
        and ai.invoice_id=ail.invoice_id
        and ail.invoice_id=aid.invoice_id
        and ai.org_id=ail.org_id
        and ai.org_id=aid.org_id
        and aid.org_id=ail.org_id
        and ai.vendor_id=aps.vendor_id
        and ai.org_id=hou.organization_id
        and aid.attribute2=moh.mov_order_no
--        and aid.dist_code_combination_id=gcc.code_combination_id
--        and aid.attribute1=lc.lc_id
--        and lc.po_header_id=pha.po_header_id
--        and pha.org_id=ai.org_id
--        and pla.po_header_id=pha.po_header_id
--        and pla.po_header_id=pda.po_header_id
--        and pla.po_line_id=pda.po_line_id
        and (ail.discarded_flag is null or ail.discarded_flag='N')
        and (ail.cancelled_flag is null or ail.cancelled_flag='N')
        and ai.cancelled_date is null
--        and (pha.cancel_flag is null or pha.cancel_flag='N')
--        and (pla.cancel_flag is null or pla.cancel_flag='N')
--        and pda.gl_cancelled_date is null
        and (aid.reversal_flag='N' or aid.reversal_flag is null)
order by ai.invoice_id,
        aid.invoice_distribution_id
        
select * from apps.hr_operating_units

select *
--distinct attribute_category 
from apps.ap_invoice_distributions_all
where attribute_category='Trip Extra Charges'

select * from apps.ap_invoices_all 