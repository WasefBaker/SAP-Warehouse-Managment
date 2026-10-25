@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Bin Capacity Overview'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_BIN_CAPACITY as select from zwm_storage_bin as Bin left outer
join ZI_WM_BIN_STOCK_TOTAL as Stock on Bin.bin_id = Stock.BinId
{
    key Bin.bin_id       as BinId,
        Bin.warehouse_id as WarehouseId,
        Bin.description  as BinDescription,
        Bin.capacity     as Capacity,
        coalesce( Stock.UsedCapacity, 0) as UsedCapacity,
        Bin.capacity - coalesce( Stock.UsedCapacity, 0 ) as FreeCapacity 
}
