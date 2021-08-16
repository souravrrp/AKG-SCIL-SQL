select  --distinct --ppa.project_id, 
          ppa.org_id,
          haou.name Organization,
          ppa.NAME,
          ppa.long_name,
          ppa.segment1,
--          pa.project_status_code,
          pps.project_status_name,
--          po.option_name project_option,
          pbv.burdened_cost budget_cost,
          pbt.budget_type,
          (SELECT PPF.EMPLOYEE_NUMBER||'-'||PPF.FULL_NAME FROM APPS.FND_USER FU, APPS.PER_PEOPLE_F PPF WHERE PPA.CREATED_BY=FU.USER_ID AND PPF.PERSON_ID=FU.EMPLOYEE_ID
            AND SYSDATE BETWEEN PPF.EFFECTIVE_START_DATE AND EFFECTIVE_END_DATE) CREATED_BY_USER,
--          ppa.created_by,
          ppa.project_type,
          ppa.start_date,
          ppa.completion_date,
          ppa.closed_date,
          ppa.carrying_out_organization_id,
--  NVL ((SELECT DISTINCT ppf.first_name || ' ' || ppf.last_name
--                           FROM apps.pa_project_players p, apps.per_all_people_f ppf
--                          WHERE ppf.person_id = p.person_id
--                            AND project_role_type = 'PROJECT MANAGER'
--                            AND p.project_id = ppa.project_id),
--               'Not Defined'
--              ) Project_members,
          pt.task_id,
          pt.task_number,
          pt.attribute1 task_status,
          pt.task_name,
          pt.description
--         ,pab.budget_version_id
         ,ppaa.asset_name
--         ,ppaa.asset_description
--         ,papf.employee_number||'-'||papf.full_name Project_person 
--         ,pprt.meaning Project_person_role
         ,ppa.ATTRIBUTE1||'.'||ppa.ATTRIBUTE2||'.'||ppa.ATTRIBUTE3||'.'||'9999'||'.'||'00' Project_Code_combinations
         ,peia.expenditure_type "Expenditure Type"
         ,peia.expenditure_item_date "Expenditure Item Date"
         ,pcdla.amount "Amount"
         ,gc1.concatenated_segments "Credit "
         ,gc2.concatenated_segments "Debit "
         ,ppa.project_currency_code
         ,pl.city location
