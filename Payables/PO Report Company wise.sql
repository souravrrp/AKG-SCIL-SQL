SELECT-- :T_C3,:T_C4,:T_C5,:T_C6,:T_C7,:T_C8,:T_C9,:T_C10,:T_C11,:T_C12,
pha.rate,TO_CHAR(pha.rate_date,'DD-MON-RRRR') rate_date,
--:P_MOF_PO,
     pha.PO_HEADER_ID,pha.COMMENTS,pla.PO_line_ID,:p_org_id,PLA.LINE_NUM,PLA.NOTE_TO_VENDOR,
      NVL(PHA.AUTHORIZATION_STATUS,'INCOMPLETE') PO_STATUS,
--       decode(:p_release,null,null,NVL(PRA.AUTHORIZATION_STATUS,'INCOMPLETE')) RELEASE_STATUS,
       pll.po_release_id, pra.release_num, 
--       :p_del_date,
       TO_CHAR (pha.APPROVED_DATE, 'DD-MON-RR') po_cr_dt,
      'Purchase Order' PO_TITLE,
      apps.XXAKG_P2P_EMP_INFO.AKG_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by) creator_details,
      'Subject: Purchase Order' PO_TITLE_SUB,
      -- XXAKG_COM_PKG.GET_UNIT_NAME(:p_org_id) Org_header_name,
       --xxakg_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,
          DECODE((select DESTINATION_ORGANIZATION_ID from apps.po_distributions_all where po_header_id=pha.po_header_id and rownum=1),222,'Abul Khair Steel',apps.xxakg_com_pkg.get_hr_operating_unit(:p_org_id)) Org_header_name, 
       apps.XXAKG_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,
       pha.FREIGHT_TERMS_LOOKUP_CODE Mode_transport,
       TO_CHAR (pra.release_date, 'DD-MON-RRRR') rel_dt,
       pha.segment1 po_num, DECODE(org.NAME,'AKM - Project','Abul Khair Steel',org.NAME) org_name,
       pov.vendor_name || ' ' || '(' || pov.SEGMENT1|| ')' supplier_name,
       '(For '||pov.vendor_name||')' SUPP_ALIAS, PLA.ATTRIBUTE2 BRAND,PLA.ATTRIBUTE3 ORIGIN,
       TO_CHAR (pha.revised_date, 'DD-MON-RRRR') rev_dt, pvs.vendor_site_code,
       pra.revision_num release_rev_no, pra.release_date,
       TO_CHAR (pra.release_date, 'DD-MON-RR') release_rev_num,
          pvs.address_line1
       || ' '
       || pvs.address_line2
       || pvs.address_line3
       || pvs.address_line4
       || ' '
       || pvs.city
       || ' '
       || pvs.state
       || ' '
       || pvs.zip
       || ','
       || INITCAP(fnd.TERRITORY_SHORT_NAME) site_add,
       pha1.segment1 quote_no,
       nvl(pha1.QUOTE_VENDOR_QUOTE_NUMBER,PHA.ATTRIBUTE4) supplier_quote,
       TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR')  REPLY_DATE,
       TO_CHAR (pha1.creation_date, 'DD-MON-RRRR') quote_dt, mst.item_code,
       pla.item_description,MUOM.UOM_CODE, 
       pll.quantity po_qty,
      '('||pha.currency_code||')' Currency_code, pla.unit_price, pla.attribute2 brand,
       nvl(pha.revision_num,0) revision_num, pla.attribute3 origin,
       TO_CHAR (pll.need_by_date, 'DD-MON-RRRR') need_by_dt,
       TO_CHAR (pll.PROMISED_DATE, 'DD-MON-RRRR') PROMISED_DATE,
       DECODE(NVL(pra.release_num,-10),-10,pha.type_lookup_code,'RELEASE') po_type, apt.NAME term_name,apt.description pay_term_Desc,
       hrl.location_code bill_to, hrl.location_code ship_to,
       pda.req_header_reference_num pr_no,
       ood.ORGANIZATION_CODE destinition,ood.ORGANIZATION_NAME dest_NAME,
      DECODE (pda.req_header_reference_num,
               NULL,apps.XXAKG_P2P_PKG.XXAKG_FND_REQUISITION_INFO(PLL.ATTRIBUTE1,:P_ORG_ID,PLL.ATTRIBUTE2,'RNUM'),
               pda.req_header_reference_num) requisition_no,
