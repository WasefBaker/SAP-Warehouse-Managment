@EndUserText.label: 'Total Stock per Storage Bin'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZI_WM_BIN_STOCK_SUM
  as select from zwm_stock
{
  key bin_id as BinId,

      sum( quantity ) as TotalStock
}
group by bin_id
