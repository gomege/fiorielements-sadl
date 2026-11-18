# UX403 Exercise 09: Build a Basic Object Page with CDS Annotation

## Objective

This branch implements UX403 Exercise 09: a basic **Object Page** for the existing Sales Order List Report.

When a user selects a sales order in the List Report, the Object Page shows a header (type name and title) and a **General Information** section with the main sales order fields.

As in the previous exercises, the existing CDS view, Metadata Extension, OData service and Fiori Elements application are reused and enhanced. No new objects are created.

---

## Branch

```text
ux403-ex09-object-page
```

Parent branch:

```text
ux403-ex08-search-filter
```

The branch history is intentionally cumulative.

---

## Training Deviation

The official exercise creates a new set of objects from a template:

| Official exercise | This repository |
|---|---|
| New CDS view `ZCDS_UX403_OBJP_##` from a template file | Existing CDS view `ZCDS_UX403_SADL_00` |
| Annotations directly in the CDS view | UI annotations in the existing Metadata Extension `ZCDS_UX403_SADL_00_UI` |
| New OData service `ZCDS_UX403_OBJP_##_CDS`, registered in `/IWFND/MAINT_SERVICE` | Existing service `ZCDS_UX403_SADL_00_CDS` (already registered) |
| New Fiori Elements project (template *List Report Object Page*) | Existing Fiori Elements application in SAP Business Application Studio |

Therefore the official **Task 1, Task 2 and Task 3 are skipped**. Only Task 4 (*Add Annotations for the Object Page*) is implemented, applied to the existing objects.

```text
One CDS view · One Metadata Extension · One OData service · One Fiori Elements app
```

---

## Backend Package

```text
ZCODE_GIT_FIORIELEMENTS-SADL
```

---

## Objects Changed in Exercise 09

| Object | Type | Change |
|---|---|---|
| `ZCDS_UX403_SADL_00` | CDS Data Definition | add fields `OverallStatus` and `PaymentMethod` |
| `ZCDS_UX403_SADL_00_UI` | Metadata Extension | add `@UI.identification` and `@UI.facet` |
| `ZCDS_UX403_SADL_00_CDS` | Generated OData service | no manual change; metadata is regenerated on activation |

---

## Exercise 08 Baseline

Exercise 09 builds on the completed Exercise 08 implementation:

- List Report with line items (positions 10–60) and responsive importance
- `TaxAmount` with custom data element `ZUX403_TAX_AMOUNT` and currency semantics
- free-text search on `SalesOrderID`, `CustomerID`, `CustomerName`, `CustomerEmailAddress`
- selection fields `CustomerID` and `CreationDate`
- Customer value help through association `_CustomerVH` to `ZC_UX403CustomerVH`

### Already in place since Exercise 06

The official Task 4, steps 1 and 2, require:

| Step | Annotation | Status |
|---|---|---|
| Type name *Sales Order* | `@UI.headerInfo.typeName` | already in the Metadata Extension |
| Title = `SalesOrderID` | `@UI.headerInfo.title.value` | already in the Metadata Extension |

```abap
@UI.headerInfo: { typeName: 'Sales Order',
                  typeNamePlural: 'Sales Orders',
                  title: { type: #STANDARD, value: 'SalesOrderID' } }
```

No change is needed for these two steps.

---

# Exercise 09 Features

## Object Page Header

Provided by the existing `@UI.headerInfo` (see above):

```text
Sales Order                <- typeName
4711                       <- title.value = SalesOrderID
```

---

## Identification Fields

The Object Page shows these fields through `@UI.identification`:

| Position | Field | Status before Ex09 |
|---|---|---|
| 10 | SalesOrderID | exists |
| 20 | CustomerID | exists |
| 30 | CustomerName | exists |
| 40 | GrossAmount | exists |
| 50 | NetAmount | exists |
| 60 | OverallStatus | **new field** |
| 70 | PaymentMethod | **new field** |

---

## Facets

| Facet | Property | Value |
|---|---|---|
| Collection facet | id | `COLLFAC1` |
| | label | General Information |
| | type | `#COLLECTION` |
| | position | 10 |
| Identification reference facet | label | General Information |
| | type | `#IDENTIFICATION_REFERENCE` |
| | parentId | `COLLFAC1` |
| | position | 10 |

```text
Object Page
  └─ Section "General Information"          (#COLLECTION, id COLLFAC1)
       └─ Sub-section "General Information" (#IDENTIFICATION_REFERENCE)
            └─ all @UI.identification fields (positions 10–70)
```

---

## Annotation Placement

| Annotation | Location | Reason |
|---|---|---|
| new fields `OverallStatus`, `PaymentMethod` | CDS Data Definition | data model |
| `@UI.identification` | Metadata Extension | UI presentation |
| `@UI.facet` | Metadata Extension (on `SalesOrderID`) | UI presentation |
| `@UI.headerInfo` | Metadata Extension | unchanged since Ex06 |

`@UI.facet` describes the whole page, but it must be attached to an element. By convention it is placed on the key field `SalesOrderID`.

---

# Implementation Steps

Develop in **ADT (Eclipse)** in the SAP system. Do not edit files in `src/` by hand (see `README.md` on `main`).

## 1. Prepare the system