-- trunc(pab.cur_base_date) approval_date,
--          (SELECT   SUM (burdened_cost)
--               FROM pafv_budget_lines
--              WHERE task_id = pt.task_id
--                AND budget_version_id = pab.budget_version_id
--           GROUP BY task_id) task_budget,
--          pt.top_task_id,
--          pt.wbs_level,
--          pt.start_date,
--          pt.completion_date,
--          pod.DESTINATION_TYPE_CODE
--           (select item_id from po_lines_all
--           where po_line_id=pod.po_line_id) item,
--             (SELECT description
--             FROM mtl_system_items_b k
--             WHERE inventory_item_id = (select item_id from po_lines_all
--                                       where po_line_id=pod.po_line_id)
--              AND organization_id = pa.carrying_out_organization_id) item_desc,
--          (SELECT segment1
--             FROM mtl_system_items_b k
--            WHERE inventory_item_id =(select item_id from po_lines_all
--                                        where po_line_id=pod.po_line_id)
--              AND organization_id = pa.carrying_out_organization_id) item_code,
--                (select  pha.segment1 from po_headers_all pha
--                     where pha.po_header_id=pod.po_header_id) po_num,
--                (select  pv.vendor_name from po_headers_all pha,po_vendors pv
--                     where pv.vendor_id=pha.vendor_id
--                     and  pha.po_header_id=pod.po_header_id) vendor_name,   
--                (select quantity from po_lines_all
--                    where po_line_id=pod.po_line_id) PO_QTY,
--                (select unit_price from po_lines_all
--                     where po_line_id=pod.po_line_id) PO_unit_price,
--                 (select (pl.unit_price * pl.quantity * nvl(ph.rate,1))
--                           from po_lines_all pl,po_headers_all ph
--                           where ph.po_header_id=pl.po_header_id
--                           and pl.po_line_id=pod.po_line_id) PO_commit_cost,
--                  (SELECT distinct receipt_num
--                   FROM rcv_shipment_headers rsh, rcv_transactions rcv,po_lines_all pla
--                   WHERE rsh.shipment_header_id = rcv.shipment_header_id
--                   and rcv.po_line_id=pla.po_line_id
--                   AND PO_DISTRIBUTION_ID=pod.PO_DISTRIBUTION_ID
--                   AND transaction_id=rcv1.transaction_id) rec_num,
--             (select distinct trunc(transaction_date) from rcv_transactions rcv
--              where PO_DISTRIBUTION_ID=pod.PO_DISTRIBUTION_ID
--              and transaction_type = 'DELIVER' and rownum=1) Rec_Date,
--                      (select sum((decode (transaction_type,'DELIVER',quantity
--                                                           ,'RETURN TO VENDOR', (quantity * (-1)))))
--                      from rcv_transactions rcv
--                      where PO_DISTRIBUTION_ID=pod.PO_DISTRIBUTION_ID
--                      and shipment_line_id = rcv1.shipment_line_id
--                      and transaction_type in ('DELIVER','RETURN TO VENDOR')) rec_qty,
--                           (select distinct po_unit_price from rcv_transactions rcv
--                            where PO_DISTRIBUTION_ID=pod.PO_DISTRIBUTION_ID
--                            and transaction_type = 'DELIVER') Rec_Price ,
--              ((select sum((decode (transaction_type,'DELIVER',quantity
--                                                      ,'RETURN TO VENDOR', (quantity * (-1)))))
--                from rcv_transactions rcv
--                where PO_DISTRIBUTION_ID=pod.PO_DISTRIBUTION_ID
--                and shipment_line_id = rcv1.shipment_line_id
--                and transaction_type in ('DELIVER','RETURN TO VENDOR')) * (select distinct po_unit_price from rcv_transactions rcv
--                where PO_DISTRIBUTION_ID=pod.PO_DISTRIBUTION_ID
--                and transaction_type = 'DELIVER')) Rec_Val
--,pt.*
from
apps.pa_projects_all ppa
--,apps.pa_project_accum_headers ppah
--,apps.pa_invoice_group_columns pigc        --invoice
--,apps.pa_invoice_groups pig
--,apps.pa_invoice_formats pif
--,apps.pa_invoice_format_details pifd
,apps.pa_tasks pt                                        --task
,apps.pa_budget_versions pbv                      --budget
,apps.pa_budget_types pbt
--,apps.pa_budget_entry_methods pbem    
--,apps.pa_budget_lines pbl
--,apps.pa_project_accum_budgets ppab
--,apps.pa_project_accum_actuals ppaac
--,apps.pa_project_accum_commitments ppac
,apps.pa_project_assets_all ppaa                  --asset
--,apps.pa_project_asset_lines_all ppala
--,apps.pa_project_asset_line_details ppald
--,apps.pa_project_asset_assignments ppaas
,apps.pa_project_statuses pps                       --status
--,apps.pa_project_status_controls ppsc
,apps.hr_all_organization_units haou
,apps.pa_project_types_all ppta
--,apps.pa_project_players pppl                      --project member/role/perty
--,apps.pa_project_role_types pprt
--,apps.per_all_people_f papf
--,apps.pa_project_parties pppr
,apps.pa_locations pl                                     --locations
--,apps.pa_project_options ppo                      --options
--,apps.pa_options po
--,apps.pa_system_linkages psl                      --linkage
--,apps.pa_expend_typ_sys_links petsl
,apps.pa_cost_distribution_lines_all pcdla        --cst dist
--,apps.pa_expenditures_all pea                     --expenditure
--,apps.pa_expenditure_types pet
--,apps.pa_expenditure_groups_all pega
,apps.pa_expenditure_items_all peia
--,apps.pa_expend_item_adj_activities peiaa
--,apps.pa_implementations_all pia                  --implementations
--,apps.pa_resources pr                                  --resource
--,apps.pa_resource_list_members prlm
--,apps.pa_resource_types prt
--,apps.pa_resource_formats prf
--,apps.pa_resource_accum_details prad
--,apps.pa_functions pf                                     --functions
--,apps.pa_function_parameters pfp
--,apps.pa_transaction_sources pts                    --transactions
--,apps.pa_transaction_interface_all ptia
--,apps.pa_txn_accum_details ptad
--,apps.pa_billing_assignments_all pbaa             --billing
--,apps.pa_action_sets pas                                --actions
--,apps.pa_action_set_lines pasl
--,apps.pa_action_set_types past
,apps.gl_code_combinations_kfv gc1                  --code combinations 
,apps.gl_code_combinations_kfv gc2
--,apps.pa_capital_events pce
--,apps.pa_project_copy_overrides ppco              --copy project
--,apps.pa_wf_processes pwp
--,apps.pa_periods_all pa
-- ,apps.pa_project_fundings ppf
--,apps.pa_events pe
--,apps.pa_event_types pet
--,apps.pa_agreements_all paa
--,apps.pa_project_classes ppc
--,apps.pa_budget_versions_draft_v pab
----------------------------------------view---------------------------------------------------
--,apps.mtl_project_demand_view mpdv
--,apps.pjm_project_oe_demand_v podv
--,apps.pjm_project_blanket_po_v podv
--,apps.pa_xla_project_ref_v pxrv
--,apps.pa_project_roles_lov_v pprv
------------------------------------------------------------------------------------------------
-- apps.po_distributions_all pod,
-- apps.rcv_transactions rcv1
where  1=1
and ppa.project_id = ppaa.project_id
--and ppaa.project_id = ppala.project_id
--and ppaa.project_asset_id=ppala.project_asset_id
--and pt.task_id=ppala.task_id
and ppa.project_id=pt.project_id
and pps.project_status_code = ppa.project_status_code
and ppa.carrying_out_organization_id = haou.organization_id
and ppta.project_type = ppa.project_type
and ppa.org_id = ppta.org_id
--and ppa.project_id = ppp.project_id
--and sysdate between papf.effective_start_date and papf.effective_end_date
--and papf.person_id = ppp.person_id
--and ppp.project_role_type = pprt.project_role_type
and pbv.project_id = ppa.project_id
and pbv.current_flag='Y'
and pbt.budget_type_code=pbv.budget_type_code
and ppa.location_id=pl.location_id
--and ppo.project_id = ppa.project_id
--and ppo.option_code=po.option_code
and pt.task_id=pcdla.task_id                             --cost distributions
and pcdla.project_id=ppa.project_id                  --cost distributions
and peia.expenditure_item_id = pcdla.expenditure_item_id
and pt.task_id=peia.task_id                             --expenditure items
and peia.project_id=ppa.project_id                  --expenditure items
and peia.EXPENDITURE_TYPE='AKG_Default'    --
and pcdla.cr_code_combination_id = gc1.code_combination_id
and pcdla.dr_code_combination_id = gc2.code_combination_id
--and ppa.org_id = peia.org_id                        --expenditure items
--and ppa.project_id = ptia.project_id(+)                  --transaction interface
--and ppa.org_id = ptia.org_id(+)                            --transaction interface
--and pt.task_id=ptia.task_id(+)                               --transaction interface
-- AND pa.segment1 = 'SCIL VRM Bag Plant Projct'--:p_project_number
--AND pa.org_id = '85'  --:p_org_id
and ppa.project_id='46011'
--------------------------------------------------
--AND ppa.project_id = ppf.project_id(+)
-- AND ppa.project_id = pab.project_id
-- AND ty.budget_type_code = pab.budget_type_code
-- and pod.task_id=rcv1.task_id(+)
-- and pod.po_distribution_id=rcv1.po_distribution_id(+)
--------------------------------------------------
order by pt.task_number         



