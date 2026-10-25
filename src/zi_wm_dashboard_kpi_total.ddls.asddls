@EndUserText.label: 'Warehouse Dashboard KPI Totals'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZI_WM_DASHBOARD_KPI_TOTAL
  as select from ZI_WM_DASHBOARD_KPI
{
  key WarehouseId,

      TotalCapacity,
      TotalUsed,
      TotalFree,

      case
        when TotalCapacity > 0
        then division(
          cast( TotalUsed as abap.dec( 15, 2 ) ) * 100,
          cast( TotalCapacity as abap.dec( 15, 2 ) ),
          2
        )
        else cast( 0 as abap.dec( 15, 2 ) )
      end as TotalUtilizationPercent
}
