@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Warehouse Material Master'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_WM_MATERIAL as select from zwm_material
{
    key material_id as  MaterialId,
        name        as  MaterialName,
        unit        as  Unit
}
