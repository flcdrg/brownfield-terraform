<template>
  <div class="slidev-layout problem">
    <Error :text="props.heading" align="left" />
    <div class="my-auto">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
//import { defineProps } from 'vue';
const props = defineProps<{ heading: string }>();
</script>

<style>
  .problem h1 {
    color: red;
  }
  .problem p {
    font-family: 'Cascadia Code', 'Courier New', Courier, monospace;
  }

  .problem h1 + p {
    opacity: 1;
  }
</style>