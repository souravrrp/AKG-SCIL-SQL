SELECT mil.segment1 loc_seg1, mil.segment11 loc_seg11, mil.segment2 loc_seg2,
mil.segment3 loc_seg3, mil.segment4 loc_seg4, mil.segment5 loc_seg5,
mil.segment6 loc_seg6,ood.ORGANIZATION_NAME,mil.SUBINVENTORY_CODE
FROM apps.mtl_item_locations mil,apps.org_organization_definitions ood
where mil.ORGANIZATION_ID = ood.ORGANIZATION_ID