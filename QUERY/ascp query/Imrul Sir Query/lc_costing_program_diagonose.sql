/*------------  1. Get All GRN in the Period   ----------------------*/

SELECT poh.segment1 po_number, pla.item_id, rcvl.item_description,
              akglc.lc_id, akglc.lc_number, pla.quantity po_quantity,
              --rcvt.quantity rcv_quantity, 
              decode(rcvt.transaction_type,'RETURN TO RECEIVING',-1*rcvt.quantity,rcvt.quantity) rcv_quantity,
              rcvt.unit_of_measure,
              pla.unit_price,
              --(rcvt.quantity * pla.unit_price) total_received,
              (decode(rcvt.transaction_type,'RETURN TO RECEIVING',-1*rcvt.quantity,rcvt.quantity)*pla.unit_price) total_received,
              rcvh.receipt_num, pla.po_header_id, pla.po_line_id,
              rcvt.transaction_id,
              rcvt.transaction_date
         FROM po.po_headers_all poh,
              po.po_lines_all pla,
              po.rcv_shipment_headers rcvh,
              po.rcv_shipment_lines rcvl,
              po.rcv_transactions rcvt,
              apps.xxakg_lc_details akglc
        WHERE poh.po_header_id = pla.po_header_id
          AND akglc.po_header_id = pla.po_header_id
          AND rcvl.po_line_id = pla.po_line_id
          AND rcvt.shipment_header_id = rcvl.shipment_header_id
          AND rcvh.shipment_header_id = rcvl.shipment_header_id
          AND rcvt.shipment_line_id = rcvl.shipment_line_id
          --AND akglc.org_id = '111'
          AND rcvt.attribute15 IS NULL                  -- added on 05/10/2011
          AND rcvt.organization_id = :l_organization_id                   --112
          AND (   (rcvt.transaction_type = 'DELIVER')
               OR (    rcvt.transaction_type in ( 'CORRECT', 'RETURN TO RECEIVING')--= 'CORRECT'
                   AND rcvt.destination_type_code = 'INVENTORY'
                   AND EXISTS (
                          SELECT 1
                            FROM po.rcv_transactions rt
                           WHERE rt.shipment_header_id =
                                                       rcvt.shipment_header_id
                             AND rt.shipment_line_id = rcvt.shipment_line_id
                             AND rt.transaction_type = 'DELIVER'
                             AND TRUNC (rt.transaction_date) BETWEEN :p_from_date
                                                                 AND :p_to_date)
                  )
              )
          AND TRUNC (rcvt.transaction_date) BETWEEN :p_from_date AND :p_to_date
          AND EXISTS (
                 SELECT 1
                   FROM inv.mtl_system_items_b msi,
                        inv.mtl_item_categories mic,
                        inv.mtl_categories_b mc
                  WHERE msi.inventory_item_id = mic.inventory_item_id
                    AND msi.organization_id = mic.organization_id
                    AND mic.category_id = mc.category_id
                    AND msi.inventory_item_id = pla.item_id
                    AND msi.organization_id = rcvt.organization_id
                    AND mc.segment1 IN
                           ('ELECTRICAL', 'AUTOMOBILE', 'IT',
                            'PRINTING AND STATIONARY', 'CIVIL', 'PRODUCTION',
                            'MECHANICAL', 'TOOLS', 'LAB AND CHEMICAL',
                            'INDIRECT MATERIAL', 'INGREDIENT','TRADING'))
                            
                            
/*-------   2. Get GRN Count    -----------------*/                            
SELECT COUNT (1)
--     INTO l_count3
     FROM po.po_headers_all poh,
          po.po_lines_all pla,
          po.rcv_shipment_headers rcvh,
          po.rcv_shipment_lines rcvl,
          po.rcv_transactions rcvt,
          apps.xxakg_lc_details akglc
    WHERE poh.po_header_id = pla.po_header_id
      AND akglc.po_header_id = pla.po_header_id
      AND rcvl.po_line_id = pla.po_line_id
      AND rcvt.shipment_header_id = rcvl.shipment_header_id
      AND rcvh.shipment_header_id = rcvl.shipment_header_id
      AND rcvt.shipment_line_id = rcvl.shipment_line_id
      --AND akglc.org_id = '111'
