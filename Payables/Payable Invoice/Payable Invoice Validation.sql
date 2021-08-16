SELECT i.invoice_id,
       i.invoice_amount,
       DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(i.invoice_id, i.invoice_amount,i.payment_status_flag,i.invoice_type_lookup_code),
               'NEVER APPROVED', 'Never Validated',
               'NEEDS REAPPROVAL', 'Needs Revalidation',
               'CANCELLED', 'Cancelled', 
               'Validated') INVOICE_STATUS
  FROM apps.ap_invoices_all i
 WHERE i.invoice_num like 'MTO/SCOU/%' 
 order by INVOICE_NUM desc