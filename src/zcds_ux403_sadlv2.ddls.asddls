@AbapCatalog.sqlViewName: 'ZCDSUX403SADL'
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'UX403 Generate OData Service by SADL'
@OData.publish: true
define view ZCDS_UX403_SADL_00
  as select from SEPM_I_SalesOrder
{
    @Search.defaultSearchElement: true
    key SalesOrder as SalesOrderID,

    @Search.defaultSearchElement: true
    _Customer.BusinessPartner as CustomerID,

    _Customer.CompanyName as CustomerName,

    GrossAmountInTransacCurrency as GrossAmount
}
