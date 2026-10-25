@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Stock CDS View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_STOCK as select from zwm_stock
{
    key material_id as MaterialId,
    key bin_id      as BinId,
        quantity    as Quantity
}
