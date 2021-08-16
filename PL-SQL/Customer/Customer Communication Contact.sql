SELECT hp.party_id,cust.account_number,hp.party_name customer_name, h_contact.party_name contact_person_name,hcp.phone_number,
hcp.EMAIL_ADDRESS,cust.account_name
--,hcp.*
--,hr.*
--,arc.*
FROM
APPS.hz_parties hp,
APPS.hz_relationships hr,
APPS.hz_parties h_contact ,
APPS.hz_contact_points hcp,
APPS.hz_cust_accounts cust,
apps.ar_contacts_v arc
where 1=1
and arc.customer_id=cust.cust_account_id 
and hr.subject_id = h_contact.PARTY_ID
and hr.object_id = hp.party_id
and hcp.owner_table_id(+) = hr.party_id
and cust.party_id = hp.party_id
--and hcp.CONTACT_POINT_TYPE ='EMAIL'   --PHONE
and hcp.STATUS = 'A'
and ACCOUNT_NUMBER='20076'
and arc.job_title='Manager' --Owner
and hr.RELATIONSHIP_ID=arc.PARTY_RELATIONSHIP_ID

-----------------------EMAIL------------------------------------------------------

SELECT ARC.EMAIL_ADDRESS EMAIL FROM APPS.AR_CONTACTS_V ARC,APPS.HZ_CUST_ACCOUNTS ACCT 
WHERE 1=1 
AND ARC.CUSTOMER_ID=ACCT.CUST_ACCOUNT_ID 
AND ACCT.ACCOUNT_NUMBER='20076'--D.CUSTOMER_NUMBER 
AND ARC.JOB_TITLE='Manager' --Owner 
AND ARC.STATUS='A'

-----------------------PHONE_NUMBER------------------------------------------------------

select 
cust.account_number,
hp.party_name customer_name, 
h_contact.party_name contact_person_name,
hcp.phone_number,
cust.account_name
--,hcp.*
--,hr.*
--,arc.*
from
apps.hz_parties hp,
apps.hz_relationships hr,
apps.hz_parties h_contact ,
apps.hz_contact_points hcp,
apps.hz_cust_accounts cust,
apps.ar_contacts_v arc
where 1=1
and arc.customer_id=cust.cust_account_id 
and hr.subject_id = h_contact.party_id
and hr.object_id = hp.party_id
and hcp.owner_table_id(+) = hr.party_id
and cust.party_id = hp.party_id
and hcp.contact_point_type ='PHONE'   --PHONE  --EMAIL
and hcp.status = 'A'
and account_number='20076'
and arc.job_title='Manager' --Owner
and hr.relationship_id=arc.party_relationship_id

--    AND d.DO_HDR_ID='2221287';
