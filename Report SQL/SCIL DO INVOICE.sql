SELECT 
DO.CUSTOMER_NUMBER,SR.FULL_NAME ,
DO.DO_NUMBER,DO.CUSTOMER_NAME,DO_DATE,
DL.ORDER_NUMBER,DL.ITEM_NUMBER,DL.ITEM_DESCRIPTION, DL.LINE_QUANTITY,DL.UOM_CODE
,SL.UNIT_list_PRICE UNIT_selling_PRICE
,case when oh.ordered_date>=to_date('01/01/2015','dd/mm/yyyy') then to_char(sl.unit_list_price-sl.unit_selling_price) else nvl(decode(sl.CONTEXT,'AKG Domestic Order Line',SL.ATTRIBUTE4),0) end ATTRIBUTE4 
,case when oh.ordered_date>=to_date('01/01/2015','dd/mm/yyyy') then SL.UNIT_SELLING_PRICE else SL.UNIT_SELLING_PRICE-NVL(SL.ATTRIBUTE4,0) end ACCTUAL_VALUE
,case when oh.ordered_date>=to_date('01/01/2015','dd/mm/yyyy') then SL.UNIT_SELLING_PRICE*SL.SHIPPED_QUANTITY else (SL.UNIT_SELLING_PRICE-NVL(SL.ATTRIBUTE4,0))*SL.SHIPPED_QUANTITY end NET_PRICE
,SL.REQUEST_DATE
,NVL(DT.CHALLAN_NO,MOVH.GATE_PASS_NO) GATE_PASS_NO,DT.VAT_CHALLAN_NO "CHALAN NO",DT.VAT_CHALLAN_DATE,SL.SHIPPED_QUANTITY ,
LTRIM(RTRIM(DL.SHIP_TO_LOCATION)),HP.ADDRESS1||' '||HP.ADDRESS2||' '||HP.ADDRESS3 ADDRESS,
CUST.ATTENTION 
,SUBSTR(DU.NAME,1,3) DUE_PAYMENT, 
CASE DU.NAME WHEN 'IMMEDIATE' THEN 'IMMEDIATE' ELSE SUBSTR(DU.NAME,1,3) END DO_TIME ,
case 
WHEN LENGTH(OH.cust_po_number) >2
THEN SUBSTR( OH.cust_po_number, (TO_NUMBER(LENGTH(OH.cust_po_number))-TO_NUMBER(LENGTH('01-JAN-2013')))+1, LENGTH(OH.cust_po_number) )
ELSE
NULL
END AS PO_DATE
,CASE
WHEN LENGTH(OH.cust_po_number) >2
THEN SUBSTR( OH.cust_po_number,1, (TO_NUMBER(LENGTH(OH.cust_po_number))-TO_NUMBER(LENGTH('01-JAN-2013')))-1 )
ELSE
NULL
END AS PO_NUMBER
FROM 
APPS.oe_order_headers_all OH,
APPS.XXAKG_DEL_ORD_HDR DO,
APPS.XXAKG_DEL_ORD_DO_LINES DL,
APPS.OE_ORDER_LINES_ALL SL,
APPS.XXAKG_MOV_ORD_HDR MOVH,
XXAKG.XXAKG_MOV_ORD_DTL DT,
apps.HZ_PARTIES PT,
apps.HZ_CUST_ACCOUNTS CT,
apps. hz_parties HP,
APPS.RA_TERMS_VL DU ,
-- apps.hz_relationships REL_CUST,
(SELECT A.PERSON_ID, A.FULL_NAME 
FROM 
APPS.PER_ALL_PEOPLE_F A
WHERE EFFECTIVE_END_DATE = (SELECT MAX(EFFECTIVE_END_DATE) FROM APPS.PER_ALL_PEOPLE_F WHERE PERSON_ID=A.PERSON_ID)) SR,
(select distinct invoice_rel.OBJECT_ID,invoice_rel.SUBJECT_ID ,LTRIM(RTRIM(invoice_party.PERSON_FIRST_NAME))||' '||LTRIM(RTRIM(invoice_party.PERSON_MIDDLE_NAME))||' '||LTRIM(RTRIM(invoice_party.PERSON_LAST_NAME)) ATTENTION
from
apps.hz_relationships invoice_rel,
apps.HZ_PARTIES invoice_party,
apps.hz_cust_accounts invoice_acct,
apps.hz_cust_account_roles invoice_roles
where invoice_party.PARTY_ID=invoice_rel.SUBJECT_ID
and invoice_roles.CURRENT_ROLE_STATE='A' 
---and rownum=1
and NVL (invoice_rel.object_id, -1) =NVL (invoice_acct.party_id, -1)
AND invoice_roles.party_id = invoice_rel.party_id(+)) CUST
WHERE 
SL.ATTRIBUTE14=SR.PERSON_ID(+)
AND OH.HEADER_ID=SL.HEADER_ID 
AND DO.DO_HDR_ID = DL.DO_HDR_ID
AND DL.ORDER_HEADER_ID = SL.HEADER_ID
AND SL.LINE_ID=DL.ORDER_LINE_ID
and do.DO_NUMBER=DT.DO_NUMBER
AND DT.MOV_ORD_HDR_ID=MOVH.MOV_ORD_HDR_ID
AND CT.ACCOUNT_NUMBER=DO.CUSTOMER_NUMBER --6,331
AND HP.PARTY_ID = CT.PARTY_ID
AND PT.PARTY_ID=HP.PARTY_ID
AND DU.TERM_ID=OH.PAYMENT_TERM_ID
AND CT.PARTY_ID=CUST.OBJECT_ID(+)
AND DO.DO_STATUS='CONFIRMED'
-- AND PT.PARTY_ID=REL_CUST.SUBJECT_ID
AND DO.DO_NUMBER=:P_DO_NUMBER
AND OH.ORG_ID=85
-- AND DO.DO_STATUS !='CANCELLED'
AND SL.SHIPPED_QUANTITY !=0


