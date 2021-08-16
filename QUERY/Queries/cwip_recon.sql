select 
    *
--    sum(nvl(amount,0))
from
    apps.xxakg_GL_pa_cwip_recon
where
    ledger_name like 'Steel%'
    and company='1220'
    and account='2030102'
--    and trunc(accounting_date) between '01-JAN-2011' and '31-DEC-2011'
--    and project_name is null
--    and source='INV'
--    and TRANSFER_TO_PROJECT='N'
--    and reference1=19933
    and rownum<10    