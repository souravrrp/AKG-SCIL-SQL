select distinct
        pha.segment1 po_number,
        lc.lc_number,
        rsh.shipment_num,
        rsh.receipt_num,
        rt.transaction_id,
        rt.transaction_type,
        ai.doc_sequence_value Invoice,
--        ail.cost_center_segment,
        ail.cost_factor_id,
        ppet.price_element_code,
        ail.amount,
        ail.original_amount
--        ai.cancelled_date
from
        apps.po_headers_all pha,
        apps.po_lines_all pla,
        apps.rcv_shipment_headers rsh,
        apps.rcv_transactions rt,
        apps.ap_invoices_all ai,
        apps.ap_invoice_lines_all ail,
        apps.ap_invoice_distributions_all aid,
        apps.xxakg_lc_details lc,
        apps.pon_price_element_types ppet
where 1=1
        and pha.segment1 in ('I/SCOU/002151')
--        and ai.doc_sequence_value in (217387733)
        and pha.po_header_id=pla.po_header_id
        and pha.po_header_id=rt.po_header_id(+)
        and pla.po_header_id=rt.po_header_id(+)
        and pla.po_line_id=rt.po_line_id(+) 
        and rsh.shipment_header_id(+)=rt.shipment_header_id
        and ai.invoice_id=ail.invoice_id
        and ai.invoice_id=aid.invoice_id
        and ail.invoice_id=aid.invoice_id
        and ai.org_id=ail.org_id
        and ai.org_id=aid.org_id
        and ail.org_id=aid.org_id
        and ail.po_header_id(+)=pha.po_header_id
        and ail.po_line_id(+)=pla.po_line_id
        and pha.po_header_id=lc.po_header_id
        and ail.rcv_transaction_id(+)=rt.transaction_id
        and ail.cost_factor_id(+)=ppet.price_element_type_id
--        and ai.cancelled_date is not null
order by pha.segment1,
            rt.transaction_id


----------------------------------------Destination type---------------------------------------------------------
select distinct
        ail.discarded_flag,
        ail.cancelled_flag,
        aid.reversal_flag,
        aid.accounting_date,
        ood.organization_code,
        aid.attribute_category,
        lc.po_number,
--        pla.line_num,
--        pda.destination_type_code,
        lc.lc_number,
        lc.lc_opening_date,
        ai.doc_sequence_value,
        mc.segment1 item_category,
--        mc.segment2 item_type,
        ail.match_type,
        ail.line_type_lookup_code,
        aid.invoice_line_number,
        aid.distribution_line_number,
        aid.amount,
        gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
from apps.ap_invoices_all ai,
        apps.ap_invoice_lines_all ail,
        apps.ap_invoice_distributions_all aid,
        apps.xxakg_lc_details lc,
        apps.po_headers_all pha,
        apps.po_lines_all pla,
        apps.po_distributions_all pda,
        apps.gl_code_combinations gcc,
        apps.org_organization_definitions ood,
        apps.mtl_item_categories mic,
        apps.mtl_categories mc,
        apps.mtl_category_sets mcs
WHERE 1=1
--        and ai.doc_sequence_value in (219092212)
--        and lc.po_number in 
--        and ail.match_type='NOT_MATCHED'
        and ai.org_id=85
        and pda.destination_type_code in ('INVENTORY')
        and aid.attribute_category like 'LC No.%LC Charge Information'
        and aid.accounting_date between '01-SEP-2015' and '18-AUG-2019'
--        and ail.discarded_flag in ('Y')
        and (ail.discarded_flag='N' or ail.discarded_flag is null)
        and (ail.cancelled_flag='N' or ail.cancelled_flag is null)
        and (aid.reversal_flag='N' or aid.reversal_flag is null)
        and ai.cancelled_date is null
        and ai.invoice_type_lookup_code!='PREPAYMENT'
        and ail.line_type_lookup_code!='PREPAY'
        and gcc.segment3='2050107'
        and ai.invoice_id=ail.invoice_id
        and ai.invoice_id=aid.invoice_id
        and ai.org_id=ail.org_id
        and ai.org_id=aid.org_id
        and ail.line_number=aid.invoice_line_number
        and aid.attribute1=lc.lc_id
        and lc.po_header_id=pha.po_header_id
        and pha.org_id=ai.org_id
        and pla.po_header_id=pha.po_header_id
        and pla.po_header_id=pda.po_header_id
        and pla.po_line_id=pda.po_line_id
        and ood.organization_id=pda.destination_organization_id
        and pla.category_id=mic.category_id(+)
        and pla.category_id=mc.category_id(+)
        and mc.structure_id=mcs.structure_id(+)
        and mic.category_set_id=mcs.category_set_id(+)
        and aid.dist_code_combination_id=gcc.code_combination_id
order by lc.po_number,
--            pla.line_num,
            ai.doc_sequence_value,
            aid.invoice_line_number,
            aid.distribution_line_number