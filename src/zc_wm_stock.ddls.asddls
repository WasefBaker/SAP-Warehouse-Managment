@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Stock Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_WM_STOCK as select from ZI_WM_STOCK_DETAIL
{
    key MaterialId,
    key BinId,
        MaterialName,
        WarehouseId,
        BinDescription,
        Quantity,
        Unit
}
