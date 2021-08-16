SELECT
*
FROM
APPS.XXAKG_ORD_TO_DO_DTL_V
WHERE 1=1
--AND MOH.CONFIRMED_DATE BETWEEN '15-OCT-2017' and '16-NOV-2017'
AND TO_CHAR (ORDERED_DATE, 'MON-RR') = 'SEP-17'



SELECT source,
          customer_number,
          customer_name,
          order_number,
          FLOW_STATUS_CODE,
          ordered_date,
          ORDER_CATEGORY_CODE,
          ORDERED_ITEM,
          item_description,
          ORDER_QUANTITY_UOM,
          ORDERED_QUANTITY,
          SHIPPED_QUANTITY,
          DO_NUMBER,
          DO_DATE,
          ACTUAL_SHIPMENT_DATE,
          DO_QUANTITY,
          TOTAL_ORDERED_QUANTITY,
          DO_STATUS,
          ITEM_WISE_ORDERED_QUANTITY
     FROM (SELECT 1 SOURCE,
                  customer_number,
                  customer_name,
                  a.order_number,
                  o.FLOW_STATUS_CODE,
                  ordered_date,
                  ORDER_CATEGORY_CODE,
                  ORDERED_ITEM,
                  description item_description,
                  ORDER_QUANTITY_UOM,
                  DECODE (ORDER_QUANTITY_UOM,
                          'MTN', ORDERED_QUANTITY * 20,
                          ORDERED_QUANTITY)
                     ORDERED_QUANTITY,
                  DECODE (ORDER_QUANTITY_UOM,
                          'MTN', SHIPPED_QUANTITY * 20,
                          SHIPPED_QUANTITY)
                     SHIPPED_QUANTITY,
                  o.SHIPMENT_PRIORITY_CODE DO_NUMBER,
                  DO_DATE,
                  ACTUAL_SHIPMENT_DATE,
                  DECODE (ORDER_QUANTITY_UOM,
                          'MTN',
                          NVL (SHIPPED_QUANTITY, ORDERED_QUANTITY) * 20,
                          NVL (SHIPPED_QUANTITY, ORDERED_QUANTITY))
                     DO_QUANTITY,
                  (SELECT SUM(DECODE (ORDER_QUANTITY_UOM,
                                      'MTN', ORDERED_QUANTITY * 20,
                                      ORDERED_QUANTITY))
                     FROM apps.oe_order_lines_all o
                    WHERE o.header_id = a.header_ID
                          AND ORDER_QUANTITY_UOM <> 'PCS')
                     TOTAL_ORDERED_QUANTITY,
                  DECODE (o.FLOW_STATUS_CODE,
                          'CLOSED', 'SHIPPED',
                          'SHIPPED', 'SHIPPED',
                          DO_STATUS)
                     DO_STATUS,
                  (SELECT SUM(DECODE (ORDER_QUANTITY_UOM,
                                      'MTN', ORDERED_QUANTITY * 20,
                                      ORDERED_QUANTITY))
                     FROM apps.oe_order_lines_all oi
                    WHERE     oi.header_id = a.header_ID
                          AND oi.inventory_item_id = o.inventory_item_id
                          AND ORDER_QUANTITY_UOM <> 'PCS')
                     ITEM_WISE_ORDERED_QUANTITY
             FROM apps.oe_order_headers_all a,
                  apps.oe_order_lines_all o,
                  xxakg_del_ord_hdr doh,
                  inv.mtl_system_items_b msi
            WHERE     a.header_id = o.header_id
                  AND o.SHIPMENT_PRIORITY_CODE = doh.DO_NUMBER
                  AND o.inventory_item_id = msi.inventory_item_id
                  AND o.SHIP_FROM_ORG_ID = msi.organization_id
                  AND ORDER_QUANTITY_UOM <> 'PCS'
                  AND o.org_id = 85
           UNION ALL
           SELECT 2 SOURCE,
                  customer_number,
                  customer_name,
                  a.order_number,
                  'AWAITING_SHIPPING',
                  ordered_date,
                  ORDER_CATEGORY_CODE,
                  ITEM_NUMBER ORDERED_ITEM,
                  item_description,
                  UOM_CODE ORDER_QUANTITY_UOM,
                  DECODE (UOM_CODE, 'MTN', LINE_QUANTITY * 20, LINE_QUANTITY)
                     ORDERED_QUANTITY,
                  0 SHIPPED_QUANTITY,
                  dol.DO_NUMBER,
                  doh.DO_DATE,
                  NULL ACTUAL_SHIPMENT_DATE,
                  DECODE (UOM_CODE, 'MTN', LINE_QUANTITY * 20, LINE_QUANTITY)
                     DO_QUANTITY,
                  (SELECT SUM(DECODE (ORDER_QUANTITY_UOM,
                                      'MTN', ORDERED_QUANTITY * 20,
                                      ORDERED_QUANTITY))
                     FROM apps.oe_order_lines_all o
                    WHERE o.header_id = a.header_ID
                          AND ORDER_QUANTITY_UOM <> 'PCS')
                     TOTAL_ORDERED_QUANTITY,
                  DO_STATUS,
                  (SELECT SUM(DECODE (ORDER_QUANTITY_UOM,
                                      'MTN', ORDERED_QUANTITY * 20,
                                      ORDERED_QUANTITY))
                     FROM apps.oe_order_lines_all oi
                    WHERE     oi.header_id = a.header_ID
                          AND oi.inventory_item_id = dol.ORDERED_ITEM_ID
                          AND ORDER_QUANTITY_UOM <> 'PCS')
                     ITEM_WISE_ORDERED_QUANTITY
             FROM xxakg_del_ord_hdr doh,
                  XXAKG_DEL_ORD_DO_LINES dol,
                  apps.oe_order_headers_all a
            WHERE     dol.DO_HDR_ID = doh.DO_HDR_ID
                  AND dol.ORDER_HEADER_ID = a.header_id
                  AND UOM_CODE <> 'PCS'
                  AND a.org_id = 85
                  AND NOT EXISTS (SELECT 1
                                    FROM apps.oe_order_lines_all o
                                   WHERE o.line_id = dol.ORDER_LINE_ID)
           UNION ALL
           SELECT 3 SOURCE,
                  customer_number,
                  customer_name,
                  a.order_number,
                  O.FLOW_STATUS_CODE,
                  ordered_date,
                  ORDER_CATEGORY_CODE,
                  ORDERED_ITEM,
                  DESCRIPTION item_description,
                  ORDER_QUANTITY_UOM,
                  (DECODE (ORDER_QUANTITY_UOM,
                           'MTN', ORDERED_QUANTITY * 20,
                           ORDERED_QUANTITY)
                   - NVL (
                        (SELECT SUM(DECODE (UOM_CODE,
                                            'MTN', line_quantity * 20,
                                            line_quantity))
                           FROM XXAKG_DEL_ORD_DO_LINES doli
                          WHERE doli.ORDER_HEADER_ID = o.HEADER_ID
                                AND doli.ordered_item_id =
                                      o.inventory_item_id
                                AND doli.ORDER_LINE_ID IS NULL),
                        0))
                     REMAINING_ORDERED_QUANTITY,
                  NULL SHIPPED_QUANTITY,
                  NULL DO_NUMBER,
                  NULL DO_DATE,
                  NULL ACTUAL_SHIPMENT_DATE,
                  NULL DO_QUANTITY,
                  (SELECT SUM(DECODE (ORDER_QUANTITY_UOM,
                                      'MTN', ORDERED_QUANTITY * 20,
                                      ORDERED_QUANTITY))
                     FROM apps.oe_order_lines_all o
                    WHERE o.header_id = a.header_ID
                          AND ORDER_QUANTITY_UOM <> 'PCS')
                     TOTAL_ORDERED_QUANTITY,
                  'BOOKED' DO_STATUS,
                  (SELECT SUM(DECODE (ORDER_QUANTITY_UOM,
                                      'MTN', ORDERED_QUANTITY * 20,
                                      ORDERED_QUANTITY))
                     FROM apps.oe_order_lines_all oi
                    WHERE     oi.header_id = a.header_ID
                          AND oi.inventory_item_id = o.ORDERED_ITEM_ID
                          AND ORDER_QUANTITY_UOM <> 'PCS')
                     ITEM_WISE_ORDERED_QUANTITY
             FROM apps.oe_order_headers_all a,
                  apps.oe_order_lines_all o,
                  inv.mtl_system_items_b msi,
                  apps.xxakg_ar_customer_site_v cust
            WHERE     a.header_id = o.header_id
                  AND o.inventory_item_id = msi.inventory_item_id
                  AND o.SHIP_FROM_ORG_ID = msi.organization_id
                  AND o.SOLD_TO_ORG_ID = cust.customer_id
                  AND site_use_code = 'BILL_TO'
                  AND primary_flag = 'Y'
                  AND a.org_id = 85
                  AND o.FLOW_STATUS_CODE = 'AWAITING_SHIPPING'
                  AND o.SHIPMENT_PRIORITY_CODE IS NULL
                  AND ORDER_QUANTITY_UOM <> 'PCS'
           UNION ALL
           SELECT 4 SOURCE,
                  customer_number,
                  customer_name,
                  a.order_number,
                  O.FLOW_STATUS_CODE,
                  ordered_date,
                  ORDER_CATEGORY_CODE,
                  ORDERED_ITEM,
                  DESCRIPTION item_description,
                  ORDER_QUANTITY_UOM,
                  DECODE (ORDER_QUANTITY_UOM,
                          'MTN', ORDERED_QUANTITY * 20,
                          ORDERED_QUANTITY),
                  NULL SHIPPED_QUANTITY,
                  NULL DO_NUMBER,
                  NULL DO_DATE,
                  NULL ACTUAL_SHIPMENT_DATE,
                  NULL DO_QUANTITY,
                  (SELECT SUM(DECODE (ORDER_QUANTITY_UOM,
                                      'MTN', ORDERED_QUANTITY * 20,
                                      ORDERED_QUANTITY))
                     FROM apps.oe_order_lines_all o
                    WHERE o.header_id = a.header_ID
                          AND ORDER_QUANTITY_UOM <> 'PCS')
                     TOTAL_ORDERED_QUANTITY,
                  'ENTERED' DO_STATUS,
                  (SELECT SUM(DECODE (ORDER_QUANTITY_UOM,
                                      'MTN', ORDERED_QUANTITY * 20,
                                      ORDERED_QUANTITY))
                     FROM apps.oe_order_lines_all oi
                    WHERE     oi.header_id = a.header_ID
                          AND oi.inventory_item_id = o.ORDERED_ITEM_ID
                          AND ORDER_QUANTITY_UOM <> 'PCS')
                     ITEM_WISE_ORDERED_QUANTITY
             FROM apps.oe_order_headers_all a,
                  apps.oe_order_lines_all o,
                  inv.mtl_system_items_b msi,
                  apps.xxakg_ar_customer_site_v cust
            WHERE     a.header_id = o.header_id
                  AND o.inventory_item_id = msi.inventory_item_id
                  AND o.SHIP_FROM_ORG_ID = msi.organization_id
                  AND o.SOLD_TO_ORG_ID = cust.customer_id
                  AND site_use_code = 'BILL_TO'
                  AND primary_flag = 'Y'
                  AND a.org_id = 85
                  AND o.FLOW_STATUS_CODE = 'ENTERED'
                  AND ORDER_QUANTITY_UOM <> 'PCS');