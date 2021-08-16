select
    distinct
    gam.alloc_id,
    gam.alloc_code,
    gae.line_no,
--    gam.organization_id,
    gcc.segment1 Company,
    gcc.segment2 Cost_Center,
    gcc.segment3 Natural_Account,
    gcc.segment4 Inter_project,
    to_char(gcc.segment5) Future,
    (select gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 from gl.gl_code_combinations gcc where gcc.code_combination_id=gae.from_account_id) From_Acc_Code,
    (select gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5 from gl.gl_code_combinations gcc where gcc.code_combination_id=gae.to_account_id) To_Acc_Code--,
--    gae.*
from
    apps.gl_code_combinations gcc,
    apps.gl_aloc_exp gae ,
    apps.gl_aloc_mst gam
where
    gam.legal_entity_id=23280
    and gam.alloc_id=gae.alloc_id
    and gae.DELETE_MARK<>1
    and gcc.code_combination_id between gae.from_account_id and gae.to_account_id
    and gam.alloc_code like 'LONG_OVERHEAD' 
--    and gae.from_account_id<>gae.to_account_id
--    and gcc.segment1='2400'
--    and gcc.segment3='4030204'
--    and gcc.segment2='ADMFC'
order by
        gam.alloc_id,
        gae.line_no    