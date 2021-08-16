select
--md.customer_number,
--mh.mov_ord_hdr_id,
mh.mov_order_no,
TO_CHAR(mh.mov_order_date) mov_order_date,
mh.mov_order_status,
--mh.mov_order_type,
mh.final_destination,
mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice
--,mh.hire_rate_ap--,
--mh.ap_flag
from
apps.xxakg_mov_ord_hdr mh
--,apps.xxakg_mov_ord_dtl md
where 1=1
--and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and mh.ready_for_invoice='N'
and mh.org_id=85
--and mh.gate_out='Y'
--and mh.gate_in='Y'-- IS NULL--='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
AND mh.VEHICLE_NO NOT IN ('SCIL-SCM-0001','SCIL-SCM-0002','SCIL-SCM-0003','SCIL-SCM-0004')
--and mh.vehicle_type='Owned By Company'
--and mh.transport_mode='Company Truck'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--AND TRUNC(MH.CONFIRMED_DATE)<NVL(:P_DATE_UPTO,SYSDATE)
--AND TRUNC(MH.CONFIRMED_DATE)>='01-JAN-2017'
--AND TRUNC(MH.CONFIRMED_DATE)<='31-JUL-2019'
--AND TO_CHAR (MH.CONFIRMED_DATE, 'RRRR') = '2017'
--AND TO_CHAR (MH.CONFIRMED_DATE, 'MON-RR') = 'MAR-18'
--AND TO_CHAR (mh.last_update_date, 'DD-MON-RR') = '08-SEP-19'
--ORDER BY mh.gate_out_date DESC
and exists (select 1 from apps.oe_order_lines_all ool, apps.xxakg_mov_ord_dtl modt 
                where ool.shipment_priority_code=modt.do_number 
                --and to_char(ool.actual_shipment_date,'MON-RR')='AUG-18' 
                and to_char(ool.actual_shipment_date,'RRRR')='2019' 
                and trunc(ool.actual_shipment_date)<nvl(:p_date_upto,sysdate)
                and mh.mov_ord_hdr_id=modt.mov_ord_hdr_id)


--------------------------------------------------------------------------------ACCOUNTS PURPOSE

SELECT                                                   --md.customer_number,
                                                          --mh.mov_ord_hdr_id,
      MH.MOV_ORDER_NO,
      TO_CHAR (MH.MOV_ORDER_DATE) MOV_ORDER_DATE,
      MH.MOV_ORDER_STATUS,
      --mh.mov_order_type,
      MH.FINAL_DESTINATION,
      MH.WAREHOUSE_ORG_CODE MOVE_WH_ORG_CODE,
      (CASE
          WHEN OOL.ORDERED_ITEM = 'CMNT.OBAG.0004'
          THEN
             (OOL.SHIPPED_QUANTITY * 1000) / 50
          ELSE
             DECODE (ORDER_QUANTITY_UOM,
                     'MTN', NVL (OOL.SHIPPED_QUANTITY, 0) * 20,
                     NVL (OOL.SHIPPED_QUANTITY, 0))
       END)
         QTY,
      MH.HIRE_RATE_AP HIRE_RATE,
      MH.TRANSPORT_MODE,
      MH.GATE_OUT,
      MH.GATE_IN,
      MH.READY_FOR_INVOICE
      ,OOL.ACTUAL_SHIPMENT_DATE INVOICE_DATE
 --mh.ap_flag
 FROM APPS.XXAKG_MOV_ORD_HDR MH,
      APPS.XXAKG_MOV_ORD_DTL MD,
      APPS.OE_ORDER_LINES_ALL OOL
WHERE     1 = 1
      AND OOL.SHIPMENT_PRIORITY_CODE = MD.DO_NUMBER
      AND MH.MOV_ORD_HDR_ID = MD.MOV_ORD_HDR_ID
      AND MH.READY_FOR_INVOICE = 'N'
      AND MH.ORG_ID = 85
      --and mh.gate_out='Y'
      --and mh.gate_in='Y'-- IS NULL--='Y'
      --and mh.warehouse_org_code='SCI'
      AND MH.MOV_ORDER_STATUS = 'CONFIRMED'
      AND MH.VEHICLE_NO NOT IN ('SCIL-SCM-0001',
                                'SCIL-SCM-0002',
                                'SCIL-SCM-0003',
                                'SCIL-SCM-0004')
      --and mh.vehicle_type='Owned By Company'
      --and mh.transport_mode='Company Truck'
      --and mh.transport_mode in ('Rental Truck','Rental Barge')
      --AND TRUNC(MH.CONFIRMED_DATE)<NVL(:P_DATE_UPTO,SYSDATE)
      --AND TRUNC(MH.CONFIRMED_DATE)>='01-JAN-2017'
      --AND TRUNC(MH.CONFIRMED_DATE)<='31-JUL-2019'
      --AND TO_CHAR (MH.CONFIRMED_DATE, 'RRRR') = '2017'
      --AND TO_CHAR (MH.CONFIRMED_DATE, 'MON-RR') = 'MAR-18'
      --AND TO_CHAR (mh.last_update_date, 'DD-MON-RR') = '08-SEP-19'
      AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'RRRR') = '2019'
      AND TRUNC (OOL.ACTUAL_SHIPMENT_DATE) < NVL ( :P_DATE_UPTO, SYSDATE)
--and to_char(ool.actual_shipment_date,'MON-RR')='AUG-18'
--ORDER BY mh.gate_out_date DESC