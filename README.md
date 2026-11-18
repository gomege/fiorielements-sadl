# UX403 Exercise 10: Add Header Facets

## Objective

This branch implements UX403 Exercise 10: **header facets** on the Object Page of the existing Sales Order application.

Two groups of fields are added to the Object Page header area:

- **Amounts**: Gross Amount and Net Amount
- **Status**: Overall, Billing, Delivery and Life Cycle Status

As in the previous exercises, the existing CDS view, Metadata Extension, OData service and Fiori Elements application are reused and enhanced. No new objects are created.

---

## Branch

```text
ux403-ex10-header-facets
```

Parent branch:

```text
ux403-ex09-object-page
```

The branch history is intentionally cumulative.

---

## Training Deviation

The official exercise again creates a new set of objects from a template:

| Official exercise | This repository |
|---|---|
| New CDS view `ZCDS_UX403_HDFT_##` from a template file | Existing CDS view `ZCDS_UX403_SADL_00` |
| Annotations directly in the CDS view | UI annotations in the existing Metadata Extension `ZCDS_UX403_SADL_00_UI` |
| New OData service `ZCDS_UX403_HDFT_##_CDS`, registered in `/IWFND/MAINT_SERVICE` | Existing service `ZCDS_UX403_SADL_00_CDS` (already registered) |
| New Fiori Elements project (template *List Report Object Page*) | Existing Fiori Elements application in SAP Business Application Studio |

Therefore the official **Task 1, Task 2 and Task 3 are skipped**. Tasks 4, 5 and 6 are implemented on the existing objects.

```text
One CDS view · One Metadata Extension · One OData service · One Fiori Elements app
```

---

## Backend Package

```text
ZCODE_GIT_FIORIELEMENTS-SADL
```

---

## Objects Changed in Exercise 10

| Object | Type | Change |
|---|---|---|
| `ZCDS_UX403_SADL_00` | CDS Data Definition | add fields `BillingStatus`, `DeliveryStatus`, `LifeCycleStatus` |
| `ZCDS_UX403_SADL_00_UI` | Metadata Extension | add `@UI.fieldGroup` (AMOUNT, STATUS) and two header facets in `@UI.facet` |
| `ZCDS_UX403_SADL_00_CDS` | Generated OData service | no manual change; metadata is regenerated on activation |

---

## Exercise 09 Baseline

Exercise 10 builds on the completed Exercise 09 implementation:

- List Report with line items, responsive `TaxAmount` (line-item position 80)
- free-text search, filter fields `CustomerID` and `CreationDate`, Customer value help
- Object Page header from `@UI.headerInfo` (type name *Sales Order*, title `SalesOrderID`)
- Object Page section **General Information** (`COLLFAC1` + identification reference) with fields at positions 10–70
- fields `OverallStatus` and `PaymentMethod` (`PaymentMethod` has no data in the demo system)

### Already in place

| Required by Ex10 | Status |
|---|---|
| `GrossAmount`, `NetAmount` | exist since Ex05/Ex07 |
| `OverallStatus` | exists since Ex09 |
| `BillingStatus`, `DeliveryStatus`, `LifeCycleStatus` | **new fields** |

---

# Exercise 10 Features

## Field Groups

A field group is a named set of fields. The name is the **qualifier**. A field can belong to several field groups and still keep its `@UI.lineItem` and `@UI.identification` annotations.

### AMOUNT

| Position | Field |
|---|---|
| 10 | GrossAmount |
| 20 | NetAmount |

### STATUS

| Position | Field |
|---|---|
| 10 | OverallStatus |
| 20 | BillingStatus |
| 30 | DeliveryStatus |
| 40 | LifeCycleStatus |

---

## Header Facets

| Header facet | Position | Target |
|---|---|---|
| Amounts | 10 | field group `AMOUNT` |
| Status | 20 | field group `STATUS` |

A facet is placed in the header with `purpose: #HEADER`. It shows a field group with `type: #FIELDGROUP_REFERENCE` and `targetQualifier: '<qualifier>'`.

```text
Object Page
  ├─ Header
  │    ├─ title: Sales Order <SalesOrderID>      (@UI.headerInfo, since Ex06)
  │    ├─ Amounts   (#HEADER, #FIELDGROUP_REFERENCE → AMOUNT)   <- new
  │    └─ Status    (#HEADER, #FIELDGROUP_REFERENCE → STATUS)   <- new
  └─ Section "General Information"               (since Ex09)
       └─ identification fields 10–70
```

---

## Annotation Placement

