SELECT
*
FROM
APPS.RA_CUSTOMER_TRX_ALL
WHERE 1=1
--JOINED BY CUSTOMER_TRX_ID, BILL_TO_CUSTOMER_ID, SHIP_TO_CUSTOMER_ID, SHIP_TO_SITE_USE_ID, BILL_TO_SITE_USE_ID, SHIP_TO_SITE_USE_ID, 
--CONDITIONED BY ORG_ID, BILL_TO_SITE_USE_ID, SHIP_TO_SITE_USE_ID, 
--FIND OUT TRX_NUMBER, CUST_TRX_TYPE_ID, SET_OF_BOOKS_ID, 
AND TRX_NUMBER='511300067'


SELECT
*
FROM
APPS.RA_CUSTOMER_TRX_LINES_ALL RCTLA
WHERE 1=1
--JOINED BY CUSTOMER_TRX_LINE_ID, CUSTOMER_TRX_ID, ORG_ID, WAREHOUSE_ID
--CONDITIONED BY LINE_NUMEBR, SET_OF_BOOKS_ID, SHIP_TO_CUSTOMER_ID, SHIP_TO_SITE_USE_ID, 
--SEARCH BY INVENTORY_ITEM_ID, DESCRIPTION, 
--FIND OUT QUANTITY_ORDERED, QUANTITY_INVOICED, UNIT_SELLING_PRICE, SALES_ORDER, SALES_ORDER_DATE, UOM_CODE, 
--PRINT_OUT EXTENDED_AMOUNT, REVENUE_AMOUNT, 


SELECT
*
FROM
APPS.RA_CUST_TRX_TYPES_ALL
WHERE 1=1
--AND TYPE = 'INV'

---------------------------------------------------------------------------------------------------------------------------

SELECT
*
FROM
APPS.AR_CASH_RECEIPTS_ALL
WHERE 1=1
--JOINED BY CASH_RECEIPT_ID, SET_OF_BOOKS_ID, CUSTOMER_SITE_USE_ID
--FIND OUT AMOUNT, ORG_ID
--CONDITIONED BY STATUS, TYPE(PAYMENT TYPE), RECEIPT_DATE, DEPOSIT_DATE
--SERACH BY RECEIPT_NUMBER,
AND RECEIPT_NUMBER='415107660'
--order by DEPOSIT_DATE desc

SELECT
*
FROM
APPS.AR_CASH_RECEIPT_HISTORY_ALL ACRHA
--JOIN BY CASH_RECEIPT_ID, ORG_ID
--CONDITIONED BY STATUS(CONFIRMED,REMITTED,CLEARED), 
--FIND OUT TRX_DATE, AMOUNT, GL_DATE, GL_POSTING_DATE,

---------------------------------------------------------------------------------------------------------------------------

SELECT
ACRA.RECEIPT_NUMBER,
ACRA.AMOUNT,
ACRA.STATUS, 
ACRA.TYPE PAYMENT_TYPE, 
ACRA.RECEIPT_DATE, 
ACRA.DEPOSIT_DATE,
ACRA.DOC_SEQUENCE_VALUE,
ACRHA.STATUS RECEIPT_TYPE,
ACRHA.TRX_DATE,
ACRHA.AMOUNT RECEIPT_AMOUNT,
ACRHA.GL_DATE
FROM
APPS.AR_CASH_RECEIPTS_ALL ACRA,
APPS.AR_CASH_RECEIPT_HISTORY_ALL ACRHA
WHERE 1=1
AND ACRA.CASH_RECEIPT_ID=ACRHA.CASH_RECEIPT_ID
AND ACRA.ORG_ID=85
AND ACRA.RECEIPT_NUMBER='5813329'

------------------------------------------------------------------------------------------------


SELECT * FROM  APPS.RA_CUST_TRX_LINE_GL_DIST_ALL RCTLGDA
WHERE 1=1
--JOINED BY CUST_TRX_LINE_GL_DIST_ID, CUSTOMER_TRX_LINE_ID, CODE_COMBINATION_ID, SET_OF_BOOKS_ID, CUSTOMER_TRX_ID, ORG_ID, 
--FIND OUT PERCENT, AMOUNT, GL_DATE, GL_POSTED_DATE, ACCTD_AMOUNT, 
--CONDITIONED BY ACCOUNT_CLASS, 
AND ACCOUNT_CLASS NOT IN ('REV','REC')


SELECT
*
FROM
APPS.AR_PAYMENT_SCHEDULES_ALL
WHERE 1=1
--JOINED BY PAYMENT_SCHEDULE_ID, CUSTOMER_ID, CUSTOMER_SITE_USE_ID, CASH_RECEIPT_ID, 
--FIND OUT DUE_DATE, AMOUNT_DUE_ORIGINAL, AMOUNT_APPLIED, 
--CONDITIONED BY STATUS, CLASS, TRX_NUMBER, TRX_DATE, GL_DATE, 
--SEARCH BY GL_DATE_CLOSED, ACTUAL_DATE_CLOSED, 

------------------------------------------------------------------------------------------------


SELECT
*
FROM
APPS.AR_RECEIVABLES_TRX_ALL
WHERE 1=1
-- FIND OUT CREATION_DATE, 
--CONDITIONED BY STATUS('ADJUST'), TYPE, ORG_ID, 
--GROUP BY NAME , DESCRIPTION



