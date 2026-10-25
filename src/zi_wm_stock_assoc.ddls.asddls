@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Stock Associations'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_STOCK_ASSOC as select from zwm_stock as Stock 
association [0..1] to ZI_WM_MATERIAL as _Material on Stock.material_id = 
_Material.MaterialId
association [0..1] to ZI_WM_STORAGE_BIN as _StorageBin on Stock.bin_id =
_StorageBin.BinId
{
    key Stock.material_id   as MaterialId,
    key Stock.bin_id        as BinId,
        Stock.quantity      as Quantity,
        _Material,
        _StorageBin
}
