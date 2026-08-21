# UX403 Exercise 07: Basic List Report

## Objective

This branch implements the concepts of UX403 Exercise 07.

Unlike the standard UX403 training approach, the existing CDS view, OData service and Fiori Elements application are reused and enhanced incrementally.

The Metadata Extension created in Exercise 06 remains part of the solution and continues to be the preferred location for UI annotations.

---

## Branch

```text
ux403-ex07-basic-list-report
```

Parent branch:

```text
ux403-ex06-metadata-extention
```

---

## Training Deviation

Official UX403 creates a new CDS view and a new Fiori Elements application.

This repository follows a different strategy:

```text
One CDS view
One Metadata Extension
One OData service
One Fiori Elements application
```

Each exercise builds on the previous one.

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
- provide calculated TaxAmount
- provide OData service generation
- expose currency information

### Metadata Extension

```text
ZCDS_UX403_SADL_00_UI
```

Responsibilities:

- header configuration
- line item configuration
- column ordering
- field importance
- responsive behavior

### Generated OData Service

```text
ZCDS_UX403_SADL_00_CDS
```

---

## Exercise 07 Features

### List Report Header

```abap
@UI.headerInfo.typeNamePlural: 'Sales Orders'
```

Expected result:

```text
Sales Orders
```

appears as the report title.

### List Report Columns

The following columns are displayed:

| Position | Field |
|-----------|-----------|
| 10 | SalesOrderID |
| 20 | CustomerID |
| 30 | CustomerName |
| 40 | GrossAmount |
| 50 | NetAmount |
| 60 | TaxAmount |

---

## TaxAmount Learning Objective

Exercise 07 intentionally exposes several issues.

### Initial Problems

TaxAmount:

- shows technical field name
- has no currency code
- exposes Currency field in table settings
- remains visible on small screens

Reason:

TaxAmount is a calculated CDS field and therefore lacks the metadata inherited from the original database field.

---

## Exercise 07 Corrections

### Custom Data Element

```text
ZUX403_TAX_AMOUNT
```

Used to provide:

```text
Medium Label:
Tax Amount
```

### Currency Semantics

TaxAmount should be linked to CurrencyCode using semantic annotations.

Expected result:

```text
123.45 EUR
```

instead of

```text
123.45
```

### Hidden Currency Field

CurrencyCode remains available for formatting purposes but should not be selectable as an independent table column.

### Responsive Importance

```abap
importance: #LOW
```

Expected behavior:

- desktop -> visible
- medium screens -> hidden automatically
- small screens -> hidden automatically

---

## Validation

Completed:

- List Report header created
- List Report columns defined
- Metadata Extension remains active
- Existing OData service reused
- Existing Fiori Elements application reused

Pending:

- TaxAmount data element
- currency semantics
- hidden currency field
- responsive importance

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

The branch history is intentionally cumulative.

---

## Next Exercise

```text
Exercise 08
Search and Filtering
```

will enhance the same CDS view, Metadata Extension and Fiori Elements application.