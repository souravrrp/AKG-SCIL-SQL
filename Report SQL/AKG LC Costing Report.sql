--------------------------------------------------------------------------------New Query 
SELECT SOURCE,
       LC_ID,
       ORG_ID,
       COMPANY_CODE,
       PO_HEADER_ID,
       VOUCHER,
       LC_NUMBER,
       LC_VALUE,
       MOTHER_VESSEL,
       LC_VALUE_DESC,
       SUPPLIER_NAME,
       LC_OPENING_BANK,
       ASSESSABLE_VALUE,
       LC_OPENING_DATE,
       BILL_AMOUNT,
       LAST_GRN_DATE,
       PARENT_VALUE,
       CHILD_VALUE,
       PERCENT_VALUE,
       ACCOUNTING_DATE,
       CURRENCY_CODE,
       AMOUNT,
    RECEIPT_NO
  FROM apps.XXAKG_AP_LCM_COSTING_V
  WHERE LC_ID = :P_LC_ID
  --and PARENT_VALUE='Value Added Tax'
and PARENT_VALUE not in ('Value Added Tax');

--------------------------------------------------------------------------------OLD QUERY2

SELECT SOURCE,
       LC_ID,
       ORG_ID,
       COMPANY_CODE,
       PO_HEADER_ID,
       VOUCHER,
       LC_NUMBER,
       LC_VALUE,
       MOTHER_VESSEL,
       LC_VALUE_DESC,
       SUPPLIER_NAME,
       LC_OPENING_BANK,
       ASSESSABLE_VALUE,
       LC_OPENING_DATE,
       BILL_AMOUNT,
       LAST_GRN_DATE,
       PARENT_VALUE,
       CHILD_VALUE,
       PERCENT_VALUE,
       ACCOUNTING_DATE,
       CURRENCY_CODE,
       AMOUNT,
    RECEIPT_NO
  FROM apps.XXAKG_AP_LCM_COSTING_V
  WHERE LC_ID = :P_LC_ID
  
--------------------------------------------------------------------------------OLD QUERY3
 SELECT LC_ID,
       PO_HEADER_ID,
       PO_LINE_ID,
       ITEM_CODE,
       ITEM_DESCRIPTION,
       RCV_AMT,
       ORD_QTY,
       GRN_QTY,
       UOM,
       ACT_CURRENCY_CODE,
       GRN_CURRENCY_CODE
  FROM apps.XXAKG_AP_LC_RECEIVING_V
   WHERE LC_ID = :P_LC_ID

--------------------------------------------------------------------------------

function CF_1Formula return NUMBER is

v_vat_amt number;

begin
	select sum(nvl(AMOUNT,0)) into v_vat_amt
	from apps.XXAKG_AP_LCM_COSTING_V 
	WHERE LC_ID = :P_LC_ID 
	and PARENT_VALUE='Value Added Tax'
	AND CHILD_VALUE='VAT on Comm.';
  
  return (v_vat_amt)	;
  
exception when others then 
	return null;
  
end;
   
--------------------------------------------------------------------------------
*/

function CF_LC_VALUE_DESCFormula return Char is
v_basic_amt number;
v_curr_code varchar2(50);
v_lc_val number;
v_rate number;
v_lc_value_desc varchar2(200);


begin
	
	select sum(nvl(AMOUNT,0)) into v_basic_amt 
	from apps.XXAKG_AP_LCM_COSTING_V 
	WHERE LC_ID = :P_LC_ID 
	and PARENT_VALUE='Basic Cost';

/*	
	select DISTINCT round(nvl(LC_VALUE,0),2) into v_lc_val
	from apps.XXAKG_AP_LCM_COSTING_V 
	WHERE LC_ID = :P_LC_ID; */
	
  select nvl(CURRENCY_CODE,'NA') into v_curr_code
  from apps.po_headers_all 
  where po_header_id=:po_header_id;
	 
	 v_rate:=round((nvl(v_basic_amt,0)/nvl(:cs_rcv_amt,1)),3);
	 
 v_lc_value_desc:=:cs_rcv_amt||' ('||v_curr_code||' @ '||v_rate||')';
 
 return (v_lc_value_desc)	; 
	 
exception when others then 
	return null;
  
end;