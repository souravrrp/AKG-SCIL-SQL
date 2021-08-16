SELECT
*
FROM
APPS.XXAKG_QP_MODIFIER_DISCOUNT_V
WHERE 1=1
--AND MODIFIER_NAME IN ('SCIL Corporate Fixed Rate For OPC Cement',
--                                    'SCIL Corporate Fixed Rate For Special Cement', 
--                                    'SCIL Corporate Fixed Rate For Special Bulk Cement',
--                                    'SCIL Corporate Fixed Rate For Popular Cement',
--                                    'SCIL Corporate Fixed Rate For OPC Bulk Cement'
----                                    'SCIL Fixed Rate for General Customer'
----                                    'SCIL General Commission'
--                                       )
--AND PRODUCT_ATTRIBUTE_TYPE='Item Number'
AND DESC_ATTRIB_VALUE_FROM LIKE '%20482%'
AND QUALIFIER_ATTR_TYPE='Customer Name'
--AND MOD_LINE_NO='1282482'
AND END_DATE IS NULL
--AND ADJUST_RATE IS NOT NULL
--AND PRODUCT_ATTR_VALUE='CMNT.PBAG.0001 | Popular Cement'
ORDER BY START_DATE DESC


------------------------------------------------------------------------------------------------

SELECT
ORIG_ORG_ID ORG_ID
,NAME MODIFIER_NAME
,TO_CHAR(START_DATE_ACTIVE) START_DATE
FROM
APPS.QP_LIST_HEADERS_VL
WHERE 1=1
--AND NAME='SCIL Bondhujon'
AND LIST_TYPE_CODE='DLT'
AND ORIG_ORG_ID=85
AND END_DATE_ACTIVE IS NULL
AND ACTIVE_FLAG='Y'


--------------------------------------------------------------------------------


select
*
from
apps.qp_qualifiers_v
where 1=1
and LIST_HEADER_ID='372474'
and LIST_LINE_ID='1031252'
order by START_DATE_ACTIVE desc

SELECT price_adjustment_id, creation_date, header_id "Order Header",
automatic_flag "discount applied automatically",
line_id "ORDER LINE_ID",
orig_sys_discount_ref "Original discount reference",
list_header_id "Header Id of the Modifier",
list_line_id "Line id of the Modifier",
list_line_type_code "Line Type of the Modifier",
accrual_flag "adjustment is accrued", benefit_qty "Quantity accrued",
benefit_uom_code
,dis.*
FROM ont.oe_price_adjustments dis
where 1=1
--and line_id='1041834'
and LIST_LINE_ID='1041834'

SELECT price_adjustment_id,
pricing_attr_value_from "from Value pricing Attribute",
pricing_attr_value_to "To Value pricing Attribute",
comparison_operator "Operators",
flex_title "pricing_context Flex_name", price_adj_attrib_id,
lock_control
,adj_attr.*
FROM ont.oe_price_adj_attribs adj_attr;


SELECT line_id "Order Line Id", price_adjustment_id,
rltd_price_adj_id "price_adjustment_id"
,adj.*
FROM ont.oe_price_adj_assocs adj
WHERE 1=1
--AND line_id='9942447'
--and price_adjustment_id in ('7110747','7110748')

------------------------------------------------------------------------------------------------

select
*
from
APPS.QP_PRICING_ATTRIBUTES

select 
*
from
APPS.QP_QUALIFIERS
WHERE 1=1
AND QUALIFIER_ATTR_VALUE LIKE '3626'

select 
--QPA.*
QQ.*
from
APPS.QP_QUALIFIERS QQ
,APPS.QP_PRICING_ATTRIBUTES QPA
WHERE 1=1
AND QQ.LIST_HEADER_ID=QPA.LIST_HEADER_ID
AND QQ.LIST_LINE_ID=QPA.LIST_LINE_ID
AND QUALIFIER_ATTR_VALUE='3626'
AND PRODUCT_ATTR_VALUE='206571'--ITEM_ID
--AND END_DATE_ACTIVE IS NULL

        
------------------------------------------------------------------------------------------------

