SELECT TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM') AS FIRST_DAY_LAST_MONTH,
 TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))) AS LAST_DAY_LAST_MONTH FROM DUAL;
 
 TO_CHAR(TO_DATE(:P_DATE)-TO_CHAR(TO_DATE(:P_DATE),'DD'),'Month YYYY')
 TO_CHAR(TRUNC(:P_DATE, 'MM') - 1,'Month YYYY')
 TO_CHAR(TRUNC(SYSDATE, 'MM') - 1,'Month YYYY')
 
select to_char(trunc(trunc(sysdate, 'MM') - 1, 'MM'),'DD-MON-YYYY') "First Day of Last Month",
to_char(trunc(sysdate, 'MM') - 1,'DD-MON-YYYY') "Last Day of Last Month"
from dual


select to_char(trunc(trunc(sysdate, 'MM') - 1, 'MM'),'DD-MON-YYYY') "First Day of Last Month",
to_char(trunc(sysdate, 'MM') - 1,'Month YYYY') "Last Day of Last Month"
from dual
 