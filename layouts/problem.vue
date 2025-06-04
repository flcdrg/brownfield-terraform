<template>
  <div class="slidev-layout problem">
    <Error :type="props.type" />
    <div class="my-auto">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">

const props = withDefaults(defineProps<{
  type?: 'error' | 'warning' | 'info';
}>(), {
  type: 'error'
});
</script>

<style>
  .problem p {
    font-family: 'Cascadia Code', 'Courier New', Courier, monospace;
  }

  .problem h1 + p {
    opacity: 1;
  }
</style>