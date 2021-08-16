SELECT
*
FROM
apps.AP_CHECKS_ALL PAY
WHERE 1=1
AND ((:P_ORG_ID IS NULL AND PAY.ORG_ID IN (83,84,85,605))  OR (PAY.ORG_ID=:P_ORG_ID))
AND TRUNC(PAY.CHECK_DATE) BETWEEN NVL(:P_DATE_FROM,TRUNC(PAY.CHECK_DATE)) AND NVL(:P_DATE_TO,TRUNC(PAY.CHECK_DATE))