SELECT
*
FROM
XLA.XLA_TRANSACTION_ENTITIES
WHERE 1=1
--FIND OUT APPLICATION_ID, LEGAL_ENTITY_ID, CREATION_DATE, LEDGER_ID
--JOIN BY TRANSACTION_NUMBER
--AND ROWNUM<=2


------------------------------------------------------------------------------------------------


SELECT
*
FROM
APPS.AR_RECEIVABLE_APPLICATIONS_ALL
--JOIND BY RECEIVABLE_APPLICATION_ID, CODE_COMBINATION_ID , ORG_ID
--FIND OUT AMOUNT_APPLIED, GL_DATE, GL_POSTED_DATE

SELECT
*
FROM
APPS.AR_CUSTOMERS
WHERE 1=1
--JOINED BY CUSTOMER_ID, 
--SEARCH BY 
--FIND OUT CUSTOMER_NAME, CUSTOMER_NUMBER, STATUS, ORIG_SYSTEM_REFERENCE
--CONDITIONED BY STATUS

SELECT
*
FROM
APPS.AR_DISTRIBUTIONS_ALL
where 1=1
--SERACH BY ORG_ID
--JOINED BY CODE_COMBINATION_ID
--CONNCETED BY LINE_ID, SOURCE_ID, AMOUNT_DR, AMOUNT_CR


------------------------------------------------------------------------------------------------

SELECT * FROM APPS.RA_CUST_TRX_LINE_SALESREPS_ALL

SELECT * FROM APPS.AR_RECEIVABLE_APPLICATIONS_ALL


------------------------------------------------------------------------------------------------

select
*
from
apps.ar_adjustments_all

select
*
from
apps.ar_distribution_sets_all

select
*
from
apps.ar_transaction_history_all

select
*
from
apps.ra_teRms


SELECT
*
FROM
APPS.RA_CUST_TRX_LINE_GL_DIST_V

SELECT
*
FROM
APPS.GL_BALANCES

SELECT
*
FROM
APPS.AR_ADJUSTMENTS_ALL

----------------------------------------------------------------------

------------------------*****Oracle Apps Receivables (AR) Tables---------------------



----------------------------------------Transactions-----------------------------------------

RA_CUSTOMER_TRX_ALL
Transaction Header table
RA_CUSTOMER_TRX_LINES_ALL
Transaction Lines table along with Tax lines.
RA_CUST_TRX_LINE_GL_DIST_ALL
Distribution for Transaction Lines
RA_CUST_TRX_LINE_SALESREPS_ALL
Salesrep information for Transaction Lines


----------------------------------------Transaction Interface Tables-----------------------

RA_INTERFACE_LINES_ALL
Transaction Lines interface
RA_INTERFACE_SALESCREDITS_ALL
Transaction Sales credit information
RA_INTERFACE_DISTRIBUTIONS_ALL
Transaction Distribution information
RA_INTERFACE_ERRORS_ALL
Transaction errors table
AR_PAYMENTS_INTERFACE_ALL
Interface table to import receipts
AR_INTERIM_CASH_RECEIPTS_ALL
Lockbox transfers the receipts that pass validation to the interim tables
AR_INTERIM_CASH_RCPT_LINES_ALL
Lockbox transfers the receipts that pass validation to the interim tables


-------------------------------------------Receipts tables------------------------------------

AR_CASH_RECEIPTS_ALL
Cash Receipt Header tables
AR_RECEIVABLE_APPLICATIONS_ALL
stores Receipt Application details
AR_PAYMENT_SCHEDULES_ALL
This table is updated when an activity occurs against an invoice, debit memo, chargeback, credit memo, on-account credit, bills receivable
AR_CASH_RECEIPT_HISTORY_ALL
This table stores all of the activity that is contained for the life cycle of a receipt.
• Each row represents one step.
• The status field for that row tells you which step the receipt has reached.
• Possible statuses are Approved, Confirmed, Remitted, Cleared, and Reversed.
RA_BATCH_SOURCES_ALL


-------------------------------------------Customer Tables----------------------------------

HZ_PARTIES
A party is an entity that can enter into a business relationship.
HZ_CUST_ACCOUNTS
This table stores information about customer/financial relationships established between a Party and the deploying company.
HZ_PARTY_SITES
This table links a party (HZ_PARTIES) and a location (HZ_LOCATIONS) and stores location-Specific party information such as a person’s mail stops at their work address.
HZ_CUST_ACCT_SITES_ALL
This table stores information about customer/financial account sites information.
HZ_CUST_SITE_USES_ALL
This table stores information about the business purposes assigned to a customer account site
HZ_LOCATIONS
A location is a point in geographical space described by an address and/or geographical Indicators such as latitude or longitude.


---------------------------------------Setup tables-------------------------------------------

RA_CUST_TRX_TYPES_ALL
This table stores information about each transaction type for all classes of transactions, for example, invoices, commitments, and credit memos.
AR_RECEIPT_CLASSES
This table stores the different receipt classes that you define.
AR_RECEIPT_METHODS
This table stores information about Payment Methods, receipt attributes that you define and assign to Receipt Classes to account for receipts and their applications
