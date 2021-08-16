Item Name: CAPACITY

Prompt: Load Capacity

Canvas: XXAKG_CAN

Block: XXAKG_DEL_ORD_HDR

Database Column Name: VEHICLE_LOAD_CAPACITY

Trigger Name: WHEN-NEW-ITEM-INSTANCE

Trigger Condition : 
if :XXAKG_DEL_ORD_HDR.DO_STATUS_MIR IN ('GENERATED','NEW') then
	 set_item_property('XXAKG_DEL_ORD_HDR.CAPACITY' , insert_allowed, property_true);
	 set_item_property('XXAKG_DEL_ORD_HDR.CAPACITY' , update_allowed, property_true);
 elsif :XXAKG_DEL_ORD_HDR.DO_STATUS_MIR IN ('CONFIRMED','CANCELLED') then
     set_item_property('XXAKG_DEL_ORD_HDR.CAPACITY' , insert_allowed, property_false);
	 set_item_property('XXAKG_DEL_ORD_HDR.CAPACITY' , update_allowed, property_false);
end if;	 

----------------------------******----------------------------------------------
if :XXAKG_DEL_ORD_HDR.DO_STATUS_MIR IN ('GENERATED','NEW') then
	 set_item_property('XXAKG_DEL_ORD_HDR.CAPACITY' , insert_allowed, property_true);
	 set_item_property('XXAKG_DEL_ORD_HDR.CAPACITY' , update_allowed, property_true);
 elsif :XXAKG_DEL_ORD_HDR.DO_STATUS_MIR IS NOT NULL or :XXAKG_DEL_ORD_HDR.DO_STATUS_MIR IN ('CONFIRMED','CANCELLED') then
     set_item_property('XXAKG_DEL_ORD_HDR.CAPACITY' , insert_allowed, property_false);
	 set_item_property('XXAKG_DEL_ORD_HDR.CAPACITY' , update_allowed, property_false);
end if;	 


LOV Name: LOV_VEHICLE_LOAD_CAPACITY

Record Group: RG_VEHICLE_LOAD_CAPACITY

Record Group Type: Query

Record Group Query:

SELECT
MEANING
FROM
APPS.FND_LOOKUP_VALUES
WHERE LOOKUP_TYPE='XXAKG_DO_VEHICLE_LOAD_CAPACITY'

-----------------------------------------------------------------

SELECT 
MEANING
FROM
APPS.FND_LOOKUP_VALUES
WHERE LOOKUP_TYPE='XXAKG_DO_VEHICLE_LOAD_CAPACITY'
AND ENABLED_FLAG='Y'
AND TRUNC(SYSDATE) BETWEEN NVL(START_DATE_ACTIVE,TRUNC(SYSDATE)) AND NVL(END_DATE_ACTIVE,SYSDATE)

if :XXAKG_DEL_ORD_HDR.DO_STATUS_MIR IN ('GENERATED','NEW') then
	 set_item_instance_property('XXAKG_DEL_ORD_HDR.CAPACITY' , current_record, insert_allowed, property_true);
	 set_item_instance_property('XXAKG_DEL_ORD_HDR.CAPACITY' , current_record, update_allowed, property_true);
 elsif :XXAKG_DEL_ORD_HDR.DO_STATUS_MIR IN ('CONFIRMED','CANCELLED') then
     set_item_instance_property('XXAKG_DEL_ORD_HDR.CAPACITY' , current_record, insert_allowed, property_false);
	 set_item_instance_property('XXAKG_DEL_ORD_HDR.CAPACITY' , current_record, update_allowed, property_false);
end if;	 
