CREATE OR REPLACE PROCEDURE APPS.xxakg_inv_allocate_move_order (
   p_move_order_number   IN     VARCHAR2,
   p_user_id             IN     NUMBER,
   p_resp_id             IN     NUMBER,
   x_return_status          OUT VARCHAR2,
   x_return_msg             OUT VARCHAR2)
AS
   l_api_version            NUMBER := 1.0;
   l_init_msg_list          VARCHAR2 (2) := fnd_api.g_true;
   l_return_values          VARCHAR2 (2) := fnd_api.g_false;
   l_commit                 VARCHAR2 (2) := fnd_api.g_false;
   --   x_return_status          VARCHAR2 (2);
   x_msg_count              NUMBER := 0;
   x_msg_data               VARCHAR2 (255);
   l_user_id                NUMBER;
   l_resp_id                NUMBER;
   l_appl_id                NUMBER;
   l_row_cnt                NUMBER := 1;
   l_trohdr_rec             inv_move_order_pub.trohdr_rec_type;
   l_trohdr_val_rec         inv_move_order_pub.trohdr_val_rec_type;
   x_trohdr_rec             inv_move_order_pub.trohdr_rec_type;
   x_trohdr_val_rec         inv_move_order_pub.trohdr_val_rec_type;
   l_validation_flag        VARCHAR2 (2) := inv_move_order_pub.g_validation_yes;
   l_trolin_tbl             inv_move_order_pub.trolin_tbl_type;
   l_trolin_val_tbl         inv_move_order_pub.trolin_val_tbl_type;
   x_trolin_tbl             inv_move_order_pub.trolin_tbl_type;
   x_trolin_val_tbl         inv_move_order_pub.trolin_val_tbl_type;
   x_number_of_rows         NUMBER;
   x_transfer_to_location   NUMBER;
   x_expiration_date        DATE;
   x_transaction_temp_id    NUMBER;

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
   SELECT user_id
     INTO l_user_id
     FROM fnd_user
    --    WHERE user_name = '11443';
    WHERE user_id = p_user_id;

   SELECT responsibility_id, application_id
     INTO l_resp_id, l_appl_id
     FROM fnd_responsibility_vl
    --    WHERE responsibility_name = 'Inventory';
    WHERE responsibility_id = p_resp_id;

   fnd_global.apps_initialize (l_user_id, l_resp_id, l_appl_id);

   FOR i IN c_mo_details
   LOOP
      mo_global.set_policy_context ('S', i.org_id);
      inv_globals.set_org_id (i.organization_id);
      mo_global.init ('INV');

      SELECT COUNT (*)
        INTO x_number_of_rows
        FROM mtl_txn_request_lines
       WHERE header_id = i.header_id;

      --      DBMS_OUTPUT.put_line (
      --         '==========================================================');
      --      DBMS_OUTPUT.put_line (
      --         'Calling INV_REPLENISH_DETAIL_PUB to Allocate MO');

      -- Allocate each line of the Move Order
      inv_replenish_detail_pub.line_details_pub (
         p_line_id                 => i.line_id,
         x_number_of_rows          => x_number_of_rows,
         x_detailed_qty            => i.quantity,
         x_return_status           => x_return_status,
         x_msg_count               => x_msg_count,
         x_msg_data                => x_msg_data,
         x_revision                => i.revision,
         x_locator_id              => i.from_locator_id,
         x_transfer_to_location    => x_transfer_to_location,
         x_lot_number              => i.lot_number,
         x_expiration_date         => x_expiration_date,
         x_transaction_temp_id     => x_transaction_temp_id,
         p_transaction_header_id   => NULL,
         p_transaction_mode        => NULL,
         p_move_order_type         => i.move_order_type,
         p_serial_flag             => fnd_api.g_false,
         p_plan_tasks              => FALSE,
         p_auto_pick_confirm       => FALSE,
         p_commit                  => FALSE);

      --      DBMS_OUTPUT.put_line ('return status:' || x_return_status);
      --      DBMS_OUTPUT.put_line (x_msg_data);
      --      DBMS_OUTPUT.put_line (x_msg_count);

      IF (x_return_status <> fnd_api.g_ret_sts_success)
      THEN
         ROLLBACK;
      --               DBMS_OUTPUT.put_line (x_msg_data);
      END IF;

      IF (x_return_status = fnd_api.g_ret_sts_success)
      THEN
         COMMIT;
      --               DBMS_OUTPUT.put_line ('Trx temp ID: ' || x_transaction_temp_id);
      END IF;

      x_return_msg := x_msg_data;
   --      DBMS_OUTPUT.put_line (
   --         '==========================================================');
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      --      DBMS_OUTPUT.put_line ('Exception Occured :');
      --      DBMS_OUTPUT.put_line ('SQLCODE :' || SQLERRM);
      --      DBMS_OUTPUT.put_line (
      --         '=======================================================');
      x_return_msg := 'Exception Occured :' || SQLCODE || ':' || SQLERRM;
END xxakg_inv_allocate_move_order;
/
