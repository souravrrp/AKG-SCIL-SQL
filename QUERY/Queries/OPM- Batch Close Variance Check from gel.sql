--SELECT ledger_id,organization_id,COUNT(*) BatchCount,sum(net) FROM (
 SELECT  /*+ parallel(geh, 20) parallel(gel, 20) parallel(xdl, 20) */
                geh.ledger_id,
--                XDL.APPLICATION_ID,
                ood.organization_code,
                 geh.organization_id,
                 GBH.BATCH_ID,
--                 geh.inventory_item_id,
--                 geh.transaction_id,
                 gbh.batch_no,
                 DECODE (gbh.batch_status,
                 1, 'Pending',
                 2, 'WIP',
                 3, 'Completed',
                 4, 'Closed',
                 -1, 'Cancelled',
                 'Others') Batch_status,
--                 xdl.AE_HEADER_ID,
--                 xdl.ae_line_num,
                 GEH.ENTITY_CODE,
            round(sum(DECODE(SIGN(gel.accounted_amount), 1, gel.accounted_amount, 0, 0, '')), 2) accounted_dr,
            round(sum(DECODE(SIGN(gel.accounted_amount), -1, gel.accounted_amount, 0, 0, '')), 2) accounted_cr,
            round(sum(DECODE(SIGN(gel.accounted_amount), 1, gel.accounted_amount, 0, 0, '')), 2) +
            round(sum(DECODE(SIGN(gel.accounted_amount), -1, gel.accounted_amount, 0, 0, '')), 2) Net
--    gel.*
            FROM apps.gmf_xla_extract_headers geh,
                 apps.gmf_xla_extract_lines gel,
                 apps.gme_batch_header gbh,
                 apps.org_organization_definitions ood
           WHERE     geh.header_id = gel.header_id
                 AND geh.event_id = gel.event_id
                 AND geh.EVENT_CLASS_CODE = 'BATCH_CLOSE'
                 AND geh.entity_code = 'PRODUCTION'
                 AND geh.SOURCE_DOCUMENT_ID=gbh.batch_id and TO_CHAR(geh.transaction_date,'MON-YYYY')='APR-2015'
                 and gel.JOURNAL_LINE_TYPE='CLS'
                and geh.ledger_id=2025
                and geh.organization_id=ood.organization_id
--                and abs(gel.accounted_amount)>1000
--                AND GBH.ORGANIZATION_ID=99
--                and gbh.batch_id=813590
--                and GBH.batch_no in (43403)
        GROUP BY geh.ledger_id,
--                        XDL.APPLICATION_ID,
                    ood.organization_code,
                        geh.organization_id,
--                 geh.inventory_item_id,
--                 geh.transaction_id,
                 gbh.batch_no,GBH.BATCH_ID,gbh.batch_status,
--                 xdl.AE_HEADER_ID,
--                 xdl.ae_line_num,
                 GEH.ENTITY_CODE
        having abs(round(sum(DECODE(SIGN(gel.accounted_amount), 1, gel.accounted_amount, 0, 0, '')), 2) +
            round(sum(DECODE(SIGN(gel.accounted_amount), -1, gel.accounted_amount, 0, 0, '')), 2))>10
            --) GROUP BY ledger_id,organization_id
