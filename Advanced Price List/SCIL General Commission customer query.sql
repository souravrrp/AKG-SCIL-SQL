SELECT 'SCIL General Commission' Modifier_name,
       hca.cust_account_id customer_id,
       hca.account_number customer_number,
       hp.party_name customer_name,
       hca.status account_status,
       NVL (dbm.region_name, 'Unspecified') region,
       (SELECT meaning FROM apps.fnd_lookup_values WHERE lookup_type = 'CUSTOMER_CATEGORY' AND view_application_id = 222 AND security_group_id = 0 AND lookup_code = hp.category_code) customer_category,
       (SELECT meaning FROM apps.fnd_lookup_values WHERE lookup_type = 'SALES_CHANNEL' AND view_application_id = 660 AND security_group_id = 0 AND lookup_code = hca.sales_channel_code) sales_channel,
       DECODE (hp.category_code, 'DISTRIBUTOR', 8, 'DEALER', 8, 'PRIME SELLER', DECODE (hca.sales_channel_code, 'DHAKA', 6, '-1',7,NULL),NULL) commission_rate,
       CASE
          WHEN dbm.region_name IN
                  ('Gazipur',
                   'Dhaka South',
                   'Mymensingh',
                   'Rajshahi',
                   'Sylhet',
                   'Rangpur',
                   'Prime Seller',
                   'Comilla',
                   'Faridpur',
                   'Dhaka North',
                   'Narayangonj',
                   'Khulna',
                   'Barisal',
                   'Tangail',
                   'Bogra',
                   'Noakhali',
                   'Chittagong')
          THEN
             'Traders'
          ELSE
             NULL
       END
          customer_type
  FROM apps.hz_cust_accounts hca,
       apps.hz_parties hp,
       xxakg.xxakg_distributor_block_m dbm
 WHERE hca.party_id = hp.party_id
      AND nvl(hca.status,'X')='A'
       AND EXISTS
              (SELECT 1
                 FROM apps.hz_cust_acct_sites_all hcas
                WHERE hcas.cust_account_id = hca.cust_account_id
                      AND hcas.org_id = 85)
       AND dbm.customer_id(+) = hca.cust_account_id
       AND dbm.org_id(+) = 85
UNION ALL
SELECT 'SCIL General Commission' Modifier_name,
       hca.cust_account_id customer_id,
       hca.account_number customer_number,
       hp.party_name customer_name,
       hca.status account_status,
       NVL (dbm.region_name, 'Unspecified') region,
       (SELECT meaning FROM apps.fnd_lookup_values WHERE lookup_type = 'CUSTOMER_CATEGORY' AND view_application_id = 222 AND security_group_id = 0 AND lookup_code = hp.category_code) customer_category,
       (SELECT meaning FROM apps.fnd_lookup_values WHERE lookup_type = 'SALES_CHANNEL' AND view_application_id = 660 AND security_group_id = 0 AND lookup_code = hca.sales_channel_code) sales_channel,
       DECODE (hp.category_code, 'DISTRIBUTOR', 8, 'DEALER', 8, 'PRIME SELLER', DECODE (hca.sales_channel_code, 'DHAKA', 6, '-1',7,NULL),NULL) commission_rate,
       CASE
          WHEN dbm.region_name IN
                  ('Gazipur',
                   'Dhaka South',
                   'Mymensingh',
                   'Rajshahi',
                   'Sylhet',
                   'Rangpur',
                   'Prime Seller',
                   'Comilla',
                   'Faridpur',
                   'Dhaka North',
                   'Narayangonj',
                   'Khulna',
                   'Barisal',
                   'Tangail',
                   'Bogra',
                   'Noakhali',
                   'Chittagong')
          THEN
             'Traders'
          ELSE
             NULL
       END
          customer_type
  FROM apps.hz_cust_accounts hca,
       apps.hz_parties hp,
       xxakg.xxakg_distributor_block_m dbm
 WHERE hca.party_id = hp.party_id
      AND nvl(hca.status,'X') !='A'
       AND EXISTS
              (SELECT 1
                 FROM apps.hz_cust_acct_sites_all hcas
                WHERE hcas.cust_account_id = hca.cust_account_id
                      AND hcas.org_id = 85)
       AND dbm.customer_id(+) = hca.cust_account_id
       AND dbm.org_id(+) = 85
