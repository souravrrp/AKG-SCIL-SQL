SELECT ood.organization_id "Organization ID" ,
  ood.organization_code "Organization Code" ,
  ood.organization_name "Organization Name" ,
  oap.period_name "Period Name" ,
  oap.period_start_date "Start Date" ,
  oap.period_close_date "Closed Date" ,
  oap.schedule_close_date "Scheduled Close" ,
  DECODE(oap.open_flag, 'P','P - Period Close is processing' ,
                        'N','N - Period Close process is completed' ,
                        'Y','Y - Period is open if Closed Date is NULL' ,'Unknown') "Period Status"
FROM apps.org_acct_periods oap ,
  apps.org_organization_definitions ood
WHERE oap.organization_id = ood.organization_id
AND (TRUNC(SYSDATE) -- Comment line if a a date other than SYSDATE is being tested.
  --AND ('01-DEC-2014' -- Uncomment line if a date other than SYSDATE is being tested.
  BETWEEN TRUNC(oap.period_start_date) AND TRUNC (oap.schedule_close_date))
ORDER BY ood.organization_id--,
--  oap.period_start_date;
-- If Period Status is 'Y' and Closed Date is not NULL then the closing of the INV period failed.
