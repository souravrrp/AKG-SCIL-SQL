SELECT
MOH.MOV_ORDER_NO,
MOH.FINAL_DESTINATION,
MOH.TRANSPORT_MODE,
MOH.VEHICLE_NO
--,MOH.MOV_ORDER_DATE MO_DATE
--,MOH.*
FROM
XXAKG.XXAKG_MOV_ORD_HDR MOH
WHERE 1=1
AND MOH.TRANSPORT_MODE IN ('Company Bulk Carrier','Company Truck','Company District Truck')
AND MOH.WAREHOUSE_ORG_CODE IN ('SCI','RMC','RMT')
AND MOH.MOV_ORDER_STATUS='CONFIRMED'
AND MOH.MOV_ORDER_TYPE='RELATED'
AND MOH.MOV_ORDER_NO='MO/SCOU/1237285'
--AND MOH.GATE_IN='Y' 
--AND TO_CHAR(MOH.GATE_OUT_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/NOV/28 06:00:00' AND '2018/NOV/29 09:40:00'--HH:MI:SS--12:00:00
--AND NOT EXISTS (SELECT 1 FROM APPS.XXAKG_FUEL_MAINTANANCE FU WHERE FU.MOVE_ORDER_NO=MOH.MOV_ORDER_NO)

SELECT
TMH.MOV_ORDER_NO,
--TMH.FROM_INV WAREHOUSE,
TMH.FINAL_DESTINATION,
TMH.TRANSPORT_MODE,
TMH.VEHICLE_NO
--,TMH.*
FROM
XXAKG.XXAKG_TO_MO_HDR TMH
WHERE 1=1
--AND TMH.TRANSPORT_MODE IN ('Company Bulk Carrier','Company Truck','Company District Truck')
AND TMH.FROM_INV='SCI'
AND TMH.MOV_ORDER_STATUS='CONFIRMED'
AND TMH.MOV_ORDER_TYPE='RELATED'
AND TMH.MOV_ORDER_NO='MTO/SCOU/064962'


----- KPL, DRIVER------------------

select 
    distinct pvrf.vehicle_repository_id,
    pvrf.registration_number,
    nvl(pvrf.fiscal_ratings,0) FISCAL_KPL,
    nvl(vre_attribute20,pvrf.fiscal_ratings) DISTRICT_KPL,
    papf.employee_number,
    papf.full_name
     FROM 
      apps.pqp_vehicle_repository_f pvrf,
      apps.per_all_people_f papf
     where 
         registration_number like 'D.M.U-11-5189'
         and  papf.person_id(+)=pvrf.vre_attribute19 
         and  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(papf.effective_start_date,SYSDATE)) AND TRUNC(NVL(papf.effective_end_date,(SYSDATE+1)))
         and  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(pvrf.effective_start_date,SYSDATE)) AND TRUNC(NVL(pvrf.effective_end_date,(SYSDATE+1)));
         

----------- Distance -----------------      
   
select 
    to_location,
      transport_mode,
   nvl(distance,0) distance
  from
  apps.xxakg_transport_hirerate
      where org_id in (84,85)
      and from_location in (101,100,201)
      and transport_mode in ('Company Truck','Company Bulk Carrier','Company District Truck')
      and to_location like '%Madaripur%'
      and end_date_active  is null;         
      
      


--------- Risk and VTS Percentage---------     

select
    distinct initcap(qr.character1) final_destination,
    qr.character2 destination_type,
    nvl(to_number(qr.character3),0) risk_percentage,
    nvl(to_number(qr.character4),0) vts_percentage 
from
    qa.qa_plans qp,
    qa.QA_RESULTS qr
where
    qp.name='FINAL DESTINATION RISK PERCENT'
    and qp.plan_id=qr.plan_id
    and qr.character1 like '%Madaripur%'




-------------------------------------FIND BEFORE EXECUTION-----------------------------

