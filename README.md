# UX403 Exercise 13: Visualize the List Report

## Objective

This branch implements UX403 Exercise 13: **criticality** (semantic colouring) in the List Report.

A value in the List Report is displayed in a colour (green, orange or red) that depends on a calculated criticality value. In this repository, the **Gross Amount** column is coloured by order size.

As in the previous exercises, the existing CDS view, Metadata Extension, OData service and Fiori Elements application are reused and enhanced. No new objects are created.

---

## Branch

```text
ux403-ex13-list-criticality
```

Parent branch:

```text
ux403-ex12-external-url
```

The branch history is intentionally cumulative.

---

## Training Deviation

The official exercise again creates a new set of objects from a template, and it uses a **different data model** (product stock with quantities instead of sales orders):

| Official exercise | This repository |
|---|---|
| New CDS view `ZCDS_UX403_VIS_##` from a template file (product stock) | Existing CDS view `ZCDS_UX403_SADL_00` (sales orders) |
| Field `StockLevel` coloured by `StockLevelCritical` | Field `GrossAmount` coloured by `GrossAmountCriticality` |
| Thresholds: `LotSizeQuantity` and `MinimumStockQuantity` (fields of the stock data) | Thresholds: two fixed amounts, chosen from the sales order data |
| UI annotations directly in the CDS view | UI annotations in the existing Metadata Extension `ZCDS_UX403_SADL_00_UI` |
| New OData service `ZCDS_UX403_VIS_##_CDS` and new Fiori Elements project | Existing service `ZCDS_UX403_SADL_00_CDS` and existing Fiori Elements application |

Therefore the official **Task 1, Task 2 and Task 3 are skipped**. Tasks 4 and 5 are implemented on the existing objects with the **same technique** (`case` expression → hidden criticality field → `criticality` in `@UI.lineItem`), applied to sales order amounts.

```text
One CDS view · One Metadata Extension · One OData service · One Fiori Elements app
```

---

## Backend Package

```text
ZCODE_GIT_FIORIELEMENTS-SADL
```

---

## Objects Changed in Exercise 13

| Object | Type | Change |
|---|---|---|
| `ZCDS_UX403_SADL_00` | CDS Data Definition | add calculated field `GrossAmountCriticality` |
| `ZCDS_UX403_SADL_00_UI` | Metadata Extension | `criticality` on the `GrossAmount` line item; `GrossAmountCriticality` hidden |
| `ZCDS_UX403_SADL_00_CDS` | Generated OData service | no manual change; metadata is regenerated on activation |

---

## Exercise 12 Baseline

Exercise 13 builds on the completed Exercise 12 implementation:

- List Report with line items, search, filter fields, Customer value help
- *Company Name* as link to a Google search (`SearchURL`, hidden)
- Object Page header with title and header facets **Amounts** and **Status**
- Object Page sections **General Information** and **Additional Information**

---

# Exercise 13 Features

## Criticality Values

Fiori Elements interprets a criticality value as a colour:

| Value | Meaning | Colour |
|---|---|---|
| 0 | neutral | default text colour |
| 1 | negative | red |
| 2 | critical | orange |
| 3 | positive | green |

## Calculated Field GrossAmountCriticality

A `case` expression in the CDS view calculates the criticality from the gross amount, with the same structure as the course:

```text
GrossAmount  >  upper threshold                      →  3  (green)
GrossAmount  >  lower threshold                      →  2  (orange)
otherwise                                            →  1  (red)
```

Business reading for this exercise: large orders are positive, small orders are negative.

## Criticality on the Line Item

`criticality: 'GrossAmountCriticality'` in the `@UI.lineItem` of `GrossAmount` tells Fiori Elements which field contains the colour value for this column.

## Hidden Criticality Field

`GrossAmountCriticality` is a technical field. `@UI.hidden: true` keeps it out of the UI. It is still part of the OData entity, so the column can use it.

```text
List Report row
  Gross Amount: 12,500.00 EUR   (green)
                    ▲
                    │ criticality: 'GrossAmountCriticality'
      GrossAmountCriticality = 3  (hidden)
```

