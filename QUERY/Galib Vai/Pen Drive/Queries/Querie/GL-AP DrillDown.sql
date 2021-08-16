/* GL Balance from Payables*/
select 
    gel.*
--    gel.PERIOD_NAME,
--    gel.SUBLEDGER_DOC_SEQUENCE_VALUE Voucher_Number,
--    SUM(NVL(gel.ACCOUNTED_DR,0)) Debit,
--    SUM(NVL(ACCOUNTED_CR,0)) Credit,
--    SUM(NVL(gel.ACCOUNTED_DR,0))-SUM(NVL(ACCOUNTED_CR,0)) Balance
from
    gl.gl_je_headers geh,
    gl.gl_je_lines gel,
    gl.gl_code_combinations gcc
where
    geh.je_header_id = gel.je_header_id
    AND gel.code_combination_id = gcc.code_combination_id
    AND geh.LEDGER_ID=2025
--    AND geh.JE_SOURCE='Payables'
--    AND geh.JE_SOURCE='Inventory'
    AND geh.JE_SOURCE='Cost Management'
    AND gcc.segment1 = '2110'
    AND gcc.segment3 = '2050107'
--    AND gel.PERIOD_NAME='MAY-13'
--group by
--    gel.PERIOD_NAME,
--    gel.SUBLEDGER_DOC_SEQUENCE_VALUE
--order by
--    gel.PERIOD_NAME,
--    gel.SUBLEDGER_DOC_SEQUENCE_VALUE
    
    
-----------------------------------------------
select
--    *
    ap.period_name,
    lc.po_number,
    lc.lc_number,
    ap.voucher_number,
    ap.grn_number,
    ap.amount
from
    apps.xxakg_lc_details lc,        
(select
--    *
    aid.PERIOD_NAME,
    aid.ATTRIBUTE1 LC_ID,
    aia.DOC_SEQUENCE_VALUE VOUCHER_NUMBER,
    aid.ATTRIBUTE5 GRN_NUMBER,
    SUM(NVL(aid.AMOUNT,0)) AMOUNT
--    SUM(case when aid.ATTRIBUTE5 is null then NVL(aid.AMOUNT,0) else 0 end) WITHOUT_GRN_AMOUNT,
--    SUM(case when aid.ATTRIBUTE5 is not null then NVL(aid.AMOUNT,0) else 0 end) WITH_GRN_AMOUNT
from
    ap.ap_invoice_distributions_all aid,
    ap.AP_INVOICEs_all aia,
    gl.gl_code_combinations gcc
where
     aid.ATTRIBUTE_CATEGORY = 'LC No.' || ' &' || ' LC Charge Information'
     and aid.invoice_id=aia.invoice_id
     and gcc.segment1='2110'
     and gcc.segment3 in ('2050107')
     and gcc.code_combination_id=aid.dist_code_combination_id
     and aia.SET_OF_BOOKS_ID=2025
     and aia.CANCELLED_DATE is null
     and aia.DOC_SEQUENCE_VALUE in 
     (select 
        gel.SUBLEDGER_DOC_SEQUENCE_VALUE
    from
        gl.gl_je_headers geh,
        gl.gl_je_lines gel,
        gl.gl_code_combinations gcc
    where
        geh.je_header_id = gel.je_header_id
        AND gel.code_combination_id = gcc.code_combination_id
        AND geh.LEDGER_ID=2025
        AND geh.JE_SOURCE='Payables'
--        AND geh.JE_SOURCE='Inventory'
        AND gcc.segment1 = '2110'
        AND gcc.segment3 in ('2050107')
--        AND gel.PERIOD_NAME='MAY-13'
        and gel.SUBLEDGER_DOC_SEQUENCE_VALUE='213034193'
    )
group by
    aid.PERIOD_NAME,
    aid.ATTRIBUTE1,
    aia.DOC_SEQUENCE_VALUE,
    aid.ATTRIBUTE5
 ) ap
 where
    ap.lc_id=lc.lc_id
    and ap.period_name in ('JUL-13') 
--                                        ('DEC-12')
--                                        ('JUL-11','AUG-11','SEP-11','OCT-11','NOV-11','DEC-11','JAN-12')
--                                        ('FEB-12','MAR-12','APR-12','MAY-12','JUN-12')
                                       -- ('JUL-12','AUG-12','SEP-12','OCT-12','NOV-12','DEC-12')--,
