select * 
        from apps.XXAKG_MOV_ORD_HDR mvh
        where  MOV_ORDER_STATUS IN ('CONFIRMED')
        AND ORG_ID = 85
        AND ap_flag IS NULL
        and mov_order_type = 'RELATED'
        AND VEHICLE_NO <> 'FOR RECO'
        AND transport_mode NOT IN ('Ex factory truck', 'Barge Ex factory')
        AND TRANSPORT_MODE='Rental Truck'
        AND mvh.READY_FOR_INVOICE='Y'
        AND TO_CHAR (mvh.CONFIRMED_DATE, 'DD-MON-RR') <= '30-JUN-18'
--        AND TO_CHAR (mvh.CONFIRMED_DATE, 'RRRR') = '2018'
--        AND TO_CHAR (mvh.CONFIRMED_DATE, 'MON-RR') = 'DEC-17'
        AND nvl(hire_rate_ap,0) = 0
        and not exists (select 1 from apps.ap_invoices_all api
                              where mvh.mov_order_no = api.invoice_num
                              and mvh.org_id = api.org_id);
                              
------------------------------------------------------------------------------------------------

SELECT 
MODT.CUSTOMER_NUMBER,
(SELECT HP.PARTY_NAME FROM APPS.HZ_PARTIES HP, APPS.HZ_CUST_ACCOUNTS HC WHERE HP.PARTY_ID=HC.PARTY_ID AND HC.ACCOUNT_NUMBER=MODT.CUSTOMER_NUMBER) CUSTOMER_NAME,
MODT.DO_NUMBER,
SUM(DODL.LINE_QUANTITY) DO_QUANTITY,
MOH.VEHICLE_NO,
MOH.MOV_ORDER_NO,
MOH.MOV_ORDER_STATUS,
MOH.WAREHOUSE_ORG_CODE,
MOH.FINAL_DESTINATION,
MOH.TRANSPORT_MODE,
MOH.TRANSPORTER_NAME,
MOH.HIRE_RATE_AP HIRE_RATE,
--MOH.INITIAL_GATE_IN,
--MOH.GATE_OUT,
--MOH.GATE_IN,
--MOH.READY_FOR_INVOICE,
--MOH.AP_FLAG,
TO_CHAR(MOH.CONFIRMED_DATE) CONFIRMED_DATE 
        FROM
        APPS.XXAKG_MOV_ORD_HDR MOH
        ,APPS.XXAKG_MOV_ORD_DTL MODT
        ,APPS.XXAKG_DEL_ORD_DO_LINES DODL
        WHERE 1=1
        AND DODL.DO_NUMBER=MODT.DO_NUMBER
        AND MOH.MOV_ORD_HDR_ID=MODT.MOV_ORD_HDR_ID
        AND  MOV_ORDER_STATUS IN ('CONFIRMED')
        AND MOH.ORG_ID = 85
        AND ap_flag IS NULL
        and mov_order_type = 'RELATED'
        AND VEHICLE_NO <> 'FOR RECO'
        AND transport_mode NOT IN ('Ex factory truck', 'Barge Ex factory')
        AND TRANSPORT_MODE='Rental Truck'
        AND MOH.READY_FOR_INVOICE='Y'
        AND TO_CHAR (MOH.CONFIRMED_DATE, 'DD-MON-RR') <= '30-JUN-18'
--        AND TO_CHAR (mvh.CONFIRMED_DATE, 'RRRR') = '2018'
--        AND TO_CHAR (mvh.CONFIRMED_DATE, 'MON-RR') = 'DEC-17'
        AND nvl(hire_rate_ap,0) = 0
        and not exists (select 1 from apps.ap_invoices_all api
                              where MOH.mov_order_no = api.invoice_num
                              and MOH.org_id = api.org_id)
GROUP BY
MODT.CUSTOMER_NUMBER,
MODT.DO_NUMBER,
MOH.VEHICLE_NO,
MOH.MOV_ORDER_NO,
MOH.MOV_ORDER_STATUS,
MOH.WAREHOUSE_ORG_CODE,
MOH.FINAL_DESTINATION,
MOH.TRANSPORT_MODE,
MOH.TRANSPORTER_NAME,
MOH.HIRE_RATE_AP,
--MOH.INITIAL_GATE_IN,
--MOH.GATE_OUT,
--MOH.GATE_IN,
--MOH.READY_FOR_INVOICE,
--MOH.GATE_PASS_NO,
--MOH.EMPTY_TRUCK_WT,
--MOH.SCALE_IN_WT,
--MOH.AP_FLAG,
MOH.CONFIRMED_DATE 
ORDER BY MOH.CONFIRMED_DATE DESC