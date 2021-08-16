/* Formatted on 7/25/2013 8:14:21 AM (QP5 v5.163.1008.3004) */
  SELECT 
         b.ITEM_NUMBER,
         a.item_category_segment1,
         a.voucher_number,
         b.SUBINVENTORY_CODE,
         b.TRANSACTION_SOURCE_TYPE,
         b.EVENT_TYPE_CODE,
         b.ORGANIZATION_ID,
--         decode(b.ORGANIZATION_ID,
--                    89,'AKCL',
--                    281,'TI2',
--                    362,'ACP') ORG_CODE,
         SUM (NVL(b.TXN_BASE_VALUE,0)) TXN_VALUE
    FROM 
    apps.xxakg_gl_details_statement_mv a, 
    GMF.GMF_TRANSACTION_VALUATION b
   WHERE     
         a.COMPANY = '2110'
         AND a.ACCOUNT IN (2050107)
         AND TRUNC (a.voucher_date) BETWEEN '01-MAY-2013' AND '31-MAY-2013'
         AND a.voucher_number = b.transaction_id
        and b.JOURNAL_LINE_TYPE='INV'
--        and b.EVENT_TYPE_CODE='MOVE_ORDER_ISSUE'
--    and b.item_number in ()
GROUP BY b.TRANSACTION_SOURCE_TYPE,
         b.EVENT_TYPE_CODE,
         b.ITEM_NUMBER,
         a.item_category_segment1,
         a.voucher_number,
         b.SUBINVENTORY_CODE,
         b.ORGANIZATION_ID
order by
    a.item_category_segment1         
         
--GIPE.PIPE.0001
         