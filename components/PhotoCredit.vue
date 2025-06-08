<template>
<div :style="{
  fontSize: '0.8em',
  color: 'white',
  position: 'absolute',
  bottom: '1.5em',
  width: '100%',
  textAlign: props.align
}">
  Photo by <a :href="props.authorLink">{{ props.authorName }}</a> on <a :href="props.unsplashLink">Unsplash</a>
</div>
</template>

<script lang="ts" setup>

export interface Props {
  authorLink: string,
  authorName: string,
  unsplashLink: string,
  align?: 'left' | 'right' | 'center';
}

const props = withDefaults(defineProps<Props>(), {
  align: 'center'
});
</script>
