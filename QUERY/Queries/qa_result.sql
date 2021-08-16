/*-------SCIL MILL DOWNTIME DETAIL--------*/
select
--    qr.*
    to_char(to_date(qr.character1,'YYYY/MM/DD'),'DD-MON-YYYY') Downtime_date,
    qr.CHARACTER2 Downtime_Shift,
    qr.CHARACTER3 Resource_name,
    qr.CHARACTER4 Major_reason,
    qr.CHARACTER5 Reason_detail,
    to_number(qr.CHARACTER6) Downtime_Duration,
    qr.CHARACTER7 Frequency
from
    qa.qa_plans qp,
    qa.QA_RESULTS qr
where
    qp.name='SCIL MILL DOWNTIME DETAIL'
    and qp.plan_id=qr.plan_id
    and to_char(trunc(to_date(qr.CHARACTER1,'YYYY/MM/DD')),'MON-YY')='FEB-15'
--    and rownum<10
order by to_date(qr.character1,'YYYY/MM/DD')


/*-------SCIL CREANE SECTION BREAKDOWN--------*/
select
--    qr.*
    to_char(to_date(qr.character1,'YYYY/MM/DD'),'DD-MON-YYYY') Downtime_date,
    qr.CHARACTER2 Downtime_Shift,
    qr.CHARACTER3 Resource_name,
    qr.CHARACTER4 Major_reason,
    qr.CHARACTER5 Reason_detail,
    to_number(qr.CHARACTER6) Downtime_Duration,
    qr.CHARACTER7 Frequency
from
    qa.qa_plans qp,
    qa.QA_RESULTS qr
where
    qp.name='SCIL CREANE SECTION BREAKDOWN'
    and qp.plan_id=qr.plan_id
    and to_char(trunc(to_date(qr.CHARACTER1,'YYYY/MM/DD')),'MON-YY')='FEB-15'
--    and rownum<10
order by to_date(qr.character1,'YYYY/MM/DD')


/*-------SCIL DELIVERY SECTION DOWNTIME--------*/    
select
--    qr.*
    to_char(to_date(qr.character1,'YYYY/MM/DD'),'DD-MON-YYYY') Downtime_date,
    qr.CHARACTER2 Downtime_Shift,
    qr.CHARACTER6 Resource_name,
    qr.CHARACTER3 Major_reason,
    qr.CHARACTER4 Reason_detail,
    to_number(qr.CHARACTER5) Downtime_Duration,
    qr.CHARACTER7 Frequency
from
    qa.qa_plans qp,
    qa.QA_RESULTS qr
where
    qp.name='SCIL DELIVERY SECTION DOWNTIME'
    and qp.plan_id=qr.plan_id
    and to_char(trunc(to_date(qr.CHARACTER1,'YYYY/MM/DD')),'MON-YY')='FEB-15'
--    and rownum<10
order by to_date(qr.character1,'YYYY/MM/DD')



/*------PSU DOWNTIME DETAIL---------------*/
select
--    qr.*
    to_char(to_date(qr.character1,'YYYY/MM/DD'),'DD-MON-YYYY') Downtime_date,
    qr.CHARACTER2 Downtime_Shift,
    qr.CHARACTER6 Resource_name,
    qr.CHARACTER7 Major_reason,
    qr.CHARACTER8 Reason_detail,
    to_number(qr.CHARACTER9) Downtime_Duration
from
    qa.qa_plans qp,
    qa.QA_RESULTS qr
where
    qp.name='PSU DOWNTIME DETAIL'
    and qp.plan_id=qr.plan_id
    and to_char(trunc(to_date(qr.CHARACTER1,'YYYY/MM/DD')),'MON-YY')='FEB-15'
--    and rownum<10
order by to_date(qr.character1,'YYYY/MM/DD')


/*------------ CERAMIC_DOWNTIME_DETAILS ------------------*/

