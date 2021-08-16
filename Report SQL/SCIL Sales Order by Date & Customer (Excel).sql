SELECT   NVL (r.region_name, 'Not Defined') region_name, h.customer_number,
         h.sold_to customer_name, TO_CHAR (h.order_number) order_number,
         TRUNC (h.ordered_date) order_date, l.ordered_item,
         l.order_quantity_uom uom, msi.description item_description,
         l.unit_selling_price, SUM (l.ordered_quantity) ordered_quantity,
         (SUM (l.ordered_quantity) * l.unit_selling_price) total_value,
         DECODE
            (l.ship_from_org_id,
             101, l.ship_from,
             xxakg_com_pkg.get_organization_name (l.ship_from_org_id)
            ) warehouse,
         l.shipment_priority_code do_number,
         INITCAP (l.flow_status_code) status,
         xxakg_com_pkg.get_user_name (h.tp_attribute15) approved_by,
         wsh.released_status
    FROM oe_order_headers_v h,
         oe_order_lines_v l,
         wsh_delivery_details wsh,
         mtl_system_items msi,
         xxakg_distributor_block_m r
   WHERE h.header_id = l.header_id
     AND h.org_id = l.org_id
     AND l.header_id = wsh.source_header_id(+)
     AND l.line_id = wsh.source_line_id(+)
     AND msi.inventory_item_id = l.inventory_item_id
     AND msi.organization_id = l.ship_from_org_id
     AND item_type_code NOT IN ('CLASS', 'OPTION', 'CONFIG', 'INCLUDED')
     AND (   (l.top_model_line_id IS NOT NULL
              AND l.top_model_line_id = line_id
             )
          OR (l.top_model_line_id IS NULL)
         )
     AND h.customer_number = r.customer_number(+)
     AND h.org_id = r.org_id(+)
     AND h.org_id = :p_org_id
     AND l.flow_status_code <> 'CANCELLED'
     AND TRUNC (h.ordered_date) BETWEEN :p_date_from AND :p_date_to
     AND (   :p_customer_number IS NULL OR (h.customer_number = :p_customer_number))
     AND (:p_region_name IS NULL OR (r.region_name = :p_region_name))
AND EXISTS
                (SELECT 1
                   FROM APPS.FND_LOOKUP_VALUES b
                  WHERE     b.lookup_type = 'CEMENT_COMPANY_REGION_USER'
                        AND R.REGION_NAME = b.attribute13
                        and b.attribute9=:P_COMPANY AND b.attribute6 = :P_person_id
                        and b.ATTRIBUTE_CATEGORY='SCIL O2C Region'
                        and h.org_id=85
                   union
                   select 1 from dual where h.org_id <>85
                        )
         AND EXISTS
                (SELECT 1
                   FROM apps.ORG_ACCESs d
                  WHERE d.responsibility_id = :P_RESPONSIBILITY_ID
                        AND D.ORGANIZATION_ID =MSI.ORGANIZATION_ID 
                        and h.org_id=85
                    union
                    select 1 from dual where h.org_id<>85
                        )
  &P_STATUS_WHERE
GROUP BY NVL (r.region_name, 'Not Defined'),
         h.customer_number,
         h.sold_to,
         TO_CHAR (h.order_number),
         TRUNC (h.ordered_date),
         l.ordered_item,
         msi.description,
         l.flow_status_code,
         l.ordered_item,
         l.order_quantity_uom,
         l.unit_selling_price,
         l.ship_from_org_id,
         l.ship_from,
         l.shipment_priority_code,
         h.tp_attribute15,
         wsh.released_status
ORDER BY TRUNC (h.ordered_date), TO_CHAR (h.order_number)

----------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT   NVL (r.region_name, 'Not Defined') region_name, h.customer_number,
         h.sold_to customer_name, TO_CHAR (h.order_number) order_number,
         TRUNC (h.ordered_date) order_date, l.ordered_item,
         l.order_quantity_uom uom, msi.description item_description,
         l.unit_selling_price, SUM (l.ordered_quantity) ordered_quantity,
         (SUM (l.ordered_quantity) * l.unit_selling_price) total_value,
         DECODE
            (l.ship_from_org_id,
             101, l.ship_from,
             xxakg_com_pkg.get_organization_name (l.ship_from_org_id)
            ) warehouse,
         l.shipment_priority_code do_number,
         INITCAP (l.flow_status_code) status,
         xxakg_com_pkg.get_user_name (h.tp_attribute15) approved_by,
         NULL released_status
    FROM oe_order_headers_v h,
         oe_order_lines_v l,
         mtl_system_items msi,
         xxakg_distributor_block_m r
   WHERE h.header_id = l.header_id
     AND h.org_id = l.org_id
     AND msi.inventory_item_id = l.inventory_item_id
     AND msi.organization_id = l.ship_from_org_id
     AND item_type_code NOT IN ('CLASS', 'OPTION', 'CONFIG', 'INCLUDED')
     AND (   (l.top_model_line_id IS NOT NULL
              AND l.top_model_line_id = line_id
             )
          OR (l.top_model_line_id IS NULL)
         )
     AND h.customer_number = r.customer_number(+)
     AND h.org_id = r.org_id(+)
     AND h.org_id = :p_org_id
     AND l.flow_status_code <> 'CANCELLED'
     AND TRUNC (h.ordered_date) BETWEEN :p_date_from AND :p_date_to
     AND (   :p_customer_number IS NULL OR (h.customer_number = :p_customer_number))
     AND (:p_region_name IS NULL OR (r.region_name = :p_region_name))
AND EXISTS
                (SELECT 1
                   FROM APPS.FND_LOOKUP_VALUES b
                  WHERE     b.lookup_type = 'CEMENT_COMPANY_REGION_USER'
                        AND R.REGION_NAME = b.attribute13
                        and b.attribute9=:P_COMPANY AND b.attribute6 = :P_person_id
                        and b.ATTRIBUTE_CATEGORY='SCIL O2C Region'
                        and h.org_id=85
                   union
                   select 1 from dual where h.org_id <>85
                        )
         AND EXISTS
                (SELECT 1
                   FROM apps.ORG_ACCESs d
                  WHERE d.responsibility_id = :P_RESPONSIBILITY_ID
                        AND D.ORGANIZATION_ID =MSI.ORGANIZATION_ID 
                        and h.org_id=85
                    union
                    select 1 from dual where h.org_id<>85
                        )
  &P_STATUS_WHERE
GROUP BY NVL (r.region_name, 'Not Defined'),
         h.customer_number,
         h.sold_to,
         TO_CHAR (h.order_number),
         TRUNC (h.ordered_date),
         l.ordered_item,
         msi.description,
         l.flow_status_code,
         l.ordered_item,
         l.order_quantity_uom,
         l.unit_selling_price,
         l.ship_from_org_id,
         l.ship_from,
         l.shipment_priority_code,
         h.tp_attribute15
ORDER BY TRUNC (h.ordered_date), TO_CHAR (h.order_number)
