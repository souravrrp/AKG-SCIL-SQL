SELECT
(CASE -----Wastage
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='P' AND SUBSTR(msi.segment1,2,2)='WC' THEN 'Wastage-Marble-Polished'
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='U' AND SUBSTR(msi.segment1,2,2)='WC' THEN 'Wastage-Marble-Unpolished'
          WHEN substr(msi.segment1,1,1)='G' AND substr(msi.segment1,-1,1)='P' AND SUBSTR(msi.segment1,2,2)='WC' THEN 'Wastage-Granite-Polished'
          WHEN substr(msi.segment1,1,1)='G' AND substr(msi.segment1,-1,1)='U' AND SUBSTR(msi.segment1,2,2)='WC' THEN 'Wastage-Granite-Unpolished'---Not Active
            ------Marble
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='P' THEN 'Marble-Polished'
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='U' THEN 'Marble-Unpolished'
          -----Granite
          WHEN substr(msi.segment1,0,1)='G' AND substr(msi.segment1,-1,1)='P' THEN 'Granite-Polished'
          WHEN substr(msi.segment1,0,1)='G' AND substr(msi.segment1,-1,1)='U' THEN 'Granite-Unpolished'
          ----Others
          WHEN substr(msi.segment2,0,1)='G' AND substr(msi.segment1,1,4)='KHPS' THEN 'Khapsa-Granite'
          WHEN substr(msi.segment2,0,1)='M' AND substr(msi.segment1,1,4)='KHPS' THEN 'Khapsa-Marble'
          WHEN substr(msi.segment2,0,1)='M' AND substr(msi.segment1,1,4)='PWDR' THEN 'Powder-Marble'
          WHEN substr(msi.segment2,0,1)='G' AND substr(msi.segment1,1,4)='PWDR' THEN 'Powder-Granite'
          WHEN substr(msi.segment2,2,4)='MLD' AND substr(msi.segment1,1,4)='SRVC' THEN 'Service-Mould'
          WHEN substr(msi.segment2,1,2)='GL' AND substr(msi.segment1,1,4)='SRVC' THEN 'Service-Glue'
          WHEN substr(msi.segment2,1,4)='GRAN' AND substr(msi.segment1,1,4)='HORN' THEN 'Horn-Granite'
          WHEN substr(msi.segment1,1,4)='CHIP' THEN 'Chips'
          WHEN substr(msi.segment2,1,4)='RSIN' THEN 'Resin'
          WHEN substr(msi.segment1,1,4)='GROO' AND substr(msi.segment2,1,4)='GROO' THEN 'Grooving'
        ELSE 'Others'
END) Item_Category,
(CASE 
          WHEN  SUBSTR(msi.segment1,2,2)='CS'   THEN 'Cut to Size'
          WHEN SUBSTR(msi.segment1,2,2)='WC'  THEN 'Cut to Size'
          WHEN SUBSTR(msi.segment1,2,2)='SL' THEN 'Slab'
        ELSE 'Others'
END) Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE,
TO_CHAR(OPLL.END_DATE_ACTIVE,'DD-MON-RR') END_DATE,
OPLL.METHOD_CODE APPLICATION_METHOD
--,OPLL.*
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
--    AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('MWCP.JGUR.1801')
--AND OPLL.CONCATENATED_SEGMENTS=:P_CONCATENATED_SEGMENTS
--AND OPLL.CONCATENATED_SEGMENTS IN ('MECH.RSIN.0001')
--AND substr(msi.segment1,0,1)='M'
--AND substr(msi.segment1,2,2)!='WC'
--AND substr(msi.segment1,4,4)='P'
AND OPL.NAME='AKG Marble Price List'
AND MSI.ORGANIZATION_ID=606
--and substr(msi.segment1,0,1)  IN ('G','M')
--AND OPLL.METHOD_CODE='UNIT_PRICE'
--and OPLL.ITEM_DESCRIPTION like '%Wastage%'            




------------------------------------------------------------------------------------------------


