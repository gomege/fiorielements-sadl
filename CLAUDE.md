# CLAUDE.md

Guidance for Claude Code in this repository. Read `README.md` for the full project description. This file only adds what matters when working on the repo.

## What this repo is

- Practice repository for SAP UX403 (Fiori Elements on CDS/SADL) and for **abapGit round trips between two SAP systems** (company sandbox and IDES). Backend development can happen in either one.
- **The SAP system is the source of truth.** Everything in `src/` is serialized by abapGit. **Do not edit, create, rename or delete files in `src/`.** Propose the change as ABAP/CDS source for the user to apply in ADT, then sync with abapGit.
- Safe to edit directly: `README.md`, `CLAUDE.md` (root files outside the abapGit starting folder `/src/`).
- The **Fiori Elements app is not in this repo**. It lives in SAP Business Application Studio. Don't look for `webapp/` or `manifest.json` here.

## Branches

- One branch per exercise, each cut from the previous one (cumulative): `main` (Ex05 baseline) → `ux403-ex06-…` → `ux403-ex07-…` → `ux403-ex08-…` → ….
- **The branch README is the status record** for that exercise (objective, objects, deviations, done/pending). Read it before working on a branch.
- Exercise branches are not merged into `main`. Don't merge or rebase between branches unless the user asks.
- The branch name `ux403-ex06-metadata-extention` contains a typo. Keep it, because other branches and abapGit links depend on it.

## Objects (package `ZCODE_GIT_FIORIELEMENTS-SADL`)

| Object | Kind | Source file |
|---|---|---|
| `ZCDS_UX403_SADL_00` | CDS view on `SEPM_I_SalesOrder`, `@OData.publish: true` | `src/zcds_ux403_sadlv2.ddls.asddls` (file name ≠ view name) |
| `ZCDS_UX403_SADL_00_UI` | Metadata extension (from Ex06) | `src/zcds_ux403_sadl_00_ui.ddlx.asddlxs` |
| `ZCDS_UX403_SADL_00_CDS` | SADL-generated OData service | `src/*.iwsv/.iwmo/.iwvb/.iwsg/.iwom.xml` (generated, never touch) |

- **Where annotations go (from Ex06 on):** `@UI.*` belongs in the metadata extension. Data, search, value-help and semantic annotations (`@Search`, `@Consumption.valueHelp`, `@Semantics`) belong in the CDS view.
- Some file names in `src/` contain padding spaces (e.g. `zcds_ux403_sadl_00_cds             0001.iwsv.xml`). Quote paths in shell commands.
- The field list and annotations change per branch. Read the current `.asddls` / `.asddlxs` instead of relying on any list.

## Conventions

- Commit messages: short, free text, ideally prefixed with the exercise (e.g. `Ex08: add customer value help`).
- Only abapGit-generated files belong in `src/`. Flag anything else (e.g. `*.code-workspace`) and suggest moving it out or adding it to `.gitignore`.
- Don't put system IDs, clients, user names or hostnames in README files or commit messages.
