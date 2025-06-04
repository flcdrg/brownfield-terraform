<template>
  <div class="error">
    <h1 v-if="props.text" class="error-heading">
      <img src="/error-icon-25240.png" alt="Error Icon" />
      <span>{{ props.text }}</span>
    </h1>
    <br style="clear: both;" />
  </div>
</template>

<script lang="ts" setup>
export interface Props {
  text: string;
  align?: 'left' | 'right' | 'center';
}

const props = withDefaults(defineProps<Props>(), {

});
</script>

<style scoped>
.error {
  color: red;
  font-weight: bold;
}
.error-heading {
  display: flex;
  align-items: center;
  gap: 0.5em;
}
.error img {
  width: 64px;
  height: 64px;
}
</style>