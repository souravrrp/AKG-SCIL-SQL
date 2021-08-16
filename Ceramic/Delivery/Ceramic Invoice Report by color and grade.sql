SELECT
--TO_CHAR(OOL.ACTUAL_SHIPMENT_DATE,'DD-MON-YYYY HH24:MI:SS') INVOICE_DATE,
OOL.ACTUAL_SHIPMENT_DATE INVOICE_DATE,
--MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
MSI.DESCRIPTION PRODUCT,
--NVL(MC.SEGMENT4,'NA') PRODUCT_TYPE,
NVL(MC.SEGMENT11,'NA') COLOR,
NVL(MC.SEGMENT14,'NA') GRADE,
--OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
SUM(OOL.ORDERED_QUANTITY) DO_QUANTITY
--,MC.*
--MSI.*
--MIC.*
FROM
INV.MTL_SYSTEM_ITEMS_B MSI
,INV.MTL_ITEM_CATEGORIES MIC
,INV.MTL_CATEGORIES_B MC
,APPS.MTL_CATEGORY_SETS MCS
,APPS.OE_ORDER_LINES_ALL OOL
WHERE 1=1
AND OOL.ORG_ID=83
--AND OOL.SHIPMENT_PRIORITY_CODE IN ('DO/COU/110391')
AND OOL.ORDERED_ITEM_ID = MSI.INVENTORY_ITEM_ID
AND OOL.SHIP_FROM_ORG_ID = MSI.ORGANIZATION_ID
AND MIC.CATEGORY_SET_ID=MCS.CATEGORY_SET_ID
AND MIC.CATEGORY_ID=MC.CATEGORY_ID
AND MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID
AND MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID
--AND MSI.ORGANIZATION_ID=99
AND MCS.CATEGORY_SET_NAME='Product Categories'
AND MC.SEGMENT1='CERAMIC'
AND OOL.FLOW_STATUS_CODE IN ('SHIPPED','CLOSED')--='AWAITING_SHIPPING'
AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE) BETWEEN NVL(:P_INVOICE_DATE_FROM,TRUNC(OOL.ACTUAL_SHIPMENT_DATE)) AND NVL(:P_INVOICE_DATE_TO,TRUNC(OOL.ACTUAL_SHIPMENT_DATE))
--AND MIC.SEGMENT2='FINISH GOODS'
--AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.SFII.0001')
GROUP BY
OOL.ACTUAL_SHIPMENT_DATE,
--MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
MSI.DESCRIPTION,
--NVL(MC.SEGMENT4,'NA') PRODUCT_TYPE,
NVL(MC.SEGMENT11,'NA'),
NVL(MC.SEGMENT14,'NA')
--OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,


--------------------------------------------------------------------------------
Select
LINE_NUM,
    ORDER_NUMBER,
ITEM_CODE,
ITEM_DESCRIPTION,
QUANTITY,
UOM,
DO_NUMBER,
ORDERED_DATE,
ORGANIZATION_CODE,
UNIT_SELLING_PRICE,
AMOUNT,
INVOICE_DATE,
    ITEM_GROUP||' '|| ITEM_VARIETY ITEM_NAME,
    ITEM_GROUP,
    ITEM_VARIETY,
    ITEM_GRADE,
    COLOR,
    sum(white) white,
    sum(Ivory) Ivory,
    sum(pink) pink,
    sum(blue) blue,
    sum(green) green,
    sum(Ruby_red) Ruby_red,
    sum(deep_blue) deep_blue,
--    sum(rastick_blue) rastick_blue,
--    sum(Rastick_Red) rastick_red,
    sum(yelow)Yelow,
    sum(Dect_white) Dect_white,
    sum(Dect_Ivory) Dect_Ivory,
    sum(Rose_pink)Rose_pink,
    sum(Other) other
from (    
select
OOL.LINE_ID LINE_NUM,
    OOH.ORDER_NUMBER,
OOL.ORDERED_ITEM ITEM_CODE,
msi.DESCRIPTION ITEM_DESCRIPTION,
SUM(OOL.ORDERED_QUANTITY) QUANTITY,
OOL.ORDER_QUANTITY_UOM UOM,
OOL.SHIPMENT_PRIORITY_CODE DO_NUMBER,
TO_CHAR(OOH.ORDERED_DATE)ORDERED_DATE,
OOD.ORGANIZATION_CODE,
OOL.UNIT_SELLING_PRICE,
(OOL.UNIT_SELLING_PRICE*SUM(OOL.ORDERED_QUANTITY)) AMOUNT,
TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE) INVOICE_DATE,
    decode(mc.segment14,'NA',null,mc.segment14) ITEM_GRADE,
         decode(mc.segment5,
         'PACKED',
          DECODE(mc.segment4,
          'ASIAN PAN','AP',
          'PEDESTAL','PD',
          'WATER TANK','WT',
          'WATER CLOSET','WC',
          'URINAL','URINAL',
          'WASH BASIN','WB',
          mc.segment4),
          mc.segment5) ||' '|| decode(mc.segment15,'NA',null,mc.segment15) ITEM_GROUP,
         mc.segment6 ||' '||decode(mc.segment12,'NA',null,mc.segment12) ITEM_VARIETY, mc.segment11 COLOR,
            SUM (
            DECODE (mc.segment11, 'WHITE', ool.ordered_quantity, NULL))
            white,
         SUM (
            DECODE (mc.segment11, 'IVORY', ool.ordered_quantity, NULL))
            Ivory,
         SUM (
            DECODE (mc.segment11, 'PINK', ool.ordered_quantity, NULL))
            pink,
         SUM (
            DECODE (mc.segment11, 'BLUE', ool.ordered_quantity, NULL))
            blue,
         SUM (
            DECODE (mc.segment11, 'GREEN', ool.ordered_quantity, NULL))
            green,
         SUM (
            DECODE (mc.segment11, 'RUBY RED', ool.ordered_quantity, NULL))
            Ruby_red,
         SUM (
            DECODE (mc.segment11, 'DEEP BLUE', ool.ordered_quantity, NULL))
            deep_blue, 
         SUM (
            DECODE (mc.segment11, 'YELLOW', ool.ordered_quantity, NULL))
            yelow,
         SUM (
            DECODE (mc.segment11, 'E', ool.ordered_quantity, NULL))
            Dect_white,
         SUM (
            DECODE (mc.segment11, 'F', ool.ordered_quantity, NULL))
            Dect_Ivory,
         SUM (
            DECODE (mc.segment11, 'ROSE PINK', ool.ordered_quantity, NULL))
            Rose_pink,
         SUM (CASE
                 WHEN mc.segment11 IN ('WHITE LINER',
                                       'BROWN LINER',
                                       'NA')
                 THEN
                    ool.ordered_quantity
                 ELSE
                    NULL
              END)
            Other
