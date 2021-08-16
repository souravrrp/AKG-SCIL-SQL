-----------------------------------************------------------------------------------
SELECT
PPA.NAME PROJECT_NAME
,PPA.SEGMENT1 
,PPA.*
FROM
APPS.PA_PROJECTS_ALL PPA
WHERE 1=1
--AND PPA.SEGMENT1  LIKE '%VRM%'

------------------------------------------------------------------------------------------------
select 
*
from
apps.oe_blanket_headers_all obha
,apps.oe_blanket_lines_all obla
where 1=1
and obha.header_id=obla.header_id
and ORDER_NUMBER='900002'
--and rownum<=3


-----------------------------------************------------------------------------------
SELECT
*
FROM
APPS.PA_DRAFT_REVENUES_ALL

-----------------------------------************------------------------------------------
SELECT      GLCC.concatenated_segments segments
                    ,GJL.period_name
                    ,GJH.name journal_name
                    ,GJB.name batch_name
                    ,GJH.je_source journal_source
                    ,GJH.je_category journal_category
                    ,GLCC.segment1 entity_segment
                    ,GLCC.segment2 project_segment
                    ,FFV.attribute1 project_vertical_dff
                    ,GLCC.segment3
                    ,GLCC.segment4
                    ,GLCC.segment5
                    ,GLCC.segment6
                    ,GLCC.segment7
                    ,TO_CHAR (GJH.doc_sequence_value) gl_doc_no
                    ,TO_CHAR (GJH.default_effective_date, 'DD-MON-YYYY') gl_date
                    ,TO_CHAR (GJH.posted_date, 'DD-MON-YYYY') posted_date
                    ,PE.expenditure_group document_number
                    ,PE.expenditure_group document_description
                    ,TO_CHAR (PEI.expenditure_item_date, 'DD-MON-YYYY')  document_date
--                  ,PPA.project_status_code document_status     
                    ,PPA.segment1 project_code 
                    ,PT.task_number task_code        
                    ,PEI.expenditure_type  
                    ,PEI.raw_cost transaction_cur_amount
                    ,PPA.project_currency_code entered_currency_code
                    ,PPA.project_rate_type exchange_rate_type
                    ,PEI.project_exchange_rate exchange_rat
   FROM       apps.gl_je_batches GJB
                    ,apps.gl_je_headers GJH
                    ,apps.gl_je_lines   GJL
                    ,apps.gl_code_combinations_kfv GLCC
                    ,apps.gl_import_references GIR
                    ,apps.xla_ae_headers  XAH
                    ,apps.xla_ae_lines    XAL
                    ,apps.xla_events      XE
                    ,apps.xla_distribution_links XDL
                    ,apps.pa_cost_distribution_lines_all PDL
                    ,apps.pa_expenditure_items_all PEI
                    ,apps.pa_expenditures_all PE
                    ,apps.pa_tasks PT
                    ,apps.pa_projects_all PPA
                    ,apps.fnd_flex_value_sets FVS
                    ,apps.fnd_flex_values FFV
         WHERE  GJB.je_batch_id         = GJH.je_batch_id          
         AND    GJH.je_header_id        = GJL.je_header_id
         AND    GJL.code_combination_id = GLCC.code_combination_id
         AND    GJL.je_header_id        = GIR.je_header_id
         AND    GJH.je_batch_id         = GIR.je_batch_id
         AND    GJL.je_line_num         = GIR.je_line_num
         AND    GIR.gl_sl_link_id       = XAL.gl_sl_link_id
         AND    GIR.gl_sl_link_table    = XAL.gl_sl_link_table
         AND    XAH.ae_header_id        = XAL.ae_header_id
         AND    XAH.application_id      = XAL.application_id
         AND    XAH.event_id            = XE.event_id
         AND    XAL.ae_header_id        = XDL.ae_header_id
         AND    XAL.ae_line_num         = XDL.ae_line_num
         AND    XDL.source_distribution_id_num_1 = PDL.expenditure_item_id 
         AND    PDL.expenditure_item_id  = PEI.expenditure_item_id
         AND    PEI.expenditure_id       = PE.expenditure_id
         AND    PEI.task_id              = PT.task_id
         AND    PT.project_id            = PPA.project_id
         AND    FFV.flex_value_set_id    = FVS.flex_value_set_id(+)
         AND    GLCC.segment2            = FFV.flex_value(+) 
--         AND UPPER (FVS.flex_value_set_name) = UPPER ('PLL_Project')
    --  AND    XAH.entity_id        = XTE.entity_id
    --  AND xte.application_id = 275
--        AND    GJH.je_source               = 'Project Accounting'
        AND    GJH.je_category             = 'Miscellaneous Transaction'
--        AND    GJH.status                  = 'P' 
--        AND    GJH.default_effective_date >= lc_gl_date_from
--        AND    GJH.default_effective_date <= lc_gl_date_to
--        AND    TRUNC (GJH.posted_date) BETWEEN NVL (lc_gl_posted_from,TRUNC (GJH.posted_date))AND NVL (lc_gl_posted_to ,TRUNC (GJH.posted_date))
--        AND    GJH.je_source               = NVL (p_gl_source, GJH.je_source)
--        AND    GJH.je_category             = NVL (p_gl_category, GJH.je_category)
        --        AND    GLCC.concatenated_segments BETWEEN (p_account_from) AND (p_account_to)
--        AND    GLCC.segment1 BETWEEN  lc_segment_from(1) AND  lc_segment_to(1)
--        AND    GLCC.segment2 BETWEEN  lc_segment_from(2) AND  lc_segment_to(2)
--        AND    GLCC.segment3 BETWEEN  lc_segment_from(3) AND  lc_segment_to(3)
--        AND    GLCC.segment4 BETWEEN  lc_segment_from(4) AND  lc_segment_to(4)
--        AND    GLCC.segment5 BETWEEN  lc_segment_from(5) AND  lc_segment_to(5)
--        AND    GLCC.segment6 BETWEEN  lc_segment_from(6) AND  lc_segment_to(6)
--        AND    GLCC.segment7 BETWEEN  lc_segment_from(7) AND  lc_segment_to(7)
--        AND    NVL (FFV.attribute1, '-1')      = NVL (p_proj_vertical_dff, NVL (FFV.attribute1, '-1'))
and PPA.project_id='46011'