# fiorielements-sadl

Practice repository for **SAP UX403 (Fiori Elements with CDS/SADL)** and, above all, for working with **abapGit** across more than one SAP system.

The backend objects of a small Sales Order List Report are developed in an SAP system, serialized by abapGit, and stored here. The same objects can then be pulled into another SAP system, changed there, and pushed back. This makes it possible to move work back and forth between systems.

---

## Goals

1. Practice the abapGit round trip: **develop → stage → commit → push → pull into another system**.
2. Work through the UX403 exercises on **one evolving solution** instead of creating new objects for every exercise.
3. Keep one branch per exercise, so each step can be imported, compared or reverted on its own.

---

## Source of truth

**The SAP system is the source of truth. GitHub is the transport and history layer.**

- Objects are created, changed and activated **in an SAP system** (ADT / Eclipse, SE80, …).
- abapGit serializes them into `src/`. **Never edit files in `src/` by hand.** abapGit would pull a hand-edited file into the system as-is, and errors only appear when the object is activated.
- Files outside `src/` (`README.md`, `CLAUDE.md`, `.abapgit.xml`) are not ABAP objects. abapGit ignores them, and they are maintained directly in Git.

---

## System landscape

Backend development is possible in **either** system, and abapGit is the bridge between them:

```text
   SAP system A                       SAP system B
 (e.g. company sandbox)             (e.g. IDES)
        │  abapGit push                   ▲  abapGit pull
        ▼                                 │
   ┌──────────────── GitHub repository ───────────────┐
   │   one branch per exercise (see Branch model)      │
   └──────────────────────────────────────────────────┘
        ▲  abapGit pull                   │  abapGit push
        │                                 ▼
   SAP system A                       SAP system B
```

The direction is not fixed: whichever system was last changed pushes, and the other one pulls.

The **Fiori Elements application is not part of this repository**. It is a separate project in **SAP Business Application Studio**. It consumes the OData service of whichever SAP system it is connected to (via BTP destination / SAP Cloud Connector, where needed).

---

## Backend objects

All objects belong to the ABAP package `ZCODE_GIT_FIORIELEMENTS-SADL`. Which objects exist depends on the branch. The core objects are:

| Object | Type | Purpose | File in `src/` |
|---|---|---|---|
| `ZCDS_UX403_SADL_00` | CDS view (DDLS) | Sales order data from `SEPM_I_SalesOrder`; search and value help; `@OData.publish: true` | `zcds_ux403_sadlv2.ddls.*` ¹ |
| `ZCDS_UX403_SADL_00_UI` | Metadata extension (DDLX) | UI annotations (header, line items, selection fields) | `zcds_ux403_sadl_00_ui.ddlx.*` |
| `ZCDS_UX403_SADL_00_CDS` | OData service (SADL-generated) | Service consumed by the Fiori Elements app | `*.iwsv.xml`, `*.iwmo.xml`, `*.iwvb.xml`, `*.iwsg.xml`, `*.iwom.xml` |
| `ZUX403_*` | Data elements etc. | Labels and semantics for calculated fields | `*.dtel.xml` |

¹ The DDLS source file is named `zcds_ux403_sadlv2`, but the view it defines is `ZCDS_UX403_SADL_00`.

Any further objects are listed in that branch's README.

---

## Branch model

```text
main                              baseline: CDS view + SADL OData service (UX403 Ex05)
 └─ ux403-ex06-<topic>
     └─ ux403-ex07-<topic>
         └─ ux403-ex08-<topic>
             └─ …                 one branch per further exercise
```

- Every exercise branch starts from the previous one, so the **history is cumulative**.
- Branch naming: `ux403-exNN-<short-topic>`.
- Every branch has its **own `README.md`** with that exercise's objective, changed objects, any deviations from the official course, the validation status and open points. This file (on `main`) only describes what applies to all branches.
- `main` is the stable baseline. Exercise branches are not merged back automatically.

### Deviation from the official course

The official UX403 exercises often create new CDS views and new Fiori Elements apps. This repository deliberately keeps one of each and enhances them step by step:

```text
One CDS view · One metadata extension · One OData service · One Fiori Elements app
```

---

## Working across systems with abapGit

### Push changes from a system

1. Make sure the abapGit repository in that system points to the **correct branch**.
2. Develop and **activate** all objects. Inactive objects are not serialized correctly.
3. In abapGit, choose **Stage**, check the file list, and commit with a short, meaningful message (e.g. `Ex08: add customer value help`).
4. Push.

### Pull changes into another system

1. Open the same repository in abapGit and **switch to the branch** you want.
2. Choose **Pull**. abapGit lists the objects that will be created, changed or deleted. Review the list before confirming.
3. Activate any objects that abapGit reports as inactive.
4. Check the OData service (`$metadata`, entity set). Depending on the system, the service may first need to be registered or activated in `/IWFND/MAINT_SERVICE`.

### Rules that prevent conflicts

- **Pull before you change.** Before starting to work in a system, pull the current branch state into it.
- **One active editor per branch.** Do not change the same objects in both systems at the same time. abapGit does not merge ABAP objects: whichever change is pulled last overwrites the other.
- abapGit marks **local changes that are not on the branch** (diff icon). Push or discard them before pulling.
- **Only abapGit-generated files in `src/`.** Do not put IDE, workspace or personal files in `src/`. abapGit flags them as unknown files, and they may expose system or user details.

---

## Repository configuration

`.abapgit.xml`: starting folder `/src/`, folder logic `PREFIX`, original language English.

---

## Disclaimer

Training and practice repository. It contains no productive code and uses only SAP demo data (EPM model, `SEPM_*`).
