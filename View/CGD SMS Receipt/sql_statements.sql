

select distinct * from apps.XXAKG_AR_RECEIPT_SMS where receipt_date >= '1-OCT-2015' 
and RECEIPT_CURR_STATUS ='CONFIRMED' 
and LAST_UPDATE_date >  to_date('16-JAN-2016 12:42:11 PM','dd-mon-yyyy hh:mi:ss AM' ) ; 





select distinct * from apps.XXAKG_AR_RECEIPT_SMS where receipt_date >= '1-OCT-2015' 
and RECEIPT_CURR_STATUS ='CLEARED' and 
LAST_UPDATE_date >  to_date('16-JAN-2016 12:42:11 PM','dd-mon-yyyy hh:mi:ss AM' ) ; 

