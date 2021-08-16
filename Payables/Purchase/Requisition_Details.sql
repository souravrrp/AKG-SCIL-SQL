SELECT
*
FROM
APPS.PO_REQUISITION_HEADERS_ALL PRHA
WHERE 1=1
--JOINED BY REQUISITION_HEADER_ID, 
--SEARCH BY PREPARER_ID, 
--FIND OUT SEGMENT1(Requisition_number), APPROVED_DATE, 
--CONDITIONED_BY AUTHORIZATION_STATUS, TYPE_LOOKUP_CODE, ORG_ID, 

SELECT
*
FROM
APPS.PO_REQUISITION_LINES_ALL PRLA
WHERE 1=1
--JOINED BY REQUISITION_HEADER_ID, REQUISITION_LINE_ID, , VENDOR_ID, VENDOR_SITE_ID, ORG_ID, 
--SEARCH BY NEED_BY_DATE
--FIND OUT ITEM_DESCRIPTION, UNIT_MEAS_LOOKUP_CODE, UNIT_PRICE, QUANTITY, BASE_UNIT_PRICE
--CONDITIONED_BY  LINE_NUM, LINE_TYPE_ID, CATAGORY_ID, 
--DESTINATION_TYPE_CODE, DESTINATION_ORGANIZATION_ID, DESTINATION_CONTEXT, QUANTITY_CANCELLED, CANCEL_DATE, 


SELECT
*
FROM
APPS.PO_REQ_DISTRIBUTIONS_ALL
WHERE 1=1
--JOINED BY ORG_ID, DISTRIBUTION_ID, CODE_COMBINATION_ID, ACCRUAL_ACCOUNT_ID, VARIANCE_ACCOUNT_ID, 
--FIND OUT SET_OF_BOOK_ID, REQ_LINE_QUANTITY, 


SELECT
*
FROM
APPS.PO_ACTION_HISTORY
--OBJECT_ID, SEQUENCE_NUM,
--CONDITION BY ACTION_CODE, ACTION_DATE, OBJECT_TYPE_CODE, OBJECT_SUB_TYPE_CODE, 
--SUBMITTED BY EMPLOYEE_ID, APPROVAL_PATH_ID, 
--SEARCH BY CREATED_BY, 

---------------------------------------------------------------------------------------------------------

SELECT
PRHA.SEGMENT1 REQUISITION_NUMBER,
PRLA.NEED_BY_DATE,
PRLA.LINE_NUM,
PRHA.TYPE_LOOKUP_CODE,
PRHA.AUTHORIZATION_STATUS,
PRHA.APPROVED_DATE,
PRLA.ITEM_DESCRIPTION, 
PRLA.UNIT_MEAS_LOOKUP_CODE, 
PRLA.UNIT_PRICE, 
PRLA.QUANTITY, 
PRLA.BASE_UNIT_PRICE,
PRLA.DESTINATION_TYPE_CODE,
PRLA.DESTINATION_CONTEXT,
PRLA.QUANTITY_CANCELLED, 
PRLA.CANCEL_DATE
FROM
APPS.PO_REQUISITION_HEADERS_ALL PRHA,
APPS.PO_REQUISITION_LINES_ALL PRLA
WHERE 1=1
AND PRHA.ORG_ID=85
AND PRHA.REQUISITION_HEADER_ID=PRLA.REQUISITION_HEADER_ID
--AND PRHA.TYPE_LOOKUP_CODE=''
AND PRLA.DESTINATION_TYPE_CODE='EXPENSE'




---------------------------------------------------------------------------------------------------------

SELECT
*
FROM
APPS.OE_ORDER_LINES_ALL OOL,
APPS.OE_ORDER_HEADERS_ALL OOH,
APPS.PO_REQUISITION_LINES_ALL PRLA,
APPS.PO_REQUISITION_HEADERs_ALL PRHA
WHERE 1=1
--AND OOH.HEADER_ID=OOL.HEADER_ID
AND OOL.SOURCE_DOCUMENT_LINE_ID=PRLA.REQUISITION_LINE_ID
AND OOL.ORIG_SYS_DOCUMENT_REF=PRHA.SEGMENT1
AND OOH.ORIG_SYS_DOCUMENT_REF=PRHA.SEGMENT1





1. OE_ORDER_LINES_ALL.SOURCE_DOCUMENT_LINE_ID =
    po_requisition_lines_all.REQUISITION_LINE_ID
2.  OE_ORDER_LINES_ALL.ORIG_SYS_DOCUMENT_REF=       
      po_requisition_HEADERs_all.SEGMENT1(Requisition Number)
3.  OE_ORDER_HEADERS_ALL.ORIG_SYS_DOCUMENT_REF=         
      po_requisition_HEADERs_all.SEGMENT1(Requisition number)


---------------------------------------------------------------------------------------------------------

SELECT
*
FROM
APPS.PO_REQUISITION_LINES_ALL PRLA,
APPS.MTL_SYSTEM_ITEMS_B MSI
WHERE 1=1
AND PRLA.ITEM_ID=MSI.INVENTORY_ITEM_ID
AND PRLA.ORG_ID=85
AND MSI.ORGANIZATION_ID=101





