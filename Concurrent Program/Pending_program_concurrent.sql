select COUNT (distinct cwr.request_id) Peding_Requests , cwr.REQUEST_DESCRIPTION, fu.user_name   
FROM apps.fnd_concurrent_worker_requests cwr, apps.fnd_concurrent_queues_tl cq, apps.fnd_user fu 
WHERE (cwr.phase_code = 'P' OR cwr.phase_code = 'R')   
AND cwr.hold_flag != 'Y'   AND cwr.requested_start_date <= SYSDATE    
AND cwr.concurrent_queue_id = cq.concurrent_queue_id   AND cwr.queue_application_id = cq.application_id  and cq.LANGUAGE='US'
AND cwr.requested_by = fu.user_id 
and cq.user_concurrent_queue_name in ( select unique user_concurrent_queue_name from apps.fnd_concurrent_queues_tl)
--and fu.user_name='25414'
group by
fu.user_name, cwr.REQUEST_DESCRIPTION



select
 fcr.request_id,
 fcr.parent_request_id,
 fu.user_name requestor,
 to_char(fcr.requested_start_date, 'MON-DD-YYYY HH24:MM:SS') START_DATE,
 fr.responsibility_key responsibility,
 fcp.concurrent_program_name,
 fcpt.user_concurrent_program_name,
 decode(fcr.status_code,
  'A', 'Waiting',
  'B', 'Resuming',
  'C', 'Normal',
  'D', 'Cancelled',
  'E', 'Error',
  'F', 'Scheduled',
  'G', 'Warning',
  'H', 'On Hold',
  'I', 'Normal',
  'M', 'No Manager',
  'Q', 'Standby',
  'R', 'Normal',
  'S', 'Suspended',
  'T', 'Terminating',
  'U', 'Disabled',
  'W', 'Paused',
  'X', 'Terminated',
  'Z', 'Waiting') status,
 decode(fcr.phase_code,
  'C', 'Completed',
  'I', 'Inactive',
  'P', 'Pending',
  'R', 'Running') phase,
 fcr.completion_text
from
 apps.fnd_concurrent_requests fcr,
 apps.fnd_concurrent_programs fcp,
 apps.fnd_concurrent_programs_tl fcpt,
 apps.fnd_user fu,
 apps.fnd_responsibility fr
where
 fcr.status_code in ('Q', 'I') and
 fcr.hold_flag = 'N' and
 fcr.requested_start_date > sysdate and
 fu.user_id = fcr.requested_by and
 fcr.concurrent_program_id = fcp.concurrent_program_id and
 fcr.concurrent_program_id = fcpt.concurrent_program_id and
 fcr.responsibility_id = fr.responsibility_id
order by
 fcr.requested_start_date,  fcr.request_id;
 
