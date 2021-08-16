XXAKG_SECSALES_REPORT_PKG
XXAKG_SECSALES_IMPORT_PKG
XXAKG_SECSALESORDER_UPLOAD_PKG
Order Import
OEOIMP
OE_ORDER_IMPORT_MAIN_PVT.ORDER_IMPORT_CONC_PGM
FND_REQUEST.SUBMIT_REQUEST
FND_CONCURRENT.WAIT_FOR_REQUEST
OE_CNCL_ORDER_IMPORT_PVT.IMPORT_ORDER

oe_headers_iface_all
oe_lines_iface_all

fnd_concurrent_queues

--------------------------------------------------------------------------------Query
select
*
from
apps.oe_lines_iface_all;

select
*
from
apps.fnd_concurrent_queues


select
*
from
apps.Fnd_Cp_services


select
*
from
apps.fnd_debug_rules


select
*
from
apps.fnd_debug_rule_options

select * from V$NLS_PARAMETERS

SELECT
*
FROM
APPS.oe_headers_interface

SELECT
*
from
apps.oe_reservtns_iface_all