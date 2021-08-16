SELECT DISTINCT gam.alloc_code,
                          gcc.segment1,
                          gcc.segment2,
                          gcc.segment3,
                          gcc.segment4,
                          gcc.segment5
            FROM gmf.gl_aloc_mst gam,
                 gmf.gl_aloc_exp gae,
                 gl.gl_code_combinations gcc
           WHERE     
                 gam.legal_entity_id=23280
--                 and gam.alloc_code='FACTORY_OVERHEAD_ALL'
                 and gam.alloc_id = gae.alloc_id
                 AND gcc.code_combination_id = gae.from_account_id
                 and gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 in ('2110.MESS.4030311.9999.00',
                 '2110.BML1.4032801.9999.00',
                 '2200.NUL.4030801.9999.00',
                 '2220.PROCS.4030801.9999.00',
                 '2110.PACKR.4032505.9999.00',
                 '2110.PSU.4032501.9999.00',
                 '2400.BATPK.4030403.9999.00')
                   AND gcc.segment3 <>'4030150'
                 AND gae.delete_mark = 0
                 AND gam.delete_mark = 0
--                 and rownum=1