SELECT
*
FROM
APPS.XXAKG_TRIP_FUEL TF
WHERE 1=1
AND WAREHOUSE IN ('SCI','RMC','RMT')
AND TF.MOV_ORDER_NO LIKE '%MO/SCOU/890413%'
--AND FINAL_DESTINATION='Savar'
--AND VEHICLE_NO='D.M.U-11-2404'
--AND TO_CHAR(MOV_ORDER_DATE,'RRRR')='2018'
--AND TO_CHAR(MOV_ORDER_DATE,'MON-RR')='DEC-17'
--AND TO_CHAR(MOV_ORDER_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/MAR/05 06:00:00' AND '2018/MAR/06 06:00:00'--HH:MI:SS--12:00:00



------------------------------DAILY FUEL-----------------------------------------------------

SELECT 
TO_CHAR(FU.MO_CREATION_DATE,'DD/MON/YYYY HH24:MI:SS') ISSUE_DATE,
FU.MOVE_ORDER_NO,
FU.VEHICLE_NUMBER,
FU.DRIVER_ID,
FU.DRIVER_NAME,
FU.PROVIDED_FUEL ISSUED_FUEL,
STATUS,
REMARKS,
'['||distance_km||'/'||kpl||'] '||nvl(ESTIMATED_FUEL,0)||'+('||nvl(adjusted_amount,0) ||')+('||nvl(special_advance,0)||')-('||nvl(PREVIOUS_REMAIN_FUEL,0)||')= '||
(ESTIMATED_FUEL+nvl(adjusted_amount,0)+nvl(special_advance,0))||'-('||nvl(PREVIOUS_REMAIN_FUEL,0)||')= '||PROVIDED_FUEL calculation
,COST_CENTER
,FU.LAST_MOVE_NO PREVIOUS_MOVE_NO
--,FU.*
FROM APPS.XXAKG_FUEL_MAINTANANCE FU
WHERE 1=1
AND ((:P_ORG_ID IS NULL AND FU.ORGANIZATION_ID IN (84,82)) OR (FU.ORGANIZATION_ID=:P_ORG_ID))
--AND FU.DRIVER_ID=1900
--AND FU.COST_CENTER!='FCTRK'
--AND FU.VEHICLE_NUMBER LIKE '%1473%'
AND ((:P_MOVE_NO IS NULL) OR (FU.MOVE_ORDER_NO=:P_MOVE_NO))
--AND FU.MOVE_ORDER_NO IN ('MO/SCOU/1232008')
--AND FU.MOVE_ORDER_NO IS NULL
--AND TO_CHAR(FU.MO_DATE,'RRRR')='2019'
--AND TO_CHAR(FU.MO_DATE,'MON-RR')='DEC-17'
--AND TO_CHAR(FU.MO_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/NOV/28 18:00:00' AND '2018/NOV/29 09:00:00'--HH:MI:SS--12:00:00
--AND EXISTS(SELECT 1 FROM XXAKG.XXAKG_MOV_ORD_HDR MOH WHERE FU.MOVE_ORDER_NO=MOH.MOV_ORDER_NO AND MOH.TRANSPORT_MODE IN ('Company Bulk Carrier') )    --'Company Truck'
ORDER BY MO_DATE DESC

--------------------------------------FUEL_INV_MOVE---------------------------------------
SELECT 
TO_CHAR(NVL(FUEL_VIEW.TRANSACTION_DATE,FUEL_VIEW.MO_CREATION_DATE),'DD/MON/YYYY HH24:MI:SS') ISSUE_DATE,
FUEL_VIEW.MOVE_ORDER_NO,
FUEL_VIEW.VEHICLE_NUMBER,
FUEL_VIEW.DRIVER_ID,
FUEL_VIEW.DRIVER_NAME,
FUEL_VIEW.PROVIDED_FUEL ISSUED_FUEL,
STATUS,
REMARKS,
'['||distance_km||'/'||kpl||'] '||nvl(ESTIMATED_FUEL,0)||'+('||nvl(adjusted_amount,0) ||')+('||nvl(special_advance,0)||')-('||nvl(PREVIOUS_REMAIN_FUEL,0)||')= '||
(ESTIMATED_FUEL+nvl(adjusted_amount,0)+nvl(special_advance,0))||'-('||nvl(PREVIOUS_REMAIN_FUEL,0)||')= '||PROVIDED_FUEL calculation
,COST_CENTER
,FUEL_VIEW.LAST_MOVE_NO PREVIOUS_MOVE_NO
,FUEL_VIEW.*
FROM APPS.XXAKG_FUEL_MAINTANANCE_V FUEL_VIEW
WHERE 1=1
AND FUEL_VIEW.ORGANIZATION_ID=82   -- IN (84,82)
--AND FUEL_VIEW.STATUS='TRANSACTED'  --TRANSACTED    --APPROVE
--AND FUEL_VIEW.COST_CENTER!='FCTRK'
--AND FUEL_VIEW.VEHICLE_NUMBER LIKE '%1473%'
--AND FUEL_VIEW.MOVE_ORDER_NO LIKE '%MO/SCOU/1344105%'
--AND FUEL_VIEW.MOVE_ORDER_NO IS NULL
--AND FUEL_VIEW.DRIVER_ID='1599'
--AND FUEL_VIEW.ALTERNATE_DRIVV_ID='35526'
--AND TRUNC(FUEL_VIEW.CREATION_DATE)<NVL(:P_DATE_UPTO,SYSDATE)
--AND TO_CHAR(FUEL_VIEW.MO_DATE,'RRRR')='2019'
--AND TO_CHAR(FUEL_VIEW.MO_DATE,'MON-RR')='DEC-17'
--AND TO_CHAR(FUEL_VIEW.MO_DATE,'YYYY/MON/DD HH24:MI:SS') BETWEEN '2018/NOV/28 18:00:00' AND '2018/NOV/29 09:00:00'--HH:MI:SS--12:00:00
--AND EXISTS(SELECT 1 FROM XXAKG.XXAKG_MOV_ORD_HDR MOH WHERE FUEL_VIEW.MOVE_ORDER_NO=MOH.MOV_ORDER_NO AND MOH.TRANSPORT_MODE IN ('Company Bulk Carrier') )    --'Company Truck'
--AND FUEL_VIEW.TRANSACTION_DATE IS NULL
--AND FUEL_VIEW.PROVIDED_FUEL!='0'
ORDER BY MO_DATE DESC

---------------------------------------------TRIP FUEL VIEW--------------------------------

SELECT moh.mov_order_no mov_order_no,
            moh.final_destination final_destination,
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
            AND moh.transport_mode IN ('Company Truck', 'Company Bulk Carrier','Company District Truck')
            --            AND moh.gate_out = 'Y'
            --AND moh.gate_in is null
            --AND moh.gate_in_date is null
            AND moh.org_id in (84,85)
            AND moh.warehouse_org_code in ('SCI','RMC','RMT')
            AND moh.mov_order_no NOT IN (SELECT NVL (move_order_no, 'XX')
                                           FROM apps.xxakg_fuel_maintanance)
            --and mov_order_no='MO/SCOU/683371'
            AND moh.mov_order_date >= '01-JAN-2016'
   GROUP BY moh.mov_order_no,
            moh.final_destination,
            moh.warehouse_org_code,
            moh.vehicle_no,
            dol.uom_code,
            moh.mov_order_date
            
UNION ALL

SELECT mth.mov_order_no mov_order_no,
            mth.final_destination final_destination,
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
            AND mth.transport_mode IN ('Company Truck', 'Company Bulk Carrier','Company District Truck')
            AND mth.mov_order_no NOT IN
                     (  SELECT NVL(move_order_no,'XX') FROM apps.xxakg_fuel_maintanance)
            -- and mov_order_no='MTO/SCOU/031625'
            AND mth.mov_order_date > '20-AUG-2017'
   GROUP BY mth.mov_order_no,
            mth.final_destination,
            mth.from_inv,
            mth.vehicle_no,
            tl.uom_code,
            mth.mov_order_date;    
            
            
 
    ----------------------Previous History ---------------------------------

 select
        driver_id,
        driver_name,
        move_order_no,
        final_destination,
        distance_km,
        provided_fuel,
        creation_date,
        vehicle_number,
        remaining_fuel,
        vts_km,
        opening_balance
    from 
        apps.xxakg_fuel_maintanance 
    where vehicle_number='D.M.U-11-0998'
    and creation_date =(select max(creation_date) from apps.xxakg_fuel_maintanance where vehicle_number='D.M.U-11-0998');
    
    
    
------------------------****Notes****----------------------
--inventory_item_id=55605 and SUBINVENTORY_CODE='CRT-PUMP' and organization_id=1306--

---------------------------------MOVE HEADER----------------------------------------------
SELECT
TRX.TRANSACTION_TYPE_NAME
,TRX.MOVE_ORDER_TYPE_NAME
,H.REQUEST_NUMBER MOVE_ORDER
,H.ORGANIZATION_ID
,H.FROM_SUBINVENTORY_CODE
,H.ATTRIBUTE1 VEHICLE_NO
,L.INVENTORY_ITEM_ID
--,(SELECT MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=L.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID=L.ORGANIZATION_ID) ITEM_CODE
,(SELECT MSI.DESCRIPTION FROM APPS.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=L.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID=L.ORGANIZATION_ID) ITEM_NAME
,L.UOM_CODE
,L.QUANTITY
,L.QUANTITY_DELIVERED
,TRX.HEADER_STATUS_NAME
,TRX.STATUS_DATE
--,H.* 
--,L.*
--,TRX.*
--,MMT.*
--MTT.*
FROM
APPS.MTL_TXN_REQUEST_HEADERS H
,APPS.MTL_TXN_REQUEST_LINES L
,APPS.MTL_TXN_REQUEST_HEADERS_V TRX
--,APPS.MTL_MATERIAL_TRANSACTIONS MMT
--,INV.MTL_TRANSACTION_TYPES MTT
WHERE 1=1
--AND MTT.TRANSACTION_TYPE_ID=MMT.TRANSACTION_TYPE_ID
--AND MTT.TRANSACTION_SOURCE_TYPE_ID = MMT.TRANSACTION_SOURCE_TYPE_ID
--AND MMT.TRANSACTION_SOURCE_ID=H.HEADER_ID
--AND L.LINE_ID=MMT.MOVE_ORDER_LINE_ID
--AND H.REQUEST_NUMBER=MMT.TRANSACTION_SOURCE_ID
--AND TO_CHAR (MMT.TRANSACTION_DATE, 'MON-RR') = 'APR-18'
--AND TO_CHAR (MMT.TRANSACTION_DATE, 'RRRR') = '2018'
--AND TO_CHAR (MMT.TRANSACTION_DATE, 'DD-MON-RR') = '27-MAY-17'
AND H.REQUEST_NUMBER=TRX.REQUEST_NUMBER
AND H.HEADER_ID=L.HEADER_ID
AND H.ORGANIZATION_ID=L.ORGANIZATION_ID
--and TO_CHAR(H.DATE_REQUIRED,'RRRR')='2018'
--and to_char(H.DATE_REQUIRED,'DD-MON-RR')='05-MAY-18'
--and h.FROM_SUBINVENTORY_CODE='AKC-GEN ST'
AND H.ORGANIZATION_ID=1306
--AND L.INVENTORY_ITEM_ID='511077'
--AND TRX.MOVE_ORDER_TYPE_NAME='Requisition'
--AND TRX.TRANSACTION_TYPE_NAME='Move Order Issue'
AND ((:P_MOVE_NO IS NULL) OR (H.REQUEST_NUMBER=:P_MOVE_NO))
--AND H.REQUEST_NUMBER IN ('15129101')   --9642353
--AND L.LINE_ID='31251259'
--AND H.HEADER_ID='15129101'
ORDER BY H.REQUEST_NUMBER DESC