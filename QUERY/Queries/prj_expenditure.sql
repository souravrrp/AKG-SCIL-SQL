select
    *
from
    pa.pa_expenditures_all
where
    rownum<10    


select
    *
from
    pa.pa_tasks
where
    project_id=37009
--    rownum<10    

select
    ppa.segment1,
    ppa.name,
    pt.task_number,
    pt.task_name,
    peia.expenditure_type,
    peia.raw_cost,
    peia.burden_cost,
    peia.transaction_source,
    peia.denom_raw_cost,
    peia.denom_burdened_cost,
    peia.denom_currency_code,
    peia.acct_raw_cost,
    peia.acct_burdened_cost,
    peia.acct_currency_code,
    peia.project_raw_cost,
    peia.project_burdened_cost,
    peia.project_currency_code,
    peia.*
from
    pa.pa_projects_all ppa,
    pa.pa_tasks pt,
    pa.pa_expenditure_items_all peia
where
    ppa.segment1='Memory 42 & 43'
    and ppa.project_id=pt.project_id
    and ppa.project_id=peia.project_id
    and pt.task_id(+)=peia.task_id
--    and rownum<10    
    
select
    *
from
    pa.pa_projects_all
where
    segment1='Memory 42 & 43'
--    and rownum<10        