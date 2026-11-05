# UX403 Exercise 06: CDS Metadata Extension

## Objective

This branch implements the concepts of UX403 Exercise 06.

The goal is to separate the Fiori Elements UI annotations from the CDS data definition by moving them into a **CDS metadata extension**.

The application continues to use the SADL-generated OData service created in Exercise 05.

For the general project setup (abapGit workflow, system landscape, branch model), see the `README.md` on `main`.

---

## Branch

```text
ux403-ex06-metadata-extention
```

Parent branch:

```text
main  (Exercise 05 baseline)
```

> The typo in the branch name ("extention") is intentional and is kept. Renaming the branch would break the abapGit links in the connected SAP systems.

---

## Backend Package

```text
ZCODE_GIT_FIORIELEMENTS-SADL
```

---

## Changes in this exercise

### CDS Data Definition: `ZCDS_UX403_SADL_00`

All `@UI` annotations were removed from the CDS view. It now only contains the data model and the non-UI annotations:

- `@Metadata.allowExtensions: true`: allows a metadata extension
- `@Search.searchable: true` and `@Search.defaultSearchElement` on `SalesOrderID` and `CustomerID`
- `@OData.publish: true`: SADL-generated OData service

Exposed fields (unchanged from Exercise 05):

```text
SalesOrderID, CustomerID, CustomerName, GrossAmount
```

### Metadata Extension: `ZCDS_UX403_SADL_00_UI` (new)

```abap
@Metadata.layer: #CORE
annotate view ZCDS_UX403_SADL_00 with
```

Responsibilities:

- header information (`typeName: 'Sales Order'`, `typeNamePlural: 'Sales Orders'`, title `SalesOrderID`)
- line items with position, importance and label

| Position | Field | Label | Importance |
|---|---|---|---|
| 10 | SalesOrderID | Sales Order ID | HIGH |
| 20 | CustomerID | BP ID | HIGH |
| 30 | CustomerName | Company Name | HIGH |
| 40 | GrossAmount | Gross Amount | HIGH |

Compared with Exercise 05, the header texts now contain spaces ("Sales Order" instead of "SalesOrder") and the columns have explicit labels.

### OData Service: `ZCDS_UX403_SADL_00_CDS`

The service is reused. In addition to the service objects from Exercise 05, abapGit now also serializes the service registration objects (`.iwsg`, `.iwom`).

---

## Design rule introduced here

From this exercise on:

```text
@UI.*                       ->  Metadata Extension  (ZCDS_UX403_SADL_00_UI)
data model, @Search, @OData,
semantics, value help       ->  CDS view            (ZCDS_UX403_SADL_00)
```

---

## Validation

Completed:

- Metadata Extension created and activated
- UI annotations removed from the CDS view
- CDS view activated
- List Report shows header and columns from the Metadata Extension
- Existing OData service reused

---

## Next Exercise

```text
Exercise 07
Basic List Report
```

Branch `ux403-ex07-basic-list-report` builds on this branch.
