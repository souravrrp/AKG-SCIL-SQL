-----------------------LC----------------------------------------------------------------------
SELECT
*
FROM
APPS.XXAKG_LC_DETAILS
WHERE 1=1
AND ORG_ID=85
ORDER BY PO_NUMBER DESC

--------------------------------PRICE_ELEMENT---------------------------------------------
SELECT
*
FROM
APPS.PON_PRICE_ELEMENT_TYPES


--------------------------------MATCHES-----------------------------------------------------
SELECT
*
FROM
APPS.INL_MATCHES

----------------------------------------MATCHES_INTERFACE------------------------------
SELECT
*
FROM
APPS.INL_MATCHES_INT


---------------------------------COMBINED---------------------------------------------------

SELECT
IM.MATCH_INT_ID
,IMI.MATCH_INT_ID 
FROM
APPS.INL_MATCHES IM
,APPS.INL_MATCHES_INT IMI
WHERE 1=1
AND IM.FROM_PARENT_TABLE_ID=IMI.FROM_PARENT_TABLE_ID
AND IM.MATCH_ID='112292'


---------------------------------SHIPMENT_HEADERS---------------------------------------
SELECT
*
FROM
APPS.RCV_SHIPMENT_HEADERS RSH
WHERE 1=1
AND RSH.SHIPMENT_NUM IS NOT NULL
AND RSH.ORGANIZATION_ID='101'
AND RSH.SHIPMENT_NUM='L/C NO-1814-13-01-0041'
ORDER BY CREATION_DATE DESC


---------------------------------SHIPMENT_LINES---------------------------------------
SELECT
*
FROM
APPS.RCV_SHIPMENT_LINES RSH
WHERE 1=1


---------------------------------SHIPMENT_COMBINED-------------------------------------
SELECT
*
FROM
APPS.RCV_SHIPMENT_HEADERS RSH
,APPS.RCV_SHIPMENT_LINES RSL
WHERE 1=1
AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID
AND RSH.SHIPMENT_NUM='L/C NO-1814-13-01-0041'


---------------------------------SHIPMENT_INTERFACE-------------------------------------
SELECT
*
FROM
APPS.RCV_TRANSACTIONS_INTERFACE RTI


---------------------------------SHIPMENT_INTERFACE_COMBINED-----------------------
SELECT
RSH.*
--RSL.*
--RTI.*
FROM
APPS.RCV_TRANSACTIONS_INTERFACE RTI
,APPS.RCV_SHIPMENT_HEADERS RSH
,APPS.RCV_SHIPMENT_LINES RSL
WHERE 1=1
AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID
AND RSH.SHIPMENT_HEADER_ID=RTI.SHIPMENT_HEADER_ID
AND RSL.SHIPMENT_LINE_ID=RTI.SHIPMENT_LINE_ID
AND RSH.SHIPMENT_NUM='3399.1'
ORDER BY RSH.CREATION_DATE DESC


--------------------------------PRICE_ELEMENT---------------------------------------------
SELECT
*
FROM
APPS.PON_PRICE_ELEMENT_TYPES


--------------------------------SHIIPMENT_INTERFACE_HEADERS------------------------
SELECT
*
FROM
APPS.INL_SHIP_HEADERS_ALL ISHI

-----------------------------------SHIIPMENT_INTERFACE_LINES--------------------------
SELECT
*
FROM
APPS.INL_SHIP_LINES_ALL ISLI



-----------------------------------SHIIPMENT_INTERFACE_GROUP--------------------------
SELECT
*
FROM
APPS.INL_SHIP_LINE_GROUPS ISLG


--------------------------------------CHARGE_LINES_INTERFACE--------------------------
SELECT
*
FROM
APPS.INL_CHARGE_LINES
WHERE 1=1
AND SOURCE_CODE='QP'




------------------------------------------------------------------------------------------------


select distinct
--        *
--        imi.processing_status_code
--        ,imi.transaction_type
--        ,imi.match_type_code
        ai.set_of_books_id
        ,ai.org_id
--        ,imi.from_parent_table_name
        ,aid.period_name
        ,aid.accounting_date
        ,lc.lc_number
        ,pha.segment1
        ,rsh.shipment_num
        ,rsh.receipt_num
        ,rt.transaction_id
        ,rt.transaction_type
        ,rt.transaction_date        
        ,msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item
        ,msi.description
        ,ai.cancelled_date
        ,ail.cancelled_flag
        ,ail.discarded_flag
        ,aid.cancellation_flag
        ,aid.reversal_flag
        ,aid.invoice_distribution_id
        ,ai.doc_sequence_value
        ,aid.line_type_lookup_code
        ,aid.invoice_line_number
        ,aid.distribution_line_number
        ,ail.cost_factor_id
        ,ppet.price_element_code
        ,aid.amount
        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account
