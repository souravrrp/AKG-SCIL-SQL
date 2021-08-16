SELECT
          cs.org_id ORG_ID,
          CELL.region_name REGION,
          CELL.block_name BLOCK,
          cs.customer_id CUSTOMER_REFID,
          cs.customer_number CUSTOMER_NUMBER,
          cs.customer_name CUSTOMER_NAME,
          --cs.location RETAILER,
          loc.ADDRESS1 RETAILER,
          ps.party_site_number RETAILER_ID,
          CELL.cell_name CELL_NAME,
          cs.location_address RETAILER_ADDRESS,
          cs.party_site_id PARTY_SITE_ID,
          cs.SHIP_TO_ORG_ID SHIP_TO_ORG_ID,
          cs.acct_use_status STATUS,
          ph.phone_number PHONE_NUMBER
     FROM apps.XXAKG_AR_CUSTOMER_SITE_V cs,
          apps.XXAKG_CEMENT_DIST_CELL_V CELL,
          apps.HZ_CONTACT_POINTS ph,
          apps.HZ_PARTY_SITES ps,
          apps.HZ_LOCATIONS LOC
    WHERE     cs.ORG_ID = CELL.ORG_ID
          AND cs.CUSTOMER_ID = CELL.CUSTOMER_ID
          AND cs.SHIP_TO_ORG_ID = CELL.SHIP_SITE_LOCATION
          AND cs.PARTY_SITE_ID = ps.PARTY_SITE_ID
          AND cs.party_site_id = ps.party_site_id
          AND ph.OWNER_TABLE_ID(+) = ps.ORIG_SYSTEM_REFERENCE
          AND PS.LOCATION_ID = LOC.LOCATION_ID
          --AND ps.ORIG_SYSTEM_REFERENCE=loc.ORIG_SYSTEM_REFERENCE(+)
          AND cs.CUSTOMER_NUMBER='20065';