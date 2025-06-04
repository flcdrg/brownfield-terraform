<template>
<div style="font-size: 0.8em; color: white; position: absolute; bottom: 1.5em; right: 2em; width: 100%; text-align: right;">
  Photo by <a :href="props.authorLink">{{ props.authorName }}</a> on <a :href="props.unsplashLink">Unsplash</a>
</div>
</template>

<script lang="ts" setup>

export interface Props {
  authorLink: string,
  authorName: string,
  unsplashLink: string,
}

const props = withDefaults(defineProps<Props>(), {
});
</script>
