SELECT d.alloc_code,
            segment1 company, 
            segment2 cost_center,
            segment3 Natural_acc,
            segment1|| '.'|| segment2|| '.'|| segment3|| '.'|| segment4|| '.'|| segment5 AS ovr_account,
         SUM (amount) Amount
    FROM apps.GL_ALOC_INP a,
         apps.gl_code_combinations gcc,
         apps.gl_aloc_exp c,
         apps.gl_aloc_mst d
   WHERE gcc.code_combination_id BETWEEN c.from_account_id AND c.to_account_id
         AND c.alloc_id = a.alloc_id
         AND c.alloc_id = d.alloc_id
         AND c.line_no = a.line_no
         AND calendar_code LIKE '%14'
         AND period_code = 7
         AND segment1 LIKE '2%'
         and segment3 not in ('4030150')
         --and segment1||'.'||segment2||'.'||segment3||'.'||segment4||'.'||segment5 =  '1160.CCLPD.4030706.9999.00'
         AND amount <> 0
GROUP BY d.alloc_code,
            segment1, 
            segment2,
            segment3,
            segment1|| '.'|| segment2|| '.'|| segment3|| '.'|| segment4|| '.'|| segment5;