--        ,imi.to_parent_table_name
--        ,imi.to_parent_table_id
--        ,aid.po_distribution_id
        ,aid.*
from 
--        apps.inl_matches_int imi,
--        ,apps.inl_matches ima
        apps.ap_invoices_all ai
        ,apps.ap_invoice_lines_all ail
        ,apps.ap_invoice_distributions_all aid
        ,apps.gl_code_combinations gcc
        ,apps.rcv_transactions rt
        ,apps.rcv_shipment_headers rsh
        ,apps.po_headers_all pha
        ,apps.po_lines_all pla
        ,apps.po_distributions_all pda
        ,apps.mtl_system_items_vl msi
        ,apps.xxakg_lc_details lc
        ,apps.pon_price_element_types ppet
where 1=1
        and ai.set_of_books_id in (2025)
        and ai.org_id in (83)
        and ai.doc_sequence_value in (216118776)
--        and imi.from_parent_table_id=aid.invoice_distribution_id
--        and ima.from_parent_table_id=aid.invoice_distribution_id
        and aid.dist_code_combination_id=gcc.code_combination_id
        and ai.invoice_id=aid.invoice_id
        and ai.org_id=aid.org_id
        and ai.invoice_id=ail.invoice_id
        and ai.org_id=ail.org_id
        and ail.invoice_id=aid.invoice_id
        and ail.org_id=aid.org_id
--        and aid.rcv_transaction_id(+)=imi.to_parent_table_id
        and ail.rcv_transaction_id=rt.transaction_id
        and ail.line_number=aid.invoice_line_number
        and rt.shipment_header_id=rsh.shipment_header_id
        and pda.destination_organization_id=rsh.ship_to_org_id
        and pla.po_line_id=rt.po_line_id
        and pha.po_header_id=pla.po_header_id
        and pla.po_header_id=pda.po_header_id
        and pha.po_header_id=pda.po_header_id
        and pha.org_id=pla.org_id
        and pla.org_id=pda.org_id
        and pha.org_id=pda.org_id
        and pla.item_id=msi.inventory_item_id
        and pda.destination_organization_id=msi.organization_id
        and ai.set_of_books_id=lc.ledger_id
        and lc.org_id=pha.org_id
        and lc.org_id=ai.org_id
--        and lc.vendor_id=pha.vendor_id
--        and lc.vendor_id=ai.vendor_id
        and lc.po_header_id=pha.po_header_id
        and lc.po_number=pha.segment1
        and ail.cost_factor_id=ppet.price_element_type_id
--        AND 
--        and aid.invoice_distribution_id!=imi.from_parent_table_id
--        and imi.from_parent_table_id is null
--        and ima.match_int_id!=imi.match_int_id
--        and ima.from_parent_table_id!=imi.from_parent_table_id
--        and ima.to_parent_table_id!=imi.to_parent_table_id
--        and ima.charge_line_type_id!=imi.charge_line_type_id
--        and aid.invoice_distribution_id='4610569'
        and not exists
        (select 1 from apps.inl_matches_int imi 
            where 1=1
--                and to_char(aid.invoice_distribution_id)<>to_char(imi.from_parent_table_id)
                and aid.invoice_distribution_id=imi.from_parent_table_id
--                and imi.from_parent_table_id is null
--            and ail.rcv_transaction_id=imi.to_parent_table_id 
--            and imi.to_parent_table_id=rt.transaction_id
         )
order by ai.org_id
--        ,aid.period_name
        ,aid.accounting_date
        ,pha.segment1
        ,rsh.shipment_num
        ,rsh.receipt_num
        ,ai.doc_sequence_value
        ,aid.invoice_line_number
        ,aid.distribution_line_number



select
*
from 
        apps.inl_matches_int imi
        where 1=1
        and imi.from_parent_table_id in (4610555,4610558,4610568,4610573,4610556,4610559,4610569,4610574,5048801,5048802,5048913,5048917,5048930,5048934,7733937,7733940,7733938,7733941,7733943,7733944,7733946,7733947,7733950,7733951,7733956,7733957,7733959,7733960)


SELECT
AIDA.*
FROM
APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA
--,APPS.INL_MATCHES_INT IMI
WHERE 1=1
--AND AIDA.INVOICE_DISTRIBUTION_ID=IMI.FROM_PARENT_TABLE_ID
AND AIDA.INVOICE_DISTRIBUTION_ID 
IN (7733937,7733940,7733938,7733941)
--in (4610555,4610558,4610568,4610573,4610556,4610559,4610569,4610574,5048801,5048802,5048913,5048917,5048930,5048934,7733937,7733940,7733938,7733941,7733943,7733944,7733946,7733947,7733950,7733951,7733956,7733957,7733959,7733960)
