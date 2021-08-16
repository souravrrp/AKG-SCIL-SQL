select distinct
--        *
        imi.processing_status_code
--        ,imi.transaction_type
--        ,imi.match_type_code
        ,ai.set_of_books_id
        ,ai.org_id
--        ,imi.from_parent_table_name
        ,aid.period_name
        ,aid.accounting_date
        ,lc.lc_number
        ,pha.segment1
        ,rsh.shipment_num
        ,rsh.receipt_num
        ,rt.transaction_id
        ,rt.transaction_type
        ,rt.transaction_date        
        ,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item
        ,msi.description
        ,ai.cancelled_date
        ,ail.cancelled_flag
        ,ail.discarded_flag
        ,aid.cancellation_flag
        ,aid.reversal_flag
        ,aid.invoice_distribution_id
        ,ai.doc_sequence_value
        ,aid.line_type_lookup_code
        ,aid.invoice_line_number
        ,aid.distribution_line_number
        ,ail.cost_factor_id
        ,ppet.price_element_code
        ,aid.amount
        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
--        ,imi.to_parent_table_name
--        ,imi.to_parent_table_id
--        ,aid.po_distribution_id
--        ,ail.*
from 
        apps.inl_matches_int imi
--        ,apps.inl_matches ima
        ,apps.ap_invoices_all ai
        ,apps.ap_invoice_lines_all ail
        ,apps.ap_invoice_distributions_all aid
        ,apps.gl_code_combinations gcc
        ,apps.rcv_transactions rt
        ,apps.rcv_shipment_headers rsh
        ,apps.po_headers_all pha
        ,apps.po_lines_all pla
        ,apps.po_distributions_all pda
        ,apps.mtl_system_items_vl msi
        ,apps.xxakg_lc_details lc
        ,apps.pon_price_element_types ppet
where 1=1
        and ai.set_of_books_id in (2025)
        and ai.org_id in (83)
        and ai.doc_sequence_value in (216118776)
        and imi.from_parent_table_id=aid.invoice_distribution_id
--        and ima.from_parent_table_id=aid.invoice_distribution_id
        and aid.dist_code_combination_id=gcc.code_combination_id
        and ai.invoice_id=aid.invoice_id
        and ai.org_id=aid.org_id
        and ai.invoice_id=ail.invoice_id
        and ai.org_id=ail.org_id
        and ail.invoice_id=aid.invoice_id
        and ail.org_id=aid.org_id
        and aid.rcv_transaction_id(+)=imi.to_parent_table_id
        and imi.to_parent_table_id=rt.transaction_id
        and ail.line_number=aid.invoice_line_number
        and rt.shipment_header_id=rsh.shipment_header_id
        and pda.destination_organization_id=rsh.ship_to_org_id
        and pla.po_line_id=rt.po_line_id
        and pha.po_header_id=pla.po_header_id
        and pla.po_header_id=pda.po_header_id
        and pha.po_header_id=pda.po_header_id
        and pha.org_id=pla.org_id
        and pla.org_id=pda.org_id
        and pha.org_id=pda.org_id
        and pla.item_id=msi.inventory_item_id
        and pda.destination_organization_id=msi.organization_id
        and ai.set_of_books_id=lc.ledger_id
        and lc.org_id=pha.org_id
        and lc.org_id=ai.org_id
--        and lc.vendor_id=pha.vendor_id
--        and lc.vendor_id=ai.vendor_id
        and lc.po_header_id=pha.po_header_id
        and lc.po_number=pha.segment1
        and ail.cost_factor_id=ppet.price_element_type_id
--        and ima.match_int_id!=imi.match_int_id
--        and ima.from_parent_table_id!=imi.from_parent_table_id
--        and ima.to_parent_table_id!=imi.to_parent_table_id
--        and ima.charge_line_type_id!=imi.charge_line_type_id
        and not exists(select 1 from apps.inl_matches ima where aid.invoice_distribution_id=ima.from_parent_table_id)
order by ai.org_id
--        ,aid.period_name
        ,aid.accounting_date
        ,pha.segment1
        ,rsh.shipment_num
        ,rsh.receipt_num
        ,ai.doc_sequence_value
        ,aid.invoice_line_number
        ,aid.distribution_line_number
        

select distinct ima.*
from 
--        apps.po_headers_all
        apps.ap_invoices_all ai
--        apps.rcv_shipment_headers
--        apps.rcv_transactions
    ,apps.inl_matches_int imi
    ,apps.inl_matches ima
    ,apps.ap_invoice_lines_all ail
        ,apps.ap_invoice_distributions_all aid
    where 1=1
            and ai.invoice_id=ail.invoice_id
            and ai.invoice_id=aid.invoice_id
            and ail.invoice_id=aid.invoice_id
            and ai.org_id=ail.org_id
            and ai.org_id=aid.org_id
            and ail.org_id=aid.org_id
--            and imi.from_parent_table_id=aid.invoice_distribution_id
            and ima.from_parent_table_id=aid.invoice_distribution_id
--            and ima.from_parent_table_id=aid.invoice_distribution_id
            and ai.org_id in (83)
            and ai.set_of_books_id in (2025)
--            and aid.invoice_distribution_id in (7733943,
--7733944,
--7733946,
--7733947,
--7733950,
--7733951,
--7733956,
--7733957,
--7733959,
--7733960)
       and ai.doc_sequence_value in (216118776)
        and ima.match_int_id!=imi.match_int_id
        and ima.from_parent_table_id!=imi.from_parent_table_id
        and ima.to_parent_table_id!=imi.to_parent_table_id
        and ima.charge_line_type_id!=imi.charge_line_type_id
--        