--       :p_note, 
--       :p_release,
        :p_po_no,
       /*PAYMENT*/
       PAY_OP.amount pay_amt,PAY_OP.CHECK_NUMBER pay_chk_no,PAY_OP.check_date pay_chk_dt, PAY_OP.invoice_num pay_ref,
       PAY_OP.invoice_currency_code pay_curr, PAY_OP.bank_name pay_bank, PAY_OP.bank_account_name pay_bnk_acc,
       'of the enterprise is pleased to place purchase order on you under the following terms & conditions :' TITLE,
       TO_CHAR(TO_DATE(substr(PLA.ATTRIBUTE9,1,10),'RRRR/MM/DD'),'DD-MON-RRRR') PROM_DEL_DT
  FROM apps.po_headers_all pha,
       apps.po_headers_all pha1,
       apps.po_lines_all pla,
       apps.mtl_units_of_measure_tl muom,
       apps.po_line_locations_all pll,
       apps.ap_suppliers pov,
       apps.ap_supplier_sites_all pvs,
       apps.hr_all_organization_units_tl org,
       apps.hr_locations_all_tl hrl,
       apps.hr_locations_all_tl hrl1,
       apps.ap_terms apt,
       apps.org_organization_definitions ood,
       apps.fnd_territories_tl fnd,
       apps.po_releases_all pra,
       (SELECT  req_header_reference_num,
        line_location_id
                   FROM apps.po_distributions_v
                   WHERE PO_HEADER_ID=:P_PO_NO
                GROUP BY req_header_reference_num, line_location_id
                   ) pda,
       (SELECT ORGANIZATION_ID,inventory_item_id, description,
                        (segment1 || '.' || segment2 || '.' || segment3
                        ) item_code
                   FROM apps.mtl_system_items_b) mst
       ,(SELECT ck.amount,CK.CHECK_NUMBER, ai.po_header_id, ck.check_date, ai.invoice_num,
               ai.invoice_currency_code, bn.bank_name, cb.bank_account_name
          FROM apps.ap_invoices_all ai,
               apps.ap_checks_all ck,
               apps.ap_invoice_payments_all pm,
               apps.ce_bank_acct_uses_all cs,
               apps.ce_bank_accounts cb,
               apps.ce_bank_branches_v bn
         WHERE ai.invoice_id = pm.invoice_id
           AND pm.check_id = ck.check_id
           AND ai.invoice_type_lookup_code = 'PREPAYMENT'
           AND NVL (ck.status_lookup_code, 'AKG') <> 'VOIDED'
           AND cs.bank_acct_use_id = ce_bank_acct_use_id
           AND cb.bank_id = bn.bank_party_id
           AND CB.BANK_BRANCH_ID=BN.BRANCH_PARTY_ID
           AND AI.PO_HEADER_ID=:P_PO_NO
           AND AI.ORG_ID=:P_ORG_ID
           AND cs.bank_account_id = cb.bank_account_id) pay_op
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET', 'STANDARD')
  -- AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') <> 'APPROVED'
   AND pla.po_header_id = pll.po_header_id
   AND pla.po_line_id = pll.po_line_id
   AND pla.item_id = mst.inventory_item_id(+)
   AND hrl.location_id = pha.bill_to_location_id
   AND hrl1.location_id = pha.ship_to_location_id
   AND pda.line_location_id(+) = pll.line_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pha.org_id = org.organization_id
   and pvs.country=fnd.TERRITORY_CODE(+)
   AND pll.po_release_id = pra.po_release_id(+)
   AND UPPER(pll.SHIPMENT_TYPE)<>'PRICE BREAK'
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N'
   AND NVL(PLL.CANCEL_FLAG,'N')='N'
   --AND NVL(PRA.AUTHORIZATION_STATUS,'APPROVED')<>'APPROVED'
   AND NVL(PRA.CANCEL_FLAG,'N')='N'
   AND pha.terms_id = apt.term_id
   AND pha.po_header_id = pay_op.po_header_id(+)
   AND PLL.SHIP_TO_ORGANIZATION_ID=MST.ORGANIZATION_ID(+)
   AND pha.org_id = :p_org_id
   AND pha.po_header_id = :p_po_no
   AND ood.organization_id = pll.ship_to_organization_id  
