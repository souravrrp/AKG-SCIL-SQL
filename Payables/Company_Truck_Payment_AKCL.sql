SELECT 
AIA.DOC_SEQUENCE_VALUE
,AIA.INVOICE_NUM
,AIDA.ATTRIBUTE2
,AIDA.*
FROM
APPS.AP_INVOICES_ALL AIA
,APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
,APPS.XXAKG_MOV_ORD_HDR MOH
,APPS.AP_SUPPLIERS APS
WHERE 1=1
AND AIA.VENDOR_ID=APS.VENDOR_ID
AND AIA.ORG_ID=82
AND AIA.INVOICE_ID=AIDA.INVOICE_ID
AND AIDA.ATTRIBUTE2=MOH.MOV_ORDER_NO
AND MOH.TRANSPORT_MODE='Company Truck'
--AND DOC_SEQUENCE_VALUE IN ('218051623')
--AND AIDA.ATTRIBUTE1='Trip Commission'
AND MOH.MOV_ORDER_NO='MO/SCOU/1124006'
--AND INVOICE_NUM LIKE '18/Daudkandi-04-%'
--AND TO_CHAR(AIA.INVOICE_DATE,'RRRR')='2017'
--AND TO_CHAR(AIA.INVOICE_DATE,'MON-RR')='DEC-17'


-------------------------------------------Details---------------------------------------------

select --distinct
--        aid.* 
        hou.name operating_unit
--        ,ai.invoice_id
        ,aps.segment1 transporter_no
        ,aps.vendor_name transporter_name
        ,modt.do_number
        ,to_char(moh.mov_order_date,'DD-MON-RR') move_order_date
        ,moh.mov_order_no
        ,moh.mov_order_status status
        ,(select ood.organization_name from apps.org_organization_definitions ood where moh.warehouse_org_code=ood.organization_code and moh.org_id=ood.operating_unit) warehouse
        ,(select sum(ool.ordered_quantity) from apps.oe_order_lines_all ool where ool.shipment_priority_code=modt.do_number) quantity
--        ,ai.invoice_type_lookup_code
--        ,ai.payment_status_flag
--        ,nvl(ai.payment_status_flag,'N') payment_status_flag
        ,decode(ai.payment_status_flag,
                'Y','Paid',
                'N','Unpaid') bill_status
        ,ai.invoice_amount amount
        ,ai.amount_paid
        ,aid.accounting_date
        ,moh.transport_mode
--        ,aid.invoice_distribution_id
--        ,aid.distribution_line_number
--        ,aid.line_type_lookup_code
--        ,aid.amount distribution_amount
--        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
--        ,lc.lc_number
--        ,aid.attribute1 type_of_charges
        ,moh.final_destination
        ,moh.vehicle_no
        ,apsa.vendor_site_code supplier_site 
        ,aid.attribute_category payment_category
        ,ai.doc_sequence_value voucher_number
        ,aid.attribute1
--        ,aid.attribute2 move_number
--        ,pha.segment1 po_number
--        ,pda.destination_type_code
--        ,ai.cancelled_date
--        ,ail.discarded_flag
--        ,ail.cancelled_flag
--        ,aid.reversal_flag
--        ,pha.cancel_flag
--        ,pla.cancel_flag
--        ,pda.gl_cancelled_date
--,ai.*
from 
        apps.ap_invoices_all ai
        ,apps.ap_invoice_lines_all ail
        ,apps.ap_invoice_distributions_all aid
        ,apps.ap_suppliers aps
        ,apps.ap_supplier_sites_all apsa
        ,apps.hr_operating_units hou
--        ,apps.gl_code_combinations gcc
--        ,apps.xxakg_lc_details lc
--        ,apps.po_headers_all pha
--        ,apps.po_lines_all pla
--        ,apps.po_distributions_all pda
        ,apps.xxakg_mov_ord_hdr moh
        ,apps.xxakg_mov_ord_dtl modt
where 1=1
        and ai.org_id=82
        and aid.attribute2='MO/SCOU/036734'
--        and ai.doc_sequence_value in (218129626)
--        and gcc.segment1 in ('2110')
--        and gcc.segment3 in ('2050107')
--        and pha.segment1 in ('I/SCOU/000899')
        and aid.accounting_date>='01-JAN-2017'        
        and aid.attribute_category='Trip Extra Charges'
--        and aid.attribute1='Trip Commission'
        and moh.transport_mode='Company Truck'
        and moh.mov_ord_hdr_id=modt.mov_ord_hdr_id
        and aid.invoice_line_number=ail.line_number
