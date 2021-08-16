SELECT
        TO_CHAR (gl.VOUCHER_DATE, 'MON-YY') period,                                                               --    *
        ec.alloc_code,
         gl.je_source,
         gl.je_category,
         gl.company,
         gl.cost_center,
         gl.account,
         SUM (NVL (gl.debits, 0)) Dr,
         SUM (NVL (gl.credits, 0)) Cr,
         SUM (NVL (gl.debits, 0)) - SUM (NVL (gl.credits, 0)) Balance
    FROM apps.XXAKG_GL_DTL_DMV_2025 gl,                                     --
         -- apps.xxakg_gl_details_statement_mv gl,
         (SELECT DISTINCT gam.alloc_code,
                          gcc.segment1,
                          gcc.segment2,
                          gcc.segment3,
                          gcc.segment4
            FROM gmf.gl_aloc_mst gam,
                 gmf.gl_aloc_exp gae,
                 gl.gl_code_combinations gcc
           WHERE     
                    gam.legal_entity_id=23279
                    and gam.alloc_id = gae.alloc_id
                 AND gcc.code_combination_id = gae.from_account_id
                   AND gcc.segment3 <>'4030150'
                 AND gae.delete_mark = 0
                 AND gam.delete_mark = 0) ec
   WHERE     gl.ledger_id = 2025
         AND gl.company = ec.segment1
         AND gl.cost_center = ec.segment2
         AND gl.account = ec.segment3
         AND gl.inter_project = ec.segment4
         AND gl.je_source = 'INV'
         AND TO_CHAR (gl.VOUCHER_DATE, 'MON-YY') = 'APR-15'
GROUP BY 
        TO_CHAR (gl.VOUCHER_DATE, 'MON-YY'),
        ec.alloc_code,
         gl.je_source,
         gl.je_category,
         gl.company,
         gl.cost_center,
         gl.account;
