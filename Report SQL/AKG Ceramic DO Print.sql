Select
    customer_number,
    customer_name,
    'Address  :-   '||Address Address,
    'Site Address :-  '||SHIP_TO_LOCATION,
    ---- order_number,
    ---- order_date,
     do_number,
     do_status,
     mode_of_transport,
     VEHICLE_NO,
     MOV_ORDER_NO,
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
  SELECT 
        cust.customer_number,
         cust.customer_name,
         cust.ADDRESS1 || ' ' || ADDRESS2 Address,
         doh.do_number,
         TRUNC (doh.do_date) do_date,
         dol.SHIP_TO_LOCATION,
         doh.do_status,
         doh.mode_of_transport,
         MVH_AP.VEHICLE_NO,
         MVH_AP.MOV_ORDER_NO,
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
            DECODE (mc.segment11, 'WHITE', dol.line_quantity, NULL))
            white,
         SUM (
            DECODE (mc.segment11, 'IVORY', dol.line_quantity, NULL))
            Ivory,
         SUM (
            DECODE (mc.segment11, 'PINK', dol.line_quantity, NULL))
            pink,
         SUM (
            DECODE (mc.segment11, 'BLUE', dol.line_quantity, NULL))
            blue,
         SUM (
            DECODE (mc.segment11, 'GREEN', dol.line_quantity, NULL))
            green,
         SUM (
            DECODE (mc.segment11, 'RUBY RED', dol.line_quantity, NULL))
            Ruby_red,
         SUM (
            DECODE (mc.segment11, 'DEEP BLUE', dol.line_quantity, NULL))
            deep_blue, 
         SUM (
            DECODE (mc.segment11, 'YELLOW', dol.line_quantity, NULL))
            yelow,
         SUM (
            DECODE (mc.segment11, 'E', dol.line_quantity, NULL))
            Dect_white,
         SUM (
            DECODE (mc.segment11, 'F', dol.line_quantity, NULL))
            Dect_Ivory,
         SUM (
            DECODE (mc.segment11, 'ROSE PINK', dol.line_quantity, NULL))
            Rose_pink,
         SUM (CASE
                 WHEN mc.segment11 IN ('WHITE LINER',
                                       'BROWN LINER',
                                       'NA')
                 THEN
                    dol.line_quantity
                 ELSE
                    NULL
              END)
            Other
    FROM 
         apps.xxakg_del_ord_do_lines dol,
         apps.xxakg_del_ord_hdr doh,
         apps.XXAKG_MOV_ORD_HDR MVH_AP,
         apps.XXAKG_MOV_ORD_DTL MVD,
         apps.oe_order_headers_all ooh,
         apps.XXAKG_AR_CUSTOMER_SITE_V CUST,
         apps.XXAKG_DISTRIBUTOR_BLOCK_M Reg,
         inv.mtl_system_items_b msi,
         inv.mtl_item_categories mic,
         inv.mtl_categories_b mc
   WHERE     
         dol.org_id = 83
         AND doh.do_hdr_id = dol.do_hdr_id
         AND dol.order_header_id = ooh.header_id
         AND MVH_AP.MOV_ORD_HDR_ID = MVD.MOV_ORD_HDR_ID
         AND MVD.DO_HDR_ID = DOL.DO_HDR_ID
         AND ooh.org_id = cust.org_id
         AND ooh.SOLD_TO_ORG_ID = cust.customer_id
         AND cust.SITE_USE_CODE = 'BILL_TO'
         AND cust.PRIMARY_FLAG = 'Y'
         AND cust.org_id = reg.org_id(+)
         AND cust.customer_id = reg.customer_id(+)
         AND dol.ordered_item_id = msi.inventory_item_id
         AND dol.WAREHOUSE_ORG_ID = msi.organization_id
         AND doh.do_number = :p_do_number
         AND msi.inventory_item_id = mic.inventory_item_id
         AND msi.organization_id = mic.organization_id
         AND mic.category_id = mc.category_id
         AND mic.category_set_id = '1100000121'
         and mc.segment1='CERAMIC'
GROUP BY 
        cust.customer_number,
         cust.customer_name,
         cust.ADDRESS1 || ' ' || ADDRESS2,
         doh.do_number,
         doh.do_date,
         doh.do_status,
         doh.mode_of_transport,
         MVH_AP.VEHICLE_NO,
         MVH_AP.MOV_ORDER_NO,
         dol.SHIP_TO_LOCATION,
         mc.segment14,
         mc.segment4,
         mc.segment15,
         mc.segment5,
         mc.segment6,
         mc.segment12) a
group by
    ITEM_GROUP,
    ITEM_VARIETY,
    ITEM_GRADE,
    customer_number,
    customer_name,
    Address,
    SHIP_TO_LOCATION,
     ---order_number,
   --- order_date,
    do_status,
    do_number,
    mode_of_transport,
    VEHICLE_NO,
    MOV_ORDER_NO