--   AND DECODE (pha.type_lookup_code, 'BLANKET', pra.release_num, 900) =  NVL (:p_release, 900)
UNION ALL
SELECT --:T_C3,:T_C4,:T_C5,:T_C6,:T_C7,:T_C8,:T_C9,:T_C10,:T_C11,:T_C12,
pha.rate,TO_CHAR(pha.rate_date,'DD-MON-RRRR') rate_date,
--:P_MOF_PO,
      pha.PO_HEADER_ID,pha.COMMENTS,pla.PO_line_ID,:p_org_id,PLA.LINE_NUM,PLA.NOTE_TO_VENDOR,
      NVL(PHA.AUTHORIZATION_STATUS,'INCOMPLETE') PO_STATUS,
--       TO_CHAR(NULL) RELEASE_STATUS,
       to_number(null) po_release_id, to_number(null) release_num,
--        :p_del_date,
       TO_CHAR (pha.creation_date, 'DD-MON-RR') po_cr_dt,
      'Work Order' PO_TITLE,
       apps.XXAKG_P2P_EMP_INFO.AKG_P2P_GET_EMPNP_MAIL(pha.creation_date,pha.created_by) creator_details,
       'Subject: Work Order' PO_TITLE_SUB,
        -- XXAKG_COM_PKG.GET_UNIT_NAME(:p_org_id) Org_header_name,
       --xxakg_com_pkg.get_hr_operating_unit(:p_org_id) Org_header_name,
         DECODE((select DESTINATION_ORGANIZATION_ID from apps.po_distributions_all where po_header_id=pha.po_header_id and rownum=1),222,'Abul Khair Steel',apps.xxakg_com_pkg.get_hr_operating_unit(:p_org_id)) Org_header_name, 
       apps.XXAKG_COM_PKG.GET_UNIT_address(:p_org_id) org_header_address,
       pha.FREIGHT_TERMS_LOOKUP_CODE Mode_transport,
       TO_CHAR (null) rel_dt,
       pha.segment1 po_num, DECODE(org.NAME,'AKM - Project','Abul Khair Steel',org.NAME) org_name,
       pov.vendor_name || ' ' || '(' || pov.SEGMENT1|| ')' supplier_name,
       '(For '||pov.vendor_name||')' SUPP_ALIAS, PLA.ATTRIBUTE2 BRAND,PLA.ATTRIBUTE3 ORIGIN,
       TO_CHAR (pha.revised_date, 'DD-MON-RRRR') rev_dt, pvs.vendor_site_code,
       to_number(null) release_rev_no, to_date(null) release_date,
       TO_CHAR (null) release_rev_num,
          pvs.address_line1
       || ' '
       || pvs.address_line2
       || pvs.address_line3
       || pvs.address_line4
       || ' '
       || pvs.city
       || ' '
       || pvs.state
       || ' '
       || pvs.zip
       || ','
       || fnd.TERRITORY_SHORT_NAME site_add,
       pha1.segment1 quote_no,
       nvl(pha1.QUOTE_VENDOR_QUOTE_NUMBER,PHA.ATTRIBUTE4) supplier_quote,
       TO_CHAR (pha1.REPLY_DATE, 'DD-MON-RRRR')  REPLY_DATE,
       TO_CHAR (pha1.creation_date, 'DD-MON-RRRR') quote_dt, mst.item_code,
       pla.item_description,MUOM.UOM_CODE, -- pla.unit_meas_lookup_code, 
       --decode(pll.quantity,null,pla.QUANTITY,pll.quantity) po_qty,
       to_number(0) po_qty,
      '('||pha.currency_code||')' Currency_code, pla.unit_price, pla.attribute2 brand,
       nvl(pha.revision_num,0) revision_num, pla.attribute3 origin,
       TO_CHAR (null) need_by_dt,
       TO_CHAR (null) PROMISED_DATE,
       pha.type_lookup_code po_type, apt.NAME term_name,apt.description pay_term_Desc,
       hrl.location_code bill_to, hrl.location_code ship_to,
       TO_CHAR(NULL) pr_no,TO_CHAR(NULL) destinition,TO_CHAR(NULL) dest_NAME,
       apps.XXAKG_P2P_PKG.XXAKG_PRICE_BRK_REQUISITION( pla.po_line_id,:P_ORG_ID) requisition_no,
