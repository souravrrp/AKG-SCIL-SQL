SELECT DO_NUMBER,
          DO_STATUS,
          DO_DATE_TIME,
          CUSTOMER_NUMBER,
          CUSTOMER_NAME,
          DO_MODE_OF_TRANSPORT,
          DO_TRANSPORTER_NAME,
          ORDER_NUMBER,
          ITEM_DESCRIPTION,
          LINE_QUANTITY,
          CONVERT_BAG_QTY,
          SHIPPED_QTY,
          CONVERT_SHIPPED_BAG_QTY,
          DO_WAREHOUSE_ORG_NAME,
          SHIP_TO_LOCATION,
          HAND_OVER_DATE,
          MOV_ORDER_STATUS,
          FINAL_DESTINATION,
          MOVE_WAREHOUSE_ORG_NAME,
          MOVE_MODE_OF_TRANSPORT,
          MOVE_TRANSPORTER_NAME,
          DRIVER_NAME,
          DRIVER_MOBILE,
          CONFIRM_FLAG,
          CONFIRM_DATE,
          GATE_OUT,
          GATE_OUT_DATE,
          GATE_IN,
          GATE_IN_DATE,
          TRUCK_LOADING_FLAG,
          TRUCK_LOADING_DATE
     FROM APPS.XXAKG_OE_DO2MOVE_NEW_V
    WHERE ORG_ID = 85;
