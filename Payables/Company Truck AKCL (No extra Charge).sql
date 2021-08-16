SELECT
MOH.*
FROM 
APPS.XXAKG_MOV_ORD_HDR MOH
WHERE 1=1
AND MOH.WAREHOUSE_ORG_CODE!='SCI'
AND MOH.READY_FOR_INVOICE='Y'
AND MOH.AP_FLAG='Y'
AND MOH.TRANSPORT_MODE='Company Truck'
AND TO_CHAR(MOH.MOV_ORDER_DATE,'MON-RR')='APR-18'
AND NOT EXISTS(SELECT 1 FROM
APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
WHERE 1=1
AND AIDA.ORG_ID=82
AND AIDA.ATTRIBUTE2=MOH.MOV_ORDER_NO)



-------------------------------No Extra Charge----------------------------------------------
select        
        'ABUL KHAIR CARRIER OPERATING UNIT' Operating_unit
--        ,ai.invoice_id
        ,'6530' Transporter_no
        ,'Trip Charge Supplier' Transporter_name
        ,modt.do_number
        ,to_char(moh.mov_order_date,'DD-MON-RR') move_order_date
        ,to_char(moh.mov_order_no) move_order_no
        ,moh.mov_order_status status
        ,(select ood.organization_name from apps.org_organization_definitions ood where moh.warehouse_org_code=ood.organization_code and moh.org_id=ood.operating_unit) warehouse
        ,moh.warehouse_org_code
        ,(select sum(ool.ordered_quantity) from apps.oe_order_lines_all ool where ool.shipment_priority_code=modt.do_number) quantity
        ,'Not Invoiced' Bill_status
        ,' ' Amount --No Invoice Amount
        ,' ' Amount_paid --No Paid Amount
        ,' ' Accounting_date --No date avilable
        ,moh.transport_mode
        ,moh.final_destination
        ,moh.vehicle_no
        ,'TRIP SUP' Supplier_site
        ,'Trip Extra Charges' Payment_category
        ,' ' voucher_number
FROM 
APPS.XXAKG_MOV_ORD_HDR MOH
,XXAKG.XXAKG_MOV_ORD_DTL MODT
WHERE 1=1
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND MOH.WAREHOUSE_ORG_CODE!='SCI'
AND MOH.READY_FOR_INVOICE='Y'
AND MOH.AP_FLAG='Y'
AND MOH.TRANSPORT_MODE='Company Truck'
AND TO_CHAR(MOH.MOV_ORDER_DATE,'MON-RR')='APR-18'
AND MOH.MOV_ORDER_NO='MO/SCOU/1074530'
AND NOT EXISTS(SELECT 1 FROM APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA WHERE AIDA.ORG_ID=82 AND AIDA.ATTRIBUTE2=MOH.MOV_ORDER_NO)



-------------------------------------DETAILS-------------------------------------------------
select        
        'ABUL KHAIR CARRIER OPERATING UNIT' Operating_unit
--        ,ai.invoice_id
        ,'6530' Transporter_no
        ,'Trip Charge Supplier' Transporter_name
        ,modt.do_number
        ,to_char(moh.mov_order_date,'DD-MON-RR') move_order_date
        ,to_char(moh.mov_order_no) move_order_no
        ,moh.mov_order_status status
        ,(select ood.organization_name from apps.org_organization_definitions ood where moh.warehouse_org_code=ood.organization_code and moh.org_id=ood.operating_unit) warehouse
        ,moh.warehouse_org_code
        ,(select sum(ool.ordered_quantity) from apps.oe_order_lines_all ool where ool.shipment_priority_code=modt.do_number) quantity
        ,'Not Paid' Bill_status
        ,to_char('-') amount 
        ,to_char('--') Amount_paid 
        ,to_char('---') Accounting_date 
        ,moh.transport_mode
        ,moh.final_destination
        ,moh.vehicle_no
        ,'TRIP SUP' Supplier_site
        ,'Trip Extra Charges' Payment_category
        ,to_char('----') voucher_number
FROM 
APPS.XXAKG_MOV_ORD_HDR MOH
,XXAKG.XXAKG_MOV_ORD_DTL MODT
WHERE 1=1
AND MODT.MOV_ORD_HDR_ID=MOH.MOV_ORD_HDR_ID
AND MOH.WAREHOUSE_ORG_CODE='G03'
AND MOH.READY_FOR_INVOICE='Y'
AND MOH.AP_FLAG='Y'
AND MOH.TRANSPORT_MODE='Company Truck'
--AND TO_CHAR(MOH.MOV_ORDER_DATE,'MON-RR')='APR-18'
and MOH.MOV_ORDER_DATE between '01-Jan-2017' and '31-Dec-2017'
--AND MOH.MOV_ORDER_NO='MO/SCOU/1074530'
AND NOT EXISTS(SELECT 1 FROM APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA WHERE AIDA.ORG_ID=82 AND AIDA.ATTRIBUTE2=MOH.MOV_ORDER_NO)
UNION ALL
select 
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
        ,to_char(sum(ai.invoice_amount)) amount
        ,to_char(sum(ai.amount_paid)) amount_paid
        ,to_char(aid.accounting_date) accounting_date
        ,moh.transport_mode
        ,moh.final_destination
        ,moh.vehicle_no
        ,apsa.vendor_site_code supplier_site 
        ,aid.attribute_category payment_category
        ,to_char(ai.doc_sequence_value) voucher_number
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
        and moh.warehouse_org_code='G03'
--        and aid.attribute2='MO/SCOU/036734'
--        AND TO_CHAR(MOH.MOV_ORDER_DATE,'MON-RR')='APR-18'
--        and ai.doc_sequence_value in (218129626)
--        and TO_CHAR (aid.accounting_date, 'MON-RR') = 'APR-18'
--        and TO_CHAR (aid.accounting_date, 'RRRR') = '2018'
        and aid.accounting_date between '01-Jan-2017' and '31-Dec-2017'
--        and aid.accounting_date>='01-JAN-2017'               
        and aid.attribute_category='Trip Extra Charges'
        and aid.attribute1='Trip Commission'
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
        ,apsa.vendor_site_code  
        ,aid.attribute_category 
        ,ai.doc_sequence_value 