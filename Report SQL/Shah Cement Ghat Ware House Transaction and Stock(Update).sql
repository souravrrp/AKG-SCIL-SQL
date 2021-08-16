select opn.organization_id,opn.organization_name,
opn.special_qty,opn.popular_qty,opn.opc_qty,opn.Stitchp_qty,opn.Stitchs_qty,opn.CEM3_qty,(opn.special_qty+opn.popular_qty+opn.opc_qty+opn.Stitchp_qty+opn.Stitchs_qty+opn.CEM3_qty) opn_sp_po_tot,
trx.trx_special_qty,trx.trx_popular_qty,trx.trx_opc_qty,trx.trx_Stitchp_qty,trx.trx_Stitchs_qty,trx.trx_CEM3_qty,(trx.trx_special_qty+trx.trx_popular_qty+trx.trx_opc_qty+trx.trx_Stitchp_qty+trx.trx_Stitchs_qty+trx.trx_CEM3_qty) trx_sp_po_tot,
sal.sal_special_qty,sal.sal_popular_qty,sal.sal_opc_qty,sal.sal_Stitchp_qty,sal.sal_Stitchs_qty,sal.sal_CEM3_qty,(sal.sal_special_qty+sal.sal_popular_qty+sal.sal_opc_qty+sal.sal_Stitchp_qty+sal.sal_Stitchs_qty+sal.sal_CEM3_qty) sal_sp_po_tot,
adj.adj_special_qty,adj.adj_popular_qty,adj.adj_opc_qty,adj.adj_Stitchp_qty,adj.adj_Stitchs_qty,adj.adj_CEM3_qty,(adj.adj_special_qty+adj.adj_popular_qty+adj.adj_opc_qty+adj.adj_Stitchp_qty+adj.adj_Stitchs_qty+adj.adj_CEM3_qty) adj_sp_po_tot,
cls.cls_special_qty,cls.cls_popular_qty,cls.cls_opc_qty,cls_Stitchp_qty,cls_Stitchs_qty,cls.cls_CEM3_qty,(cls.cls_special_qty+cls.cls_popular_qty+cls.cls_opc_qty+cls_Stitchp_qty+cls_Stitchs_qty+cls.cls_CEM3_qty) cls_sp_po_tot
from
--OPEN
--==============================================
(select organization_id,organization_name,sum(special_qty) special_qty,sum(popular_qty)popular_qty, sum(opc_qty) opc_qty,sum(Stitchp_qty) Stitchp_qty, sum(Stitchs_qty) Stitchs_qty, sum(CEM3_qty) CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
AND MMT.TRANSACTION_TYPE_ID!=10008--NEED TO CLARIFY
AND trunc(MMT.TRANSACTION_DATE) < '31-JUL-2018'-- TRUNC(:PL_DATE)
--AND trunc(MMT.TRANSACTION_DATE) between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs, 'CMNT.CBAG.0001' as CEM3)) 
group by organization_id,organization_name) opn,
--================================
--ORG TRX
--==============================================================================================
(select organization_id,organization_name,sum(special_qty) trx_special_qty,sum(popular_qty)trx_popular_qty, sum(opc_qty) trx_opc_qty,sum(Stitchp_qty) trx_Stitchp_qty, sum(Stitchs_qty) trx_Stitchs_qty, sum(CEM3_qty) trx_CEM3_qty  from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID=3
and mmt.transfer_organization_id=101
AND trunc(MMT.TRANSACTION_DATE) between '31-JUL-2018' and '31-JUL-2018'--TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs,'CMNT.CBAG.0001' as CEM3)) 
group by organization_id,organization_name) trx,
--======================================
--SALES
--======================================
(select ORGANIZATION_ID,organization_name,abs(sum(special_qty)) sal_special_qty,abs(sum(popular_qty))sal_popular_qty, abs(sum(opc_qty)) sal_opc_qty,abs(sum(Stitchp_qty))sal_Stitchp_qty, abs(sum(Stitchs_qty)) sal_Stitchs_qty, abs(sum(CEM3_qty)) sal_CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
--AND OOD.ORGANIZATION_ID IN (103,104,105,106,107,108,109,111,112,115,116,117,118,119,120,121,126,181,182,183,184,185,186,187,484,564)),
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID=33
AND trunc(MMT.TRANSACTION_DATE)  between '31-JUL-2018' and '31-JUL-2018'--TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs,'CMNT.CBAG.0001' as CEM3)) 
group by ORGANIZATION_ID,organization_name) sal,
--==============================================================================
--ADJUST
--==============================================================================
(select ORGANIZATION_ID,organization_name,sum(special_qty) adj_special_qty,sum(popular_qty)adj_popular_qty, sum(opc_qty) adj_opc_qty,sum(Stitchp_qty) adj_Stitchp_qty, sum(Stitchs_qty) adj_Stitchs_qty,sum(CEM3_qty) adj_CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID IN (32,42)
AND trunc(MMT.TRANSACTION_DATE)  between '31-JUL-2018' and '31-JUL-2018'--TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs,'CMNT.CBAG.0001' as CEM3)) 
group by ORGANIZATION_ID,organization_name) adj,
--=================================================
--CLS
--================================================
(select ORGANIZATION_ID,organization_name,sum(special_qty) cls_special_qty,sum(popular_qty) cls_popular_qty, sum(opc_qty) cls_opc_qty,sum(Stitchp_qty) cls_Stitchp_qty, sum(Stitchs_qty) cls_Stitchs_qty,sum(CEM3_qty) cls_CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
AND MMT.TRANSACTION_TYPE_ID!=10008--NEED TO CLARIFY
AND trunc(MMT.TRANSACTION_DATE) <='31-JUL-2018'-- TRUNC(:PH_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs,'CMNT.CBAG.0001' as CEM3)) 
group by organization_ID,organization_name) cls
where opn.organization_ID=trx.organization_ID
and opn.organization_ID=sal.organization_ID
and opn.organization_ID=adj.organization_ID
and opn.organization_ID=cls.organization_ID
order by opn.organization_id