1. In abapGit, switch the repository to branch `ux403-ex09-object-page`.
2. Pull, so that the system has the current Exercise 08 state.
3. Check that no local changes are pending (no diff icon in abapGit).

---

## 2. Add the new fields to the CDS view

In `ZCDS_UX403_SADL_00`, add the two fields to the projection list, for example after `TaxAmount`:

```abap
      SalesOrderOverallStatus        as OverallStatus,

      SalesOrderPaymentMethod        as PaymentMethod,
```

> **Verify the source field names first.** The names `SalesOrderOverallStatus` and `SalesOrderPaymentMethod` are expected names in `SEPM_I_SalesOrder`, but they have not been checked in the system yet. Open `SEPM_I_SalesOrder` in ADT (F3) or use code completion (Ctrl+Space) and adjust the names if needed.

Activate the CDS view.

---

## 3. Add identification annotations to the Metadata Extension

In `ZCDS_UX403_SADL_00_UI`, add `@UI.identification` to each field. Keep the existing `@UI.lineItem` and `@UI.selectionField` annotations. Reuse the List Report labels for a consistent UI.

```abap
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

  @UI.lineItem:       [ { position: 40, importance: #HIGH, label: 'Gross Amount' } ]
  @UI.identification: [ { position: 40, label: 'Gross Amount' } ]
  GrossAmount;

  @UI.lineItem:       [ { position: 50, importance: #HIGH, label: 'Net Amount' } ]
  @UI.identification: [ { position: 50, label: 'Net Amount' } ]
  NetAmount;

  @UI.identification: [ { position: 60, label: 'Overall Status' } ]
  OverallStatus;

  @UI.identification: [ { position: 70, label: 'Payment Method' } ]
  PaymentMethod;
```

---

## 4. Add the facets to the Metadata Extension

Add `@UI.facet` on `SalesOrderID`:

```abap
  @UI.facet: [ { id:       'COLLFAC1',
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
```

Activate the Metadata Extension.

---

## 5. Verify the OData service

Service:

```text
ZCDS_UX403_SADL_00_CDS
```

Check `$metadata` and the entity set:

- the entity type contains `OverallStatus` and `PaymentMethod`
- the annotations contain `UI.Identification` and `UI.Facets` (look in the annotation model `ZCDS_UX403_SADL_00_CDS_VAN`)

If the old metadata is still returned, clear the metadata cache (`/IWFND/CACHE_CLEANUP` on the hub, `/IWBEP/CACHE_CLEANUP` on the backend) and reload.

---

## 6. Push the backend to GitHub

In abapGit:

1. Stage the changed objects (CDS view, Metadata Extension and any changed service files).
2. Commit, for example: `Ex09: add object page facets and identification`.
3. Push to `ux403-ex09-object-page`.

---

## 7. Validate in the Fiori Elements application

Use the existing application in SAP Business Application Studio, connected to the company sandbox through the BTP Destination and SAP Cloud Connector. Do not generate a new application.

1. Start the application and choose **Go**.
2. Select a sales order row.
3. Check the Object Page:
   - header shows *Sales Order* and the `SalesOrderID`
   - section **General Information** exists
   - fields are shown in the order 10–70, including `OverallStatus` and `PaymentMethod`

> If selecting a row does not navigate, check that the existing app was created with the *List Report Object Page* template and that `manifest.json` contains the Object Page route and target.

---

## 8. Regression-test Exercises 07 and 08

Verify that the List Report still provides:

- all existing line items, labels and responsive `TaxAmount`
- `TaxAmount` currency formatting and hidden `CurrencyCode`
- free-text search across the four searchable fields
- filter fields `CustomerID` and `CreationDate`
- Customer value help on `CustomerID`

The new fields `OverallStatus` and `PaymentMethod` should **not** appear as List Report columns, because they have no `@UI.lineItem` annotation.

---

## Architecture After Exercise 09

```text
ZCDS_UX403_SADL_00
        |
        |-- search semantics
        |-- value-help association
        |-- amount/currency semantics
        |-- business fields (+ OverallStatus, PaymentMethod)
        |
        +---- ZCDS_UX403_SADL_00_UI
        |       |
        |       |-- header (List Report + Object Page)
        |       |-- line items
        |       |-- selection fields
        |       |-- identification            <- new
        |       |-- facets                    <- new
        |       +-- visibility / importance
        |
        v
ZCDS_UX403_SADL_00_CDS
        |
        v
Fiori Elements application
  List Report  --select row-->  Object Page
```

---

## Exercise 09 Status

Planned:

- [ ] branch switched and pulled in the development system
- [ ] source field names verified in `SEPM_I_SalesOrder`
- [ ] `OverallStatus` and `PaymentMethod` added to the CDS view
- [ ] `@UI.identification` added (positions 10–70)
- [ ] `@UI.facet` added (collection + identification reference)
- [ ] CDS view and Metadata Extension activated
- [ ] `$metadata` verified
- [ ] backend pushed to GitHub with abapGit
- [ ] Object Page validated in the Fiori Elements application
- [ ] Exercises 07 and 08 regression-tested

---

## Next Exercise

After successful validation, create the next branch from:

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

---

## Source

Exercise content based on *UX403, Unit 4, Exercise 9: Build a Basic Object Page with CDS Annotation*. The course material is not part of this repository.
