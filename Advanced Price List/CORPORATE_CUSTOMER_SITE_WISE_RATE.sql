SELECT 
DBM.REGION_NAME,
ACSV.CUSTOMER_NUMBER,
ACSV.CUSTOMER_NAME,
ACSV.PARTY_SITE_NUMBER,
ACSV.REAILER||','||ACSV.REAILER_ADDRESS ADDRESS
,Item_Code
,Item_Description
,SITE.RATE
,TO_CHAR(START_DATE) START_DATE
FROM 
APPS.XXAKG_AR_CUSTOMER_SITE_V ACSV, 
APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM 
,(SELECT DESC_ATTRIB_VALUE_FROM CUST_SITE, ADJUST_RATE Rate
 ,substr(PRODUCT_ATTR_VALUE,1,instr(PRODUCT_ATTR_VALUE,'|',1,1)-1) Item_Code
,substr(PRODUCT_ATTR_VALUE,+18,instr(PRODUCT_ATTR_VALUE,'|',1,1)+15) Item_Description ,START_DATE
FROM (SELECT source,
            name modifier_name,
            product_attribute_type,
            product_attr_value,
            list_line_type,
            mod_line_no,
            operand adjust_rate,
            arithmetic_operator,
            user_segment_name qualifier_attr_type,
            operator,
            group_no,
            DECODE (
               user_segment_name,
               'Sales Channel',
               (SELECT meaning
                  FROM apps.oe_lookups
                 WHERE lookup_type = 'SALES_CHANNEL'
                       AND LOOKUP_CODE = qualifier_attr_value),
               'Order Type',
               (SELECT name
                  FROM apps.oe_transaction_types_tl
                 WHERE transaction_type_id = NVL (qualifier_attr_value, -99)),
               'Customer Name',
               (SELECT customer_number --|| ' - ' || customer_name
                  FROM                                        --qp_customers_v
                       (SELECT party.party_name customer_name,
                               acct.account_number customer_number,
                               acct.cust_account_id customer_id
                          FROM apps.hz_parties party, apps.hz_cust_accounts acct
                         WHERE party.party_id = acct.party_id)
                 WHERE customer_id = NVL (qualifier_attr_value, -99)),
               'Ship To',
               (SELECT  party_site_ship.party_site_number--  cust_acct.account_number,party.party_name, party_site_ship.party_site_number Cusomter_Site_Number, LOC_SHIP.address1||','||LOC_SHIP.address2|| ',' || LOC_SHIP.address3 Cusomter_Site
                  FROM apps.hz_parties party,
                       apps.hz_cust_accounts_all cust_acct,
                       apps.hz_cust_acct_sites_all acct_site_ship,
                       apps.hz_party_sites party_site_ship,
                       apps.hz_locations loc_ship,
                       apps.hz_cust_site_uses_all s_ship
                 WHERE acct_site_ship.cust_account_id =
                          cust_acct.cust_account_id
                       AND cust_acct.party_id = party.party_id
                       AND acct_site_ship.party_site_id =
                             party_site_ship.party_site_id
                       AND party_site_ship.location_id = loc_ship.location_id
                       AND s_ship.cust_acct_site_id =
                             acct_site_ship.cust_acct_site_id
                       AND s_ship.site_use_id = qualifier_attr_value
                       AND acct_site_ship.ORG_ID=85
                       AND s_ship.site_use_code = 'SHIP_TO'),
               'Price List',
               (SELECT name
                  FROM apps.qp_list_headers_tl
                 WHERE list_header_id = qualifier_attr_value),
               qualifier_attr_value)
               desc_attrib_value_from,
            DECODE (
               user_segment_name,
               'Order Type',
               (SELECT name
                  FROM apps.oe_transaction_types_tl
                 WHERE transaction_type_id = NVL (qualifier_attr_value_to, -99)),
               'Customer Name',
               (SELECT customer_number --|| ' - ' || customer_name
                  FROM                                        --qp_customers_v
                       (SELECT party.party_name customer_name,
                               acct.account_number customer_number,
                               acct.cust_account_id customer_id
                          FROM apps.hz_parties party, apps.hz_cust_accounts acct
                         WHERE party.party_id = acct.party_id)
                 WHERE customer_id = NVL (qualifier_attr_value_to, -99)),
               'Ship To',
               (SELECT  party_site_ship.party_site_number--  cust_acct.account_number,party.party_name, party_site_ship.party_site_number Cusomter_Site_Number, LOC_SHIP.address1||','||LOC_SHIP.address2|| ',' || LOC_SHIP.address3 Cusomter_Site
                  FROM apps.hz_parties party,
                       apps.hz_cust_accounts_all cust_acct,
                       apps.hz_cust_acct_sites_all acct_site_ship,
                       apps.hz_party_sites party_site_ship,
                       apps.hz_locations loc_ship,
                       apps.hz_cust_site_uses_all s_ship
                 WHERE acct_site_ship.cust_account_id =
                          cust_acct.cust_account_id
                       AND cust_acct.party_id = party.party_id
                       AND acct_site_ship.party_site_id =
                             party_site_ship.party_site_id
                       AND party_site_ship.location_id = loc_ship.location_id
                       AND s_ship.cust_acct_site_id =
                             acct_site_ship.cust_acct_site_id
                       AND s_ship.site_use_id = qualifier_attr_value_to
                       AND acct_site_ship.ORG_ID=85
                       AND s_ship.site_use_code = 'SHIP_TO'),
               'Price List',
               (SELECT name
                  FROM apps.qp_list_headers_tl
                 WHERE list_header_id = qualifier_attr_value_to),
               qualifier_attr_value_to)
               desc_attrib_value_to,
            NVL (line_auto_flag, automatic_flag) automatic_flag,
            NVL (excluder_flag, 'N') excluder_flag,
            accrual_flag,
            override_flag,
            NVL (qua_line_start_date, NVL (line_start_date, start_date_active))
               start_date,
            NVL (qua_line_end_date, NVL (line_end_date, end_date_active))
               end_date
       FROM (
             SELECT 'Line' source,
                    qpn.list_header_id,
                    qpn.name,
                    qph.start_date_active,
                    qph.end_date_active,
                    qph.automatic_flag,
                    qph.active_flag,
                    line.list_line_id,
                    line.list_line_no mod_line_no,
                    line.product_attribute_context,
                    line.product_attribute_type,
                    DECODE (
                       line.product_attr,
                       'PRICING_ATTRIBUTE1',
                       (SELECT    concatenated_segments
                               || ' | '
                               || SUBSTR (description, 1, 150)
                          FROM apps.mtl_system_items_vl
                         WHERE inventory_item_id =
                                  TO_NUMBER (line.product_attr_val)
                               AND ROWNUM = 1),
                       line.product_attr_value)
                       product_attr_value,
                    line.product_uom_code,
                    line.pricing_phase,
                    line.modifier_level,
                    line.list_line_type,
                    line.operand,
                    line.arithmetic_operator,
                    line.automatic_flag line_auto_flag,
                    line.override_flag,
                    line.comparison_operator_code,
                    line.pricing_attribute_context,
                    line.pricing_attribute,
                    line.pricing_attr_value_from,
                    line.pricing_attr_value_to,
                    line.price_break_type,
                    line.accrual_flag,
                    line.start_date_active line_start_date,
                    line.end_date_active line_end_date,
                    hql.qualifier_id,
                    qsv.user_segment_name,
                    hql.excluder_flag,
                    hql.comparision_operator_code OPERATOR,
                    hql.qualifier_grouping_no GROUP_NO,
                    hql.qualifier_precedence,
                    hql.qualifier_attr_value,
                    hql.qualifier_attr_value_to,
                    hql.start_date_active qua_line_start_date,
                    hql.end_date_active qua_line_end_date
               FROM apps.qp_list_headers_b qph,
                    apps.qp_list_headers_tl qpn,
                    apps.qp_qualifiers_v hql,
                    apps.qp_prc_contexts_v qlv,
                    apps.qp_segments_v qsv,
                    apps.qp_modifier_summary_v line
              WHERE     1 = 1
--                    AND line.product_attr='Ship To'
                    AND qph.ORIG_ORG_ID=85
                    AND qph.list_header_id = qpn.list_header_id
                    AND qph.list_header_id = line.list_header_id
                    AND line.list_header_id = hql.list_header_id
                    AND hql.list_line_id = line.LIST_LINE_ID
                    AND hql.qualifier_context = qlv.prc_context_code
                    AND qlv.prc_context_type = 'QUALIFIER'
                    AND qlv.prc_context_id = qsv.prc_context_id
                    AND hql.qualifier_attribute = qsv.segment_mapping_column
                    AND qph.list_type_code != 'PRL'
                    AND qph.active_flag = 'Y'
                    AND line.list_line_type_code != 'PRG'
                    AND hql.end_date_active IS NULL
             UNION ALL
             SELECT 'Line' source,
                    qpn.list_header_id,
                    qpn.name,
                    qph.start_date_active,
                    qph.end_date_active,
                    qph.automatic_flag,
                    qph.active_flag,
                    line.list_line_id,
                    line.list_line_no mod_line_no,
                    line.product_attribute_context,
                    line.product_attribute_type,
                    DECODE (
                       line.product_attr,
                       'PRICING_ATTRIBUTE1',
                       (SELECT    concatenated_segments
                               || ' | '
                               || SUBSTR (description, 1, 150)
                          FROM apps.mtl_system_items_vl
                         WHERE inventory_item_id =
                                  TO_NUMBER (line.product_attr_val)
                               AND ROWNUM = 1),
                       line.product_attr_value)
                       product_attr_value1,
                    line.product_uom_code,
                    line.pricing_phase,
                    line.modifier_level,
                    line.list_line_type,
                    line.operand,
                    line.arithmetic_operator,
                    line.automatic_flag line_auto_flag,
                    line.override_flag,
                    line.comparison_operator_code,
                    line.pricing_attribute_context,
                    line.pricing_attribute,
                    line.pricing_attr_value_from,
                    line.pricing_attr_value_to,
                    line.price_break_type,
                    line.accrual_flag,
                    line.start_date_active line_start_date,
                    line.end_date_active line_end_date,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL
               FROM apps.qp_list_headers_b qph,
                    apps.qp_list_headers_tl qpn,
                    apps.qp_modifier_summary_v line
              WHERE     1 = 1
                    AND line.product_attr='Ship To'
                    AND qph.ORIG_ORG_ID=85
                    AND qph.list_header_id = qpn.list_header_id
                    AND qph.list_header_id = line.list_header_id
                    AND NOT EXISTS
                          (SELECT 1
                             FROM apps.qp_qualifiers_v
                            WHERE list_header_id = line.list_header_id
                                  AND list_line_id = line.list_line_id)
                    AND qph.list_type_code != 'PRL'
                    AND qph.active_flag = 'Y'
                    AND line.list_line_type_code != 'PRG'
                    AND line.end_date_active IS NULL)
   ORDER BY modifier_name,
            source,
            product_attribute_type,
            product_attr_value,
            mod_line_no,
            group_no)
             MOD_FIER WHERE 1=1 
            --------------------------
            AND QUALIFIER_ATTR_TYPE='Ship To'
--            AND OPERATOR='='
) SITE
WHERE  ACSV.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER 
AND SITE.CUST_SITE=ACSV.PARTY_SITE_NUMBER
AND DBM.REGION_NAME IN ('Corporate North','Corporate South','Institutional','MES')
AND ACSV.SITE_USE_CODE='SHIP_TO'
--AND ACSV.PARTY_SITE_NUMBER='293556'
AND ACSV.CUSTOMER_NUMBER='20482'-- IN ('187872','25954','21615','187098','36448','186207','184145','187704','187794','37167')
--AND SITE.ITEM_CODE='CMNT.SBAG.0001'
