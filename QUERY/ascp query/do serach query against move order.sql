select a.DO_NUMBER,A.MOV_ORDER_NO,TOTAL_ITEM_QTY,A.CUSTOMER_NAME
FROM APPS.ABC A
WHERE MOV_ORDER_NO between :from_mov and :to_mov--MO/COU/017773
order by mov_order_no