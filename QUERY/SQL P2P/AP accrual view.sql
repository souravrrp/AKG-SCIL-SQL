select * 
from apps.xxakg_ap_accrual_detail_v
where 1=1
--and supplier_name is null
--and voucher_number in ('218222849','218236462','218250630','218251197','218254971','218255402','218281751','218287886')
and company=2110 
and po_number='L/SCOU/032140'
and grn_no in (35515)

order by po_number asc,voucher_date desc

select *
from apps.xxakg_inv_grn_details_v
where company=2110
--        and je_source='CST'
--        and voucher_number=217179224