--                                        ('JAN-13','FEB-13','MAR-13','APR-13','MAY-13','JUN-13','JUL-13')
--    and to_date(ap.period_name,'MON-YY') < to_date('JAN-13','MON-YY')
    and lc.po_number in ('I/AKCOU/000001',
'I/SCOU/000099',
'I/SCOU/000218',
'I/SCOU/000224',
'I/SCOU/000242',
'I/SCOU/000247',
'I/SCOU/000265',
'I/SCOU/000270',
'I/SCOU/000271',
'I/SCOU/000278',
'I/SCOU/000279',
'I/SCOU/000282',
'I/SCOU/000283',
'I/SCOU/000285',
'I/SCOU/000286',
'I/SCOU/000287',
'I/SCOU/000290',
'I/SCOU/000294',
'I/SCOU/000295',
'I/SCOU/000301',
'I/SCOU/000302',
'I/SCOU/000303',
'I/SCOU/000304',
'I/SCOU/000309',
'I/SCOU/000313',
'I/SCOU/000314',
'I/SCOU/000316',
'I/SCOU/000318',
'I/SCOU/000319',
'I/SCOU/000322',
'I/SCOU/000323',
'I/SCOU/000325',
'I/SCOU/000326',
'I/SCOU/000327',
'I/SCOU/000329',
'I/SCOU/000330',
'I/SCOU/000331',
'I/SCOU/000332',
'I/SCOU/000333',
'I/SCOU/000336',
'I/SCOU/000337',
'I/SCOU/000338',
'I/SCOU/000339',
'I/SCOU/000340',
'I/SCOU/000341',
'I/SCOU/000342',
'I/SCOU/000343',
'I/SCOU/000344',
'I/SCOU/000345',
'I/SCOU/000347',
'I/SCOU/000348',
'I/SCOU/000349',
'I/SCOU/000350',
'I/SCOU/000351',
'I/SCOU/000352',
'I/SCOU/000353',
'I/SCOU/000354',
'I/SCOU/000355',
'I/SCOU/000356',
'I/SCOU/000357',
'I/SCOU/000358',
'I/SCOU/000359',
'I/SCOU/000360',
'I/SCOU/000361',
'I/SCOU/000362',
'I/SCOU/000363',
'I/SCOU/000364',
'I/SCOU/000365',
'I/SCOU/000366',
'I/SCOU/000367',
'I/SCOU/000368',
'I/SCOU/000369',
'I/SCOU/000370',
'I/SCOU/000371',
'I/SCOU/000372',
'I/SCOU/000373',
'I/SCOU/000375',
'I/SCOU/000376',
'I/SCOU/000377',
'I/SCOU/000378',
'I/SCOU/000379',
'I/SCOU/000380',
'I/SCOU/000381',
'I/SCOU/000382',
'I/SCOU/000383',
'I/SCOU/000384',
'I/SCOU/000386',
'I/SCOU/000387',
'I/SCOU/000388',
'I/SCOU/000389',
'I/SCOU/000390',
'I/SCOU/000391',
'I/SCOU/000392',
'I/SCOU/000393',
'I/SCOU/000394',
'I/SCOU/000395',
'I/SCOU/000396',
'I/SCOU/000397',
'I/SCOU/000398',
'I/SCOU/000399',
'I/SCOU/000400',
'I/SCOU/000401',
'I/SCOU/000402',
'I/SCOU/000403',
'I/SCOU/000404',
'I/SCOU/000405',
'I/SCOU/000406',
'I/SCOU/000407',
'I/SCOU/000408',
'I/SCOU/000409',
'I/SCOU/000410',
'I/SCOU/000411',
'I/SCOU/000412',
'I/SCOU/000413',
'I/SCOU/000414',
'I/SCOU/000415',
'I/SCOU/000416',
'I/SCOU/000417',
'I/SCOU/000418',
'I/SCOU/000419',
'I/SCOU/000420',
'I/SCOU/000421',
'I/SCOU/000422',
'I/SCOU/000423',
'I/SCOU/000424',
'I/SCOU/000425',
'I/SCOU/000426',
'I/SCOU/000427',
'I/SCOU/000429',
'I/SCOU/000430',
'I/SCOU/000431',
'I/SCOU/000432',
'I/SCOU/000433',
'I/SCOU/000434',
'I/SCOU/000435',
'I/SCOU/000436',
'I/SCOU/000437',
'I/SCOU/000438',
'I/SCOU/000439',
'I/SCOU/000440',
'I/SCOU/000441',
'I/SCOU/000442',
'I/SCOU/000443',
'I/SCOU/000444',
'I/SCOU/000445',
'I/SCOU/000446',
'I/SCOU/000447',
'I/SCOU/000448',
'I/SCOU/000449',
'I/SCOU/000450',
'I/SCOU/000451',
'I/SCOU/000452',
'I/SCOU/000453',
'I/SCOU/000454',
'I/SCOU/000455',
'I/SCOU/000456',
'I/SCOU/000457',
'I/SCOU/000458',
'I/SCOU/000459',
'I/SCOU/000460',
'I/SCOU/000461',
'I/SCOU/000462',
'I/SCOU/000463',
'I/SCOU/000465',
'I/SCOU/000466',
'I/SCOU/000467',
'I/SCOU/000468',
'I/SCOU/000469',
'I/SCOU/000470',
'I/SCOU/000471',
'I/SCOU/000472',
'I/SCOU/000473',
'I/SCOU/000474',
'I/SCOU/000475',
'I/SCOU/000476',
'I/SCOU/000477',
'I/SCOU/000478',
'I/SCOU/000480',
'I/SCOU/000481',
'I/SCOU/000482',
'I/SCOU/000483',
'I/SCOU/000485',
'I/SCOU/000486',
'I/SCOU/000488',
'I/SCOU/000493',
'I/SCOU/000496',
'I/SCOU/000497')
group by
    ap.period_name,
    lc.po_number,
    lc.lc_number,
    ap.voucher_number,
    ap.grn_number,
    ap.amount
order by
    ap.period_name,
    lc.po_number,
    lc.lc_number,
    ap.voucher_number,
    ap.grn_number,
    ap.amount                                  
--------------------------------------        