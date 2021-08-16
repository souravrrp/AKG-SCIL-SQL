SELECT cust.customer_number,
cust.customer_name,
ord.trx_date period_name,
order_value,
receipt_amount,
order_qty,
ord.OPERAND adj_rate,
avg_rate_per_qty,
(CASE WHEN nvl(receipt_amount,0)=0 THEN NULL
WHEN receipt_amount >= order_value THEN order_qty*ord.OPERAND
WHEN receipt_amount < order_value THEN ROUND ( (receipt_amount / avg_rate_per_qty), 0)*ord.OPERAND
ELSE NULL
END) adjustment_value,
(CASE WHEN receipt_amount >= order_value THEN '5/10 TK Discount will be applied over - ORDER_VALUE ' || order_value || ' tk.'
WHEN receipt_amount < order_value THEN '5/10 TK Discount will be applied over - RECEIPT_AMOUNT ' || receipt_amount || ' tk.'
ELSE 'No Discount'
END) advanced_pricing_rules
FROM 
(SELECT ooh.sold_to_org_id customer_id, DIS.OPERAND,
TO_CHAR (ooh.ordered_date,'MON-YYYY') trx_date,
SUM (ool.unit_selling_price * ool.ordered_quantity) order_value,
SUM (ool.ordered_quantity) order_qty,
SUM (ool.unit_selling_price * ool.ordered_quantity)/SUM (ool.ordered_quantity) avg_rate_per_qty
FROM apps.oe_order_lines_all ool, apps.oe_order_headers_all ooh, ont.oe_price_adjustments dis
WHERE ooh.org_id = 85
AND dis.list_header_id='1096622' --SCIL Cash Discount on value of Collection
AND ooh.header_id=dis.header_id(+)
AND ool.line_id=dis.line_id(+)
AND ooh.header_id = ool.header_id
AND ooh.flow_status_code IN ('BOOKED','CLOSED')
AND ool.ordered_item IN
('CMNT.SBAG.0001',
'CMNT.SBAG.0003',
'CMNT.PBAG.0001',
'CMNT.PBAG.0003')
AND TO_CHAR (ooh.ordered_date, 'MON-YYYY') = 'JUL-2019'
AND ool.line_category_code = 'ORDER'
AND ool.cancelled_flag = 'N'
GROUP BY TO_CHAR (ooh.ordered_date,'MON-YYYY'), ooh.sold_to_org_id,DIS.OPERAND
) ord,
(SELECT cra.pay_from_customer customer_id,
TO_CHAR(crh.gl_date,'MON-YYYY') trx_date,
SUM (cra.amount) receipt_amount
FROM apps.ar_cash_receipts_all cra,
apps.ar_cash_receipt_history_all crh --,
--(SELECT MIN (cash_receipt_history_id) cash_receipt_history_id, cash_receipt_id FROM apps.ar_cash_receipt_history_all GROUP BY cash_receipt_id) crh1
WHERE cra.org_id = 85
AND cra.cash_receipt_id = crh.cash_receipt_id
AND cra.status != 'REV'
AND cra.TYPE = 'CASH'
AND crh.cash_receipt_history_id = (SELECT MIN (cash_receipt_history_id) cash_receipt_history_id from apps.ar_cash_receipt_history_all crh1 WHERE crh1.cash_receipt_id=cra.cash_receipt_id) --crh1.cash_receipt_history_id
AND TO_CHAR (crh.gl_date, 'MON-YYYY') = 'JUL-2019'
GROUP BY TO_CHAR(crh.gl_date,'MON-YYYY'), cra.pay_from_customer
) rcpt,apps.ar_customers cust
WHERE ord.customer_id=cust.customer_id
AND ord.trx_date = rcpt.trx_date(+)
AND ord.customer_id = rcpt.customer_id(+)



--------------------------------------------------------------------------------MONTH_WISE

