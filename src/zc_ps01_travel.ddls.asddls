@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel - Projection View'
@Metadata.allowExtensions: true
define root view entity ZC_PS01_TRAVEL 
    provider contract transactional_query as 
    projection on ZI_PS01_Travel
{
    key Traveluuid,
    Travelid,
    Agencyid,
    Customerid,
    Begindate,
    Enddate,
    Bookingfee,
    Totalprice,
    Currencycode,
    Status,
    Description,
    CreatedBy,
    CreatedAt,
    LastChangedAt,
    LocalLastChangedBy,
    LocalLastChangedAt
}
