select 
--md.customer_number,
mh.mov_order_no,
TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE) invoice_date,
to_char(ool.actual_shipment_date,'MON-RR') invoice_period,
mh.mov_order_status,
(CASE 
          WHEN  ool.ordered_item='CMNT.OBAG.0004' THEN (SUM(ool.ordered_quantity)*1000)/50
            ELSE SUM(DECODE (ool.order_quantity_uom, 'MTN', ool.ordered_quantity*20,'BAG', ool.ordered_quantity))
END) "Quantity in BAG",
sum(ool.ordered_quantity) quantity,
mh.final_destination,
mh.warehouse_org_code move_wh_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice,
mh.hire_rate_ap
,mh.ap_flag
from
apps.xxakg_mov_ord_hdr mh
,apps.xxakg_mov_ord_dtl md
,apps.oe_order_lines_all ool
where 1=1
--AND TRANSPORT_MODE NOT IN ('Barge Ex factory','Ex factory truck')
AND     (:P_REGION_NAME IS NULL OR (APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (OOL.SOLD_TO_ORG_ID) = :P_REGION_NAME))
--AND APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (OOL.SOLD_TO_ORG_ID) IN ('MES')
and mh.mov_ord_hdr_id=md.mov_ord_hdr_id
and ool.shipment_priority_code=md.do_number
and ool.pricing_quantity_uom IN ('BAG','MTN')
AND     (:P_Period_YEAR IS NULL OR (to_char(ool.actual_shipment_date,'RRRR')=:P_Period_YEAR))
AND     (:P_Period_of_Month IS NULL OR (to_char(ool.actual_shipment_date,'MON-RR')=:P_Period_of_Month))
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE)<=NVL(:P_DATE_UPTO,SYSDATE)
--and ool.actual_shipment_date<='31-AUG-2018'
--and mh.ready_for_invoice='N'
--and mh.hire_rate_ap is not null 
--and mh.hire_rate_ap!='0'
AND OOL.FLOW_STATUS_CODE='CLOSED'
and mh.org_id=85
--AND mh.VEHICLE_TYPE='Owned By Company'
--AND mh.VEHICLE_NO NOT IN ('SCIL-SCM-0001','SCIL-SCM-0002','SCIL-SCM-0003','SCIL-SCM-0004')
--AND mh.VEHICLE_NO!='SCIL-SCM-0001'
--and mh.gate_out='Y'
--and mh.transport_mode='Company Bulk Carrier'
--and mh.transport_mode in ('Rental Truck','Rental Barge')
--and mh.gate_in='Y'
--and mh.warehouse_org_code='SCI'
and mh.mov_order_status='CONFIRMED'
--AND TO_CHAR (mh.gate_out_date, 'MON-RR') = 'NOV-17'
AND EXISTS (SELECT 1 FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE OOL.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID AND OOL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSI.SEGMENT1='CMNT')
AND NOT EXISTS(SELECT 1 FROM APPS.XXAKG_DISTRIBUTION_COST DC WHERE DC.MOV_ORDER_NO=mh.mov_order_no)
group by
--md.customer_number,
mh.mov_order_no,
OOL.ACTUAL_SHIPMENT_DATE,
--mh.gate_in_date,
mh.mov_order_status,
mh.final_destination,
mh.warehouse_org_code,
mh.transport_mode,
mh.gate_out,
mh.gate_in,
mh.ready_for_invoice,
mh.hire_rate_ap
,mh.ap_flag
,ool.ordered_item