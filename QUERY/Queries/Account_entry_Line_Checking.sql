select
    geh.*
from
    gmf.gmf_xla_extract_headers geh--,
--    gmf.gmf_xla_extract_lines gel
where
--    geh.header_id=gel.header_id
--    and 
    geh.transaction_id in (153434)    


select
    *
from
    xla.xla_ae_headers
where
    event_id=16731414
--    rownum<10    


select
    *
from
    xla.xla_ae_lines
where
    ae_header_id= 81211125   


select *
from
    apps.org_organization_definitions
where
    organization_code='SGL'
    
    
        

select
    geh.entity_code,
    geh.source_document_id,
    geh.transaction_id voucher_number,
    geh.inventory_item_id,
    xel.ACCOUNTING_DATE,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 account_code_combination,
    xel.accounting_class_code,
    nvl(xel.ACCOUNTED_DR,0) Debits,
    nvl(xel.ACCOUNTED_CR,0) Credits,
    nvl(xel.ACCOUNTED_DR,0)-nvl(xel.ACCOUNTED_CR,0) Balance
from
    gmf.gmf_xla_extract_headers geh,
    xla.xla_ae_headers xeh,
    xla.xla_ae_lines xel,
    gl.gl_code_combinations gcc
where
    geh.event_id=xeh.event_id
    and xeh.ae_header_id=xel.ae_header_id
    and xel.code_combination_id=gcc.code_combination_id
--    and geh.organization_id in (93)
--    and geh.entity_code='PURCHASING'
--    and geh.event_class_code='ACTCOSTADJ'
--    and trunc(geh.transaction_date) = '01-DEC-2014'
--    and geh.inventory_item_id in (79832)
    and geh.transaction_id in (51249694,
51249695,
51249696,
51249842,
51249959,
51285733,
51285734,
51285735,
51285736,
51285737,
51285798,
51285799,
51285885,
51285886,
51285926,
51285927,
51286155,
51286156,
51286157,
51286158,
51286159,
51286160,
51307748,
51307749,
51307750,
51308154,
51309273,
51309274,
51309422,
51309779,
51309780,
51309781,
51309782,
51309984,
51310073,
51310074,
51310114,
51369104,
51369105,
51369140,
51369189,
51369304,
51369409,
51369410,
51369436,
51369437,
51369500,
51369836,
51369837)
--    and ,geh.ENTITY_CODE='PURCHASING'
--    and geh.source_document_id in (4306455)    ---- Shipment_header_id
order by     
    geh.source_document_id,
    geh.transaction_id