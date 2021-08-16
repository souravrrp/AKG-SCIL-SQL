SELECT
MOH.WAREHOUSE_ORG_CODE,
MOH.MOV_ORDER_NO,
MOH.FINAL_DESTINATION,
MOH.TRANSPORT_MODE,
MOH.VEHICLE_NO
,(SELECT PAPF.EMPLOYEE_NUMBER||'-'||PAPF.FULL_NAME FROM APPS.PER_ALL_PEOPLE_F PAPF WHERE PAPF.PERSON_ID=VR.VRE_ATTRIBUTE19 AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE) DRIVER
,NVL(VR.FISCAL_RATINGS,0) FISCAL_KPL
,NVL(VRE_ATTRIBUTE20,VR.FISCAL_RATINGS) DISTRICT_KPL
,NVL(HR.DISTANCE,0) DISTANCE
--,MOH.MOV_ORDER_DATE MO_DATE
--,MOH.*
FROM
XXAKG.XXAKG_MOV_ORD_HDR MOH
,APPS.XXAKG_TRANSPORT_HIRERATE HR
,APPS.PQP_VEHICLE_REPOSITORY_F VR
WHERE 1=1
AND MOH.ORG_ID IN (84,85)
AND MOH.FINAL_DESTINATION=HR.TO_LOCATION(+)
AND MOH.WAREHOUSE_ORG_ID=HR.FROM_LOCATION(+)
AND VR.REGISTRATION_NUMBER=MOH.VEHICLE_NO
AND  TRUNC(SYSDATE) BETWEEN TRUNC(NVL(VR.EFFECTIVE_START_DATE,SYSDATE)) AND TRUNC(NVL(VR.EFFECTIVE_END_DATE,(SYSDATE+1)))
AND MOH.TRANSPORT_MODE IN ('Company Bulk Carrier','Company Truck','Company District Truck')
AND MOH.WAREHOUSE_ORG_CODE IN ('RMC','RMT','SCI')   --='RMT'
AND MOH.MOV_ORDER_STATUS='CONFIRMED'
AND MOH.MOV_ORDER_TYPE='RELATED'
--AND MOH.VEHICLE_NO IN ('D.M.S-11-2294')
AND MOH.MOV_ORDER_NO IN ('MO/RMCOU/130297',
                                            'MO/RMCOU/130298',
                                            'MO/RMCOU/130299',
                                            'MO/RMCOU/130300',
                                            'MO/RMCOU/130301',
                                            'MO/RMCOU/130272',
                                            'MO/RMCOU/130242',
                                            'MO/RMCOU/130233',
                                            'MO/RMCOU/130234'
                                            )
--AND ROWNUM<10
ORDER BY MOH.MOV_ORDER_NO ASC

------------------------------Onhand Quntity------------------------------------------------
select 
(case 
          when ood.organization_code='CRT' AND subinventory_code='CRT-PUMP' then  ood.organization_code||'-'||sum(nvl(transaction_quantity,0)) 
          when ood.organization_code='RMS' and subinventory_code='RMS-CEN ST' then ood.organization_code||'-'||sum(nvl(transaction_quantity,0))
          when ood.organization_code='RTS' and subinventory_code='RTS-CEN ST' then ood.organization_code||'-'||sum(nvl(transaction_quantity,0))
end) onhand_quantity 
--,ood.*
--,onhand.*
from 
apps.mtl_onhand_quantities_detail onhand
,apps.org_organization_definitions ood
where 1=1
and ood.organization_id=onhand.organization_id
and onhand.organization_id in ('1306','1325','1327')
--and ood.organization_code='RMT'
and inventory_item_id=55605 
GROUP BY
inventory_item_id
,subinventory_code
,ood.organization_code

-----------------------------------*******--------------------------------------------------
if :xxakg_fuel_maintanance.SOURCE_ORG='SCI' then
    select   sum(nvl(transaction_quantity,0)) into :xxakg_fuel_maintanance.on_hand_quantity from  mtl_onhand_quantities_detail 
    where inventory_item_id=55605 and SUBINVENTORY_CODE='CRT-PUMP' and organization_id=1306;
