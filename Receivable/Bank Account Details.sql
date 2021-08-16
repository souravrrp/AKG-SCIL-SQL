SELECT xep.name                                       legal_entity_name, 
       ou.name                                        "Operating Unit", 
       cba.bank_account_name                          "Bank Account Name", 
       cba.bank_account_num                           "Bank Account Number", 
       NVL(cba.attribute1, cba.currency_code)         currency, 
       cba.multi_currency_allowed_flag                "Multi Currency Flag", 
       cba.account_classification                     "Account Classification", 
       bb.bank_name                                   "Bank Name", 
       bb.bank_branch_type                            "Bank Branch Type", 
       bb.bank_branch_name                            "Bank Branch Name", 
       bb.bank_branch_number                          "Bank Branch Number", 
       bb.eft_swift_code                              "Swift Code", 
       bau.ap_use_enable_flag                         bank_setup_ap_use_flag, 
       bau.ar_use_enable_flag                         bank_setup_ar_use_flag, 
       gcf.concatenated_segments 
       "ASSET GL Code Combination", 
       (SELECT RTRIM(XMLAGG(XMLELEMENT(e, apg.vendor_pay_group|| 
                     ',')) .extract('//text()'), 
                       ',') 
        FROM   (SELECT DISTINCT apg.vendor_pay_group, 
                                bank_account_id 
                FROM   apps.ap_payment_templates apt, 
                       apps.ap_pay_group apg 
                WHERE  1 = 1 
                   AND apg.template_id = apt.template_id 
                   AND NVL(apt.inactive_date, SYSDATE + 1) > SYSDATE) apg 
        WHERE  bank_account_id = cba.bank_account_id) used_in_ap_pay_groups, 
       (SELECT RTRIM(XMLAGG(XMLELEMENT(e, arm.name|| CHR(10)|| 
                     ',')) .extract('//text()'), ',') 
        FROM   apps.ar_receipt_method_accounts_all arma, 
               apps.ar_receipt_methods arm 
        WHERE  arm.receipt_method_id = arma.receipt_method_id 
           AND arma.remit_bank_acct_use_id = bau.bank_acct_use_id) 
                                                      used_in_ar_recipt_mthods 
FROM   apps.ce_bank_accounts cba, 
       apps.ce_bank_acct_uses_all bau, 
       apps.cefv_bank_branches bb, 
       apps.hr_operating_units ou, 
       apps.xle_entity_profiles xep, 
       apps.gl_code_combinations_kfv gcf 
WHERE  cba.bank_account_id = bau.bank_account_id 
   AND cba.bank_branch_id = bb.bank_branch_id 
   AND ou.organization_id = bau.org_id 
   AND cba.asset_code_combination_id = gcf.code_combination_id 
   AND ( cba.end_date IS NULL 
          OR cba.end_date > TRUNC(SYSDATE) ) 
   AND ou.default_legal_context_id = xep.legal_entity_id
   AND cba.ACCOUNT_OWNER_ORG_ID=ou.DEFAULT_LEGAL_CONTEXT_ID
--   AND bau.bank_account_id='16426'
   AND OU.ORGANIZATION_ID='84'
   AND EXISTS(SELECT 1 FROM APPS.AR_CASH_RECEIPTS_ALL ACR WHERE BAU.BANK_ACCOUNT_ID=ACR.REMIT_BANK_ACCT_USE_ID AND TO_CHAR(ACR.RECEIPT_DATE,'MON-RR')='NOV-18' )
ORDER  BY ( cba.bank_account_num ); 