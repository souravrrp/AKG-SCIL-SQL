SELECT QPSEG.SEGMENT_MAPPING_COLUMN, QPSOUR.USER_SOURCING_TYPE,
QPSOUR.USER_VALUE_STRING, QPCON.PRC_CONTEXT_CODE,
QPSOUR.ATTRIBUTE_SOURCING_LEVEL, QPSOUR.REQUEST_TYPE_CODE,
QPREQ.PTE_CODE, QPCON.PRC_CONTEXT_TYPE, QPSEG.SEGMENT_CODE,
QPCON.SEEDED_FLAG CONTEXT_SEEDED_FLAG,
QPSEG.SEEDED_FLAG ATTRIBUTE_SEEDED_FLAG
FROM APPS.QP_SEGMENTS_B QPSEG,
APPS.QP_ATTRIBUTE_SOURCING QPSOUR,
APPS.QP_PRC_CONTEXTS_B QPCON,
APPS.QP_PTE_REQUEST_TYPES_B QPREQ,
APPS.QP_PTE_SEGMENTS QPPSEG
WHERE QPSOUR.SEGMENT_ID = QPSEG.SEGMENT_ID
AND QPPSEG.USER_SOURCING_METHOD = 'ATTRIBUTE MAPPING'
AND QPSOUR.REQUEST_TYPE_CODE = 'ONT'
AND QPSEG.PRC_CONTEXT_ID = QPCON.PRC_CONTEXT_ID
AND QPREQ.REQUEST_TYPE_CODE = QPSOUR.REQUEST_TYPE_CODE
AND QPPSEG.PTE_CODE = QPREQ.PTE_CODE
AND QPPSEG.SEGMENT_ID = QPSOUR.SEGMENT_ID
AND QPPSEG.SOURCING_ENABLED = 'Y'
AND QPCON.PRC_CONTEXT_TYPE IN
('PRICING_ATTRIBUTE', 'PRODUCT', 'QUALIFIER')