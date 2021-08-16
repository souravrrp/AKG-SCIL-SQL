/* Formatted on 7/3/2013 3:18:17 PM (QP5 v5.163.1008.3004) */
  SELECT DISTINCT xe.*
    FROM 
        ap_invoices_all ai, 
        xla_events xe, 
        xla.xla_transaction_entities xte
   WHERE     xte.application_id = 200   -- Application_id=200 For AP
         AND xte.application_id = xe.application_id
         AND ai.invoice_id = '166014'
         AND xte.entity_code = 'AP_INVOICES'
         AND xte.source_id_int_1 = ai.invoice_id
         AND xte.entity_id = xe.entity_id
ORDER BY xe.entity_id, xe.event_number;


    
SELECT XE.*
FROM XLA.XLA_EVENTS XE
WHERE
    XE.ENTITY_ID IN (SELECT DISTINCT ENTITY_ID 
                            FROM XLA.XLA_TRANSACTION_ENTITIES
                            WHERE
                                LEDGER_ID=2025
                                AND APPLICATION_ID=200
                                AND TO_CHAR(CREATION_DATE,'YYYY')>=2013) 
    AND XE.ENTITY_ID=5247447                               
order by XE.ENTITY_ID;


select *
from XLA.XLA_TRANSACTION_ENTITIES XTE
where
    XTE.ENTITY_ID=5247447                                