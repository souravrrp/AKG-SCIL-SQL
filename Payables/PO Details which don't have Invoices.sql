SELECT asp.vendor_name
      ,pha.segment1
      ,pha.creation_date po_date
      ,pha.type_lookup_code
      ,SUM(pla.unit_price* pla.quantity) po_amount
  FROM apps.po_distributions_all pda
      ,apps.po_headers_all pha
      ,apps.rcv_shipment_lines rsl
      ,apps.ap_suppliers asp
      ,apps.po_lines_all pla
 WHERE 1=1
   AND pda.po_header_id=pha.po_header_id
   AND pda.po_distribution_id NOT IN
      (SELECT po_distribution_id FROM apps.po_distributions_all pda
       WHERE po_distribution_id IN (SELECT DISTINCT  po_distribution_id FROM apps.ap_invoice_distributions_all))
   AND rsl.po_header_id=pha.po_header_id   
   AND asp.vendor_id=pha.vendor_id
   AND pha.po_header_id=pla.po_header_id
   AND pla.po_line_id=pda.po_line_id
GROUP BY asp.vendor_name,pha.segment1,pha.creation_date,pha.type_lookup_code
   