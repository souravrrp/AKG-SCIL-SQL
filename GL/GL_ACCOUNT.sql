SELECT   gb.period_name "Period Name"
        ,gb.period_year "Period Year"
        ,gb.period_num "Period Num"
--        ,gb.set_of_books_id "SOB ID"
        , gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4 "Account"
        ,gb.currency_code "Currency"
        ,SUM(gb.period_net_dr) "Period Net Dr"
        ,SUM(gb.period_net_cr) "Period Net Cr"
        ,SUM( (gb.period_net_dr - gb.period_net_cr) ) "PTD"
    FROM apps.gl_balances gb
        ,apps.gl_code_combinations gcc
   WHERE 1=1
--   and gb.set_of_books_id = 1 
   AND gb.currency_code = 'BDT' AND gcc.segment4 = '9999' AND gb.code_combination_id = gcc.code_combination_id
   and gb.period_year=2017
   and gb.period_name='OCT-17'
GROUP BY gb.period_name
        ,gb.period_year
        ,gb.period_num
--        ,gb.set_of_books_id
        , gcc.segment1 || '-' || gcc.segment2 || '-' || gcc.segment3 || '-' || gcc.segment4
        ,gb.currency_code
ORDER BY gb.period_year
        ,gb.period_num

SELECT      
      cc.concatenated_segments   "GL Account"
     ,cc.gl_account_type         "Account Type"
     ,nvl(sum(bal.begin_balance_dr - bal.begin_balance_cr),0)   "Begin Balance"
     ,bal.period_name            "Period Name"
FROM  apps.gl_code_combinations_kfv cc
     ,apps.gl_balances bal
WHERE cc.code_combination_id = bal.code_combination_id
AND   bal.period_name        = 'OCT-17'
AND   bal.LEDGER_ID    = 2025
GROUP BY
      cc.concatenated_segments
     ,cc.gl_account_type
     ,bal.period_name
ORDER by
      cc.concatenated_segments
      
      
      
SELECT
      cc.concatenated_segments   "GL Account"
     ,cc.gl_account_type         "Account Type"
     ,nvl(sum(bal.begin_balance_dr - bal.begin_balance_cr +
          bal.period_net_dr - bal.period_net_cr),0)  "Closing Balance"
     ,bal.period_name            "Period Name"
FROM  apps.gl_code_combinations_kfv cc
     ,apps.gl_balances bal
WHERE cc.code_combination_id = bal.code_combination_id
--AND   bal.period_name        = [Period Name]
--AND   bal.set_of_books_id    = [Set of Book ID]
GROUP BY
      cc.concatenated_segments
     ,cc.gl_account_type
     ,bal.period_name
ORDER BY
      cc.concatenated_segments
      