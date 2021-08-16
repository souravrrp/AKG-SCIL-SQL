/* Formatted on 7/14/2019 1:42:37 PM (QP5 v5.287) */
SELECT a.segment1 || '.' || a.segment2 || '.' || a.segment3 Item_code,
       a.description item_desc,
       msi.description name_other,
       a.organization_id,
       mp.organization_code,
       a.item_type,
       inventory_item_status_code status,
       ick.concatenated_segments item_category,
       a.inventory_item_flag,
       a.inventory_item_status_code,
       a.primary_uom_code,
       a.primary_unit_of_measure,
       fa.concatenated_segments asset_category
  FROM apps.mtl_system_items a,
       apps.mtl_categories_b_kfv ick,
       apps.mtl_category_sets_vl cs,
       apps.mtl_item_categories c,
       apps.mtl_parameters mp,
       apps.mtl_system_items_tl msi,
       apps.fa_categories_b_kfv fa
 WHERE     1 = 1
       AND fa.category_id(+) = a.asset_category_id
       AND cs.structure_id = ick.structure_id
       AND ick.category_id = c.category_id
       AND a.inventory_item_id = msi.inventory_item_id
       AND a.inventory_item_id = c.inventory_item_id
       AND a.organization_id = c.organization_id
       AND msi.language = 'US'
       AND msi.organization_id = a.organization_id
       AND a.organization_id = mp.organization_id
       AND a.segment1 || '.' || a.segment2 || '.' || a.segment3 =
              'SCRP.MUTH.0001'
              
              
              
--------------------------------------------------------------------------------

