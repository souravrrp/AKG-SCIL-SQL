select distinct a.employee_number,
a.full_name,
--x.user_person_type,
max(c.proposed_salary_n) bal,
c.change_date
from 
apps.per_people_f a,
apps.per_assignments_f b,
apps.per_pay_proposals c,
apps.per_person_types x,
apps.per_person_type_usages_f e
where a.person_id=b.person_id
and b.assignment_id=c.assignment_id
and a.employee_number=32053
group by
a.employee_number,
a.full_name,
--x.user_person_type,
c.change_date

