@EndUserText.label: 'Warehouse Dashboard KPIs'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_WM_DASHBOARD_KPI
  as select from ZI_WM_DASHBOARD_KPI_TOTAL
{
  key WarehouseId,
      TotalCapacity,
      TotalUsed,
      TotalFree,
      TotalUtilizationPercent
}
