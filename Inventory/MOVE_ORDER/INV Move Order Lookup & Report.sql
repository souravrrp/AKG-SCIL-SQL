SELECT 
--mmtt.transaction_temp_id,
  tol.organization_id,
  toh.request_number,
  toh.header_id,
  tol.line_number,
  tol.line_id,
  tol.inventory_item_id,
  toh.description,
  toh.move_order_type,
  tol.line_status,
  DECODE(tol.line_status,1,'Incomplete',2,'Pending Approval',3,'Approved',4,'Not Approved',5,'Closed',6,'Canceled',7,'Pre Approved',8,'Partially Approved',9,'Canceled by Source') Move_order_status,
  tol.quantity,
  tol.quantity_delivered,
  tol.quantity_detailed
  ,toh.*
FROM apps.mtl_txn_request_headers toh,
  apps.mtl_txn_request_lines tol
--  apps.mtl_material_transactions_temp mmtt
WHERE toh.header_id = tol.header_id
 AND toh.organization_id = tol.organization_id
-- AND tol.line_id = mmtt.move_order_line_id
 and toh.request_number='13088380'
-- and tol.line_status='1'
 
 
 SELECT 
 LOOKUP_TYPE,
 LOOKUP_CODE,
 MEANING,
 DESCRIPTION
-- ,VL.*
 FROM 
 APPS.FND_LOOKUP_VALUES_VL VL
 WHERE 1=1
-- AND meaning like '%Closed%'
 AND LOOKUP_TYPE='MTL_TXN_REQUEST_STATUS'
 
 
 
 -----------------------------*******HISTORY****--------------------------------------
 
 SELECT MMT.INVENTORY_ITEM_ID,
                            TRUNC (MMT.TRANSACTION_DATE) TRANSACTION_DATE,
                            MMT.TRANSACTION_UOM,
                            SUM (
                               -1 * MMT.TRANSACTION_QUANTITY
                               * INV_CONVERT.INV_UM_CONVERT (
                                    MMT.INVENTORY_ITEM_ID,
                                    MMT.TRANSACTION_UOM,'PCS'
--                                    P_UOM
                                    ))
                               PRIMARY_QUANTITY
                       FROM mtl_material_transactions MMT,
                            MTL_TRANSACTION_TYPES MTT,
                            MTL_TXN_REQUEST_LINES MTRL,
                            MTL_TXN_REQUEST_HEADERS MTRH
                      WHERE     1 = 1
                            AND MTRH.HEADER_ID = MTRL.HEADER_ID
                            AND MMT.INVENTORY_ITEM_ID = MTRL.INVENTORY_ITEM_ID
                            AND MMT.INVENTORY_ITEM_ID = '511077'--P_INVENTORY_ITEM_ID
                            AND MMT.TRANSACTION_SOURCE_ID = MTRH.HEADER_ID
                            AND MMT.TRX_SOURCE_LINE_ID = MTRL.LINE_ID
                            AND MTRH.ATTRIBUTE_CATEGORY = 'AKCL Vehicle Number'--P_ATC
                            AND NVL(MTRH.ATTRIBUTE1,MTRH.ATTRIBUTE4) = 'D.M.U-11-2444'--P_UOA
                            AND MMT.TRANSFER_ORGANIZATION_TYPE IS NULL
                            --AND MMT.TRANSACTION_DATE < TRUNC (P_DATE_REQUIRED)
                            and to_char(MMT.TRANSACTION_DATE,'DD-MON-YYYY') < '27-MAY-17'--P_DATE_REQUIRED
                            --AND MMT.INVENTORY_ITEM_ID in (178138)--, 72699,73714,49053,57343,56370,50792)
                            --AND MMT.ORGANIZATION_ID in (89,1306)
                            AND MMT.ORGANIZATION_ID = 89--P_ORG
                            AND MMT.TRANSACTION_TYPE_ID = MTT.TRANSACTION_TYPE_ID
                            AND MMT.TRANSACTION_QUANTITY<0
                            --AND MTT.TRANSACTION_TYPE_NAME = 'Move Order Issue'
                   GROUP BY MMT.INVENTORY_ITEM_ID,
                            TRUNC (MMT.TRANSACTION_DATE),
                            MMT.TRANSACTION_UOM
                   ORDER BY TRUNC (MMT.TRANSACTION_DATE) DESC