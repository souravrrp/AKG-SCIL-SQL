select gcc.segment3,a.*, c.* from apps.xla_seg_rule_details a,apps.gl_code_combinations gcc, apps.xla_conditions c
where a.application_id=555
and a.VALUE_CODE_COMBINATION_ID=gcc.code_combination_id --and a.user_sequence=c.user_sequence
and a.application_id=c.application_id
and gcc.segment1='2200' and a.SEGMENT_RULE_DETAIL_ID=c.SEGMENT_RULE_DETAIL_ID and gcc.segment3 like '2%'
and c.source_code=gcc.Cost_Category_Segment1


select
    xrd.segment_rule_code,
    xrd.user_sequence,
    xc.value_constant,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 acc_Code_combination,
    xc.*
from
    xla.xla_seg_rule_details xrd,
    xla.xla_conditions xc,
    gl.gl_code_combinations gcc
where
    xrd.SEGMENT_RULE_DETAIL_ID=xc.SEGMENT_RULE_DETAIL_ID
    and xrd.segment_rule_code like 'STEEL%WIP'---GREEN PEAS MIXING
    and xrd.application_id=xc.application_id
    and xc.application_id=555
--    and xc.source_code='COST_CAT_SEGMENT1'
--    and xc.source_code like 'SOURCE%'
--    and xc.VALUE_CONSTANT ='101'--like  'BRNG%'--'LABOUR CHARGE'
--    and xc.value_constant like '%TRAD%'
--     and xrd.user_sequence=xc.user_sequence
--    and  xrd.user_sequence in (230,300)
    and xrd.value_code_combination_id=gcc.code_combination_id
    and gcc.segment1='1210'
--    and gcc.segment2 in ('BRAND')
--    and gcc.segment4='2220'
--    and gcc.segment3='2010501'
--    and gcc.segment4<>'9999'
--and rownum<10


-------------------------------------------------
select a.*, c.* from apps.xla_seg_rule_details a,apps.gl_code_combinations gcc, apps.xla_conditions c
where a.application_id=555
and a.VALUE_CODE_COMBINATION_ID=gcc.code_combination_id --and a.user_sequence=c.user_sequence
and a.application_id=c.application_id
and gcc.segment1='2200' and a.SEGMENT_RULE_CODE='CEM_ALC' and a.SEGMENT_RULE_DETAIL_ID=c.SEGMENT_RULE_DETAIL_ID


-----------------------------------------------------
select gcc.segment3,a.*, c.* from apps.xla_seg_rule_details a,apps.gl_code_combinations gcc, apps.xla_conditions c
where a.application_id=555
and a.VALUE_CODE_COMBINATION_ID=gcc.code_combination_id --and a.user_sequence=c.user_sequence
and a.application_id=c.application_id
and gcc.segment1='2200' and a.SEGMENT_RULE_DETAIL_ID=c.SEGMENT_RULE_DETAIL_ID and gcc.segment3 like '2%'
------------------------------------------------------


select 
    distinct
    c.VALUE_CONSTANT, 
    gcc.segment3,
    FLEX.DESCRIPTION
--    a.*, c.*
from apps.xla_seg_rule_details a,apps.gl_code_combinations gcc, apps.xla_conditions c,apps.FND_FLEX_VALUES_VL FLEX 
where a.application_id=555
and a.VALUE_CODE_COMBINATION_ID=gcc.code_combination_id --and a.user_sequence=c.user_sequence
and a.application_id=c.application_id
and gcc.segment1='2200' and a.SEGMENT_RULE_DETAIL_ID=c.SEGMENT_RULE_DETAIL_ID
and gCC.SEGMENT3 = FLEX.FLEX_VALUE_MEANING 
and gcc.segment3 like '2050%' 
and gcc.segment3<>'2050107'
and c.source_code='COST_CAT_SEGMENT1' 
