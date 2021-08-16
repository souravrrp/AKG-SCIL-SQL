SELECT customer_id,
   CUSTOMER_NUMBER,
   CUSTOMER_NAME,
   ADDRESS,
   TO_NUMBER,
   TO_DATE,
   FREE_TEXT,
   ITEM_DESCRIPTION,
   TO_QTY,
   SHIP_FROM,
   SHIP_TO,
   EMPTY_BAG,
   MODE_OF_TRANSPORT
FROM XXAKG_OE_CEMENT_TO_ADV_FA_V
WHERE ORG_ID=:P_ORG_ID
AND To_number between NVL(:P_TO_FROM,To_number) AND NVL(:P_TO_TO,To_number)
AND     (:P_MODE_OF_TRANSPORT IS NULL OR (MODE_OF_TRANSPORT = :P_MODE_OF_TRANSPORT))
and trunc(TO_DATE) between nvl(:p_date_from,trunc(TO_DATE)) and nvl(:p_date_to,trunc(TO_DATE))
AND CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUSTOMER_ID)

-----------------------------------------Update Function------------------------------------
SELECT TOH.TO_HDR_ID FROM APPS.XXAKG_TO_DO_HDR TOH,APPS.XXAKG_TO_DO_LINES TOL
        WHERE  TOH.TO_HDR_ID= TOL.TO_HDR_ID
        AND  TOH.ORG_ID= TOL.ORG_ID
        AND TOH.TO_STATUS ='GENERATED'
        AND TOH.ORG_ID=:P_ORG_ID
    ---    AND DOL.FROM_INV ='SCI'
        AND READY_FOR_PRINTING ='Y'
        AND NVL(PRINTED_FLAG,'N')='N'
----        AND TOL.ORG_ID=:P_ORG_ID
        AND TOH.TO_NUMBER BETWEEN :P_TO_FROM AND :P_TO_TO
        AND     (:P_MODE_OF_TRANSPORT IS NULL OR (MODE_OF_TRANSPORT = :P_MODE_OF_TRANSPORT))
GROUP BY TOH.TO_HDR_ID;

-------------------------Original--------------------------------------------------------------
SELECT customer_id,
   CUSTOMER_NUMBER,
   CUSTOMER_NAME,
   ADDRESS,
   TO_NUMBER,
   TO_DATE,
   FREE_TEXT,
   ITEM_DESCRIPTION,
   TO_QTY,
   SHIP_FROM,
   SHIP_TO,
   EMPTY_BAG,
   MODE_OF_TRANSPORT
FROM XXAKG_OE_CEMENT_TO_ADV_FA_V
WHERE ORG_ID=:P_ORG_ID
AND To_number between NVL(:P_TO_FROM,To_number) AND NVL(:P_TO_TO,To_number)
and trunc(TO_DATE) between nvl(:p_date_from,trunc(TO_DATE)) and nvl(:p_date_to,trunc(TO_DATE))
AND CUSTOMER_ID=NVL(:P_CUSTOMER_ID,CUSTOMER_ID)

-----------------------------------------Function---------------------------------------------
SELECT TOH.TO_HDR_ID FROM XXAKG_TO_DO_HDR TOH,XXAKG_TO_DO_LINES TOL
        WHERE  TOH.TO_HDR_ID= TOL.TO_HDR_ID
        AND  TOH.ORG_ID= TOL.ORG_ID
        AND TOH.TO_STATUS ='GENERATED'
        AND TOH.ORG_ID=:P_ORG_ID
    ---    AND DOL.FROM_INV ='SCI'
        AND READY_FOR_PRINTING ='Y'
        AND NVL(PRINTED_FLAG,'N')='N'
----        AND TOL.ORG_ID=:P_ORG_ID
        AND TOH.TO_NUMBER BETWEEN :P_TO_FROM AND :P_TO_TO
GROUP BY TOH.TO_HDR_ID;