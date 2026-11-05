# UX403 Exercise 08: Search and Filtering

## Objective

This branch implements the backend concepts of UX403 Exercise 08: Search and Filtering.

Unlike the standard UX403 training approach, the existing CDS view, Metadata Extension, OData service and Fiori Elements application are reused and enhanced incrementally.

The Metadata Extension created in Exercise 06 remains part of the solution and is the preferred location for UI presentation annotations.

---

## Branch

```text
ux403-ex08-search-filter
```

Parent branch:

```text
ux403-ex07-basic-list-report
```

The branch history is intentionally cumulative.

---

## Training Deviation

Official UX403 exercises typically introduce new CDS views and may create new Fiori Elements applications for individual exercises.

This repository follows a different strategy:

```text
One evolving CDS view
One Metadata Extension
One OData service
One Fiori Elements application
```

Each exercise builds on the previous exercise.

The goal is to observe how an existing application evolves as CDS and UI annotations are added incrementally.

---

## Backend Package

```text
ZCODE_GIT_FIORIELEMENTS-SADL
```

---

## Active Backend Objects

### CDS Data Definition

```text
ZCDS_UX403_SADL_00
```

Responsibilities:

- expose sales order data
- define searchable fields
- expose fields used for structured filtering
- provide Customer value help
- provide calculated TaxAmount
- define amount/currency semantics
- expose the CDS view through the existing OData service

### Metadata Extension

```text
ZCDS_UX403_SADL_00_UI
```

Responsibilities:

- List Report header configuration
- line item configuration
- column ordering
- field importance
- responsive behavior
- selection fields
- UI visibility

### Generated OData Service

```text
ZCDS_UX403_SADL_00_CDS
```

The existing service continues to be reused.

No additional OData service is created for Exercise 08.

---

## Exercise 07 Baseline

Exercise 08 builds on the completed Exercise 07 implementation.

The List Report contains:

| Position | Field | Importance |
|---|---|---|
| 10 | SalesOrderID | HIGH |
| 20 | CustomerID | HIGH |
| 30 | CustomerName | HIGH |
| 40 | GrossAmount | HIGH |
| 50 | NetAmount | HIGH |
| 60 | TaxAmount | LOW |

Exercise 07 also introduced:

- custom data element `ZUX403_TAX_AMOUNT`
- TaxAmount currency semantics
- hidden standalone CurrencyCode field
- responsive `#LOW` importance for TaxAmount

These features remain part of the cumulative application.

---

# Exercise 08 Features

## Search Support

The CDS view is enabled for search:

```abap
@Search.searchable: true
```

Multiple properties participate in the free-text search using:

```abap
@Search.defaultSearchElement: true
```

The searchable properties are:

```text
SalesOrderID
CustomerID
CustomerName
CustomerEmailAddress
```

This allows the Fiori Elements List Report search field to perform free-text searches across multiple backend properties.

---

## Additional CDS Fields

Exercise 08 extends the existing CDS view with additional information required by the searching and filtering scenario:

```text
CustomerURL
CustomerEmailAddress
CreationDate
```

`CreationDate` is derived from the sales order creation timestamp and exposed as an ABAP date.

The existing Exercise 07 fields remain unchanged.

---

## Structured Filtering

Exercise 08 introduces structured filter fields using UI selection-field annotations.

The filter fields are:

| Position | Field |
|---|---|
| 10 | CustomerID |
| 20 | CreationDate |

These annotations are maintained in the existing Metadata Extension.

This maintains the separation between:

```text
CDS model / semantics
        +
Metadata Extension / UI presentation
```

---

## Customer Value Help

CustomerID receives a value help based on:

```text
C_UX403CustomerVH
```

The CDS contains an association:

```abap
association [1..1] to C_UX403CustomerVH as _CustomerVH
```

connected through the projected `CustomerID`.

The value help is assigned using:

```abap
@Consumption.valueHelp: '_CustomerVH'
```

The association is exposed by the CDS so that the generated OData metadata can represent the value-help relationship.

### Annotation Placement

`@Consumption.valueHelp` remains in the CDS Data Definition.

It is intentionally not maintained in the Metadata Extension because this SAP system does not permit `Consumption.valueHelp` in metadata extensions.

UI-specific annotations such as:

```text
@UI.selectionField
@UI.lineItem
@UI.hidden
@UI.headerInfo
```

remain in the Metadata Extension where applicable.

---

## Search vs. Filter

Exercise 08 demonstrates two related but distinct mechanisms.

### Free-Text Search

```text
Fiori Elements Search
        |
        v
@Search.searchable
        |
        v
@Search.defaultSearchElement
        |
        v
multiple CDS properties
```

