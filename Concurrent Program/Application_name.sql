SELECT fa.application_id           "Application ID",
       fat.application_name        "Application Name",
       fa.application_short_name   "Application Short Name",
       fa.basepath                 "Basepath"
  FROM apps.fnd_application     fa,
       apps.fnd_application_tl  fat
 WHERE fa.application_id = fat.application_id
   AND fat.language      = USERENV('LANG')
   -- AND fat.application_name = 'Payables'  -- <change it>
 ORDER BY fat.application_name;