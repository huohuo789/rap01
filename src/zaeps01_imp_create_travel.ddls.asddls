@EndUserText.label: 'Parameter Import Create Travel'
define abstract entity ZAEPS01_IMP_CREATE_TRAVEL
{
    TravelID : abap.numc(8);
    AgencyID : abap.numc(6);
    CustomerID : abap.numc(6);
    BeginDate : dats;
    EndDate : dats;
    CurrencyCode : abap.cuky;
    BookingFee : abap.dec(17,2);
    TotalPrice : abap.dec(17,2);
    Description : abap.char(255);
    
}