SELECT
(CASE ------Marble
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='U' AND SUBSTR(msi.segment1,2,2)='CS' THEN 'Marble-Unpolished-Cut to Size'
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='U' AND SUBSTR(msi.segment1,2,2)='SL' THEN 'Marble-Unpolished-Slab'
          WHEN substr(msi.segment1,0,1)='M' AND substr(msi.segment1,-1,1)='P' AND SUBSTR(msi.segment1,2,2)='CS' THEN 'Marble-Polished-Cut to Size'
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='P' AND SUBSTR(msi.segment1,2,2)='SL' THEN 'Marble-Polished-Slab'
          -----Wastage
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='P' AND SUBSTR(msi.segment1,2,2)='WC' THEN 'Wastage-Marble-Polished-Cut to Size'
          WHEN substr(msi.segment1,1,1)='M' AND substr(msi.segment1,-1,1)='U' AND SUBSTR(msi.segment1,2,2)='WC' THEN 'Wastage-Marble-Unpolished-Cut to Size'
          WHEN substr(msi.segment1,1,1)='G' AND substr(msi.segment1,-1,1)='P' AND SUBSTR(msi.segment1,2,2)='WC' THEN 'Wastage-Granite-Polished-Cut to Size'
--          WHEN substr(msi.segment1,1,1)='G' AND substr(msi.segment1,-1,1)='U' AND SUBSTR(msi.segment1,2,2)='WC' THEN 'Wastage-Granite-Unpolished-Cut to Size'---Not Active
          -----Granite
          WHEN substr(msi.segment1,0,1)='G' AND substr(msi.segment1,-1,1)='P' AND SUBSTR(msi.segment1,2,2)='CS' THEN 'Granite-Polished-Cut to Size'
          WHEN substr(msi.segment1,1,1)='G' AND substr(msi.segment1,-1,1)='P' AND SUBSTR(msi.segment1,2,2)='SL' THEN 'Granite-Polished-Slab'
          WHEN substr(msi.segment1,0,1)='G' AND substr(msi.segment1,-1,1)='U' AND SUBSTR(msi.segment1,2,2)='CS' THEN 'Granite-Unpolished-Cut to Size'
          WHEN substr(msi.segment1,0,1)='G' AND substr(msi.segment1,-1,1)='U' AND SUBSTR(msi.segment1,2,2)='SL' THEN 'Granite-Unpolished-Slab'
          WHEN substr(msi.segment2,0,1)='G' AND substr(msi.segment1,1,4)='KHPS' THEN 'Khapsa-Granite'
          WHEN substr(msi.segment2,0,1)='M' AND substr(msi.segment1,1,4)='KHPS' THEN 'Khapsa-Marble'
          WHEN substr(msi.segment2,0,1)='M' AND substr(msi.segment1,1,4)='PWDR' THEN 'Powder-Marble'
          WHEN substr(msi.segment2,0,1)='G' AND substr(msi.segment1,1,4)='PWDR' THEN 'Powder-Granite'
          WHEN substr(msi.segment2,2,4)='MLD' AND substr(msi.segment1,1,4)='SRVC' THEN 'Service-Mould'
          WHEN substr(msi.segment2,1,2)='GL' AND substr(msi.segment1,1,4)='SRVC' THEN 'Service-Glue'
          WHEN substr(msi.segment2,1,4)='GRAN' AND substr(msi.segment1,1,4)='HORN' THEN 'Horn-Granite'
          WHEN substr(msi.segment1,1,4)='CHIP' THEN 'Chips'
          WHEN substr(msi.segment2,1,4)='RSIN' THEN 'Resin'
          WHEN substr(msi.segment1,1,4)='GROO' AND substr(msi.segment2,1,4)='GROO' THEN 'Grooving'
        ELSE 'Others'
END) Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE,
TO_CHAR(OPLL.END_DATE_ACTIVE,'DD-MON-RR') END_DATE,
OPLL.METHOD_CODE APPLICATION_METHOD
--,OPLL.*
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
--    AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.ELAB.0020')
--AND OPLL.CONCATENATED_SEGMENTS=:P_CONCATENATED_SEGMENTS
--AND OPLL.CONCATENATED_SEGMENTS IN ('MECH.RSIN.0001')
--AND substr(msi.segment1,0,1)='M'
--AND substr(msi.segment1,2,2)!='WC'
--AND substr(msi.segment1,4,4)='P'
AND OPL.NAME='AKG Marble Price List'
AND MSI.ORGANIZATION_ID=606
--and substr(msi.segment1,0,1) NOT IN ('G','M')
--AND OPLL.METHOD_CODE='UNIT_PRICE'
--and OPLL.ITEM_DESCRIPTION like '%Wastage%'    

