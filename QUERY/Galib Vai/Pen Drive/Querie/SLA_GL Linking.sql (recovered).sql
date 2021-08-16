SELECT XE.*
FROM XLA.XLA_EVENTS XE
WHERE
    XE.ENTITY_ID IN (SELECT DISTINCT ENTITY_ID 
                            FROM XLA.XLA_TRANSACTION_ENTITIES
                            WHERE
                                LEDGER_ID=2025
                                AND APPLICATION_ID=200
                                AND TO_CHAR(CREATION_DATE,'YYYY')>=2013
                                AND SOURCE_ID_INT_1 IN (SELECT INVOICE_ID FROM  AP.AP_INVOICES_ALL 
                                                                            WHERE 
                                                                            INVOICE_NUM='MTO/SCOU/003303'))                               
ORDER BY XE.ENTITY_ID;


/** XLA_AE_HEADERS**/

select XAH.*
from XLA.XLA_AE_HEADERS XAH
where
    XAH.ENTITY_ID in (SELECT DISTINCT ENTITY_ID 
                            FROM XLA.XLA_TRANSACTION_ENTITIES
                            WHERE
                                LEDGER_ID=2025
                                AND APPLICATION_ID=200
                                AND TO_CHAR(CREATION_DATE,'YYYY')>=2013
                                AND SOURCE_ID_INT_1 IN (SELECT INVOICE_ID FROM  AP.AP_INVOICES_ALL 
                                                                            WHERE 
                                                                            INVOICE_NUM='MTO/SCOU/003303'))
order by XAH.ENTITY_ID;



/**XLA_AE_LINES**/

SELECT 
    XAL.*,
--    XAL.AE_HEADER_ID,
--    XAL.ACCOUNTING_CLASS_CODE,
--    sum(NVL(XAL.ACCOUNTED_CR,0)) Total_CR,
--    SUM(NVL(XAL.ACCOUNTED_DR,0)) Total_DR
--    SUM(NVL(XAL.ACCOUNTED_DR,0))-sum(NVL(XAL.ACCOUNTED_CR,0)) Value
    apps.fnd_flex_ext.get_segs('SQLGL','SQL#',50577,XAL.code_combination_id) Account
FROM 
    XLA.XLA_AE_HEADERS XAH,
    XLA.XLA_AE_LINES XAL
WHERE
    XAH.AE_HEADER_ID=XAL.AE_HEADER_ID
    AND XAH.ENTITY_ID IN (SELECT DISTINCT ENTITY_ID 
                            FROM XLA.XLA_TRANSACTION_ENTITIES
                            WHERE
                                LEDGER_ID=2025
                                AND APPLICATION_ID=200
                                AND ENTITY_CODE='AP_INVOICES'
--                                AND TO_CHAR(CREATION_DATE,'YYYY')>=2013
                                AND SOURCE_ID_INT_1 IN (SELECT INVOICE_ID FROM  AP.AP_INVOICES_ALL 
                                                                            WHERE 
                                                                            INVOICE_NUM='MTO/SCOU/003303'))
GROUP BY
--    XAL.AE_HEADER_ID
    XAL.ACCOUNTING_CLASS_CODE                                                                            