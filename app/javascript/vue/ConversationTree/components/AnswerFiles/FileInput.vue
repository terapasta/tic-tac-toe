<script>
const LimitFileSize = 10 * 1024 * 1024 // 10MB

export default {
  methods: {
    handleInputChange (e) {
      const file = e.target.files[0]
      if (file.size > LimitFileSize) {
        return this.$swal({
          title: 'エラー',
          text: 'ファイル容量は10MBが上限です',
          type: 'error'
        })
      }
      this.$emit('selectFile', file)
    }
  }
}
</script>

<template>
  <div class="answer-file-input">
    <i class="material-icons">add</i>
    ファイルを<br />アップロード
    <input type="file" @change="handleInputChange" />
  </div>
</template>

<style scoped lang="scss">
.answer-file-input {
  position: relative;
  display: inline-block;
  padding: 20px;
  width: 140px;
  height: 140px;
  background-color: #ccc;
  color: #fff;
  border-radius: 6px;
  text-align: center;
  font-weight: bold;
  vertical-align: top;

  &:hover {
    background-color: #bbb;
  }

  .material-icons {
    display: block;
    margin-bottom: 12px;
    font-size: 32px;
  }

  input[type=file] {
    cursor: pointer;
    position: absolute;
    display: block;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    opacity: 0;
    width: 100%;
    height: 100%;
  }
}
</style>