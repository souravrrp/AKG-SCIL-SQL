SELECT ott.org_id
      ,hrorg.name operating_unit_name
      ,ottl.name order_type_name
      ,ott.order_category_code
      ,ott.transaction_type_code
      ,ott.attribute1 order_type
      ,ott.attribute2 order_category
      ,ott.attribute3 adjustment_reason
      ,ott.def_transaction_phase_code
      ,ott.default_fulfillment_set
      ,ott.start_date_active
      ,ott.invoice_source_id
      ,ott.non_delivery_invoice_source_id
      ,ott.tax_calculation_event_code
      ,ott.price_list_id
      ,ott.warehouse_id
      ,ott.shipping_method_code
      ,ott.scheduling_level_code
--      ,in_type.NAME default_return_line_type
--      ,out_type.NAME default_order_line_type
      ,(SELECT wa.display_name
        FROM   apps.wf_activities_tl wa
              ,apps.oe_workflow_assignments wf
        WHERE  wf.order_type_id = ott.transaction_type_id
        AND    wa.NAME          = wf.process_name
        AND   (wf.line_type_id  = ott.transaction_type_id
        OR     wf.line_type_id  = ott.transaction_type_id)
        AND    version          = (
                       SELECT MAX(wa.version)
                       FROM   apps.wf_activities_tl wa
                             ,apps.oe_workflow_assignments wf
                       WHERE  wa.NAME          = wf.process_name
                       AND    wf.order_type_id = ott.transaction_type_id
                       AND    wf.line_type_id IS NOT NULL)
                                 ) wf_process
FROM  apps.oe_transaction_types_all  ott
     ,apps.oe_transaction_types_tl   ottl
     ,apps.hr_all_organization_units hrorg
WHERE ott.transaction_type_id           = ottl.transaction_type_id
AND   hrorg.organization_id             = ott.org_id
--and ott.transaction_type_id='1653'
and ott.org_id='85'