select * from apps.po_headers_all
where TYPE_LOOKUP_CODE in ('RFQ')
--and FROM_HEADER_ID is not null
and segment1 in ('220127684','220127685')

SELECT   rh.segment1 REQ_NUM,
           rl.requisition_line_id,
           rl.requisition_header_id,
           ph.segment1 RFQ_NUM,
           pl.po_header_id,
           pl.po_line_id
    FROM   apps.po_requisition_headers_all rh,
           apps.po_requisition_lines_all rl,
           apps.po_headers_all ph,
           apps.po_lines_all pl
   WHERE       rh.requisition_header_id = rl.requisition_header_id
           AND rl.last_update_date = pl.creation_date
           AND pl.po_header_id = ph.po_header_id
           AND rl.on_rfq_flag = 'Y'
           AND rh.segment1 in ('120130204')
ORDER BY   requisition_line_id DESC