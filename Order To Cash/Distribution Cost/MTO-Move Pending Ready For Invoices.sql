/* Formatted on 7/27/2019 9:55:57 AM (QP5 v5.287) */
SELECT 'MOVE' MOVE_TYPE,
       --md.customer_number,
       --mh.mov_ord_hdr_id,
       MH.MOV_ORDER_NO,
       TO_CHAR (MH.MOV_ORDER_DATE) MOV_ORDER_DATE,
       MH.MOV_ORDER_STATUS,
       --mh.mov_order_type,
       MH.FINAL_DESTINATION,
       MH.WAREHOUSE_ORG_CODE MOVE_WH_ORG_CODE,
       MH.TRANSPORT_MODE,
       MH.GATE_OUT,
       MH.GATE_IN,
       MH.READY_FOR_INVOICE
  --,mh.hire_rate_ap--,
  --mh.ap_flag
  FROM APPS.XXAKG_MOV_ORD_HDR MH
 --,apps.xxakg_mov_ord_dtl md
 WHERE     1 = 1
       --and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
       AND MH.READY_FOR_INVOICE = 'N'
       AND MH.ORG_ID = 85
       AND MH.GATE_OUT = 'Y'
       AND MH.GATE_IN = 'Y'                                   -- IS NULL--='Y'
       --and mh.warehouse_org_code='SCI'
       AND MH.MOV_ORDER_STATUS = 'CONFIRMED'
       AND MH.VEHICLE_NO NOT IN ('SCIL-SCM-0001',
                                 'SCIL-SCM-0002',
                                 'SCIL-SCM-0003',
                                 'SCIL-SCM-0004')
--and mh.vehicle_type='Owned By Company'
--and mh.transport_mode='Company Truck'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--AND TRUNC(MH.CONFIRMED_DATE)>='01-JAN-2017'
--AND TRUNC(MH.CONFIRMED_DATE)<='30-JUN-2019'
--AND TO_CHAR (MH.CONFIRMED_DATE, 'RRRR') = '2017'
AND TO_CHAR (MH.CONFIRMED_DATE, 'MON-RR') = :P_PERIOD
--AND TO_CHAR (MH.CONFIRMED_DATE, 'MON-RR') = 'MAR-18'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'JUN-18'
--ORDER BY mh.gate_out_date DESC
UNION ALL
SELECT 'MTO' MOVE_TYPE,
       --TDL.TO_NUMBER,
       --TDH.TO_STATUS,
       TMH.MOV_ORDER_NO,
       TO_CHAR (TMH.MOV_ORDER_DATE) MOV_ORDER_DATE,
       TMH.MOV_ORDER_STATUS,
       TMH.FINAL_DESTINATION,
       TMH.FROM_INV MOVE_WH_ORG_CODE,
       TMH.TRANSPORT_MODE,
       TMH.GATE_OUT,
       TMH.GATE_IN,
       TMH.READY_FOR_INVOICE
       --,TMH.*
  FROM XXAKG.XXAKG_TO_MO_HDR TMH
 WHERE     1 = 1
       AND TMH.ORG_ID = 85
       --AND TMH.MOV_ORDER_STATUS='GENERATED'
       AND TMH.MOV_ORDER_STATUS = 'CONFIRMED'
       AND TMH.READY_FOR_INVOICE != 'Y'
       --AND TMH.MOV_ORDER_NO='MTO/SCOU/054916'
       --AND TDL.TO_NUMBER='TO/SCOU/087983'
       --AND  TMH.TRANSPORT_MODE='Company Barge'
       --AND TRUNC (TMH.MOV_ORDER_DATE) <= '30-JUN-2019'
       AND TO_CHAR (TMH.MOV_ORDER_DATE, 'MON-RR') = :P_PERIOD
--AND TO_CHAR (TMH.MOV_ORDER_DATE, 'DD-MON-RR') ='08-AUG-18'
--AND TO_CHAR (TMH.MOV_ORDER_DATE, 'MON-RR') =:P_PERIOD_NAME-- 'JAN-18'
--AND TO_CHAR (TMH.MOV_ORDER_DATE, 'RRRR') =:P_YEAR-- '2018'
--AND NVL(TMH.GATE_PASS_NO,0)='0'
--AND TMH.GATE_PASS_NO IS NOT NULL
--AND TMH.FROM_INV='SCI'
--AND TMH.GATE_IN='Y'
--AND TMH.GATE_OUT!='Y'
--AND TMH.VEHICLE_NO='D.M.U-11-1034'
--ORDER BY GATE_IN_DATE DESC