 select adv.created_by,
        adv.creation_date,
        adv.keep_site_flag,
        adv.last_updated_by,
        adv.last_update_date,
        adv.process_flag,
        pv.vendor_name "From Supplier",
        pvs.vendor_site_code "From Site",
        pv1.vendor_name "To Supplier",
        pvs1.vendor_site_code "To Site"
from apps.ap_duplicate_vendors adv,
        apps.po_vendors pv,
        apps.po_vendor_sites_all pvs,
        apps.po_vendors pv1,
        apps.po_vendor_sites_all pvs1
where adv.duplicate_vendor_id=pv.vendor_id
        and adv.duplicate_vendor_site_id=pvs.vendor_site_id
        and adv.vendor_id=pv1.vendor_id
        and adv.vendor_site_id=pvs1.vendor_site_id
        