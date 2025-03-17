---
# You can also start simply with 'default'
theme: default
title: Order from chaos - Importing brownfield Azure applications into Terraform
info: |
  Shows how to import existing Azure resources into Terraform state

drawings:
  persist: false
# slide transition: https://sli.dev/guide/animations.html#slide-transitions
transition: fade
# enable MDC Syntax: https://sli.dev/features/mdc
mdc: true
---

# Order from chaos

Importing brownfield Azure applications into Terraform

<div @click="$slidev.nav.next" class="mt-12 py-1" hover:bg="white op-10">
  Press Space for next page <carbon:arrow-right />
</div>

<div class="abs-br m-6 text-xl">
  <button @click="$slidev.nav.openInEditor" title="Open in Editor" class="slidev-icon-btn">
    <carbon:edit />
  </button>
  <a href="https://github.com/flcdrg/csharp-refactoring-slidev" target="_blank" class="slidev-icon-btn">
    <carbon:logo-github />
  </a>
</div>

<!--
The last comment block of each slide will be treated as slide notes. It will be visible and editable in Presenter Mode along with the slide. [Read more in the docs](https://sli.dev/guide/syntax.html#notes)
-->

---

# Outline

* The problem
* `aztfexport`
* `import`
* `move`
* Migrate TF deprecated resources

---
src: ./slides-10-problem.md
---

---
src: ./slides-20-aztfexport.md
---

---
src: ./slides-30-pipeline.md
---

---
src: ./slides-40-import.md
---

---
src: ./slides-50-move.md
---

---
src: ./slides-60-migrate.md
---

---

# Clean up

After changes have been applied to all environments

* Re-apply a second time, just to be sure. Then
* Remove `moved` blocks
* Remove `import` blocks
* And deploy again. Terraform should not want to make any changes.

---
layout: end
---

# And we're done!
