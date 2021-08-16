select msi.secondary_inventory_name, MSI.SECONDARY_INVENTORY_NAME "Subinventory", MSI.DESCRIPTION "Description", 
MSI.DISABLE_DATE "Disable Date", msi.PICKING_ORDER "Picking Order",
gcc1.concatenated_segments "Material Account",
gcc2.concatenated_segments "Material Overhead Account",
gcc3.concatenated_segments "Resource Account",
gcc4.concatenated_segments "Overhead Account",
gcc5.concatenated_segments "Outside Processing Account",
gcc6.concatenated_segments "Expense Account",
gcc7.concatenated_segments "Encumbrance Account",
msi.material_overhead_account,
msi.resource_account,
msi.overhead_account,
msi.outside_processing_account,
msi.expense_account,
msi.encumbrance_account
from apps.mtl_secondary_inventories msi, 
apps.gl_code_combinations_kfv gcc1,
apps.gl_code_combinations_kfv gcc2,
apps.gl_code_combinations_kfv gcc3,
apps.gl_code_combinations_kfv gcc4,
apps.gl_code_combinations_kfv gcc5,
apps.gl_code_combinations_kfv gcc6,
apps.gl_code_combinations_kfv gcc7
where msi.material_account = gcc1.CODE_COMBINATION_ID(+)
and msi.material_overhead_account = gcc2.CODE_COMBINATION_ID(+)
and msi.resource_account = gcc3.CODE_COMBINATION_ID(+)
and msi.overhead_account = gcc4.CODE_COMBINATION_ID(+)
and msi.outside_processing_account = gcc5.CODE_COMBINATION_ID(+)
and msi.expense_account = gcc6.CODE_COMBINATION_ID(+)
and msi.encumbrance_account = gcc7.CODE_COMBINATION_ID(+)
order by msi.secondary_inventory_name
