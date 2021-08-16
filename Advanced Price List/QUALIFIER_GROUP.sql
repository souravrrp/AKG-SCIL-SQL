SELECT
*
FROM
APPS.qp_qualifier_rules R
,APPS.qp_qualifiers Q
WHERE 1=1
AND Q.CREATED_FROM_RULE_ID=R.QUALIFIER_RULE_ID
AND NAME='BFD Promotional Items for 1 Pcs for 48 for Milk'


SELECT
*
FROM
APPS.qp_qualifiers

SELECT
*
FROM
APPS.qp_qualifier_rules
WHERE 1=1
AND NAME='CGD Credit Distributor List'