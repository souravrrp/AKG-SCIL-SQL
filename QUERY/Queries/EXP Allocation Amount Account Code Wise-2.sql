select
    gam.alloc_code,
    gcc.code_combination_id,
    gcc.segment1 Company,
    gcc.segment2 Cost_center,
    gcc.segment3 Natural_account,
    gcc.segment4 Inter_Project,
    gcc.segment5 Future_Value,
    sum(gai.AMOUNT) ALLOC_AMNT
--    gai.*
from
     apps.gl_code_combinations gcc,
     apps.gl_aloc_inp gai,
     apps.gl_aloc_exp gae ,
    apps.gl_aloc_mst gam
where
    gai.calendar_code='AKG2015'
    and gai.period_code='3'
    and gam.alloc_id=gai.alloc_id
    and gai.alloc_id=gae.alloc_id
    and gai.line_no=gae.line_no
    and gam.legal_entity_id=23280
    and gai.account_id=gcc.code_combination_id
--    and gam.alloc_code='CRM_OVERHEAD_1110'
group by
    gam.alloc_code,
    gcc.code_combination_id,
    gcc.segment1,gcc.segment2,gcc.segment3,gcc.segment4,gcc.segment5
--having  sum(gai.AMOUNT)<>0   
