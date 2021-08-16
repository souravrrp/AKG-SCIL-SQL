/** Inventory Organization Period Status**/
SELECT 
    oad.ORGANIZATION_ID,
    oad.PERIOD_NAME,
    CASE OPEN_FLAG
        WHEN 'Y' THEN 'OPEN' ELSE 'CLOSED'
    END OPEN_STATUS
FROM 
    INV.ORG_ACCT_PERIODS oap,
    apps.org_organization_definitions ood
WHERE 
    oap.organization_id=ood.organization_id
--    ORGANIZATION_ID=:ORGANIZATION_ID
--    ORGANIZATION_ID IN ('89','91','92','99','100','101','102','103','104','105','106','107','108','109','110','111','112','113','114','115','116','117','118','119','120','121','126','181',
--                                    '182','183','184','185','186','187','201','281','362','365','424','425','444','484','524')

    and oap.PERIOD_NAME=:PERIOD_NAME
ORDER BY
    ORGANIZATION_ID;    
    
    
/** OPM Period Status**/
SELECT
    PERIOD_CODE,
    CASE PERIOD_STATUS
        WHEN 'O' THEN 'OPEN'
        WHEN 'C' THEN 'CLOSED'
        WHEN 'F' THEN 'FROZEN' ELSE 'UNKNOWN'
    END PERIOD_STATUS
FROM GMF.GMF_PERIOD_STATUSES
WHERE
    LEGAL_ENTITY_ID=23279   --CEMENT
--    LEGAL_ENTITY_ID=23280   --STEEL
    AND CALENDAR_CODE='AKG2013'
ORDER BY
    PERIOD_CODE;
        

    
select * from ALL_OBJECTS 
where 
    OBJECT_NAME like '%ORG%DEFIN%'
--    and OBJECT_TYPE='TABLE'
--    and OWNER='INV'
--    and rownum<10    