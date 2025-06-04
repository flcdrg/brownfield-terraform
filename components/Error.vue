<template>
  <div class="error">
    <h1 v-if="props.text">
    <img src="/error-icon-25240.png" alt="Error Icon" :align=props.align valign="bottom" :style="{ verticalAlign: 'baseline' }" /> 
    {{ props.text }}
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
.error img {
  width: 64px;
  height: 64px;
}
</style>