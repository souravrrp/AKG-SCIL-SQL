/* Formatted on 7/15/2013 2:05:32 PM (QP5 v5.163.1008.3004) */
  SELECT 
        A.organization_id Source_org,
        A.TRANSFER_ORGANIZATION_ID Dest_Org,       
        SUM (A.TRANSACTION_QUANTITY) TXN_QTY,
         A.SHIPMENT_NUMBER,
         a.TRANSACTION_ID,
         TO_CHAR (A.TRansaction_date, 'DD_MON_YYYY') TR_date
    FROM INV.MTL_MATERIAL_TRANSACTIONS A
   WHERE     
            A.organization_id = 102
         AND A.TRANSACTION_TYPE_ID = 21
--         AND A.INVENTORY_ITEM_ID = 24409
         AND A.TRANSFER_ORGANIZATION_ID = 101
--    A.TRansaction_date < '01-NOV-2013' --and
    and A.SHIPMENT_NUMBER in ('ITR/PRT/2674')
GROUP BY 
     A.organization_id,
        A.TRANSFER_ORGANIZATION_ID,
        A.SHIPMENT_NUMBER,
         a.TRANSACTION_ID,
         TO_CHAR (A.TRansaction_date, 'DD_MON_YYYY')
  HAVING SUM (A.TRANSACTION_QUANTITY) <> 0

/* Formatted on 7/15/2013 2:06:02 PM (QP5 v5.163.1008.3004) */
---PRT - SCI
  SELECT
        C.SEGMENT1||'.'||C.SEGMENT2||'.'||C.SEGMENT3 ItemCode, 
        SUM (B.TRANSACTION_QUANTITY) TXN_QTY,
         B.SHIPMENT_NUMBER,
         B.TRANSFER_TRANSACTION_ID,
         TO_CHAR (b.TRansaction_date, 'DD-MON-YYYY') TXN_DATE
    FROM INV.MTL_MATERIAL_TRANSACTIONS b,
             INV.MTL_SYSTEM_ITEMS_B c
   WHERE     B.organization_id = 101
         AND B.TRANSACTION_TYPE_ID = 12
--         AND B.INVENTORY_ITEM_ID = 24409
         AND B.TRANSFER_ORGANIZATION_ID = 102 ---PRT
--        AND B.TRANSFER_ORGANIZATION_ID = 524 ---PSU
         and B.INVENTORY_ITEM_ID=C.INVENTORY_ITEM_ID
         and trunc(b.TRansaction_date) between ('01-OCT-2013') and ('31-OCT-2013')
GROUP BY 
         C.SEGMENT1,C.SEGMENT2,C.SEGMENT3,
         B.SHIPMENT_NUMBER,
         B.TRANSFER_TRANSACTION_ID,
         TO_CHAR (b.TRansaction_date, 'DD-MON-YYYY')
  HAVING SUM (B.TRANSACTION_QUANTITY) <> 0
  
  
  
-- PSU - SCI  
SELECT SUM (B.TRANSACTION_QUANTITY),
         B.SHIPMENT_NUMBER,
         B.TRANSFER_TRANSACTION_ID,
         TO_CHAR (b.TRansaction_date, 'DD_MON_YYYY') TR_date
    FROM INV.MTL_MATERIAL_TRANSACTIONS b
   WHERE     B.organization_id = 113
         AND B.TRANSACTION_TYPE_ID = 12
         AND B.INVENTORY_ITEM_ID = 24409
         AND B.TRANSFER_ORGANIZATION_ID = 101
         and b.TRansaction_date between to_date('01-JUN-2013','DD-MON-YYYY') and to_date('30-JUN-2013','DD-MON-YYYY')
GROUP BY B.SHIPMENT_NUMBER,
         B.TRANSFER_TRANSACTION_ID,
         TO_CHAR (b.TRansaction_date, 'DD_MON_YYYY')
  HAVING SUM (B.TRANSACTION_QUANTITY) <> 0  
  
  
  
select 
--    rt.*,
    rsh.SHIPMENT_NUM,
    rt.TRANSACTION_TYPE,
    rt.COMMENTS,
    rsh.receipt_num,
    rt.SUBINVENTORY,
    sum(NVL(QUANTITY,0)) RCV_QTY
from 
    apps.rcv_shipment_headers rsh,
    apps.rcv_transactions rt
where 
    rsh.shipment_header_id=rt.shipment_header_id
    and rt.TRANSACTION_TYPE='CORRECT'
    and rsh.receipt_num is not null
    and rsh.SHIPMENT_NUM like 'ITR/PRT%'--in ('ITR/PRT/2674')
group by
    rsh.SHIPMENT_NUM,
    rt.COMMENTS,
    rt.TRANSACTION_TYPE,
    rsh.receipt_num,
    rt.SUBINVENTORY
order by 1


rownuM<10  