SELECT cust.customer_number,
cust.customer_name,
to_date(ord.trx_date,'MON-YYYY'),
order_value,
receipt_amount,
order_qty,
ord.OPERAND p_adj_rate,
(CASE WHEN receipt_amount >= order_value THEN order_qty*ord.OPERAND
WHEN receipt_amount < order_value THEN ROUND ( (receipt_amount * order_qty) / order_value, 0)*ord.OPERAND
ELSE NULL
END) adjustment_value,
(CASE WHEN receipt_amount >= order_value THEN '5/10 TK Discount will be applied over ' || order_value || ' tk.'
WHEN receipt_amount < order_value THEN '5/10 TK Discount will be applied over ' || receipt_amount || ' tk.'
ELSE 'No Discount'
END) advanced_pricing_rules
FROM (SELECT ooh.sold_to_org_id customer_id, DIS.OPERAND,
TO_CHAR (ooh.ordered_date,'MON-YYYY') trx_date,
SUM (ool.unit_selling_price * ool.ordered_quantity) order_value,
SUM (ool.ordered_quantity) order_qty
FROM apps.oe_order_lines_all ool, apps.oe_order_headers_all ooh, ont.oe_price_adjustments dis
WHERE ooh.org_id = 85
AND dis.list_header_id='1096622' --1096622-PROD   --823390-CLONE6
AND ooh.header_id=dis.header_id(+)
AND ool.line_id=dis.line_id(+)
AND ooh.header_id = ool.header_id
AND ooh.flow_status_code IN ('BOOKED','CLOSED')
AND ool.ordered_item IN
('CMNT.SBAG.0001',
'CMNT.SBAG.0003',
'CMNT.PBAG.0001',
'CMNT.PBAG.0003')
--AND TRUNC (ooh.ordered_date) = TO_DATE ('JUN-2019', 'MON-YYYY')
AND TO_CHAR (ooh.ordered_date, 'MON-YYYY') = TO_CHAR ('JUL-2019')
AND ool.line_category_code = 'ORDER'
AND ool.cancelled_flag = 'N'
GROUP BY TO_CHAR (ooh.ordered_date,'MON-YYYY'), ooh.sold_to_org_id,DIS.OPERAND) ord,
(SELECT cra.pay_from_customer customer_id,
TO_CHAR(crh.gl_date,'MON-YYYY') trx_date,
SUM (cra.amount) receipt_amount
FROM apps.ar_cash_receipts_all cra,
apps.ar_cash_receipt_history_all crh,
(SELECT MIN (cash_receipt_history_id) cash_receipt_history_id, cash_receipt_id FROM apps.ar_cash_receipt_history_all GROUP BY cash_receipt_id) crh1
WHERE cra.org_id = 85
AND cra.cash_receipt_id = crh.cash_receipt_id
AND cra.status != 'REV'
AND cra.TYPE = 'CASH'
AND crh.cash_receipt_history_id = crh1.cash_receipt_history_id
--AND trunc(crh.gl_date) = TO_DATE ('JUN-2019', 'MON-YYYY')
AND TO_CHAR (crh.gl_date, 'MON-YYYY') = TO_CHAR ('JUL-2019')
GROUP BY TO_CHAR(crh.gl_date,'MON-YYYY'), cra.pay_from_customer) rcpt,apps.ar_customers cust
WHERE cust.customer_id = ord.customer_id
AND to_date(ord.trx_date,'MON-YYYY') = to_date(rcpt.trx_date,'MON-YYYY')
AND ord.customer_id = rcpt.customer_id(+);

--------------------------------------------------------------------------------DATE_WISE
SELECT cust.customer_number,
cust.customer_name,
ord.trx_date,
order_value,
receipt_amount,
order_qty,
ord.OPERAND p_adj_rate,
(CASE WHEN receipt_amount >= order_value THEN order_qty*ord.OPERAND
WHEN receipt_amount < order_value THEN ROUND ( (receipt_amount * order_qty) / order_value, 0)*ord.OPERAND
ELSE NULL
END) adjustment_value,
(CASE WHEN receipt_amount >= order_value THEN '5/10 TK Discount will be applied over ' || order_value || ' tk.'
WHEN receipt_amount < order_value THEN '5/10 TK Discount will be applied over ' || receipt_amount || ' tk.'
ELSE 'No Discount'
END) advanced_pricing_rules
FROM (SELECT ooh.sold_to_org_id customer_id, DIS.OPERAND,
TRUNC (ooh.ordered_date) trx_date,
SUM (ool.unit_selling_price * ool.ordered_quantity) order_value,
SUM (ool.ordered_quantity) order_qty
FROM apps.oe_order_lines_all ool, apps.oe_order_headers_all ooh, ont.oe_price_adjustments dis
WHERE ooh.org_id = 85
AND dis.list_header_id='823390'
AND ooh.header_id=dis.header_id(+)
AND ool.line_id=dis.line_id(+)
AND ooh.header_id = ool.header_id
AND ooh.flow_status_code = 'BOOKED'
AND ool.ordered_item IN
('CMNT.SBAG.0001',
'CMNT.SBAG.0003',
'CMNT.PBAG.0001',
'CMNT.PBAG.0003')
AND TRUNC (ooh.ordered_date) = TO_DATE ('17-JUN-2019', 'DD-MON-YYYY')
AND ool.line_category_code = 'ORDER'
AND ool.cancelled_flag = 'N'
GROUP BY TRUNC (ooh.ordered_date), ooh.sold_to_org_id,DIS.OPERAND) ord,
(SELECT cra.pay_from_customer customer_id,
crh.gl_date trx_date,
SUM (cra.amount) receipt_amount
FROM apps.ar_cash_receipts_all cra,
apps.ar_cash_receipt_history_all crh,
(SELECT MIN (cash_receipt_history_id) cash_receipt_history_id, cash_receipt_id FROM apps.ar_cash_receipt_history_all GROUP BY cash_receipt_id) crh1
WHERE cra.org_id = 85
AND cra.cash_receipt_id = crh.cash_receipt_id
AND cra.status != 'REV'
AND cra.TYPE = 'CASH'
AND crh.cash_receipt_history_id = crh1.cash_receipt_history_id
AND crh.gl_date = TO_DATE ('17-JUN-2019', 'DD-MON-YYYY')
GROUP BY crh.gl_date, cra.pay_from_customer) rcpt,apps.ar_customers cust
WHERE cust.customer_id = ord.customer_id
AND ord.trx_date = rcpt.trx_date(+)
AND ord.customer_id = rcpt.customer_id(+);


