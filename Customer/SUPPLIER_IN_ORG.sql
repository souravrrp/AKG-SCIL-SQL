select TOT_OU,
cnt.SEGMENT1,cnt.VENDOR_NAME
from
(
select count (Count_Value.TOT_ORG) TOT_OU,
--aps.segment1 Supplier_Number
Count_Value.SEGMENT1,Count_Value.VENDOR_NAME
--,Count_Value.name
from 
(SELECT distinct hou.ORGANIZATION_ID,
count(hou.organization_id)TOT_ORG,
aps.SEGMENT1,hou.name,aps.VENDOR_NAME
FROM apps.ap_suppliers aps,
apps.ap_supplier_sites_all apsa,
apps.hr_all_organization_units hou
where 1=1
and aps.vendor_id=apsa.vendor_id
and apsa.ORG_ID=hou.ORGANIZATION_ID
and organization_id in(82,83,84,85,189,605,1125)
--and VENDOR_NAME like'%Maruf%'
--and segment1='15047'
group by SEGMENT1,hou.ORGANIZATION_ID,
aps.VENDOR_NAME,
hou.name
order by 1 desc)Count_Value,
apps.hr_all_organization_units hou
where 1=1
and Count_Value.ORGANIZATION_ID=hou.ORGANIZATION_ID
group by Count_Value.SEGMENT1,Count_Value.VENDOR_NAME
order by 1 desc ) cnt
where cnt.TOT_OU=7


select count (Count_Value.TOT_ORG) TOT_OU,
--aps.segment1 Supplier_Number
Count_Value.SEGMENT1,Count_Value.VENDOR_NAME
--,Count_Value.name
from 
(SELECT distinct hou.ORGANIZATION_ID,
count(hou.organization_id)TOT_ORG,
aps.SEGMENT1,hou.name,aps.VENDOR_NAME
FROM apps.ap_suppliers aps,
apps.ap_supplier_sites_all apsa,
apps.hr_all_organization_units hou
where 1=1
and aps.vendor_id=apsa.vendor_id
and apsa.ORG_ID=hou.ORGANIZATION_ID
and organization_id in(82,83,84,85,189,605,1125)
--and VENDOR_NAME like'%Maruf%'
--and segment1='15047'
group by SEGMENT1,hou.ORGANIZATION_ID,
aps.VENDOR_NAME,
hou.name
order by 1 desc)Count_Value,
apps.hr_all_organization_units hou
where 1=1
and Count_Value.ORGANIZATION_ID=hou.ORGANIZATION_ID
group by Count_Value.SEGMENT1,Count_Value.VENDOR_NAME
having count(TOT_ORG)=7
order by 1 desc 