----------------------------Sales_Return_GRN---------------------------------

SELECT
OOH.ORG_ID,
RT.ORGANIZATION_ID,
--OOH.ORDER_TYPE_ID,
OOH.ORDER_NUMBER,
OOL.ORDERED_ITEM,
OOL.INVENTORY_ITEM_ID,
OOL.UNIT_SELLING_PRICE,
OOL.UNIT_COST,
OOL.ACTUAL_SHIPMENT_DATE,
OOL.FLOW_STATUS_CODE,
OOL.INVOICED_QUANTITY,
RSL.QUANTITY_SHIPPED,
RSL.QUANTITY_RECEIVED,
--RSL.UNIT_OF_MEASURE,
RSL.ITEM_DESCRIPTION,
RT.TRANSACTION_TYPE,
RT.QUANTITY,
RT.UOM_CODE,
RT.SUBINVENTORY,
--,RT.DESTINATION_CONTEXT
--RT.CUSTOMER_ID
--RT.CUSTOMER_SITE_ID
--,RSH.EMPLOYEE_ID
--,RSH.CUSTOMER_ID
RSH.RECEIPT_NUM
--,RT.INTERFACE_TRANSACTION_ID
--,RT.TRANSACTION_ID
--,MIL.*
FROM
APPS.RCV_TRANSACTIONS RT,
APPS.RCV_SHIPMENT_HEADERS RSH,
APPS.RCV_SHIPMENT_LINES RSL,
APPS.OE_ORDER_HEADERS_ALL OOH,
APPS.OE_ORDER_LINES_ALL OOL
--,APPS.MTL_ITEM_LOCATIONS MIL
--,APPS.MTL_TRANSACTIONS_INTERFACE MTI
WHERE 1=1
--AND RT.LOCATION_ID=MIL.INVENTORY_LOCATION_ID
AND RT.SHIPMENT_HEADER_ID=RSH.SHIPMENT_HEADER_ID
AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID
AND RT.OE_ORDER_HEADER_ID=OOH.HEADER_ID
AND RT.OE_ORDER_LINE_ID=OOL.LINE_ID
AND OOH.HEADER_ID=OOL.HEADER_ID
AND OOL.INVENTORY_ITEM_ID=RSL.ITEM_ID
--AND MTI.TRANSACTION_INTERFACE_ID=RT.INTERFACE_TRANSACTION_ID
--AND OOL.INVENTORY_ITEM_ID=MTI.INVENTORY_ITEM_ID
--AND OOH.ORDER_TYPE_ID='1014'
--AND RSH.ORGANIZATION_ID=101
--AND RSH.RECEIPT_NUM=16231
AND RSH.RECEIPT_NUM=:P_RECEIPT_NUM
--AND OOH.ORDER_NUMBER=:P_ORDER_NUMBER
AND RT.SOURCE_DOCUMENT_CODE='RMA'
AND TRANSACTION_TYPE IN ('ACCEPT','DELIVER','RECEIVE','REJECT')

---------------------------------------**************-----------------------------------

SELECT
RT.ORGANIZATION_ID,
RSL.QUANTITY_SHIPPED,
RSL.QUANTITY_RECEIVED,
--RSL.UNIT_OF_MEASURE,
RSL.ITEM_DESCRIPTION,
RT.TRANSACTION_TYPE,
RT.QUANTITY,
RT.UOM_CODE,
RT.SUBINVENTORY,
--,RT.DESTINATION_CONTEXT
--RT.CUSTOMER_ID
--RT.CUSTOMER_SITE_ID
--,RSH.EMPLOYEE_ID
--,RSH.CUSTOMER_ID
RSH.RECEIPT_NUM
--,RT.INTERFACE_TRANSACTION_ID
--,RT.TRANSACTION_ID
,RT.*
FROM
APPS.RCV_TRANSACTIONS RT,
APPS.RCV_SHIPMENT_HEADERS RSH,
APPS.RCV_SHIPMENT_LINES RSL
--APPS.MTL_SYSTEM_ITEMS_B MSI
--,APPS.PO_HEADERS_ALL PHA
--,APPS.PO_LINES_ALL PLA
--,APPS.MTL_TRANSACTIONS_INTERFACE MTI
WHERE 1=1
--AND RT.PO_HEADER_ID=PHA.PO_HEADER_ID
--AND PLA.PO_HEADER_ID=PHA.PO_HEADER_ID
--AND RT.PO_LINE_ID=PLA.PO_LINE_ID
--AND RT.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND RT.SHIPMENT_HEADER_ID=RSH.SHIPMENT_HEADER_ID
AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID
--AND MSI.INVENTORY_ITEM_ID=RSL.ITEM_ID
--AND MTI.TRANSACTION_INTERFACE_ID=RT.INTERFACE_TRANSACTION_ID
--AND OOL.INVENTORY_ITEM_ID=MTI.INVENTORY_ITEM_ID
--AND OOH.ORDER_TYPE_ID='1014'
AND RSH.ORGANIZATION_ID=95
--AND RSH.RECEIPT_NUM=1072
AND RSH.RECEIPT_NUM=:P_RECEIPT_NUM
--AND TRANSACTION_TYPE IN ('TRANSFER','ACCEPT','DELIVER','RECEIVE','REJECT','RETURN TO VENDOR','CORRECT','RETURN TO RECEIVING','UNORDERED','RETURN TO CUSTOMER')
--AND RT.SOURCE_DOCUMENT_CODE='PO'


---------------------------------------*****************--------------------------------------------------


SELECT aia.org_id,
        pha.segment1 po_number,
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
        ,MIL.segment1 || '.' || MIL.segment2 || '.' || MIL.segment3  "INV Item Location"
        ,MIL.*
  FROM apps.rcv_transactions rt,
       apps.po_headers_all pha,
       apps.po_line_locations_all plla,
       apps.po_distributions_all pda,
       apps.po_lines_all pla,
       apps.mtl_system_items msi,
       apps.rcv_shipment_headers rsh,
       apps.rcv_shipment_lines rsl,
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
       ,APPS.MTL_ITEM_LOCATIONS MIL
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
       and rsh.shipment_header_id=rsl.shipment_header_id
       and rsh.shipment_header_id=rt.shipment_header_id
       and rt.shipment_header_id=rsl.shipment_header_id
       AND RT.LOCATION_ID=MIL.INVENTORY_LOCATION_ID
       AND rt.transaction_type = 'DELIVER'
--       AND RT.SOURCE_DOCUMENT_CODE='PO'
--       AND RT.DESTINATION_TYPE_CODE='INVENTORY'
--       AND ail.line_type_lookup_code = 'ITEM'
--       AND aid.line_type_lookup_code = 'ACCRUAL'
       AND pha.segment1 =:P_PO_NUMBER--'L/FSOU/000106'--'L/SCOU/026910' --PO_NUMBER
       
       
---------------------------------------------------------------------------------------------------