select organization_id,organization_name,sum(special_qty) special_qty,sum(popular_qty)popular_qty, sum(opc_qty) opc_qty,sum(Stitchp_qty) Stitchp_qty, sum(Stitchs_qty) Stitchs_qty, sum(CEM3_qty) CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
AND MMT.TRANSACTION_TYPE_ID!=10008--NEED TO CLARIFY
--AND trunc(MMT.TRANSACTION_DATE) < TRUNC(:PL_DATE)
AND trunc(MMT.TRANSACTION_DATE) between '31-JUL-2018' and '31-JUL-2018' --TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs, 'CMNT.CBAG.0001' as CEM3)) 
group by organization_id,organization_name

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select opn.organization_id,opn.organization_name,
opn.special_qty,opn.popular_qty,opn.opc_qty,opn.Stitchp_qty,opn.Stitchs_qty,opn.CEM3_qty,(opn.special_qty+opn.popular_qty+opn.opc_qty+opn.Stitchp_qty+opn.Stitchs_qty+opn.CEM3_qty) opn_sp_po_tot,
trx.trx_special_qty,trx.trx_popular_qty,trx.trx_opc_qty,trx.trx_Stitchp_qty,trx.trx_Stitchs_qty,trx.trx_CEM3_qty,(trx.trx_special_qty+trx.trx_popular_qty+trx.trx_opc_qty+trx.trx_Stitchp_qty+trx.trx_Stitchs_qty+trx.trx_CEM3_qty) trx_sp_po_tot,
sal.sal_special_qty,sal.sal_popular_qty,sal.sal_opc_qty,sal.sal_Stitchp_qty,sal.sal_Stitchs_qty,sal.sal_CEM3_qty,(sal.sal_special_qty+sal.sal_popular_qty+sal.sal_opc_qty+sal.sal_Stitchp_qty+sal.sal_Stitchs_qty+sal.sal_CEM3_qty) sal_sp_po_tot,
adj.adj_special_qty,adj.adj_popular_qty,adj.adj_opc_qty,adj.adj_Stitchp_qty,adj.adj_Stitchs_qty,adj.adj_CEM3_qty,(adj.adj_special_qty+adj.adj_popular_qty+adj.adj_opc_qty+adj.adj_Stitchp_qty+adj.adj_Stitchs_qty+adj.adj_CEM3_qty) adj_sp_po_tot,
cls.cls_special_qty,cls.cls_popular_qty,cls.cls_opc_qty,cls_Stitchp_qty,cls_Stitchs_qty,cls.cls_CEM3_qty,(cls.cls_special_qty+cls.cls_popular_qty+cls.cls_opc_qty+cls_Stitchp_qty+cls_Stitchs_qty+cls.cls_CEM3_qty) cls_sp_po_tot
from
--OPEN
--==============================================
(select organization_id,organization_name,sum(special_qty) special_qty,sum(popular_qty)popular_qty, sum(opc_qty) opc_qty,sum(Stitchp_qty) Stitchp_qty, sum(Stitchs_qty) Stitchs_qty, sum(CEM3_qty) CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
AND MMT.TRANSACTION_TYPE_ID!=10008--NEED TO CLARIFY
AND TO_CHAR(MMT.TRANSACTION_DATE,'YYYY/MON/DD HH24:MI:SS') < TRUNC(:PL_DATE)
--AND trunc(MMT.TRANSACTION_DATE) between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs, 'CMNT.CBAG.0001' as CEM3)) 
group by organization_id,organization_name) opn,
--================================
--ORG TRX
--==============================================================================================
(select organization_id,organization_name,sum(special_qty) trx_special_qty,sum(popular_qty)trx_popular_qty, sum(opc_qty) trx_opc_qty,sum(Stitchp_qty) trx_Stitchp_qty, sum(Stitchs_qty) trx_Stitchs_qty, sum(CEM3_qty) trx_CEM3_qty  from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID=3
and mmt.transfer_organization_id=101
AND TO_CHAR(MMT.TRANSACTION_DATE,'YYYY/MON/DD HH24:MI:SS') between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs,'CMNT.CBAG.0001' as CEM3)) 
group by organization_id,organization_name) trx,
--======================================
--SALES
--======================================
(select ORGANIZATION_ID,organization_name,abs(sum(special_qty)) sal_special_qty,abs(sum(popular_qty))sal_popular_qty, abs(sum(opc_qty)) sal_opc_qty,abs(sum(Stitchp_qty))sal_Stitchp_qty, abs(sum(Stitchs_qty)) sal_Stitchs_qty, abs(sum(CEM3_qty)) sal_CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
--AND OOD.ORGANIZATION_ID IN (103,104,105,106,107,108,109,111,112,115,116,117,118,119,120,121,126,181,182,183,184,185,186,187,484,564)),
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID=33
AND TO_CHAR(MMT.TRANSACTION_DATE,'YYYY/MON/DD HH24:MI:SS')  between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs,'CMNT.CBAG.0001' as CEM3)) 
group by ORGANIZATION_ID,organization_name) sal,
--==============================================================================
--ADJUST
--==============================================================================
(select ORGANIZATION_ID,organization_name,sum(special_qty) adj_special_qty,sum(popular_qty)adj_popular_qty, sum(opc_qty) adj_opc_qty,sum(Stitchp_qty) adj_Stitchp_qty, sum(Stitchs_qty) adj_Stitchs_qty,sum(CEM3_qty) adj_CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID IN (32,42)
AND TO_CHAR(MMT.TRANSACTION_DATE,'YYYY/MON/DD HH24:MI:SS')  between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs,'CMNT.CBAG.0001' as CEM3)) 
group by ORGANIZATION_ID,organization_name) adj,
--=================================================
--CLS
--================================================
(select ORGANIZATION_ID,organization_name,sum(special_qty) cls_special_qty,sum(popular_qty) cls_popular_qty, sum(opc_qty) cls_opc_qty,sum(Stitchp_qty) cls_Stitchp_qty, sum(Stitchs_qty) cls_Stitchs_qty,sum(CEM3_qty) cls_CEM3_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
AND MMT.TRANSACTION_TYPE_ID!=10008--NEED TO CLARIFY
AND TO_CHAR(MMT.TRANSACTION_DATE,'YYYY/MON/DD HH24:MI:SS') <= TRUNC(:PH_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs,'CMNT.CBAG.0001' as CEM3)) 
group by organization_ID,organization_name) cls
where opn.organization_ID=trx.organization_ID
and opn.organization_ID=sal.organization_ID
and opn.organization_ID=adj.organization_ID
and opn.organization_ID=cls.organization_ID
order by opn.organization_id




