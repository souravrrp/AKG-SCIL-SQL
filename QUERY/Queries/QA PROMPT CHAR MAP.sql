select
--    qpc.*
    qpc.plan_id,
    qp.name,
    qp.description,
    qpc.prompt,
    qpc.result_column_name
from
    qa.qa_plan_chars qpc,
    QA.QA_PLANS qp
where
    qpc.plan_id=qp.plan_id
--    and qpc.plan_id in (19101)
    and qpc.plan_id in (select
    qp.plan_id
from
    qa.qa_plans qp,
    apps.org_organization_definitions ood
where
    qp.organization_id=ood.organization_id
    and ood.legal_entity in (23279,23280,24273)
--    and qp.organization_id not in (90,91)
    and qp.effective_to is null)
order by qpc.result_column_name
        
        