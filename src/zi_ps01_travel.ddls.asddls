@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel - Interface View'
define root view entity ZI_PS01_Travel as select from zps01_travel
{
    key traveluuid as Traveluuid,
    travelid as Travelid,
    agencyid as Agencyid,
    customerid as Customerid,
    begindate as Begindate,
    enddate as Enddate,
    bookingfee as Bookingfee,
    totalprice as Totalprice,
    currencycode as Currencycode,
    status as Status,
    description as Description,
    @Semantics.user.createdBy: true
    created_by            as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at            as CreatedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at       as LastChangedAt,
    @Semantics.user.localInstanceLastChangedBy: true
    local_last_changed_by as LocalLastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt
}
