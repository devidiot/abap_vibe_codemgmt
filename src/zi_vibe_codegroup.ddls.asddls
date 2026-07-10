@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vibe Code Group'
define root view entity ZI_VIBE_CODEGROUP
  as select from zt_vibe_cdgroup as CodeGroup
  composition [0..*] of ZI_VIBE_CODE as _Code
{
  key CodeGroup.code_group_id as CodeGroupID,
      CodeGroup.code_group_name as CodeGroupName,
      CodeGroup.description as Description,
      CodeGroup.is_active as IsActive,

      @Semantics.user.createdBy: true
      CodeGroup.created_by as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CodeGroup.created_at as CreatedAt,
      @Semantics.user.lastChangedBy: true
      CodeGroup.updated_by as UpdatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      CodeGroup.updated_at as UpdatedAt,
      _Code
}
