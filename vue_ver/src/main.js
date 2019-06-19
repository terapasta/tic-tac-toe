import Vue from 'vue'
import Game from './components/Game'

Vue.config.productionTip = false

new Vue({
  render: h => h(Game),
}).$mount('#app')
