<script>
import { mapActions } from 'vuex'
import isEmpty from 'is-empty'

import FileInput from './AnswerFiles/FileInput'
import FileItem, { answerFilesValidator } from './AnswerFiles/FileItem'

export default {
  components: {
    FileInput,
    FileItem
  },

  props: {
    questionAnswerId: { type: Number, default: null },
    answerFiles: { type: Array, default: () => ([]), validator: answerFilesValidator }
  },

  methods: {
    ...mapActions(['attachFileToQuestionAnswer']),

    handleFileInputSelectFile (file) {
      const { questionAnswerId } = this
      if (!isEmpty(questionAnswerId)) {
        this.attachFileToQuestionAnswer({ questionAnswerId, file })
          .catch(() => {
            this.$swal({
              title: 'エラー',
              text: 'アップロードできませんでした',
              type: 'error'
            })
          })
      }
    }
  }
}
</script>

<template>
  <div class="form-group">
    <div class="card">
      <div class="card-body p-3">
        <label>
          <i class="material-icons">attachment</i>
          <span>回答添付ファイル</span>
        </label>
        <div class="answer-files">
          <template v-for="(answerFile, i) in answerFiles">
            <file-item
              :questionAnswerId="questionAnswerId"
              :answerFile="answerFile"
              :key="i"
            />
          </template>
          <file-input
            @selectFile="handleFileInputSelectFile"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.answer-files {
  margin-left: -1rem;
  margin-right: -1rem;
  padding-left: 1rem;
  padding-right: 1rem;
  overflow-x: auto;
  overflow-y: hidden;
  white-space: nowrap;
}
</style>