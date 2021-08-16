select * from inv.mtl_transaction_types where rownum<10

select
    *
from
    inv.mtl_material_transactions mmt
where
    transaction_id=23129075
--    rownum<10  

--mmt.DISTRIBUTION_ACCOUNT_ID  

select 
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4 Account_code_combination
from gl.gl_code_combinations gcc 
where 
    gcc.CODE_COMBINATION_ID=219224
--    rownum<10

select
    mmt.transaction_id,
    msi.inventory_item_id,
    msi.segment1||'.'||msi.segment2||'.'||msi.segment3 ITEM_CODE,
    msi.description ITEM_DESC,
    mtt.transaction_type_name,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4 Account_code_combination,
    sum(nvl(mmt.transaction_quantity,0)) TXN_QTY,
    trunc(mmt.transaction_date) TXN_DATE
--    mmt.*
from 
    inv.MTL_MATERIAL_TRANSACTIONS mmt,
    inv.mtl_transaction_types mtt,
    inv.mtl_system_items_b msi,
    gl.gl_code_combinations gcc
where
    mmt.transaction_type_id=mtt.transaction_type_id
    and mmt.inventory_item_id=msi.inventory_item_id
    and mmt.organization_id=msi.organization_id
    and mmt.distribution_account_id=gcc.code_combination_id(+)
    and trunc(mmt.transaction_date) between '01-FEB-2015' and '18-FEB-2015'
--    and trunc(mmt.transaction_date) < '01-NOV-2013'
--    and mmt.transaction_type_id='35'
--    and mtt.transaction_type_name ='Sales order issue'
    and mmt.organization_id=101
--    and gcc.segment3='7000001'
--    and mmt.inventory_item_id in (60081,165969,202983,58481,42050,60083,48710,165253,25829,25830,25831,202982,42393,24722,50276,165250,56882,165975,205117,190974,48728)
    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in ('DRCT.CLNK.0001')
--    and msi.segment1||'.'||msi.segment2||'.'||msi.segment3 in (
--    'GCSP.BMSK.1801',
--'GCSP.FLSB.1801',
--'GCSP.MGNI.1801',
--'GCSP.RMHG.1801',
--'GCSP.SGLX.1801',
--'GCSP.STLG.1801',
--'GCSP.ZBLK.1801',
--'MCSP.BECH.1501',
--'MCSP.BECH.1801',
--'MCSP.EPRD.1801',
--'MCSP.GEM0.1501',
--'MCSP.JGUR.1801',
--'MCSP.LTLC.1801',
--'MCSP.MGWT.1801',
--'MCSP.MRMA.6001',
--'MCSP.NTLP.1801',
--'MCSP.SLME.1501',
--'MCSP.TCTA.1801',
--'MCSP.TVRA.1501',
--'MCSP.VLKS.1801',
--'MCSP.VRNA.1201',
--'MCSP.WCCL.1201',
--'MCSP.WCCL.1801',
--'MCSP.WCLI.1501',
--'MCSP.WCLI.1801',
--'MCSU.BECH.1501',
--'MCSU.TCTA.1501',
--'MSLP.JGUR.1801',
--'MSLP.WCLI.1501',
--'MWCP.WCLI.1801')
--    and msi.description in ('Marble  Block Mugla White',
--'Marble  Block Sugar  White',
--'Marble  Block Otantic White',
--'Marble  Block Light Tippy',
--'Marble  Block Rosaline Pink',
--'Marble  Block Rosaia Pinky',
--'Marble  Block Rosalia Light')
--    and rownum<10    
group by
    mmt.transaction_id,
    msi.inventory_item_id,
        msi.segment1||'.'||msi.segment2||'.'||msi.segment3,
    msi.description,
    mtt.transaction_type_name,
    gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4,
--    sum(nvl(mmt.transaction_quantity,0)),
    trunc(mmt.transaction_date)
order by 2    