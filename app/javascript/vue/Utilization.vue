<script>
import axios from 'axios'

import UtilizationChart from './UtilizationChart'

export default {
  components: {
    UtilizationChart
  },

  mounted () {
    this.$nextTick(async () => {
      const config = { withCredentials: true }
      const response = await axios.get('/admin/utilizations', config)
      this.rawData = response.data.data
    })
  },

  data: () => ({
    rawData: [],
    displayData: [],
    monthlyData: [],
    levels: ['high', 'middle', 'low']
  })
}
</script>

<template>
  <div>
    <div
      v-for="(level, index) in levels"
      :key="index"
    >
      <h6 class="mt-5">{{level.toUpperCase()}}</h6>
      <div
        v-for="(data, index) in rawData[level]"
        :key="index"
      >
        <div class="col-md-4">
          <div class="card">
            <div class="card-body">
              <a
                class="d-flex link-silent align-items-center mb-2"
                :href="`/bots/${data.bot.id}`"
              >
                <div
                  class="circle-image-56"
                  :style="`background-image:url(${data.bot.image.thumb.url})`"
                />
                {{data.bot.name}}
              </a>
              <utilization-chart
                :columns="data.data"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
</style>
