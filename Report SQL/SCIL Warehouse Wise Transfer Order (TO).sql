SELECT distinct from_org.organization_id from_warehouse_id,
         from_org.organization_name from_warehouse,
         to_org.organization_id to_warehouse_id,
         to_org.organization_name to_warehouse,
         to_org.organization_name group_to_warehouse,
         mvh.mov_order_no,
         TRUNC (mvh.mov_order_date) mov_order_date,
            mmt.shipment_number TO_NUMBER,
             TRUNC (mmt.transaction_date) TO_DATE,
         msi.description item_name,
         /*---- Begin: updated from abs(mmt.transaction_quantity) to mmt.transaction_quantity by Imrul*/ -- 1,297 2,188
         DECODE (msi.concatenated_segments,
                 'CMNT.SBAG.0001', mmt.transaction_quantity,
                 NULL)
            sp_quantity,
         DECODE (msi.concatenated_segments,
                 'CMNT.PBAG.0001', mmt.transaction_quantity,
                 NULL)
            pp_quantity,
         --------- Begin: Added by Imrul for OPC ---------------   
         DECODE (msi.concatenated_segments,
                 'CMNT.OBAG.0001', mmt.transaction_quantity,
                 NULL)
            OPC_quantity,          
         DECODE (msi.concatenated_segments,
                 'CMNT.SBAG.0003', mmt.transaction_quantity,
                 NULL)
            SCSB_quantity,
         DECODE (msi.concatenated_segments,
                 'CMNT.PBAG.0003', mmt.transaction_quantity,
                 NULL)
            PCSB_quantity,  
         DECODE (msi.concatenated_segments,
                 'CMNT.CBAG.0001', mmt.transaction_quantity,
                 NULL)
            CEM3B_quantity,             
         --------- End: Added by Imrul for OPC ---------------
         /*---- End: updated from abs(mmt.transaction_quantity) to mmt.transaction_quantity by Imrul*/
         mvh.org_id,
         mvh.final_destination,
         mmt.transaction_uom primary_uom,
         NVL (aps.vendor_name, mvh.transporter_name) transporter_name,
         (select vendor_site_code  from apps.ap_invoices_all a, apps.ap_supplier_sites_all b 
         where a.vendor_id=b.vendor_id and a.vendor_site_id=b.vendor_site_id and a.invoice_num=mvh.mov_order_no and a.org_id= :P_ORG_ID ) vendor_site_code,
         mvh.hire_rate_ap hire_rate,
         transport_mode,
         TRUNC (mmt.transaction_date) transfer_date,
         vehicle_no,
         apps.XXAKG_AP_PKG.GET_INVOICE_CREATION_STATUS (NULL, mvh.mov_order_no)    invoice_status,
         apps.XXAKG_AP_PKG.GET_INVOICE_PAID_STATUS (NULL, mvh.mov_order_no)    bill_status       
    FROM apps.mtl_transaction_types mtt,
         apps.mtl_material_transactions mmt,
         apps.org_organization_definitions from_org,
         apps.org_organization_definitions to_org,
         apps.XXAKG_OE_TO_DO_MOVE_V mvh,
         apps.mtl_system_items_kfv msi,
         apps.ap_suppliers aps
   WHERE     mtt.transaction_type_id = mmt.transaction_type_id
         AND mtt.transaction_type_name = 'Direct Org Transfer'
        /*    ------------  Commented By Imrul
         AND mmt.organization_id = from_org.organization_id
         AND mmt.transfer_organization_id = to_org.organization_id
         */
        /*------------- Begin: Join Updated by Imrul-------------*/ 
        AND mmt.organization_id = to_org.organization_id--from_org.organization_id
         AND mmt.transfer_organization_id = from_org.organization_id--to_org.organization_id
         /*------------- End: Join Updated by Imrul-------------*/
        AND mmt.attribute3 =mvh.mov_order_no(+)
         AND msi.inventory_item_id = mmt.inventory_item_id
         AND msi.organization_id = mmt.organization_id
         AND mvh.transporter_vendor_id = aps.vendor_id(+)
         AND from_org.operating_unit = :P_ORG_ID
         AND TRUNC (mmt.transaction_date) BETWEEN :P_DATE_FROM AND :P_DATE_TO
         AND (:P_PARTY_ID IS NULL                       OR (aps.vendor_id=:P_PARTY_ID))
         AND (:P_TRANSPORT_MODE IS NULL         OR (MVH.TRANSPORT_MODE = :P_TRANSPORT_MODE))
         AND (:P_FROM_WAREHOUSE IS NULL        OR (from_org.organization_id = :P_FROM_WAREHOUSE))
         AND (:P_TO_WAREHOUSE IS NULL            OR (to_org.organization_id = :P_TO_WAREHOUSE))
         AND (:P_PAID_STATUS IS NULL OR APPS.XXAKG_AP_PKG.GET_INVOICE_PAID_STATUS(NULL, mvh.mov_order_no)  = :P_PAID_STATUS)
