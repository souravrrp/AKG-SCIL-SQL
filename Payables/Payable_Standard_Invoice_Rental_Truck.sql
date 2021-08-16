-----------------------------------------------------------------------------------------------

select
        hou.name operating_unit
--        ,ai.invoice_id
        ,aps.segment1 transporter_no
        ,aps.vendor_name transporter_name
--        ,modt.do_number
--        ,to_char(moh.mov_order_date,'DD-MON-RR') move_order_date
--        ,moh.mov_order_no
--        ,moh.mov_order_status status
--        ,(select ood.organization_name from apps.org_organization_definitions ood where moh.warehouse_org_code=ood.organization_code and moh.org_id=ood.operating_unit) warehouse
--        ,moh.warehouse_org_code
--        ,(select sum(ool.ordered_quantity) from apps.oe_order_lines_all ool where ool.shipment_priority_code=modt.do_number) quantity
        ,decode(ai.payment_status_flag,
                'Y','Paid',
                'N','Unpaid') bill_status
        ,sum(ai.invoice_amount) amount
        ,sum(ai.amount_paid) amount_paid
        ,aid.accounting_date
--        ,moh.transport_mode
--        ,moh.final_destination
--        ,moh.vehicle_no
        ,apsa.vendor_site_code supplier_site 
        ,ai.doc_sequence_value voucher_number
        ,gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5 "ACCOUNT_CODE"
        ,fndu.user_name user_id
--,ai.*
from 
        apps.ap_invoices_all ai
        ,apps.ap_invoice_lines_all ail
        ,apps.ap_invoice_distributions_all aid
        ,apps.ap_suppliers aps
        ,apps.ap_supplier_sites_all apsa
        ,apps.hr_operating_units hou
        ,apps.gl_code_combinations gcc
        ,apps.fnd_user fndu
--        ,apps.xxakg_mov_ord_hdr moh
--        ,apps.xxakg_mov_ord_dtl modt
where 1=1
        and ai.org_id=85
        and invoice_type_lookup_code='STANDARD'
--        and moh.warehouse_org_code='G03'
--        and aid.attribute2='MO/SCOU/036734'
--        and ai.doc_sequence_value in (218146000)
--        and gcc.segment3 IN ('4031804','4031805') 
        and TO_CHAR(aid.accounting_date,'MON-RR')='JAN-19' 
--        and aid.accounting_date>='01-JAN-2017'        
--        and aid.attribute_category='Trip Extra Charges'
--        and aid.attribute1='Trip Commission'
--        and moh.transport_mode='Rental Truck'
--        and moh.mov_ord_hdr_id=modt.mov_ord_hdr_id
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
--        and aid.attribute2=moh.mov_order_no
        and (ail.discarded_flag is null or ail.discarded_flag='N')
        and (ail.cancelled_flag is null or ail.cancelled_flag='N')
        and ai.cancelled_date is null
        and (aid.reversal_flag='N' or aid.reversal_flag is null)
        and aid.dist_code_combination_id=gcc.code_combination_id
        and fndu.user_id=ai.LAST_UPDATED_BY
        group by
        hou.name
        ,aps.segment1
        ,aps.vendor_name
--        ,modt.do_number
--        ,to_char(moh.mov_order_date,'DD-MON-RR')
--        ,moh.mov_order_no
--        ,moh.mov_order_status
--        ,moh.warehouse_org_code
--        ,moh.org_id
        ,decode(ai.payment_status_flag,
                'Y','Paid',
                'N','Unpaid') 
        ,aid.accounting_date
--        ,moh.transport_mode
--        ,moh.final_destination
--        ,moh.vehicle_no
        ,apsa.vendor_site_code  
        ,ai.doc_sequence_value 
        ,gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 || '-' || gcc.segment5
        ,fndu.user_name
--order by moh.mov_order_no