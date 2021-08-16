select
    b.TRANSACTION_ID,
    b.TRANSACTION_TYPE_NAME,
    b.INVENTORY_ITEM_ID,
    b.ITEM_CODE,
    b.ITEM_DESC,
    b.ITEM_CATEGORY,
    b.ITEM_TYPE,
    b.SET_OF_BOOKS_ID,
    b.OPERATING_UNIT,
    ood1.ORGANIZATION_code,
    ood2.ORGANIZATION_code cost_organization_code,
    b.TXN_DATE,
    b.COST_PERIOD,
    b.TXN_PERIOD,
    b.QTY,
    b.PRIMARY_UOM_CODE,
    b.TRANSACTION_COST,
    b.ACC_COST,
    b.QTY*b.ACC_COST ACC_VALUE
from
(SELECT 
            a.*,
            DECODE (NVL (a.transaction_cost, 0),0,apps.fnc_get_item_cost (a.cost_organization_id,a.inventory_item_id,a.cost_period),a.transaction_cost) Acc_Cost
             FROM (                /*---- In transit Shipment/Receipt ------*/
                   SELECT   mmt.transaction_id,
                            mtt.transaction_type_name,
                            msi.inventory_item_id,
                            msi.segment1|| '.'|| msi.segment2|| '.'|| msi.segment3 Item_Code,
                            msi.description Item_Desc,
                            mic.segment1 Item_Category,
                            mic.segment2 Item_Type,
                            ood.set_of_books_id,
                            ood.operating_unit,
                            ood.organization_id,
                            DECODE (mmt.transaction_type_id,12, mmt.transfer_organization_id,mmt.organization_id) Cost_organization_id,
                            TRUNC (mmt.transaction_date) Txn_Date,
                            TO_CHAR (rsh.shipped_date, 'MON-YY') Cost_Period,
                            TO_CHAR (mmt.transaction_date, 'MON-YY') Txn_Period,
                            NVL (mmt.primary_quantity,mmt.transaction_quantity) Qty,
                            msi.PRIMARY_UOM_CODE,
                            mmt.TRANSACTION_COST
                       FROM inv.mtl_material_transactions mmt,
                            inv.mtl_system_items_b msi,
                            apps.mtl_item_categories_v mic,
                            apps.org_organization_definitions ood,
                            inv.mtl_transaction_types mtt,
                            po.rcv_shipment_headers rsh,
                            po.rcv_shipment_lines rsl
                      WHERE     mmt.transaction_type_id IN (12, 21)
                            AND msi.organization_id = ood.organization_id
                            AND msi.organization_id = mic.organization_id
                            AND msi.inventory_item_id = mic.inventory_item_id
                            AND msi.organization_id = mmt.organization_id
                            AND msi.inventory_item_id = mmt.inventory_item_id
                            AND mmt.transaction_type_id =mtt.transaction_type_id
                            AND mmt.shipment_number = rsh.shipment_num
                            AND rsl.shipment_header_id = rsh.shipment_header_id
                            AND mmt.inventory_item_id = rsl.item_id
                   GROUP BY mmt.transaction_id,
                            mmt.transaction_type_id,
                            mtt.transaction_type_name,
                            msi.inventory_item_id,
                            msi.segment1|| '.'|| msi.segment2|| '.'|| msi.segment3,
                            msi.description,
                            mic.segment1,
                            mic.segment2,
                            ood.set_of_books_id,
                            ood.operating_unit,
                            mmt.transfer_organization_id,
                            mmt.organization_id,
                            ood.organization_id,
                            TRUNC (mmt.transaction_date),
                            TO_CHAR (rsh.shipped_date, 'MON-YY'),
                            TO_CHAR (mmt.transaction_date, 'MON-YY'),
                            mmt.primary_quantity,
                            mmt.transaction_quantity,
                            msi.PRIMARY_UOM_CODE,
                            mmt.TRANSACTION_COST
                   /*----End of In transit Shipment/Receipt ------*/
                   UNION
                     SELECT CASE
                               WHEN mmt.transaction_type_id IN
                                          (2, 64, 103, 161)
                               THEN
                                  DECODE (
                                     SIGN(mmt.transfer_transaction_id
                                          - mmt.transaction_id),
                                     -1,
                                     mmt.transfer_transaction_id,
                                     mmt.transaction_id)
                               ELSE
                                  mmt.transaction_id
                            END
                               transaction_id,
                            mtt.transaction_type_name,
                            msi.inventory_item_id,
                            msi.segment1|| '.'|| msi.segment2|| '.'|| msi.segment3 Item_Code,
                            msi.description Item_Desc,
                            mic.segment1 Item_Category,
                            mic.segment2 Item_Type,
                            ood.set_of_books_id,
                            ood.operating_unit,
                            ood.organization_id,
                            CASE
                               WHEN mmt.transaction_type_id = 3 /*Direct Org Transfer*/
                               THEN
                                  DECODE (SIGN (mmt.primary_quantity),
                                          1, mmt.transfer_organization_id,
                                          mmt.organization_id)
                               ELSE
                                  mmt.organization_id
                            END
                               Cost_organization_id,
                            TRUNC (mmt.transaction_date) Txn_Date,
                            TO_CHAR (mmt.transaction_date, 'MON-YY')
                               Cost_period,
                            TO_CHAR (TRUNC (mmt.transaction_date), 'MON-YY')
                               Txn_Period,
                            NVL (mmt.primary_quantity,
                                 mmt.transaction_quantity)
                               Qty,
                            msi.PRIMARY_UOM_CODE,
                            mmt.TRANSACTION_COST
                       FROM inv.mtl_material_transactions mmt,
                            inv.mtl_system_items_b msi,
                            apps.mtl_item_categories_v mic,
                            apps.org_organization_definitions ood,
                            inv.mtl_transaction_types mtt
                      WHERE mmt.transaction_type_id NOT IN (12,21,51,52,80,98,99,104,120,142,160,10008,100002)
                            AND msi.organization_id = ood.organization_id
                            AND msi.organization_id = mic.organization_id
                            AND msi.inventory_item_id = mic.inventory_item_id
                            AND msi.organization_id = mmt.organization_id
                            AND msi.inventory_item_id = mmt.inventory_item_id
                            AND mmt.transaction_type_id =mtt.transaction_type_id
                   GROUP BY mmt.transaction_id,
                            mmt.transfer_transaction_id,
                            mmt.transaction_type_id,
                            mtt.transaction_type_name,
                            msi.inventory_item_id,
                            msi.segment1|| '.'|| msi.segment2|| '.'|| msi.segment3,
                            msi.description,
                            mic.segment1,
                            mic.segment2,
                            ood.set_of_books_id,
                            ood.operating_unit,
                            mmt.organization_id,
                            mmt.transfer_organization_id,
                            ood.ORGANIZATION_id,
                            TO_CHAR (mmt.transaction_date, 'MON-YY'),
                            TRUNC (mmt.transaction_date),
                            mmt.primary_quantity,
                            mmt.transaction_quantity,
                            msi.PRIMARY_UOM_CODE,
                            mmt.TRANSACTION_COST) 
                            a) b,
                            apps.org_organization_definitions ood1,
                            apps.org_organization_definitions ood2
where
    b.organization_id=ood1.organization_id
    and b.COST_ORGANIZATION_ID=ood2.organization_id
    and ood1.operating_unit=665
    and b.item_code in ('BFOD.BCFM.0400')    
--    and b.TRANSACTION_TYPE_NAME like 'PO%'
    and ood1.organization_code='BFD'                      
    and b.Txn_Date <'01-APR-2015'--between '01-MAR-2015' and '31-MAR-2015'
--    and b.item_category='SALES PROMOTION'
--    and b.ITEM_TYPE like '%CANDY%'
--    and ood1.organization_code in ('CDY','DBR','DGR','DMY','DNB','DPT','DRP','DSY','DTN')