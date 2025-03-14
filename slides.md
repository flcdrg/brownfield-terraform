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
src: ./slides-01-problem.md
---

---
src: ./slides-02-aztfexport.md
---

---
src: ./slides-03-import.md
---

---
src: ./slides-04-move.md
---

---
src: ./slides-05-migrate.md
---

---
layout: end
---

# Conclusion

The end
