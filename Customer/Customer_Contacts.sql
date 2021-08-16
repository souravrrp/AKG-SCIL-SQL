SELECT
ARC.*
FROM
APPS.AR_CONTACTS_V ARC
where 1=1
and arc.customer_id='2539'


SELECT
*
FROM
APPS.HZ_CUST_ACCOUNTS
--WHERE PARTY_ID='16176'

SELECT
*
FROM
APPS.HZ_CUST_ACCOUNT_ROLES
WHERE 1=1
--AND 

SELECT
*
FROM
APPS.HZ_CONTACT_POINTS
WHERE 1=1
AND OWNER_TABLE_ID='16174'

SELECT
*
FROM
APPS.HZ_PARTIES HP
WHERE 1=1
AND PARTY_ID='16174'--'16174'


SELECT
*
FROM
APPS.HZ_CONTACT_FIND_V
WHERE 1=1
AND CUSTOMER_ID='5028'

SELECT
*
FROM
APPS.HZ_CUSTOMER_PROFILES
WHERE 1=1
AND PARTY_ID='16174'

SELECT
*
FROM
APPS.HZ_CUST_PROFILE_CLASSES
WHERE 1=1
--AND PARTY_ID='16174'

SELECT
*
FROM
APPS.HZ_LOCATIONS
--AND PARTY_ID='16174'

SELECT
*
FROM
APPS.HZ_ORG_CONTACTS
WHERE 1=1
AND CONTACT_NUMBER='1168'
--AND ORIG_SYSTEM_REFERENCE='16174'

SELECT
*
FROM
APPS.HZ_CONTACT_RESTRICTIONS 

SELECT
*
FROM
APPS.HZ_PERSON_LANGUAGE 

SELECT
*
FROM
APPS.HZ_RELATIONSHIPS
WHERE 1=1
--AND RELATIONSHIP_ID='3088'
--AND PARTY_ID='16174'

SELECT hcasa.org_id,
  role_acct.account_number,
  hcasa.orig_system_reference,
  rel.subject_id,rel.object_id
  ,party.party_id                                           party_id,
  rel_party.party_id                                      rel_party_id,
  acct_role.cust_account_id                         ,
  acct_role.cust_acct_site_id                        ,
  party.person_pre_name_adjunct                 contact_prefix,
  substr(party.person_first_name, 1, 40)       contact_first_name,
  substr(party.person_middle_name, 1, 40)  contact_middle_name,
  substr(party.person_last_name, 1, 50)        contact_last_name,
  party.person_name_suffix                           contact_suffix,
  acct_role.status, org_cont.job_title             contact_job_title,
  org_cont.job_title_code                              contact_job_title_code,
  rel_party.address1                                       contact_address1,
  rel_party.address2                                       contact_address2,
  rel_party.address3                                       contact_address3,
  rel_party.address4                                       contact_address4,
  rel_party.country                                         contact_country,
  rel_party.state                                              contact_state,
  rel_party.city                                               contact_city,
  rel_party.county                                          contact_county,
  rel_party.postal_code                                  contact_postal_code
FROM    apps.hz_contact_points                         cont_point,
        apps.hz_cust_account_roles                         acct_role,
        apps.hz_parties                                             party,
        apps.hz_parties                                             rel_party,
        apps.hz_relationships                                   rel,
        apps.hz_org_contacts                                   org_cont,
        apps.hz_cust_accounts                                 role_acct,
        apps.hz_contact_restrictions                        cont_res,
        apps.hz_person_language                            per_lang,
        apps.hz_cust_acct_sites_all                        hcasa
WHERE   acct_role.party_id                   = rel.party_id
--  and   acct_role.role_type                        = 'CONTACT'
  and   org_cont.party_relationship_id      = rel.relationship_id
  and   rel.subject_id                                  = party.party_id
  and   rel_party.party_id                           = rel.party_id
  and   cont_point.owner_table_id(+)        = rel_party.party_id
--  and   cont_point.contact_point_type(+)   = 'EMAIL'
  and   cont_point.primary_flag(+)            = 'Y'
  and   acct_role.cust_account_id              = role_acct.cust_account_id
  and   role_acct.party_id                          =  rel.object_id
  and   party.party_id                                 = per_lang.party_id(+)
  and   per_lang.native_language(+)         = 'Y'
  and   party.party_id                                 = cont_res.subject_id(+)
  and   cont_res.subject_table(+)               = 'HZ_PARTIES'
  and   role_acct.cust_account_id              =  hcasa.cust_account_id
  and   hcasa.cust_acct_site_id                  =  acct_role.cust_acct_site_id
  and role_acct.account_number='20058'
--  and   acct_role.cust_account_id           =  p_customer_id --3177
--  and   acct_role.cust_acct_site_id         =  p_address_id
--  and   hcasa.org_id                                =  90

SELECT hp.party_id,cust.account_number,hp.party_name customer_name, h_contact.party_name contact_person_name,hcp.phone_number,
hcp.EMAIL_ADDRESS,cust.account_name
--,hcp.*
FROM
APPS.hz_parties hp,
APPS.hz_relationships hr,
APPS.hz_parties h_contact ,
APPS.hz_contact_points hcp,
APPS.hz_cust_accounts cust
where
1=1
and hr.subject_id = h_contact.PARTY_ID
and hr.object_id = hp.party_id
and hcp.owner_table_id(+) = hr.party_id
and cust.party_id = hp.party_id
--and hcp.CONTACT_POINT_TYPE ='EMAIL'
and hcp.STATUS = 'A'
and ACCOUNT_NUMBER='20058'
--AND hp.party_name=:1

select
*
from
apps.hz_cust_acct_relate_all
