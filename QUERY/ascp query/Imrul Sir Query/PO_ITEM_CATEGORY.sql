SELECT
    PHA.SEGMENT1 PO_NUMBER,
    PHA.CLOSED_CODE,
    msi.inventory_item_id,
    MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
    MSI.DESCRIPTION,
    MC.SEGMENT1 ITEM_CATG,MC.SEGMENT2 ITEM_type,
    DECODE(MSI.ITEM_TYPE,
        'FG', 'Finished Good',
        'P', 'Purchased Item',
        'NS','Non Stockable Item') inventory_type
FROM 
    PO.PO_HEADERS_ALL PHA,
    PO.PO_LINES_ALL PLA,
    INV.MTL_SYSTEM_ITEMS_B MSI,
    INV.MTL_ITEM_CATEGORIES MIC,
    INV.MTL_CATEGORIES_B MC,
    apps.org_organization_definitions ood
WHERE
    PHA.PO_HEADER_ID=PLA.PO_HEADER_ID
    AND PLA.ITEM_ID=MSI.INVENTORY_ITEM_ID
    AND MSI.INVENTORY_ITEM_ID=MIC.INVENTORY_ITEM_ID
    AND MSI.ORGANIZATION_ID=MIC.ORGANIZATION_ID
    AND MIC.CATEGORY_ID=MC.CATEGORY_ID
    and msi.organization_id=ood.organization_id
    and ood.operating_unit=83
    AND PHA.SEGMENT1 like '%6777%'
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3='GANT.CRAN.0001'
GROUP BY
    PHA.SEGMENT1,
    PHA.CLOSED_CODE,
    msi.inventory_item_id,
    MSI.SEGMENT1,MSI.SEGMENT2,MSI.SEGMENT3,
    MSI.DESCRIPTION,
    MC.SEGMENT1,MC.SEGMENT2,
    MSI.ITEM_TYPE
ORDER BY
    MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3
