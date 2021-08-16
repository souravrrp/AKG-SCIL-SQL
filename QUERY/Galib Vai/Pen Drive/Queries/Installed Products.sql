/* Formatted on 7/3/2013 9:29:24 AM (QP5 v5.163.1008.3004) */
SELECT fa.application_id appn_id,
       DECODE (fa.application_short_name,
               'SQLAP', 'AP',
               'SQLGL', 'GL',
               fa.application_short_name)
          appn_short_name,
       SUBSTR (fat.application_name, 1, 50)
       || DECODE (SIGN (LENGTH (fat.application_name) - 50), 1, '...')
          Application,
       fa.basepath Base_path,
       fl.meaning install_status,
       NVL (fpi.product_version, 'Not Available') product_version,
       NVL (fpi.patch_level, 'Not Available') patch_level,
       TO_CHAR (fa.last_update_date, 'DD-Mon-YY (Dy) HH24:MI')
          last_update_date,
       NVL (fu.user_name, '* Install *') Updated_by
  FROM applsys.fnd_application fa,
       applsys.fnd_application_tl fat,
       applsys.fnd_user fu,
       applsys.fnd_product_installations fpi,
       apps.fnd_lookups fl
 WHERE  
        fa.application_id in ('200','222','140','707','260','555')
        and   
        fa.application_id = fat.application_id
       AND fat.language(+) = USERENV ('LANG')
       AND fa.application_id = fpi.application_id
       AND fpi.last_updated_by = fu.user_id(+)
       AND fpi.status = fl.lookup_code
       AND fl.lookup_type = 'FND_PRODUCT_STATUS'
UNION ALL
SELECT fa.application_id,
       fa.application_short_name,
       SUBSTR (fat.application_name, 1, 50)
       || DECODE (SIGN (LENGTH (fat.application_name) - 50), 1, '...'),
       fa.basepath,
       'Not Available',
       'Not Available',
       'Not Available',
       TO_CHAR (fa.last_update_date, 'DD-Mon-YY (Dy) HH24:MI'),
       NVL (fu.user_name, '* Install *')
  FROM applsys.fnd_application fa,
       applsys.fnd_application_tl fat,
       applsys.fnd_user fu
 WHERE     
        fa.application_id in ('200','222','140','707','260','555')
        and
        fa.application_id = fat.application_id
       AND fat.language(+) = USERENV ('LANG')
       AND fa.last_updated_by = fu.user_id(+)
       AND fa.application_id NOT IN
              (SELECT fpi.application_id
                 FROM applsys.fnd_product_installations fpi)
ORDER BY 2;