elsif :xxakg_fuel_maintanance.SOURCE_ORG='RMC' then
    select   sum(nvl(transaction_quantity,0)) into :xxakg_fuel_maintanance.on_hand_quantity from  mtl_onhand_quantities_detail 
    where inventory_item_id=55605 and SUBINVENTORY_CODE='RMS-CEN ST' and organization_id=1325;
else
    select   sum(nvl(transaction_quantity,0)) into :xxakg_fuel_maintanance.on_hand_quantity from  mtl_onhand_quantities_detail 
    where inventory_item_id=55605 and SUBINVENTORY_CODE='RTS-CEN ST' and organization_id=1327;
end if;

------------------------------------------------------------------------------------------------
--XXAKG_INV_CREATE_MOVE_ORDER 

--XXAKG_INV_ALLOCATE_MOVE_ORDER

--XXAKG_INV_TRANSACT_MOVE_ORDER

-------------------------------INV_MOVE_ORDER_CREATE---------------------------------

select distinct
organization_id --into v_mov_org_id
,ou_id --into v_mov_ou
,balancing_segment  --v_into business_grp
--,org.*
from
apps.xxakg_inv_org_hierarchy org
where 1=1
and organization_code='CRT'--:xxakg_fuel_maintanance.SOURCE_ORG

--------------------------------------sub_inv_code------------------------------------------

     if p_SOURCE_ORG = 'SCI' 
      then
      l_org_id:= 1306;
      l_f_subinv_code :='CRT-PUMP';  
      l_ou_id :=82;
      l_context:='AKCL Vehicle Number';
    elsif p_SOURCE_ORG='RMC' 
    then
      l_org_id := 1325 ;
      l_f_subinv_code :='RMS-CEN ST';
      l_ou_id := 84;
      l_context:='RMC Vehicle Number';
    elsif p_source_org='RMT' 
    then
      l_org_id := 1327; 
      l_f_subinv_code := 'RTS-CEN ST' ;
      l_ou_id := 84;
      l_context:='RMC Vehicle Number';
    end if;

------------------------------------------------------------------------------------------------
select 
organization_id --into p_organization_id
,trxh.*
from
apps.mtl_txn_request_headers trxh
where request_number='MO/RMCOU/130227'--:xxakg_fuel_maintanance.move_order_no;


--------------------------------------org_id------------------------------------------

v_org_id	varchar2(100);

     if fnd_profile.value('ORG_ID') = '85' 
      then
      v_org_id:= '82';
    else 
      v_org_id := fnd_profile.value('ORG_ID') ;

------------------------------------------------------------------------------------------------
declare
    v_cost_center                                        varchar2(100);
    v_vehicle_group                                     varchar2(100);
begin

select nvl(vre_attribute16,NULL) VGROUP 
into v_vehicle_group 
from apps.pqp_vehicle_repository_f vr
    where vr.registration_number=:xxakg_fuel_maintanance.vehicle_number
    and vr.vre_attribute2=fnd_profile.value('ORG_ID')
    and vr.vehicle_status='A'
    and sysdate between vr.effective_start_date and vr.effective_end_date;
    
    if v_vehicle_group = 'Group-A' 
      then
        v_cost_center:= 'FCTRK';
    elsif v_vehicle_group = 'Group-B'
    then
        v_cost_center:= 'FCTRK';
    elsif v_vehicle_group = 'Group-C'
    then
        v_cost_center:= 'FCTRK';
    elsif v_vehicle_group = 'Group-D'
    then
        v_cost_center:= 'FCTRK';
    elsif v_vehicle_group = 'Group-E'
    then
        v_cost_center:= 'FCTRK';
    elsif v_vehicle_group = 'Others'
    then
        v_cost_center:= 'FCTRK';
    elsif v_vehicle_group is null
    then
        v_cost_center:= 'FCTRK';
    elsif v_vehicle_group = 'DISTBPNT'
    then
        v_cost_center:= 'FCTRK';
    elsif v_vehicle_group = 'Group-Bulk'
    then
        v_cost_center:= 'BULK';
    elsif v_vehicle_group = 'Group-DT'
    then
        v_cost_center:= 'CDTRK';
    end if;

end;    

