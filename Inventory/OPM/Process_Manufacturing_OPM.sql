-------------------------------------Process_Operations_details---------------------------
SELECT
*
FROM
APPS.GMD_OPERATIONS_VL 
WHERE 1=1
AND OPRN_NO='BAG_TO_BLK_PROC';


-------------------------------------Process_Operations_details---------------------------
SELECT
*
FROM
APPS.GMD_OPERATIONS_B
WHERE 1=1
AND OPRN_NO='BAG_TO_BLK_PROC'



-------------------------------------Process_Operations_Activities---------------------------
SELECT
*
FROM
APPS.GMD_OPERATION_ACTIVITIES GOA
WHERE 1=1
AND ACTIVITY='BAG TO BLK PROC'


-------------------------------------Process_Operations------------------------------------
SELECT
GOV.OPRN_NO
,GOV.PROCESS_QTY_UOM
,GOV.OWNER_ORGANIZATION_ID
,GOV.OPRN_DESC
,GOV.OPERATION_STATUS
,GOA.ACTIVITY
,S.MEANING STATUS_MEANING
,S.DESCRIPTION STATUS_DESCRIPTION
,GOA.*
FROM
APPS.GMD_OPERATIONS_VL GOV
,APPS.GMD_OPERATION_ACTIVITIES GOA
,APPS.GMD_STATUS S
WHERE 1=1
AND GOV.OPRN_ID=GOA.OPRN_ID
AND GOV.OPERATION_STATUS=S.STATUS_CODE
AND GOV.OPRN_NO='BAG_TO_BLK_PROC'
AND GOA.ACTIVITY='BAG TO BLK PROC'


------------------------------------------STATUS--------------------------------------------
SELECT
*
FROM
APPS.GMD_STATUS S
WHERE 1=1
--AND 


------------------------------------------PROCESS_ENGINEER>PROCESS_OPERATIONS>ACTIVITIES--------------------------------------------
SELECT
*
FROM
APPS.GMD_ACTIVITIES_VL GAV
WHERE 1=1
AND ACTIVITY='BAG TO BLK PROC'



-----------------------------------------PARAMETERS---------------------------------------------------------
SELECT
*
FROM
APPS.GME_PARAMETERS GP
WHERE 1=1
AND ORGANIZATION_ID='112'

------------PROCESS_ENGINEER>PROCESS_OPERATIONS>RESOURCES---------------
SELECT
*
FROM
APPS.GMD_OPERATION_RESOURCES
WHERE 1=1
AND RESOURCES='HOPPER'


SELECT
*
FROM
APPS.CR_RSRC_MST_VL
WHERE 1=1
AND RESOURCES='HOPPER'

------------PROCESS_ENGINEER>SETUP>PROCESS_OPERATION_CLASSES---------------
SELECT
*
FROM
APPS.GMD_OPERATION_CLASS_TL



------------OPM FINANCIAL>SETUP>ANALYSIS_CODE---------------
SELECT
*
FROM
APPS.CM_ALYS_MST


--------------------------------------------FORMULA-----------------------------

SELECT
*
FROM
APPS.FM_FORM_MST 
WHERE 1=1
AND OWNER_ORGANIZATION_ID='112'
AND FORMULA_NO='CMNT.SBLK.0001'


SELECT
*
FROM
APPS.FM_FORM_MST_B 
WHERE 1=1

----------------------------FORMULA_LINES---------------------------------------------
SELECT
*
FROM
APPS.FM_MATL_DTL FMD
WHERE 1=1
--AND 

---------------------------------------FORMULA_DETAILS-----------------------------------
SELECT
FMD.*
FROM
APPS.FM_FORM_MST  FFM
,APPS.FM_MATL_DTL FMD
WHERE 1=1
AND FFM.FORMULA_ID=FMD.FORMULA_ID
AND OWNER_ORGANIZATION_ID='112'
AND FFM.FORMULA_NO='CMNT.SBLK.0001'

---------------------------------------FORMULAE DETAILS-------------------------

  SELECT A.FORMULA_ID,
         A.FORMULA_NO,
         A.FORMULA_DESC1,
         B.INVENTORY_ITEM_ID,
         C.DESCRIPTION,
         B.ORGANIZATION_ID,
         DECODE (B.LINE_TYPE,
                 -1, 'Ingredients',
                 1, 'Product',
                 2, 'By Product')
            AS LINE_TYPE
    FROM APPS.FM_FORM_MST A, APPS.FM_MATL_DTL B, APPS.MTL_SYSTEM_ITEMS C
   WHERE     A.FORMULA_ID = B.FORMULA_ID
         AND B.ORGANIZATION_ID = :YOUR_ORG_ID
         --AND FORMULA_NO='CRCL.0350.0914'
         --AND A.FORMULA_CLASS <> 'COSTING'
         AND B.INVENTORY_ITEM_ID = C.INVENTORY_ITEM_ID
         AND B.ORGANIZATION_ID = C.ORGANIZATION_ID
ORDER BY A.FORMULA_ID;


-------IINVENTORY>SETUP>ITEMS>TEMPLATES----------------------------------------
SELECT
*
FROM
APPS.MTL_ITEM_TEMPLATES
WHERE 1=1
AND TEMPLATE_NAME='AKG_FINISH_GOODS_WIP'

------------------------------IINVENTORY>SETUP>ITEMS>ATTRIBUTE -----------------------------------------------------------------
SELECT
*
FROM
APPS.MTL_ITEM_TEMPL_ATTRIBUTES
WHERE 1=1
AND ATTRIBUTE_NAME='MTL_SYSTEM_ITEMS.DESCRIPTION'

------------------------------IINVENTORY>SETUP>ITEMS>ATTRIBUTE CONTROL-----------------------------------------------------------------
SELECT
*
FROM
APPS.MTL_ITEM_ATTRIBUTES_V 
WHERE 1=1
AND USER_ATTRIBUTE_NAME='Stockable'

------------------------------------------------------------------------------------------------