--------------------------------------------------------------------------------

SELECT cust.customer_number,
cust.customer_name,
ord.trx_date,
order_value,
receipt_amount,
order_qty,
ord.OPERAND p_adj_rate,
(CASE WHEN receipt_amount >= order_value THEN order_qty*ord.OPERAND
WHEN receipt_amount < order_value THEN ROUND ( (receipt_amount * order_qty) / order_value, 0)*ord.OPERAND
ELSE NULL
END) adjustment_value,
(CASE WHEN receipt_amount >= order_value THEN '5/10 TK Discount will be applied over ' || order_value || ' tk.'
WHEN receipt_amount < order_value THEN '5/10 TK Discount will be applied over ' || receipt_amount || ' tk.'
ELSE 'No Discount'
END) advanced_pricing_rules
FROM (SELECT ooh.sold_to_org_id customer_id, DIS.OPERAND,
TRUNC (ooh.ordered_date) trx_date,
SUM (ool.unit_selling_price * ool.ordered_quantity) order_value,
SUM (ool.ordered_quantity) order_qty
FROM apps.oe_order_lines_all ool, apps.oe_order_headers_all ooh, APPS.OE_PRICE_ADJUSTMENTS_V DIS
WHERE ooh.org_id = 85
AND dis.adjustment_name='SCIL Cash Discount Tk. 5 Over Payment'
AND ooh.header_id=dis.header_id(+)
AND ool.line_id=dis.line_id(+)
AND ooh.header_id = ool.header_id
AND ooh.flow_status_code = 'BOOKED'
AND ool.ordered_item IN
('CMNT.SBAG.0001',
'CMNT.SBAG.0003',
'CMNT.PBAG.0001',
'CMNT.PBAG.0003')
AND TRUNC (ooh.ordered_date) = TO_DATE ('17-JUN-2019', 'DD-MON-YYYY')
AND ool.line_category_code = 'ORDER'
AND ool.cancelled_flag = 'N'
GROUP BY TRUNC (ooh.ordered_date), ooh.sold_to_org_id,DIS.OPERAND) ord,
(SELECT cra.pay_from_customer customer_id,
crh.gl_date trx_date,
SUM (cra.amount) receipt_amount
FROM apps.ar_cash_receipts_all cra,
apps.ar_cash_receipt_history_all crh,
(SELECT MIN (cash_receipt_history_id) cash_receipt_history_id, cash_receipt_id FROM apps.ar_cash_receipt_history_all GROUP BY cash_receipt_id) crh1
WHERE cra.org_id = 85
AND cra.cash_receipt_id = crh.cash_receipt_id
AND cra.status != 'REV'
AND cra.TYPE = 'CASH'
AND crh.cash_receipt_history_id = crh1.cash_receipt_history_id
AND crh.gl_date = TO_DATE ('17-JUN-2019', 'DD-MON-YYYY')
GROUP BY crh.gl_date, cra.pay_from_customer) rcpt,apps.ar_customers cust
WHERE cust.customer_id = ord.customer_id
AND ord.trx_date = rcpt.trx_date(+)
AND ord.customer_id = rcpt.customer_id(+);



--------------------------------------------------------------------------------
SELECT
*
FROM
APPS.OE_PRICE_ADJUSTMENTS_V DIS
WHERE 1=1
AND dis.adjustment_name='SCIL Cash Discount on value of Collection'