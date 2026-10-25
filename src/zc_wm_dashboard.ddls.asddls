@EndUserText.label: 'Warehouse Dashboard'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_WM_DASHBOARD
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
      
      case UtilizationStatus
        when 'GREEN'  then 3
        when 'YELLOW' then 2
        when 'RED'    then 1
        else 0
      end as StatusCriticality
}
