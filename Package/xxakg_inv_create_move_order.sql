CREATE OR REPLACE PROCEDURE APPS.xxakg_inv_create_move_order (
   p_move_order_number   IN     VARCHAR2,
   p_vehicle_number      IN     VARCHAR2,
   p_move_order_qty      IN     NUMBER,
   p_cost_center        IN  VARCHAR2,
   p_user_id             IN     NUMBER,
   p_resp_id             IN     NUMBER,
   x_return_status          OUT VARCHAR2,
   x_return_msg             OUT VARCHAR2)
AS
   -- Common Declarations
   l_api_version      NUMBER := 1.0;
   l_init_msg_list    VARCHAR2 (2) := FND_API.G_TRUE;
   l_return_values    VARCHAR2 (2) := FND_API.G_FALSE;
   l_commit           VARCHAR2 (2) := FND_API.G_FALSE;
   --   x_return_status    VARCHAR2 (2);
   x_msg_count        NUMBER := 0;
   x_msg_data         VARCHAR2 (4000);

   -- WHO columns
   l_user_id          NUMBER := -1;
   l_resp_id          NUMBER := -1;
   l_application_id   NUMBER := -1;
   l_row_cnt          NUMBER := 1;
   --   l_user_name        VARCHAR2 (30) := '11443';
   --   l_resp_name        VARCHAR2 (50) := 'Inventory'; --'Manufacturing and Distribution Manager';
   
   l_to_account_id  NUMBER:=-1;

   -- API specific declarations
   l_header_id        NUMBER := 0;
   l_trohdr_rec       INV_MOVE_ORDER_PUB.TROHDR_REC_TYPE;
   l_trohdr_val_rec   INV_MOVE_ORDER_PUB.TROHDR_VAL_REC_TYPE;
   l_trolin_tbl       INV_MOVE_ORDER_PUB.TROLIN_TBL_TYPE;
   l_trolin_val_tbl   INV_MOVE_ORDER_PUB.TROLIN_VAL_TBL_TYPE;
   x_trolin_tbl       INV_MOVE_ORDER_PUB.TROLIN_TBL_TYPE;
   x_trolin_val_tbl   INV_MOVE_ORDER_PUB.TROLIN_VAL_TBL_TYPE;
   x_trohdr_rec       INV_MOVE_ORDER_PUB.TROHDR_REC_TYPE;
   x_trohdr_val_rec   INV_MOVE_ORDER_PUB.TROHDR_VAL_REC_TYPE;

   v_msg_index_out    NUMBER;
