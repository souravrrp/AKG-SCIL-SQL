SELECT /*+RULE */ 
hca.account_number
, ctx.trx_number trx_nbr
, TO_CHAR(ctx.trx_date,'DD-MM-YYYY') trx_date
, ctt.NAME tran_type
,hca.cust_account_id
, ctx.customer_trx_id
, ctx.bill_to_customer_id
, ctx.cust_trx_type_id
FROM apps.ra_cust_trx_types_all ctt
, apps.hz_cust_accounts hca
, apps.ra_customer_trx_all ctx
WHERE NVL(ctx.complete_flag,'N') = 'N'
AND ctx.bill_to_customer_id = hca.cust_account_id 
AND ctx.cust_trx_type_id = ctt.cust_trx_type_id
and to_char(ctx.trx_date,'MON-RR')='NOV-17'