---

## Annotation Placement

| Annotation / element | Location | Reason |
|---|---|---|
| `GrossAmountCriticality` (calculated field) | CDS Data Definition | data model |
| `criticality` in `@UI.lineItem` of `GrossAmount` | Metadata Extension | UI presentation |
| `@UI.hidden` on `GrossAmountCriticality` | Metadata Extension | UI presentation (same as `CurrencyCode`, `SearchURL`) |

---

# Implementation Steps

Develop in **ADT (Eclipse)** in the SAP system. Do not edit files in `src/` by hand (see `README.md` on `main`).

Remember the lesson from Ex12: **data model first** (CDS view, activate, Data Preview), **then UI** (Metadata Extension).

## 1. Prepare the system

1. In abapGit, switch the repository to branch `ux403-ex13-list-criticality`.
2. Pull, so that the system has the current Exercise 12 state.
3. Check that no local changes are pending (no diff icon in abapGit).

---

## 2. Choose the thresholds from the data

The course thresholds come from fields of the stock data. Sales orders have no such fields, so two fixed amounts are used. Choose them so that all three colours appear.

Run in the ADT SQL Console:

```sql
SELECT TransactionCurrency,
       COUNT(*)                          AS cnt,
       MIN( GrossAmountInTransacCurrency ) AS min_amount,
       MAX( GrossAmountInTransacCurrency ) AS max_amount
  FROM SEPM_I_SalesOrder
 GROUP BY TransactionCurrency
```

Pick a **lower** and an **upper** threshold that split the orders of the main currency into roughly three groups.

> The examples below use **1000** and **10000** as placeholders. Replace them with your values.

Note: the comparison ignores the currency. With several currencies this is a simplification that is acceptable for the exercise.

---

## 3. Add the criticality field to the CDS view

In `ZCDS_UX403_SADL_00`, add the new field directly after `GrossAmount`:

```abap
      GrossAmountInTransacCurrency   as GrossAmount,

      case
        when GrossAmountInTransacCurrency > 10000 then 3
        when GrossAmountInTransacCurrency > 1000  then 2
        else 1
      end                            as GrossAmountCriticality,

      NetAmountInTransactionCurrency as NetAmount,
```

> **Not yet verified in the system:** comparing the amount field directly with a number literal. If activation reports a type error, compare a converted value instead, for example `cast( GrossAmountInTransacCurrency as abap.dec(15,2) ) > 10000`.

Check (Ctrl+F2), activate (Ctrl+F3) and use the Data Preview (F8): `GrossAmountCriticality` must contain 1, 2 and 3. If one value is missing, adjust the thresholds.

---

## 4. Update the Metadata Extension

Two changes in `ZCDS_UX403_SADL_00_UI`. All other annotations stay as they are.

### 4a. Add criticality to the GrossAmount line item

Replace the complete `GrossAmount` block (keep `@UI.identification` and `@UI.fieldGroup`):

```abap
  @UI.lineItem:       [ { position:    40,
                          importance:  #HIGH,
                          label:       'Gross Amount',
                          criticality: 'GrossAmountCriticality' } ]
  @UI.identification: [ { position: 40, label: 'Gross Amount' } ]
  @UI.fieldGroup:     [ { qualifier: 'AMOUNT', position: 10, label: 'Gross Amount' } ]
  GrossAmount;
```

### 4b. Hide GrossAmountCriticality

Add directly after the `GrossAmount` block:

```abap
  @UI.hidden: true
  GrossAmountCriticality;
```

Activate the Metadata Extension.

---

## 5. Verify the OData service

Service:

```text
ZCDS_UX403_SADL_00_CDS
```

Check `$metadata` and the entity set:

- the entity type contains `GrossAmountCriticality`; the entity set returns the values 1, 2 and 3
- in the annotation model `ZCDS_UX403_SADL_00_CDS_VAN`, the `UI.LineItem` entry for `GrossAmount` contains `Criticality` with path `GrossAmountCriticality`
- `GrossAmountCriticality` carries `UI.Hidden`