--      AND rcvt.attribute_category = 'LC Costed'  -- Makshud
      AND rcvt.attribute15 IS NULL                      -- added on 05/10/2011
      AND rcvt.organization_id = :l_organization_id                       --112
      AND (   (rcvt.transaction_type = 'DELIVER')
           OR (    rcvt.transaction_type = 'CORRECT'
               AND rcvt.destination_type_code = 'INVENTORY'
               AND EXISTS (
                      SELECT 1
                        FROM po.rcv_transactions rt
                       WHERE rt.shipment_header_id = rcvt.shipment_header_id
                         AND rt.shipment_line_id = rcvt.shipment_line_id
                         AND rt.transaction_type = 'DELIVER'
                         AND TRUNC (rt.transaction_date) BETWEEN :l_from_date
                                                             AND :l_to_date)
              )
          )
      AND TRUNC (rcvt.transaction_date) BETWEEN :l_from_date AND :l_to_date;                            
                            


/*--------------- 3. Get Total Accepted Qty for Closed PO Line and Item   ---------------------*/

SELECT   SUM (rcv_mon_amount) l_qty_accepted_amt, line_amount l_line_qty_amt, po_header_id l_closed_hdr_id,
               item_id l_closed_item_id, po_line_id l_closed_line_id
--          INTO l_qty_accepted_amt, l_line_qty_amt, l_closed_hdr_id,
--               l_closed_item_id, l_closed_line_id
          FROM (SELECT (decode(rcvt.TRANSACTION_TYPE,'RETURN TO RECEIVING',-1*rcvt.quantity,rcvt.quantity) * pla.unit_price) rcv_mon_amount,
                       (pla.quantity * pla.unit_price) line_amount,
                       poh.po_header_id, pla.item_id, pla.po_line_id
                  FROM po.po_headers_all poh,
                       po.po_lines_all pla,
                       po.rcv_shipment_headers rcvh,
                       po.rcv_shipment_lines rcvl,
                       po.rcv_transactions rcvt,
                       apps.xxakg_lc_details akglc
                 WHERE poh.po_header_id = pla.po_header_id
                   AND akglc.po_header_id = pla.po_header_id
                   AND rcvl.po_line_id = pla.po_line_id
                   AND rcvt.shipment_header_id = rcvl.shipment_header_id
                   AND rcvh.shipment_header_id = rcvl.shipment_header_id
                   AND rcvt.shipment_line_id = rcvl.shipment_line_id
                   -- AND akglc.org_id = '111'
                   AND rcvt.organization_id = :l_organization_id          --128
                   AND (   (rcvt.transaction_type = 'DELIVER')
                        OR (    rcvt.transaction_type in ( 'CORRECT','RETURN TO RECEIVING')
                            AND rcvt.destination_type_code = 'INVENTORY'
                            AND EXISTS (
                                   SELECT 1
                                     FROM po.rcv_transactions rt
                                    WHERE rt.shipment_header_id =
                                                       rcvt.shipment_header_id
                                      AND rt.shipment_line_id =
                                                         rcvt.shipment_line_id
                                      AND rt.transaction_type = 'DELIVER'
                                      AND TRUNC (rt.transaction_date)
                                             BETWEEN :l_from_date
                                                 AND :l_to_date)
                           )
                       ))
         WHERE po_header_id = :i_po_header_id
           AND item_id = :i_item_id
           AND po_line_id = :i_po_line_id
      GROUP BY po_header_id, item_id, po_line_id, line_amount;                            



