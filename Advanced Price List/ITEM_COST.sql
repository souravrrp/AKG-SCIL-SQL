SELECT
*
FROM
APPS.GL_ITEM_CST GIC
WHERE 1=1
--FIND OUT ACCTG_COST, 
--JOINED BY  INVENTORY_ITEM_ID, ORGANIZATION_ID, PERIOD_ID,
--SEARCH BY ITEM_COST_ID, 
--CONDITIONED BY PROGRAM_ID, COST_TYPE_ID, 


SELECT
*
FROM
APPS.CST_ITEM_COSTS
WHERE 1=1
--JOINED BY INVENTORY_ITEM_ID, ORGANIZATION_ID, COST_TYPE_ID,
--FIND OUT ITEM_COST, MATERIAL_COST, 
--AND ORGANIZATION_ID=101


SELECT
*
FROM
APPS.CST_COST_TYPES
--JOINED BY COST_TYPE_ID, 
--SEARCH BY COST_TYPE, DESCRIPTION

------------------------------------------------------------------------------------------------------

SELECT
*
FROM
APPS.ORG_ACCT_PERIODS


SELECT
*
FROM
APPS.MTL_TRANSACTION_ACCOUNTS
WHERE 1=1
AND ORGANIZATION_ID='85'


SELECT
*
FROM
APPS.GL_DAILY_BALANCES


------------------------------------------------------------------------------------------------------

SELECT
MSI.ORGANIZATION_ID,
MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
CIC.ITEM_COST, 
CIC.MATERIAL_COST,
CCT.COST_TYPE, 
CCT.DESCRIPTION
FROM
APPS.CST_ITEM_COSTS CIC,
APPS.CST_COST_TYPES CCT
,APPS.MTL_SYSTEM_ITEMS_B MSI
WHERE 1=1
AND CIC.COST_TYPE_ID=CCT.COST_TYPE_ID
AND MSI.INVENTORY_ITEM_ID=CIC.INVENTORY_ITEM_ID
AND MSI.ORGANIZATION_ID=CIC.ORGANIZATION_ID
--AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('CMNT.SBAG.0003')
--AND CIC.INVENTORY_ITEM_ID=158815
AND CIC.ORGANIZATION_ID=101




SELECT   msi.concatenated_segments item_code,
mmt.transaction_date,
mtt.transaction_type_name,
mmt.transaction_quantity,
mcd.prior_cost,
mcd.new_cost
FROM apps.mtl_cst_actual_cost_details mcd,
apps.mtl_system_items_kfv msi,
apps.mtl_material_transactions mmt,
apps.mtl_transaction_types mtt
WHERE 1 = 1
AND mcd.inventory_item_id = msi.inventory_item_id
AND mcd.organization_id = msi.organization_id
AND mcd.transaction_id = mmt.transaction_id
AND mmt.inventory_item_id = msi.inventory_item_id
AND mmt.organization_id = msi.organization_id
AND mmt.transaction_type_id = mtt.transaction_type_id
--AND msi.concatenated_segments='CMNT.SBAG.0003'
ORDER BY mcd.creation_date DESC

SELECT
--CACD.TRANSACTION_ID,
CACD.ORGANIZATION_ID,
MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 ITEM_CODE,
--MSI.INVENTORY_ITEM_ID,
MSI.DESCRIPTION,
CACD.ACTUAL_COST,
--CACD.PRIOR_COST,
CACD.NEW_COST
FROM
APPS.MTL_CST_ACTUAL_COST_DETAILS CACD
,APPS.MTL_SYSTEM_ITEMS_B MSI
WHERE 1=1
AND MSI.ORGANIZATION_ID=CACD.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID=CACD.INVENTORY_ITEM_ID
AND MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3 IN ('FAN1.EXST.0009')
AND CACD.INSERTION_FLAG='Y'--Y
--AND CACD.INVENTORY_ITEM_ID=158815


SELECT
*
FROM
APPS.MTL_CST_ACTUAL_COST_DETAILS CACD
WHERE 1=1
AND CACD.ORGANIZATION_ID=101


select msi.segment1 "ITEM_NUM",
msi.description "ITEM_DESCRIPTION",
msi.PRIMARY_UNIT_OF_MEASURE "UOM",
cct.cost_type "COST TYPE",
cic.DEFAULTED_FLAG "USE DEFAULT CONTROLS",
msi.INVENTORY_ASSET_FLAG "INVENTORY ASSET",
cic.BASED_ON_ROLLUP_FLAG "BASED ON ROLLUP",
cic.LOT_SIZE,
cic.shrinkage_rate "MANUFACTURING SHRINKAGE",
cic.item_cost "UNIT COST",
cic.MATERIAL_COST "MATERIAL",
cic.MATERIAL_OVERHEAD_COST "MATERIAL_OVERHEAD",
cic.RESOURCE_COST "RESOURCE",
cic.OUTSIDE_PROCESSING_COST "OUTSIDE_PROCESSING",
cic.OVERHEAD_cost "OVERHEAD",
gcc.CONCATENATED_SEGMENTS "COGS_ACCOUNT",
gcc1.CONCATENATED_SEGMENTS "SALES_ACCOUNT",
flv.MEANING "MAKE/BUY",
msi.DEFAULT_INCLUDE_IN_ROLLUP_flag "INCLUDE IN ROLLUP",
(SELECT  mic.segment1
                   || '.'
                   || mic.segment2
                   || '.'
                   || mic.segment3
                   || '.'
                   || mic.segment4
                   || '.'
                   || mic.segment5
                   || '.'
                   || mic.segment6
            FROM   APPS.MTL_ITEM_CATEGORIES_V mic, APPS.mtl_category_sets mcs
           WHERE       mic.CATEGORY_SET_ID = mcs.CATEGORY_SET_ID
                   AND mcs.CATEGORY_SET_NAME = 'ENVS CST Category Set'
                   AND mic.inventory_item_id = msi.inventory_item_id
                   AND mic.organization_id = msi.organization_id)
            "COST CATEGORY"
from APPS.mtl_system_items_b msi,
APPS.cst_cost_types cct,
APPS.cst_item_costs cic,
APPS.org_organization_definitions ood,
APPS.gl_code_combinations_kfv gcc,
APPS.gl_code_combinations_kfv gcc1,
APPS.FND_LOOKUP_VALUES flv
WHERE 1=1
AND cct.cost_type_id = cic.cost_type_id 
AND cic.inventory_item_id = msi.inventory_item_id 
AND cic.organization_id = msi.organization_id
AND msi.organization_id = ood.organization_id
AND gcc.CHART_OF_ACCOUNTS_ID = ood.CHART_OF_ACCOUNTS_ID
AND gcc.CODE_COMBINATION_ID =msi.COST_OF_SALES_ACCOUNT
AND gcc1.CHART_OF_ACCOUNTS_ID = ood.CHART_OF_ACCOUNTS_ID
AND gcc1.CODE_COMBINATION_ID =msi.expense_account
AND flv.lookup_type = 'MTL_PLANNING_MAKE_BUY'
and flv.LOOKUP_CODE=msi.PLANNING_MAKE_BUY_CODE
AND flv.LANGUAGE='US'
AND ood.organization_code = 'SCI'
--and msi.segment1='02980050'
--and msi.inventory_item_id=1117374
