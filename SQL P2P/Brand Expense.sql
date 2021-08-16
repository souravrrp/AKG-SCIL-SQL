select * from apps.XXAKG_BRAND_EXPENSE_V


SELECT 
            pha.segment1 po_number,
            ppf.full_name po_creator,
            pha.approved_date,
            decode(txn.line_status,
        1,'Incomplete',
        2,'Pending Approval',
        3,'Approved',
        4,'Not Approved',
        5,'Closed',
        6,'Cancelled',
        7,'Pre-Approved',
        8,'Partially Approved',
        9,'Cancelled by Source') line_status,
            pla.po_line_id,
            pla.line_num,
            msi.organization_id,
            pda.destination_type_code,
            msi.inventory_item_id,
            msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3 item_code,
            msi.description,
            DECODE (pha.currency_code,
                    'BDT', pla.unit_price,
                    pla.unit_price * pha.rate)
               rate,
            pda.quantity_delivered grn_quantity,
            SUM (NVL (txn.quantity, 0)) mo_approved_qty,
            SUM (NVL (txn.quantity_delivered, 0)) mo_transacted_qty,
            (pda.quantity_delivered - SUM (NVL (txn.quantity_delivered, 0))) remaining_transacted_qty
FROM 
            apps.po_headers_all pha,
            apps.po_lines_all pla,
            apps.po_distributions_all pda,
            apps.mtl_system_items_b msi,
            apps.mtl_txn_request_lines txn,
            apps.fnd_user fu,
            apps.per_people_f ppf
      WHERE 1=1
--            AND pha.segment1 in ('L/SCOU/033738','L/SCOU/032986')
            AND pha.po_header_id = pla.po_header_id
            AND pha.po_header_id = pda.po_header_id
            AND pla.po_line_id = pda.po_line_id
            --and pha.created_by=5995
            AND pla.item_id = msi.inventory_item_id
            AND msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3 in ('BRND.PROG.0001')
            AND msi.organization_id in ('1345')
            -- and pda.destination_organization_id=msi.organization_id
            AND pha.type_lookup_code = 'STANDARD'
            AND pda.quantity_delivered <> 0
            AND TO_CHAR (pla.po_line_id) = txn.attribute2(+)
            AND (pda.quantity_delivered - NVL (txn.quantity_delivered, 0)) > 0
            AND txn.line_status IN (2,3,5,8)
            AND txn.attribute_category(+) = 'SCIL Brand Expenses'
            --and msi.organization_id=:$PROFILES$.MFG_ORGANIZATION_ID
            AND pha.org_id = 85
            AND pha.created_by = fu.user_id
            AND fu.user_name = to_char(ppf.employee_number)
            AND sysdate between ppf.effective_start_date and ppf.effective_end_date
   GROUP BY pha.segment1,
            ppf.full_name,
            pha.approved_date,
            txn.line_status,
            pla.po_line_id,
            pla.line_num,
            msi.organization_id,
            pda.destination_type_code,
            msi.inventory_item_id,
            msi.segment1 || '.' || msi.segment2 || '.' || msi.segment3,
            msi.description,
            DECODE (pha.currency_code,
                    'BDT', pla.unit_price,
                    pla.unit_price * pha.rate),
            pda.quantity_delivered;
            

