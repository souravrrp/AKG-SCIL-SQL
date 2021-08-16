SELECT 
fcpp.concurrent_request_id req_id, fcp.node_name, fcp.logfile_name 
FROM apps.fnd_conc_pp_actions fcpp, apps.fnd_concurrent_processes fcp 
WHERE fcpp.processor_id = fcp.concurrent_process_id
 AND fcpp.action_type = 6
 AND fcpp.concurrent_request_id ='44458755'