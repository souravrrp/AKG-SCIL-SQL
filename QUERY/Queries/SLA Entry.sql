select 
--    sr.*
    USER_SEQUENCE,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 Code_combination
--    gcc.*
from
    xla.xla_seg_rule_details sr,
    gl.gl_code_combinations gcc
where
        sr.SEGMENT_RULE_CODE='CEM_BATCH_INV'
        and gcc.CODE_COMBINATION_ID=sr.VALUE_CODE_COMBINATION_ID
        and gcc.segment1=2200
        and gcc.segment3='2050109'
--        and rownum<10