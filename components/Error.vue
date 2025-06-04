<template>
  <div :class="['error', props.type]">
    <h1 class="error-heading">
      <img v-if="props.type === 'error'" src="/error-icon-25240.png" alt="Error Icon" />
      <img v-if="props.type === 'warning'" src="/warning.png" alt="Warning Icon" />
      <TitleRenderer />
    </h1>
    <br style="clear: both;" />
  </div>
</template>

<script lang="ts" setup>
import TitleRenderer from '#slidev/title-renderer'

export interface Props {
  align?: 'left' | 'right' | 'center';
  type?: 'error' | 'warning' | 'info';
}

const props = withDefaults(defineProps<Props>(), {
  type: 'error'
});
</script>

<style scoped>
.error {
  color: red;
  font-weight: bold;
}
.error.warning {
  color: #e6b800;
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