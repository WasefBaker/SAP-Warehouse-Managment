@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Warehouse Bin Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_WM_RAP_BIN
  provider contract transactional_query
  as projection on ZI_WM_RAP_BIN
{
    key BinId,
        WarehouseId,
        Description,
        Capacity
}