--        and ai.invoice_amount-ai.amount_paid>0
        and ai.invoice_id=aid.invoice_id
        and ai.invoice_id=ail.invoice_id
        and ail.invoice_id=aid.invoice_id
        and ai.org_id=ail.org_id
        and ai.org_id=aid.org_id
        and aid.org_id=ail.org_id
        and ai.vendor_site_id=apsa.vendor_site_id
        and apsa.org_id=ai.org_id
        and ai.vendor_id=aps.vendor_id
        and apsa.vendor_id=aps.vendor_id
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
order by moh.mov_order_no
--           ,ai.invoice_id
--        ,aid.invoice_distribution_id


---------------------------------------Summary----------------------------------------------

select --distinct
        hou.name operating_unit
--        ,ai.invoice_id
        ,aps.segment1 transporter_no
        ,aps.vendor_name transporter_name
        ,modt.do_number
        ,to_char(moh.mov_order_date,'DD-MON-RR') move_order_date
        ,to_char(moh.mov_order_no) move_order_no
        ,moh.mov_order_status status
        ,(select ood.organization_name from apps.org_organization_definitions ood where moh.warehouse_org_code=ood.organization_code and moh.org_id=ood.operating_unit) warehouse
        ,moh.warehouse_org_code
        ,(select sum(ool.ordered_quantity) from apps.oe_order_lines_all ool where ool.shipment_priority_code=modt.do_number) quantity
        ,decode(ai.payment_status_flag,
                'Y','Paid',
                'N','Unpaid') bill_status
        ,sum(ai.invoice_amount) amount
        ,sum(ai.amount_paid) amount_paid
        ,SUM(aid.amount) distribution_amount
        ,to_char(aid.accounting_date) accounting_date
        ,moh.transport_mode
        ,moh.final_destination
        ,moh.vehicle_no
        ,apsa.vendor_site_code supplier_site 
        ,aid.attribute_category payment_category
        ,to_number(ai.doc_sequence_value) voucher_number
        ,aid.ATTRIBUTE1 cost_head
--,ai.*
from 
        apps.ap_invoices_all ai
        ,apps.ap_invoice_lines_all ail
        ,apps.ap_invoice_distributions_all aid
        ,apps.ap_suppliers aps
        ,apps.ap_supplier_sites_all apsa
        ,apps.hr_operating_units hou
        ,apps.xxakg_mov_ord_hdr moh
        ,apps.xxakg_mov_ord_dtl modt
where 1=1
        and ai.org_id=82
--        and moh.warehouse_org_code='G03'
--        and aid.attribute2='MO/SCOU/1124006'
--        and moh.vehicle_no in ('D.M.U-11-1479','D.M.U-11-1485','D.M.U-11-1174')
--        and ai.doc_sequence_value in (218129626)
--        and TO_CHAR (aid.accounting_date, 'MON-RR') = 'JUN-18'
--        and ai.payment_status_flag='Y'
--        and TO_CHAR (aid.accounting_date, 'RRRR') = '2018'
--        and aid.accounting_date between '01-Apr-2018' and '30-Jun-2018'
--        and aid.accounting_date>='01-JAN-2017'               
        and aid.attribute_category='Trip Extra Charges'
--        and aid.attribute1='Trip Commission'
        and moh.transport_mode='Company Truck'
        and moh.mov_ord_hdr_id=modt.mov_ord_hdr_id
        and aid.invoice_line_number=ail.line_number
        and ai.invoice_id=aid.invoice_id
        and ai.invoice_id=ail.invoice_id
        and ail.invoice_id=aid.invoice_id
        and ai.org_id=ail.org_id
        and ai.org_id=aid.org_id
        and aid.org_id=ail.org_id
        and ai.vendor_site_id=apsa.vendor_site_id
        and apsa.org_id=ai.org_id
        and ai.vendor_id=aps.vendor_id
        and apsa.vendor_id=aps.vendor_id
        and ai.org_id=hou.organization_id
        and aid.attribute2=moh.mov_order_no
        and (ail.discarded_flag is null or ail.discarded_flag='N')
        and (ail.cancelled_flag is null or ail.cancelled_flag='N')
        and ai.cancelled_date is null
        and (aid.reversal_flag='N' or aid.reversal_flag is null)
        group by
        hou.name
        ,aps.segment1
        ,aps.vendor_name
        ,modt.do_number
        ,to_char(moh.mov_order_date,'DD-MON-RR')
        ,moh.mov_order_no
        ,moh.mov_order_status
        ,moh.warehouse_org_code
        ,moh.org_id
        ,decode(ai.payment_status_flag,
                'Y','Paid',
                'N','Unpaid') 
        ,aid.accounting_date
        ,moh.transport_mode
        ,moh.final_destination
        ,moh.vehicle_no
        ,aid.amount
        ,apsa.vendor_site_code  
        ,aid.attribute_category 
        ,ai.doc_sequence_value 
        ,aid.ATTRIBUTE1 
order by moh.mov_order_no
