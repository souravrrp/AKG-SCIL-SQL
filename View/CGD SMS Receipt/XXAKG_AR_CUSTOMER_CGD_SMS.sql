SELECT CUST_ACCT.CUST_ACCOUNT_ID CUSTOMER_ID,
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