@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Storage Bins'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_STORAGE_BIN as select from zwm_storage_bin
{
    key bin_id          as  BinId,
        warehouse_id    as  WarehouseId,
        description     as  BinDescription,
        capacity        as  Capacity
}
