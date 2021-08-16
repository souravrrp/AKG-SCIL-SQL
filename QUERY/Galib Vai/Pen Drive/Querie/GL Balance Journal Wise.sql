/* Formatted on 7/21/2013 4:18:51 PM (QP5 v5.163.1008.3004) */
  SELECT
    *
--        a.je_header_id, 
--        a.je_source,
--         b.period_name,
--         SUM (NVL (b.accounted_dr, 0)) dr,
--         SUM (NVL (b.accounted_cr, 0)) cr,
--         SUM (NVL (b.accounted_dr, 0)) - SUM (NVL (b.accounted_cr, 0)) net,
--         b.GL_SL_LINK_ID
    FROM gl.gl_je_headers a, gl.gl_je_lines b, gl.gl_code_combinations c
   WHERE     a.je_header_id = b.je_header_id
--            and a.je_header_id =131713
         AND b.code_combination_id = c.code_combination_id
         AND c.segment1 = '2110'
--         AND c.segment3 = 2050101   -- RAW MATERIAL
--         AND c.segment3 = 2050104   -- FG
          AND c.segment3 = 2050107  -- STORES and  SPARES
--         AND TRUNC (b.effective_date) <= '30-JUN-2013'
            AND TRUNC (b.effective_date) between '01-JUL-2011' and '31-JUL-2013'
--         AND JE_SOURCE = 'Inventory'
--GROUP BY 
--    a.je_header_id,
--    a.je_source, 
--    b.period_name,b.GL_SL_LINK_ID

/*
    SUBLEDGER_DOC_SEQUENCE_VALUE
    SUM(NVL(ACCOUNTED_DR,0)) 
    SUM(NVL(ACCOUNTED_CR,0))
    PERIOD_NAME_1

    
*/


order by
    to_date(b.period_name,'MON-YY')