@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vibe Code'
define view entity ZI_VIBE_CODE
  as select from zvibe_code as Code
  association to parent ZI_VIBE_CODEGROUP as _CodeGroup
    on $projection.CodeGroupID = _CodeGroup.CodeGroupID
{
  key Code.code_group_id as CodeGroupID,
  key Code.code_id as CodeID,
      Code.code_value as CodeValue,
      Code.description as Description,
      Code.is_active as IsActive,
      Code.sort_order as SortOrder,

      @Semantics.user.createdBy: true
      Code.created_by as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Code.created_at as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Code.updated_by as UpdatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Code.updated_at as UpdatedAt,
      _CodeGroup
}
