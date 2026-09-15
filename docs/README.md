# FinPay Azure Infra Docs

Organized using the [Diátaxis](https://diataxis.fr/) framework: docs are split by what
the reader is trying to do, not by topic.

| Type | Answers | Start here |
|---|---|---|
| [Tutorials](tutorials/) | "Walk me through it" | [Deploy a dev environment](tutorials/deploy-dev-environment.md) |
| [How-to guides](how-to/) | "How do I do X?" | [How-to index](how-to/) |
| [Reference](reference/) | "What are the exact inputs/outputs?" | [Module reference](reference/modules/) |
| [Explanation](explanation/) | "Why is it built this way?" | [Architecture overview](explanation/architecture-overview.md) |

## Conventions

- **Reference docs for each module are generated, not hand-written.** They live in
  `reference/modules/*.md`, are wrapped in `<!-- BEGIN_TF_DOCS -->` / `<!-- END_TF_DOCS -->`
  markers, and are regenerated with [terraform-docs](https://terraform-docs.io/) (config:
  `.terraform-docs.yml` at repo root). Never hand-edit content between the markers — edit
  the module's `variables.tf`/`outputs.tf` and regenerate instead:

  ```sh
  terraform-docs markdown table --output-file ../../docs/reference/modules/<module>.md ./modules/<module>
  ```

  or, for all modules at once:

  ```sh
  make docs
  ```

- Tutorials, how-to guides, and explanation pages are hand-written and reviewed like code —
  they describe intent and reasoning that can't be generated from `.tf` files.
- Known gaps in the infra are called out where relevant instead of glossed over (e.g. the
  `monitoring` module is currently a stub — see [architecture-overview](explanation/architecture-overview.md)).
