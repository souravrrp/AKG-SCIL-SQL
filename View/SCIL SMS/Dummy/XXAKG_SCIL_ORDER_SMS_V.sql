DROP VIEW APPS.XXAKG_SCIL_ORDER_SMS_V;

/* Formatted on 4/10/2019 3:31:35 PM (QP5 v5.136.908.31019) */
CREATE OR REPLACE FORCE VIEW APPS.XXAKG_SCIL_ORDER_SMS_V
(
          ORG_ID,
          OPERATING_UNIT,
          REGION, 
          CUSTOMER_NUMBER, 
          CUSTOMER_NAME,
          ORDER_NUMBER,
          ORDERED_DATE,
          BOOKED_DATE,
          HEADER_ID,
          LINE_ID,
          INVENTORY_ITEM_ID,
          ITEM_CODE,
          ITEM_DESCRIPTION,
          UOM_CODE,
          ORDERED_QUANTITY,
          CONVERT_BAG_QTY,
          SHIPPED_QUANTITY,
          CONVERT_SHIPPED_BAG_QTY,
          ACTUAL_SHIPMENT_DATE,
          UNIT_SELLING_PRICE,
          PRICING_DATE,
          PRICE_LIST_ID,
          PRICE_LOCATION,
          TRANSPORT_MODE,
          DELIVERY_MODE,
          SHIP_TO_ORG_ID,
          DELIVERY_SITE,
          WAREHOUSE_ORG_ID,
          WAREHOUSE_ORG_NAME,
          RETAILER_PHONE_NO,
          EMAIL_ADDRESS,
          OFFICER_PHONE_NO,
          ORDER_STATUS
)
AS
    SELECT 
          H.ORG_ID,
          XXAKG_COM_PKG.GET_ORGANIZATION_NAME (H.ORG_ID) OPERATING_UNIT,
          APPS.XXAKG_AR_PKG.GET_REGION_FROM_CUST_ID (H.SOLD_TO_ORG_ID) REGION, 
          APPS.XXAKG_AR_PKG.GET_CUSTOMER_NUMBER_FROM_ID (H.SOLD_TO_ORG_ID) CUSTOMER_NUMBER, 
          APPS.XXAKG_AR_PKG.GET_CUSTOMER_NAME_FROM_ID (H.SOLD_TO_ORG_ID) CUSTOMER_NAME,
          H.ORDER_NUMBER,
          H.ORDERED_DATE,
          H.BOOKED_DATE,
          H.HEADER_ID,
          L.LINE_ID,
          L.INVENTORY_ITEM_ID,
          L.ORDERED_ITEM ITEM_CODE,
          (SELECT DESCRIPTION FROM INV.MTL_SYSTEM_ITEMS_B MSI WHERE MSI.INVENTORY_ITEM_ID=L.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID= L.SHIP_FROM_ORG_ID) ITEM_DESCRIPTION,
          L.ORDER_QUANTITY_UOM UOM_CODE,
          L.ORDERED_QUANTITY,
          (CASE 
            WHEN  L.ORDERED_ITEM='CMNT.OBAG.0004' THEN (L.ORDERED_QUANTITY*1000)/50
            ELSE DECODE (ORDER_QUANTITY_UOM,'MTN', NVL (ORDERED_QUANTITY, 0) * 20,NVL (ORDERED_QUANTITY, 0))
          END) CONVERT_BAG_QTY,
          L.SHIPPED_QUANTITY,
          (CASE 
            WHEN  L.ORDERED_ITEM='CMNT.OBAG.0004' THEN (L.SHIPPED_QUANTITY*1000)/50
            ELSE DECODE (ORDER_QUANTITY_UOM, 'MTN', NVL (L.SHIPPED_QUANTITY, 0) * 20, NVL (L.SHIPPED_QUANTITY, 0))
          END) CONVERT_SHIPPED_BAG_QTY,
          L.ACTUAL_SHIPMENT_DATE,
          L.UNIT_SELLING_PRICE,
          L.PRICING_DATE,
          L.PRICE_LIST_ID,
          L.ATTRIBUTE10 PRICE_LOCATION,
          L.ATTRIBUTE11 TRANSPORT_MODE,
          L.ATTRIBUTE13 DELIVERY_MODE,
          L.SHIP_TO_ORG_ID,
          XXAKG_ONT_PKG.GET_RETAILER_DELIVERY_LOCATION (L.SHIP_TO_ORG_ID) DELIVERY_SITE,
          L.SHIP_FROM_ORG_ID WAREHOUSE_ORG_ID,
          XXAKG_COM_PKG.GET_ORGANIZATION_NAME (L.SHIP_FROM_ORG_ID) WAREHOUSE_ORG_NAME,
          XXAKG_ONT_PKG.GET_RETAILER_PHONE_NO (L.SHIP_TO_ORG_ID) RETAILER_PHONE_NO,
          (SELECT ARC.EMAIL_ADDRESS FROM APPS.AR_CONTACTS_V ARC WHERE ARC.CUSTOMER_ID = H.SOLD_TO_ORG_ID AND ARC.CONTACT_ID = H.SOLD_TO_CONTACT_ID) EMAIL_ADDRESS,
          (SELECT NVL(HCA.ATTRIBUTE9,0) FROM APPS.HZ_CUST_ACCOUNTS HCA WHERE HCA.CUST_ACCOUNT_ID=H.SOLD_TO_ORG_ID) OFFICER_PHONE_NO,
          H.FLOW_STATUS_CODE ORDER_STATUS
     FROM
        APPS.OE_ORDER_LINES_ALL L,
        APPS.OE_ORDER_HEADERS_ALL H
     WHERE H.ORG_ID = 85
        AND H.HEADER_ID=L.HEADER_ID;