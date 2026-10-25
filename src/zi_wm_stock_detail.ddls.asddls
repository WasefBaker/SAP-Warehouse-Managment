@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Stock Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_STOCK_DETAIL as select from zwm_stock as Stock inner join
zwm_material as Material on Stock.material_id = Material.material_id inner join 
zwm_storage_bin as Bin on Stock.bin_id = Bin.bin_id
{
    key Stock.material_id   as MaterialId,
    key Stock.bin_id        as BinId,
        Material.name       as MaterialName,
        Bin.warehouse_id    as WarehouseId,
        Bin.description     as BinDescription,
        Stock.quantity      as Quantity,
        Material.unit       as Unit
}
