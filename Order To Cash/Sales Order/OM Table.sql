Order Management Tables. Entered
oe_order_headers_all 1 record created in header tableoe_order_lines_all Lines for particular records
oe_price_adjustments When discount gets applied
oe_order_price_attribs If line has price attributes then populated
oe_order_holds_all If any hold applied for order like credit check etc.
Booked
oe_order_headers_all Booked_flag=Y Order booked.wsh_delivery_details Released_status Ready to release
Pick Released 
wsh_delivery_details Released_status=Y Released to Warehouse (Line has been released to Inventory for processing)
wsh_picking_batches After batch is created for pick release. 
mtl_reservations This is only soft reservations. No physical movement of stock
Full Transaction
mtl_material_transactions No records in mtl_material_transactionsmtl_txn_request_headers
mtl_txn_request_lines
wsh_delivery_details Released to warehouse.wsh_new_deliveries if Auto-Create is Yes then data populated.wsh_delivery_assignments deliveries get assigned
Pick Confirmed
wsh_delivery_details Released_status=Y Hard Reservations. Picked the stock. Physical movement of stock
Ship Confirmed
wsh_delivery_details Released_status=C Y To C:Shipped ;Delivery Note get printed Delivery assigned to trip stop quantity will be decreased from stagedmtl_material_transactions On the ship confirm form, check Ship all boxwsh_new_deliveries If Defer Interface is checked I.e its deferred then OM & inventory not updated. If Defer Interface is not checked.: Shipped
oe_order_lines_all Shipped_quantity get populated.wsh_delivery_legs 1 leg is called as 1 trip.1 Pickup & drop up stop for each trip.
oe_order_headers_all If all the lines get shipped then only flag N
Autoinvoice
wsh_delivery_details Released_status=I Need to run workflow background process.
ra_interface_lines_all Data will be populated after workflow process.
ra_customer_trx_all After running Autoinvoice Master Program forra_customer_trx_lines_all specific batch transaction tables get populated
Price Detailsqp_list_headers_b To Get Item Price Details.
qp_list_lines
Items On Hand Qty
mtl_onhand_quantities TO check On Hand Qty Items.

Payment Terms
ra_terms Payment terms

AutoMatic Numbering System
ar_system_parametes_all you can check Automatic Numbering is enabled/disabled.
Customer Information
hz_parties Get Customer information include name,contacts,Address and Phonehz_party_sites
hz_locations
hz_cust_accounts
hz_cust_account_sites_all
hz_cust_site_uses_all
ra_customers
Document Sequence
fnd_document_sequences Document Sequence Numbersfnd_doc_sequence_categories
fnd_doc_sequence_assignments
Default rules for Price List
oe_def_attr_def_rules Price List Default Rulesoe_def_attr_condns
ak_object_attributes
End User Details 
csi_t_party_details To capture End user Details

Sales Credit Sales Credit Information(How much credit can get)oe_sales_credits

Attaching Documents 
fnd_attached_documents Attached Documents and Text information
fnd_documents_tl
fnd_documents_short_text

Blanket Sales Order
oe_blanket_headers_all Blanket Sales Order Information.
oe_blanket_lines_all

Processing Constraints
oe_pc_assignments Sales order Shipment schedule Processing Constraints
oe_pc_exclusions
Sales Order Holds
oe_hold_definitions Order Hold and Managing Details.
oe_hold_authorizations
oe_hold_sources_all
oe_order_holds_all

Hold Release
oe_hold_releases_all Hold released Sales Order.

Credit Chk Details
oe_credit_check_rules To get the Credit Check Against Customer.
Cancel Ordersoe_order_lines_all Cancel Order Details.