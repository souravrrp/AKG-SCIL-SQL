SELECT 
t.org_id, 
 c.customer_name, 
c.customer_number, 
c.customer_id,
t.customer_trx_id, 
t.trx_number, 
ct.NAME invoice_type,
l.quantity_invoiced,
l.revenue_amount,
l.line_number, 
cc.segment1, 
cc.segment2,
cc.segment3, 
cc.segment4, 
cc.segment5, 
cc.segment6, 
d.gl_date,
d.cust_trx_line_gl_dist_id, 
d.code_combination_id,
d.account_class
--,l.*
FROM apps.ra_cust_trx_types_all ct,
apps.ar_customers c,
apps.ra_customer_trx_all t,
apps.ra_customer_trx_lines_all l,
apps.gl_code_combinations cc,
apps.ra_cust_trx_line_gl_dist_all d
WHERE 1 = 1
AND t.org_id=82
AND t.cust_trx_type_id = ct.cust_trx_type_id
AND t.bill_to_customer_id = c.customer_id
AND d.customer_trx_id = t.customer_trx_id
AND d.customer_trx_line_id = l.customer_trx_line_id(+)
AND d.code_combination_id = cc.code_combination_id
AND TO_CHAR (d.gl_date, 'MON-RR') = 'JAN-19'
--AND TO_CHAR (d.gl_date, 'RRRR') = '2019'
--AND TRUNC (d.gl_date) >= TO_DATE ('01-07-2018', 'DD-MM-YYYY')
--AND d.posting_control_id = -3
--AND d.account_set_flag = 'N'
AND d.account_class = 'REV'
and cc.segment1='2300'
and cc.segment2='BULK'
and cc.segment3='3010101'

------------------------------------Rvenue Summary----------------------------------------

SELECT 
--t.org_id, 
--c.customer_name, 
--c.customer_number, 
--c.customer_id,
--t.customer_trx_id, 
--t.trx_number, 
--t.interface_header_attribute1 move_order_no,
--ct.NAME invoice_type,
--l.quantity_invoiced,
sum(l.revenue_amount),
--l.line_number,
cc.segment1 || '.' || cc.segment2 || '.' || cc.segment3 || '.' || cc.segment4 || '.' || cc.segment5  account_combination
--to_char(d.gl_date,'MON-RR') period
--d.gl_date,
--d.cust_trx_line_gl_dist_id, 
--d.code_combination_id,
--d.account_class
--,ct.*
FROM apps.ra_cust_trx_types_all ct,
apps.ar_customers c,
apps.ra_customer_trx_all t,
apps.ra_customer_trx_lines_all l,
apps.gl_code_combinations cc,
apps.ra_cust_trx_line_gl_dist_all d
WHERE 1 = 1
AND t.org_id=82
AND t.cust_trx_type_id = ct.cust_trx_type_id
AND t.bill_to_customer_id = c.customer_id
AND d.customer_trx_id = t.customer_trx_id
AND d.customer_trx_line_id = l.customer_trx_line_id(+)
AND d.code_combination_id = cc.code_combination_id
--AND t.interface_header_attribute1='MO/SCOU/1239563'
AND ct.NAME='AKCL Trip Invoice'
--AND TO_CHAR (d.gl_date, 'MON-RR') = 'JAN-19'
AND TO_CHAR (d.gl_date, 'RRRR') = '2019'
AND TRUNC (d.gl_date) <= TO_DATE ('31-03-2019', 'DD-MM-YYYY')
--AND d.posting_control_id = -3
--AND d.account_set_flag = 'N'
AND d.account_class = 'REV'
--AND cc.segment1 || '.' || cc.segment2 || '.' || cc.segment3 || '.' || cc.segment4 || '.' || cc.segment5 
--in 
--('2300.BULK.3010101.9999.00',
--'2300.CDTRK.3010101.9999.00',
--'2300.FCTRK.3010101.9999.00',
--'2300.GHTRK.3010101.9999.00',
--'2300.MEMRY.3010101.9999.00')
--='2300.BULK.3010101.9999.00'
--and cc.segment1='2300'
--and cc.segment2='BULK'
--and cc.segment3='3010101'
group bY
cc.segment1 || '.' || cc.segment2 || '.' || cc.segment3 || '.' || cc.segment4 || '.' || cc.segment5 
--,d.gl_date

