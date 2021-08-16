/* Formatted on 10/26/2019 6:06:31 PM (QP5 v5.287) */
APPROVAL_SIGNATURE (
          (SELECT    SUBSTR (DESCRIPTION, 1, INSTR (DESCRIPTION, '|') - 1)
                  || CHR (10)
                  || SUBSTR (DESCRIPTION, INSTR (DESCRIPTION, '|') + 1, 240)
                     AUTHORIZATION_SIG
             FROM APPS.FND_LOOKUP_VALUES_VL A
            WHERE     LOOKUP_TYPE = 'XXAKG_BALANCE_CONFIRM_MANAGER'
                  AND ENABLED_FLAG = 'Y'
                  AND NVL (TAG, :P_ORG_ID) = :P_ORG_ID
                  AND EXISTS
                         (SELECT 1
                            FROM APPS.XXAKG_DISTRIBUTOR_BLOCK_M D1,
                                 APPS.AR_CUSTOMERS C1
                           WHERE     A.MEANING = D1.REGION_NAME
                                 AND D1.CUSTOMER_ID = C1.CUSTOMER_ID
                                 AND C1.CUSTOMER_NUMBER = :CUSTOMER_NUMBER
                                 AND D1.ORG_ID = :P_ORG_ID)) OR
          (SELECT    SUBSTR (DESCRIPTION, 1, INSTR (DESCRIPTION, '|') - 1)
                  || CHR (10)
                  || SUBSTR (DESCRIPTION, INSTR (DESCRIPTION, '|') + 1, 240)
             FROM APPS.FND_LOOKUP_VALUES_VL
            WHERE     LOOKUP_TYPE = 'XXAKG_BALANCE_CONFIRM_MANAGER'
                  AND ENABLED_FLAG = 'Y'
                  AND LOOKUP_CODE = :P_ORG_ID
                  AND ROWNUM = 1))
  FROM DUAL


--------------------------------------------------------------------------------

SELECT NVL (
          (SELECT    SUBSTR (DESCRIPTION, 1, INSTR (DESCRIPTION, '|') - 1)
                  || CHR (10)
                  || SUBSTR (DESCRIPTION, INSTR (DESCRIPTION, '|') + 1, 240)
             FROM APPS.FND_LOOKUP_VALUES_VL A
            WHERE LOOKUP_TYPE = 'XXAKG_BALANCE_CONFIRM_MANAGER'
                  AND ENABLED_FLAG = 'Y'
                  AND MEANING =
                         (SELECT D1.REGION_NAME
                            FROM APPS.XXAKG_DISTRIBUTOR_BLOCK_M D1,
                                 APPS.AR_CUSTOMERS C1
                           WHERE     D1.CUSTOMER_ID = C1.CUSTOMER_ID
                                 AND C1.CUSTOMER_NUMBER = :CUSTOMER_NUMBER
                                 AND D1.ORG_ID = :P_ORG_ID)
                  AND NVL (TAG, :P_ORG_ID) = :P_ORG_ID),
          (SELECT    SUBSTR (DESCRIPTION, 1, INSTR (DESCRIPTION, '|') - 1)
                  || CHR (10)
                  || SUBSTR (DESCRIPTION, INSTR (DESCRIPTION, '|') + 1, 240)
             FROM APPS.FND_LOOKUP_VALUES_VL
            WHERE     LOOKUP_TYPE = 'XXAKG_BALANCE_CONFIRM_MANAGER'
                  AND ENABLED_FLAG = 'Y'
                  AND LOOKUP_CODE = :P_ORG_ID
                  AND ROWNUM = 1)) AUTHORIZATION_SIGNATURE
  --          INTO V_RETURN
  FROM DUAL;
