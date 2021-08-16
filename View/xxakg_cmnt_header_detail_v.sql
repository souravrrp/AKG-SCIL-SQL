DROP VIEW APPS.XXAKG_CMNT_HEADER_DETAIL_V;

/* Formatted on 9/4/2019 3:01:19 PM (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW APPS.XXAKG_CMNT_HEADER_DETAIL_V
(
   HEADER_ID,
   ORDERED_DATE,
   ORG_ID,
   ORDER_NUMBER,
   SHIP_TO_ORG_ID,
   SOLD_TO_ORG_ID,
   CANCELLED_FLAG,
   OPEN_FLAG,
   BOOKED_FLAG,
   RETURN_REASON_CODE,
   BOOKED_DATE,
   LINE_ID,
   REVENUE_AMOUNT,
   ORDERED_ITEM,
   ORDER_QUANTITY_UOM,
   ORDERED_QUANTITY,
   CONVERT_ORDERED_BAG_QTY,
   SHIPPED_QUANTITY,
   CONVERT_SHIPPED_BAG_QTY,
   UNIT_SELLING_PRICE,
   INVOICED_QUANTITY,
   CONVERT_INVOICED_BAG_QTY,
   DELIVERY_DATE,
   FLOW_STATUS_CODE,
   DO_NUMBER,
   PRICE_LIST_ID,
   ORGANIZATION_ID,
   ORDERED_ITEM_ID,
   ITEM_GROUP,
   ORGANIZATION_CODE,
   ORGANIZATION_NAME,
   MODE_OF_TRANSPORT,
   AMOUNT,
   TRANSPORT_HIRE_RATE,
   TRANSPORT_COST,
   VAT_CHALLAN_NO,
   DO_STATUS,
   DO_DATE,
   DO_CONFIRM_DATE
)
   BEQUEATH DEFINER
AS
   SELECT header_id,
          ordered_date,
          org_id,
          order_number,
          ship_to_org_id,
          sold_to_org_id,
          cancelled_flag,
          open_flag,
          booked_flag,
          return_reason_code,
          booked_date,
          line_id,
          revenue_amount,
          ordered_item,
          order_quantity_uom,
          ordered_quantity,
          DECODE (
             org_id,
             85, (CASE 
                    when  ordered_item='CMNT.OBAG.0004' then (ordered_quantity*1000)/50
                        else decode (order_quantity_uom,'MTN', nvl (ordered_quantity, 0) * 20,nvl (ordered_quantity, 0))
                  END))
             convert_ordered_bag_qty,
          shipped_quantity,
          DECODE (
             org_id,
             85, (CASE 
                    when  ordered_item='CMNT.OBAG.0004' then (shipped_quantity*1000)/50
                        else decode (order_quantity_uom,'MTN', nvl (shipped_quantity, 0) * 20,nvl (shipped_quantity, 0))
                  END))
             convert_shipped_bag_qty,
          unit_selling_price,
          invoiced_quantity,
          DECODE (
             org_id,
             85, (CASE 
                    when  ordered_item='CMNT.OBAG.0004' then (invoiced_quantity*1000)/50
                        else decode (order_quantity_uom,'MTN', nvl (invoiced_quantity, 0) * 20,nvl (invoiced_quantity, 0))
                  END))
             convert_invoiced_bag_qty,
          actual_shipment_date,
          flow_status_code,
          do_number,
          price_list_id,
          ship_from_org_id,
          ordered_item_id,
          item_group,
          organization_code,
          organization_name,
          attribute11,
          amount,
          transport_hire_rate,
          --          shipped_quantity * transport_hire_rate
          0 transport_cost,
          --          apps.xxakg_bi_ont_pkg.get_vat_challan_no (line_id)
          NULL vat_challan_no,
          do_status,
          do_date,
          do_confirm_date
     FROM (SELECT a.header_id,
                  TRUNC (a.ordered_date) ordered_date,
                  a.org_id,
                  a.order_number,
                  o.ship_to_org_id,
                  o.sold_to_org_id,
                  o.cancelled_flag,
                  o.open_flag,
                  o.booked_flag,
                  o.return_reason_code,
                  TRUNC (a.booked_date) booked_date,
                  o.line_id,
                  o.revenue_amount,
                  o.ordered_item,
                  o.order_quantity_uom,
                  o.ordered_quantity,
                  o.shipped_quantity,
                  o.unit_selling_price,
                  o.invoiced_quantity,
                  TRUNC (o.actual_shipment_date) actual_shipment_date,
                  o.flow_status_code,
                  o.shipment_priority_code do_number,
                  o.price_list_id,
                  o.ship_from_org_id,
                  o.ordered_item_id,
                  mltc.segment2 item_group,
                  organization_code,
                  organization_name,
                  o.attribute11,
                  NVL (o.unit_selling_price, 0) * NVL (o.ordered_quantity, 0)
                     amount,
                  --                  apps.xxakg_bi_ont_pkg.get_transport_hire_rate (o.line_id)
                  0 transport_hire_rate,
                  o.line_number || '.' || o.shipment_number
                     parent_line_number,
                  (SELECT do_status
                     FROM apps.xxakg_del_ord_hdr
                    WHERE     org_id = a.org_id
                          AND do_number = o.shipment_priority_code
                          AND ROWNUM = 1)
                     do_status,
                  (SELECT do_date
                     FROM apps.xxakg_del_ord_hdr
                    WHERE     org_id = a.org_id
                          AND do_number = o.shipment_priority_code
                          AND ROWNUM = 1)
                     do_date,
                  flv.creation_date do_confirm_date
             FROM apps.oe_order_headers_all a,
                  apps.oe_order_lines_all o,
                  apps.mtl_categories mltc,
                  apps.mtl_category_sets mltcs,
                  apps.mtl_item_categories mltic,
                  apps.mtl_system_items msi,
                  apps.org_organization_definitions ood,
                  --apps.XXAKG_ORG_DEF_T ood,
                  apps.xle_le_ou_ledger_v le,
                  apps.fnd_lookup_values_vl flv
            WHERE     a.header_id = o.header_id
                  AND o.flow_status_code <> 'CANCELLED'
                  AND order_category_code = 'ORDER'
                  AND mltc.structure_id = mltcs.structure_id
                  AND UPPER (mltcs.category_set_name) = 'INVENTORY'
                  AND mltic.category_id = mltc.category_id
                  AND msi.inventory_item_id = mltic.inventory_item_id
                  AND msi.organization_id = mltic.organization_id
                  AND ood.organization_id = msi.organization_id
                  AND msi.organization_id = o.ship_from_org_id
                  AND msi.inventory_item_id = o.inventory_item_id
                  AND ood.organization_id = o.ship_from_org_id
                  AND ood.operating_unit = o.org_id
                  AND o.org_id = le.operating_unit_id
                  AND le.ledger_name = 'Cement Ledger'
                  AND mltc.segment2 <> 'BAG'
                  AND NVL (o.shipment_priority_code, '_XXX_') =
                         flv.lookup_code(+)
                  AND flv.lookup_type(+) = 'SHIPMENT_PRIORITY'
                  AND flv.view_application_id(+) = 660
                  AND flv.security_group_id(+) = 0);


GRANT SELECT ON APPS.XXAKG_CMNT_HEADER_DETAIL_V TO XXAKG_APPS_ROLE;

GRANT SELECT ON APPS.XXAKG_CMNT_HEADER_DETAIL_V TO XXAKG_ONT_ROLE;

/*
SELECT header_id,
          ordered_date,
          org_id,
          order_number,
          ship_to_org_id,
          sold_to_org_id,
          cancelled_flag,
          open_flag,
          booked_flag,
          return_reason_code,
          booked_date,
          line_id,
          revenue_amount,
          ordered_item,
          order_quantity_uom,
          ordered_quantity,
          DECODE (
             org_id,
             85, DECODE (order_quantity_uom,
                         'MTN', NVL (ordered_quantity, 0) * 20,
                         NVL (ordered_quantity, 0)))
             convert_ordered_bag_qty,
          shipped_quantity,
          DECODE (
             org_id,
             85, DECODE (order_quantity_uom,
                         'MTN', NVL (shipped_quantity, 0) * 20,
                         NVL (shipped_quantity, 0)))
             convert_shipped_bag_qty,
          unit_selling_price,
          invoiced_quantity,
          DECODE (
             org_id,
             85, DECODE (order_quantity_uom,
                         'MTN', NVL (invoiced_quantity, 0) * 20,
                         NVL (invoiced_quantity, 0)))
             convert_invoiced_bag_qty,
          actual_shipment_date,
          flow_status_code,
          do_number,
          price_list_id,
          ship_from_org_id,
          ordered_item_id,
          item_group,
          organization_code,
          organization_name,
          attribute11,
          amount,
          transport_hire_rate,
          --          shipped_quantity * transport_hire_rate

          0 transport_cost,
          --          apps.xxakg_bi_ont_pkg.get_vat_challan_no (line_id)

          NULL vat_challan_no,
          do_status,
          do_date,
          do_confirm_date
     FROM (SELECT a.header_id,
                  TRUNC (a.ordered_date) ordered_date,
                  a.org_id,
                  a.order_number,
                  o.ship_to_org_id,
                  o.sold_to_org_id,
                  o.cancelled_flag,
                  o.open_flag,
                  o.booked_flag,
                  o.return_reason_code,
                  TRUNC (a.booked_date) booked_date,
                  o.line_id,
                  o.revenue_amount,
                  o.ordered_item,
                  o.order_quantity_uom,
                  o.ordered_quantity,
                  o.shipped_quantity,
                  o.unit_selling_price,
                  o.invoiced_quantity,
                  TRUNC (o.actual_shipment_date) actual_shipment_date,
                  o.flow_status_code,
                  o.shipment_priority_code do_number,
                  o.price_list_id,
                  o.ship_from_org_id,
                  o.ordered_item_id,
                  mltc.segment2 item_group,
                  organization_code,
                  organization_name,
                  o.attribute11,
                  NVL (o.unit_selling_price, 0) * NVL (o.ordered_quantity, 0)
                     amount,
                  --                  apps.xxakg_bi_ont_pkg.get_transport_hire_rate (o.line_id)

                  0 transport_hire_rate,
                  o.line_number || '.' || o.shipment_number
                     parent_line_number,
                  (SELECT do_status
                     FROM apps.xxakg_del_ord_hdr
                    WHERE     org_id = a.org_id
                          AND do_number = o.shipment_priority_code
                          AND ROWNUM = 1)
                     do_status,
                  (SELECT do_date
                     FROM apps.xxakg_del_ord_hdr
                    WHERE     org_id = a.org_id
                          AND do_number = o.shipment_priority_code
                          AND ROWNUM = 1)
                     do_date,
                  flv.creation_date do_confirm_date
             FROM apps.oe_order_headers_all a,
                  apps.oe_order_lines_all o,
                  apps.mtl_categories mltc,
                  apps.mtl_category_sets mltcs,
                  apps.mtl_item_categories mltic,
                  apps.mtl_system_items msi,
                  --                  org_organization_definitions ood,

                  apps.XXAKG_ORG_DEF_T ood,
                  apps.xle_le_ou_ledger_v le,
                  apps.fnd_lookup_values_vl flv
            WHERE     a.header_id = o.header_id
                  AND o.flow_status_code <> 'CANCELLED'
                  AND order_category_code = 'ORDER'
                  AND mltc.structure_id = mltcs.structure_id
                  AND UPPER (mltcs.category_set_name) = 'INVENTORY'
                  AND mltic.category_id = mltc.category_id
                  AND msi.inventory_item_id = mltic.inventory_item_id
                  AND msi.organization_id = mltic.organization_id
                  AND ood.organization_id = msi.organization_id
                  AND msi.organization_id = o.ship_from_org_id
                  AND msi.inventory_item_id = o.inventory_item_id
                  AND ood.organization_id = o.ship_from_org_id
                  AND ood.operating_unit = o.org_id
                  AND o.org_id = le.operating_unit_id
                  AND le.ledger_name = 'Cement Ledger'
                  AND mltc.segment2 <> 'BAG'
                  AND NVL (o.shipment_priority_code, '_XXX_') =
                         flv.lookup_code(+)
                  AND flv.lookup_type(+) = 'SHIPMENT_PRIORITY'
                  AND flv.view_application_id(+) = 660
                  AND flv.security_group_id(+) = 0);
*/