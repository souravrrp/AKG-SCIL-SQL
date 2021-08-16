/* Formatted on 7/16/2019 2:38:06 PM (QP5 v5.287) */
SELECT * FROM INV.MTL_PARAMETERS;

SELECT * FROM APPS.MTL_INTERORG_PARAMETERS;

SELECT * FROM APPS.MTL_SECONDARY_INVENTORIES;

SELECT * FROM APPS.MTL_SECONDARY_INVENTORIES_FK_V;

--------------------------INVENTORY TRANSACTIONS--------------------------------

SELECT * FROM INV.MTL_MATERIAL_TRANSACTIONS;

SELECT * FROM INV.MTL_TRANSACTION_TYPES;

SELECT * FROM INV.MTL_TRANSACTION_REASONS;

SELECT * FROM INV.MTL_TRANSACTION_ACCOUNTS;

SELECT * FROM APPS.MTL_TXN_REQUEST_HEADERS;

SELECT * FROM APPS.MTL_TXN_REQUEST_LINES;

SELECT * FROM APPS.MTL_TXN_SOURCE_TYPES;

SELECT * FROM APPS.MTL_MATERIAL_STATUS_HISTORY;

--------------------------INVENTORY ITEM----------------------------------------

SELECT * FROM INV.MTL_SYSTEM_ITEMS_B;

SELECT * FROM APPS.MTL_ITEM_STATUS;

SELECT * FROM APPS.MTL_PENDING_ITEM_STATUS;

SELECT * FROM INV.MTL_ITEM_ATTRIBUTES;

SELECT * FROM INV.MTL_UNITS_OF_MEASURE_TL;

SELECT * FROM APPS.MTL_UOM_CLASS_CONVERSIONS;

SELECT * FROM APPS.MTL_ITEM_LOCATIONS;

SELECT * FROM INV.MTL_ITEM_CATEGORIES;

SELECT * FROM INV.MTL_CATEGORIES_B;

SELECT * FROM INV.MTL_CATEGORY_SETS_B;

SELECT * FROM APPS.MTL_CATEGORY_SETS;

SELECT * FROM APPS.MTL_GRADES_B;

----------------------------INVENTORY LOT---------------------------------------

SELECT * FROM INV.MTL_LOT_NUMBERS MLN;

SELECT * FROM INV.MTL_TRANSACTION_LOT_NUMBERS MTLN;

SELECT * FROM APPS.MTL_LOT_GRADE_HISTORY;

-------------------------STOCK ALLOCATION---------------------------------------

SELECT * FROM INV.MTL_DEMAND;

SELECT * FROM APPS.MTL_DEMAND_HISTORIES;

SELECT * FROM APPS.MTL_SUPPLY;

SELECT * FROM INV.MTL_ONHAND_QUANTITIES;

SELECT * FROM INV.MTL_ITEM_CATALOG_GROUPS_B;

SELECT * FROM INV.MTL_ITEM_REVISIONS_B;

SELECT * FROM APPS.MTL_ITEM_REVISIONS;

SELECT * FROM APPS.MTL_RESERVATIONS;

SELECT * FROM APPS.MTL_RESERVATIONS_ALL_V;

-------------------------------INVENTORY TRANSACTION INTERFACE------------------

SELECT * FROM INV.MTL_SYSTEM_ITEMS_INTERFACE;

SELECT * FROM INV.MTL_TRANSACTIONS_INTERFACE;

SELECT * FROM INV.MTL_ITEM_REVISIONS_INTERFACE;

SELECT * FROM INV.MTL_ITEM_CATEGORIES_INTERFACE;

SELECT * FROM INV.MTL_DEMAND_INTERFACE;

SELECT * FROM INV.MTL_INTERFACE_ERRORS;


----------------------INVENTORY MOVE ORDER--------------------------------------

SELECT * FROM INV.MTL_TXN_REQUEST_HEADERS;

SELECT * FROM INV.MTL_TXN_REQUEST_LINES;

SELECT * FROM INV.MTL_TXN_REQUEST_HEADERS_V;

SELECT * FROM APPS.CST_ITEM_COSTS;

-----------------------------------INVENTORY OM---------------------------------

SELECT * FROM APPS.MTL_SALES_ORDERS;

--------------------------------------------------------------------------------

SELECT * FROM APPS.WF_PROCESS_ACTIVITIES;

SELECT * FROM APPS.WF_ITEM_ACTIVITY_STATUSES;


---------------------------INVENYORY PRODUCTIONS--------------------------------

SELECT * FROM APPS.MTL_MFG_PART_NUMBERS;

-------------------------------VIEW---------------------------------------------

SELECT * FROM APPS.MTL_TRX_REQUEST_LINES_V;


----------------------------NO DATA---------------------------------------------

SELECT * FROM INV.MTL_CUSTOMER_ITEMS;

--------------------------------------------------------------------------------

SELECT * FROM APPS.MTL_MFG_PART_NUMBERS;