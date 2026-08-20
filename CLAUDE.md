# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **SAP Fiori Elements project** based on **CDS (Core Data Services)** and synchronized with GitHub via **abapgit**. The repository contains CDS Views and metadata that generate OData services for SAP Fiori UI applications.

**Key Technologies:**
- **CDS Views** (.ddls files) - Core Data Services definitions for SADL (Service Adapter Layer)
- **abapgit** - Version control bridge between SAP ABAP systems and GitHub
- **OData Services** - Exposed through SADL with UI annotations
- **Fiori Elements** - UI generation based on CDS metadata annotations

## Repository Structure

```
src/
├── zcds_ux403_sadlv2.ddls.asddls    # CDS View definition (ABAP source)
├── zcds_ux403_sadlv2.ddls.xml       # CDS View metadata (abapgit serialization)
├── zcds_ux403_sadl_00_cds_*.iwvb.xml # View variant configurations
├── zcds_ux403_sadl_00_cds_*.iwmo.xml # View model configurations
├── zcds_ux403_sadl_00_cds_*.iwsv.xml # Service configurations
└── package.devc.xml                 # Package definition metadata
.abapgit.xml                         # abapgit repository configuration
```

## Working with This Repository

### Syncing with SAP Systems

This repository is synchronized via **abapgit**, which bridges GitHub and SAP ABAP systems:

1. **Pull from SAP** → **Push to GitHub**:
   - In SAP system, use abapgit to pull changes from GitHub
   - Developers make changes in SAP (via SE80, ADT, or similar)
   - abapgit pushes changes back to GitHub

2. **Push from GitHub** → **Pull into SAP**:
   - Changes merged to GitHub's `main` branch
   - In SAP system, use abapgit "Pull" to fetch the latest changes
   - abapgit serializes objects into XML format automatically

**Note:** Direct edits to files in this GitHub repo should be minimal—most changes happen in the SAP system and sync through abapgit.

### Key Configuration Files

- **`.abapgit.xml`**: Defines repository metadata
  - `STARTING_FOLDER: /src/` — All objects start in the `src/` folder
  - `FOLDER_LOGIC: PREFIX` — Folder structure is based on object name prefix
  - `MASTER_LANGUAGE: E` — English

### Understanding CDS Views

CDS View: `ZCDS_UX403_SADL_00` (defined in `zcds_ux403_sadlv2.ddls.asddls`)

**Key Annotations:**
- `@Metadata.allowExtensions: true` — Allows extensions in derived views
- `@OData.publish: true` — Exposes the view as an OData service
- `@UI.` annotations — Define how Fiori Elements renders the UI
  - `@UI.headerInfo` — Header section (title, type name)
  - `@UI.lineItem` — Columns displayed in the list view
  - `@Search.` — Search and indexing behavior
  - `@EndUserText.label` — User-facing label

**Example Structure:**
The view selects from `SEPM_I_SalesOrder` and exposes:
- `SalesOrderID` (key, position 10)
- `CustomerID` (position 20)
- `CustomerName` (position 30)
- `GrossAmount` (position 40)

The `position` field controls the column order in the Fiori Elements UI.

### Common Development Tasks

#### Adding a New Field to the CDS View
1. Edit `src/zcds_ux403_sadlv2.ddls.asddls`:
   - Add the field to the SELECT clause
   - Include UI annotations (`@UI.lineItem.position`) to control visibility and order
   - Add search annotations if needed (`@Search.defaultSearchElement`)

2. Commit and push to GitHub

3. In SAP system, pull changes via abapgit → test in Fiori Elements

#### Modifying UI Behavior
- Edit the `@UI.` annotations in the CDS view
- Change `@UI.headerInfo` for header/title behavior
- Modify `@UI.lineItem.position` values to reorder columns
- Adjust `@UI.fieldGroup` for detail views (if present)

#### Extending the CDS View
- Use another CDS view that extends this one (via `extend view`)
- abapgit will serialize the extension as a separate object

### Commit Message Convention

When syncing from SAP through abapgit, commits follow the pattern:
- `[OBJECT_TYPE] Object Name` (e.g., `CDS View ZCDS_UX403_SADL_00`)
- abapgit auto-generates these; avoid manual edits unless necessary

## Useful Resources

- **SAP ABAP CDS Documentation**: Core Data Services syntax and annotations
- **Fiori Elements Documentation**: UI generation and annotation reference
- **abapgit Project**: https://github.com/abapGit/abapGit — for sync mechanics
- **SAP Fiori Design Guidelines**: https://experience.sap.com/fiori-design/ — for UI best practices