--       :p_note,
--        :p_release,
         :p_po_no,
       /*PAYMENT*/
       PAY_OP.amount pay_amt,PAY_OP.CHECK_NUMBER pay_chk_no,PAY_OP.check_date pay_chk_dt, PAY_OP.invoice_num pay_ref,
       PAY_OP.invoice_currency_code pay_curr, PAY_OP.bank_name pay_bank, PAY_OP.bank_account_name pay_bnk_acc,
       'of the enterprise is pleased to place work order on you under the following terms & conditions :' TITLE,
       TO_CHAR(TO_DATE(substr(PLA.ATTRIBUTE9,1,10),'RRRR/MM/DD'),'DD-MON-RRRR') PROM_DEL_DT
  FROM apps.po_headers_all pha,
       apps.po_headers_all pha1,
       apps.po_lines_all pla,
       apps.mtl_units_of_measure_tl muom,
       apps.ap_suppliers pov,
       apps.ap_supplier_sites_all pvs,
       apps.hr_all_organization_units_tl org,
       apps.hr_locations_all_tl hrl,
       apps.hr_locations_all_tl hrl1,
       apps.ap_terms apt,
       apps.fnd_territories_tl fnd,
       (SELECT inventory_item_id,
                        (segment1 || '.' || segment2 || '.' || segment3
                        ) item_code
                   FROM apps.mtl_system_items_b
                   group by inventory_item_id,
                        (segment1 || '.' || segment2 || '.' || segment3
                        )) mst,
       (SELECT ck.amount,CK.CHECK_NUMBER, ai.po_header_id, ck.check_date, ai.invoice_num,
               ai.invoice_currency_code, bn.bank_name, cb.bank_account_name
          FROM apps.ap_invoices_all ai,
               apps.ap_checks_all ck,
               apps.ap_invoice_payments_all pm,
               apps.ce_bank_acct_uses_all cs,
               apps.ce_bank_accounts cb,
               apps.ce_bank_branches_v bn
         WHERE ai.invoice_id = pm.invoice_id
           AND pm.check_id = ck.check_id
           AND ai.invoice_type_lookup_code = 'PREPAYMENT'
           AND NVL (ck.status_lookup_code, 'AKG') <> 'VOIDED'
           AND cs.bank_acct_use_id = ce_bank_acct_use_id
           AND cb.bank_id = bn.bank_party_id
           AND CB.BANK_BRANCH_ID=BN.BRANCH_PARTY_ID
           AND AI.PO_HEADER_ID=:P_PO_NO
           AND AI.ORG_ID=:P_ORG_ID
           AND cs.bank_account_id = cb.bank_account_id) pay_op
 WHERE pha.po_header_id = pla.po_header_id
   AND pha.vendor_id = pov.vendor_id
   AND pha.vendor_site_id = pvs.vendor_site_id
   AND pov.vendor_id = pvs.vendor_id
   AND pha.type_lookup_code IN ('BLANKET')
  -- AND NVL (UPPER (pha.authorization_status), 'INCOMPLETE') <> 'APPROVED'
   AND pha.approved_flag = 'Y'
   AND pla.item_id = mst.inventory_item_id(+)
   AND hrl.location_id = pha.bill_to_location_id
   AND hrl1.location_id = pha.ship_to_location_id
   AND pha1.po_header_id(+) = pha.from_header_id
   AND pha.org_id = org.organization_id
   and pvs.country=fnd.TERRITORY_CODE
   AND pla.unit_meas_lookup_code=MUOM.UNIT_OF_MEASURE(+)
   --AND NVL (pha.closed_code, 'OPEN') not in ('CLOSED','FINALLY CLOSED')
   --AND NVL (pLa.closed_code, 'OPEN') not in ('CLOSED','FINALLY CLOSED') 
   AND NVL(PHA.CANCEL_FLAG,'N')='N'
   AND NVL(PLA.CANCEL_FLAG,'N')='N'
   --AND NVL (pha.closed_code, 'OPEN') <> 'CLOSED'
   --AND NVL(PHA.AUTHORIZATION_STATUS,'INCOMPLETE')=NVL(:P_PO_STUS,NVL(PHA.AUTHORIZATION_STATUS,'INCOMPLETE'))
   AND pha.terms_id = apt.term_id
   AND pha.po_header_id = pay_op.po_header_id(+)
   AND pha.org_id = :p_org_id
   AND pha.po_header_id = :p_po_no
--   AND 1=nvl2(:p_release,900,1)
  order by LINE_NUM asc