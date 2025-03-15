<!-- global-bottom.vue -->
<template>
    <footer class="absolute bottom-0 left-0 right-0 p-2">David Gardiner</footer>
    <footer
    v-if="$nav.currentLayout !== 'cover'"
    class="absolute bottom-0 right-0 p-2"
  >
    {{ $nav.currentPage }} / {{ $nav.total }}
    </footer>
</template>