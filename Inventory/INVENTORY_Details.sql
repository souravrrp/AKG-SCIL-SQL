/* Formatted on 7/14/2019 6:17:50 PM (QP5 v5.287) */
  SELECT MMT.TRANSACTION_ID,
         MMT.REASON_ID,
         MMT.RCV_TRANSACTION_ID,
         MMT.TRX_SOURCE_LINE_ID,
         MTT.TRANSACTION_TYPE_NAME,
         MMT.TRANSACTION_SOURCE_ID,
         MMT.TRANSACTION_SOURCE_NAME,
         MC.SEGMENT1 ITEM_CATEGORY,
         MC.SEGMENT2 ITEM_TYPE,
         MMT.INVENTORY_ITEM_ID,
         MSI.SEGMENT1 || '.' || MSI.SEGMENT2 || '.' || MSI.SEGMENT3 ITEM_CODE,
         MSI.DESCRIPTION,
         --    msi.segment2 dia,
         MSI.PRIMARY_UOM_CODE,
         MSI.SECONDARY_UOM_CODE,
         MTLN.LOT_NUMBER,
         MMT.SHIPMENT_NUMBER,
         OOD1.ORGANIZATION_CODE,
         OOD2.ORGANIZATION_CODE TRANSFER_ORGANIZATION,
         MMT.SUBINVENTORY_CODE,
         MMT.TRANSFER_SUBINVENTORY,
         MIL.SEGMENT1 || '.' || MIL.SEGMENT2 || '.' || MIL.SEGMENT3
            ITEM_LOCATOR,
         MMT.TRANSACTION_DATE,
         MMT.DISTRIBUTION_ACCOUNT_ID,
            GCC.SEGMENT1
         || '.'
         || GCC.SEGMENT2
         || '.'
         || GCC.SEGMENT3
         || '.'
         || GCC.SEGMENT4
         || '.'
         || GCC.SEGMENT5
            DIST_ACC_CODE,
         MMT.TRANSACTION_REFERENCE,
         TO_CHAR (TRUNC (MMT.TRANSACTION_DATE), 'MON-YYYY') TXN_PERIOD,
         --    trunc(mmt.transaction_date) txn_date,
         --    mmt.transaction_quantity,
         MMT.PRIOR_COSTED_QUANTITY,
         MMT.PRIOR_COST,
         NVL (MTLN.PRIMARY_QUANTITY, MMT.PRIMARY_QUANTITY) PRIMARY_QTY,
         NVL (MTLN.TRANSACTION_QUANTITY, MMT.TRANSACTION_QUANTITY)
            TRANSACTION_QTY,
         MMT.TRANSACTION_UOM,
         NVL (MTLN.SECONDARY_TRANSACTION_QUANTITY,
              MMT.SECONDARY_TRANSACTION_QUANTITY)
            SECONDARY_TRANSACTION_QTY,
         APPS.FNC_GET_ITEM_COST (
            MMT.TRANSFER_ORGANIZATION_ID,
            MMT.INVENTORY_ITEM_ID,
            TO_CHAR (TRUNC (MMT.TRANSACTION_DATE), 'MON-YY'))
            DEST_ITEM_COST,
         APPS.FNC_GET_ITEM_COST (
            MMT.ORGANIZATION_ID,
            MMT.INVENTORY_ITEM_ID,
            TO_CHAR (TRUNC (MMT.TRANSACTION_DATE), 'MON-YY'))
            SOURCE_ITEM_COST,
         NVL (MMT.TRANSACTION_COST, MMT.ACTUAL_COST) TXN_COST,
         ABS (
              MMT.TRANSACTION_QUANTITY
            * NVL (MMT.TRANSACTION_COST, MMT.ACTUAL_COST))
            TRANSACTION_VALUE
            ,MTT.TRANSACTION_SOURCE_TYPE_ID
            --,MTRV.*
            --,MTRL.*
         --,WSH.SHIPMENT_PRIORITY_CODE
    FROM 
         INV.MTL_PARAMETERS MP,
         INV.MTL_MATERIAL_TRANSACTIONS MMT,
         INV.MTL_TRANSACTION_REASONS MTR,
         INV.MTL_TRANSACTION_LOT_NUMBERS MTLN,
         INV.MTL_SYSTEM_ITEMS_B MSI,
         INV.MTL_ITEM_CATEGORIES MIC,
         INV.MTL_CATEGORIES_B MC,
         INV.MTL_CATEGORY_SETS_B MCS,
         INV.MTL_TRANSACTION_TYPES MTT,
         INV.MTL_ITEM_LOCATIONS MIL,
         INV.MTL_TXN_REQUEST_HEADERS MTRH,
         INV.MTL_TXN_REQUEST_LINES MTRL,
         APPS.MTL_TXN_REQUEST_HEADERS_V MTRV,
         APPS.ORG_ORGANIZATION_DEFINITIONS OOD1,
         APPS.ORG_ORGANIZATION_DEFINITIONS OOD2,
         GL.GL_CODE_COMBINATIONS GCC
         --APPS.WSH_DELIVERABLES_V WSH
   WHERE     1 = 1
         --AND MMT.TRX_SOURCE_LINE_ID = WSH.SOURCE_LINE_ID(+)
         AND MP.ORGANIZATION_ID = MMT.ORGANIZATION_ID
         AND MTR.REASON_ID=MMT.REASON_ID
         AND MTRH.REQUEST_NUMBER=MTRV.REQUEST_NUMBER
         AND MMT.TRANSACTION_SOURCE_ID=MTRH.HEADER_ID
         AND MTRH.REQUEST_NUMBER=MMT.TRANSACTION_SOURCE_ID
         AND MTRL.LINE_ID=MMT.MOVE_ORDER_LINE_ID
         AND OOD1.OPERATING_UNIT=82
         AND MSI.INVENTORY_ITEM_ID = MMT.INVENTORY_ITEM_ID
         AND MSI.ORGANIZATION_ID = MMT.ORGANIZATION_ID
         AND OOD1.ORGANIZATION_ID = MMT.ORGANIZATION_ID
         --    and ood2.organization_code='G12'
         --    and mmt.organization_id in (1525)
         --    and ood1.organization_code in ('G09')
         AND MMT.TRANSACTION_TYPE_ID = MTT.TRANSACTION_TYPE_ID
         AND MMT.TRANSFER_ORGANIZATION_ID = OOD2.ORGANIZATION_ID(+)
         AND MSI.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID
         AND MSI.ORGANIZATION_ID = MIC.ORGANIZATION_ID
         AND MIC.CATEGORY_SET_ID=MCS.CATEGORY_SET_ID
         AND MIC.CATEGORY_SET_ID = 1
         AND MIC.CATEGORY_ID = MC.CATEGORY_ID
         AND MMT.TRANSACTION_ID = MTLN.TRANSACTION_ID(+)
         AND MMT.LOCATOR_ID = MIL.INVENTORY_LOCATION_ID(+)
         AND MMT.DISTRIBUTION_ACCOUNT_ID = GCC.CODE_COMBINATION_ID(+)
         --    and mmt.logical_transaction is null
         --    and mmt.transfer_subinventory in ('G27-STAGIN')--='W MLD LINE'
         --    and to_char(trunc(mmt.transaction_date),'MON-YY') in ('SEP-18')
         --    and to_char(trunc(mmt.transaction_date),'RRRR') in ('2018')
         --    and mmt.SHIPMENT_NUMBER='TO/SCOU/082666'
         --    and wsh.shipment_priority_code=:p_shipment_priority_code
         --    and mtt.TRANSACTION_TYPE_NAME in ('Sales Order Pick')
         --    and mtt.TRANSACTION_TYPE_NAME in ('Sales order issue')
         --    and mtt.transaction_type_name in ('Direct Org Transfer')
         --    and mtt.TRANSACTION_TYPE_NAME in ('Subinventory Transfer')
         --    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous receipt','Miscellaneous issue')
         --    and mtt.TRANSACTION_TYPE_NAME in ('Miscellaneous issue')
         --    and mtt.transaction_type_name in ('WIP Completion','WIP Completion Return')
         --    and mtt.transaction_type_name like ('RMA Receipt','RMA Return')
         --    and mtt.transaction_type_name in ('WIP Issue','WIP Return')
         --    and mtt.TRANSACTION_TYPE_NAME in ('COGS Recognition')
         --    and mtt.TRANSACTION_TYPE_NAME in ('Average cost update')
         --    and mmt.transaction_source_name in ('SCRAP_STOCK_RECEIVE_FOR_DELIVERY_JUNE_2018')
         --AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.OBAG.0001')
         --AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.SBAG.0001','CMNT.SBAG.0003','CMNT.PBAG.0001','CMNT.PBAG.0003','CMNT.OBAG.0001','CMNT.SBLK.0001','CMNT.PBLK.0001','CMNT.OBLK.0001','CMNT.CBAG.0001','CMNT.CBLK.0001','CMNT.CBAG.0003')
         --    and mmt.reason_id is null
         AND MTLN.LOT_NUMBER='2127709717'
         --    and mc.segment1 in ('WIP')
         --    and mc.segment1 in ('INGREDIENT')
         --    and mc.segment1 in ('FINISH GOODS')
         --    and mc.segment2 like '%GRINDING MEDIA%'
         --    and msi.segment1 in ('GPNF','GPCG')
         --    and upper(msi.description) like '%TYRE%MICRO%195%R%'
         --    and mmt.subinventory_code in ('CER-MOLD'%)
         --    and nvl(mtln.primary_quantity,mmt.primary_quantity)>0
         --    and mmt.primary_quantity<0
         --    and trunc(mmt.transaction_date)>'30-APR-2018'-- between '01-JAN-2016' and '31-OCT-2017'--'29-FEB-2016'--<'01-APR-2016'--<'01-JUL-2016'---<'01-JUL-2016'--='31-AUG-2016'--
         --    and wsh.shipment_priority_code='DO/SCOU/1194725'
         AND MMT.TRANSACTION_ID IN (114843252)
--    and gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5='2110.NUL.4020107.9999.00'
--    and mmt.transaction_source_id='10521203'
--    and mmt.trx_source_line_id=9103548
--    and msi.inventory_item_id='206571'
--    and mmt.transaction_type_id in (98,99)
--    and mtt.transaction_source_type_id=5
--    and  od1.legal_entity=ood2.legal_entity
--    and  ood1.legal_entity=23279
--    and mmt.transaction_type_id in (12,21)--105
--    and mmt.rcv_transaction_id in ()
--    and mmt.transaction_set_id in ()
ORDER BY MMT.TRANSACTION_ID, MMT.TRANSACTION_DATE