<!-- From https://github.com/k2tzumi/slidev-addon-qrcode/ -->
<template>
  <div class="qrcode_wrapper" :style="{ marginBottom: props.bottomAdjust }">
    <div class="qrcode_container" ref="qrCodeRef"></div>
  </div>
</template>

<script lang="ts" setup>
import QRCodeStyling from 'qr-code-styling';
import { Options } from 'qr-code-styling';
import { watch, computed, onMounted, ref } from 'vue';

const qrCodeRef: any = ref(null);

export interface Props {
  value: string,
  color?: string,
  width?: number,
  height?: number,
  image?: string,
  bottomAdjust?: string
}

const props = withDefaults(defineProps<Props>(), {
  width: 150,
  height: 150,
  color: "blue",
  bottomAdjust: "-2em"
});

const offsetColor = computed<string>(() => {
  const percent = 85;
  let r = parseInt(props.color.slice(1, 3), 16),
    g = parseInt(props.color.slice(3, 5), 16),
    b = parseInt(props.color.slice(5, 7), 16);

  r = Math.round(r * (100 - percent) / 100);
  g = Math.round(g * (100 - percent) / 100);
  b = Math.round(b * (100 - percent) / 100);

  return ('0' + (r || 0).toString(16)).slice(-2) +
    ('0' + (g || 0).toString(16)).slice(-2) +
    ('0' + (b || 0).toString(16)).slice(-2);
});

const options: Options = {
  width: props.width,
  height: props.height,
  type: 'svg',
  data: props.value,
  image: props.image,
  margin: 10,
  qrOptions: {
    typeNumber: 0,
    mode: 'Byte',
    errorCorrectionLevel: 'H',
  },
  imageOptions: {
    hideBackgroundDots: true,
    crossOrigin: 'anonymous',
  },
  cornersSquareOptions: {
    type: 'extra-rounded',
    color: '#' + props.color
  },
  cornersDotOptions: {
    type: 'square',
    color: '#' + props.color
  },
  dotsOptions: {
    type: 'rounded',
    color: '#' + props.color,
    gradient: {
      type: 'linear',
      rotation: 0,
      colorStops: [
        {
          offset: 0,
          color: '#' + props.color
        },
        {
          offset: 1,
          color: '#' + offsetColor
        }
      ]
    }
  },
};

const qrCode = new QRCodeStyling(options);

onMounted(async () => {
  qrCode.append(qrCodeRef.value);
});

watch(
  () => props.value,
  (newValue) => {
    qrCode.update({ ...options, data: newValue });
  },
);
</script>

<style scoped>
.qrcode_wrapper {
  display: flex;
  align-items: center;
}

.qrcode_container {
  margin-left: 10px;
}

a:active, a:visited, a:link {
  text-decoration: underline;
  border-style: none;

}
</style>