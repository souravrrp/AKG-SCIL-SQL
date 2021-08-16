SELECT
--QPF.*
QPFL.*
FROM
APPS.QP_PRICE_FORMULAS QPF
,APPS.QP_PRICE_FORMULA_LINES QPFL
WHERE 1=1
AND QPF.PRICE_FORMULA_ID=QPFL.PRICE_FORMULA_ID
AND QPF.NAME='AKG Marble General Commission Polish'--'AKG SCIL Product Incentive'


------------------------------------------------------------------------------------------------
SELECT
*
FROM
APPS.QP_PRICE_FORMULAS--qp_price_formulas_vl 

SELECT
*
FROM
APPS.QP_PRICE_FORMULA_LINES

------------------------------------------------------------------------------------------------
SELECT
*
FROM
APPS.QP_PRICE_FORMULAS_VL--qp_price_formulas_vl 