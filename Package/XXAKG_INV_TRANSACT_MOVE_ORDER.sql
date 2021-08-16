CREATE OR REPLACE PROCEDURE APPS.xxakg_inv_transact_move_order (
   p_move_order_number   IN     VARCHAR2,
   p_user_id             IN     NUMBER,
   p_resp_id             IN     NUMBER,
   x_return_status          OUT VARCHAR2,
   x_return_msg             OUT VARCHAR2)
AS
   -- Common Declarations
   l_api_version        NUMBER := 1.0;
   l_init_msg_list      VARCHAR2 (2) := FND_API.G_TRUE;
   l_commit             VARCHAR2 (2) := FND_API.G_FALSE;
   --   x_return_status      VARCHAR2 (2);
   x_msg_count          NUMBER := 0;
   x_msg_data           VARCHAR2 (255);

   -- API specific declarations
   l_move_order_type    NUMBER := 1;
   l_transaction_mode   NUMBER := 1;
   l_trolin_tbl         INV_MOVE_ORDER_PUB.trolin_tbl_type;
   l_mold_tbl           INV_MO_LINE_DETAIL_UTIL.g_mmtt_tbl_type;
   x_mmtt_tbl           INV_MO_LINE_DETAIL_UTIL.g_mmtt_tbl_type;
   x_trolin_tbl         INV_MOVE_ORDER_PUB.trolin_tbl_type;
   l_transaction_date   DATE := SYSDATE;

   -- WHO columns
   l_user_id            NUMBER := -1;
   l_resp_id            NUMBER := -1;
   l_application_id     NUMBER := -1;
   l_row_cnt            NUMBER := 1;

   --   l_user_name          VARCHAR2 (30) := '11443';
   --   l_resp_name          VARCHAR2 (80) := 'Inventory';

   --   l_mo_line_id         NUMBER := 0;

   CURSOR c_mo_details
   IS
      SELECT mtrh.header_id,
             mtrh.request_number,
             mtrh.move_order_type,
             mtrh.organization_id,
             mtrl.line_id,
             mtrl.line_number,
             mtrl.inventory_item_id,
             mtrl.lot_number,
             mtrl.quantity,
             revision,
             mtrl.from_locator_id,
             (SELECT DISTINCT operating_unit
                FROM org_organization_definitions
               WHERE organization_id = mtrh.organization_id)
                org_id
        FROM mtl_txn_request_headers mtrh, mtl_txn_request_lines mtrl
       WHERE     mtrh.header_id = mtrl.header_id
             AND mtrh.request_number = p_move_order_number
             AND mtrh.organization_id = 1306;
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

   FND_GLOBAL.APPS_INITIALIZE (l_user_id, l_resp_id, l_application_id); -- Mfg / Mfg Dist Mgr / INV
   DBMS_OUTPUT.put_line (
         'Initialized applications context: '
      || l_user_id
      || ' '
      || l_resp_id
      || ' '
      || l_application_id);

   --   l_trolin_tbl (1).line_id := l_mo_line_id;
   FOR i IN c_mo_details
   LOOP
      mo_global.set_policy_context ('S', i.org_id);
      inv_globals.set_org_id (i.organization_id);
      mo_global.init ('INV');
      l_trolin_tbl (1).line_id := i.line_id;

      --      DBMS_OUTPUT.PUT_LINE ('Move Order Line Id: ' || i.line_id);
      --      -- call API to create move order header
      --      DBMS_OUTPUT.PUT_LINE (
      --         '=======================================================');
      --      DBMS_OUTPUT.PUT_LINE (
      --         'Calling INV_Pick_Wave_Pick_Confirm_PUB.Pick_Confirm API');

      INV_PICK_WAVE_PICK_CONFIRM_PUB.Pick_Confirm (
         p_api_version_number   => l_api_version,
         p_init_msg_list        => l_init_msg_list,
         p_commit               => l_commit,
         x_return_status        => x_return_status,
         x_msg_count            => x_msg_count,
         x_msg_data             => x_msg_data,
         p_move_order_type      => l_move_order_type,
         p_transaction_mode     => l_transaction_mode,
         p_trolin_tbl           => l_trolin_tbl,
         p_mold_tbl             => l_mold_tbl,
         x_mmtt_tbl             => x_mmtt_tbl,
         x_trolin_tbl           => x_trolin_tbl,
         p_transaction_date     => l_transaction_date);

      --      DBMS_OUTPUT.PUT_LINE (
      --         '=======================================================');
      --      DBMS_OUTPUT.PUT_LINE ('Return Status: ' || x_return_status);
      --      DBMS_OUTPUT.put_line (x_msg_data);
      --      DBMS_OUTPUT.put_line (x_msg_count);

      IF (x_msg_count > 0)
      THEN
         FOR i IN 1 .. x_msg_count
         LOOP
            x_msg_data :=
               fnd_msg_pub.get (p_msg_index => i, p_encoded => FND_API.G_FALSE);
         --            DBMS_OUTPUT.put_line ('message :' || x_msg_data);
         END LOOP;
      END IF;

      IF (x_return_status <> FND_API.G_RET_STS_SUCCESS)
      THEN
         ROLLBACK;

         --         DBMS_OUTPUT.PUT_LINE (
         --               'Message count: '
         --            || x_msg_count
         --            || ' Error Message :'
         --            || x_msg_data);

         IF (x_msg_count > 1)
         THEN
            FOR i IN 1 .. x_msg_count
            LOOP
               x_msg_data :=
                  fnd_msg_pub.get (p_msg_index   => i,
                                   p_encoded     => FND_API.G_FALSE);
            --               DBMS_OUTPUT.put_line ('message :' || x_msg_data);
            END LOOP;
         END IF;
      END IF;

      IF (x_return_status = fnd_api.g_ret_sts_success)
      THEN
         COMMIT;
      --               DBMS_OUTPUT.put_line ('Trx temp ID: ' || x_transaction_temp_id);
      END IF;

      x_return_msg := x_msg_data;
   --      DBMS_OUTPUT.PUT_LINE (
   --         '=======================================================');
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      --      DBMS_OUTPUT.PUT_LINE ('Exception Occured :');
      --      DBMS_OUTPUT.PUT_LINE (SQLCODE || ':' || SQLERRM);
      --      DBMS_OUTPUT.PUT_LINE (
      --         '=======================================================');
      x_return_msg := 'Exception Occured :' || SQLCODE || ':' || SQLERRM;
END xxakg_inv_transact_move_order;
/
