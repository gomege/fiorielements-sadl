# UX403 Exercise 11: Add Sections and Facets to the Object Page

## Objective

This branch implements UX403 Exercise 11: **sections in the body area** of the Object Page of the existing Sales Order application.

The body of the Object Page is organised in two sections:

- **General Information**: the identification fields (exists since Ex09)
- **Additional Information**: the field groups AMOUNT and STATUS (**new**)

As in the previous exercises, the existing CDS view, Metadata Extension, OData service and Fiori Elements application are reused and enhanced. No new objects are created.

---

## Branch

```text
ux403-ex11-body-facets
```

Parent branch:

```text
ux403-ex10-header-facets
```

The branch history is intentionally cumulative.

---

## Training Deviation

The official exercise again creates a new set of objects from a template:

| Official exercise | This repository |
|---|---|
| New CDS view `ZCDS_UX403_BDFT_##` from a template file (with identification and two field groups) | Existing CDS view `ZCDS_UX403_SADL_00` |
| Annotations directly in the CDS view | UI annotations in the existing Metadata Extension `ZCDS_UX403_SADL_00_UI` |
| New OData service `ZCDS_UX403_BDFT_##_CDS`, registered in `/IWFND/MAINT_SERVICE` | Existing service `ZCDS_UX403_SADL_00_CDS` (already registered) |
| New Fiori Elements project (template *List Report Object Page*) | Existing Fiori Elements application in SAP Business Application Studio |

Therefore the official **Task 1, Task 2 and Task 3 are skipped**. Tasks 4, 5 and 6 are implemented on the existing objects.

The official template has no header facets. In this repository the **header facets from Ex10 are kept**, so the AMOUNT and STATUS field groups appear both in the header and in the body (see *Design Note*).

```text
One CDS view · One Metadata Extension · One OData service · One Fiori Elements app
```

---

## Backend Package

```text
ZCODE_GIT_FIORIELEMENTS-SADL
```

---

## Objects Changed in Exercise 11

| Object | Type | Change |
|---|---|---|
| `ZCDS_UX403_SADL_00` | CDS Data Definition | **no change** |
| `ZCDS_UX403_SADL_00_UI` | Metadata Extension | add collection facet `COLLFAC2` and two field-group reference facets to `@UI.facet` |
| `ZCDS_UX403_SADL_00_CDS` | Generated OData service | no manual change; annotations are regenerated on activation |

---

## Exercise 10 Baseline

Exercise 11 builds on the completed Exercise 10 implementation:

- List Report with line items, search, filter fields and Customer value help
- Object Page header: title from `@UI.headerInfo`, header facets **Amounts** and **Status**
- Object Page body: section **General Information** (`COLLFAC1` + identification reference)
- field groups `AMOUNT` (GrossAmount, NetAmount) and `STATUS` (Overall, Billing, Delivery, Life Cycle Status)

### Comparison with the official tasks

| Official task | Status |
|---|---|
| Task 4.1: collection facet *General Information*, `COLLFAC1`, position 10 | already in place since Ex09 |
| Task 4.2: collection facet *Additional Information*, `COLLFAC2`, position 20 | **new** |
| Task 5.1: identification reference under `COLLFAC1` | already in place since Ex09 |
| Task 5.2: field-group references AMOUNT and STATUS under `COLLFAC2` | **new** |
| Field groups AMOUNT and STATUS (part of the official template) | already in place since Ex10 |

---

# Exercise 11 Features

## Collection Facets (sections)

| Property | General Information | Additional Information |
|---|---|---|
| id | `COLLFAC1` | `COLLFAC2` |
| type | `#COLLECTION` | `#COLLECTION` |
| label | General Information | Additional Information |
| position | 10 | 20 |
| status | since Ex09 | **new** |

## Reference Facets (sub-sections)

| Parent | Type | Target | Label | Position |
|---|---|---|---|---|
| `COLLFAC1` | `#IDENTIFICATION_REFERENCE` | `@UI.identification` | General Information | 10 |
| `COLLFAC2` | `#FIELDGROUP_REFERENCE` | field group `AMOUNT` | Amounts | 10 (**new**) |
| `COLLFAC2` | `#FIELDGROUP_REFERENCE` | field group `STATUS` | Status | 20 (**new**) |

The course does not specify labels or positions for the two field-group reference facets. `Amounts`/`Status` and 10/20 are chosen to match the header facets of Ex10.

```text
Object Page
  ├─ Header
  │    ├─ title: Sales Order <SalesOrderID>
  │    ├─ Amounts   (header facet, Ex10)
  │    └─ Status    (header facet, Ex10)
  └─ Body
       ├─ Section "General Information"     (COLLFAC1, Ex09)
       │    └─ identification fields 10–70
       └─ Section "Additional Information"  (COLLFAC2)                 <- new
            ├─ Amounts  (#FIELDGROUP_REFERENCE → AMOUNT)               <- new
            └─ Status   (#FIELDGROUP_REFERENCE → STATUS)               <- new
```

---

## Design Note: Field Groups in Header and Body

The same field group can be referenced by several facets. After Ex11, AMOUNT and STATUS are shown twice: as header facets (Ex10) and in the *Additional Information* section (Ex11).

