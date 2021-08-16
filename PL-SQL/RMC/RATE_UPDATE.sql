SELECT 
a.MODIFIER_NAME
,a.PRODUCT_ATTR_VALUE Item
,a.MOD_LINE_NO
,a.GROUP_NO
,x.DESC_ATTRIB_VALUE_FROM Customer_Name
,a.DESC_ATTRIB_VALUE_FROM Price_Location
,a.ADJUST_RATE
,a.START_DATE
,a.END_DATE
--,substr(DESC_ATTRIB_VALUE_FROM,+22,instr(DESC_ATTRIB_VALUE_FROM,1,1)+13) FINAL_DESTINATION
--,substr(PRODUCT_ATTR_VALUE,1,instr(PRODUCT_ATTR_VALUE,'|',1,1)-1) item_code
--,a.*
FROM apps.xxakg_qp_modifier_discount_v a,
apps.xxakg_qp_modifier_discount_v x
WHERE 1=1 
AND a.modifier_name IN ('RMC Price Discount','RMC Over Sales Price')
AND x.qualifier_attr_type IN ('Customer Name') 
AND a.qualifier_attr_type IN ('Price List') 
AND DECODE (x.qualifier_attr_type,'Customer Name', SUBSTR (x.desc_attrib_value_from,1,INSTR (x.desc_attrib_value_from,'-')- 2)) IN (&p_cust_num)
and a.mod_line_no=x.mod_line_no
and a.group_no=x.group_no
AND a.END_DATE IS NULL
AND SUBSTR(a.PRODUCT_ATTR_VALUE,1,INSTR(a.PRODUCT_ATTR_VALUE,'|',1,1)-1) LIKE ('%'||:P_ITEM_CODE||'%') 
AND a.DESC_ATTRIB_VALUE_FROM like ('%'||:p_Location||'%') 

--=====================
--RMC Price Discount
--====================
select 
distinct modifier_name,product_attribute_type,product_attr_value,mod_line_no,adjust_rate,arithmetic_operator,source,list_line_type,automatic_flag
from
apps.xxakg_qp_modifier_discount_v
where modifier_name='RMC Price Discount'
and product_attribute_type='Item Number'
and substr(product_attr_value,1,14) = :p_item_numbers
and adjust_rate=nvl(:p_adj_rate,adjust_rate)


--======================
--RMC Over Sales Price
--======================
select 
distinct modifier_name,product_attribute_type,product_attr_value,mod_line_no,adjust_rate,arithmetic_operator,source,list_line_type,automatic_flag
from
apps.xxakg_qp_modifier_discount_v
where modifier_name='RMC Over Sales Price'
and product_attribute_type='Item Number'
and substr(product_attr_value,1,14) = :p_item_numbers
and adjust_rate=nvl(:p_adj_rate,adjust_rate)


---=======
--Up To Date RMC Rate
---=======
SELECT 
MODIFIER_NAME
,PRODUCT_ATTR_VALUE
,a.MOD_LINE_NO
,a.GROUP_NO qualifier_group
,DESC_ATTRIB_VALUE_FROM
,ADJUST_RATE
,START_DATE
,END_DATE
--,substr(DESC_ATTRIB_VALUE_FROM,+22,instr(DESC_ATTRIB_VALUE_FROM,1,1)+13) FINAL_DESTINATION
--,substr(PRODUCT_ATTR_VALUE,1,instr(PRODUCT_ATTR_VALUE,'|',1,1)-1) item_code
--,a.*
FROM apps.xxakg_qp_modifier_discount_v a,
(SELECT DISTINCT mod_line_no, group_no
FROM apps.xxakg_qp_modifier_discount_v
WHERE 1=1 
AND modifier_name IN ('RMC Price Discount','RMC Over Sales Price')
AND qualifier_attr_type IN ('Customer Name') 
AND DECODE (
qualifier_attr_type,
'Customer Name', SUBSTR (desc_attrib_value_from,1,INSTR (desc_attrib_value_from,'-')- 2)) IN (&p_cust_num) 
) x
WHERE a.mod_line_no=x.mod_line_no
and a.group_no=x.group_no
AND modifier_name IN ('RMC Price Discount','RMC Over Sales Price')
AND END_DATE IS NULL
AND SUBSTR(PRODUCT_ATTR_VALUE,1,INSTR(PRODUCT_ATTR_VALUE,'|',1,1)-1) LIKE ('%'||:P_ITEM_CODE||'%') 
AND DESC_ATTRIB_VALUE_FROM like ('%'||:p_Location||'%') --AKG RMC Price List To


------------------------------------------------------------------------------------------------

SELECT *
FROM apps.xxakg_qp_modifier_discount_v a,
(SELECT DISTINCT mod_line_no, group_no
FROM apps.xxakg_qp_modifier_discount_v
WHERE 1=1 
AND modifier_name IN ('RMC Price Discount','RMC Over Sales Price')
AND qualifier_attr_type IN ('Customer Name') 
AND DECODE (
qualifier_attr_type,
'Customer Name', SUBSTR (desc_attrib_value_from,1,INSTR (desc_attrib_value_from,'-')- 2)) IN (&p_cust_num) 
) x
WHERE a.mod_line_no=x.mod_line_no
and a.group_no=x.group_no
AND modifier_name IN ('RMC Price Discount','RMC Over Sales Price')
AND a.END_DATE IS NULL
AND SUBSTR(a.PRODUCT_ATTR_VALUE,1,INSTR(a.PRODUCT_ATTR_VALUE,'|',1,1)-1) LIKE ('%'||:P_ITEM_CODE||'%') 
AND a.DESC_ATTRIB_VALUE_FROM like ('%'||:p_Location||'%') 
