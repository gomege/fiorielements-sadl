@AbapCatalog.sqlViewName: 'ZCDSUX403SADL'

@EndUserText.label: 'UX403 Generate OData Service by SADL'

@Metadata.allowExtensions: true

@OData.publish: true

@Search.searchable: true

define view ZCDS_UX403_SADL_00
  as select from SEPM_I_SalesOrder

  association [1..1] to C_UX403CustomerVH as _CustomerVH on $projection.CustomerID = _CustomerVH.CustomerID

{
      @Search.defaultSearchElement: true
  key SalesOrder                     as SalesOrderID,

      @Search.defaultSearchElement: true
      @Consumption.valueHelp: '_CustomerVH'
      _Customer.BusinessPartner      as CustomerID,

      @Search.defaultSearchElement: true
      _Customer.CompanyName          as CustomerName,

      _Customer.URL                  as CustomerURL,

      @Search.defaultSearchElement: true
      _Customer.EmailAddress         as CustomerEmailAddress,

      cast(
        left(
          cast(CreationDateTime as abap.char(30)),
          8
        ) as abap.dats
      )                              as CreationDate,

      GrossAmountInTransacCurrency   as GrossAmount,

      NetAmountInTransactionCurrency as NetAmount,

      TransactionCurrency            as CurrencyCode,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      cast(
        GrossAmountInTransacCurrency
        - NetAmountInTransactionCurrency
        as zux403_tax_amount
      )                              as TaxAmount,

      _CustomerVH
}