-----------------------------------------------**********Old********--------------------

SELECT 
DO.CUSTOMER_NUMBER,SR.FULL_NAME ,
DO.DO_NUMBER,DO.CUSTOMER_NAME,DO_DATE,
DL.ORDER_NUMBER,DL.ITEM_NUMBER,DL.ITEM_DESCRIPTION, DL.LINE_QUANTITY,DL.UOM_CODE
,SL.UNIT_list_PRICE UNIT_selling_PRICE
,case when oh.ordered_date>=to_date('01/01/2015','dd/mm/yyyy') then to_char(sl.unit_list_price-sl.unit_selling_price) else nvl(decode(sl.CONTEXT,'AKG Domestic Order Line',SL.ATTRIBUTE4),0) end ATTRIBUTE4 
,case when oh.ordered_date>=to_date('01/01/2015','dd/mm/yyyy') then SL.UNIT_SELLING_PRICE else SL.UNIT_SELLING_PRICE-NVL(SL.ATTRIBUTE4,0) end ACCTUAL_VALUE
,case when oh.ordered_date>=to_date('01/01/2015','dd/mm/yyyy') then SL.UNIT_SELLING_PRICE*SL.SHIPPED_QUANTITY else (SL.UNIT_SELLING_PRICE-NVL(SL.ATTRIBUTE4,0))*SL.SHIPPED_QUANTITY end NET_PRICE
,SL.REQUEST_DATE
,MOVH.GATE_PASS_NO,DT.VAT_CHALLAN_NO "CHALAN NO",DT.VAT_CHALLAN_DATE,SL.SHIPPED_QUANTITY ,
LTRIM(RTRIM(DL.SHIP_TO_LOCATION)),HP.ADDRESS1||' '||HP.ADDRESS2||' '||HP.ADDRESS3 ADDRESS,
CUST.ATTENTION 
,SUBSTR(DU.NAME,1,3) DUE_PAYMENT, 
CASE DU.NAME WHEN 'IMMEDIATE' THEN 'IMMEDIATE' ELSE SUBSTR(DU.NAME,1,3) END DO_TIME ,
case 
WHEN LENGTH(OH.cust_po_number) >2
THEN SUBSTR( OH.cust_po_number, (TO_NUMBER(LENGTH(OH.cust_po_number))-TO_NUMBER(LENGTH('01-JAN-2013')))+1, LENGTH(OH.cust_po_number) )
ELSE
NULL
END AS PO_DATE
,CASE
WHEN LENGTH(OH.cust_po_number) >2
THEN SUBSTR( OH.cust_po_number,1, (TO_NUMBER(LENGTH(OH.cust_po_number))-TO_NUMBER(LENGTH('01-JAN-2013')))-1 )
ELSE
NULL
END AS PO_NUMBER
FROM 
APPS.oe_order_headers_all OH,
APPS.XXAKG_DEL_ORD_HDR DO,
APPS.XXAKG_DEL_ORD_DO_LINES DL,
APPS.OE_ORDER_LINES_ALL SL,
APPS.XXAKG_MOV_ORD_HDR MOVH,
XXAKG.XXAKG_MOV_ORD_DTL DT,
apps.HZ_PARTIES PT,
apps.HZ_CUST_ACCOUNTS CT,
apps. hz_parties HP,
APPS.RA_TERMS_VL DU ,
-- apps.hz_relationships REL_CUST,
(SELECT A.PERSON_ID, A.FULL_NAME 
FROM 
APPS.PER_ALL_PEOPLE_F A
WHERE EFFECTIVE_END_DATE = (SELECT MAX(EFFECTIVE_END_DATE) FROM APPS.PER_ALL_PEOPLE_F WHERE PERSON_ID=A.PERSON_ID)) SR,
(select distinct invoice_rel.OBJECT_ID,invoice_rel.SUBJECT_ID ,LTRIM(RTRIM(invoice_party.PERSON_FIRST_NAME))||' '||LTRIM(RTRIM(invoice_party.PERSON_MIDDLE_NAME))||' '||LTRIM(RTRIM(invoice_party.PERSON_LAST_NAME)) ATTENTION
from
apps.hz_relationships invoice_rel,
apps.HZ_PARTIES invoice_party,
apps.hz_cust_accounts invoice_acct,
apps.hz_cust_account_roles invoice_roles
where invoice_party.PARTY_ID=invoice_rel.SUBJECT_ID
and invoice_roles.CURRENT_ROLE_STATE='A' 
---and rownum=1
and NVL (invoice_rel.object_id, -1) =NVL (invoice_acct.party_id, -1)
AND invoice_roles.party_id = invoice_rel.party_id(+)) CUST
WHERE 
SL.ATTRIBUTE14=SR.PERSON_ID(+)
AND OH.HEADER_ID=SL.HEADER_ID 
AND DO.DO_HDR_ID = DL.DO_HDR_ID
AND DL.ORDER_HEADER_ID = SL.HEADER_ID
AND SL.LINE_ID=DL.ORDER_LINE_ID
and do.DO_NUMBER=DT.DO_NUMBER
AND DT.MOV_ORD_HDR_ID=MOVH.MOV_ORD_HDR_ID
AND CT.ACCOUNT_NUMBER=DO.CUSTOMER_NUMBER --6,331
AND HP.PARTY_ID = CT.PARTY_ID
AND PT.PARTY_ID=HP.PARTY_ID
AND DU.TERM_ID=OH.PAYMENT_TERM_ID
AND CT.PARTY_ID=CUST.OBJECT_ID(+)
AND DO.DO_STATUS='CONFIRMED'
-- AND PT.PARTY_ID=REL_CUST.SUBJECT_ID
AND DO.DO_NUMBER=:P_DO_NUMBER
AND OH.ORG_ID=85
-- AND DO.DO_STATUS !='CANCELLED'
AND SL.SHIPPED_QUANTITY !=0