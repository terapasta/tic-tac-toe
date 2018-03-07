<script>
import { mapActions } from 'vuex'
import Joi from 'joi-browser'
import includes from 'lodash/includes'
import last from 'lodash/last'
import isEmpty from 'is-empty'

import Spinner from '../Spinner'

export const answerFileValidationSchema = Joi.object().keys({
  id: Joi.number().required(),
  file: Joi.object().keys({
    url: Joi.string()
  }).required(),
  fileType: Joi.string().required(),
  fileSize: Joi.number().required()
})

export const answerFileValidator = (val) => {
  const { error } = Joi.validate(val, answerFileValidationSchema)
  return error === null
}

export const answerFilesValidator = (val) => {
  const results = val.map(v => answerFileValidator(v))
  return !includes(results, false)
}

export default {
  components: {
    Spinner
  },

  props: {
    decisionBranchId: { type: Number, default: null },
    questionAnswerId: { type: Number, default: null },
    answerFile: { type: Object, required: true, validator: answerFileValidator }
  },

  data: () => ({
    isProcessing: false
  }),

  computed: {
    name () {
      return window.decodeURIComponent(last(this.answerFile.file.url.split('?')[0].split("/")))
    },

    itemStyle () {
      if (this.isImage) {
        return { backgroundColor: '#000' }
      } else {
        return {}
      }
    },

    bgStyle () {
      if (this.isImage) {
        return { backgroundImage: `url(${this.answerFile.file.url})` }
      } else {
        return {}
      }
    },

    nameStyle () {
      if (this.isImage) {
        return { textShadow: '0 0 5px rgba(0,0,0,.75)', color: '#fff' }
      } else {
        return {}
      }
    },

    isImage () {
      return /image/.test(this.answerFile.fileType)
    }
  },

  methods: {
    ...mapActions([
      'removeFileFromQuestionAnswer',
      'removeFileFromDecisionBranch'
    ]),

    handleDeleteButtonClick () {
      this.$swal({
        title: '本当に削除してよろしいですか？',
        text: 'この操作は取り消せません。',
        type: 'warning',
        showCancelButton: true
      }).then(() => {
        const { questionAnswerId, decisionBranchId } = this
        if (!isEmpty(questionAnswerId)) {
          this.removeFileFromQuestionAnswer({ questionAnswerId, answerFileId: this.answerFile.id })
            .catch(e => this.errorAlert())
        } else if (!isEmpty(decisionBranchId)) {
          this.removeFileFromDecisionBranch({ decisionBranchId, answerFileId: this.answerFile.id })
            .catch(e => this.errorAlert())
        }
      }).catch(this.$swal.noop)
    },

    handleItemClick () {
      window.open(this.answerFile.file.url)
    },

    errorAlert () {
      this.$swal({
        title: 'エラー',
        text: '削除できませんでした',
        type: 'error'
      })
    }
  }
}
</script>

<template>
  <div class="answer-file-item" @click="handleItemClick" :style="itemStyle">
    <div v-if="isImage" class="bg" :style="bgStyle" />
    <i v-if="!isImage" class="material-icons icon">insert_drive_file</i>
    <div class="name" :style="nameStyle">{{name}}</div>
    <button
      v-if="!isProcessing"
      class="delete"
      @click.stop="handleDeleteButtonClick"
    >
      <i class="material-icons">close</i>
    </button>
    <spinner v-if="isProcessing" />
  </div>
</template>

<style scoped lang="scss">
.answer-file-item {
  cursor: pointer;
  position: relative;
  display: inline-block;
  overflow: hidden;
  margin-right: 8px;
  padding: 20px;
  width: 140px;
  height: 140px;
  border-radius: 6px;
  border: 1px solid #ddd;
  vertical-align: top;
  background: {
    position: center center;
    repeat: no-repeat;
    size: cover;
  }

  &:hover {
    border-color: #1e8ecf;
    .delete {
      display: block;
    }
  }

  .bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: {
      size: cover;
      repeat: no-repeat;
      position: center center;
    }
    opacity: 0.9;
  }

  .icon {
    display: block;
    font-size: 63px;
    color: #ddd;
    text-align: center;
  }

  .name {
    position: absolute;
    left: 20px;
    right: 20px;
    bottom: 20px;
    color: #aaa;
    text-align: center;
    font-weight: bold;
    word-wrap: break-word;
    white-space: normal;
  }

  .delete {
    display: none;
    position: absolute;
    padding: 0;
    top: 2px;
    right: 2px;
    width: 24px;
    height: 24px;
    line-height: 24px;
    background-color: #ff4444;
    color: #fff;
    text-align: center;
    border: 0;
    border-radius: 12px;

    &:hover {
      background-color: #cf1e1e;
    }

    .material-icons {
      font-size: 16px;
    }
  }
}
</style>