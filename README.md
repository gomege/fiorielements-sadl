# UX403 Exercise 12: Navigate to an External URL

## Objective

This branch implements UX403 Exercise 12: an **external link** on the customer name in the List Report.

The *Company Name* column becomes a link. Selecting it opens a Google search for the company name in the browser.

As in the previous exercises, the existing CDS view, Metadata Extension, OData service and Fiori Elements application are reused and enhanced. No new objects are created.

---

## Branch

```text
ux403-ex12-external-url
```

Parent branch:

```text
ux403-ex11-body-facets
```

The branch history is intentionally cumulative.

---

## Training Deviation

The official exercise again creates a new set of objects from a template:

| Official exercise | This repository |
|---|---|
| New CDS view `ZCDS_UX403_LINK_##` from a template file | Existing CDS view `ZCDS_UX403_SADL_00` |
| UI annotations directly in the CDS view | UI annotations in the existing Metadata Extension `ZCDS_UX403_SADL_00_UI` |
| New OData service `ZCDS_UX403_LINK_##_CDS`, registered in `/IWFND/MAINT_SERVICE` | Existing service `ZCDS_UX403_SADL_00_CDS` (already registered) |
| New Fiori Elements project (template *List Report Object Page*) | Existing Fiori Elements application in SAP Business Application Studio |

Therefore the official **Task 1, Task 2 and Task 3 are skipped**. Tasks 4 and 5 are implemented on the existing objects.

```text
One CDS view · One Metadata Extension · One OData service · One Fiori Elements app
```

---

## Backend Package

```text
ZCODE_GIT_FIORIELEMENTS-SADL
```

---

## Objects Changed in Exercise 12

| Object | Type | Change |
|---|---|---|
| `ZCDS_UX403_SADL_00` | CDS Data Definition | add calculated field `SearchURL` |
| `ZCDS_UX403_SADL_00_UI` | Metadata Extension | `CustomerName` line item becomes `#WITH_URL`; `SearchURL` hidden |
| `ZCDS_UX403_SADL_00_CDS` | Generated OData service | no manual change; metadata is regenerated on activation |

---

## Exercise 11 Baseline

Exercise 12 builds on the completed Exercise 11 implementation:

- List Report with line items, search, filter fields and Customer value help
- Object Page header with title and header facets **Amounts** and **Status**
- Object Page sections **General Information** and **Additional Information**

---

# Exercise 12 Features

## Calculated Field SearchURL

A new field builds the Google search URL from a fixed part and the company name, using the CDS function `concat`:

```text
'https://www.google.com/search?q='  +  CompanyName   =   SearchURL
```

Example: `https://www.google.com/search?q=SAP`

## Link on Company Name

| Annotation (on `CustomerName`, in `@UI.lineItem`) | Meaning |
|---|---|
| `type: #WITH_URL` | the column is rendered as a link instead of plain text |
| `url: 'SearchURL'` | the link target is taken from the field `SearchURL` |

## Hidden SearchURL

`SearchURL` is only a technical field for the link target. `@UI.hidden: true` keeps it out of the UI (table columns, Object Page, column settings). It is still part of the OData entity, so the link can use it.

```text
List Report row
  Company Name: "SAP"  (link)  ──select──►  https://www.google.com/search?q=SAP
                                              ▲
                                              │ url: 'SearchURL'
                                     SearchURL (hidden)
```

---

## Annotation Placement

| Annotation / element | Location | Reason |
|---|---|---|
| `SearchURL` (calculated field) | CDS Data Definition | data model |
| `@UI.lineItem` with `type: #WITH_URL`, `url` | Metadata Extension | UI presentation |
| `@UI.hidden` on `SearchURL` | Metadata Extension | UI presentation (same as `CurrencyCode`) |

---

# Implementation Steps

Develop in **ADT (Eclipse)** in the SAP system. Do not edit files in `src/` by hand (see `README.md` on `main`).

## 1. Prepare the system

1. In abapGit, switch the repository to branch `ux403-ex12-external-url`.
2. Pull, so that the system has the current Exercise 11 state.
3. Check that no local changes are pending (no diff icon in abapGit).

---

## 2. Add the field SearchURL to the CDS view

In `ZCDS_UX403_SADL_00`, add the new field directly after `CustomerName`:

```abap
      @Search.defaultSearchElement: true
      _Customer.CompanyName          as CustomerName,

      concat( 'https://www.google.com/search?q=',
              _Customer.CompanyName ) as SearchURL,

      _Customer.URL                  as CustomerURL,
```

Check (Ctrl+F2), activate (Ctrl+F3) and use the Data Preview (F8) to see the generated URLs.

---

## 3. Update the Metadata Extension

Two changes in `ZCDS_UX403_SADL_00_UI`. All other annotations stay as they are.

### 3a. Make CustomerName a link

Replace the `@UI.lineItem` of `CustomerName` (keep `@UI.identification`):

```abap
  @UI.lineItem:       [ { position:   30,
                          importance: #HIGH,
                          label:      'Company Name',
                          type:       #WITH_URL,
                          url:        'SearchURL' } ]
  @UI.identification: [ { position: 30, label: 'Company Name' } ]
  CustomerName;
```

### 3b. Hide SearchURL

Add directly after `CustomerName`:

```abap
  @UI.hidden: true
  SearchURL;
```

Activate the Metadata Extension.

---

## 4. Verify the OData service

