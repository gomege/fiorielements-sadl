@AbapCatalog.sqlViewName: 'ZCDSUX403SADL'

@EndUserText.label: 'UX403 Generate OData Service by SADL'

@Metadata.allowExtensions: true

@OData.publish: true

@Search.searchable: true

define view ZCDS_UX403_SADL_00
  as select from SEPM_I_SalesOrder

{
      @Search.defaultSearchElement: true
  key SalesOrder                     as SalesOrderID,

      @Search.defaultSearchElement: true
      _Customer.BusinessPartner      as CustomerID,

      _Customer.CompanyName          as CustomerName,

      GrossAmountInTransacCurrency   as GrossAmount,

      NetAmountInTransactionCurrency as NetAmount,

      @UI.hidden: true
      TransactionCurrency            as CurrencyCode,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      cast(
             GrossAmountInTransacCurrency
             - NetAmountInTransactionCurrency
             as zux403_tax_amount
      )                              as TaxAmount
}
