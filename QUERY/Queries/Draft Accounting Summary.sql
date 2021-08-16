/* Formatted on 7/16/2013 9:50:19 AM (QP5 v5.163.1008.3004) */
  SELECT COMPANY,
         COST_CENTER,
         ACCOUNT,
         INTER_PROJECT,
         FUTURE,
         ACCTDESC,
         SUM (NVL (debits, 0)) DEBIT,
         SUM (NVL (credits, 0)) CREDIT,
         SUM (NVL (debits, 0))-SUM (NVL (credits, 0)) BALANCE
    FROM APPS.XXAKG_GL_DETAILS_STATEMENT_DMV
   WHERE     --application_id = 555
          ledger_id = 2025
         AND voucher_date BETWEEN '01-JUL-2010' AND '31-JUL-2013'
          AND account='2050107'
--             and company=2110 --SCIL
         --    and company=2120 --SCPL
         --and company=2200 --CERAMIC
         --and company=2300 --AKCL
--         AND company = 2400                                               --RM
GROUP BY company,
         COST_CENTER,
         ACCOUNT,
         INTER_PROJECT,
         FUTURE,
         ACCTDESC
--having sum(nvl(debits,0))-sum(nvl(credits,0))  <>0