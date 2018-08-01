<script>
export default {
}
</script>

<template>
  <div class="v-spinner">
    <div
      class="v-beat v-beat-odd"
      style="background-color: rgb(243, 107, 48); height: 8px; width: 8px; margin: 2px; border-radius: 100%;"
    /><div
      class="v-beat v-beat-even"
      style="background-color: rgb(243, 107, 48); height: 8px; width: 8px; margin: 2px; border-radius: 100%;"
    /><div
      class="v-beat v-beat-odd"
      style="background-color: rgb(243, 107, 48); height: 8px; width: 8px; margin: 2px; border-radius: 100%;"
    />
  </div>
</template>

<style scoped>
.v-spinner .v-beat
{
    -webkit-animation: v-beatStretchDelay 0.7s infinite linear;
            animation: v-beatStretchDelay 0.7s infinite linear;
    -webkit-animation-fill-mode: both;
	          animation-fill-mode: both;
    display: inline-block;
}
.v-spinner .v-beat-odd
{
  animation-delay: 0s;
}
.v-spinner .v-beat-even
{
  animation-delay: 0.35s;
}
@-webkit-keyframes v-beatStretchDelay
{
    50%
    {
        -webkit-transform: scale(0.75);
                transform: scale(0.75);
        -webkit-opacity: 0.2;
                opacity: 0.2;
    }
    100%
    {
        -webkit-transform: scale(1);
                transform: scale(1);
        -webkit-opacity: 1;
                opacity: 1;
    }
}
@keyframes v-beatStretchDelay
{
    50%
    {
        -webkit-transform: scale(0.75);
                transform: scale(0.75);
        -webkit-opacity: 0.2;
                opacity: 0.2;
    }
    100%
    {
        -webkit-transform: scale(1);
                transform: scale(1);
        -webkit-opacity: 1;
                opacity: 1;
    }
}
</style>
