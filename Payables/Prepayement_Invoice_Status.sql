SELECT pv.VENDOR_NAME,
ai.invoice_num,
NVL (
DECODE (
SIGN (SUM (amount - NVL (prepay_amount_remaining, amount))),
1,
DECODE (SUM (prepay_amount_remaining), 0, 'Y', NULL),
NULL
),
'N'
)
AS PP_F -- Y is Fully Applied, N is Partially or Not Applied
FROM apps.ap_invoice_distributions_all aid, apps.ap_invoices_all ai, apps.po_vendors pv
WHERE aid.invoice_id = ai.INVOICE_ID
AND pv.VENDOR_ID = ai.VENDOR_ID
AND aid.line_type_lookup_code = 'ITEM'
AND ai.invoice_type_lookup_code = 'PREPAYMENT'
--AND ai.INVOICE_ID = :P_INVOICE_ID
AND NVL (reversal_flag, 'N') <> 'Y'
GROUP BY pv.vendor_name, ai.invoice_num
HAVING NVL (
DECODE (
SIGN (SUM (amount - NVL (prepay_amount_remaining, amount))),
1,
DECODE (SUM (prepay_amount_remaining), 0, 'Y', NULL),
NULL
),
'N'
) <> 'Y';