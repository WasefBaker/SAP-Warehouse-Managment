@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Bin Utilization'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZI_WM_BIN_UTILIZATION
  as select from ZI_WM_BIN_CAPACITY
{
  key BinId,
      WarehouseId,
      BinDescription,
      Capacity,
      UsedCapacity,
      FreeCapacity,

      case
        when Capacity > 0
        then division(
          cast( UsedCapacity as abap.dec(15,2) ) * 100,
          cast( Capacity as abap.dec(15,2) ),
          2
        )
        else cast( 0 as abap.dec(15,2) )
      end as UtilizationPrecent,

      case
        when Capacity <= 0 then 'RED'
        when UsedCapacity >= Capacity then 'RED'
        when UsedCapacity * 100 >= Capacity * 90
          then 'RED'
        when UsedCapacity * 100 >= Capacity * 50
          then 'YELLOW'
        else 'GREEN'
      end as UtilizationStatus
}