---------------------------------------------------------------------------------------------------------


-- ALL OPEN PO'S

SELECT h.segment1 "PO NUM",
h.authorization_status "STATUS",
l.line_num "SEQ NUM",
ll.line_location_id,
d.po_distribution_id,
h.type_lookup_code "TYPE"
FROM po.po_headers_all h,
po.po_lines_all l,
po.po_line_locations_all ll,
po.po_distributions_all d
WHERE h.po_header_id = l.po_header_id
AND ll.po_line_id = l.po_Line_id
AND ll.line_location_id = d.line_location_id
AND h.closed_date IS NULL
AND h.type_lookup_code NOT IN ('QUOTATION')

-- PO WITHOUT PURCHASE REQUISITION

SELECT prh.segment1 "PR NUM",
TRUNC (prh.creation_date) "CREATED ON",
TRUNC (prl.creation_date) "Line Creation Date",
prl.line_num "Seq #",
msi.segment1 "Item Num",
prl.item_description "Description",
prl.quantity "Qty",
TRUNC (prl.need_by_date) "Required By",
ppf1.full_name "REQUESTOR",
ppf2.agent_name "BUYER"
FROM po.po_requisition_headers_all prh,
po.po_requisition_lines_all prl,
apps.per_people_f ppf1,
( SELECT DISTINCT agent_id, agent_name FROM apps.po_agents_v) ppf2,
po.po_req_distributions_all prd,
inv.mtl_system_items_b msi,
po.po_line_locations_all pll,
po.po_lines_all pl,
po.po_headers_all ph
WHERE prh.requisition_header_id = prl.requisition_header_id
AND prl.requisition_line_id = prd.requisition_line_id
AND ppf1.person_id = prh.preparer_id
AND prh.creation_date BETWEEN ppf1.effective_start_date
AND ppf1.effective_end_date
AND ppf2.agent_id(+) = msi.buyer_id
AND msi.inventory_item_id = prl.item_id
AND msi.organization_id = prl.destination_organization_id
AND pll.line_location_id(+) = prl.line_location_id
AND pll.po_header_id = ph.po_header_id(+)
AND pll.po_line_id = pl.po_line_id(+)
AND prh.authorization_status = 'APPROVED'
AND pll.line_location_id IS NULL
AND prl.closed_code IS NULL
AND NVL (prl.cancel_flag, 'N') <> 'Y'
ORDER BY 1, 2, 4

-- REQUISITION AND PO

SELECT r.segment1 "Req Num", ph.segment1 "PO Num"
FROM po_headers_all ph,
po_distributions_all d,
po_req_distributions_all rd,
po_requisition_lines_all rl,
po_requisition_headers_all r
WHERE ph.po_header_id = d.po_header_id
AND d.req_distribution_id = rd.distribution_id
AND rd.requisition_line_id = rl.requisition_line_id
AND rl.requisition_header_id = r.requisition_header_id

-- CANCELLED REQUISITIONS

SELECT prh.REQUISITION_HEADER_ID,
prh.PREPARER_ID,
prh.SEGMENT1 "REQ NUM",
TRUNC (prh.CREATION_DATE),
prh.DESCRIPTION,
prh.NOTE_TO_AUTHORIZER
FROM apps.Po_Requisition_headers_all prh, apps.po_action_history pah
WHERE action_code = 'CANCEL'
AND pah.object_type_code = 'REQUISITION'
AND pah.object_id = prh.REQUISITION_HEADER_ID

-- INTERNAL REQUISITION WITHOUT INTERNAL SALES ORDER

SELECT RQH.SEGMENT1,
RQL.LINE_NUM,
RQL.REQUISITION_HEADER_ID,
RQL.REQUISITION_LINE_ID,
RQL.ITEM_ID,
RQL.UNIT_MEAS_LOOKUP_CODE,
RQL.UNIT_PRICE,
RQL.QUANTITY,
RQL.QUANTITY_CANCELLED,
RQL.QUANTITY_DELIVERED,
RQL.CANCEL_FLAG,
RQL.SOURCE_TYPE_CODE,
RQL.SOURCE_ORGANIZATION_ID,
RQL.DESTINATION_ORGANIZATION_ID,
RQH.TRANSFERRED_TO_OE_FLAG
FROM PO_REQUISITION_LINES_ALL RQL, PO_REQUISITION_HEADERS_ALL RQH
WHERE RQL.REQUISITION_HEADER_ID = RQH.REQUISITION_HEADER_ID
AND RQL.SOURCE_TYPE_CODE = 'INVENTORY'
AND RQL.SOURCE_ORGANIZATION_ID IS NOT NULL
AND NOT EXISTS
(SELECT 'existing internal order'
FROM OE_ORDER_LINES_ALL LIN
WHERE LIN.SOURCE_DOCUMENT_LINE_ID =
RQL.REQUISITION_LINE_ID
AND LIN.SOURCE_DOCUMENT_TYPE_ID = 10)
ORDER BY RQH.REQUISITION_HEADER_ID, RQL.LINE_NUM