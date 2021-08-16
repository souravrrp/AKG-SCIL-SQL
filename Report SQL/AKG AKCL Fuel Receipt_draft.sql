select
 move_order_no,
 vehicle_number,
 final_destination,
 driver_id,
 driver_name,
 ppf.global_name created_by ,
 ppf2.global_name last_updated_by,
 ppf.global_name,
 previous_remain_fuel,
 fm.creation_date,
 estimated_fuel,
 adjusted_amount,
 mo_date,
 acctual_need_fuel,
 distance_km,
 special_advance,
 provided_fuel,
 '( '||distance_km||' / '||kpl||' )'||nvl(ESTIMATED_FUEL,0)||'+'||nvl(adjusted_amount,0) ||'+'||nvl(special_advance,0)||'='||
 (ESTIMATED_FUEL+nvl(adjusted_amount,0)+nvl(special_advance,0))||'-'||nvl(PREVIOUS_REMAIN_FUEL,0)||'='||PROVIDED_FUEL calculation
 from
 apps.xxakg_fuel_maintanance fm,
 apps.fnd_user fu,
 apps.fnd_user fu2,
 apps.per_people_f ppf,
 apps.per_people_f ppf2
 where status='TRANSACTED'
 and fm.created_by=fu.user_id
-- and fm.provided_by=fu2.user_id                                   --commented line
 and nvl(fm.provided_by,fm.last_updated_by)=fu2.user_id  --new line
 and fu.user_name=ppf.employee_number
 and fu2.user_name=ppf2.employee_number
 and sysdate between ppf.effective_start_date and ppf.effective_end_date
 and sysdate between ppf2.effective_start_date and ppf2.effective_end_date
 and move_order_no=:Move_order  