This is kept on purpose, to show both exercises in one application. In a real application, one of them would usually be removed. That only requires deleting the corresponding entries from `@UI.facet`; the field groups themselves stay unchanged.

---

# Implementation Steps

Develop in **ADT (Eclipse)** in the SAP system. Do not edit files in `src/` by hand (see `README.md` on `main`).

## 1. Prepare the system

1. In abapGit, switch the repository to branch `ux403-ex11-body-facets`.
2. Pull, so that the system has the current Exercise 10 state.
3. Check that no local changes are pending (no diff icon in abapGit).

---

## 2. Update the facets in the Metadata Extension

Only the `@UI.facet` annotation on `SalesOrderID` changes. The CDS view and all other annotations stay as they are.

Replace the existing `@UI.facet` annotation with:

```abap
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
               /* Ex09: section General Information */
               { id:       'COLLFAC1',
                 type:     #COLLECTION,
                 label:    'General Information',
                 position: 10 },
               { type:     #IDENTIFICATION_REFERENCE,
                 label:    'General Information',
                 parentId: 'COLLFAC1',
                 position: 10 },
               /* Ex11: section Additional Information */
               { id:       'COLLFAC2',
                 type:     #COLLECTION,
                 label:    'Additional Information',
                 position: 20 },
               { type:            #FIELDGROUP_REFERENCE,
                 targetQualifier: 'AMOUNT',
                 label:           'Amounts',
                 parentId:        'COLLFAC2',
                 position:        10 },
               { type:            #FIELDGROUP_REFERENCE,
                 targetQualifier: 'STATUS',
                 label:           'Status',
                 parentId:        'COLLFAC2',
                 position:        20 } ]
```

The annotations directly below it (`@UI.lineItem` and `@UI.identification` of `SalesOrderID`) remain unchanged.

Notes:

- `parentId` places a reference facet inside a collection facet; it must match the collection's `id` exactly.
- Positions are ordered per level: header facets among themselves, sections among themselves, and sub-sections within their parent.

Activate the Metadata Extension.

---

## 3. Verify the OData service

Service:

```text
ZCDS_UX403_SADL_00_CDS
```

Check the annotation model `ZCDS_UX403_SADL_00_CDS_VAN` in `$metadata`:

- `UI.Facets` contains two `UI.CollectionFacet` entries (General Information, Additional Information)
- the Additional Information collection contains two `UI.ReferenceFacet` entries pointing to `UI.FieldGroup#AMOUNT` and `UI.FieldGroup#STATUS`
- `UI.HeaderFacets` is unchanged

If the old metadata is still returned, clear the metadata cache (`/IWFND/CACHE_CLEANUP`, `/IWBEP/CACHE_CLEANUP`) and reload.

---

## 4. Push the backend to GitHub

In abapGit:

1. Stage the changed Metadata Extension (and any changed service files).
2. Commit, for example: `Ex11: add Additional Information section`.
3. Push to `ux403-ex11-body-facets`.

> Commits made directly on GitHub that only change files outside `src/` (for example this README) do not require a pull in abapGit before the next push.

---

## 5. Validate in the Fiori Elements application

Use the existing application in SAP Business Application Studio. Do not generate a new application.

1. Start the application and choose **Go**.
2. Select a sales order row.
3. Check the Object Page body:
   - two sections (anchor bar tabs): **General Information** and **Additional Information**, in this order
   - *General Information* shows the identification fields 10–70 as before
   - *Additional Information* shows the sub-sections **Amounts** and **Status** with their fields
4. Refresh the browser (Ctrl+Shift+R) if the body does not change.

---

## 6. Regression-test Exercises 07 to 10

Verify that:

- the List Report, search, filter fields and Customer value help are unchanged
- the Object Page header still shows the header facets **Amounts** and **Status**
- the General Information section is unchanged

---

## Architecture After Exercise 11

```text
ZCDS_UX403_SADL_00                       (unchanged in Ex11)
        |
        +---- ZCDS_UX403_SADL_00_UI
        |       |
        |       |-- header info
        |       |-- line items / selection fields
        |       |-- identification
        |       |-- field groups AMOUNT, STATUS
        |       |-- facets
        |       |     |-- header facets: Amounts, Status
        |       |     |-- COLLFAC1 General Information
        |       |     |     +-- identification reference
        |       |     +-- COLLFAC2 Additional Information      <- new
        |       |           |-- field group AMOUNT             <- new
        |       |           +-- field group STATUS             <- new
        |       +-- visibility / importance
        |
        v
ZCDS_UX403_SADL_00_CDS
        |
        v
Fiori Elements application
  List Report  --select row-->  Object Page (header facets + 2 sections)
```

---

## Exercise 11 Status

Planned:

- [ ] branch switched and pulled in the development system
- [ ] collection facet `COLLFAC2` *Additional Information* added
- [ ] field-group reference facets AMOUNT and STATUS added under `COLLFAC2`
- [ ] Metadata Extension activated
- [ ] backend pushed to GitHub with abapGit
- [ ] sections validated in the Fiori Elements application
- [ ] Exercises 07 to 10 regression-tested

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
```

Each exercise branch represents the cumulative application state at that stage of the UX403 training.

---

## Source

Exercise content based on *UX403, Unit 4, Exercise 11: Add Sections and Facets to the Object Page*. The course material is not part of this repository.
