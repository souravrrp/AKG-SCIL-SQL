SELECT 
        rcvh.shipment_header_id source_document_id,
        pha.segment1 PO_NUMBER,
        rcvh.receipt_num,
--       CAT.NAME JE_CATEGORY,
       RCVT.TRANSACTION_ID VOUCHER_NUMBER,
       MST.INVENTORY_ITEM_ID,
       mcb.segment1 item_category,
       MST.DESCRIPTION INVENTORY_ITEM_NAME,
       XAL.ACCOUNTING_DATE,
       CC.SEGMENT1||'.'||
       CC.SEGMENT2||'.'||
       CC.SEGMENT3||'.'||
       CC.SEGMENT4||'.'||
       CC.SEGMENT5 ACCOUNT_CODE_COMBINATION,
       FLEX.DESCRIPTION ACCTDESC,
       XAL.accounting_class_code,
       sum(nvl(XAL.ACCOUNTED_DR,0)) DEBITS,
       sum(nvl(XAL.ACCOUNTED_CR,0)) CREDITS,
       sum(nvl(XAL.ACCOUNTED_DR,0))-sum(nvl(XAL.ACCOUNTED_CR,0)) Balance--,
--       ORG.ORGANIZATION_CODE,
--       MST.SEGMENT1 ITEM_CODE_SEGMENT1,
--       MST.SEGMENT2 ITEM_CODE_SEGMENT2,
--       MST.SEGMENT3 ITEM_CODE_SEGMENT3,
--       MST.DESCRIPTION INVENTORY_ITEM_NAME--,
--       MCB.SEGMENT1 ITEM_CATEGORY_SEGMENT1,
--       MCB.SEGMENT2 ITEM_CATEGORY_SEGMENT2,
--       RCVH.RECEIPT_NUM GOODS_RECEIPT_NUM
  FROM 
       apps.po_headers_all pha,
        apps.PO_LINES_ALL POL,
       apps.RCV_SHIPMENT_HEADERS RCVH,
       apps.RCV_TRANSACTIONS RCVT,
       apps.XLA_TRANSACTION_ENTITIES_UPG XATE,
       apps.XLA_EVENTS XAE,
       apps.XLA_DISTRIBUTION_LINKS XDL,
       apps.XLA_AE_LINES XAL,
       apps.XLA_AE_HEADERS XAH,
       apps.gl_import_references GIR,
       apps.gl_je_lines GJL,
       apps.gl_je_headers GJH,
       apps.gl_code_combinations cc,
       apps.FND_DOC_SEQUENCE_CATEGORIES CAT,
       apps.FND_FLEX_VALUES_VL FLEX,
       apps.MTL_SYSTEM_ITEMS_B MST,
       apps.ORG_ORGANIZATION_DEFINITIONS ORG,
       apps.MTL_CATEGORIES_B MCB,
       apps.MTL_ITEM_CATEGORIES MIC
 WHERE     
        pol.po_header_id=pha.po_header_id and
        POL.PO_LINE_ID = RCVT.PO_LINE_ID
        -----
        and pha.segment1='L/LSOU/028390'
--        and rcvh.receipt_num=1411
        -----
       AND RCVH.SHIPMENT_HEADER_ID = RCVT.SHIPMENT_HEADER_ID
       AND RCVT.TRANSACTION_ID = XATE.SOURCE_ID_INT_1
       AND XATE.ENTITY_ID = XAE.ENTITY_ID
       AND XDL.EVENT_ID = XAE.EVENT_ID
       AND XDL.source_distribution_type = 'RCV_RECEIVING_SUB_LEDGER'
       AND XDL.APPLICATION_ID = XAH.APPLICATION_ID
       AND XDL.APPLICATION_ID = 707
       AND XDL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XDL.AE_LINE_NUM = XAL.AE_LINE_NUM
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XAL.gl_sl_link_id = GIR.gl_sl_link_id
       AND GIR.gl_sl_link_table IN ('APECL', 'XLAJEL')
       AND GIR.je_header_id = GJL.je_header_id
       AND GIR.je_line_num = GJL.je_line_num
       AND GIR.je_header_id = GJH.je_header_id
       AND GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
       AND GJL.code_combination_id = cc.code_combination_id
       AND GJH.JE_CATEGORY = CAT.CODE
       AND CAT.APPLICATION_ID = 101
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND RCVT.ORGANIZATION_ID = MST.ORGANIZATION_ID
       AND POL.ITEM_ID = MST.INVENTORY_ITEM_ID
--       and mst.segment1||'.'||mst.segment2||'.'||mst.segment3 in ('FAN1.CELF.0006','PSTL.PFAN.0001')
       AND RCVT.ORGANIZATION_ID = ORG.ORGANIZATION_ID
       and org.organization_id=222
       AND MCB.STRUCTURE_ID = 101
       AND MCB.CATEGORY_ID = MIC.CATEGORY_ID
       AND MIC.INVENTORY_ITEM_ID = MST.INVENTORY_ITEM_ID
       AND MIC.ORGANIZATION_ID = MST.ORGANIZATION_ID
--       AND GJH.ACTUAL_FLAG = 'A'
--       AND GJL.STATUS = 'P'
--       and mcb.segment1 in ('ELECTRICAL EQUIPMENTS','ELECTRICAL INSTALLATION','FURNITURE & FIXTURES','PRODUCTION MACHINERY','SERVICE MACHINERY')
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
--       and RCVT.TRANSACTION_ID in ()
group by
            rcvh.shipment_header_id ,
            pha.segment1,
            rcvh.receipt_num,
--       CAT.NAME ,
       RCVT.TRANSACTION_ID ,
              mcb.segment1,
       MST.INVENTORY_ITEM_ID,
       XAL.ACCOUNTING_DATE,
       CC.SEGMENT1||'.'||
       CC.SEGMENT2||'.'||
       CC.SEGMENT3||'.'||
       CC.SEGMENT4||'.'||
       CC.SEGMENT5 ,
       FLEX.DESCRIPTION ,
       XAL.accounting_class_code,
       MST.DESCRIPTION        