------------------------------------Rvenue Details----------------------------------------

SELECT 
t.org_id, 
c.customer_number,
c.customer_name, 
--c.customer_id,
--t.customer_trx_id, 
moh.mov_order_no,
--t.trx_number ar_trx_number, 
t.doc_sequence_value ar_vouchar_no,
aia.doc_sequence_value ap_vouchar_no,
--t.interface_header_attribute1 move_order_no,
--ct.NAME invoice_type,
l.quantity_invoiced,
l.revenue_amount,
--aia.invoice_amount,
--sum(l.revenue_amount),
--l.line_number,
--cc.segment1 || '.' || cc.segment2 || '.' || cc.segment3 || '.' || cc.segment4 || '.' || cc.segment5  account_combination
--to_char(d.gl_date,'MON-RR') period
--d.gl_date,
--d.cust_trx_line_gl_dist_id, 
--d.code_combination_id,
--d.account_class
--,hp.party_name
--,hps.party_site_name
aps.segment1 supplier_no
,aps.vendor_name supplier_name
,apsa.vendor_site_code supplier_site
--,t.*
--,aia.*
FROM 
apps.xxakg_mov_ord_hdr moh,
apps.ap_invoices_all aia,
--apps.ra_cust_trx_types_all ct,
apps.ar_customers c,
apps.ra_customer_trx_all t,
apps.ra_customer_trx_lines_all l
--apps.gl_code_combinations cc,
--apps.ra_cust_trx_line_gl_dist_all d
--,apps.hz_parties hp
--,apps.hz_party_sites hps
,apps.ap_suppliers aps
,apps.ap_supplier_sites_all apsa
WHERE 1 = 1
AND t.org_id=82
--AND t.cust_trx_type_id = ct.cust_trx_type_id
AND t.bill_to_customer_id = c.customer_id
AND l.customer_trx_id = t.customer_trx_id
--AND d.customer_trx_line_id = l.customer_trx_line_id(+)
--AND d.code_combination_id = cc.code_combination_id
--AND t.interface_header_attribute1='MO/SCOU/1240171'
and t.attribute15=moh.mov_ord_hdr_id
and aia.invoice_num=moh.mov_order_no
and aia.source in ('AKG TRIP INVOICE')
and t.interface_header_context='CEMENT TRIP INVOICE'
--and aia.party_site_id=hps.party_site_id
--and hp.party_id=aia.party_id
and aps.vendor_id=aia.vendor_id
and aia.vendor_site_id=apsa.vendor_site_id
--AND ct.NAME='AKCL Trip Invoice'
AND TO_CHAR (aia.gl_date, 'MON-RR') = 'JAN-19'
--AND TO_CHAR (d.gl_date, 'MON-RR') = 'JAN-19'
--AND TO_CHAR (d.gl_date, 'RRRR') = '2019'
--AND TRUNC (d.gl_date) <= TO_DATE ('31-03-2019', 'DD-MM-YYYY')
--AND d.posting_control_id = -3
--AND d.account_set_flag = 'N'
--AND d.account_class = 'REV'
--AND cc.segment1 || '.' || cc.segment2 || '.' || cc.segment3 || '.' || cc.segment4 || '.' || cc.segment5 
--in 
--('2300.BULK.3010101.9999.00',
--'2300.CDTRK.3010101.9999.00',
--'2300.FCTRK.3010101.9999.00',
--'2300.GHTRK.3010101.9999.00',
--'2300.MEMRY.3010101.9999.00')
--='2300.BULK.3010101.9999.00'
--and cc.segment1='2300'
--and cc.segment2='BULK'
--and cc.segment3='3010101'
--group bY
--cc.segment1 || '.' || cc.segment2 || '.' || cc.segment3 || '.' || cc.segment4 || '.' || cc.segment5 
--,d.gl_date