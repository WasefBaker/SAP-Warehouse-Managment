@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Bin Stock Totals'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_BIN_STOCK_TOTAL as select from zwm_stock
{
    key bin_id  as BinId,
        sum(quantity) as UsedCapacity
        
}
group by bin_id
