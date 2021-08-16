/*---- Batch Close Accross The Period*/
select
    *
--    count(batch_no)    
from
(

select 
    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')) PRODUCTION_DATE,
    gbh.ATTRIBUTE10 PROCESS,
    gbh.BATCH_NO,
    DECODE(gbh.BATCH_STATUS,
         -1,'CANCELED',
          1,'PENDING',
          2,'WIP',
          3,'COMPLETED',
          4,'CLOSED') BATCH_STATUS, 
    trunc(gbh.ACTUAL_START_DATE) START_DATE,
    trunc(mmt.transaction_date) TXN_DATE,
    trunc(gbh.ACTUAL_CMPLT_DATE) COMPLETION_DATE,
    trunc(gbh.BATCH_CLOSE_DATE) CLOSE_DATE
from 
    GME.GME_BATCH_HEADER gbh,
     INV.MTL_MATERIAL_TRANSACTIONS mmt,
     apps.org_organization_definitions ood
where 
    ood.legal_entity=23279
    and ood.organization_id=gbh.organization_id
--    GBH.ORGANIZATION_ID=99
    and MMT.TRANSACTION_SOURCE_ID=GBH.BATCH_ID
    and mmt.transaction_source_type_id=5
group by
    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
    gbh.ATTRIBUTE10,
    gbh.BATCH_NO, 
    gbh.BATCH_STATUS,
    trunc(gbh.ACTUAL_START_DATE),
    trunc(mmt.transaction_date),
    trunc(gbh.ACTUAL_CMPLT_DATE),
    trunc(gbh.BATCH_CLOSE_DATE)
--order by
--    trunc(to_date(gbh.ATTRIBUTE4,'YYYY/MM/DD HH24:MI:SS')),
--    gbh.ATTRIBUTE10,
--    gbh.BATCH_NO        
 )
where
    PRODUCTION_DATE between '1-MAY-2014' and '31-MAY-2014'
--    and CLOSE_DATE > '31-OCT-2013'
--    and TXN_DATE > '31-OCT-2013'
order by PRODUCTION_DATE 

/*---- Batch Close Accross The Period*/ 
    

select 
    * 
from 
    inv.mtl_material_transactions mmt 
where 
    organization_id=99
    and mmt.TRANSACTION_SOURCE_ID=463257
--    and rownum<10


select * from inv.MTL_TRANSACTION_TYPES 
--where 
--    transaction_type_name like 'WIP%'    
--    rownum<10
order by
    transaction_type_id
    
select 
    *--,
--    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 Item_code 
from 
    gme.gme_material_details gmd,
    inv.mtl_system_items_b msi,
    mtl_material_transactions mmt 
where 
    gmd.ORGANIZATION_ID=99
    and gmd.organization_id=msi.organization_id
    and gmd.inventory_item_id=msi.inventory_item_id
    and batch_id=463257
--    and rownum<10    
    
    
    2013/10/03 00:00:00