------------------------------------------------------------------------------------------------


SELECT
NVL(decode(substr(msi.segment1,1,4),'GROO','Grooving',decode(substr(msi.segment1,0,1),
        'G','Granaite',
        'M','Marble',
        'C','Chips'
        ,DECODE(substr(msi.segment2,1,2),'GL','GLUE'))),
        DECODE(substr(msi.segment2,0,1),'G','Granaite','M','Marble'))
        ||'-'||
        NVL(decode(substr(msi.segment1,4,4),
        'U','Unpolished',
        'P','Polish'
        ,decode(substr(msi.segment1,1,4),'KHPS','Khapsa','HORN','Horn','PWDR','Powder','GROO','Grooving')),
        DECODE(substr(msi.segment2,2,4), 'MLD','Mould'
        ,decode(substr(msi.segment1,1,4),'SRVC','Service'))
        ) Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE,
TO_CHAR(OPLL.END_DATE_ACTIVE,'DD-MON-RR') END_DATE,
OPLL.METHOD_CODE APPLICATION_METHOD
--,OPLL.*
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
--    AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('BSNA.ELAB.0020')
--AND OPLL.CONCATENATED_SEGMENTS=:P_CONCATENATED_SEGMENTS
--AND OPLL.CONCATENATED_SEGMENTS IN ('MECH.RSIN.0001')
AND OPL.NAME='AKG Marble Price List'
AND MSI.ORGANIZATION_ID=606
--and substr(msi.segment1,0,1) NOT IN ('G','M')
--AND OPLL.METHOD_CODE='UNIT_PRICE'
--and OPLL.ITEM_DESCRIPTION like '%Wastage%'


SELECT
*
FROM
APPS.MTL_SYSTEM_ITEMS_B MSI
WHERE 1=1
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3=:P_ITEM_CODE


-----------------------------ALL ITEMS-------------------------------------------------------

SELECT 'Others Item' Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
AND OPL.NAME='AKG Marble Price List'
AND MSI.ORGANIZATION_ID=606
--AND OPLL.CONCATENATED_SEGMENTS=:P_Item_Code
UNION ALL
SELECT 'Polish Item' Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
AND OPL.NAME='AKG Marble Polish Price List'
AND MSI.ORGANIZATION_ID=606
--AND OPLL.CONCATENATED_SEGMENTS=:P_Item_Code
UNION ALL
SELECT 'Unpolish Item' Item_Type,
OPLL.CONCATENATED_SEGMENTS ITEM_CODE,
OPLL.ITEM_DESCRIPTION,
OPLL.LIST_PRICE PRICE,
OPLL.UNIT_CODE "UOM",
TO_CHAR(OPLL.START_DATE_ACTIVE,'DD-MON-RR') START_DATE
FROM
APPS.OE_PRICE_LISTS OPL,
APPS.OE_PRICE_LIST_LINES OPLL
,APPS.MTL_SYSTEM_ITEMS_B MSI
where 1=1
and OPL.PRICE_LIST_ID = OPLL.PRICE_LIST_ID 
and OPLL.END_DATE_ACTIVE IS NULL
AND OPL.ATTRIBUTE1 IS NULL
AND OPLL.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID
AND OPL.NAME='AKG Marble Unpolish Price List'
AND MSI.ORGANIZATION_ID=606
--AND OPLL.CONCATENATED_SEGMENTS=:P_Item_Code