ORDER BY TRUNC (mmt.transaction_date)


/* Only Show Move TOs
select XXAKG_COM_PKG.get_organization_name(sum(from_warehouse_id)) from_warehouse, 
XXAKG_COM_PKG.get_organization_name(sum(to_warehouse_id)) to_warehouse,
XXAKG_COM_PKG.get_organization_name(sum(to_warehouse_id)) group_to_warehouse,
mov_order_no, mov_order_date, to_number, to_date, item_name, sp_quantity, pp_quantity,
org_id, final_destination, 
xxakg_ont_pkg.get_hire_rate(org_id, XXAKG_COM_PKG.get_organization_name(sum(to_warehouse_id)), sum(from_warehouse_id), transport_mode, trunc(mov_order_date), 'AP') hire_rate,
primary_uom, transporter_name, transport_mode, transfer_date, vehicle_no
FROM
(
select decode(sign(mmt.transaction_quantity), -1, mmt.organization_id) from_warehouse_id,
decode(sign(mmt.transaction_quantity), 1, mmt.organization_id) to_warehouse_id,  
mvh.mov_order_no, trunc(mvh.mov_order_date) mov_order_date,
mmt.shipment_number to_number, trunc(mmt.transaction_date) to_date, 
msi.description item_name, 
decode(msi.concatenated_segments, 'CMNT.SBAG.0001', abs(mmt.transaction_quantity), null) sp_quantity, 
decode(msi.concatenated_segments, 'CMNT.PBAG.0001', abs(mmt.transaction_quantity), null) pp_quantity,
mvh.org_id, mvh.final_destination, 
mmt.transaction_uom primary_uom, nvl(aps.vendor_name, mvh.transporter_name) transporter_name, transport_mode, trunc(mmt.transaction_date) transfer_date, vehicle_no,
null bill_status, null paid_date
from xxakg_mov_ord_hdr mvh,  
mtl_material_transactions mmt,
ap_suppliers aps,
mtl_system_items_kfv msi
where mmt.attribute3 = mvh.mov_order_no 
and MOV_ORDER_TYPE <> 'RELATED'
and mov_order_no is not null
and mvh.transporter_vendor_id = aps.vendor_id (+)
and msi.inventory_item_id = mmt.inventory_item_id
and msi.organization_id = mmt.organization_id 
and  mvh.org_id  = :P_ORG_ID
and trunc(mmt.transaction_date) BETWEEN :P_DATE_FROM AND :P_DATE_TO
AND     (:P_TRANSPORT_MODE IS NULL OR (MVH.TRANSPORT_MODE = :P_TRANSPORT_MODE))
--and mmt.ATTRIBUTE3 = 'MO/SCOU/003859'
--and SHIPMENT_NUMBER = 'ITR/SCI/340'
)
GROUP BY mov_order_no, mov_order_date, to_number, to_date, item_name, sp_quantity, pp_quantity,
org_id, final_destination, transport_mode, primary_uom, transporter_name, transfer_date, vehicle_no
HAVING (:P_FROM_WAREHOUSE IS NULL OR (sum(from_warehouse_id) = :P_FROM_WAREHOUSE))
AND       (:P_TO_WAREHOUSE IS NULL OR (sum(to_warehouse_id) = :P_TO_WAREHOUSE))
*/


