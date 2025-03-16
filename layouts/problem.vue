<template>
  <div class="slidev-layout problem">
    <div class="my-auto">
      <slot />
    </div>
  </div>
</template>

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