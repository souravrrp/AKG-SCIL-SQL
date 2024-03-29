SELECT GJH.JE_SOURCE,
          GJH.JE_CATEGORY,
          CC2.SEGMENT1 COMPANY,
          CC2.SEGMENT2 COST_CENTER,
          CC2.SEGMENT3 ACCOUNT,
          CC2.SEGMENT4 INTER_PROJECT,
          CC2.SEGMENT5 FUTURE,
          FLEX.DESCRIPTION ACCTDESC,
          GJH.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
          GJH.DEFAULT_EFFECTIVE_DATE VOUCHER_DATE,
          GJH.PERIOD_NAME,
          GJL.DESCRIPTION,
          NVL (GJL.ENTERED_DR, 0) ENTERED_DR,
          NVL (GJL.ENTERED_CR, 0) ENTERED_CR,
          NVL (GJL.ACCOUNTED_DR, 0) ACCOUNTED_DR,
          NVL (GJL.ACCOUNTED_CR, 0) ACCOUNTED_CR,
          CC2.CHART_OF_ACCOUNTS_ID,
          GJH.LEDGER_ID,
          org.organization_id WAREHOUSE_ID,
          ORG.TYPE,
          org.name WAREHOUSE_NAME
     FROM apps.GL_JE_HEADERS GJH,
          APPS.GL_JE_LINES GJL,
          APPS.GL_CODE_COMBINATIONS CC1,
          apps.FND_FLEX_VALUES_VL FLEX,
          apps.FND_LOOKUP_VALUES_VL LV,
          apps.hr_all_organization_units org,
          apps.MTL_PARAMETERS mtlp,
          apps.gl_code_combinations cc2
    WHERE GJH.JE_HEADER_ID = GJL.JE_HEADER_ID
          AND (NVL (GJL.ACCOUNTED_DR, 0) <> 0
               OR NVL (GJL.ACCOUNTED_CR, 0) <> 0)
          AND CC2.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
          AND CC2.SEGMENT3 = LV.LOOKUP_CODE
          AND LV.LOOKUP_TYPE = 'XXAKG_DIST_COST_INCLUDE_COA'
          AND mtlp.organization_id = org.organization_id
          AND mtlp.MATERIAL_ACCOUNT = cc1.code_combination_id
          AND GJL.CODE_COMBINATION_ID = CC2.CODE_COMBINATION_ID
          AND CC1.SEGMENT1 = CC2.SEGMENT1
          AND CC1.SEGMENT2 = CC2.SEGMENT2
          AND GJH.JE_SOURCE <> 'Payables'
          AND CC2.SEGMENT1 = '2110'
          --AND org.TYPE IN ('GHAT')
          AND GJL.STATUS = 'P'
          AND GJH.ACTUAL_FLAG = 'A'
          AND GJH.PERIOD_NAME='JAN-18'
          AND CC2.SEGMENT3 ='4030103'
   UNION ALL
   SELECT GJH.JE_SOURCE,
          GJH.JE_CATEGORY,
          CC2.SEGMENT1 COMPANY,
          CC2.SEGMENT2 COST_CENTER,
          CC2.SEGMENT3 ACCOUNT,
          CC2.SEGMENT4 INTER_PROJECT,
          CC2.SEGMENT5 FUTURE,
          FLEX.DESCRIPTION ACCTDESC,
          API.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
          GJH.DEFAULT_EFFECTIVE_DATE VOUCHER_DATE,
          GJH.PERIOD_NAME,
          GJL.DESCRIPTION,
          NVL (GJL.ENTERED_DR, 0) ENTERED_DR,
          NVL (GJL.ENTERED_CR, 0) ENTERED_CR,
          NVL (GJL.ACCOUNTED_DR, 0) ACCOUNTED_DR,
          NVL (GJL.ACCOUNTED_CR, 0) ACCOUNTED_CR,
          CC2.CHART_OF_ACCOUNTS_ID,
          GJH.LEDGER_ID,
          org.organization_id WAREHOUSE_ID,
          ORG.TYPE,
          org.name WAREHOUSE_NAME
     FROM apps.AP_INVOICES_ALL API,
          XLA.XLA_TRANSACTION_ENTITIES XTE,
          apps.XLA_AE_HEADERS XAH,
          apps.XLA_AE_LINES XAL,
          apps.GL_IMPORT_REFERENCES GIR,
          apps.GL_JE_HEADERS GJH,
          apps.GL_JE_LINES GJL,
          apps.GL_CODE_COMBINATIONS CC1,
          apps.FND_FLEX_VALUES_VL FLEX,
          apps.FND_LOOKUP_VALUES_VL LV,
          apps.hr_all_organization_units org,
          apps.MTL_PARAMETERS mtlp,
          apps.gl_code_combinations cc2
    WHERE     API.INVOICE_ID = XTE.SOURCE_ID_INT_1
          AND API.SOURCE <> 'AKG TRIP INVOICE'
          AND API.INVOICE_NUM NOT LIKE 'MO/SCOU%'
          AND XTE.ENTITY_ID = XAH.ENTITY_ID
          AND XTE.ENTITY_CODE = 'AP_INVOICES'
          AND XTE.APPLICATION_ID = XAH.APPLICATION_ID
          AND XAH.APPLICATION_ID = 200
          AND XAH.APPLICATION_ID = XAL.APPLICATION_ID
          AND XAL.AE_HEADER_ID = XAH.AE_HEADER_ID
          AND XAL.GL_SL_LINK_ID = GIR.GL_SL_LINK_ID
          AND GIR.GL_SL_LINK_TABLE IN ('APECL', 'XLAJEL')
          AND GJH.JE_HEADER_ID = GIR.JE_HEADER_ID
          AND GJL.JE_HEADER_ID = GIR.JE_HEADER_ID
          AND GJL.JE_LINE_NUM = GIR.JE_LINE_NUM
          AND NVL (NVL (GJL.ACCOUNTED_DR, GJL.ACCOUNTED_CR), 0) <> 0
          AND CC2.SEGMENT3 = FLEX.FLEX_VALUE_MEANING
          AND CC2.SEGMENT3 = LV.LOOKUP_CODE
          AND LV.LOOKUP_TYPE = 'XXAKG_DIST_COST_INCLUDE_COA'
          AND mtlp.organization_id = org.organization_id
          AND mtlp.MATERIAL_ACCOUNT = cc1.code_combination_id
          AND GJL.CODE_COMBINATION_ID = CC2.CODE_COMBINATION_ID
          AND CC1.SEGMENT1 = CC2.SEGMENT1
          AND CC1.SEGMENT2 = CC2.SEGMENT2
          AND CC2.SEGMENT1 = '2110'
          --AND org.TYPE IN ('GHAT')
          AND GJL.STATUS = 'P'
          AND GJH.ACTUAL_FLAG = 'A'
          AND GJH.PERIOD_NAME='JAN-18'
          AND CC2.SEGMENT3 ='4030103';