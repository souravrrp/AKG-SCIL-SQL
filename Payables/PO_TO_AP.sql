SELECT pha.segment1 po_number,
        pha.type_lookup_code,
        pha.authorization_status,
        pha.approved_date,
        pla.item_id,
        pla.item_description,
        pla.unit_meas_lookup_code,
        pla.list_price_per_unit,
        pla.quantity,
        pla.unit_price po_unit_price,
--       pla.line_num,
--       plla.shipment_num,
       msi.inventory_item_id,
       msi.organization_id,
       MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 "Inventory Item Code",
       msi.description Invnetory_item_description,
       msi.primary_uom_code,
       msi.list_price_per_unit inventory_unit_price,
       msi.purchasing_item_flag,
       msi.purchasing_enabled_flag,
       msi.expense_account,
       rt.transaction_type,
       rt.transaction_date,
       rt.subinventory,
       plla.quantity quantity_ordered,
       plla.quantity_received,
       pda.quantity_delivered,
       plla.quantity_Billed,
       rsh.receipt_num grn_number,
       aia.invoice_num,
       ail.line_number inv_line_number,
       aid.distribution_line_number inv_dist_number,
       ail.line_type_lookup_code Line_type,
       aid.line_type_lookup_code Dist_line_type,
       aid.amount,
       aid.quantity_invoiced,
       ac.check_number,
       aip.payment_num
       ,gcc.segment2 "Cost Centre" 
       ,gcc.segment1 || '.' || gcc.segment2 || '.' || gcc.segment3 || '.' || gcc.segment4 "Account"
        ,gcc.segment3 "Natural Account"
--        ,aid.*
  FROM apps.rcv_transactions rt,
       apps.po_headers_all pha,
       apps.po_line_locations_all plla,
       apps.po_distributions_all pda,
       apps.po_lines_all pla,
       apps.mtl_system_items msi,
       apps.rcv_shipment_headers rsh,
       apps.ap_invoices_all aia,
       apps.ap_invoice_lines_all ail,
       apps.ap_invoice_distributions_all aid,
       apps.ap_invoice_payments_all aip,
       apps.ap_payment_schedules_all apsa,
       apps.ap_suppliers aps,
       apps.ap_supplier_sites_all assa,
       apps.ap_checks_all ac
       ,apps.po_vendors pv
       ,apps.po_vendor_sites_all pvsa
       ,apps.gl_code_combinations gcc
WHERE  1=1
--       AND pha.org_id=85   
--       AND msi.organization_id=94
       AND rt.po_header_id = pha.po_header_id
       AND pha.po_header_id = pla.po_header_id
       AND pla.po_line_id = plla.po_line_id
       AND plla.line_location_id = pda.line_location_id
       AND rt.po_line_location_id = plla.line_location_id
       AND pla.item_id = msi.inventory_item_id
       AND rt.po_line_id = pla.po_line_id
       AND rt.organization_id = msi.organization_id
       AND rsh.shipment_header_id = rt.shipment_header_id
       AND aip.check_id = ac.check_id
       AND aia.invoice_id = aip.invoice_id
       AND aia.invoice_id = ail.invoice_id
       AND aia.invoice_id = aid.invoice_id
       AND pda.po_distribution_id = aid.po_distribution_id
       and pv.vendor_id=pha.vendor_id
       and pv.vendor_id=pvsa.vendor_id
       and pvsa.vendor_site_id=pha.vendor_site_id
       and gcc.code_combination_id=pda.code_combination_id
       and aia.invoice_id = apsa.invoice_id
       and aia.vendor_id = aps.vendor_id
       and aps.vendor_id = assa.vendor_id
       and aia.vendor_site_id = assa.vendor_site_id
       AND rt.transaction_type = 'DELIVER'
       AND ail.line_type_lookup_code = 'ITEM'
       AND aid.line_type_lookup_code = 'ACCRUAL'
       AND pha.segment1 ='L/FSOU/000106'--'L/SCOU/026910' --
