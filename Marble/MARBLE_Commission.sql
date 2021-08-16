SELECT 
            ol.unit_list_price,
            ol.unit_selling_price,
            ol.unit_selling_price - ol.unit_list_price rate_diff,
            qpm_dis.adjusted_amount disc_adj,
            qpm_dis.operand disc_operand,
            disc_tp.meaning disc_type,
            qpl.name program_name,
            qpm_dis.list_line_no,
            ol.ordered_quantity
            * DECODE (qpm_dis.accrual_flag, 'N', qpm_dis.adjusted_amount, 0)
               line_adj_tot,
            DECODE (
               LAG (ol.line_id)
                  OVER (PARTITION BY ol.line_id ORDER BY ol.line_id),
               NULL,
                 ol.ordered_quantity
               * ol.unit_selling_price
               * NVL (oh.conversion_rate, 1),
               NULL)
               line_tot_amt,
            DECODE (
               LAG (ol.line_id)
                  OVER (PARTITION BY ol.line_id ORDER BY ol.line_id),
               NULL,
                 ol.ordered_quantity
               * ol.unit_list_price
               * NVL (oh.conversion_rate, 1),
               NULL)
               line_gross_tot_amt
       FROM apps.oe_order_lines_all ol,
            apps.oe_order_headers_all oh,
            apps.oe_transaction_types_tl ot,
            apps.qp_list_headers_tl qpl,
            apps.oe_price_adjustments qpm_dis,
            (SELECT LOOKUP_CODE, meaning
               FROM apps.fnd_lookup_values
              WHERE lookup_type = 'ARITHMETIC_OPERATOR') disc_tp,
            (SELECT hca.cust_account_id customer_id,
                    hca.account_number customer_number,
                    dam.region_name,
                    hp.party_name customer_name,
                    hp.party_type,
                    hp.category_code,
                    DECODE (hca.sales_channel_code,
                            '-1', 'Unassigned',
                            hca.sales_channel_code)
                       sales_channel_code
               FROM apps.hz_parties hp,
                    apps.hz_cust_accounts hca,
                    apps.xxakg_distributor_block_m dam
              WHERE     1 = 1
                    AND hp.party_id = hca.party_id
                    AND hca.cust_account_id = dam.customer_id(+)
                    AND dam.org_id(+) = 605
                    AND EXISTS
                          (SELECT 1
                             FROM apps.hz_cust_acct_sites_all
                            WHERE org_id = 605
                                  AND cust_account_id = hca.cust_account_id))
            cus
      WHERE     1 = 1
            AND cus.customer_id = oh.sold_to_org_id
            AND oh.order_type_id = ot.transaction_type_id
            AND oh.header_id = ol.header_id
            AND qpl.name in ('Marble Additional Discount','Marble General Commission')
            AND oh.org_id = 605
--            AND oh.ORDER_NUMBER IN ('196016622')
            AND ol.line_id = qpm_dis.line_id(+)
            AND qpm_dis.list_header_id = qpl.list_header_id(+)
            AND qpm_dis.arithmetic_operator = disc_tp.lookup_code(+)
            AND TO_CHAR (ol.actual_shipment_date, 'MON-RR') = 'APR-18'
            --            AND trunc(oh.creation_date)>=to_date('01/03/2016','dd/mm/yyyy')
            AND ol.flow_status_code <> 'CANCELLED'
--            AND qpm_dis.list_line_no=837678
            
            


------------------------------Summary-------------------------------------------------------

SELECT 
--            qpm_dis.operand Commission_operand,
--            disc_tp.meaning Commission_type,
            qpl.name Commission_Name,
               sum(ol.ordered_quantity
            * DECODE (qpm_dis.accrual_flag, 'N', qpm_dis.adjusted_amount, 0)) Total_commission
       FROM apps.oe_order_lines_all ol,
            apps.oe_order_headers_all oh,
            apps.oe_transaction_types_tl ot,
            apps.qp_list_headers_tl qpl,
            apps.oe_price_adjustments qpm_dis,
            (SELECT LOOKUP_CODE, meaning
               FROM apps.fnd_lookup_values
              WHERE lookup_type = 'ARITHMETIC_OPERATOR') disc_tp,
            (SELECT hca.cust_account_id customer_id,
                    hca.account_number customer_number,
                    dam.region_name,
                    hp.party_name customer_name,
                    hp.party_type,
                    hp.category_code,
                    DECODE (hca.sales_channel_code,
                            '-1', 'Unassigned',
                            hca.sales_channel_code)
                       sales_channel_code
               FROM apps.hz_parties hp,
                    apps.hz_cust_accounts hca,
                    apps.xxakg_distributor_block_m dam
              WHERE     1 = 1
                    AND hp.party_id = hca.party_id
                    AND hca.cust_account_id = dam.customer_id(+)
                    AND dam.org_id(+) = 605
                    AND EXISTS
                          (SELECT 1
                             FROM apps.hz_cust_acct_sites_all
                            WHERE org_id = 605
                                  AND cust_account_id = hca.cust_account_id))
            cus
      WHERE     1 = 1
            AND cus.customer_id = oh.sold_to_org_id
            AND oh.order_type_id = ot.transaction_type_id
            AND oh.header_id = ol.header_id
            AND qpl.name in ('Marble Additional Discount','Marble General Commission')
            and exists (select 1 from apps.oe_order_lines_all ol,apps.oe_order_headers_all oh where oh.header_id=ol.header_id and ol.flow_status_code IN ('CLOSED','SHIPPED') and oh.order_type_id!=1177) 
            AND oh.org_id = 605
--            AND oh.ORDER_NUMBER IN ('196016622')
            AND ol.line_id = qpm_dis.line_id(+)
            AND qpm_dis.list_header_id = qpl.list_header_id(+)
            AND qpm_dis.arithmetic_operator = disc_tp.lookup_code(+)
            AND TO_CHAR (ol.actual_shipment_date, 'MON-RR') = 'APR-18'
--                        AND trunc(oh.creation_date)>=to_date('01/03/2016','dd/mm/yyyy')
            AND ol.flow_status_code <> 'CANCELLED'
            group by
--             qpm_dis.operand,
--            disc_tp.meaning,
            qpl.name