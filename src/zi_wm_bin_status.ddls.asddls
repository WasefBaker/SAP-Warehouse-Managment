@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Bin Status'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_WM_BIN_STATUS
  with parameters
    p_warehouse : abap.char(4)

  as select from ZI_WM_BIN_UTILIZATION
{
  key BinId,
      WarehouseId,
      BinDescription,
      Capacity,
      UsedCapacity,
      FreeCapacity,
      UtilizationPrecent,
      UtilizationStatus,

      case
        when UsedCapacity > Capacity
          then 'OVER_CAPACITY'
        when UsedCapacity = Capacity
          then 'FULL'
        when UsedCapacity = 0
          then 'EMPTY'
        else 'AVAILABLE'
      end as BinStatus
}
where WarehouseId = $parameters.p_warehouse
