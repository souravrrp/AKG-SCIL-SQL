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
