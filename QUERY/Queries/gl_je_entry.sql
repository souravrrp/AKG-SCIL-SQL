select
    geh.*
from
    gmf.gmf_xla_extract_headers geh,
    xla.xla_ae_headers xah,
    xla.xla_ae_lines xal
where
    geh.legal_entity_id=23279
    and geh.entity_code = 'PRODUCTION'
    and trunc(geh.transaction_date) between '01-JUN-2014' and '30-JUN-2014'
    and geh.event_id=xah.event_id
    and xah.ae_header_id=xal.ae_header_id
--    rownum<10    


select
    *
from
    xla.xla_ae_headers
where
    event_id=13530000   
    
    
select
    gcc.segment1,gcc.segment2,gcc.segment3,gcc.segment4,gcc.segment5,
    xal.*
from
    xla.xla_ae_lines xal,
    gl.gl_code_combinations gcc
where
    ae_header_id=59295034      
    and xal.code_combination_id=gcc.code_combination_id
    
    
       