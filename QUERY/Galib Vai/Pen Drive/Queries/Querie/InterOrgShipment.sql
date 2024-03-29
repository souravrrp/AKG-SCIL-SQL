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
--            A.organization_id = 102
--         AND A.TRANSACTION_TYPE_ID = 21
--         AND A.INVENTORY_ITEM_ID = 24409
--         AND A.TRANSFER_ORGANIZATION_ID = 101
    A.TRansaction_date < '01-NOV-2013' --and
--    A.SHIPMENT_NUMBER in ()
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
    rt.COMMENTS,
    rsh.receipt_num,
    rt.SUBINVENTORY,
    sum(NVL(QUANTITY,0)) RCV_QTY
from 
    apps.rcv_shipment_headers rsh,
    apps.rcv_transactions rt
where 
    rsh.shipment_header_id=rt.shipment_header_id
--    and rt.TRANSACTION_TYPE='DELIVER'
    and rsh.receipt_num is not null
    and rsh.SHIPMENT_NUM in ('ITR/PRT/2465',
'ITR/PRT/2467',
'ITR/PRT/2469',
'ITR/PRT/2470',
'ITR/PRT/2472',
'ITR/PRT/2473',
'ITR/PRT/2474',
'ITR/PRT/2475',
'ITR/PRT/2476',
'ITR/PRT/2477',
'ITR/PRT/2478',
'ITR/PRT/2479',
'ITR/PRT/2480',
'ITR/PRT/2481',
'ITR/PRT/2482',
'ITR/PRT/2483',
'ITR/PRT/2484',
'ITR/PRT/2485',
'ITR/PRT/2486',
'ITR/PRT/2487',
'ITR/PRT/2488',
'ITR/PRT/2489',
'ITR/PRT/2490',
'ITR/PRT/2491',
'ITR/PRT/2492',
'ITR/PRT/2493',
'ITR/PRT/2494',
'ITR/PRT/2495',
'ITR/PRT/2496',
'ITR/PRT/2497',
'ITR/PRT/2498',
'ITR/PRT/2499',
'ITR/PRT/2500',
'ITR/PRT/2502',
'ITR/PRT/2503',
'ITR/PRT/2504',
'ITR/PRT/2505',
'ITR/PRT/2506',
'ITR/PRT/2507',
'ITR/PRT/2508',
'ITR/PRT/2509',
'ITR/PRT/2510',
'ITR/PRT/2511',
'ITR/PRT/2512',
'ITR/PRT/2513',
'ITR/PRT/2514',
'ITR/PRT/2515',
'ITR/PRT/2516',
'ITR/PRT/2517',
'ITR/PRT/2518',
'ITR/PRT/2519',
'ITR/PRT/2520',
'ITR/PRT/2521',
'ITR/PRT/2522',
'ITR/PRT/2523',
'ITR/PRT/2526',
'ITR/PRT/2527',
'ITR/PRT/2528',
'ITR/PRT/2529',
'ITR/PRT/2530',
'ITR/PRT/2531',
'ITR/PRT/2533',
'ITR/PRT/2535',
'ITR/PRT/2536',
'ITR/PRT/2537',
'ITR/PRT/2538',
'ITR/PRT/2539',
'ITR/PRT/2540',
'ITR/PRT/2541',
'ITR/PRT/2542',
'ITR/PRT/2543',
'ITR/PRT/2544',
'ITR/PRT/2545',
'ITR/PRT/2546',
'ITR/PRT/2547',
'ITR/PRT/2548',
'ITR/PRT/2549',
'ITR/PRT/2550',
'ITR/PRT/2551',
'ITR/PRT/2552',
'ITR/PRT/2553',
'ITR/PRT/2554',
'ITR/PRT/2555',
'ITR/PRT/2556',
'ITR/PRT/2557',
'ITR/PRT/2558',
'ITR/PRT/2576',
'ITR/PRT/2577',
'ITR/PRT/2578',
'ITR/PRT/2579',
'ITR/PRT/2582',
'ITR/PRT/2583',
'ITR/PRT/2584',
'ITR/PRT/2585',
'ITR/PRT/2586',
'ITR/PRT/2587',
'ITR/PRT/2588',
'ITR/PRT/2589',
'ITR/PRT/2590',
'ITR/PRT/2592',
'ITR/PRT/2593',
'ITR/PRT/2594',
'ITR/PRT/2595',
'ITR/PRT/2596',
'ITR/PRT/2597',
'ITR/PRT/2599',
'ITR/PRT/2601',
'ITR/PRT/2602',
'ITR/PRT/2603',
'ITR/PRT/2604',
'ITR/PRT/2605',
'ITR/PRT/2608',
'ITR/PRT/2609',
'ITR/PRT/2610',
'ITR/PRT/2611',
'ITR/PRT/2612',
'ITR/PRT/2613',
'ITR/PRT/2615',
'ITR/PRT/2619',
'ITR/PRT/2620',
'ITR/PRT/2621',
'ITR/PRT/2622',
'ITR/PRT/2623')
group by
    rsh.SHIPMENT_NUM,
    rt.COMMENTS,
    rsh.receipt_num,
    rt.SUBINVENTORY


rownuM<10  