Service:

```text
ZCDS_UX403_SADL_00_CDS
```

Check `$metadata` and the entity set:

- the entity type contains `SearchURL`, and the entity set returns URLs such as `https://www.google.com/search?q=...`
- in the annotation model `ZCDS_UX403_SADL_00_CDS_VAN`, the `UI.LineItem` entry for `CustomerName` is a `UI.DataFieldWithUrl` with `Url` = path `SearchURL`
- `SearchURL` carries `UI.Hidden`

If the old metadata is still returned, clear the metadata cache (`/IWFND/CACHE_CLEANUP`, `/IWBEP/CACHE_CLEANUP`) and reload.

---

## 5. Push the backend to GitHub

In abapGit:

1. Stage the changed objects (CDS view, Metadata Extension and any changed service files).
2. Commit, for example: `Ex12: add external search link on company name`.
3. Push to `ux403-ex12-external-url`.

> Commits made directly on GitHub that only change files outside `src/` (for example this README) do not require a pull in abapGit before the next push.

---

## 6. Validate in the Fiori Elements application

Use the existing application in SAP Business Application Studio. Do not generate a new application.

1. Start the application and choose **Go**.
2. The *Company Name* column shows the names as links.
3. Select a link: a Google search for that company opens.
4. `SearchURL` does not appear as a column, in the column settings or on the Object Page.
5. Refresh the browser (Ctrl+Shift+R) if nothing changes.

---

## 7. Regression-test Exercises 07 to 11

Verify that:

- all other List Report columns, search, filter fields and Customer value help are unchanged
- free-text search on `CustomerName` still works (the field itself is unchanged; only its display changed)
- the Object Page header facets and both sections are unchanged

---

## Notes and Limitations

- **Link only in the List Report.** As in the course, only `@UI.lineItem` gets `#WITH_URL`. On the Object Page, *Company Name* stays plain text. The same `type`/`url` properties could also be added to `@UI.identification` if a link is wanted there.
- **Special characters.** The company name is inserted into the URL unencoded. Names with characters such as `&` or `#` may produce an incomplete search. Spaces are handled by the browser. For a training exercise this is acceptable.
- **Alternative target.** The view already contains `CustomerURL` (the customer's web site). `url: 'CustomerURL'` would link to the customer's own site instead of a search.
- **Customer data in an external URL.** The company name is sent to an external search engine. This is fine for EPM demo data; in real applications, check data protection before sending business data to external services.

---

## Architecture After Exercise 12

```text
ZCDS_UX403_SADL_00
        |
        |-- search semantics
        |-- value-help association
        |-- amount/currency semantics
        |-- business and status fields
        |-- SearchURL (concat)                    <- new
        |
        +---- ZCDS_UX403_SADL_00_UI
        |       |
        |       |-- header info
        |       |-- line items
        |       |     +-- CustomerName #WITH_URL  <- new
        |       |-- selection fields
        |       |-- identification / field groups
        |       |-- facets (header + 2 sections)
        |       +-- hidden: CurrencyCode, SearchURL   <- new
        |
        v
ZCDS_UX403_SADL_00_CDS
        |
        v
Fiori Elements application
  List Report (Company Name link → Google)  --select row-->  Object Page
```

---

## Lessons Learned

- **Data model first, UI second.** In the first attempt only the Metadata Extension was changed. `url: 'SearchURL'` then pointed to a field that did not exist in the CDS view, so the link did not work. The correct order is: add the field to the CDS view → activate → check in Data Preview → then annotate it in the Metadata Extension.
- **Element names in the Metadata Extension** are not case-sensitive (`searchurl` works), but writing them exactly like the CDS alias (`SearchURL`) keeps the code readable and searchable.

---

## Bonus Exercise: Link to the Customer's Web Site

*Small extra task, not part of the official course.*

### Task

The view already exposes `CustomerURL` (the customer's web site), but it is not shown anywhere in the app. Show it on the Object Page in the section **General Information**, as a **clickable link that opens the customer's own web site**.

### Hints

- Which annotation puts a field into *General Information*? (See Ex09.)
- In Ex12, `type` and `url` were used inside `@UI.lineItem`. The same two properties exist for that other annotation.
- A field can be the link target of itself.
- Before testing, look at a few `CustomerURL` values in the Data Preview (F8). Does every value start with `http://` or `https://`? What would the browser do with a value like `www.example.com`?

### Expected Result

- *General Information* shows a new field *Web Site* (or similar label) at the end of the field list.
- Selecting it opens the customer's web site in a new browser tab.
- No CDS view change is needed.

---

## Exercise 12 Status

**Exercise 12 completed.**

- ✅ branch switched and pulled in the development system
- ✅ `SearchURL` added to the CDS view
- ✅ `CustomerName` line item changed to `#WITH_URL` with `url: 'SearchURL'`
- ✅ `SearchURL` hidden
- ✅ CDS view and Metadata Extension activated
- ✅ backend pushed to GitHub with abapGit
- ✅ link validated in the Fiori Elements application
- ✅ Exercises 07 to 11 regression-tested

Bonus exercise:

- [ ] `CustomerURL` shown as link in *General Information*

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
```

Each exercise branch represents the cumulative application state at that stage of the UX403 training.

---

## Source

Exercise content based on *UX403, Unit 5, Exercise 12: Navigate to an External URL*. The course material is not part of this repository.
