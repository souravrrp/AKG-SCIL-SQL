SELECT distinct
t.org_id, 
 c.customer_name, 
c.customer_number, 
c.customer_id,
t.customer_trx_id, 
t.trx_number, 
ct.NAME invoice_type,
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
FROM apps.ra_cust_trx_types_all ct,
apps.ar_customers c,
apps.ra_customer_trx_all t,
apps.ra_customer_trx_lines_all l,
apps.gl_code_combinations cc,
apps.ra_cust_trx_line_gl_dist_all d
WHERE 1 = 1
AND t.cust_trx_type_id = ct.cust_trx_type_id
AND t.bill_to_customer_id = c.customer_id
AND d.customer_trx_id = t.customer_trx_id
AND d.customer_trx_line_id = l.customer_trx_line_id(+)
AND d.code_combination_id = cc.code_combination_id
AND TRUNC (d.gl_date) >= TO_DATE ('01-07-2018', 'DD-MM-YYYY')
AND d.posting_control_id = -3
AND d.account_set_flag = 'N'
AND d.account_class = 'REV'
