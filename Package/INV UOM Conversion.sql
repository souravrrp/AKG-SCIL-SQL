/* Formatted on 10/27/2019 1:30:01 PM (QP5 v5.287) */
  SELECT DECODE (INV_CONVERT.inv_um_convert (OOL.INVENTORY_ITEM_ID,
                                             5,
                                             SUM (OOL.ORDERED_QUANTITY),
                                             OOL.ORDER_QUANTITY_UOM,
                                             'MTN',
                                             NULL,
                                             NULL),
                 -99999, NULL,
                 INV_CONVERT.inv_um_convert (OOL.INVENTORY_ITEM_ID,
                                             5,
                                             SUM (OOL.ORDERED_QUANTITY),
                                             OOL.ORDER_QUANTITY_UOM,
                                             'MTN',
                                             NULL,
                                             NULL))
            ORDER_QTY_MTN,
            ------------------------------------------------------BAG---------------------------------------------------------------------
            DECODE (INV_CONVERT.inv_um_convert (OOL.INVENTORY_ITEM_ID,
                                             5,
                                             DECODE(OOL.INVENTORY_ITEM_ID,'995467',SUM(OOL.ORDERED_QUANTITY)*20,SUM(OOL.ORDERED_QUANTITY)),
                                             OOL.ORDER_QUANTITY_UOM,
                                             'BAG',
                                             NULL,
                                             NULL),
                 -99999, NULL,
                 INV_CONVERT.inv_um_convert (OOL.INVENTORY_ITEM_ID,
                                             5,
                                             DECODE(OOL.INVENTORY_ITEM_ID,'995467',SUM(OOL.ORDERED_QUANTITY)*20,SUM(OOL.ORDERED_QUANTITY)),
                                             OOL.ORDER_QUANTITY_UOM,
                                             'BAG',
                                             NULL,
                                             NULL))
            ORDER_QTY_BAG
    FROM APPS.OE_ORDER_LINES_ALL OOL
   WHERE     1 = 1
         --AND OOL.ORDERED_ITEM = 'CMNT.OBAG.0004'
         AND OOL.SHIPMENT_PRIORITY_CODE IN ('DO/SCOU/922751')
GROUP BY OOL.INVENTORY_ITEM_ID, OOL.ORDER_QUANTITY_UOM