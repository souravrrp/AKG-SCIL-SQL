select gam.legal_entity_id,gam.alloc_code,gcc1.segment1||'.'||gcc1.segment2||'.'||gcc1.segment3||'.'||gcc1.segment4||'.'||gcc1.segment5 From_Account,
         gcc2.segment1||'.'||gcc2.segment2||'.'||gcc2.segment3||'.'||gcc2.segment4||'.'||gcc2.segment5 To_Account,
         gae.*
from apps.gl_aloc_mst gam, apps.GL_ALOC_EXP gae, gl.gl_code_combinations gcc1, gl.gl_code_combinations gcc2
where 1=1
--gae.from_account_id <> gae.to_account_id
and gam.legal_entity_id=23280
and gae.from_account_id=gcc1.code_combination_id
and gae.to_account_id=gcc2.code_combination_id
and gam.alloc_id=gae.alloc_id
--and gam.alloc_id in (18,19,47,51,52)
--and gam.alloc_code in ('FACTORY_OVERHEAD_ALL')
--and gcc1.segment1='1210'
--and gcc1.segment2='ACFAC'
--and (gcc1.segment3 in (4030307,
--4031706,
--4030701,
--4031312,
--4031105,
--4032104,
--4032101,
--4030702,
--4030703,
--4030704,
--4030708,
--4030801,
--4030802,
--4030803,
--4030804,
--4030805)
--or
--gcc2.segment3 in (4030307,
--4031706,
--4030701,
--4031312,
--4031105,
--4032104,
--4032101,
--4030702,
--4030703,
--4030704,
--4030708,
--4030801,
--4030802,
--4030803,
--4030804,
--4030805)) 
and gam.delete_mark<>1
and gae.delete_mark<>1
order by
    gam.alloc_id, gae.line_no




select alloc_code, alloc_desc
from
    apps.gl_aloc_mst
where
--    alloc_code='CCL_OVERHEAD_ROLF_1'    
    legal_entity_id=23280
    and delete_mark=1
