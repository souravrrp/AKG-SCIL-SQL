SELECT 555 APPLICATION_ID,
       'INV' JE_SOURCE,
       NULL JE_CATEGORY,
       CC.SEGMENT1 COMPANY,
       CC.SEGMENT2 COST_CENTER,
       CC.SEGMENT3 ACCOUNT,
       CC.SEGMENT4 INTER_PROJECT,
       CC.SEGMENT5 FUTURE,
       FLEX.DESCRIPTION ACCTDESC,
       xdl.TRANSACTION_ID VOUCHER_NUMBER,
       xdl.batch_no,
       NULL GL_VOUCHER_NUMBER,
       NULL GL_JE_LINE_NUM,
       XAL.ACCOUNTING_DATE VOUCHER_DATE,
       NULL PARTICULARS,
       XAL.ENTERED_DR ENTERED_DR,
       XAL.ENTERED_CR ENTERED_CR,
       XAL.ACCOUNTED_DR ACCOUNTED_DR,
       XAL.ACCOUNTED_CR ACCOUNTED_CR,
       NULL CHEQUE_NUMBER,
       TRUNC (SYSDATE) CHEQUE_DATE,
       NULL PARTY_CODE,
       NULL PARTY_NAME,
       ENTITY_CODE TRANSACTION_TYPE,
       CC.CHART_OF_ACCOUNTS_ID,
       XAH.LEDGER_ID,
       NULL DFF_CONTEXT,
       NULL ATTRIBUTE1,
       NULL ATTRIBUTE2,
       NULL ATTRIBUTE3,
       NULL ATTRIBUTE4,
       NULL ATTRIBUTE5,
       NULL ORGANIZATION_ID,
       NULL ORGANIZATION_CODE,
       NULL ORGANIZATION_NAME,
       NULL INVENTORY_ITEM_ID,
       NULL ITEM_CODE_SEGMENT1,
       NULL ITEM_CODE_SEGMENT2,
       NULL ITEM_CODE_SEGMENT3,
       NULL INVENTORY_ITEM_NAME,
       NULL ITEM_CATEGORY_SEGMENT1,
       NULL ITEM_CATEGORY_SEGMENT2,
       NULL GOODS_RECEIPT_NUM
  FROM (  SELECT  /*+ parallel(geh, 20) parallel(gel, 20) parallel(xdl, 20) */
                XDL.APPLICATION_ID,
                 geh.organization_id,
                 geh.inventory_item_id,
                 geh.transaction_id,
                 gbh.batch_no,
                 xdl.AE_HEADER_ID,
                 xdl.ae_line_num,
                 GEH.ENTITY_CODE
            --round(sum(DECODE(SIGN(gel.accounted_amount), 1, gel.accounted_amount, 0, 0, '')), 2) accounted_dr,
            --round(sum(DECODE(SIGN(gel.accounted_amount), -1, gel.accounted_amount, 0, 0, '')), 2) accounted_cr
            FROM gmf.gmf_xla_extract_headers geh,
                 gmf.gmf_xla_extract_lines gel,
                 xla.XLA_DISTRIBUTION_LINKS xdl, gme.gme_batch_header gbh,
                 apps.org_organization_definitions ood
           WHERE     geh.header_id = gel.header_id
                 AND geh.event_id = gel.event_id
                 AND geh.EVENT_CLASS_CODE = 'BATCH_CLOSE'
                 AND geh.entity_code = 'PRODUCTION'
                 AND xdl.source_distribution_type = geh.entity_code
                 AND xdl.event_id = geh.event_id
                 AND xdl.source_distribution_id_num_1 = gel.line_id
                 AND xdl.APPLICATION_ID = 555 and geh.SOURCE_DOCUMENT_ID=gbh.batch_id and geh.transaction_date between '01-JAN-2015' and '31-JAN-2015' 
--                and  geh.TRANSACTION_ID in (484624,    484605,    484673,    484666,    484166,    483841,    484645,    484712,    483603,    483832,    483807,    484177,    484140,    483856,    483600,    484245,    483840,    484148,    484637,    484220,    484130,    484680,    483880,    483860,    484689,    483825,    483778,    483882,    483869,    483946,    484699,    483872,    483980,    484161,    484705,    483866,    484330,    484170,    484694,    484419,    484327,    483878,    483864,    484595,    484682,    484633,    484329,    484599,    484423,    484208,    484236,    483855,    483863,    484612,    484180,    484686,    484609,    484688,    483886,    483819,    484695,    484227,    484585,    484157,    483816,    483936,    484325,    483853,    483834,    484240,    483823,    483811,    484249,    484702,    484707,    484154,    484671,    483805,    484664,    484590,    484144,    484715,    484152,    484135,    484700,    484615,    484626,    484425,    484649,    484619,    483820,    484339,    484334,    483604,    484160,    484155,    483978,    484231,    484652,    483933,    484159,    483930,    484200,    484421,    484679,    484189,    484710,    484213,    484629,    483867,    483828,    484718,    484690,    484193)
--                and geh.organization_id in (99,113,100,444,101,201,606)
                   and geh.organization_id=ood.organization_id
                   and ood.legal_entity=23280
        GROUP BY XDL.APPLICATION_ID,
                 geh.organization_id,
                 geh.inventory_item_id,
                 geh.transaction_id,gbh.batch_no,
                 xdl.AE_HEADER_ID,
                 xdl.ae_line_num,
                 GEH.ENTITY_CODE) XDL,
       xla.XLA_AE_LINES XAL,
       xla.XLA_AE_HEADERS XAH,
       gl.gl_code_combinations cc,
       apps.FND_FLEX_VALUES_VL FLEX
 WHERE     XDL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XDL.AE_LINE_NUM = XAL.AE_LINE_NUM
       AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
       AND XAL.code_combination_id = cc.code_combination_id
       AND CC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
       AND (NVL (XAL.ACCOUNTED_DR, 0) <> 0 OR NVL (XAL.ACCOUNTED_CR, 0) <> 0)
