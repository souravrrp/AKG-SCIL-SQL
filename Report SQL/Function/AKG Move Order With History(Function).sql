CREATE OR REPLACE FUNCTION APPS.XXAKG_GET_MV_DATE_QTY (
   P_ORG NUMBER,
   P_INVENTORY_ITEM_ID    NUMBER,
   P_DATE_REQUIRED        DATE,
   P_RNUM                 NUMBER,
   P_UOM                  VARCHAR2,
   P_ATC                  VARCHAR2,  
   P_UOA                  VARCHAR2)
   RETURN VARCHAR2
IS
   TR_HIST   VARCHAR2 (300);
BEGIN
   SELECT TRH
     INTO TR_HIST
     FROM (SELECT ROWNUM rnum,
                     TO_CHAR (TRANSACTION_DATE, 'DD.MM.YYYY')
                  || '/'
                  || PRIMARY_QUANTITY
                     TRh
             FROM (  SELECT MMT.INVENTORY_ITEM_ID,
                            TRUNC (MMT.TRANSACTION_DATE) TRANSACTION_DATE,
                            MMT.TRANSACTION_UOM,
                            SUM (
                               -1 * MMT.TRANSACTION_QUANTITY
                               * INV_CONVERT.INV_UM_CONVERT (
                                    MMT.INVENTORY_ITEM_ID,
                                    MMT.TRANSACTION_UOM,
                                    P_UOM))
                               PRIMARY_QUANTITY
                       FROM mtl_material_transactions MMT,
                            MTL_TRANSACTION_TYPES MTT,
                            MTL_TXN_REQUEST_LINES MTRL,
                            MTL_TXN_REQUEST_HEADERS MTRH
                      WHERE     1 = 1
                            AND MTRH.HEADER_ID = MTRL.HEADER_ID
                            AND MMT.INVENTORY_ITEM_ID = MTRL.INVENTORY_ITEM_ID
                            AND MMT.INVENTORY_ITEM_ID = P_INVENTORY_ITEM_ID
                            AND MMT.TRANSACTION_SOURCE_ID = MTRH.HEADER_ID
                            AND MMT.TRX_SOURCE_LINE_ID = MTRL.LINE_ID
                            AND MTRH.ATTRIBUTE_CATEGORY = P_ATC
                            AND NVL(MTRH.ATTRIBUTE1,MTRH.ATTRIBUTE4) = P_UOA
			    AND MMT.TRANSFER_ORGANIZATION_TYPE IS NULL
                            --AND MMT.TRANSACTION_DATE < TRUNC (P_DATE_REQUIRED)
                            and to_char(MMT.TRANSACTION_DATE,'DD-MON-YYYY') < P_DATE_REQUIRED
                            --AND MMT.INVENTORY_ITEM_ID in (178138)--, 72699,73714,49053,57343,56370,50792)
                            --AND MMT.ORGANIZATION_ID in (89,1306)
                            AND MMT.ORGANIZATION_ID = P_ORG
                            AND MMT.TRANSACTION_TYPE_ID =
                                   MTT.TRANSACTION_TYPE_ID
                            --AND MTT.TRANSACTION_TYPE_NAME = 'Move Order Issue'
                   GROUP BY MMT.INVENTORY_ITEM_ID,
                            TRUNC (MMT.TRANSACTION_DATE),
                            MMT.TRANSACTION_UOM
                   ORDER BY TRUNC (MMT.TRANSACTION_DATE) DESC))
    WHERE Rnum = p_RNUM;

   RETURN (TR_HIST);
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN (NULL);
END;
/
