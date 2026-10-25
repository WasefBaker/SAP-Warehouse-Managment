@EndUserText.label: 'Warehouse Dashboard KPIs'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZI_WM_DASHBOARD_KPI
  as select from ZI_WM_BIN_UTILIZATION
{
  WarehouseId,

  sum( Capacity )     as TotalCapacity,
  sum( UsedCapacity ) as TotalUsed,
  sum( FreeCapacity ) as TotalFree
}
group by WarehouseId