---------------------------------PROJECT PERIOD-------------------------------------------
SELECT
--PPA.NAME PROJECT_NAME
OU.NAME OPERATING_UNITS
,PA.ORG_ID
,OU.SHORT_CODE ORG_CODE
,OU.SET_OF_BOOKS_ID
,PA.PERIOD_NAME
,PA.STATUS
,OOD.ORGANIZATION_ID
,OOD.ORGANIZATION_CODE
,OOD.ORGANIZATION_NAME
--,OOD.*
FROM
APPS.PA_PERIODS_ALL PA
--,APPS.PA_PROJECTS_ALL PPA
,APPS.PA_ALL_ORGANIZATIONS PAO
,APPS.HR_OPERATING_UNITS OU
,APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE 1=1
AND PA.ORG_ID=PAO.ORG_ID
AND PA.ORG_ID=OU.ORGANIZATION_ID
AND PAO.ORGANIZATION_ID=OOD.ORGANIZATION_ID
--AND PA.ORG_ID=PPA.ORG_ID
AND PA.STATUS='O'   --'P'   --'O'
AND PA.ORG_ID=85
--AND OOD.ORGANIZATION_CODE='SCD'
AND PA.PERIOD_NAME='JAN-19'

-----------------------------draft--------------------------------------------------------
SELECT
--project_id,
peia.*
FROM
apps.pa_cost_distribution_lines_all pcdla
,apps.pa_expenditure_items_all peia
,apps.pa_tasks pt
where 1=1
and pt.task_id=pcdla.task_id                             --cost distributions
--and pcdla.project_id=ppa.project_id                  --cost distributions
and peia.expenditure_item_id = pcdla.expenditure_item_id
and pt.task_id=peia.task_id                             --expenditure items
and peia.project_id=pcdla.project_id                  --expenditure items
and pcdla.project_id='46011'
--and TRANSACTION_SOURCE!='Inventory Misc'
and peia.EXPENDITURE_TYPE='AKG_Default'
--and org_id=85
--AND TRANSACTION_SOURCE='AP INVOICE'
--AND DOCUMENT_TYPE='STANDARD'