SELECT a.NAME "Modifier Name",
       b.list_line_no "Modifier Line No",
       a.description "Modifier Description",
       a.comments,
       b.list_line_type_code,
       d.qualifier_context,
       a.orig_org_id,
       a.active_flag,
       b.start_date_active, 
       b.end_date_active,
       a.list_type_code,
       b.modifier_level_code,
       b.organization_id,
       f.order_number,
       b.pricing_phase_id,
       b.list_line_no,
       d.header_quals_exist_flag,
       d.qualifier_datatype,
       d.qualifier_attribute,
       d.segment_id,
       d.CONTEXT,
       d.qualifier_grouping_no
  FROM APPS.qp_list_headers_all   a,
       APPS.qp_list_lines         b,
       APPS.qp_pricing_attributes c,
       APPS.qp_qualifiers         d,
       APPS.qp_qualifier_rules    qqr,
       APPS.oe_order_lines_all    e,
       APPS.oe_order_headers_all  f
 WHERE a.list_header_id = b.list_header_id
   AND b.list_header_id = c.list_header_id
   AND b.list_line_id = d.list_line_id(+)
   AND qqr.qualifier_rule_id(+) = d.created_from_rule_id
   AND e.price_list_id(+) = b.list_header_id
   AND e.header_id = f.header_id(+)
   AND b.list_line_id = c.list_line_id(+)
   AND b.pricing_phase_id > 1
--   AND a.name=:P_Price_list_name
AND ORIG_ORG_ID=85
         
------------------------------------------------------------------------------------------------
         
SELECT   l.list_line_id,
         q.qualifier_grouping_no,
         q.qualifier_id,
         q.qualifier_context,
         q.qualifier_attr_value,
         q.comparison_operator_code,
         q.qualifier_precedence,
         q.qual_attr_value_from_number,
         q.qualifier_attribute,
         q.end_date_active,
         l.end_date_active,
         h.end_date_active
  FROM   APPS.qp_list_headers_all h, APPS.qp_list_lines l, APPS.qp_qualifiers q
 WHERE       h.list_header_id = l.list_header_id
         AND h.list_header_id = q.list_header_id
         AND NVL (h.end_date_active, SYSDATE) >= SYSDATE
         AND NVL (l.end_date_active, SYSDATE) >= SYSDATE
         AND NVL (q.end_date_active, SYSDATE) >= SYSDATE;
         

------------------------------------------------------------------------------------------------

SELECT distinct qlh.comments "Modifier Name"
,qqv.rule_name "Qualifier Group"
,ou.name "Store Id"
--,qlhv.name "Price list name"
,qms.product_attr_value "SKU"
,qms.list_line_no "Modifier Line No"
,qms.start_date_active "Start Date"
,qms.end_date_active "End Date"
,qms.arithmetic_operator_type "Application Method"
,qms.operand "Value"
,qms.product_precedence "Precedence"
,qms.incompatibility_grp "Incompatibility Group"
,qms.pricing_group_sequence "Bucket"
FROM 
apps.qp_modifier_summary_v qms
, apps.qp_list_headers_b qlh
,apps.qp_list_headers_tl qlt
,apps.qp_qualifiers_v qqv 
,apps.mtl_system_items_b msi
,apps.hr_all_organization_units ou
--,qp_list_headers_v qlhv 
WHERE 
qlh.list_header_id = qms.list_header_id 
--and qms.list_header_id=qlhv.list_header_id 
and qlh.list_header_id =qqv.list_header_id 
and to_char(msi.inventory_item_id)=qms.product_attr_val
AND ou.organization_id = msi.organization_id 
and to_char(ou.organization_id)= qqv.qualifier_attr_value 
and sysdate between qms.start_date_active and qms.end_date_active 
and qlt.LIST_HEADER_ID=qlh.LIST_HEADER_ID
AND exists
(select 1
from apps.mtl_system_items_b a
where a.organization_id=85
and to_char(a.inventory_item_id)=qms.product_attr_val 
--and a.segment1 in('61054243')
)


------------------------------------------------------------------------------------------------
