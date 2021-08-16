SELECT
GB.LEDGER_ID SETS_OF_BOOKS_ID,
GB.PERIOD_NAME,
GB.ACTUAL_FLAG,
DECODE(GB.ACTUAL_FLAG,'A', 'Actual',
                                           'B', 'Budget',
                                           'E', 'Encumbrance',
                                           'Not Defined') "ACTUAL_FLAG_MEANING",
nvl(sum(GB.begin_balance_dr - GB.begin_balance_cr),0)   "Begin Balance",
GB.PERIOD_NET_DR,
GB.PERIOD_NET_CR,
nvl(sum(GB.begin_balance_dr - GB.begin_balance_cr +
          GB.period_net_dr - GB.period_net_cr),0)  "Closing Balance",
GCCK.CONCATENATED_SEGMENTS ACCOUNT_CODE,
GCCK.GL_ACCOUNT_TYPE,
DECODE(GCCK.GL_ACCOUNT_TYPE,'A', 'Asset',
                                           'E', 'Expense',
                                           'L', 'Liability',
                                           'O', 'Owners Equity',
                                           'R', 'Revenue',
                                           'Not Defined') "Account_Type"
FROM
APPS.GL_CODE_COMBINATIONS_KFV GCCK,
APPS.GL_BALANCES GB
WHERE 1=1
AND GCCK.CODE_COMBINATION_ID=GB.CODE_COMBINATION_ID
AND GB.PERIOD_NAME='OCT-17'
AND GB.LEDGER_ID=2025
--AND GCCK.GL_ACCOUNT_TYPE='E'
--AND GCCK.CONCATENATED_SEGMENTS='2110.PSU.4030709.9999.00' 
GROUP BY 
GB.LEDGER_ID,
GB.PERIOD_NAME,
GB.ACTUAL_FLAG,
GB.ACTUAL_FLAG,
GCCK.CONCATENATED_SEGMENTS,
GCCK.GL_ACCOUNT_TYPE,
GB.PERIOD_NET_DR,
GB.PERIOD_NET_CR


SELECT
*
FROM
APPS.GL_CODE_COMBINATIONS
WHERE 1=1


SELECT
*
FROM
APPS.GL_BALANCES
WHERE 1=1


SELECT
GCCV.*
, decode(GL_ACCOUNT_TYPE,'A', 'Asset',
                                           'E', 'Expense',
                                           'L', 'Liability',
                                           'O', 'Owners Equity',
                                           'R', 'Revenue',
                                           'Not Defined') "Account Type"
FROM
APPS.GL_CODE_COMBINATIONS_KFV GCCV


SELECT
*
FROM
APPS.GL_SETS_OF_BOOKS

SELECT
*
FROM
APPS.gl_je_headers


APPS.GL_JE_BATCHES GJB


gl_je_headers gjh,
gl_je_lines gjl,
gl_ledgers gl,
gl_code_combinations gcc,