select
--    qr.*
    to_char(to_date(qr.character1,'YYYY/MM/DD'),'DD-MON-YYYY') Downtime_date,
    qr.CHARACTER2 Downtime_Shift,
    qr.CHARACTER3 Resource_name,
    qr.CHARACTER4 Major_reason,
    qr.CHARACTER5 Reason_detail,
    to_char(to_date(qr.character6,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS') Downtime_Start,
    to_char(to_date(qr.character7,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS') Downtime_End,
    to_number(qr.CHARACTER8) Downtime_Duration,
    qr.CHARACTER9 Remarks
from
    qa.qa_plans qp,
    qa.QA_RESULTS qr
where
    qp.name='CERAMIC_DOWNTIME_DETAILS'
    and qp.plan_id=qr.plan_id
    and to_char(trunc(to_date(qr.CHARACTER1,'YYYY/MM/DD')),'MON-YY')='MAR-15'
--    and rownum<10
order by to_date(qr.character1,'YYYY/MM/DD')





/*----------  VEHICLE MAINTENANCE  --------------*/
select
--    qr.*
    qr.character1 MAJOR_REASON,
    qr.character2 vehicle_no,    
    to_char(to_date(qr.character3,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') IN_date,
    to_char(to_date(qr.character4,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') tentative_out_date,
    to_char(to_date(qr.character6,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY') actual_out_date,
    to_number(qr.CHARACTER5) tentative_Duration,
    to_number(qr.CHARACTER7) actual_Duration,
    qr.character8 Description,
     qr.character9 OU_NAME,
     qr.character10 VEHICLE_TYPE, 
     qr.character11 Floor_Engineer_Name  
--    qr.CHARACTER2 Downtime_Shift,
--    qr.CHARACTER3 Resource_name,
--    qr.CHARACTER4 Major_reason,
--    qr.CHARACTER5 Reason_detail,
--    to_char(to_date(qr.character6,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS') Downtime_Start,
--    to_char(to_date(qr.character7,'YYYY/MM/DD HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS') Downtime_End,
--    to_number(qr.CHARACTER8) Downtime_Duration,
--    qr.CHARACTER9 Remarks
from
    qa.qa_plans qp,
    qa.QA_RESULTS qr
where
    qp.name='VEHICLE MAINTENANCE'
    and qp.plan_id=qr.plan_id
    and trunc(to_date(qr.character3,'YYYY/MM/DD HH24:MI:SS')) >= '10-JAN-2011' and trunc(to_date(qr.character3,'YYYY/MM/DD HH24:MI:SS'))<='15-FEB-2015'
    and trunc(to_date(qr.character6,'YYYY/MM/DD HH24:MI:SS')) >= '10-JAN-2011' and trunc(to_date(qr.character6,'YYYY/MM/DD HH24:MI:SS'))<='15-FEB-2015'
--    and to_char(trunc(to_date(qr.CHARACTER1,'YYYY/MM/DD')),'MON-YY')='DEC-14'
--    and rownum<10
order by 
    qr.character2,
    trunc(to_date(qr.character3,'YYYY/MM/DD HH24:MI:SS'))


/*----------  CON DOWNTIME DETAIL  --------------*/
select 
    qr.CHARACTER1 Downtime_Date,
qr.CHARACTER10 Performance,
qr.CHARACTER11 Resource_Name,
qr.CHARACTER12 Major_Reason,
qr.CHARACTER13 Reason_Detail,
qr.CHARACTER14 Downtime_Start_Date_and_Time,
qr.CHARACTER15 Downtime_End_Date_and_Time,
qr.CHARACTER16 Duration,
qr.CHARACTER17 Remarks,
qr.CHARACTER2 Shift,
qr.CHARACTER3 Production_Hour,
qr.CHARACTER4 Product_Code,
qr.CHARACTER5 Product_Description,
qr.CHARACTER6 Product_UOM,
qr.CHARACTER7 Standard_Quantity,
qr.CHARACTER8 Actual_Quantity,
qr.CHARACTER9 Delay_Loss
from
    qa.qa_plans qp,
    qa.qa_results qr
where
    qp.name like 'CON%'
    and qp.plan_id=qr.plan_id