| Annotation | Location | Reason |
|---|---|---|
| new status fields | CDS Data Definition | data model |
| `@UI.fieldGroup` | Metadata Extension | UI presentation |
| header facets in `@UI.facet` | Metadata Extension (on `SalesOrderID`) | UI presentation; extends the existing facet list |

There is only **one** `@UI.facet` annotation. The new header facets are added as further entries to the existing list from Ex09.

---

# Implementation Steps

Develop in **ADT (Eclipse)** in the SAP system. Do not edit files in `src/` by hand (see `README.md` on `main`).

## 1. Prepare the system

1. In abapGit, switch the repository to branch `ux403-ex10-header-facets`.
2. Pull, so that the system has the current Exercise 09 state.
3. Check that no local changes are pending (no diff icon in abapGit).

---

## 2. Add the new status fields to the CDS view

In `ZCDS_UX403_SADL_00`, add the three fields after `OverallStatus`:

```abap
      SalesOrderOverallStatus        as OverallStatus,

      SalesOrderBillingStatus        as BillingStatus,

      SalesOrderDeliveryStatus       as DeliveryStatus,

      SalesOrderLifeCycleStatus      as LifeCycleStatus,

      SalesOrderPaymentMethod        as PaymentMethod,

      _CustomerVH
}
```

> **Verify the source field names first.** `SalesOrderBillingStatus`, `SalesOrderDeliveryStatus` and `SalesOrderLifeCycleStatus` are the expected names in `SEPM_I_SalesOrder` (same pattern as `SalesOrderOverallStatus`), but they have not been checked in the system yet. Use code completion (Ctrl+Space) and adjust if needed.

Check (Ctrl+F2), activate (Ctrl+F3) and use the Data Preview (F8) to see whether the status fields contain data.

---

## 3. Update the Metadata Extension

Below is the **complete** target source of `ZCDS_UX403_SADL_00_UI`. It keeps every annotation from Ex06–Ex09 and adds:

- two header facets in `@UI.facet`
- `@UI.fieldGroup` for `AMOUNT` and `STATUS`
- the three new status fields

```abap
@Metadata.layer: #CORE

@UI.headerInfo: { typeName: 'Sales Order',
                  typeNamePlural: 'Sales Orders',
                  title: { type: #STANDARD, value: 'SalesOrderID' } }

annotate view ZCDS_UX403_SADL_00 with

{
  @UI.facet: [ /* Ex10: header facets */
               { purpose:         #HEADER,
                 type:            #FIELDGROUP_REFERENCE,
                 targetQualifier: 'AMOUNT',
                 label:           'Amounts',
                 position:        10 },
               { purpose:         #HEADER,
                 type:            #FIELDGROUP_REFERENCE,
                 targetQualifier: 'STATUS',
                 label:           'Status',
                 position:        20 },
               /* Ex09: content section */
               { id:       'COLLFAC1',
                 type:     #COLLECTION,
                 label:    'General Information',
                 position: 10 },
               { type:     #IDENTIFICATION_REFERENCE,
                 label:    'General Information',
                 parentId: 'COLLFAC1',
                 position: 10 } ]
  @UI.lineItem:       [ { position: 10, importance: #HIGH, label: 'Sales Order ID' } ]
  @UI.identification: [ { position: 10, label: 'Sales Order ID' } ]
  SalesOrderID;

  @UI.lineItem:       [ { position: 20, importance: #HIGH, label: 'BP ID' } ]
  @UI.selectionField: [ { position: 10 } ]
  @UI.identification: [ { position: 20, label: 'BP ID' } ]
  CustomerID;

  @UI.lineItem:       [ { position: 30, importance: #HIGH, label: 'Company Name' } ]
  @UI.identification: [ { position: 30, label: 'Company Name' } ]
  CustomerName;

  @UI.selectionField: [ { position: 20 } ]    // keep: Ex08 filter field
  CreationDate;

  @UI.lineItem:       [ { position: 40, importance: #HIGH, label: 'Gross Amount' } ]
  @UI.identification: [ { position: 40, label: 'Gross Amount' } ]
  @UI.fieldGroup:     [ { qualifier: 'AMOUNT', position: 10, label: 'Gross Amount' } ]
  GrossAmount;

  @UI.lineItem:       [ { position: 50, importance: #HIGH, label: 'Net Amount' } ]
  @UI.identification: [ { position: 50, label: 'Net Amount' } ]
  @UI.fieldGroup:     [ { qualifier: 'AMOUNT', position: 20, label: 'Net Amount' } ]
  NetAmount;

  @UI.identification: [ { position: 60, label: 'Overall Status' } ]
  @UI.fieldGroup:     [ { qualifier: 'STATUS', position: 10, label: 'Overall Status' } ]
  OverallStatus;

  @UI.fieldGroup:     [ { qualifier: 'STATUS', position: 20, label: 'Billing Status' } ]
  BillingStatus;

  @UI.fieldGroup:     [ { qualifier: 'STATUS', position: 30, label: 'Delivery Status' } ]
  DeliveryStatus;

  @UI.fieldGroup:     [ { qualifier: 'STATUS', position: 40, label: 'Life Cycle Status' } ]
  LifeCycleStatus;

  @UI.identification: [ { position: 70, label: 'Payment Method' } ]
  PaymentMethod;

  @UI.hidden: true
  CurrencyCode;

  @UI.lineItem:       [ { position: 80, importance: #LOW, label: 'Tax Amount' } ]
  TaxAmount;
}
```

