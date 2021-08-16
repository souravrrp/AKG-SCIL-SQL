SELECT
*
FROM
APPS.XXAKG_CMNT_TARGET_VS_ACHIVE_V
WHERE 1=1
AND ROWNUM<=3



SELECT org_id,
          REGION_NAME,
          CUSTOMER_ID,
          CUSTOMER_NUMBER,
          CUSTOMER_NAME,
          apps.xxakg_bi_ont_pkg.get_opening_qty (org_id, customer_id) opening_qty,
          TARGET_QTY,
          AVG_TARGET,
          DAY_DELIVERY,
          DAY_ORDER,
          MONTH_TILL_NOW_DEL,
          MONTH_TILL_NOW_ORD,
          REQ_DEL_PER_DAY,
          REQ_ORD_PER_DAY,
          MONTH_TILL_NOW_TARGET,
          MONTH_TILL_NOW_TARGET - MONTH_TILL_NOW_DEL DEL_GAP,
          MONTH_TILL_NOW_TARGET - MONTH_TILL_NOW_ORD ORD_GAP,
          ROUND (
             (MONTH_TILL_NOW_DEL / ( (TARGET_QTY / LAST_DA) * till_day))
             * 100,
             2)
          || '%'
             DEL_ACHIVEMENT,
          ROUND (
             (MONTH_TILL_NOW_ORD / ( (TARGET_QTY / LAST_DA) * till_day))
             * 100,
             2)
          || '%'
             ORD_ACHIVEMENT
     FROM (SELECT org_id,
                  REGION_NAME,
                  CUSTOMER_ID,
                  CUSTOMER_NUMBER,
                  CUSTOMER_NAME,
                  TARGET_QTY,
                  LAST_DA,
                  till_day,
                  TARGET_QTY / LAST_DA AVG_TARGET,
                  DAY_DELIVERY,
                  DAY_ORDER,
                  MONTH_TILL_NOW_DEL,
                  MONTH_TILL_NOW_ORD,
                  ROUND( (TARGET_QTY - MONTH_TILL_NOW_DEL)
                        / (LAST_DA - till_day))
                     REQ_DEL_PER_DAY,
                  ROUND( (TARGET_QTY - MONTH_TILL_NOW_ORD)
                        / (LAST_DA - till_day))
                     REQ_ORD_PER_DAY,
                  (TARGET_QTY / LAST_DA) * till_day MONTH_TILL_NOW_TARGET,
                  ( (TARGET_QTY / LAST_DA) * till_day) - (MONTH_TILL_NOW_DEL)
                     DEL_GAP,
                  ( (TARGET_QTY / LAST_DA) * till_day) - (MONTH_TILL_NOW_ORD)
                     ORD_GAP
             /*  ROUND (
                  (MONTH_TILL_NOW_DEL / ( (TARGET_QTY / LAST_DA) * till_day)) * 100,
                  2)
               || '%'
                  DEL_ACHIVEMENT,
               ROUND (
                  (MONTH_TILL_NOW_ORD / ( (TARGET_QTY / LAST_DA) * till_day)) * 100,
                  2)
               || '%'
                  ORD_ACHIVEMENT*/
             FROM (  SELECT org_id,
                            REGION_NAME,
                            CUSTOMER_ID,
                            CUSTOMER_NUMBER,
                            CUSTOMER_NAME,
                            SUM (TARGET_QTY) TARGET_QTY,
                            TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'DD'))
                               LAST_DA,
                            TO_NUMBER (TO_CHAR (TRUNC (SYSDATE) - 1, 'DD'))
                               till_day,
                            apps.xxakg_bi_ont_pkg.get_delivery_qty (
                               org_id,
                               CUSTOMER_ID,
                               TRUNC (SYSDATE) - 1,
                               TRUNC (SYSDATE) - 1)
                               DAY_DELIVERY,
                            apps.XXAKG_BI_ONT_PKG.get_booked_qty (
                               org_id,
                               CUSTOMER_ID,
                               TRUNC (SYSDATE) - 1,
                               TRUNC (SYSDATE) - 1)
                               DAY_ORDER,
                            apps.xxakg_bi_ont_pkg.get_delivery_qty (
                               org_id,
                               CUSTOMER_ID,
                               apps.xxakg_bi_ont_pkg.fday_ofmonth (SYSDATE),
                               TRUNC (SYSDATE) - 1)
                               MONTH_TILL_NOW_DEL,
                            apps.xxakg_bi_ont_pkg.get_booked_qty (
                               org_id,
                               CUSTOMER_ID,
                               apps.xxakg_bi_ont_pkg.fday_ofmonth (SYSDATE),
                               TRUNC (SYSDATE) - 1)
                               MONTH_TILL_NOW_ORD
                       /* ROUND (
                           (SUM (TARGET_QTY)
                            - xxakg_bi_ont_pkg.get_delivery_qty (
                                 org_id,
                                 CUSTOMER_ID,
                                 xxakg_bi_ont_pkg.fday_ofmonth(sysdate),
                                 TRUNC (SYSDATE) - 1))
                           / (TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'DD'))
                              - TO_NUMBER (TO_CHAR (TRUNC (SYSDATE) - 1, 'DD'))))
                           REQ_DEL_PER_DAY,*/
                       /*  ROUND (
                        (SUM (TARGET_QTY)
                         - xxakg_bi_ont_pkg.get_booked_qty (
                              org_id,
                              CUSTOMER_ID,
                              xxakg_bi_ont_pkg.fday_ofmonth(sysdate),
                              TRUNC (SYSDATE) - 1))
                        / (TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'DD'))
                           - TO_NUMBER (TO_CHAR (TRUNC (SYSDATE) - 1, 'DD'))))
                          REQ_ORD_PER_DAY,
                     (SUM (TARGET_QTY) / TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'DD')))
                     * TO_NUMBER (TO_CHAR (TRUNC (SYSDATE) - 1, 'DD'))
                        MONTH_TILL_NOW_TARGET,
                        ( (SUM (TARGET_QTY)
                        / TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'DD')))
                      * TO_NUMBER (TO_CHAR (TRUNC (SYSDATE) - 1, 'DD')))
                     - (xxakg_bi_ont_pkg.get_delivery_qty (org_id,
                                                           CUSTOMER_ID,
                                                           xxakg_bi_ont_pkg.fday_ofmonth(sysdate),
                                                           TRUNC (SYSDATE) - 1))
                        DEL_GAP,
                            ( (SUM (TARGET_QTY)
                        / TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'DD')))
                      * TO_NUMBER (TO_CHAR (TRUNC (SYSDATE) - 1, 'DD')))
                     - (xxakg_bi_ont_pkg.get_booked_qty (org_id,
                                                           CUSTOMER_ID,
                                                           xxakg_bi_ont_pkg.fday_ofmonth(sysdate),
                                                           TRUNC (SYSDATE) - 1))
                        ORD_GAP,
                     ROUND (
                        ( (xxakg_bi_ont_pkg.get_delivery_qty (
                              org_id,
                              CUSTOMER_ID,
                              xxakg_bi_ont_pkg.fday_ofmonth(sysdate),
                              TRUNC (SYSDATE) - 1))
                         / ( (SUM (TARGET_QTY)
                              / TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'DD')))
                            * TO_NUMBER (TO_CHAR (TRUNC (SYSDATE) - 1, 'DD'))))
                        * 100,
                        2)
                     || '%'
                        DEL_ACHIVEMENT,
                         ROUND (
                        ( (xxakg_bi_ont_pkg.get_booked_qty (
                              org_id,
                              CUSTOMER_ID,
                              xxakg_bi_ont_pkg.fday_ofmonth(sysdate),
                              TRUNC (SYSDATE) - 1))
                         / ( (SUM (TARGET_QTY)
                              / TO_NUMBER (TO_CHAR (LAST_DAY (SYSDATE), 'DD')))
                            * TO_NUMBER (TO_CHAR (TRUNC (SYSDATE) - 1, 'DD'))))
                        * 100,
                        2)
                     || '%'
                        ORD_ACHIVEMENT*/
                       FROM APPS.XXAKG_TARGET_FIX_CUSTOMER_M
                      WHERE PERIOD_NAME = TO_CHAR (SYSDATE, 'MON-YY')
                   GROUP BY org_id,
                            REGION_NAME,
                            CUSTOMER_ID,
                            CUSTOMER_NUMBER,
                            CUSTOMER_NAME));
                            
                            
                            
                            SELECT
                            *
                            FROM APPS.XXAKG_TARGET_FIX_CUSTOMER_M
                            WHERE 1=1
                            AND PERIOD_NAME='MAY-18'
                            AND REGION_NAME='Khulna'