select rt.routing_no ,a.organization_id , ood.organization_code ,a.batch_no , a.actual_start_date , 
 to_char(a.actual_start_date,'MON-YY') Period ,TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS') AS Production_Date, TO_CHAR(TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'),'MON-YY') AS Production_PERIOD,
 decode(a.batch_status,1,'Pending',2,'WIP',3,'Completed',4,'Closed',-1,'Cancelled','Others' ) as Batch_status  ,a.batch_close_date ,
a.actual_cmplt_date ,sum(decode(b.line_type,-1,b.actual_qty)) as ING,sum(decode(b.line_type,1,b.actual_qty)) as Prod,sum(decode(b.line_type,2,b.actual_qty)) as BY_prod
from apps.gme_batch_header a ,
        apps.gme_material_details b ,
        apps.org_organization_definitions ood,
        apps.gmd_routings_b rt
where a.organization_id  =113
and TO_CHAR(a.actual_start_date,'MON-YY') ='APR-14'-->='01-OCT-2013'
--and a.actual_start_date<='01-NOV-2013'
--and TO_CHAR(a.batch_close_date,'MON-YY') ='NOV-13' 
--and TO_CHAR(TO_DATE (a.attribute4, 'RRRR/MM/DD HH24:MI:SS'),'MON-YY') IN ('OCT-13')
and a.batch_id =b.batch_id 
and a.organization_id =b.organization_id 
and a.organization_id=ood.organization_id 
and a.routing_id=rt.routing_id 
group by  a.organization_id ,ood.organization_code, a.batch_no ,a.attribute4 , a.actual_start_date , a.batch_status,a.actual_cmplt_date,rt.routing_no,a.BATCH_CLOSE_DATE
order by 4 DESC