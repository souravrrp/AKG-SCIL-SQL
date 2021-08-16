SELECT
*
FROM
APPS.XXAKG_QP_MODIFIER_DISCOUNT_V MOD_PRC
WHERE 1=1
AND MODIFIER_NAME IN (  
                                        'SCIL Corporate Fixed Rate For OPC Cement'
                                        ,'SCIL Corporate Fixed Rate For Special Cement'
                                        ,'SCIL Corporate Fixed Rate For OPC Bulk Cement'
                                        ,'SCIL Corporate Fixed Rate For Popular Cement'
                                        ,'SCIL Corporate Fixed Rate For Special Bulk Cement'
--                                        'RMC Over Sales Price'
--                                        ,'RMC Price Discount'
                                      )
--AND DESC_ATTRIB_VALUE_FROM LIKE '%16822%'
--AND QUALIFIER_ATTR_TYPE NOT IN ('Ship To','Customer Name')
AND END_DATE IS NULL
--AND MOD_LINE_NO=983742
--AND GROUP_NO=242
AND EXISTS (SELECT 1 FROM APPS.XXAKG_QP_MODIFIER_DISCOUNT_V WHERE 1=1
AND MODIFIER_NAME IN (  
                                        'SCIL Corporate Fixed Rate For OPC Cement'
                                        ,'SCIL Corporate Fixed Rate For Special Cement'
                                        ,'SCIL Corporate Fixed Rate For OPC Bulk Cement'
                                        ,'SCIL Corporate Fixed Rate For Popular Cement'
                                        ,'SCIL Corporate Fixed Rate For Special Bulk Cement'
--                                        'RMC Over Sales Price'
--                                        ,'RMC Price Discount'
                                      )
--AND DESC_ATTRIB_VALUE_FROM LIKE '%16822%'
--AND QUALIFIER_ATTR_TYPE NOT IN ('Ship To','Customer Name')
AND END_DATE IS NULL
AND GROUP_NO=MOD_PRC.GROUP_NO
AND QUALIFIER_ATTR_TYPE!=MOD_PRC.QUALIFIER_ATTR_TYPE
AND DESC_ATTRIB_VALUE_FROM!=MOD_PRC.DESC_ATTRIB_VALUE_FROM
AND MOD_LINE_NO=MOD_PRC.MOD_LINE_NO --AND GROUP_NO=28
)