/*--------------- 4. Get Period Accepted Qty for Closed PO Line and Item   ---------------------*/
SELECT   SUM (rcv_mon_amount) l_month_qty_amt, po_header_id l_rec_hdr_id, item_id l_closed_item_id, po_line_id l_rec_line_id
--          INTO l_month_qty_amt, l_rec_hdr_id, l_closed_item_id, l_rec_line_id
          FROM (SELECT (decode(rcvt.TRANSACTION_TYPE,'RETURN TO RECEIVING',-1*rcvt.quantity,rcvt.quantity) * pla.unit_price) rcv_mon_amount,
                       poh.po_header_id, pla.item_id, pla.po_line_id
                  FROM po.po_headers_all poh,
                       po.po_lines_all pla,
                       po.rcv_shipment_headers rcvh,
                       po.rcv_shipment_lines rcvl,
                       po.rcv_transactions rcvt,
                       apps.xxakg_lc_details akglc
                 WHERE poh.po_header_id = pla.po_header_id
                   AND akglc.po_header_id = pla.po_header_id
                   AND rcvl.po_line_id = pla.po_line_id
                   AND rcvt.shipment_header_id = rcvl.shipment_header_id
                   AND rcvh.shipment_header_id = rcvl.shipment_header_id
                   AND rcvt.shipment_line_id = rcvl.shipment_line_id
                   -- AND akglc.org_id = '111'
                   AND rcvt.organization_id = :l_organization_id          --128
                   AND (   (rcvt.transaction_type = 'DELIVER')
                        OR (    rcvt.transaction_type  in ( 'CORRECT','RETURN TO RECEIVING')
                            AND rcvt.destination_type_code = 'INVENTORY'
                            AND EXISTS (
                                   SELECT 1
                                     FROM po.rcv_transactions rt
                                    WHERE rt.shipment_header_id =
                                                       rcvt.shipment_header_id
                                      AND rt.shipment_line_id =
                                                         rcvt.shipment_line_id
                                      AND rt.transaction_type = 'DELIVER'
                                      AND TRUNC (rt.transaction_date)
                                             BETWEEN :l_from_date
                                                 AND :l_to_date)
                           )
                       )
                   --AND TRUNC (rcvt.transaction_date) BETWEEN '01-MAY-2011' AND '31-MAY-2011')
                   AND TRUNC (rcvt.transaction_date) BETWEEN :l_from_date
                                                         AND :l_to_date)
         WHERE po_header_id = :i_po_header_id
           AND item_id = :i_item_id
           AND po_line_id = :i_po_line_id
      GROUP BY po_header_id, item_id, po_line_id;                            
      
      

select apps.xxakg_cal_rec_val (:l_organization_id,
                                 :l_from_date,
                                 :i_po_header_id
                                ) l_received_previous
from dual;      
      


SELECT   SUM (pda.QUANTITY_DELIVERED * pla.unit_price)
--             INTO l_po_total_amount
             FROM po.po_lines_all pla, po.po_distributions_all pda
            WHERE pla.po_header_id = :i_po_header_id and pla.po_line_id=pda.po_line_id
         GROUP BY pla.po_header_id;
         

         SELECT   i.po_line_id l_line_id, i.item_id l_item_id, i.total_received l_rcv_amt,
--                  SUM (pla.quantity * pla.unit_price),
                    (l_month_qty_amt  )
                  / (l_po_total_amount - l_receievd_previous) l_allocation_without_grn
--             INTO l_line_id, l_item_id, l_rcv_amt,
----                  l_po_total_amount,
--                  l_allocation_without_grn           -- l_allocation_with_grn,
             FROM po_lines_all pla
            WHERE po_header_id = :i_po_header_id
              AND po_line_id = :i_po_line_id                            -- 2125
         GROUP BY po_header_id, po_line_id;
         
         


/*------ Delivery Count Per Line  -------------- */
SELECT COUNT (*) l_delivery_count_per_line
--           INTO l_delivery_count_per_line
           FROM po.rcv_transactions rt
          WHERE rt.po_line_id = :i_po_line_id
            AND rt.organization_id = :l_organization_id
            AND (   (rt.transaction_type = 'DELIVER')
                 OR (    rt.transaction_type in ( 'CORRECT','RETURN TO RECEIVING')
                     AND rt.destination_type_code = 'INVENTORY'
                     AND EXISTS (
                            SELECT 1
                              FROM po.rcv_transactions rcvt
                             WHERE rt.shipment_header_id =
                                                       rcvt.shipment_header_id
                               AND rt.shipment_line_id = rcvt.shipment_line_id
                               AND rcvt.transaction_type = 'DELIVER'
                               AND TRUNC (rcvt.transaction_date)
                                      BETWEEN :l_from_date
                                          AND :l_to_date)
                    )
                )
            AND TRUNC (rt.transaction_date) BETWEEN :l_from_date AND :l_to_date;         