------------------------------------------------------------------------------------------------------------------------------------------
SELECT distinct from_org.organization_id from_warehouse_id,
         from_org.organization_name from_warehouse,
         to_org.organization_id to_warehouse_id,
         to_org.organization_name to_warehouse,
         to_org.organization_name group_to_warehouse,
         mvh.mov_order_no,
         TRUNC (mvh.mov_order_date) mov_order_date,
            mmt.shipment_number TO_NUMBER,
             TRUNC (mmt.transaction_date) TO_DATE,
         msi.description item_name,
         /*---- Begin: updated from abs(mmt.transaction_quantity) to mmt.transaction_quantity by Imrul*/ -- 1,297 2,188
         DECODE (msi.concatenated_segments,
                 'CMNT.SBAG.0001', mmt.transaction_quantity,
                 NULL)
            sp_quantity,
         DECODE (msi.concatenated_segments,
                 'CMNT.PBAG.0001', mmt.transaction_quantity,
                 NULL)
            pp_quantity,
         --------- Begin: Added by Imrul for OPC ---------------   
         DECODE (msi.concatenated_segments,
                 'CMNT.OBAG.0001', mmt.transaction_quantity,
                 NULL)
            OPC_quantity,          
         DECODE (msi.concatenated_segments,
                 'CMNT.SBAG.0003', mmt.transaction_quantity,
                 NULL)
            SCSB_quantity,
         DECODE (msi.concatenated_segments,
                 'CMNT.PBAG.0003', mmt.transaction_quantity,
                 NULL)
            PCSB_quantity,  
         DECODE (msi.concatenated_segments,
                 'CMNT.CBAG.0001', mmt.transaction_quantity,
                 NULL)
            CEM3B_quantity,             
         --------- End: Added by Imrul for OPC ---------------
         /*---- End: updated from abs(mmt.transaction_quantity) to mmt.transaction_quantity by Imrul*/
         mvh.org_id,
         mvh.final_destination,
         mmt.transaction_uom primary_uom,
         NVL (aps.vendor_name, mvh.transporter_name) transporter_name,
         (select vendor_site_code  from apps.ap_invoices_all a, apps.ap_supplier_sites_all b 
         where a.vendor_id=b.vendor_id and a.vendor_site_id=b.vendor_site_id and a.invoice_num=mvh.mov_order_no and a.org_id= :P_ORG_ID ) vendor_site_code,
         mvh.hire_rate_ap hire_rate,
         (select th.payable_rate from apps.xxakg_transport_hirerate  th where th.from_location=from_org.organization_id and th.to_location=mvh.final_destination and th.transport_mode=mvh.transport_mode and th.end_date_active is null) chart_rate, --Added by Sourav Paul
         transport_mode,
         TRUNC (mmt.transaction_date) transfer_date,
         vehicle_no,
         apps.XXAKG_AP_PKG.GET_INVOICE_CREATION_STATUS (NULL, mvh.mov_order_no)    invoice_status,
         apps.XXAKG_AP_PKG.GET_INVOICE_PAID_STATUS (NULL, mvh.mov_order_no)    bill_status       
    FROM apps.mtl_transaction_types mtt,
         apps.mtl_material_transactions mmt,
         apps.org_organization_definitions from_org,
         apps.org_organization_definitions to_org,
         apps.XXAKG_OE_TO_DO_MOVE_V mvh,
         apps.mtl_system_items_kfv msi,
         apps.ap_suppliers aps
   WHERE     mtt.transaction_type_id = mmt.transaction_type_id
         AND mtt.transaction_type_name = 'Direct Org Transfer'
        /*    ------------  Commented By Imrul
         AND mmt.organization_id = from_org.organization_id
         AND mmt.transfer_organization_id = to_org.organization_id
         */
        /*------------- Begin: Join Updated by Imrul-------------*/ 
        AND mmt.organization_id = to_org.organization_id--from_org.organization_id
         AND mmt.transfer_organization_id = from_org.organization_id--to_org.organization_id
         /*------------- End: Join Updated by Imrul-------------*/
        AND mmt.attribute3 =mvh.mov_order_no(+)
         AND msi.inventory_item_id = mmt.inventory_item_id
         AND msi.organization_id = mmt.organization_id
         AND mvh.transporter_vendor_id = aps.vendor_id(+)
         AND from_org.operating_unit = :P_ORG_ID
         AND TRUNC (mmt.transaction_date) BETWEEN :P_DATE_FROM AND :P_DATE_TO
         AND (:P_PARTY_ID IS NULL                       OR (aps.vendor_id=:P_PARTY_ID))
         AND (:P_TRANSPORT_MODE IS NULL         OR (MVH.TRANSPORT_MODE = :P_TRANSPORT_MODE))
         AND (:P_FROM_WAREHOUSE IS NULL        OR (from_org.organization_id = :P_FROM_WAREHOUSE))
         AND (:P_TO_WAREHOUSE IS NULL            OR (to_org.organization_id = :P_TO_WAREHOUSE))
         AND (:P_PAID_STATUS IS NULL OR APPS.XXAKG_AP_PKG.GET_INVOICE_PAID_STATUS(NULL, mvh.mov_order_no)  = :P_PAID_STATUS)
ORDER BY TRUNC (mmt.transaction_date)