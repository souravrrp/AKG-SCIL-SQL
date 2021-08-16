SELECT ORGANIZATION_ID,segment1||'.'||segment2||'.'||segment3,DESCRIPTION,planner_code,PROCESS_SUPPLY_SUBINVENTORY,PROCESS_YIELD_SUBINVENTORY,SAFETY_STOCK_BUCKET_days,MRP_SAFETY_STOCK_PERCENT,Fixed_Order_Quantity,
WIP_SUPPLY_SUBINVENTORY,Fixed_Days_Supply,Fixed_Lot_Multiplier,LEAD_TIME_LOT_SIZE
from 
 --XXAKG_ITEM_ATTRI_STG
    inv.mtl_system_items_b
where ORGANIZATION_id=99
--and USER_ITEM_TYPE= 'FG'
and PLANNER_CODE='WIPG.SPRY'
--and segment1||'.'||segment2||'.'||segment3 in ('CPAP.LOTS.0001')
