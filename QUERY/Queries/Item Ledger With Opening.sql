
SELECT TYP,
       OPERATING_UNIT,
       ORGANIZATION_CODE,
       ORGANIZATION_ID,
       SUBINVENTORY_CODE,
       INVENTORY_ITEM_ID,
       ITEM_CODE,
       ITEM_DESCRIPTION,
       P_UOM,
       S_UOM,
       ITEM_CATG,
       ITEM_TYPE,
       ITEM_SOURCE,
       OPENING_QTY,
       S_OPENING_QTY,
       ITR_RCV,
       S_ITR_RCV,
       PO_RECEVING,
       S_PO_RECEVING,
       PO_CORRECTION_RCV,
       S_PO_CORRECTION_RCV,
       WIP_RETUN,
       S_WIP_RETUN,
       WIP_COMPLETION,
       S_WIP_COMPLETION,
       WIP_BY_PRODUCT_RCV,
       S_WIP_BY_PRODUCT_RCV,
       PRA_RCV,
       S_PRA_RCV,
       RMA_RCV,
       S_RMA_RCV,
       DORG_RCV,
       S_DORG_RCV,
       MISC_RCV,
       S_MISC_RCV,
       ITR_ISSUE,
       S_ITR_ISSUE,
       MO_ISSUE,
       S_MO_ISSUE,
       NRG_ISSUE,
       S_NRG_ISSUE,
       RTV_ISSUE,
       S_RTV_ISSUE,
       PO_CORRCTION_ISSUE,
       S_PO_CORRCTION_ISSUE,
       MI2C_ISSUE,
       S_MI2C_ISSUE,
       WIP_COMPLETION_RE_ISSUE,
       S_WIP_COMPLETION_RE_ISSUE,
       WIP_ISSUE,
       S_WIP_ISSUE,
       WIPBR_ISSUE,
       S_WIPBR_ISSUE,
       PRA_ISSUE,
       S_PRA_ISSUE,
       DORG_ISSUE,
       S_DORG_ISSUE,
       MISC_ISSUE,
       S_MISC_ISSUE,
       SLS_ISSUE,
       S_SLS_ISSUE
  --       apps.fnc_get_item_cost (
  --          organization_id,
  --          inventory_item_id,
  --          TO_CHAR (
  --             TO_DATE ('VALUEOF(NQ_SESSION.P_DAT_FRM_IL)', 'YYYY-MM-DD'),
  --             'MON-RR'))
  --          current_cost,
  --       apps.fnc_get_item_cost (
  --          organization_id,
  --          inventory_item_id,
  --          DECODE (
  --             TO_CHAR (
  --                TO_DATE ('VALUEOF(NQ_SESSION.P_DAT_FRM_IL)', 'YYYY-MM-DD'),
  --                'DD'),
  --             '01',
  --             TO_CHAR (
  --                TO_DATE ('VALUEOF(NQ_SESSION.P_DAT_FRM_IL)', 'YYYY-MM-DD')
  --                - 1,
  --                'MON-RR'),
  --             TO_CHAR (
  --                TO_DATE ('VALUEOF(NQ_SESSION.P_DAT_FRM_IL)', 'YYYY-MM-DD'),
  --                'MON-RR')))
  --          OPN_COST
  FROM (WITH ON_HAND
                AS (  SELECT oq.organization_id,
                             oq.subinventory_code,
                             oq.inventory_item_id,
                             SUM (target_qty) op_qty,
                             SUM (s_target_qty) s_op_qty
                        FROM (  SELECT organization_id,
                                       subinventory_code,
                                       inventory_item_id,
                                       SUM (primary_transaction_quantity)
                                          target_qty,
                                       SUM (SECONDARY_TRANSACTION_QUANTITY)
                                          s_target_qty
                                  FROM apps.mtl_onhand_quantities_detail moq
                              GROUP BY organization_id,
                                       subinventory_code,
                                       inventory_item_id
                              UNION
                                SELECT organization_id,
                                       subinventory_code,
                                       inventory_item_id,
                                       -SUM (primary_quantity) target_qty,
                                       -SUM (SECONDARY_TRANSACTION_QUANTITY) s_target_qty
                                  FROM apps.mtl_material_transactions mmt
                                 WHERE 
                                    transaction_date >=NVL (:p_date_from-1,SYSDATE)
                                    AND (mmt.Logical_Transaction = 2 OR mmt.Logical_Transaction IS NULL)
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
                             SUM(DECODE (transaction_type_id,12,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) ITR_RCV,
                             SUM(DECODE (transaction_type_id,12,DECODE (SIGN (mmt.secondary_transaction_quantity),1,mmt.secondary_transaction_quantity))) S_ITR_RCV,
                             SUM(DECODE (transaction_type_id,18,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) PO_RCV,
                             SUM(DECODE (transaction_type_id,18,DECODE (SIGN (mmt.secondary_transaction_quantity),1,mmt.secondary_transaction_quantity))) S_PO_RCV,
                             SUM(DECODE (transaction_type_id,71,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) PO_CORRECTION_RCV,
                             SUM(DECODE (transaction_type_id,71,DECODE (SIGN (mmt.secondary_transaction_quantity),1,mmt.secondary_transaction_quantity))) S_PO_CORRECTION_RCV,
                             SUM(DECODE (transaction_type_id,43,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) WIPR_RCV,
                             SUM(DECODE (transaction_type_id,43,DECODE (SIGN (mmt.secondary_transaction_quantity),1,mmt.secondary_transaction_quantity))) S_WIPR_RCV,
                             SUM(DECODE (transaction_type_id,44,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) WIP_RCV,
                             SUM(DECODE (transaction_type_id,44,DECODE (SIGN (mmt.secondary_transaction_quantity),1,mmt.secondary_transaction_quantity))) S_WIP_RCV,
                             SUM(DECODE (transaction_type_id,1002,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) WIPBP_RCV,
                             SUM(DECODE (transaction_type_id,1002,DECODE (SIGN (mmt.secondary_transaction_quantity),1,mmt.secondary_transaction_quantity))) S_WIPBP_RCV,
                             SUM(DECODE (transaction_type_id,8,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) PRA_RCV,
                             SUM(DECODE (transaction_type_id,8,DECODE (SIGN (mmt.secondary_transaction_quantity),1,mmt.secondary_transaction_quantity))) S_PRA_RCV,
                             SUM(DECODE (transaction_type_id,15,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) RMA_RCV,
                             SUM(DECODE (transaction_type_id,15,DECODE (SIGN (mmt.secondary_transaction_quantity),1,secondary_transaction_quantity))) S_RMA_RCV,
                             SUM(DECODE (transaction_type_id,3,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) DORG_RCV,
                             SUM(DECODE (transaction_type_id,3,DECODE (SIGN (mmt.secondary_transaction_quantity),1,secondary_transaction_quantity))) S_DORG_RCV,
                             SUM(DECODE (transaction_type_id,42,DECODE (SIGN (mmt.transaction_quantity),1, primary_quantity))) MISC_RCV,
                             SUM(DECODE (transaction_type_id,42,DECODE (SIGN (mmt.secondary_transaction_quantity),1,mmt.secondary_transaction_quantity))) S_MISC_RCV
                        FROM apps.mtl_material_transactions mmt
                       WHERE transaction_date BETWEEN 
--                                    NVL (TO_DATE (:p_date_from),SYSDATE) AND TO_DATE (:p_date_to) + .9999
                                        trunc(nvl(:p_date_from,sysdate)) and trunc(:p_date_to)
                             AND (mmt.Logical_Transaction = 2 OR mmt.Logical_Transaction IS NULL)
                    GROUP BY organization_id,
                             subinventory_code,
                             inventory_item_id),
             ISSUE
                AS (  SELECT organization_id,
                             subinventory_code,
                             inventory_item_id,
                             SUM(DECODE (transaction_type_id,21,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) ITR_ISSUE,
                             SUM(DECODE (transaction_type_id,21,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_ITR_ISSUE,
                             SUM(DECODE (transaction_type_id,63,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) MO_ISSUE,
                             SUM(DECODE (transaction_type_id,63,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_MO_ISSUE,
                             SUM(DECODE (transaction_type_id,101,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) NRG_ISSUE,
                             SUM(DECODE (transaction_type_id,101,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_NRG_ISSUE,
                             SUM(DECODE (transaction_type_id,36,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) RTV_ISSUE,
                             SUM(DECODE (transaction_type_id,36,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_RTV_ISSUE,
                             SUM(DECODE (transaction_type_id,71,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) PO_CORRCTION_ISSUE,
                             SUM(DECODE (transaction_type_id,71,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_PO_CORRCTION_ISSUE,
                             SUM(DECODE (transaction_type_id,105,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) MI2C_ISSUE,
                             SUM(DECODE (transaction_type_id,105,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_MI2C_ISSUE,
                             SUM(DECODE (transaction_type_id,17,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) WIPCR_ISSUE,
                             SUM(DECODE (transaction_type_id,17,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_WIPCR_ISSUE,
                             SUM(DECODE (transaction_type_id,35,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) WIP_ISSUE,
                             SUM(DECODE (transaction_type_id,35,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_WIP_ISSUE,
                             SUM(DECODE (transaction_type_id,1003,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) WIPBR_ISSUE,
                             SUM(DECODE (transaction_type_id,1003,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_WIPBR_ISSUE,
                             SUM(DECODE (transaction_type_id,8,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) PRA_ISSUE,
                             SUM(DECODE (transaction_type_id,8,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_PRA_ISSUE,
                             SUM(DECODE (transaction_type_id,3,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) DORG_ISSUE,
                             SUM(DECODE (transaction_type_id,3,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_DORG_ISSUE,
                             SUM(DECODE (transaction_type_id,32,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) MISC_ISSUE,
                             SUM(DECODE (transaction_type_id,32,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_MISC_ISSUE,
                             SUM(DECODE (transaction_type_id,33,DECODE (SIGN (mmt.transaction_quantity),-1, primary_quantity))) SLS_ISSUE,
                             SUM(DECODE (transaction_type_id,33,DECODE (SIGN (mmt.secondary_transaction_quantity),-1,mmt.secondary_transaction_quantity))) S_SLS_ISSUE
                        FROM apps.mtl_material_transactions mmt
                       WHERE transaction_date BETWEEN 
--                              NVL (TO_DATE (:p_date_from),SYSDATE) AND  TO_DATE (:p_date_to)+ .9999
                                trunc(nvl(:p_date_from,sysdate)) and trunc(:p_date_to)
                             AND (mmt.Logical_Transaction = 2 OR mmt.Logical_Transaction IS NULL)
                    --TO_DATE('VALUEOF(NQ_SESSION.P_DAT_FRM_IL)','YYYY-MM-DD')  and  TO_DATE('VALUEOF(NQ_SESSION.P_DAT_TO_IL)','YYYY-MM-DD')+1
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
               msi.primary_uom_code p_uom,
               msi.secondary_uom_code s_uom,
               mic.segment1 AS Item_Catg,
               mic.segment2 Item_type,
               DECODE (msi.attribute27, 'Foreign', 'Foreign', 'Local')
                  AS item_Source,
               NVL (oh.op_qty, 0) OPENING_QTY,
               NVL (oh.s_op_qty, 0) S_OPENING_QTY,
               0 ITR_RCV,
               0 S_ITR_RCV,
               0 PO_RECEVING,
               0 S_PO_RECEVING,
               0 PO_CORRECTION_RCV,
               0 S_PO_CORRECTION_RCV,
               0 WIP_RETUN,
               0 S_WIP_RETUN,
               0 WIP_COMPLETION,
               0 S_WIP_COMPLETION,
               0 WIP_BY_PRODUCT_RCV,
               0 S_WIP_BY_PRODUCT_RCV,
               0 PRA_RCV,
               0 S_PRA_RCV,
               0 RMA_RCV,
               0 S_RMA_RCV,
               0 DORG_RCV,
               0 S_DORG_RCV,
               0 MISC_RCV,
               0 S_MISC_RCV,
               0 ITR_ISSUE,
               0 S_ITR_ISSUE,
               0 MO_ISSUE,
               0 S_MO_ISSUE,
               0 NRG_ISSUE,
               0 S_NRG_ISSUE,
               0 RTV_ISSUE,
               0 S_RTV_ISSUE,
               0 PO_CORRCTION_ISSUE,
               0 S_PO_CORRCTION_ISSUE,
               0 MI2C_ISSUE,
               0 S_MI2C_ISSUE,
               0 WIP_COMPLETION_RE_ISSUE,
               0 S_WIP_COMPLETION_RE_ISSUE,
               0 WIP_ISSUE,
               0 S_WIP_ISSUE,
               0 WIPBR_ISSUE,
               0 S_WIPBR_ISSUE,
               0 PRA_ISSUE,
               0 S_PRA_ISSUE,
               0 DORG_ISSUE,
               0 S_DORG_ISSUE,
               0 MISC_ISSUE,
               0 S_MISC_ISSUE,
               0 SLS_ISSUE,
               0 S_SLS_ISSUE
          FROM ON_HAND oh,                      --  RCV r ,        ISSUE  isu,
               apps.mtl_system_items_kfv msi,
               apps.mtl_item_categories_v mic,
               APPS.ORG_ORGANIZATION_DEFINITIONS OOD
         WHERE                      --oh.organization_id (+)=r.organization_id
                   --and oh.inventory_item_id (+)= r.inventory_item_id
                   --and oh.organization_id(+) =isu.organization_id
                   --and oh.inventory_item_id(+) = isu.inventory_item_id
                   oh.organization_id = ood.organization_id
               AND oh.inventory_item_id(+) = msi.inventory_item_id
               AND oh.organization_id(+) = msi.organization_id
               AND mic.organization_id = msi.organization_id
               AND mic.inventory_item_id = msi.inventory_item_id
               AND msi.concatenated_segments = 'DRCT.CLNK.0001'
               --     AND mic.segment2 = 'HR COIL'
               AND msi.organization_id = 101            --  in (94,95,96,97,98)
               AND msi.organization_id not in (90,91)
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
               msi.primary_uom_code p_uom,
               msi.secondary_uom_code s_uom,
               mic.segment1 AS Item_Catg,
               mic.segment2 Item_type,
               DECODE (msi.attribute27, 'Foreign', 'Foreign', 'Local')
                  AS item_Source,
               0 OPENING_QTY,
               0 S_OPENING_QTY,
               NVL(ITR_RCV,0) ITR_RCV,
               NVL(S_ITR_RCV,0) S_ITR_RCV,
               NVL (PO_RCV, 0) PO_RECEVING,
               NVL (S_PO_RCV, 0) S_PO_RECEVING,
               NVL (PO_CORRECTION_RCV, 0) PO_CORRECTION_RCV,
               NVL (S_PO_CORRECTION_RCV, 0) S_PO_CORRECTION_RCV,
               NVL (WIPR_RCV, 0) WIP_RETUN,
               NVL (S_WIPR_RCV, 0) S_WIP_RETUN,
               NVL (WIP_RCV, 0) WIP_COMPLETION,
               NVL (S_WIP_RCV, 0) WIP_COMPLETION,
               NVL (WIPBP_RCV, 0) WIP_BY_PRODUCT_RCV,
               NVL (S_WIPBP_RCV, 0) WIP_BY_PRODUCT_RCV,
               NVL (PRA_RCV, 0) PRA_RCV,
               NVL (S_PRA_RCV, 0) S_PRA_RCV,
               NVL (RMA_RCV, 0) RMA_RCV,
               NVL (S_RMA_RCV, 0) S_RMA_RCV,
               NVL (DORG_RCV, 0) DORG_RCV,
               NVL (S_DORG_RCV, 0) S_DORG_RCV,
               NVL (MISC_RCV, 0) MISC_RCV,
               NVL (S_MISC_RCV, 0) S_MISC_RCV,
               0 ITR_ISSUE,
               0 S_ITR_ISSUE,
               0 MO_ISSUE,
               0 S_MO_ISSUE,
               0 NRG_ISSUE,
               0 S_NRG_ISSUE,
               0 RTV_ISSUE,
               0 S_RTV_ISSUE,
               0 PO_CORRCTION_ISSUE,
               0 S_PO_CORRCTION_ISSUE,
               0 MI2C_ISSUE,
               0 S_MI2C_ISSUE,
               0 WIP_COMPLETION_RE_ISSUE,
               0 S_WIP_COMPLETION_RE_ISSUE,
               0 WIP_ISSUE,
               0 S_WIP_ISSUE,
               0 WIPBR_ISSUE,
               0 S_WIPBR_ISSUE,
               0 PRA_ISSUE,
               0 S_PRA_ISSUE,
               0 DORG_ISSUE,
               0 S_DORG_ISSUE,
               0 MISC_ISSUE,
               0 S_MISC_ISSUE,
               0 SLS_ISSUE,
               0 S_SLS_ISSUE
          FROM                                                 --ON_HAND  oh ,
              RCV r,                                          --   ISSUE  isu,
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
               AND msi.concatenated_segments = 'DRCT.CLNK.0001'
               --AND mic.segment2 = 'HR COIL'
               AND msi.organization_id = 101            --  in (94,95,96,97,98)
               AND msi.organization_id not in (90,91)
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
               msi.primary_uom_code p_uom,
               msi.secondary_uom_code s_uom,
               mic.segment1 AS Item_Catg,
               mic.segment2 Item_type,
               DECODE (msi.attribute27, 'Foreign', 'Foreign', 'Local')
                  AS item_Source,
               0 OPENING_QTY,
               0 S_OPENING_QTY,
               0 ITR_RCV,
               0 S_ITR_RCV,
               0 PO_RECEVING,
               0 S_PO_RECEVING,
               0 PO_CORRECTION_RCV,
               0 S_PO_CORRECTION_RCV,
               0 WIP_RETUN,
               0 S_WIP_RETUN,
               0 WIP_COMPLETION,
               0 S_WIP_COMPLETION,
               0 WIP_BY_PRODUCT_RCV,
               0 S_WIP_BY_PRODUCT_RCV,
               0 PRA_RCV,
               0 S_PRA_RCV,
               0 RMA_RCV,
               0 S_RMA_RCV,
               0 DORG_RCV,
               0 S_DORG_RCV,
               0 MISC_RCV,
               0 S_MISC_RCV,
               NVL(ITR_ISSUE,0) ITR_ISSUE,
               NVL(S_ITR_ISSUE,0) S_ITR_ISSUE,
               NVL (MO_ISSUE, 0) MO_ISSUE,
               NVL (S_MO_ISSUE, 0) S_MO_ISSUE,
               NVL (NRG_ISSUE, 0) NRG_ISSUE,
               NVL (S_NRG_ISSUE, 0) S_NRG_ISSUE,
               NVL (RTV_ISSUE, 0) RTV_ISSUE,
               NVL (S_RTV_ISSUE, 0) S_RTV_ISSUE,
               NVL (PO_CORRCTION_ISSUE, 0) PO_CORRCTION_ISSUE,
               NVL (S_PO_CORRCTION_ISSUE, 0) S_PO_CORRCTION_ISSUE,
               NVL (MI2C_ISSUE, 0) MI2C_ISSUE,
               NVL (S_MI2C_ISSUE, 0) S_MI2C_ISSUE,
               NVL (WIPCR_ISSUE, 0) WIP_COMPLETION_RE_ISSUE,
               NVL (S_WIPCR_ISSUE, 0) S_WIP_COMPLETION_RE_ISSUE,
               NVL (WIP_ISSUE, 0) WIP_ISSUE,
               NVL (S_WIP_ISSUE, 0) S_WIP_ISSUE,
               NVL (WIPBR_ISSUE, 0) WIPBR_ISSUE,
               NVL (S_WIPBR_ISSUE, 0) S_WIPBR_ISSUE,
               NVL (PRA_ISSUE, 0) PRA_ISSUE,
               NVL (S_PRA_ISSUE, 0) S_PRA_ISSUE,
               NVL (DORG_ISSUE, 0) DORG_ISSUE,
               NVL (S_DORG_ISSUE, 0) S_DORG_ISSUE,
               NVL (MISC_ISSUE, 0) MISC_ISSUE,
               NVL (S_MISC_ISSUE, 0) MISC_ISSUE,
               NVL (SLS_ISSUE, 0) SLS_ISSUE,
               NVL (S_SLS_ISSUE, 0) S_SLS_ISSUE
          FROM                                --ON_HAND  oh ,      --  RCV r ,
              ISSUE isu,
               apps.mtl_system_items_kfv msi,
               apps.mtl_item_categories_v mic,
               APPS.ORG_ORGANIZATION_DEFINITIONS OOD
         WHERE                      --oh.organization_id (+)=r.organization_id
                   --and oh.inventory_item_id (+)= r.inventory_item_id
                   --and oh.organization_id(+) =isu.organization_id
                   --and oh.inventory_item_id(+) = isu.inventory_item_id
                   isu.organization_id = ood.organization_id
               AND isu.inventory_item_id(+) = msi.inventory_item_id
               AND isu.organization_id(+) = msi.organization_id
               AND mic.organization_id = msi.organization_id
               AND mic.inventory_item_id = msi.inventory_item_id
               AND msi.concatenated_segments = 'DRCT.CLNK.0001'
               --AND mic.segment2 = 'HR COIL'
               AND msi.organization_id not in (90,91)
               AND msi.organization_id = 101            --  in (94,95,96,97,98)
        ORDER BY 1, 2)