BEGIN
   -- Get the user_id
   SELECT user_id
     INTO l_user_id
     FROM fnd_user
    --    WHERE user_name = l_user_name;
    WHERE user_id = p_user_id;

   -- Get the application_id and responsibility_id
   SELECT application_id, responsibility_id
     INTO l_application_id, l_resp_id
     FROM fnd_responsibility_vl
    --    WHERE responsibility_name = l_resp_name;
    WHERE responsibility_id = p_resp_id;

   
   SELECT NVL(code_combination_id,95332)
     INTO l_to_account_id
     FROM GL_CODE_COMBINATIONS
    --    WHERE user_name = l_user_name;
    WHERE SEGMENT1||'.'||SEGMENT2||'.'||SEGMENT3||'.'||SEGMENT4||'.'||SEGMENT5 = '2300.'||p_cost_center||'.4032001.9999.00';

   
   FND_GLOBAL.APPS_INITIALIZE (l_user_id, l_resp_id, l_application_id); -- Suhasini / Mfg  Mgr / INV
   --   DBMS_OUTPUT.put_line (
   --         'Initialized applications context: '
   --      || l_user_id
   --      || ' '
   --      || l_resp_id
   --      || ' '
   --      || l_application_id);

   mo_global.set_policy_context ('S', 82);
   inv_globals.set_org_id (1306);
   mo_global.init ('INV');

   -- Initialize the move order header
   l_trohdr_rec.date_required := SYSDATE;                       ----sysdate+2;
   l_trohdr_rec.organization_id := 1306;                        ---207;--- CRT
   l_trohdr_rec.from_subinventory_code := 'CRT-PUMP';            ----'Stores';
   --   l_trohdr_rec.to_subinventory_code := NULL;                      -----'FGI';
   l_trohdr_rec.status_date := SYSDATE;
   l_trohdr_rec.request_number := p_move_order_number;
   --      'FCA_' || TO_CHAR (SYSDATE, 'YYMMDDHH24MISS');
   l_trohdr_rec.header_status := INV_Globals.G_TO_STATUS_PREAPPROVED; -- preApproved
   l_trohdr_rec.transaction_type_id := INV_GLOBALS.G_TYPE_TRANSFER_ORDER_ISSUE;
   --          l_trohdr_rec.transaction_type_id        :=   INV_GLOBALS.G_TYPE_TRANSFER_ORDER_SUBXFR; -- INV_GLOBALS.G_TYPE_TRANSFER_ORDER_STGXFR;
   l_trohdr_rec.move_order_type := INV_GLOBALS.G_MOVE_ORDER_REQUISITION; -- G_MOVE_ORDER_PICK_WAVE;
   l_trohdr_rec.db_flag := FND_API.G_TRUE;
   l_trohdr_rec.operation := INV_GLOBALS.G_OPR_CREATE;
   l_trohdr_rec.to_account_id := l_to_account_id;--95332;
   -- Attribute
   l_trohdr_rec.ATTRIBUTE_CATEGORY := 'AKCL Vehicle Number';
   l_trohdr_rec.ATTRIBUTE1 := p_vehicle_number;
   -- Who columns
   l_trohdr_rec.created_by := l_user_id;
   l_trohdr_rec.creation_date := SYSDATE;
   l_trohdr_rec.last_updated_by := l_user_id;
   l_trohdr_rec.last_update_date := SYSDATE;

   -- create  line  for the  header created above
   l_trolin_tbl (l_row_cnt).date_required := SYSDATE;
   l_trolin_tbl (l_row_cnt).organization_id := 1306;        ---207;--- CRT207;
   l_trolin_tbl (l_row_cnt).inventory_item_id := 55605;            ----513963;
   l_trolin_tbl (l_row_cnt).from_subinventory_code := 'CRT-PUMP'; ---'Stores';
   --   l_trolin_tbl (l_row_cnt).to_subinventory_code := NULL;           ----'FGI';
   l_trolin_tbl (l_row_cnt).quantity := p_move_order_qty;
   l_trolin_tbl (l_row_cnt).status_date := SYSDATE;
   l_trolin_tbl (l_row_cnt).uom_code := 'LTR';                       ----'Ea';
   l_trolin_tbl (l_row_cnt).line_number := l_row_cnt;
   l_trolin_tbl (l_row_cnt).line_status := INV_Globals.G_TO_STATUS_PREAPPROVED;
   l_trolin_tbl (l_row_cnt).transaction_type_id :=
      inv_globals.g_type_transfer_order_issue;
   l_trolin_tbl (l_row_cnt).db_flag := FND_API.G_TRUE;
   l_trolin_tbl (l_row_cnt).operation := INV_GLOBALS.G_OPR_CREATE;
   l_trolin_tbl (l_row_cnt).to_account_id := l_to_account_id;---95332;
   -- Who columns
   l_trolin_tbl (l_row_cnt).created_by := l_user_id;
   l_trolin_tbl (l_row_cnt).creation_date := SYSDATE;
   l_trolin_tbl (l_row_cnt).last_updated_by := l_user_id;
   l_trolin_tbl (l_row_cnt).last_update_date := SYSDATE;
   l_trolin_tbl (l_row_cnt).last_update_login := -1;   ---FND_GLOBAL.login_id;

   -- call API to create move order header
   --   DBMS_OUTPUT.PUT_LINE (
   --      '=======================================================');
   --   DBMS_OUTPUT.PUT_LINE ('Calling INV_MOVE_ORDER_PUB.Process_Move_Order API');

   INV_MOVE_ORDER_PUB.Process_Move_Order (
      P_API_VERSION_NUMBER   => l_api_version,
      P_INIT_MSG_LIST        => l_init_msg_list,
      P_RETURN_VALUES        => l_return_values,
      P_COMMIT               => l_commit,
      X_RETURN_STATUS        => x_return_status,
      X_MSG_COUNT            => x_msg_count,
      X_MSG_DATA             => x_msg_data,
      P_TROHDR_REC           => l_trohdr_rec,
      P_TROHDR_VAL_REC       => l_trohdr_val_rec,
      P_TROLIN_TBL           => l_trolin_tbl,
      P_TROLIN_VAL_TBL       => l_trolin_val_tbl,
      X_TROHDR_REC           => x_trohdr_rec,
      X_TROHDR_VAL_REC       => x_trohdr_val_rec,
      X_TROLIN_TBL           => x_trolin_tbl,
      X_TROLIN_VAL_TBL       => x_trolin_val_tbl);

   --   DBMS_OUTPUT.PUT_LINE (
   --      '=======================================================');
   --   DBMS_OUTPUT.PUT_LINE ('Return Status: ' || x_return_status);
   --   DBMS_OUTPUT.PUT_LINE ('Return Status: ' || x_msg_count);

   IF (x_return_status <> FND_API.G_RET_STS_SUCCESS)
   THEN
      ROLLBACK;
      x_return_msg := 'Move Order Creation Failed Due to Following Reasons';

      --      DBMS_OUTPUT.PUT_LINE (
      --         'Move Order Creation Failed Due to Following Reasons');
      --      --      DBMS_OUTPUT.PUT_LINE ('Error Message :' || x_msg_data);
      IF x_msg_count > 0
      THEN
         FOR v_index IN 1 .. x_msg_count
         LOOP
            fnd_msg_pub.get (p_msg_index       => v_index,
                             p_encoded         => 'F',
                             p_data            => x_msg_data,
                             p_msg_index_out   => v_msg_index_out);
            x_msg_data := SUBSTR (x_msg_data, 1, 200);
            x_return_msg := x_return_msg || ' ' || x_msg_data;
         --            DBMS_OUTPUT.put_line (x_msg_data);
         --            DBMS_OUTPUT.put_line (x_return_msg);
         END LOOP;
      END IF;
   END IF;

   IF (x_return_status = FND_API.G_RET_STS_SUCCESS)
   THEN
      COMMIT;
      x_return_msg :=
            'Move Order Created Successfully for '
         || l_trohdr_rec.request_number;
   --      DBMS_OUTPUT.PUT_LINE (
   --            'Move Order Created Successfully for '
   --         || l_trohdr_rec.request_number
   --         || x_trolin_tbl (l_row_cnt).header_id);
   --      DBMS_OUTPUT.PUT_LINE (x_return_msg);
   END IF;
--   DBMS_OUTPUT.PUT_LINE (
--      '=======================================================');
EXCEPTION
   WHEN OTHERS
   THEN
      --      DBMS_OUTPUT.PUT_LINE ('Exception Occured :');
      --      DBMS_OUTPUT.PUT_LINE (SQLCODE || ':' || SQLERRM);
      --      DBMS_OUTPUT.PUT_LINE (
      --         '=======================================================');
      x_return_msg := 'Exception Occured :' || SQLCODE || ':' || SQLERRM;
END xxakg_inv_create_move_order;
/
