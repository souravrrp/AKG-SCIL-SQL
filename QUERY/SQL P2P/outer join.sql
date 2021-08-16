select * from apps.ap_invoices_all
where doc_sequence_value=117001974

select * from apps.per_people_f

select * from apps.po_headers_all
where segment1='L/SCOU/000070'

select * from apps.po_lines_all pla
where po_header_id=24056

select * from apps.rcv_transactions rt

select * from apps.rcv_shipment_headers rsh

select shipment_line_id from apps.rcv_shipment_lines
where po_header_id=897306

select * from apps.po_distributions_all pda
where po_distribution_id=929484

select * from apps.ap_invoices_all
where doc_sequence_value=217015958


select * from apps.ap_invoice_distributions_all
where po_distribution_id=11171

---PO doesn't have GRN or Invoice
select DISTINCT pha.segment1,
         rsh.receipt_num,
         aia.doc_sequence_value,
         aia.cancelled_date,
         TO_CHAR (TRUNC (aia.creation_date), 'DD-MON-RR') creation_date,
         TO_CHAR (TRUNC (aia.last_update_date), 'DD-MON-RR') last_update_date
from apps.po_headers_all pha,
        apps.po_lines_all pla,
        apps.po_distributions_all pda,
       apps.rcv_shipment_lines rsl,
        apps.rcv_shipment_headers rsh,
        apps.ap_invoices_all aia,
        apps.ap_invoice_lines_all ail
where pha.segment1 in ('L/COU/008068')
        and rsh.receipt_num in (18973)
--        and aia.doc_sequence_value in(217373338,217390024)
        and pha.po_header_id=pla.po_header_id
        and pha.po_header_id=rsl.po_header_id(+)
        --and pla.po_line_id=rt.po_line_id(+)
        and rsl.shipment_header_id=rsh.shipment_header_id(+)
        and ail.po_distribution_id(+)=pda.po_distribution_id
        and aia.invoice_id(+)=ail.invoice_id
        and pla.po_header_id=pda.po_header_id
        and pla.po_line_id=pda.po_line_id
        and ail.rcv_shipment_line_id(+)=rsl.shipment_line_id
        order by doc_sequence_value desc


---PO doesn't have Invoice
select distinct pha.segment1,
        aia.doc_sequence_value,
        aia.cancelled_date
from apps.po_headers_all pha,
        apps.po_lines_all pla,
        apps.po_distributions_all pda,
        apps.ap_invoices_all aia,
        apps.ap_invoice_distributions_all aid
where segment1 in ('L/SCOU/021338')
        and pha.po_header_id=pla.po_header_id
        and aid.po_distribution_id(+)=pda.po_distribution_id
        and aia.invoice_id(+)=aid.invoice_id
        and pla.po_header_id=pda.po_header_id
        and pla.po_line_id=pda.po_line_id
        order by segment1 desc

---PO doesn't have GRN
select pha.segment1,
        rsh.receipt_num
from apps.po_headers_all pha,
    apps.rcv_shipment_lines rsl,
    apps.rcv_shipment_headers rsh
where pha.po_header_id=rsl.po_header_id(+)
        and rsl.shipment_header_id=rsh.shipment_header_id(+)
        and pha.segment1 in ('L/SCOU/000070','L/SCOU/000069','I/SCOU/001635')
        order by segment1 desc
