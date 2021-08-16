/* Formatted on 9/7/2019 3:43:18 PM (QP5 v5.287) */
SELECT A.REQUEST_ID,
       A.ORG_ID,
       OU.NAME,
       A.INTERFACE_LINE_ID,
       A.CREATION_DATE,
       A.INTERFACE_LINE_CONTEXT,
       (SELECT HCA.ACCOUNT_NUMBER || ' - ' || HP.PARTY_NAME
          FROM APPS.HZ_CUST_ACCOUNTS HCA, APPS.HZ_PARTIES HP
         WHERE     HCA.PARTY_ID = HP.PARTY_ID
               AND HCA.CUST_ACCOUNT_ID = A.ORIG_SYSTEM_BILL_CUSTOMER_ID)
          CUSTOMER_NAME,
       A.SALES_ORDER,
       (SELECT SEGMENT1 || '.' || SEGMENT2 || '.' || SEGMENT3
          FROM INV.MTL_SYSTEM_ITEMS_B
         WHERE     ORGANIZATION_ID = A.WAREHOUSE_ID
               AND INVENTORY_ITEM_ID = A.INVENTORY_ITEM_ID)
          ITEM_CODE,
       A.DESCRIPTION,
       A.SALES_ORDER_DATE,
       A.SALES_ORDER_SOURCE,
       A.INTERFACE_LINE_ATTRIBUTE2,
       A.INTERFACE_LINE_ATTRIBUTE1,
       A.INTERFACE_LINE_ATTRIBUTE6,
       A.INTERFACE_LINE_ATTRIBUTE11,
       A.BATCH_SOURCE_NAME,
       A.SET_OF_BOOKS_ID,
       A.LINE_TYPE,
       A.QUANTITY,
       A.AMOUNT,
       A.CUST_TRX_TYPE_ID,
       A.SHIP_DATE_ACTUAL,
       A.GL_DATE,
       A.TRX_DATE,
       A.WAREHOUSE_ID,
       A.INVENTORY_ITEM_ID,
       A.TERM_NAME
  FROM APPS.RA_INTERFACE_LINES_ALL A,
       --APPS.RA_INTERFACE_SALESCREDITS_ALL B,
       --APPS.RA_INTERFACE_DISTRIBUTIONS_ALL C,
       APPS.RA_INTERFACE_ERRORS_ALL D,
       APPS.HR_OPERATING_UNITS OU
 WHERE     1 = 1
       AND A.INTERFACE_LINE_ID = D.INTERFACE_LINE_ID
       AND A.ORG_ID = OU.ORGANIZATION_ID
       AND A.ORG_ID = :ORG_ID
       AND A.INTERFACE_STATUS IS NULL
       AND A.BATCH_SOURCE_NAME = 'SCIL Incentive Upload';
 
 
 SELECT
 *
 FROM
 APPS.RA_INTERFACE_LINES_ALL
 WHERE 1=1
 AND INTERFACE_LINE_ID=13524531
 
 SELECT
 *
 FROM
 APPS.AR_INTERIM_CASH_RECEIPTS_ALL
 WHERE 1=1
 --AND INTERFACE_LINE_ID=13524531

--------------------------------------------------------------------------------

/*
Transaction Interface Tables
RA_INTERFACE_LINES_ALL Transaction Lines interface
RA_INTERFACE_SALESCREDITS_ALL Transaction Sales credit information
RA_INTERFACE_DISTRIBUTIONS_ALL Transaction Distribution information
RA_INTERFACE_ERRORS_ALL Transaction errors table
AR_PAYMENTS_INTERFACE_ALL Interface table to import receipts
AR_INTERIM_CASH_RECEIPTS_ALL Lockbox transfers the receipts that pass validation to the interim tables
AR_INTERIM_CASH_RCPT_LINES_ALL Lockbox transfers the receipts that pass validation to the interim tables

________________________________________________________________________________

Receipts TABLES
AR_CASH_RECEIPTS_ALL Cash Receipt Header TABLES
AR_RECEIVABLE_APPLICATIONS_ALL stores Receipt Application details
AR_PAYMENT_SCHEDULES_ALL This TABLE IS UPDATED WHEN an ACTIVITY occurs against an invoice, debit memo, chargeba
credit, bills receivable
AR_CASH_RECEIPT_HISTORY_ALL This TABLE stores ALL OF THE ACTIVITY that IS contained FOR THE life CYCLE OF A receipt.
• EACH ROW represents ONE step.
• THE status FIELD FOR that ROW tells you which step THE receipt has reached.
• Possible statuses ARE Approved, Confirmed, Remitted, Cleared, AND Reversed.

, RA_INTERFACE_DISTRIBUTIONS_ALL
RA_INTERFACE_SALESCREDITS_ALL, RA_INTERFACE_ERRORS_ALL
*/