If the old metadata is still returned, clear the metadata cache (`/IWFND/CACHE_CLEANUP`, `/IWBEP/CACHE_CLEANUP`) and reload.

---

## 6. Push the backend to GitHub

In abapGit:

1. Stage the changed objects (CDS view, Metadata Extension and any changed service files).
2. Commit, for example: `Ex13: add criticality to gross amount`.
3. Push to `ux403-ex13-list-criticality`.

> Commits made directly on GitHub that only change files outside `src/` (for example this README) do not require a pull in abapGit before the next push.

---

## 7. Validate in the Fiori Elements application

Use the existing application in SAP Business Application Studio. Do not generate a new application.

1. Start the application and choose **Go**.
2. The *Gross Amount* column shows values in green, orange and red, matching the thresholds.
3. Depending on the UI5 version, a status icon may also appear next to the value.
4. `GrossAmountCriticality` does not appear as a column, in the column settings or on the Object Page.
5. Refresh the browser (Ctrl+Shift+R) if nothing changes.

---

## 8. Regression-test Exercises 07 to 12

Verify that:

- all other List Report columns, search, filter fields and Customer value help are unchanged
- the *Company Name* link to Google still works
- the Object Page header facets and both sections are unchanged

---

## Bonus Exercise: Colour the Amount in the Object Page Header

*Small extra task, not part of the official course.*

### Task

After Ex13 the gross amount is coloured in the List Report, but not on the Object Page. Make **Gross Amount in the header facet *Amounts*** show the same colour as in the List Report.

### Hints

- Which annotation feeds the header facet *Amounts*? (See Ex10.)
- The property you used in `@UI.lineItem` in this exercise also exists in that annotation.
- No CDS view change is needed: the criticality value already exists.
- Is the colour also shown in the section *Additional Information*? Why?

### Expected Result

- In the Object Page header, *Gross Amount* is shown in the same colour as in the List Report row.
- The List Report is unchanged.

---

## Architecture After Exercise 13

```text
ZCDS_UX403_SADL_00
        |
        |-- search semantics
        |-- value-help association
        |-- amount/currency semantics
        |-- business and status fields
        |-- SearchURL (concat)
        |-- GrossAmountCriticality (case)            <- new
        |
        +---- ZCDS_UX403_SADL_00_UI
        |       |
        |       |-- header info
        |       |-- line items
        |       |     |-- CustomerName #WITH_URL
        |       |     +-- GrossAmount criticality     <- new
        |       |-- selection fields
        |       |-- identification / field groups
        |       |-- facets (header + 2 sections)
        |       +-- hidden: CurrencyCode, SearchURL, GrossAmountCriticality   <- new
        |
        v
ZCDS_UX403_SADL_00_CDS
        |
        v
Fiori Elements application
  List Report (coloured Gross Amount)  --select row-->  Object Page
```

---

## Exercise 13 Status

Planned:

- [ ] branch switched and pulled in the development system
- [ ] thresholds chosen from the sales order data
- [ ] `GrossAmountCriticality` added to the CDS view (values 1, 2, 3 in Data Preview)
- [ ] `criticality` added to the `GrossAmount` line item
- [ ] `GrossAmountCriticality` hidden
- [ ] CDS view and Metadata Extension activated
- [ ] backend pushed to GitHub with abapGit
- [ ] colours validated in the Fiori Elements application
- [ ] Exercises 07 to 12 regression-tested

Bonus exercise:

- [ ] Gross Amount coloured in the Object Page header

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
                                     |
                                     +-- ux403-ex11-body-facets
                                            |
                                            +-- ux403-ex12-external-url
                                                   |
                                                   +-- ux403-ex13-list-criticality
```

Each exercise branch represents the cumulative application state at that stage of the UX403 training.

---

## Source

Exercise content based on *UX403, Unit 5, Exercise 13: Visualize the List Report*. The course material is not part of this repository.
