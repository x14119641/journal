<template>
  <!-- Pase content file and add variables to wha ti want to change, i want to change stroke color -->
  <svg
    version="1.1"
    id="Capa_1"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    viewBox="0 0 15.741 15.741"
    xml:space="preserve"
    class="w-10 h-10"
  >
    <g>
      <g>
        <path
          :fill="baseColor"
          d="M8.472,0l-1.28,0.003c-2.02,0.256-3.679,1.104-4.671,2.386C1.685,3.47,1.36,4.78,1.553,6.283
                  c0.37,2.87,2.773,6.848,4.674,8.486c0.475,0.41,1.081,0.794,1.353,0.899c0.129,0.044,0.224,0.073,0.333,0.073
                  c0.11,0,0.217-0.031,0.319-0.091c1.234-0.603,2.438-1.88,3.788-4.02c0.936-1.485,2.032-3.454,2.2-5.495
                  C14.492,2.843,12.295,0.492,8.472,0z M8.435,0.69c3.431,0.447,5.337,2.462,5.097,5.391c-0.156,1.913-1.271,3.875-2.097,5.182
                  c-1.278,2.027-2.395,3.226-3.521,3.777c-0.005,0.002-0.009,0.004-0.012,0.005c-0.029-0.006-0.068-0.021-0.087-0.027
                  c-0.149-0.057-0.706-0.401-1.135-0.771c-1.771-1.525-4.095-5.375-4.44-8.052C2.07,4.879,2.348,3.741,3.068,2.812
                  c0.878-1.135,2.363-1.889,4.168-2.12L8.435,0.69z"
        />
        <path
          :fill="fillColor"
          d="M3.504,6.83C3.421,6.857,3.37,6.913,3.373,7.024c0.308,1.938,1.616,3.536,3.842,3.126
                  C7.002,8.019,5.745,6.933,3.504,6.83z"
        />
        <path
          :fill="fillColor2"
          d="M8.778,10.215c2.196-0.125,3.61-1.379,3.776-3.319C10.321,6.727,8.55,7.923,8.778,10.215z"
        />
      </g>
    </g>
    <!-- Dollar Sign on Forehead -->
    <text
      class="cursor-pointer select-none"
      x="8"
      y="5"
      font-size="4"
      font-weight="bold"
      text-anchor="middle"
      :fill="fillColor2"
    >
      $
    </text>
  </svg>
</template>

<script setup lang="ts">
defineProps({
  baseColor: {
    type: String,
    default: "#323232",
  },
  fillColor: {
    type: String,
    default: "#323232",
  },
  fillColor2: {
    type: String,
    default: "#323232",
  },
});
</script>
