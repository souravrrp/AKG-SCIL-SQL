SELECT a.segment1, geh.ORGANIZATION_ID, to_char(b.effective_date,'MON-YYYY'), '01-'||to_char(b.effective_date,'MON-YYYY'), geh.inventory_item_id,SUM (NVL (d.accounted_dr, 0)), SUM (NVL (d.accounted_cr, 0))
    FROM gl.gl_code_combinations a,
         gl.gl_je_lines b,
         gl.gl_import_references c,
         xla.xla_ae_lines d,
         xla.xla_ae_headers e,
         xla.xla_transaction_entities f,
         apps.gmf_xla_extract_headers geh
   WHERE     a.segment3 in ( 2050107, 2050106) and a.segment1=2200
         AND b.effective_date BETWEEN :Fdate AND :Tdate
         AND e.application_id = 555
         AND a.code_combination_id = b.code_combination_id
         AND b.je_header_id = c.je_header_id
         AND b.je_line_num = c.je_line_num
         AND c.gl_sl_link_id = d.gl_sl_link_id
         AND d.ae_header_id = e.ae_header_id
         AND d.application_id = e.application_id
         AND e.application_id = f.application_id
         AND e.entity_id = f.entity_id
         and e.event_id = geh.event_id and e.ledger_id=geh.ledger_id
         and geh.inventory_item_id in ('24454'
,'24453')
        -- and geh.inventory_item_id=24409 -- and f.SOURCE_ID_INT_1=geh.transaction_id
GROUP BY  a.segment1,geh.ORGANIZATION_ID, to_char(b.effective_date,'MON-YYYY'),geh.inventory_item_id