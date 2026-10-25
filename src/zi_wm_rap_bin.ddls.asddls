@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RAP Warehouse Bin Interface'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_WM_RAP_BIN
  as select from zwm_rap_bin
{
  key bin_id                as BinId,
      warehouse_id          as WarehouseId,
      description           as Description,
      capacity              as Capacity,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
