 select distinct * 
 From
 (SELECT A.CASH_RECEIPT_ID,
          A.PAY_FROM_CUSTOMER,
          A.RECEIPT_NUMBER,
          A.RECEIPT_DATE,
          A.CONFIRMED_FLAG,
          A.CUSTOMER_SITE_USE_ID,
          C.CUSTOMER_NUMBER,
          C.CUSTOMER_NAME,
          C.CUSTOMER_CATEGORY_CODE,
          C.DIVISION,
          C.REGION,
          C.TERRITORY,
          A.DEPOSIT_DATE,
          A.DOC_SEQUENCE_VALUE,
          A.ORG_ID,
          A.REMIT_BANK_ACCT_USE_ID,
          A.EXCHANGE_RATE,
          A.STATUS,
          A.TYPE,
          A.CURRENCY_CODE,
          A.AMOUNT,
          B.STATUS RECEIPT_CURR_STATUS,
          B.TRX_DATE,
          B.CURRENT_RECORD_FLAG,
          B.GL_DATE,
          B.ACCTD_AMOUNT,
          CBA.BANK_ACCOUNT_NUM,
          --       cba.description,
          CBA.BANK_ID,
          CBAU.BANK_ACCT_USE_ID,
          CBAU.BANK_ACCOUNT_ID,
          BNK.BANK_NAME,
          BRNCH.BANK_BRANCH_NAME,
          C.PHONE_NUMBER,
          B.LAST_UPDATE_DATE
     FROM APPS.AR_CASH_RECEIPTS_ALL A,
          APPS.AR_CASH_RECEIPT_HISTORY_ALL B,
          APPS.CE_BANK_ACCOUNTS CBA,
          APPS.CE_BANK_ACCT_USES_ALL CBAU,
          APPS.CE_BANK_BRANCHES_V BRNCH,
          APPS.CE_BANKS_V BNK,
          --APPS.XXAKG_AR_CUSTOMER_SITE_CGD_V C
          ( SELECT CUST_ACCT.CUST_ACCOUNT_ID CUSTOMER_ID,
          CUST_ACCT.ACCOUNT_NUMBER CUSTOMER_NUMBER,
          PARTY.PARTY_NAME CUSTOMER_NAME,
          SITE_USE.ORG_ID ORG_ID,
          SITE_USE.LOCATION,
          LOC.ADDRESS2 LOCATION_ADDRESS,
          CUST_ACCT.ORIG_SYSTEM_REFERENCE,
             PARTY.ADDRESS1
          || ' '
          || PARTY.ADDRESS2
          || ' '
          || PARTY.ADDRESS3
          || ' '
          || PARTY.ADDRESS4
          || ','
          || PARTY.CITY
             ADDRESS,
          PARTY.COUNTRY,
          PARTY.KNOWN_AS,
          PARTY.PARTY_ID,
          TRIM (CUST_ACCT.ATTRIBUTE1) CREDIT_LIMIT,
          TRIM (CUST_ACCT.ATTRIBUTE2) ADDITIONAL_CREDIT_LIMIT,
          TRIM (CUST_ACCT.ATTRIBUTE3) SPECIAL_CREDIT_LIMIT,
          CUST_ACCT.ATTRIBUTE4 SECURITY_MODE,
          SITE_USE.SITE_USE_CODE,
          SITE_USE.PRIMARY_FLAG,
          SITE_USE.SITE_USE_ID,
          ACCT_USE.PARTY_SITE_ID,
          CUST_ACCT.STATUS,
          SITE_USE.STATUS SITE_USE_STATUS,
          ACCT_USE.STATUS ACCT_USE_STATUS,
          CUST_ACCT.ATTRIBUTE7 OLD_CUSTOMER_NUMBER,
          PARTY.PARTY_TYPE,
          party.category_code CUSTOMER_CATEGORY_CODE,
          LOC.ADDRESS1 REAILER,
          LOC.ADDRESS2 REAILER_ADDRESS,
          LOC.ADDRESS3 PROPRIETOR,
          LOC.ADDRESS4 SALES_REP,
          PS.PARTY_SITE_NUMBER,
          ACCT_USE.ATTRIBUTE2 CAMPAIGN,
          DECODE (CUST_ACCT.ATTRIBUTE_CATEGORY,
                  'SCIL Customer Information', CUST_ACCT.ATTRIBUTE8,
                  NULL)
             MOVING_STATUS,
          terr.name,
          terr.description,
          terr.segment1 BUSINESS,
          terr.segment2 DIVISION,
          terr.segment3 REGION,
          terr.segment4 TERRITORY,
          terr.segment5 AREA,
          terr.segment6 ROUTE,
          terr.segment7 FUTURE1,
          terr.segment8 FUTURE2,
          op.TAX_REFERENCE,
          op.CURR_FY_POTENTIAL_REVENUE,
          op.NEXT_FY_POTENTIAL_REVENUE,
          CUST_ACCT.CREATION_DATE,
          ph.phone_number
     FROM APPS.HZ_PARTIES PARTY,
          APPS.HZ_CUST_ACCOUNTS CUST_ACCT,
          APPS.HZ_CUST_SITE_USES_ALL SITE_USE,
          APPS.HZ_CUST_ACCT_SITES_ALL ACCT_USE,
          APPS.HZ_PARTY_SITES PS,
          APPS.HZ_LOCATIONS LOC,
          apps.ra_territories terr,
          APPS.hz_organization_profiles op,
          APPS.HZ_CONTACT_POINTS ph
    WHERE     1 = 1
          AND PARTY.PARTY_ID = CUST_ACCT.PARTY_ID
          AND SITE_USE.CUST_ACCT_SITE_ID = ACCT_USE.CUST_ACCT_SITE_ID
          AND CUST_ACCT.CUST_ACCOUNT_ID = ACCT_USE.CUST_ACCOUNT_ID
          AND ACCT_USE.PARTY_SITE_ID = PS.PARTY_SITE_ID
          AND PS.LOCATION_ID = LOC.LOCATION_ID
          AND acct_use.territory_id = terr.territory_id(+)
          AND PARTY.PARTY_ID = OP.PARTY_ID
          AND ph.OWNER_TABLE_ID(+) = ps.PARTY_ID
          and ph.contact_point_type(+)='PHONE'
          and ph.OWNER_TABLE_NAME(+)='HZ_PARTIES'
          and ph.status(+)='A'
          and ph.primary_flag(+)='Y'
          AND SITE_USE.org_id = 665
          AND op.EFFECTIVE_END_DATE IS NULL
          AND SITE_USE.SITE_USE_CODE='BILL_TO'
          AND  terr.segment1='CGD'
          ---AND CUST_ACCT.ACCOUNT_NUMBER='40007'
          ) C
    WHERE     A.CASH_RECEIPT_ID = B.CASH_RECEIPT_ID
          AND CBAU.BANK_ACCT_USE_ID = A.REMIT_BANK_ACCT_USE_ID
          AND CBAU.BANK_ACCOUNT_ID = CBA.BANK_ACCOUNT_ID
          AND CBA.BANK_BRANCH_ID = BRNCH.BRANCH_PARTY_ID
          AND CBA.BANK_ID = BRNCH.BANK_PARTY_ID
          AND BRNCH.BANK_PARTY_ID = BNK.BANK_PARTY_ID
          AND A.PAY_FROM_CUSTOMER = C.CUSTOMER_ID
          AND A.ORG_ID = 665
          AND B.CURRENT_RECORD_FLAG = 'Y'
          AND A.STATUS != 'REV'
          AND C.SITE_USE_CODE = 'BILL_TO')
where receipt_date >= '1-OCT-2015' 
and RECEIPT_CURR_STATUS ='CONFIRMED' 
and LAST_UPDATE_date >  to_date('16-JAN-2016 12:42:11 PM','dd-mon-yyyy hh:mi:ss AM' )