/* Formatted on 2/19/2015 6:53:46 PM (QP5 v5.136.908.31019) */
SELECT usr.user_name,
       GET_PWD.DECRYPT (
          (SELECT (SELECT get_pwd.decrypt (
                             apps.fnd_web_sec.get_guest_username_pwd,
                             usertable.encrypted_foundation_password)
                     FROM DUAL)
                     apps_password
             FROM apps.fnd_user usertable
            WHERE usertable.user_name =
                     (SELECT SUBSTR (
                                apps.fnd_web_sec.get_guest_username_pwd,
                                1,
                                INSTR (apps.fnd_web_sec.get_guest_username_pwd,
                                       '/')
                                - 1)
                        FROM DUAL)),
          usr.encrypted_user_password)
          password
  FROM apps.fnd_user usr
 WHERE usr.user_name = '11443'