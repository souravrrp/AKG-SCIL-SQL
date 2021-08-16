/* Formatted on 7/2/2013 6:42:54 PM (QP5 v5.163.1008.3004) */
SELECT 
       application_id,
       period_name,
       period_num,
       DECODE (closing_status,
               'O', 'Open',
               'C', 'Closed',
               'F', 'Future',
               'N', 'Never',
               closing_status)
          gl_status,
       set_of_books_id
  FROM gl.gl_period_statuses 
 WHERE     
        application_id in (SELECT APPLICATION_ID 
                                    FROM applsys.fnd_application 
                                    WHERE 
                                    PRODUCT_CODE in ('MFG'))
--       AND UPPER (period_name) = UPPER ('JUL-13')
       AND set_of_books_id = (SELECT SET_OF_BOOKS_ID
                                            FROM APPS.GL_SETS_OF_BOOKS
                                            WHERE
                                            UPPER(NAME) LIKE UPPER('%cement%')) --- 2025->Cement Ledger, 2022->Steel Ledger, 2027->Group Common Ledger