order by ITEM_NAME        

------------------------------------***************------------------------------------

Select
    customer_number,
    customer_name,
    'Address  :-   '||Address Address,
    'Site Address :-  '||SHIP_TO_LOCATION,
    ---- order_number,
    ---- order_date,
     do_number,
     do_status,
     mode_of_transport,
     VEHICLE_NO,
     MOV_ORDER_NO,
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
    cust.customer_number,
    cust.customer_name,
    cust.ADDRESS1||' '||ADDRESS2  Address,
    ---ooh.order_number,
   --- trunc(ooh.ordered_date) order_date,
    doh.do_number,
    trunc(doh.do_date) do_date,
    dol.SHIP_TO_LOCATION,
    doh.do_status,
    doh.mode_of_transport,
     MVH_AP.VEHICLE_NO,
     MVH_AP.MOV_ORDER_NO,
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
        'ADR','Adriana',
        'Other')
        ITEM_VARIETY,
         sum( decode(substr(msi.segment2,4,1),
        'W',dol.line_quantity,
        null))
        white,
        sum(decode(substr(msi.segment2,4,1),
        'I',dol.line_quantity,
        null))
       Ivory ,
         sum(decode(substr(msi.segment2,4,1),
        'P',dol.line_quantity,
        null))
        pink,
        sum(decode(substr(msi.segment2,4,1),
        'B',dol.line_quantity,
        null))
        blue,
         sum(decode(substr(msi.segment2,4,1),
        'G',dol.line_quantity,
        null))
       green ,
         sum(decode(substr(msi.segment2,4,1),
        'R',dol.line_quantity,
        null))
       Ruby_red,
        sum( decode(substr(msi.segment2,4,1),
        'D',dol.line_quantity,
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
        'Y',dol.line_quantity,
        null))
        yelow,
        sum(decode(substr(msi.segment2,4,1),
        'E', dol.line_quantity,
        null))
        Dect_white,
        sum(decode(substr(msi.segment2,4,1),
        'F', dol.line_quantity,
        null))
        Dect_Ivory,
        sum(decode(substr(msi.segment2,4,1),
        'S', dol.line_quantity,
        null))
        Rose_pink,
       sum(case  when  substr(msi.segment2,4,1)  in(  'A',  'C', 'H','J','K','L','M','N','0', 'O','Q','T','U','V','X','Z') then dol.line_quantity else       null   end )
        Other 
from
    apps.xxakg_del_ord_do_lines dol,
    apps.xxakg_del_ord_hdr doh,
    apps.XXAKG_MOV_ORD_HDR MVH_AP,
    apps.XXAKG_MOV_ORD_DTL MVD,
    apps.oe_order_headers_all ooh,
    apps.XXAKG_AR_CUSTOMER_SITE_V CUST,
    apps.XXAKG_DISTRIBUTOR_BLOCK_M Reg,
    inv.mtl_system_items_b msi--,
--    apps.oe_order_lines_all ool
where
    dol.org_id=83
    and doh.do_hdr_id=dol.do_hdr_id
    and dol.order_header_id=ooh.header_id
    and MVH_AP.MOV_ORD_HDR_ID = MVD.MOV_ORD_HDR_ID
    AND MVD.DO_HDR_ID = DOL.DO_HDR_ID
    and ooh.org_id=cust.org_id
    and ooh.SOLD_TO_ORG_ID=cust.customer_id
    and cust.SITE_USE_CODE='BILL_TO'
    and cust.PRIMARY_FLAG='Y'
    and cust.org_id=reg.org_id(+)
    and cust.customer_id=reg.customer_id(+)
    and dol.ordered_item_id=msi.inventory_item_id
    and dol.WAREHOUSE_ORG_ID=msi.organization_id
--    and ooh.order_number=99012841
    and doh.do_number= :p_do_number
--    and dol.ITEM_number='CMDA.IMPW.0008'
--    and DO_STATUS<>'CONFIRMED'
   -- and trunc(doh.do_date) between '20-JUL-2014' and '31-JUL-2014'
    group by 
    cust.customer_number,
    cust.customer_name,
    cust.ADDRESS1||' '||ADDRESS2 ,
    ----ooh.order_number,
    ----ooh.ordered_date,
    doh.do_number,
    doh.do_date,
    doh.do_status,
    doh.mode_of_transport,
     MVH_AP.VEHICLE_NO,
     MVH_AP.MOV_ORDER_NO,
    dol.SHIP_TO_LOCATION,
    msi.segment1,
    msi.segment2
--  order by msi.segment1, msi.segment2
) a
group by
    ITEM_GROUP,
    ITEM_VARIETY,
    ITEM_GRADE,
    customer_number,
    customer_name,
    Address,
    SHIP_TO_LOCATION,
     ---order_number,
   --- order_date,
    do_status,
    do_number,
    mode_of_transport,
    VEHICLE_NO,
    MOV_ORDER_NO
order by ITEM_NAME        