------------------------------------NEW AGAIN----------------------------------------------


select opn.organization_id,opn.organization_name,
opn.special_qty,opn.popular_qty,opn.opc_qty,opn.Stitchp_qty,opn.Stitchs_qty,opn.CEMIII_qty,(opn.special_qty+opn.popular_qty+opn.opc_qty+opn.Stitchp_qty+opn.Stitchs_qty+opn.CEMIII_qty) opn_sp_po_tot,
trx.trx_special_qty,trx.trx_popular_qty,trx.trx_opc_qty,trx.trx_Stitchp_qty,trx.trx_Stitchs_qty,trx.trx_CEMIII_qty,(trx.trx_special_qty+trx.trx_popular_qty+trx.trx_opc_qty+trx.trx_Stitchp_qty+trx.trx_Stitchs_qty+trx.trx_CEMIII_qty) trx_sp_po_tot,
sal.sal_special_qty,sal.sal_popular_qty,sal.sal_opc_qty,sal.sal_Stitchp_qty,sal.sal_Stitchs_qty,sal.sal_CEMIII_qty,(sal.sal_special_qty+sal.sal_popular_qty+sal.sal_opc_qty+sal.sal_Stitchp_qty+sal.sal_Stitchs_qty+sal.sal_CEMIII_qty) sal_sp_po_tot,
adj.adj_special_qty,adj.adj_popular_qty,adj.adj_opc_qty,adj.adj_Stitchp_qty,adj.adj_Stitchs_qty,adj.adj_CEMIII_qty,(adj.adj_special_qty+adj.adj_popular_qty+adj.adj_opc_qty+adj.adj_Stitchp_qty+adj.adj_Stitchs_qty+adj.adj_CEMIII_qty) adj_sp_po_tot,
cls.cls_special_qty,cls.cls_popular_qty,cls.cls_opc_qty,cls_Stitchp_qty,cls_Stitchs_qty,cls.cls_CEMIII_qty,(cls.cls_special_qty+cls.cls_popular_qty+cls.cls_opc_qty+cls_Stitchp_qty+cls_Stitchs_qty+cls.cls_CEMIII_qty) cls_sp_po_tot
from
--OPEN
--==============================================
(select organization_id,organization_name,sum(special_qty) special_qty,sum(popular_qty)popular_qty, sum(opc_qty) opc_qty,sum(Stitchp_qty) Stitchp_qty, sum(Stitchs_qty) Stitchs_qty, sum(CEMIII_qty) CEMIII_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
AND MMT.TRANSACTION_TYPE_ID!=10008--NEED TO CLARIFY
AND trunc(MMT.TRANSACTION_DATE) < TRUNC(:PL_DATE)
--AND trunc(MMT.TRANSACTION_DATE) between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs, 'CMNT.CBAG.0001' as CEMIII)) 
group by organization_id,organization_name) opn,
--================================
--ORG TRX
--==============================================================================================
(select organization_id,organization_name,sum(special_qty) trx_special_qty,sum(popular_qty)trx_popular_qty, sum(opc_qty) trx_opc_qty,sum(Stitchp_qty) trx_Stitchp_qty, sum(Stitchs_qty) trx_Stitchs_qty, sum(CEMIII_qty) trx_CEMIII_qty  from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID=3
and mmt.transfer_organization_id=101
AND trunc(MMT.TRANSACTION_DATE) between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs, 'CMNT.CBAG.0001' as CEMIII)) 
group by organization_id,organization_name) trx,
--======================================
--SALES
--======================================
(select ORGANIZATION_ID,organization_name,abs(sum(special_qty)) sal_special_qty,abs(sum(popular_qty))sal_popular_qty, abs(sum(opc_qty)) sal_opc_qty,abs(sum(Stitchp_qty))sal_Stitchp_qty, abs(sum(Stitchs_qty)) sal_Stitchs_qty, abs(sum(CEMIII_qty)) sal_CEMIII_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
--AND OOD.ORGANIZATION_ID IN (103,104,105,106,107,108,109,111,112,115,116,117,118,119,120,121,126,181,182,183,184,185,186,187,484,564)),
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID=33
AND trunc(MMT.TRANSACTION_DATE)  between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs, 'CMNT.CBAG.0001' as CEMIII)) 
group by ORGANIZATION_ID,organization_name) sal,
--==============================================================================
--ADJUST
--==============================================================================
(select ORGANIZATION_ID,organization_name,sum(special_qty) adj_special_qty,sum(popular_qty)adj_popular_qty, sum(opc_qty) adj_opc_qty,sum(Stitchp_qty) adj_Stitchp_qty, sum(Stitchs_qty) adj_Stitchs_qty, sum(CEMIII_qty) adj_CEMIII_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and mmt.TRANSACTION_TYPE_ID IN (32,42)
AND trunc(MMT.TRANSACTION_DATE)  between TRUNC(:PL_DATE) and TRUNC(:Ph_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs, 'CMNT.CBAG.0001' as CEMIII)) 
group by ORGANIZATION_ID,organization_name) adj,
--=================================================
--CLS
--================================================
(select ORGANIZATION_ID,organization_name,sum(special_qty) cls_special_qty,sum(popular_qty) cls_popular_qty, sum(opc_qty) cls_opc_qty,sum(Stitchp_qty) cls_Stitchp_qty, sum(Stitchs_qty) cls_Stitchs_qty, sum(CEMIII_qty) cls_CEMIII_qty from
(WITH ORG AS
(SELECT OOD.ORGANIZATION_ID,OOD.ORGANIZATION_NAME,MSI.INVENTORY_ITEM_ID,(MSI.SEGMENT1||'.'||MSI.SEGMENT2||'.'||MSI.SEGMENT3) ITEM_CODE
FROM INV.MTL_SYSTEM_ITEMS_B MSI, apps.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE OOD.ORGANIZATION_ID=MSI.ORGANIZATION_ID
AND MSI.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null),
TRX AS
(select mmt.inventory_item_id,MMT.organization_id,
sum(mmt.transaction_quantity)QTY
from inv.mtl_material_transactions MMT, apps.org_organization_definitions ood
WHERE mmt.organization_id=ood.organization_id
and ood.organization_name like '%Ghat%' 
and ood.disable_date is null
AND MMT.INVENTORY_ITEM_ID IN (24403,24495,206571,856985,856986,992159)
AND MMT.TRANSACTION_TYPE_ID!=10008--NEED TO CLARIFY
AND trunc(MMT.TRANSACTION_DATE) <= TRUNC(:PH_DATE)
group by mmt.inventory_item_id,MMT.organization_id)
SELECT ORG.ORGANIZATION_ID,ORG.ORGANIZATION_NAME,ORG.INVENTORY_ITEM_ID,ORG.ITEM_CODE,NVL(TRX.QTY,0) QTY FROM ORG,TRX
WHERE ORG.ORGANIZATION_ID=TRX.ORGANIZATION_ID(+)
AND ORG.INVENTORY_ITEM_ID=TRX.INVENTORY_ITEM_ID(+)
ORDER BY ORG.ORGANIZATION_ID)
PIVOT(SUM(QTY)AS QTY FOR ITEM_CODE IN('CMNT.SBAG.0001' AS Special,'CMNT.PBAG.0001' as Popular,'CMNT.OBAG.0001' as OPC,'CMNT.PBAG.0003' as Stitchp,'CMNT.SBAG.0003' as Stitchs, 'CMNT.CBAG.0001' as CEMIII)) 
group by organization_ID,organization_name) cls
where opn.organization_ID=trx.organization_ID
and opn.organization_ID=sal.organization_ID
and opn.organization_ID=adj.organization_ID
and opn.organization_ID=cls.organization_ID
order by opn.organization_id

