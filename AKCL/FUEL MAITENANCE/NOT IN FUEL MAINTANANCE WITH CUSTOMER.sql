SELECT moh.mov_order_no mov_order_no,
            moh.final_destination final_destination,
            doh.customer_number,
            doh.customer_name,
            moh.warehouse_org_code warehouse,
            moh.vehicle_no vehicle_no,
            dol.uom_code uom,
            moh.mov_order_date mov_order_date,
            SUM (dol.line_quantity) quantity
       FROM apps.xxakg_mov_ord_hdr moh,
            apps.xxakg_mov_ord_dtl mol,
            apps.xxakg_del_ord_hdr doh,
            apps.xxakg_del_ord_do_lines dol
      WHERE     moh.mov_ord_hdr_id = mol.mov_ord_hdr_id
            AND mol.do_number = doh.do_number
            AND doh.do_hdr_id = dol.do_hdr_id
            --            AND doh.printed_flag = 'Y'
            AND doh.do_status = 'CONFIRMED'
            AND moh.transport_mode IN ('Company Truck', 'Company Bulk Carrier')
            --            AND moh.gate_out = 'Y'
            --AND moh.gate_in is null
            --AND moh.gate_in_date is null
            AND moh.org_id = 85
            AND moh.warehouse_org_code = 'SCI'
            AND moh.mov_order_no NOT IN (SELECT NVL (move_order_no, 'XX')
                                           FROM apps.xxakg_fuel_maintanance)
            --and mov_order_no='MO/SCOU/683371'
            AND moh.mov_order_date >= '01-JAN-2018'
   GROUP BY moh.mov_order_no,
            moh.final_destination,
            doh.customer_number,
            doh.customer_name,
            moh.warehouse_org_code,
            moh.vehicle_no,
            dol.uom_code,
            moh.mov_order_date
UNION ALL
SELECT mth.mov_order_no mov_order_no,
            mth.final_destination final_destination,
            (select hca.account_number from apps.hz_cust_accounts hca where th.customer_id=hca.cust_account_id) customer_number,
            th.customer_name,
            mth.from_inv warehouse,
            mth.vehicle_no vehicle_no,
            tl.uom_code uom,
            mth.mov_order_date mov_order_date,
            SUM (tl.quantity) quantity
       FROM apps.xxakg_to_mo_hdr mth,
            apps.xxakg_to_mo_dtl mtl,
            apps.xxakg_to_do_hdr th,
            apps.xxakg_to_do_lines tl
      WHERE     mth.mov_ord_hdr_id = mtl.mov_ord_hdr_id
            AND mtl.to_hdr_id = th.to_hdr_id
            AND th.to_hdr_id = tl.to_hdr_id
            AND th.to_status = 'CONFIRMED'
            AND mth.org_id=85
            AND mth.from_inv='SCI'
            AND mth.transport_mode IN ('Company Truck', 'Company Bulk Carrier')
            AND mth.mov_order_no NOT IN
                     (  SELECT NVL(move_order_no,'XX') FROM apps.xxakg_fuel_maintanance)
            -- and mov_order_no='MTO/SCOU/031625'
            AND mth.mov_order_date >= '01-JAN-2018'
   GROUP BY mth.mov_order_no,
            mth.final_destination,
            th.customer_id,
            th.customer_name,
            mth.from_inv,
            mth.vehicle_no,
            tl.uom_code,
            mth.mov_order_date;    



