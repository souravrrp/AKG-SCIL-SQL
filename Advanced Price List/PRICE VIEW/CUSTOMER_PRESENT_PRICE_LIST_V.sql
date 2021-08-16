SELECT 
DESC_ATTRIB_VALUE_FROM "Customer ID-Name"
,substr(PRODUCT_ATTR_VALUE,1,instr(PRODUCT_ATTR_VALUE,'|',1,1)-1) Item_Code
,substr(PRODUCT_ATTR_VALUE,+18,instr(PRODUCT_ATTR_VALUE,'|',1,1)+15) Item_Description
,ADJUST_RATE Rate
--,substr(PRODUCT_ATTR_VALUE,1,instr(PRODUCT_ATTR_VALUE,'|',1,1)-1) Item_Code
--,substr(DESC_ATTRIB_VALUE_FROM,1,instr(DESC_ATTRIB_VALUE_FROM,'-',1,1)-1) Customer_number
--,SUBSTR (desc_attrib_value_from,1,INSTR (desc_attrib_value_from,'-')- 2) Customer_No
--,SUBSTR (desc_attrib_value_from,1,INSTR ('-',desc_attrib_value_from)+6) Customer_NO_NEW
   /* ,(CASE WHEN INSTR(desc_attrib_value_from, '-') > 0
        THEN substr(desc_attrib_value_from, 1, instr(desc_attrib_value_from, '-') -1)
        ELSE desc_attrib_value_from
    END) AS CUST_NAME_CASE
,(instr(DESC_ATTRIB_VALUE_FROM,'-',1,1)-1) Customer_name*/
--,(INSTR (desc_attrib_value_from,'-')- 2)  CUST_NAME
--,(INSTR ('-',desc_attrib_value_from)+6) Customer_NAME_N
/*,(CASE WHEN INSTR(desc_attrib_value_from, '-') > 0
        THEN substr(desc_attrib_value_from, 1, instr(desc_attrib_value_from, '-') -1)
        ELSE desc_attrib_value_from
    END) AS CUST_NO_NEW*/
FROM apps.xxakg_qp_modifier_discount_v a,
(SELECT DISTINCT mod_line_no, group_no
FROM apps.xxakg_qp_modifier_discount_v
WHERE 1=1 
AND modifier_name IN ('SCIL Corporate Fixed Rate For OPC Cement'
                                        ,'SCIL Corporate Fixed Rate For Special Cement'
                                        ,'SCIL Corporate Fixed Rate For OPC Bulk Cement'
                                        ,'SCIL Corporate Fixed Rate For Popular Cement'
                                        ,'SCIL Corporate Fixed Rate For Special Bulk Cement')
AND qualifier_attr_type IN ('Customer Name') 
AND DECODE (
qualifier_attr_type,
'Customer Name', SUBSTR (desc_attrib_value_from,1,INSTR (desc_attrib_value_from,'-')- 2)) IN ( SELECT ACSV.CUSTOMER_NUMBER FROM APPS.XXAKG_AR_CUSTOMER_SITE_V ACSV, APPS.XXAKG_DISTRIBUTOR_BLOCK_M DBM WHERE  ACSV.CUSTOMER_NUMBER=DBM.CUSTOMER_NUMBER AND DBM.REGION_NAME IN ('Corporate North','Corporate South','Institutional','MES')) 
) x
WHERE a.mod_line_no=x.mod_line_no
and a.group_no=x.group_no
and END_DATE is null
AND modifier_name IN ('SCIL Corporate Fixed Rate For OPC Cement'
                                        ,'SCIL Corporate Fixed Rate For Special Cement'
                                        ,'SCIL Corporate Fixed Rate For OPC Bulk Cement'
                                        ,'SCIL Corporate Fixed Rate For Popular Cement'
                                        ,'SCIL Corporate Fixed Rate For Special Bulk Cement')
                                        
                                        
                                        
select * from
apps.xxakg_qp_modifier_discount_v a
where 1=1
and exists (select 1 from apps.qp_list_headers_tl t,apps.qp_list_headers_b b where t.list_header_id=b.list_header_id and t.name=a.modifier_name and b.orig_org_id=85)
--and upper(modifier_name) like 'SC%CORP%'
and source !='Header' 
and end_date is null
and automatic_flag='Y'
and accrual_flag='N'



                                        
                                        
                                        
select * from
apps.xxakg_qp_modifier_discount_v a
where 1=1
and exists (select 1 from apps.qp_list_headers_tl t,apps.qp_list_headers_b b where t.list_header_id=b.list_header_id and t.name=a.modifier_name and b.orig_org_id=85)
--and upper(modifier_name) like 'SC%CORP%'
and source !='Header' 
and end_date is null
and automatic_flag='Y'
and accrual_flag='N'
