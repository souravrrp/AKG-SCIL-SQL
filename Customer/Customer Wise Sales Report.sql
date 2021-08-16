SELECT  hou.NAME OPERATING_UNIT
      , hp.party_name CUSTOMER_NAME
      , hca.account_number CUSTOMER_NUMBER
      , rct.trx_number INV_NO
      , rct.trx_date INV_DATE
      , rctd.gl_date GL_DATE
      , rct.ct_reference REF_NO
      , rct.doc_sequence_value VOUCHER_NO
      , rct.invoice_currency_code CURRENCY_CODE
      , rct.exchange_rate
      , rctd.Amount Enterd_AMT
      ,(select sum(a.amount) from apps.ra_cust_trx_line_gl_dist_all a where a.account_class='REV' and a.customer_trx_id=rct.customer_trx_id) Entrd_cur
      , rctd.Acctd_amount ACCT_AMT
      ,((select sum(b.amount) from apps.ra_cust_trx_line_gl_dist_all b where b.account_class='REV' and b.customer_trx_id=rct.customer_trx_id)
      * nvl(rct.exchange_rate,1))Acct_cur
    --  , zl.tax_amt "TAXES"
    --  , NVL (zl.tax_amt, 0)
     -- , NVL (rct.exchange_rate, 1) *  rctd.Amount TOTAL
       ,((nvl(rct.exchange_rate,1)*rctd.Amount)
      +
      nvl((select sum(z.amount) from apps.ra_cust_trx_line_gl_dist_all z where z.account_class='TAX' and z.customer_trx_id=rct.customer_trx_id),0)) TOTAL
      , rct.interface_header_context CONTEXT
      ,DECODE (interface_header_context,
                'PROJECTS INVOICES', interface_header_attribute1,
                NULL
               )         project_num
       ,DECODE (interface_header_context,
                'PROJECTS INVOICES', interface_header_attribute2,
                NULL
               )  draft_inv_num
       ,DECODE (interface_header_context,
                'PROJECTS INVOICES', interface_header_attribute3,
                NULL
               )  agreement_num
       ,DECODE (interface_header_context,
                'PROJECTS INVOICES', interface_header_attribute4,
                NULL
               ) project_org
       ,DECODE (interface_header_context,
                'PROJECTS INVOICES', interface_header_attribute5,
                NULL
               ) project_manager
      ,  rctd.account_class  CLASS
       , rctl.line_number  Line_Number
       , NVL (rct.exchange_rate, 1) * rctd.Amount line_amount
       , gcc.concatenated_segments Revenue_Account
       , rctd.customer_trx_id
FROM   apps.ra_customer_trx_all            rct
      ,apps.ra_customer_trx_lines_all      rctl
      ,apps.ra_cust_trx_line_gl_dist_all   rctd
      ,apps.hz_cust_accounts_all           hca
      ,apps.hz_parties                     hp
      --,zx_lines                       zl
      ,apps.hr_operating_units             hou
      ,apps.ra_cust_trx_types_all          rctt
      ,apps.gl_code_combinations_kfv       gcc
      ,apps.AR_AEL_SL_INV_V ARSL
    -- ,XLA_AE_LINES XAL
    --  ,XLA_AE_HEADERS XAH
WHERE --rct.customer_trx_id  in ( 757008,6250,6251)
--AND   
rct.customer_trx_id   = rctl.customer_trx_id
AND    rctl.customer_trx_id   = rctd.customer_trx_id
AND    rctl.customer_trx_line_id = rctd.customer_trx_line_id
AND    rct.bill_to_customer_id  = hca.cust_account_id
AND    hca.party_id         =  hp.party_id
--AND    rctl.tax_line_id     = zl.tax_line_id(+)
AND    rct.org_id         = hou.organization_id
AND    rct.cust_trx_type_id = rctt.cust_trx_type_id
AND    rct.org_id         = rctt.org_id
AND    rctd.code_combination_id = gcc.code_combination_id
AND    rctd.account_class = 'REV'
AND    rct.trx_number=nvl(:P_TRX_NUM,rct.trx_number)
AND    rct.org_id=nvl(:P_ORG_ID,rct.org_id)
AND    HP.PARTY_NAME=NVL(:P_CUST_NAME,HP.PARTY_NAME)
AND    RCTT.TYPE=NVL(:P_TRX_TYPE,RCTT.TYPE)
AND    arsl.trx_hdr_id=rct.customer_trx_id
AND    arsl.GL_TRANSFER_STATUS='Y'
AND    arsl.code_combination_id=rctd.code_combination_id
--AND    arsl.trx_number_displayed=rct.trx_number
--AND    XAH.event_id=rctd.event_id
--AND    xah.ae_header_id=xal.ae_header_id
--AND    xal.code_combination_id=gcc.code_combination_id
--AND    hou.name=nvl(:P_OP_NAME,hou.name)
--AND   rctd.gl_date between :P_FROM_G_DATE and :P_TO_G_DATE