### Structured Filtering

```text
Fiori Elements Filter Bar
        |
        v
@UI.selectionField
        |
        +--> CustomerID
        |      |
        |      v
        |   Value Help
        |
        +--> CreationDate
```

The distinction is important: search operates across selected searchable properties whereas selection fields expose specific properties as structured filter criteria.

---

## Architecture After Exercise 08

```text
ZCDS_UX403_SADL_00
        |
        |-- search semantics
        |-- value-help association
        |-- amount/currency semantics
        |-- business fields
        |
        +---- ZCDS_UX403_SADL_00_UI
        |       |
        |       |-- header
        |       |-- line items
        |       |-- selection fields
        |       |-- visibility
        |       +-- responsive importance
        |
        v
ZCDS_UX403_SADL_00_CDS
        |
        v
Fiori Elements application
```

---

## Exercise 08 Backend Status

Completed:

- existing CDS reused
- existing Metadata Extension reused
- existing OData service reused
- `@Search.searchable` enabled
- default search elements configured
- CustomerURL exposed
- CustomerEmailAddress exposed
- CreationDate exposed
- CustomerID selection field configured
- CreationDate selection field configured
- Customer value-help association added
- `@Consumption.valueHelp` configured in the CDS
- CDS activated
- Metadata Extension activated
- backend changes committed and pushed to GitHub

No new Fiori Elements project was created.

---

## UI Validation Status

Backend implementation is complete.

Fiori Elements validation is intentionally deferred to the company sandbox environment, where the required connectivity infrastructure already exists.

The target environment provides:

```text
Company SAP Sandbox
        |
        v
OData Service
        |
        v
SAP Cloud Connector
        |
        v
BTP Destination
        |
        v
SAP Business Application Studio
        |
        v
existing Fiori Elements application
```

The IDES system was used for backend implementation and OData verification.

The company sandbox will be used for integrated Fiori Elements validation.

---

# Next Steps

## 1. Import Exercise 08 into the company sandbox

Using abapGit, fetch and switch to:

```text
ux403-ex08-search-filter
```

Import the Exercise 08 backend state into the sandbox system.

Verify that the relevant CDS, Metadata Extension and service-related objects are active after the import.

---

## 2. Verify OData in the sandbox

Before testing Fiori Elements, verify the service directly.

Service:

```text
ZCDS_UX403_SADL_00_CDS
```

Check:

```text
$metadata
```

and the entity set.

Verify in particular that the generated metadata contains the new Exercise 08 search, filtering and value-help metadata.

---

## 3. Connect the existing Fiori Elements application

Reuse the existing application in SAP Business Application Studio.

Do not generate another Fiori Elements application unless required for troubleshooting.

Use the existing BTP Destination and SAP Cloud Connector connection to access the sandbox OData service.

---

## 4. Validate Free-Text Search

Verify that the List Report search field searches the intended properties:

```text
SalesOrderID
CustomerID
CustomerName
CustomerEmailAddress
```

Test with known values from the sandbox data.

---

## 5. Validate Structured Filtering

Verify that the filter bar provides:

```text
CustomerID
CreationDate
```

Confirm that filters are transferred correctly to the OData service and restrict the List Report results.

---

## 6. Validate Customer Value Help

Open the value help for:

```text
CustomerID
```

Confirm that the value help is provided through:

```text
C_UX403CustomerVH
```

and that selecting a CustomerID correctly filters the List Report.

---

## 7. Regression-Test Exercise 07

Exercise 08 must not regress the cumulative Exercise 07 functionality.

Verify that the List Report still provides:

- Sales Order header
- existing line items
- GrossAmount and NetAmount
- TaxAmount
- TaxAmount currency formatting
- hidden standalone CurrencyCode
- responsive TaxAmount behavior

---

## 8. Complete Exercise 08

Exercise 08 should only be considered fully validated after the backend imported from this branch has been tested using the existing Fiori Elements application in the company sandbox.

If validation succeeds, continue with:

```text
Exercise 09
Object Page
```

Create the next branch from:

```text
ux403-ex08-search-filter
```

not from `main`.

Expected branch:

```text
ux403-ex09-object-page
```

---

## Repository Strategy

```text
main
  |
  +-- ux403-ex06-metadata-extention
         |
         +-- ux403-ex07-basic-list-report
                |
                +-- ux403-ex08-search-filter
                       |
                       +-- ux403-ex09-object-page
```

Each exercise branch represents the cumulative application state at that stage of the UX403 training.

The repository therefore acts both as source control and as a reproducible history of the incremental Fiori Elements application development.