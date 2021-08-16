/* Formatted on 7/3/2014 2:44:52 PM (QP5 v5.136.908.31019) */
SELECT a.OPERATING_UNIT,
       a.ORGANIZATION_CODE,
       a.ORGANIZATION_ID,
       a.SUBINVENTORY_CODE,
       a.INVENTORY_ITEM_ID,
       a.ITEM_CODE,
       a.ITEM_DESCRIPTION,
       a.UOM,
       a.ITEM_CATG,
       a.ITEM_TYPE,
       a.item_Source,
       a.movement_status,
       CASE
          WHEN TYP = 'OPN'
          THEN
             (  a.OPENING_QTY
              + a.ITR_RCV
              + a.PO_RECEVING
              + a.PO_CORRECTION_RCV
              + a.WIP_RETUN
              + a.WIP_COMPLETION
              + a.WIP_BY_PRODUCT_RCV
              + a.PRA_RCV
              + a.RMA_RCV
              + a.DORG_RCV
              + a.MISC_RCV
              + a.ITR_ISSUE
              + a.MO_ISSUE
              + a.NRG_ISSUE
              + a.RTV_ISSUE
              + a.PO_CORRCTION_ISSUE
              + a.MI2C_ISSUE
              + a.WIP_COMPLETION_RE_ISSUE
              + a.WIP_ISSUE
              + a.WIPBR_ISSUE
              + a.PRA_ISSUE
              + a.DORG_ISSUE
              + a.MISC_ISSUE
              + a.SLS_ISSUE)
          ELSE
             0
       END
          OPN_QTY,
       CASE
          WHEN TYP = 'RCV'
          THEN
             (  a.OPENING_QTY
              + a.ITR_RCV
              + a.PO_RECEVING
              + a.PO_CORRECTION_RCV
              + a.WIP_RETUN
              + a.WIP_COMPLETION
              + a.WIP_BY_PRODUCT_RCV
              + a.PRA_RCV
              + a.RMA_RCV
              + a.DORG_RCV
              + a.MISC_RCV
              + a.ITR_ISSUE
              + a.MO_ISSUE
              + a.NRG_ISSUE
              + a.RTV_ISSUE
              + a.PO_CORRCTION_ISSUE
              + a.MI2C_ISSUE
              + a.WIP_COMPLETION_RE_ISSUE
              + a.WIP_ISSUE
              + a.WIPBR_ISSUE
              + a.PRA_ISSUE
              + a.DORG_ISSUE
              + a.MISC_ISSUE
              + a.SLS_ISSUE)
          ELSE
             0
       END
          RCV_QTY,
       CASE
          WHEN TYP = 'ISU'
          THEN
             (  a.OPENING_QTY
              + a.ITR_RCV
              + a.PO_RECEVING
              + a.PO_CORRECTION_RCV
              + a.WIP_RETUN
              + a.WIP_COMPLETION
              + a.WIP_BY_PRODUCT_RCV
              + a.PRA_RCV
              + a.RMA_RCV
              + a.DORG_RCV
              + a.MISC_RCV
              + a.ITR_ISSUE
              + a.MO_ISSUE
              + a.NRG_ISSUE
              + a.RTV_ISSUE
              + a.PO_CORRCTION_ISSUE
              + a.MI2C_ISSUE
              + a.WIP_COMPLETION_RE_ISSUE
              + a.WIP_ISSUE
              + a.WIPBR_ISSUE
              + a.PRA_ISSUE
              + a.DORG_ISSUE
              + a.MISC_ISSUE
              + a.SLS_ISSUE)
          ELSE
             0
       END
          ISSUE_QTY,
       a.current_cost,
       a.OPN_COST
  FROM (SELECT TYP,
               OPERATING_UNIT,
               ORGANIZATION_CODE,
               ORGANIZATION_ID,
               SUBINVENTORY_CODE,
               INVENTORY_ITEM_ID,
               ITEM_CODE,
               ITEM_DESCRIPTION,
               UOM,
               ITEM_CATG,
               ITEM_TYPE,
               item_Source,
               movement_status,
               OPENING_QTY,
               ITR_RCV,
               PO_RECEVING,
               PO_CORRECTION_RCV,
               WIP_RETUN,
               WIP_COMPLETION,
               WIP_BY_PRODUCT_RCV,
               PRA_RCV,
               RMA_RCV,
               DORG_RCV,
               MISC_RCV,
               ITR_ISSUE,
               MO_ISSUE,
               NRG_ISSUE,
               RTV_ISSUE,
               PO_CORRCTION_ISSUE,
               MI2C_ISSUE,
               WIP_COMPLETION_RE_ISSUE,
               WIP_ISSUE,
               WIPBR_ISSUE,
               PRA_ISSUE,
               DORG_ISSUE,
               MISC_ISSUE,
               SLS_ISSUE,
               apps.fnc_get_item_cost (organization_id,
                                       inventory_item_id,
                                       TO_CHAR (:p_from_date, 'MON-RR'))
                  current_cost,
               apps.fnc_get_item_cost (
                  organization_id,
                  inventory_item_id,
                  DECODE (TO_CHAR (:p_from_date, 'DD'),
                          '01', TO_CHAR (:p_from_date - 1, 'MON-RR'),
                          TO_CHAR (:p_from_date, 'MON-RR')))
                  OPN_COST
          FROM (WITH ON_HAND
                        AS (  SELECT oq.organization_id,
                                     oq.subinventory_code,
                                     oq.inventory_item_id,
                                     SUM (target_qty) op_qty
                                FROM (  SELECT organization_id,
                                               subinventory_code,
                                               inventory_item_id,
                                               SUM(primary_transaction_quantity)
                                                  target_qty
                                          FROM apps.mtl_onhand_quantities_detail moq
                                      GROUP BY organization_id,
                                               subinventory_code,
                                               inventory_item_id
                                      UNION
                                        SELECT organization_id,
                                               subinventory_code,
                                               inventory_item_id,
                                               -SUM (primary_quantity)
                                                  target_qty
                                          FROM apps.mtl_material_transactions mmt
                                         WHERE TRUNC (mmt.transaction_date) >=
                                                  :p_from_date
                                               AND (mmt.Logical_Transaction =
                                                       2
                                                    OR mmt.Logical_Transaction IS NULL)
                                      GROUP BY organization_id,
                                               subinventory_code,
                                               inventory_item_id) oq
                            GROUP BY organization_id,
                                     subinventory_code,
                                     inventory_item_id
                              HAVING SUM (target_qty) <> 0),
                     RCV
                        AS (  SELECT organization_id,
                                     subinventory_code,
                                     inventory_item_id,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            12,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        ITR_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            18,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        PO_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            71,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        PO_CORRECTION_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            43,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        WIPR_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            44,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        WIP_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            1002,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        WIPBP_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            8,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        PRA_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            15,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        RMA_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            3,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        DORG_RCV,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            42,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               1,
                                               primary_quantity)))
                                        MISC_RCV
                                FROM apps.mtl_material_transactions mmt
                               WHERE TRUNC (transaction_date) BETWEEN :p_from_date
                                                                  AND  :p_to_date
                            GROUP BY organization_id,
                                     subinventory_code,
                                     inventory_item_id),
                     ISSUE
                        AS (  SELECT organization_id,
                                     subinventory_code,
                                     inventory_item_id,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            21,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        ITR_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            63,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        MO_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            101,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        NRG_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            36,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        RTV_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            71,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        PO_CORRCTION_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            105,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        MI2C_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            17,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        WIPCR_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            35,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        WIP_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            1003,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        WIPBR_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            8,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        PRA_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            3,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        DORG_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            32,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        MISC_ISSUE,
                                     SUM(DECODE (
                                            transaction_type_id,
                                            33,
                                            DECODE (
                                               SIGN (mmt.transaction_quantity),
                                               -1,
                                               primary_quantity)))
                                        SLS_ISSUE
                                FROM apps.mtl_material_transactions mmt
                               WHERE TRUNC (transaction_date) BETWEEN :p_from_date
                                                                  AND  :p_to_date
                            GROUP BY organization_id,
                                     subinventory_code,
                                     inventory_item_id)
                SELECT 'OPN' TYP,
                       ood.operating_unit,
                       ood.organization_code,
                       ood.organization_id,
                       oh.subinventory_code,
                       msi.inventory_item_id,
                       msi.concatenated_segments item_code,
                       msi.description item_description,
                       msi.primary_uom_code uom,
                       mic.segment1 AS Item_Catg,
                       mic.segment2 Item_type,
                       DECODE (msi.attribute27,
                               'Foreign', 'Foreign',
                               'Local')
                          AS item_Source,
                       msi.attribute29 movement_status,
                       NVL (oh.op_qty, 0) OPENING_QTY,
                       0 ITR_RCV,
                       0 PO_RECEVING,
                       0 PO_CORRECTION_RCV,
                       0 WIP_RETUN,
                       0 WIP_COMPLETION,
                       0 WIP_BY_PRODUCT_RCV,
                       0 PRA_RCV,
                       0 RMA_RCV,
                       0 DORG_RCV,
                       0 MISC_RCV,
                       0 ITR_ISSUE,
                       0 MO_ISSUE,
                       0 NRG_ISSUE,
                       0 RTV_ISSUE,
                       0 PO_CORRCTION_ISSUE,
                       0 MI2C_ISSUE,
                       0 WIP_COMPLETION_RE_ISSUE,
                       0 WIP_ISSUE,
                       0 WIPBR_ISSUE,
                       0 PRA_ISSUE,
                       0 DORG_ISSUE,
                       0 MISC_ISSUE,
                       0 SLS_ISSUE
                  FROM ON_HAND oh,              --  RCV r ,        ISSUE  isu,
                       apps.mtl_system_items_kfv msi,
                       apps.mtl_item_categories_v mic,
                       APPS.ORG_ORGANIZATION_DEFINITIONS OOD
                 WHERE              --oh.organization_id (+)=r.organization_id
                           --and oh.inventory_item_id (+)= r.inventory_item_id
                           --and oh.organization_id(+) =isu.organization_id
                           --and oh.inventory_item_id(+) = isu.inventory_item_id
                           oh.organization_id = ood.organization_id
                       AND oh.inventory_item_id(+) = msi.inventory_item_id
                       AND oh.organization_id(+) = msi.organization_id
                       AND mic.organization_id = msi.organization_id
                       AND mic.inventory_item_id = msi.inventory_item_id
                       --and msi.concatenated_segments='DRCT.H240.0930'
                       --     AND mic.segment2 = 'HR COIL'
                       --and oh.organization_id =94--  in (94,95,96,97,98)
                       AND msi.organization_id NOT IN (90, 91, 685)
                --group by  mtp.organization_code, msi.concatenated_segments
                UNION
                SELECT 'RCV' TYP,
                       ood.operating_unit,
                       ood.organization_code,
                       ood.organization_id,
                       r.subinventory_code,
                       msi.inventory_item_id,
                       msi.concatenated_segments item_code,
                       msi.description item_description,
                       msi.primary_uom_code uom,
                       mic.segment1 AS Item_Catg,
                       mic.segment2 Item_type,
                       DECODE (msi.attribute27,
                               'Foreign', 'Foreign',
                               'Local')
                          AS item_Source,
                       msi.attribute29 movement_status,
                       0 OPENING_QTY,
                       NVL (ITR_RCV, 0) ITR_RCV,
                       NVL (PO_RCV, 0) PO_RECEVING,
                       NVL (PO_CORRECTION_RCV, 0) PO_CORRECTION_RCV,
                       NVL (WIPR_RCV, 0) WIP_RETUN,
                       NVL (WIP_RCV, 0) WIP_COMPLETION,
                       NVL (WIPBP_RCV, 0) WIP_BY_PRODUCT_RCV,
                       NVL (PRA_RCV, 0) PRA_RCV,
                       NVL (RMA_RCV, 0) RMA_RCV,
                       NVL (DORG_RCV, 0) DORG_RCV,
                       NVL (MISC_RCV, 0) MISC_RCV,
                       0 ITR_ISSUE,
                       0 MO_ISSUE,
                       0 NRG_ISSUE,
                       0 RTV_ISSUE,
                       0 PO_CORRCTION_ISSUE,
                       0 MI2C_ISSUE,
                       0 WIP_COMPLETION_RE_ISSUE,
                       0 WIP_ISSUE,
                       0 WIPBR_ISSUE,
                       0 PRA_ISSUE,
                       0 DORG_ISSUE,
                       0 MISC_ISSUE,
                       0 SLS_ISSUE
                  FROM                                         --ON_HAND  oh ,
                      RCV r,                                  --   ISSUE  isu,
                       apps.mtl_system_items_kfv msi,
                       apps.mtl_item_categories_v mic,
                       APPS.ORG_ORGANIZATION_DEFINITIONS OOD
                 WHERE     msi.organization_id = r.organization_id(+)
                       AND msi.inventory_item_id = r.inventory_item_id(+)
                       --and oh.organization_id(+) =isu.organization_id
                       --and oh.inventory_item_id(+) = isu.inventory_item_id
                       AND msi.organization_id = ood.organization_id
                       --  and oh.inventory_item_id(+) =msi.inventory_item_id
                       -- and oh.organization_id(+)=msi.organization_id
                       AND mic.organization_id = msi.organization_id
                       AND mic.inventory_item_id = msi.inventory_item_id
                       -- and msi.concatenated_segments='DRCT.H240.0930'
                       --AND mic.segment2 = 'HR COIL'
                       --and oh.organization_id =94--  in (94,95,96,97,98)
                       AND msi.organization_id NOT IN (90, 91, 685)
                --group by  mtp.organization_code, msi.concatenated_segments
                UNION
                SELECT 'ISU' TYP,
                       ood.operating_unit,
                       ood.organization_code,
                       ood.organization_id,
                       isu.subinventory_code,
                       msi.inventory_item_id,
                       msi.concatenated_segments item_code,
                       msi.description item_description,
                       msi.primary_uom_code uom,
                       mic.segment1 AS Item_Catg,
                       mic.segment2 Item_type,
                       DECODE (msi.attribute27,
                               'Foreign', 'Foreign',
                               'Local')
                          AS item_Source,
                       msi.attribute29 movement_status,
                       0 OPENING_QTY,
                       0 ITR_RCV,
                       0 PO_RECEVING,
                       0 PO_CORRECTION_RCV,
                       0 WIP_RETUN,
                       0 WIP_COMPLETION,
                       0 WIP_BY_PRODUCT_RCV,
                       0 PRA_RCV,
                       0 RMA_RCV,
                       0 DORG_RCV,
                       0 MISC_RCV,
                       NVL (ITR_ISSUE, 0) ITR_ISSUE,
                       NVL (MO_ISSUE, 0) MO_ISSUE,
                       NVL (NRG_ISSUE, 0) NRG_ISSUE,
                       NVL (RTV_ISSUE, 0) RTV_ISSUE,
                       NVL (PO_CORRCTION_ISSUE, 0) PO_CORRCTION_ISSUE,
                       NVL (MI2C_ISSUE, 0) MI2C_ISSUE,
                       NVL (WIPCR_ISSUE, 0) WIP_COMPLETION_RE_ISSUE,
                       NVL (WIP_ISSUE, 0) WIP_ISSUE,
                       NVL (WIPBR_ISSUE, 0) WIPBR_ISSUE,
                       NVL (PRA_ISSUE, 0) PRA_ISSUE,
                       NVL (DORG_ISSUE, 0) DORG_ISSUE,
                       NVL (MISC_ISSUE, 0) MISC_ISSUE,
                       NVL (SLS_ISSUE, 0) SLS_ISSUE
                  FROM                        --ON_HAND  oh ,      --  RCV r ,
                      ISSUE isu,
                       apps.mtl_system_items_kfv msi,
                       apps.mtl_item_categories_v mic,
                       APPS.ORG_ORGANIZATION_DEFINITIONS OOD
                 WHERE              --oh.organization_id (+)=r.organization_id
                           --and oh.inventory_item_id (+)= r.inventory_item_id
                           --and oh.organization_id(+) =isu.organization_id
                           --and oh.inventory_item_id(+) = isu.inventory_item_id
                           isu.organization_id = ood.organization_id
                       AND isu.inventory_item_id(+) = msi.inventory_item_id
                       AND isu.organization_id(+) = msi.organization_id
                       AND mic.organization_id = msi.organization_id
                       AND mic.inventory_item_id = msi.inventory_item_id
                       -- and msi.concatenated_segments='DRCT.H240.0930'
                       --AND mic.segment2 = 'HR COIL'
                       AND msi.organization_id NOT IN (90, 91, 685) --  in (94,95,96,97,98)
                --group by  mtp.organization_code, msi.concatenated_segments
                ORDER BY 1, 2)) A
 WHERE 
    a.OPERATING_UNIT = 84
    and a.ITEM_CATG  in ('FINISH GOODS')
--    and a.organization_code in ('SCP')---('CDY','DBR','DMY','DTN','DSY','DRP','DPT')
--    and a.item_catg in ('INGREDIENT','INDIRECT MATERIAL','LAB AND CHEMICAL','WIP','FINISH GOODS')
--    and a.item_catg='WIP'
--    and a.ITEM_TYPE like 'GIFT ITEM%'
--    and a.inventory_item_id=343390
    and a.ITEM_CODE in ('RMC0.3000.0005')
--    and a.organization_id=93
    and a.subinventory_code is not null