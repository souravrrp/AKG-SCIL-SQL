CREATE OR REPLACE PACKAGE BODY APPS.XXAKG_SECSALES_IMPORT_PKG IS
  PROCEDURE  XXAKG_SECSALES_IMPORT_PROC(errbuf varchar2,retcode varchar2) is 
  
  ln_cust_id          NUMBER;
  ln_order_type_id    NUMBER;
  ln_price_list_id    NUMBER;
  ln_item_id          NUMBER;
  ln_ship_id          NUMBER;
  ln_bill_id          NUMBER;
  ln_org_id           NUMBER;
  ln_line_num         NUMBER:=0;
  ln_line_seq         NUMBER;
  ln_request_id       NUMBER;
  lc_cust_name        VARCHAR2(200);
  ln_cust_num         NUMBER ;
  lc_item_code        VARCHAR2(100);
  lc_req_phase        VARCHAR2(100):=NULL;
  lc_req_status       VARCHAR2(100):=NULL;
  lc_req_dev_phase    VARCHAR2(100):=NULL;
  lc_req_dev_status   VARCHAR2(100):=NULL;
  lc_req_message      VARCHAR2(2000):=NULL;
  lc_wait_req_status  BOOLEAN;
  ln_interval         NUMBER :=60;
  ln_max_wait         NUMBER :=0;
  ln_fst_req_id       NUMBER;  
  ln_lst_req_id       NUMBER;
  ln_rep_request_id   NUMBER;
  ln_warehouse        NUMBER;
  
  
    cursor lcu_adi_hdrdata is
  select distinct cust_account_id
                 ,order_date,month_year
  from xxakg_sales_order_adi_stg
  where cust_account_id is not null;
  
  cursor lcu_adi_linedata(cp_cust_id number, cp_order_date date, cp_month_year VARCHAR2) is --Added on 17-Nov-2014 to restrict duplicate entry
  select * 
  from xxakg_sales_order_adi_stg
  where cust_account_id=cp_cust_id
  and   order_date= cp_order_date --Added on 17-Nov-2014 to restrict duplicate entry
  and   month_year= cp_month_year;--Added on 17-Nov-2014 to restrict duplicate entry
  
  --OE_ORDER_HEADERS_S
  --OE_ORDER_LINES_S
  
  BEGIN
           
  fnd_global.apps_initialize(gn_user_id,gn_responsibility_id,gn_respappl_id);
  
         fnd_file.put_line(fnd_file.output,'----------------------------------------------------------------SECONDARY SALES ORDER REPORT----------------------------------------------------------------------------------------------------');
         fnd_file.put_line(fnd_file.output,'Customer Number'||'    |'||'Customer Name'||'                                |'||'Order Date'||'   |'||'Item '||'              |'||'Qty'||' |'||'Unit selling price');
         fnd_file.put_line(fnd_file.output,'------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');

     FOR lcu_hdr_rec IN lcu_adi_hdrdata
     
      LOOP
      
       
            ------------cust_num and Cust Name------------------
           BEGIN 
            SELECT HP.party_name,HCA.cust_account_id into lc_cust_name,ln_cust_num
              FROM hz_cust_Accounts HCA
                  ,hz_parties HP
             WHERE HP.party_id=HCA.party_id
               AND HCA.account_number=to_char(lcu_hdr_rec.cust_account_id);
               
               exception 
        when others then 
        fnd_file.put_line(fnd_file.log,'Err in Cust Name '||lcu_hdr_rec.cust_account_id);
        END;
         
         -----order_type_id---------
       SELECT order_type_id,org_id INTO ln_order_type_id,ln_org_id
         FROM so_order_types_all
        WHERE name='CGD Second Sales CM';
      
        -------price_list_id----------
  
       SELECT list_header_id INTO ln_price_list_id
         FROM apps.qp_list_headers
        WHERE name='CGD Secondary Price List'
          AND active_flag='Y';
        
          ------Bill to---------
        BEGIN  
          SELECT site_use_id into ln_bill_id
            FROM hz_cust_acct_sites_all  HCAS
                ,hz_cust_site_uses_all   HCSU
                ,hz_cust_accounts HCA
           WHERE bill_to_flag='P'
             AND HCSU.cust_acct_site_id=HCAS.cust_acct_site_id
             AND HCAS.cust_account_id=HCA.cust_account_id
             AND (HCA.account_number)=to_char(lcu_hdr_rec.cust_account_id)  --242990 
             AND SITE_use_code='BILL_TO'
             AND HCSU.primary_flag='Y'  
             AND HCAS.STATUS='A'
             AND HCSU.STATUS='A';
             
             exception 
        when others then 
        fnd_file.put_line(fnd_file.log,'Error in Bill to -'||lcu_hdr_rec.cust_account_id);
        END;
             
      
       --------Ship to-----------------------------
           
       BEGIN
           SELECT site_use_id into ln_ship_id
             FROM hz_cust_acct_sites_all  HCAS
                 ,hz_cust_site_uses_all HCSU
                 ,hz_cust_accounts HCA
            WHERE ship_to_flag='P'
              AND HCSU.cust_acct_site_id=HCAS.cust_acct_site_id
              AND HCAS.cust_account_id=HCA.cust_account_id
             AND (HCA.account_number)=to_char(lcu_hdr_rec.cust_account_id)--lcu_hdr_rec.cust_account_id 
              AND site_use_code='SHIP_TO'
              AND HCSU.primary_flag='Y'
              AND HCAS.STATUS='A'
              AND HCSU.STATUS='A';
              
          exception 
        when others then 
        fnd_file.put_line(fnd_file.log,'Error in Ship TO  '||'-'||lcu_hdr_rec.cust_account_id);
        END;      
                   
         -----------ITEM--------------------------------
         
         fnd_file.put_line(fnd_file.log,'before insert '||'-'||lcu_hdr_rec.cust_account_id);
       
       
                         INSERT INTO oe_headers_iface_all
                                         (
                                         order_source_id
                                         ,context
                                         ,attribute2
                                        ,ordered_date
                                        ,order_type_id --1633
                                        ,price_list_id
                                        ,sold_to_org_id--cust nid
                                        ,orig_sys_document_ref
                                        ,header_id
                                        ,ship_to_org_id
                                        ,invoice_to_org_id
                                        ,sold_from_org_id
                                        ,org_id
                                        ,created_by
                                        ,creation_date
                                        ,last_updated_by
                                        ,last_update_date
                                        ,booked_flag
                                        )
                                  VALUES( 
                                         0,
                                         'CGD Sales'
                                         ,lcu_hdr_rec.month_year
                                         ,lcu_hdr_rec.order_date--order_date
                                        ,ln_order_type_id
                                        ,ln_price_list_id
                                        ,ln_cust_num--lcu_hdr_rec.cust_account_id
                                        ,'OE_ORDER_HEADERS_ALL'||OE_ORDER_HEADERS_S.NEXTVAL
                                        ,OE_ORDER_HEADERS_S.CURRVAL
                                        ,ln_ship_id
                                        ,ln_bill_id
                                        ,ln_org_id
                                        ,ln_org_id
                                        ,fnd_global.user_id
                                        ,sysdate
                                        ,fnd_global.user_id
                                        ,sysdate
                                        ,'Y'
                                          );
       
       
        FOR lcu_line_rec in lcu_adi_linedata(lcu_hdr_rec.cust_account_id,lcu_hdr_rec.order_date, lcu_hdr_rec.month_year)
        
        LOOP
        
        BEGIN--ITEM
        
         SELECT distinct segment1||'.'||segment2||'.'||segment3 into lc_item_code
           FROM mtl_system_items_b
          WHERE inventory_item_id=lcu_line_rec.inventory_item_id
          AND rownum=1;
        END ;
        
        
        
        BEGIN
        SELECT warehouse_id into ln_warehouse 
          FROM oe_transaction_types_vl
         WHERE name like 'Second%'
          AND transaction_type_id= lcu_line_rec.line_type_id;
        
        exception 
        when others then 
        fnd_file.put_line(fnd_file.log,'Wrong ware house id '||lcu_line_rec.line_type_id);
        END;
        
        ln_line_num:=ln_line_num+1;
        
         SELECT OE_ORDER_LINES_S.NEXTVAL 
           INTO ln_line_seq 
           FROM dual;
        
                           INSERT INTO oe_lines_iface_all
                           (
                              order_source_id
                             ,org_id
                             ,line_number 
                             ,line_type_id
                             ,price_list_id
                             ,inventory_item_id
                             ,orig_sys_document_ref
                             ,orig_sys_line_ref
                             ,line_id
                             ,ship_to_org_id
                             ,invoice_to_org_id
                             ,ordered_quantity
                             ,pricing_quantity
                             ,order_quantity_uom
                             ,pricing_quantity_uom
                             ,ship_from_org_id
                             ,unit_selling_price
                             ,unit_selling_price_per_pqty
                             ,context
                             ,attribute3--op_stk
                             ,attribute4--bill amt
                             ,attribute5 --remarks
                             ,attribute6 --expense_type
                             ,created_by
                             ,creation_date
                             ,last_updated_by
                             ,last_update_date   
                             ,option_flag 
                             ,calculate_price_flag              
                             ,unit_list_price     
                             ,actual_shipment_date
                             ,schedule_ship_date      
                           )
                          VALUES
                            (
                            0
                            ,ln_org_id
                            ,ln_line_num
                            ,lcu_line_rec.line_type_id
                            ,ln_price_list_id
                            ,lcu_line_rec.inventory_item_id
                            ,'OE_ORDER_HEADERS_ALL'||OE_ORDER_HEADERS_S.currval
                            ,'OE_ORDER_LINES_ALL'||ln_line_seq
                            ,ln_line_seq
                            ,ln_ship_id
                            ,ln_bill_id
                            ,lcu_line_rec.qty
                            ,lcu_line_rec.qty
                            ,lcu_line_rec.uom
                            ,lcu_line_rec.uom
                            ,ln_warehouse
                            ,lcu_line_rec.unit_selling_price
                            ,lcu_line_rec.unit_selling_price
                            ,'AKG Distributor Details' --context
                            ,lcu_line_rec.distributors_op_stk
                            ,lcu_line_rec.bill_amount
                            ,lcu_line_rec.remarks_dff
                            ,lcu_line_rec.expense_type_dff
                            ,fnd_global.user_id
                            ,sysdate
                            ,fnd_global.user_id
                            ,sysdate     
                            ,''       
                            ,'N'            
                            ,0    
                            ,sysdate
                            ,sysdate
                            );
                   --  fnd_file.put_line(fnd_file.log,'Line num'||ln_line_num);
                    -- fnd_file.put_line(fnd_file.log,'UNIT--'||lcu_line_rec.unit_selling_price);
                    -- fnd_file.put_line(fnd_file.log,'Customer-->'||lcu_hdr_rec.cust_account_id||'Item--'||lcu_line_rec.inventory_item_id);
                     fnd_file.put_line(fnd_file.output,lcu_hdr_rec.cust_account_id||' |'||lc_cust_name||'                  |'||lcu_hdr_rec.order_date||'         |'||lc_item_code||'   |'||lcu_line_rec.qty||'   |'||lcu_line_rec.unit_selling_price );
        END LOOP;  
      
        ln_line_num:=0;
      
      
      END LOOP;
      
      
      BEGIN
      
      fnd_global.apps_initialize(gn_user_id,gn_responsibility_id,gn_respappl_id);

      fnd_file.put_line(fnd_file.LOG,'gp'||' '||gn_user_id||', '||gn_responsibility_id||', '||gn_respappl_id);

      ln_request_id :=  FND_REQUEST.SUBMIT_REQUEST (
               application  =>  'ONT'
              ,program      =>  'OEOIMP'
              ,description  =>  'Order Import'
              ,start_time   =>  SYSDATE
              ,sub_request  =>  NULL
              ,argument1    =>  NULL
              ,argument2    =>  NULL--p_order_source
              ,argument3    =>  NULL--p_orig_sys_document_ref
              ,argument4    =>  NULL--p_operation_code
              ,argument5    =>  'N'--p_validate_only
              ,argument6    =>  1--p_debug_level
              ,argument7    =>  4--p_num_instances
              ,argument8    =>  NULL --p_sold_to_org_id
              ,argument9    =>  NULL--p_sold_to_org
              ,argument10   =>  NULL--p_change_sequence
              ,argument11   =>  'Y'--p_perf_param
              ,argument12   =>  'N'--p_rtrim_data
              ,argument13   =>  'Y'--p_pro_ord_with_null_flag
              ,argument14   =>  ln_org_id--665--p_default_org_id
              ,argument15   =>  'N'--p_validate_desc_flex
             );

       COMMIT;
       
       exception when others then 
       fnd_file.put_line(fnd_file.log,'Error in calling Order Import');
       
       
       fnd_file.put_line(fnd_file.log,'Request Id'||ln_request_id);
      
      END;
     
     
     BEGIN
     
                 
       
       IF ln_request_id > 0 
       THEN
       fnd_file.put_line(fnd_file.LOG,'inside req loop');
       
        LOOP
         lc_wait_req_status :=
                              FND_CONCURRENT.wait_for_request(ln_request_id
                                                              ,ln_interval
                                                              ,ln_max_wait
                                                              ,lc_req_phase
                                                              ,lc_req_status
                                                              ,lc_req_dev_phase
                                                              ,lc_req_dev_status 
                                                              ,lc_req_message
                                                             );
              EXIT 
                WHEN UPPER (lc_req_phase)   = 'COMPLETED' OR UPPER (lc_req_status) IN ('CANCELLED','ERROR','TERMINATED')    ;
        END LOOP;
                                              
                  
        select MIN(request_id),MAX(request_id) 
        into ln_fst_req_id ,ln_lst_req_id 
       from fnd_concurrent_requests where parent_request_id=ln_request_id;
     
     
       fnd_file.put_line(fnd_file.LOG,'frst n last Req id'||ln_fst_req_id||'---'||ln_fst_req_id);
        
        
        
       END IF; 
     
     
     
         BEGIN-- sec sales final report
         ln_rep_request_id :=
         fnd_request.submit_request
          (application      => 'XXAKG',
           program          =>'XXAKGSECSALEREPORT',
           description      => NULL,
           start_time       => NULL,
           sub_request      =>FALSE,
           argument1        =>ln_fst_req_id,
           argument2        =>ln_lst_req_id
        );
      
      
        
        EXCEPTION
         WHEN OTHERS THEN
         fnd_file.put_line(fnd_file.LOG,'Calling Report Package'||ln_rep_request_id||SQLERRM);
       
      
        END;
 
     
     
     END;
     
      
      fnd_file.put_line(fnd_file.log,'After order imp'||ln_request_id);
      
      
      
      delete from xxakg_sales_order_adi_stg;
      
      commit;
      
      
     
   END;
  
  END;
/