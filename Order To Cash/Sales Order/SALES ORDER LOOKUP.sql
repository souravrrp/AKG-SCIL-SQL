SELECT DISTINCT
--ORG_ID,
PAYMENT_TYPE_CODE,
NAME,
DESCRIPTION
FROM
APPS.OE_PAYMENT_TYPES_TL


SELECT DISTINCT
OTTT.TRANSACTION_TYPE_ID,
NAME,
DESCRIPTION
FROM
APPS.OE_TRANSACTION_TYPES_TL OTTT

--------------------------------------------------------------------------------
Usual Order Management Tables
OE_ORDER_HEADERS_ALL: Order Header Table
OE_ORDER_LINES_ALL: Order Line Table 
OE_LOOKUPS: Lookup table for values related types of entries in OE
OE_ORDER_HOLDS: Holds created for a Line or Header ID
OE_HOLD_SOURCES: Parent Hold to get the Source Name in OE_HOLD_DEFINITIONS
OE_HOLD_DEFINITIONS: where name of the Order Hold is stored
OE_TRANSACTION_TYPES_TL: Order Transaction Types
OE_PRICE_ADJUSTMENTS: Adjustment to the lines or headers due to modifier or discounts
OE_DROP_SHIP_SOURCES: table related to the PO Requisition for the Drop Ship Orders
QP_LIST_HEADERS_VL: Pricing Discount Headers
QP_LIST_LINES: Pricing Discount Lines
QP_MODIFIER_SUMMARY_V: Pricing Modifiers
QP_QUALIFIERS_V: Qualifiers for Discounts
QP_PRICING_ATTRIBUTES: Attributes whether ITEM, CATEGORY, etc and values

Shipment Tables
WSH_DELIVERY_DETAILS: stores the details of the deliveries such as Item 
WSH_NEW_DELIVERIES: stores the status of the delivery
WSH_DELIVERY_LEGS: the table link between the WSH_TRIP_STOPS (using STOP_ID) and WSH_DELIVERIES (using delivery_id)
WSH_DELIVERY_LEG_DETAILS
WSH_DELIVERY_LEG_ACTIVITIESWSH_DELIVERY_ASSIGNMENTS: Deliveries associated with the Delivery Details
WSH_CARRIERS
WSH_CARRIER_SERVICES
WSH_CARRIER_SHIP_METHODS
WSH_DOCUMENT_INSTANCES
WSH_DOC_SEQUENCE_CATEGORIES
WSH_EXCEPTIONS
WSH_EXCEPTION_DEFINITIONS_B
WSH_EXCEPTION_DEFINITIONS_TL
WSH_GLOBAL_PARAMETERS
WSH_INTERFACE_ERRORS
WSH_ORG_CARRIER_SERVICES
WSH_ORG_CARRIER_SITES
WSH_PICKING_BATCHES
WSH_PICKING_RULES
WSH_PICK_GROUPING_RULES
WSH_PICK_SEQUENCE_RULES
WSH_SERIAL_NUMBERS
WSH_SHIPPING_PARAMETERS
WSH_TRANSACTION_HISTORY
WSH_TRIPS
WSH_TRIP_STOPS
WSH_REPORT_SETS

Interface
OE_LINES_IFACE_ALL: Interface table for Order Lines
OE_HEADERS_IFACE_ALL: Interface table for Order Headers
WSH_DEL_ASSGN_INTERFACE: Delivery Assignments
WSH_DEL_DETAILS_INTERFACE: Delivery details it has delivery ID
WSH_DEL_LEG_INTERFACE:
WSH_TRIP_INTERFACE: Trip Interface during shipment

OTHER RELATED:
MTL_TRXN_REQUEST_LINES: Used in Pick Confirm
MTL_MATERIAL_TRANSACTIONS_TEMP: Staging for Pick Confirm
