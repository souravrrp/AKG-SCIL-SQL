select
    *
from 
    gme.gme_material_details gmd,
    gme.gme_batch_header gbh
where
    gbh.organization_id=99
    and gbh.batch_id=gmd.batch_id
   and gbh.batch_no =17543
    and line_type=1
  
