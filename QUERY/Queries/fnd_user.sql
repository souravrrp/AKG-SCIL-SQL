select
    fu.user_id,
    fu.user_name,
    pap.full_name,
    fu.*,
    pap.*
from
    apps.fnd_user fu,
    apps.per_all_people_f pap
where
--    fu.user_id=:created_by
    fu.user_name='4052'
    and fu.user_name=pap.employee_number    