from
    APPS.OE_ORDER_HEADERS_ALL OOH,
    APPS.OE_ORDER_LINES_ALL OOL,
    APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
    inv.mtl_item_categories mic,
    inv.mtl_categories_b mc,
    inv.mtl_system_items_b msi
--    apps.xxakg_del_ord_do_lines dol,
--    apps.xxakg_del_ord_hdr doh,
--    apps.XXAKG_MOV_ORD_HDR MVH_AP,
--    apps.XXAKG_MOV_ORD_DTL MVD,
--    apps.oe_order_headers_all ooh,
--    apps.XXAKG_AR_CUSTOMER_SITE_V CUST,
--    apps.XXAKG_DISTRIBUTOR_BLOCK_M Reg,
--    inv.mtl_system_items_b msi
where 1=1
        AND OOH.HEADER_ID=OOL.HEADER_ID
        AND OOL.INVENTORY_ITEM_ID=msi.INVENTORY_ITEM_ID
        AND OOL.SHIP_FROM_ORG_ID=msi.ORGANIZATION_ID
        AND OOD.ORGANIZATION_ID=msi.ORGANIZATION_ID
        AND OOL.FLOW_STATUS_CODE IN ('SHIPPED','CLOSED')--='AWAITING_SHIPPING'
        AND OOH.FLOW_STATUS_CODE IN ('CLOSED','BOOKED')
        AND OOH.ORDER_TYPE_ID=1173--1099
        --AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'JUL-19'
        AND TRUNC(OOL.ACTUAL_SHIPMENT_DATE) BETWEEN NVL(:P_INVOICE_DATE_FROM,TRUNC(OOL.ACTUAL_SHIPMENT_DATE)) AND NVL(:P_INVOICE_DATE_TO,TRUNC(OOL.ACTUAL_SHIPMENT_DATE))
        --AND TO_CHAR (DOH.OR, 'RRRR') = '2017'
        AND OOH.ORG_ID=83
        AND msi.inventory_item_id = mic.inventory_item_id
         AND msi.organization_id = mic.organization_id
         AND mic.category_id = mc.category_id
--         AND mic.category_set_id = '1100000121'
         and mc.segment1='CERAMIC'
--    and ooh.order_number=99012841
--AND OOL.ORDERED_ITEM='INDI.HING.0001'
--AND OOL.SHIPMENT_PRIORITY_CODE='DO/COU/96402'   --:P_SHIPMENT_PRIORITY_CODE
--    and dol.ITEM_number='CMDA.IMPW.0008'
--    and DO_STATUS<>'CONFIRMED'
   -- and trunc(doh.do_date) between '20-JUL-2014' and '31-JUL-2014'
    group by 
    OOL.LINE_ID,
    OOH.ORDER_NUMBER,
OOL.ORDERED_ITEM,
msi.DESCRIPTION,
OOL.ORDER_QUANTITY_UOM,
OOL.SHIPMENT_PRIORITY_CODE ,
OOH.ORDERED_DATE,
OOD.ORGANIZATION_CODE,
OOL.UNIT_SELLING_PRICE,
OOL.UNIT_SELLING_PRICE*OOL.ORDERED_QUANTITY
,OOL.ACTUAL_SHIPMENT_DATE,
    msi.segment1,
    msi.segment2,
    mc.segment14,
         mc.segment4,
         mc.segment15,
         mc.segment5,
         mc.segment6,
         mc.segment12,mc.segment11
--  order by msi.segment1, msi.segment2
) a
group by
    ITEM_GROUP,
    ITEM_VARIETY,
    ITEM_GRADE,
      ORDER_NUMBER,
ITEM_CODE,
ITEM_DESCRIPTION,
QUANTITY,
UOM,
DO_NUMBER,
ORDERED_DATE,
ORGANIZATION_CODE,
UNIT_SELLING_PRICE,
AMOUNT,
INVOICE_DATE
,LINE_NUM,COLOR
order by ITEM_NAME        