Notes:

- Header facet positions (10, 20) and content facet positions (10) are separate: `purpose: #HEADER` facets are ordered among themselves.
- The `label` of a header facet is the heading shown above the field group in the header.
- If the `/* */` comments inside the annotation array cause a syntax error, remove them.

Activate the Metadata Extension.

---

## 4. Verify the OData service

Service:

```text
ZCDS_UX403_SADL_00_CDS
```

Check `$metadata` and the annotation model `ZCDS_UX403_SADL_00_CDS_VAN`:

- the entity type contains `BillingStatus`, `DeliveryStatus` and `LifeCycleStatus`
- `UI.FieldGroup#AMOUNT` and `UI.FieldGroup#STATUS` exist
- `UI.HeaderFacets` contains two `UI.ReferenceFacet` entries

If the old metadata is still returned, clear the metadata cache (`/IWFND/CACHE_CLEANUP`, `/IWBEP/CACHE_CLEANUP`) and reload.

---

## 5. Push the backend to GitHub

In abapGit:

1. Stage the changed objects (CDS view, Metadata Extension and any changed service files).
2. Commit, for example: `Ex10: add field groups and header facets`.
3. Push to `ux403-ex10-header-facets`.

> Commits made directly on GitHub that only change files outside `src/` (for example this README) do not require a pull in abapGit before the next push.

---

## 6. Validate in the Fiori Elements application

Use the existing application in SAP Business Application Studio. Do not generate a new application.

1. Start the application and choose **Go**.
2. Select a sales order row.
3. Check the Object Page header:
   - title *Sales Order* and `SalesOrderID` as before
   - header facet **Amounts** with Gross Amount and Net Amount (with currency)
   - header facet **Status** with Overall, Billing, Delivery and Life Cycle Status, in this order
4. Refresh the browser (Ctrl+Shift+R) if the header does not change.

---

## 7. Regression-test Exercises 07 to 09

Verify that:

- the List Report columns are unchanged; the new status fields do **not** appear as columns
- search, filter fields `CustomerID` and `CreationDate`, and the Customer value help still work
- the Object Page section **General Information** still shows the fields 10–70
- the new status fields do **not** appear in *General Information* (they have no `@UI.identification`)

---

## Architecture After Exercise 10

```text
ZCDS_UX403_SADL_00
        |
        |-- search semantics
        |-- value-help association
        |-- amount/currency semantics
        |-- business fields (+ Billing/Delivery/LifeCycle status)
        |
        +---- ZCDS_UX403_SADL_00_UI
        |       |
        |       |-- header info
        |       |-- line items / selection fields
        |       |-- identification
        |       |-- field groups AMOUNT, STATUS   <- new
        |       |-- facets
        |       |     |-- header facets           <- new
        |       |     +-- General Information
        |       +-- visibility / importance
        |
        v
ZCDS_UX403_SADL_00_CDS
        |
        v
Fiori Elements application
  List Report  --select row-->  Object Page (header facets + sections)
```

---

## Exercise 10 Status

Planned:

- [ ] branch switched and pulled in the development system
- [ ] source field names verified in `SEPM_I_SalesOrder`
- [ ] `BillingStatus`, `DeliveryStatus`, `LifeCycleStatus` added to the CDS view
- [ ] `@UI.fieldGroup` AMOUNT and STATUS added
- [ ] header facets added to `@UI.facet`
- [ ] CDS view and Metadata Extension activated
- [ ] backend pushed to GitHub with abapGit
- [ ] header facets validated in the Fiori Elements application
- [ ] Exercises 07 to 09 regression-tested

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
                              |
                              +-- ux403-ex10-header-facets
```

Each exercise branch represents the cumulative application state at that stage of the UX403 training.

---

## Source

Exercise content based on *UX403, Unit 4, Exercise 10: Add Header Facets*. The course material is not part of this repository.