/* Formatted on 7/14/2019 12:38:43 PM (QP5 v5.287) */
SELECT DISTINCT
       ORG.ORGANIZATION_CODE,
       MSI.SEGMENT1 ITEM,
       MSI.DESCRIPTION,
       MSI.PRIMARY_UNIT_OF_MEASURE,
       GLCC1.CONCATENATED_SEGMENTS COST_OF_SALES_ACCOUNT,
       GLCC2.CONCATENATED_SEGMENTS EXPENSE_ACCOUNT,
       DECODE (MSI.PLANNING_MAKE_BUY_CODE,  '2', 'BUY',  '1', 'MAKE')
          MAKE_BUY_CODE,
       ML.MEANING ITEM_TYPE,
       (SELECT MSI.INVENTORY_ITEM_STATUS_CODE
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.inventory_item_status_code')
          ITEM_STATUS,
       (SELECT MSI.PURCHASING_ITEM_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.purchasing_item_flag')
          PURCHASED,
       (SELECT MSI.SHIPPABLE_ITEM_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.shippable_item_flag')
          SHIPPABLE,
       (SELECT MSI.MTL_TRANSACTIONS_ENABLED_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.mtl_transactions_enabled_flag')
          TRANSACTABLE,
       (SELECT MSI.SO_TRANSACTIONS_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.so_transactions_flag')
          OE_TRANSACTABLE,
       (SELECT MSI.INTERNAL_ORDER_ENABLED_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.internal_order_enabled_flag')
          INTERNAL_ORDERS_ENABLED,
       (SELECT MSI.CUSTOMER_ORDER_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.customer_order_enabled_flag')
          OM_CUSTOMER_ORDERED,
       (SELECT MSI.RETURNABLE_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.customer_order_enabled_flag')
          OM_RETURNABLE_FLAG,
       (SELECT MSI.CUSTOMER_ORDER_ENABLED_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.customer_order_enabled_flag')
          CUSTOMER_ORDERS_ENABLED,
       (SELECT MSI.PURCHASING_ENABLED_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.purchasing_enabled_flag')
          PURCHASABLE,
       MSI.OUTSIDE_OPERATION_UOM_TYPE,
       (SELECT MSI.INVENTORY_ASSET_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.inventory_asset_flag')
          INVENTORY_ASSET_VALUE,
       MSI.COSTING_ENABLED_FLAG,
       MSI.DEFAULT_INCLUDE_IN_ROLLUP_FLAG INCLUDE_IN_ROLLUP,
       (SELECT MSI.ENG_ITEM_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) = 'mtl_system_items.eng_item_flag')
          ENGINEERING_ITEM,
       (SELECT MSI.INVENTORY_ITEM_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.inventory_item_flag')
          INVENTORY_ITEM,
       (SELECT MSI.MUST_USE_APPROVED_VENDOR_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.service_item_flag')
          USE_APPROVED_SUPPLIER,
       (SELECT MSI.INTERNAL_ORDER_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.internal_order_flag')
          INTERNAL_ORDERED,
       (SELECT MSI.BUILD_IN_WIP_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.build_in_wip_flag')
          BUILD_IN_WIP,
       (SELECT MSI.BOM_ENABLED_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.bom_enabled_flag')
          BOM_ALLOWED,
       DECODE (MSI.WIP_SUPPLY_TYPE,
               1, 'PUSH',
               2, 'ASSEMBLY_PULL',
               3, 'OPERATION_PULL',
               4, 'BULK',
               5, 'SUPPLIER',
               6, 'PHANTOM')
          WIP_SUPPLY_TYPE,
       (SELECT MSI.STOCK_ENABLED_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.stock_enabled_flag')
          STOCKABLE,
       MSI.SO_TRANSACTIONS_FLAG OM_TRANSACTIONS,
       MSI.MTL_TRANSACTIONS_ENABLED_FLAG MTL_TRANSACTIONS_ENABLED,
       (SELECT MSI.INVOICEABLE_ITEM_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.INVOICEABLE_ITEM_FLAG')
          INVOICEABLE_ITEM_FLAG,
       (SELECT MSI.INVOICE_ENABLED_FLAG
          FROM APPS.MTL_ITEM_ATTRIBUTES_V IA
         WHERE LOWER (IA.ATTRIBUTE_NAME) =
                  'mtl_system_items.INVOICE_ENABLED_FLAG')
          INVOICE_ENABLED_FLAG,
       (SELECT NAME
          FROM APPS.HR_ALL_ORGANIZATION_UNITS
         WHERE ORGANIZATION_ID = MSI.DEFAULT_SHIPPING_ORG)
          DEFAULT_SHIPPING_ORGNIZATION,
       MSI.ATTRIBUTE11 SONA_DMR_CODE,
       MSI.ATTRIBUTE12 SONA_ITEM_ISSUE_TYPE,
       MSI.ATTRIBUTE10 SONA_SALES_TAX_NUMBER,
       MSI.ATTRIBUTE9 SONA_TOOLS_PLANNED_LIFE,
       DECODE (MSI.INVENTORY_PLANNING_CODE,
               6, 'Not Planned',
               2, 'Min-Max',
               1, 'Reorder Point',
               7, 'Vendor Managed')
          "INVENTORY PLANNING CODE",
       MSI.PLANNER_CODE,
       DECODE (MSI.SUBCONTRACTING_COMPONENT,
               1, 'Prepositioned',
               2, 'Synchronized',
               NULL, NULL)
          "SUBCONTRACTING COMPONENT",
       MSI.MIN_MINMAX_QUANTITY,
       MSI.MAX_MINMAX_QUANTITY,
       MSI.MINIMUM_ORDER_QUANTITY,
       MSI.MAXIMUM_ORDER_QUANTITY,
       MSI.ORDER_COST "Cost Order",
       MSI.CARRYING_COST "Cost Carrying %",
       DECODE (MSI.SOURCE_TYPE,
               1, 'Inventory',
               2, 'Supplier',
               3, 'Subinventory',
               NULL, NULL)
          "Source Type",
       ORG1.ORGANIZATION_CODE "Source Organization",
       ORG1.ORGANIZATION_NAME "Source Organization Name",
       MSI.SOURCE_SUBINVENTORY,
       DECODE (MSI.MRP_SAFETY_STOCK_CODE,
               1, 'Non-MRP Planned',
               2, 'MRP Planned %')
          "Safety Stock Method",
       MSI.SAFETY_STOCK_BUCKET_DAYS "Safety Stock Bucket Days",
       MSI.MRP_SAFETY_STOCK_PERCENT "Safety Stock Percent",
       DECODE (MSI.MRP_PLANNING_CODE,
               3, 'MRP Planned',
               4, 'MPS Planned',
               6, 'Not Planned',
               7, 'MRP/MPP Planned',
               8, 'MPS/MPP Planned',
               9, 'MPP Planned',
               NULL)
          "MRP Planning Method",
       MSI.FIXED_ORDER_QUANTITY,
       MSI.FIXED_DAYS_SUPPLY,
       MSI.FIXED_LOT_MULTIPLIER,
       MSI.VMI_MINIMUM_UNITS "VM Min Quantity",
       MSI.VMI_MINIMUM_DAYS "VM Min Days of Supply",
       MSI.VMI_MAXIMUM_UNITS "VM Max Quantity",
       MSI.VMI_MAXIMUM_DAYS "VM Max Days of Supply",
       MSI.VMI_FIXED_ORDER_QUANTITY "VM Fixed Quantity",
       DECODE (MSI.SO_AUTHORIZATION_FLAG,
               1, 'Customer',
               2, 'Supplier',
               NULL, 'None')
          "VM Release Autho Required",
       DECODE (MSI.CONSIGNED_FLAG,  1, 'Yes',  2, 'No') CONSIGNED,
       DECODE (MSI.ASN_AUTOEXPIRE_FLAG,  1, 'Yes',  2, 'No')
          "VM Auto Expire ASN",
       DECODE (MSI.VMI_FORECAST_TYPE,
               1, 'Order Forecast',
               2, 'Sales Forecast',
               3, 'Historical Sales',
               NULL, NULL)
          "VM Forecast Type",
       MSI.FORECAST_HORIZON "VM Window Days",
       (SELECT REGIME_CODE
          FROM APPS.JAI_RGM_ITM_REGNS A
         WHERE     A.ORGANIZATION_ID = MSI.ORGANIZATION_ID
               AND A.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
               AND A.REGIME_CODE = 'EXCISE')
          "Regime Excise",
       (SELECT REGIME_CODE
          FROM APPS.JAI_RGM_ITM_REGNS B
         WHERE     B.ORGANIZATION_ID = MSI.ORGANIZATION_ID
               AND B.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
               AND B.REGIME_CODE = 'VAT')
          "Regime VAT",
       MSI.ORGANIZATION_ID,
       DECODE (MSI.INSPECTION_REQUIRED_FLAG,
               'Y', 'Inspection Required',
               'N', 'Inspection Not Required',
               NULL)
          ITEM_INSPECTION,
       MS.CATEGORY_SET_NAME,
       MS.CATEGORY_CONCAT_SEGS "Category Segments"
  FROM APPS.FND_LOOKUP_VALUES ML,
       APPS.MTL_SYSTEM_ITEMS_B MSI,
       APPS.ORG_ORGANIZATION_DEFINITIONS ORG,
       APPS.ORG_ORGANIZATION_DEFINITIONS ORG1,
       APPS.MTL_ITEM_CATEGORIES_V MS,
       --apps.org_organization_definitions org2,
       APPS.HR_ORGANIZATION_UNITS HOU,
       APPS.GL_CODE_COMBINATIONS_KFV GLCC1,
       APPS.GL_CODE_COMBINATIONS_KFV GLCC2
 WHERE     1 = 1
       -- AND msi.organization_id = :organization_id
       AND MSI.ITEM_TYPE = ML.LOOKUP_CODE(+)
       AND ML.LOOKUP_TYPE(+) = 'ITEM_TYPE'
       AND MSI.ORGANIZATION_ID = ORG.ORGANIZATION_ID
       AND MSI.INVENTORY_ITEM_ID = MS.INVENTORY_ITEM_ID
       AND MSI.ORGANIZATION_ID = MS.ORGANIZATION_ID
       AND MSI.ORGANIZATION_ID = HOU.ORGANIZATION_ID
       AND MSI.SOURCE_ORGANIZATION_ID = ORG1.ORGANIZATION_ID(+)
       AND MSI.COST_OF_SALES_ACCOUNT = GLCC1.CODE_COMBINATION_ID
       AND MSI.EXPENSE_ACCOUNT = GLCC2.CODE_COMBINATION_ID
       AND MSI.INVENTORY_ITEM_ID = 24408
--ORDER BY   1, 2