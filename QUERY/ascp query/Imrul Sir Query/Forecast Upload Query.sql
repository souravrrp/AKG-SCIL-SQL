  select                             
  --    *                            
  --    distinct FORECAST_DESIGNATOR                            
      ood.organization_code,                            
      mfd.FORECAST_DESIGNATOR,                            
      trunc(mfd.FORECAST_DATE) forecast_date,                            
      mc.segment1 item_category,                            
      mc.segment2 item_type,                            
      msi.segment1||'.'||msi.segment2||'.'||msi.segment3 item_code,                            
      msi.description,                            
      msi.primary_uom_code,                            
      mfd.ORIGINAL_FORECAST_QUANTITY,                            
      mfd.CURRENT_FORECAST_QUANTITY                            
  from                            
      apps.MRP_FORECAST_DATES mfd,                            
      inv.mtl_system_items_b msi,                            
      inv.mtl_item_categories mic,                            
      inv.mtl_categories_b mc,                            
      apps.org_organization_definitions ood                            
  where                            
      mfd.organization_id=msi.organization_id                            
      and msi.inventory_item_id=mfd.inventory_item_id                            
      and msi.inventory_item_id=mic.inventory_item_id                            
      and msi.organization_id=mic.organization_id                            
      and mic.category_set_id=1                            
      and mic.category_id=mc.category_id                            
      and mfd.organization_id=ood.organization_id                            
      and mfd.FORECAST_DESIGNATOR=:forecast                            
      and trunc(mfd.FORECAST_DATE) between :from_date and :to_date                            
  --    and rownum<10;                            
