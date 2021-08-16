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
    decode(substr(msi.segment1,4,1),
        'A','A',
        'B','B',
        'C','C')
        ITEM_GRADE,
    decode(substr(msi.segment1,0,3),
        'BSN','WB Normal',
        'MBS','WB Marble',
        'CMD','WC Normal',
        'COV','Seat Cover',
        'WCL','WC Normal',
        'MCM','WC Marble',
        'WCM','WC Marble',
        'MWC','WC Marble',
        'PAN','AP Normal',
        'MPN','AP Marble',
        'PDL','PD Normal',
        'PED','PD Normal',
        'PAC','Packing Meterial',
        'MPD','PD Marble',
        'WTN','WT Normal',
        'MWT','WT Marble',
        'WTM','WT Marble',
        'LED','LD Normal',
        'LID','LD Normal',
        'MLE','LD Marble',
        'MLD','LD Marble',
        'SOA','SPC Normal',
        'MSO','SPC Marble',
        'SOP','SPC Deep Color',
        'SCO','SCVR Normal',
        'TLH','Towel Hanger Normal',
        'TLM','Towel Hanger Marble',
        'FLS','Flush Mechanism Single',
        'FLD','Flush Mechanism Dual',
        'URN', 'Urinal Normal',
        'MUR', 'Urinal Marble',
        'Other')
        ITEM_GROUP,
          decode(substr(msi.segment2,0,3),
        'ALS', 'Alisha',
        'ANG','Angelina',
        'CAS','Soap Case',
        'CRN','Crown',
        'CWM','Crown',
        'CWB','Crown Big',
        'CWN','Crown',
        'CWS','Crown Small',
        'CWW','Crown WOP',
        'DAL','Dallas',
        'DLS','Dallas',
        'ELA','Elana',
        'FLO','Flora',
        'FLS','Flora Small',
        'FLW','Flora WOP',
        'HNG','Towel Hanger',
        'IM0','Imola',
        'IMH','Imola S Type',
        'IML','Imola',
        'IMP','Imola P Type',
        'IMS','Imola S Type',
        'IMW','Imola WOP',
        'ISB', 'Isabella',
        'ISM','Isabela Medium',
        'JU0','Junior',
        'LIL','Lily',
        'LIW','Lily WOP',
        'LOT','Lotus',
        'LOW','Lotus WOP',
        'MAR','Marcela',
        'MER', 'Maria',
        'MOC','Over Counter',
        'MPT','Marcella-P Trap',
        'MRS','Marcela',
        'MRP','Marcela For Pan',
        'OC0','Over Counter',
        'OCR','Over Counter',
        'OCD','Over Counter',
        'OCS','Over Counter Small',
        'OCT','Octavia',
        'ORC','Orchid',
        'ORW','Orchid WOP',
        'OVC','Over Counter',
        'ROS','Rosella',
        'SAF','Sofia',
        'SFI','Sofia',
        'SIL','Silvana',
        'SIW','Silvana WOP',
        'SLV','Silvana',
        'SLW','Silvana WOP',
        'STL','Stella',
        'SUS' , 'Susana',
        'SMN','Simona',
        'UCR','Under Counter',
        'UNI','Universal',
        'UNW','Universal WOP',
        'VER','Verso',
        'VRB','Verso Big',
        'VRS','Verso Small',
        'LCA','Lucia',
        'VIN','Vivana',
        'VIV','Vivana',
        'Other')
        ITEM_VARIETY,
         sum( decode(substr(msi.segment2,4,1),
        'W',OOL.ORDERED_QUANTITY,
        null))
        white,
        sum(decode(substr(msi.segment2,4,1),
        'I',OOL.ORDERED_QUANTITY,
        null))
       Ivory ,
         sum(decode(substr(msi.segment2,4,1),
        'P',OOL.ORDERED_QUANTITY,
        null))
        pink,
        sum(decode(substr(msi.segment2,4,1),
        'B',OOL.ORDERED_QUANTITY,
        null))
        blue,
         sum(decode(substr(msi.segment2,4,1),
        'G',OOL.ORDERED_QUANTITY,
        null))
       green ,
         sum(decode(substr(msi.segment2,4,1),
        'R',OOL.ORDERED_QUANTITY,
        null))
       Ruby_red,
        sum( decode(substr(msi.segment2,4,1),
        'D',OOL.ORDERED_QUANTITY,
        null))
        deep_blue,/*
        sum(decode(substr(msi.segment2,4,1),
        'T',dol.line_quantity,
        null))
        rastick_blue,
        sum(decode(substr(msi.segment2,4,1),
        'K',dol.line_quantity,
        null))
        rastick_red,*/
        sum(decode(substr(msi.segment2,4,1),
        'Y',OOL.ORDERED_QUANTITY,
        null))
        yelow,
        sum(decode(substr(msi.segment2,4,1),
        'E', OOL.ORDERED_QUANTITY,
        null))
        Dect_white,
        sum(decode(substr(msi.segment2,4,1),
        'F', OOL.ORDERED_QUANTITY,
        null))
        Dect_Ivory,
        sum(decode(substr(msi.segment2,4,1),
        'S', OOL.ORDERED_QUANTITY,
        null))
        Rose_pink,
       sum(case  when  substr(msi.segment2,4,1)  in(  'A',  'C', 'H','J','K','L','M','N','0', 'O','Q','T','U','V','X','Z') then OOL.ORDERED_QUANTITY else       null   end )
        Other 
from
    APPS.OE_ORDER_HEADERS_ALL OOH,
APPS.OE_ORDER_LINES_ALL OOL,
APPS.ORG_ORGANIZATION_DEFINITIONS OOD,
    inv.mtl_system_items_b msi
where 1=1
    AND OOH.HEADER_ID=OOL.HEADER_ID
AND OOL.INVENTORY_ITEM_ID=msi.INVENTORY_ITEM_ID
AND OOL.SHIP_FROM_ORG_ID=msi.ORGANIZATION_ID
AND OOD.ORGANIZATION_ID=msi.ORGANIZATION_ID
AND OOL.FLOW_STATUS_CODE IN ('SHIPPED','CLOSED')--='AWAITING_SHIPPING'
AND OOH.FLOW_STATUS_CODE IN ('CLOSED','BOOKED')
AND OOH.ORDER_TYPE_ID=1173--1099
AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'SEP-19'
--AND TO_CHAR (DOH.OR, 'RRRR') = '2017'
AND OOH.ORG_ID=83
--    and ooh.order_number=99012841
--AND OOL.ORDERED_ITEM='INDI.HING.0001'
--AND OOL.SHIPMENT_PRIORITY_CODE=:P_SHIPMENT_PRIORITY_CODE
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
    msi.segment2
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
,LINE_NUM
order by ITEM_NAME        


--------------------------------------**************-----------------------------------

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
         mc.segment6 ||' '||decode(mc.segment12,'NA',null,mc.segment12) ITEM_VARIETY,
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
        AND TO_CHAR (OOL.ACTUAL_SHIPMENT_DATE, 'MON-RR') = 'OCT-19'
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
         mc.segment12
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
,LINE_NUM
order by ITEM_NAME        

