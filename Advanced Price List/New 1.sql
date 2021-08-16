/* Formatted on 1/6/2020 4:52:31 PM (QP5 v5.287) */
  SELECT HOU.NAME OU_NAME,
         LED.LEGAL_ENTITY_ID,
         LED.LEGAL_ENTITY_NAME,
         ORG.ORGANIZATION_NAME,
         RSH.RECEIPT_NUM GRN_Number,
         --RT.TRANSACTION_DATE GRN_DATE,
         PHA.SEGMENT1 PO_NUMBER,
         PHA.CREATION_DATE PO_DATE,
         PRHA.SEGMENT1 REQUISITION_NUMBER,
         PHA.CREATION_DATE REQUISITION_DATE,
         MSI.DESCRIPTION ITEM_DESCRIPTION,
         SUP.VENDOR_NAME PARTY_NAME,
         SUM (PLA.QUANTITY) QUANTITY,
         ( :TO_WHOM) "TO_WHOM",
         --RT.UOM_CODE UNIT,
         (SELECT (CASE
                     WHEN RT.TRANSACTION_TYPE = 'REJECT'
                     THEN
                        SUM (NVL (RT.QUANTITY, 0))
                  END)
                    REJECTED_QUANTITY
            FROM APPS.RCV_TRANSACTIONS RT
           WHERE     RT.TRANSACTION_TYPE IN ('ACCEPT', 'REJECT')
                 AND PHA.PO_HEADER_ID = RT.PO_HEADER_ID
                 AND PLA.PO_LINE_ID = RT.PO_LINE_ID
                 AND RT.SHIPMENT_HEADER_ID = RSH.SHIPMENT_HEADER_ID
                 AND RT.SHIPMENT_LINE_ID = RSL.SHIPMENT_LINE_ID GROUP BY RT.TRANSACTION_TYPE)
            REJECTED_QUANTITY
    FROM APPS.PO_HEADERS_ALL PHA,
         APPS.PO_LINES_ALL PLA,
         APPS.XXDBL_COMPANY_LE_MAPPING_V LED,
         APPS.AP_SUPPLIERS SUP,
         APPS.AP_SUPPLIER_SITES_ALL SUPS,
         APPS.PO_LINE_TYPES_B PLT,
         APPS.PO_LINE_LOCATIONS_ALL PLL,
         APPS.MTL_SYSTEM_ITEMS_B MSI,
         APPS.MTL_ITEM_CATEGORIES MIC,
         APPS.MTL_CATEGORIES MC,
         APPS.ORG_ORGANIZATION_DEFINITIONS ORG,
         APPS.HR_OPERATING_UNITS HOU,
         APPS.PO_DISTRIBUTIONS_ALL PDA,
         APPS.PO_REQ_DISTRIBUTIONS_ALL PROD,
         APPS.PO_REQUISITION_LINES_ALL PROL,
         APPS.PO_REQUISITION_HEADERS_ALL PRHA,
         APPS.MTL_TXN_REQUEST_LINES L,
         APPS.MTL_TXN_REQUEST_HEADERS MTRH,
--         (SELECT SHIPMENT_HEADER_ID,
--                 SHIPMENT_HEADER_ID (
--                    CASE
--                       WHEN RT.TRANSACTION_TYPE = 'ACCEPT'
--                       THEN
--                          SUM (NVL (RT.QUANTITY, 0))
--                    END)
--                    ACCEPTED_QUANTITY,
--                 (CASE
--                     WHEN RT.TRANSACTION_TYPE = 'REJECT'
--                     THEN
--                        SUM (NVL (RT.QUANTITY, 0))
--                  END)
--                    REJECTED_QUANTITY
--            FROM APPS.RCV_TRANSACTIONS RT
--           WHERE     RT.TRANSACTION_TYPE IN ('ACCEPT', 'REJECT')
--                 AND PHA.PO_HEADER_ID = RT.PO_HEADER_ID
--                 AND PLA.PO_LINE_ID = RT.PO_LINE_ID
--                 AND RT.SHIPMENT_HEADER_ID = RSH.SHIPMENT_HEADER_ID
--                 AND RT.SHIPMENT_LINE_ID = RSL.SHIPMENT_LINE_ID) RT,
         APPS.RCV_SHIPMENT_HEADERS RSH,
         APPS.RCV_SHIPMENT_LINES RSL
   WHERE     PHA.PO_HEADER_ID = PLA.PO_HEADER_ID
         AND PHA.ORG_ID = PLA.ORG_ID
         AND PHA.ORG_ID = LED.ORG_ID
         AND PHA.ORG_ID = HOU.ORGANIZATION_ID
         AND PHA.PO_HEADER_ID = PLL.PO_HEADER_ID
         AND PLA.PO_LINE_ID = PLL.PO_LINE_ID
         AND PLA.LINE_TYPE_ID = PLT.LINE_TYPE_ID
         AND PLA.ITEM_ID = MSI.INVENTORY_ITEM_ID
         AND PLL.SHIP_TO_ORGANIZATION_ID = MSI.ORGANIZATION_ID
         AND MSI.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID
         AND MSI.ORGANIZATION_ID = MIC.ORGANIZATION_ID
         AND MIC.CATEGORY_ID = MC.CATEGORY_ID
         AND MIC.CATEGORY_SET_ID = 1
         AND PHA.VENDOR_ID = SUP.VENDOR_ID
         AND SUP.VENDOR_ID = SUPS.VENDOR_ID
         AND PLL.SHIP_TO_ORGANIZATION_ID = ORG.ORGANIZATION_ID
         AND PHA.VENDOR_SITE_ID = SUPS.VENDOR_SITE_ID(+)
         AND PHA.TYPE_LOOKUP_CODE = 'STANDARD'
         AND PHA.PO_HEADER_ID = PDA.PO_HEADER_ID
         AND PLA.PO_LINE_ID = PDA.PO_LINE_ID
         AND PLL.LINE_LOCATION_ID = PDA.LINE_LOCATION_ID
         AND PDA.REQ_DISTRIBUTION_ID = PROD.DISTRIBUTION_ID(+)
         AND PROD.REQUISITION_LINE_ID = PROL.REQUISITION_LINE_ID(+)
         AND PROL.REQUISITION_HEADER_ID = PRHA.REQUISITION_HEADER_ID(+)
         AND RSH.SHIPMENT_HEADER_ID = RSL.SHIPMENT_HEADER_ID
         AND L.ATTRIBUTE14(+) = PROD.DISTRIBUTION_ID
         AND L.HEADER_ID = MTRH.HEADER_ID(+)
         AND LED.UNIT_NAME = :P_UNIT_NAME
         AND RSH.RECEIPT_NUM = :P_GRN_NO
GROUP BY HOU.NAME,
         LED.LEGAL_ENTITY_ID,
         LED.LEGAL_ENTITY_NAME,
         ORG.ORGANIZATION_NAME,
         RSH.RECEIPT_NUM,
         --RT.TRANSACTION_DATE,
         PHA.SEGMENT1,
         PHA.CREATION_DATE,
         PRHA.SEGMENT1,
         PHA.CREATION_DATE,
         MSI.DESCRIPTION,
         SUP.VENDOR_NAME
         --RT.UOM_CODE
         --RT.TRANSACTION_TYPE;