SELECT DISTINCT
           REQH.SEGMENT1 REQ_NUM,
           REQH.AUTHORIZATION_STATUS REQ_STATUS,  -- poh.po_header_id,
           POH.SEGMENT1 PO_NUM,
           POL.LINE_NUM,
           POH.AUTHORIZATION_STATUS PO_STATUS,
    --     i.invoice_id,
           I.INVOICE_NUM,
           I.INVOICE_AMOUNT,
           I.AMOUNT_PAID,
           I.VENDOR_ID,
    --     v.vendor_name,
    --     p.check_id,
           C.CHECK_NUMBER,
           H.GL_TRANSFER_FLAG,
           H.PERIOD_NAME  
    FROM APPS.AP_INVOICES_ALL I,
         APPS.AP_INVOICE_DISTRIBUTIONS_ALL INVD,
         APPS.PO_HEADERS_ALL POH,
         APPS.PO_LINES_ALL POL,
         APPS.PO_DISTRIBUTIONS_ALL POD,
         APPS.PO_VENDORS V,
         APPS.PO_REQUISITION_HEADERS_ALL REQH,
         APPS.PO_REQUISITION_LINES_ALL REQL,
         APPS.PO_REQ_DISTRIBUTIONS_ALL REQD,     
         APPS.AP_INVOICE_PAYMENTS_ALL P,
         APPS.AP_CHECKS_ALL C,
         APPS.AP_AE_HEADERS_ALL H,
         APPS.AP_AE_LINES_ALL L
    WHERE 1=1     
    AND I.VENDOR_ID = V.VENDOR_ID
    AND C.CHECK_ID = P.CHECK_ID
    AND P.INVOICE_ID = I.INVOICE_ID
    AND POH.PO_HEADER_ID = POL.PO_HEADER_ID
    AND REQH.REQUISITION_HEADER_ID = REQL.REQUISITION_HEADER_ID
    AND REQD.REQUISITION_LINE_ID = REQL.REQUISITION_LINE_ID
    AND POD.REQ_DISTRIBUTION_ID = REQD.DISTRIBUTION_ID
    AND POD.PO_HEADER_ID = POH.PO_HEADER_ID
    AND POD.PO_DISTRIBUTION_ID = INVD.PO_DISTRIBUTION_ID
    AND INVD.INVOICE_ID = I.INVOICE_ID
    AND H.AE_HEADER_ID = L.AE_HEADER_ID
    AND L.SOURCE_TABLE = 'AP_INVOICES'
    AND L.SOURCE_ID = I.INVOICE_ID 
    --and poh.segment1 = 4033816 -- PO NUMBER
    --AND REQH.SEGMENT1 = '501'   -- REQ NUMBER
    --and i.invoice_num = 3114     -- INVOICE NUMBER
    --and c.check_number =     -- CHECK NUMBER
   --and vendor_id =          -- VENDOR ID
   
--------------------------------------------------------------------------------


SELECT DISTINCT REQH.SEGMENT1 REQ_NUM, REQH.AUTHORIZATION_STATUS REQ_STATUS,               
      --       POH.PO_HEADER_ID,
                POH.SEGMENT1 PO_NUM, POL.LINE_NUM,
                POH.AUTHORIZATION_STATUS PO_STATUS, RCVH.RECEIPT_NUM,
                RCV.INSPECTION_STATUS_CODE,
      --       I.INVOICE_ID,
                I.INVOICE_NUM, I.INVOICE_AMOUNT,
                I.AMOUNT_PAID, I.VENDOR_ID,
      --       V.VENDOR_NAME,
      --       P.CHECK_ID,
                C.CHECK_NUMBER, H.GL_TRANSFER_FLAG,
               H.PERIOD_NAME
           FROM APPS.AP_INVOICES_ALL I,
                APPS.AP_INVOICE_DISTRIBUTIONS_ALL INVD,
                APPS.PO_HEADERS_ALL POH,
                APPS.PO_LINES_ALL POL,
                APPS.PO_DISTRIBUTIONS_ALL POD,
                APPS.PO_VENDORS V,
                APPS.PO_REQUISITION_HEADERS_ALL REQH,
                APPS.PO_REQUISITION_LINES_ALL REQL,
                APPS.PO_REQ_DISTRIBUTIONS_ALL REQD,
                APPS.RCV_TRANSACTIONS RCV,
                APPS.RCV_SHIPMENT_HEADERS RCVH,
                APPS.RCV_SHIPMENT_LINES RCVL,
                APPS.AP_INVOICE_PAYMENTS_ALL P,
                APPS.AP_CHECKS_ALL C,
                APPS.AP_AE_HEADERS_ALL H,
                APPS.AP_AE_LINES_ALL L
          WHERE 1 = 1
            AND I.VENDOR_ID = V.VENDOR_ID
            AND C.CHECK_ID = P.CHECK_ID
            AND P.INVOICE_ID = I.INVOICE_ID
            AND POH.PO_HEADER_ID = POL.PO_HEADER_ID
            AND REQH.REQUISITION_HEADER_ID = REQL.REQUISITION_HEADER_ID
            AND REQD.REQUISITION_LINE_ID = REQL.REQUISITION_LINE_ID
            AND POD.REQ_DISTRIBUTION_ID = REQD.DISTRIBUTION_ID
            AND POD.PO_HEADER_ID = POH.PO_HEADER_ID
          --AND POH.PO_HEADER_ID = RCV.PO_HEADER_ID
            AND RCVH.SHIPMENT_HEADER_ID = RCV.SHIPMENT_HEADER_ID(+)
          --AND RCVH.SHIPMENT_HEADER_ID = RCVL.SHIPMENT_HEADER_ID
          --AND RCV.TRANSACTION_TYPE = 'RECEIVE'
          --AND RCV.SOURCE_DOCUMENT_CODE = 'PO'
          --AND POL.PO_LINE_ID = RCV.PO_LINE_ID
          --AND POD.PO_DISTRIBUTION_ID = RCV.PO_DISTRIBUTION_ID
            AND POD.PO_DISTRIBUTION_ID = INVD.PO_DISTRIBUTION_ID
            AND INVD.INVOICE_ID = I.INVOICE_ID
            AND H.AE_HEADER_ID = L.AE_HEADER_ID
            AND L.SOURCE_TABLE = 'AP_INVOICES'
            AND L.SOURCE_ID = I.INVOICE_ID
          --AND POH.SEGMENT1 = 36420 -- PO NUMBER
            AND REQH.SEGMENT1 = '501'  -- REQ NUMBER
          --AND I.INVOICE_NUM = 3114     -- INVOICE NUMBER
          --AND C.CHECK_NUMBER =     -- CHECK NUMBER
          --AND VENDOR_ID =          -- VENDOR ID
          --AND RECEIPT_NUM = 692237