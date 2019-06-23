<script>
import bytes from 'bytes'

export default {
  props: {
    answerFile: { type: Object, required: true },
  },

  computed: {
    isImage () {
      return this.answerFile.fileType.indexOf('image') > -1
    },

    fileUrl () {
      return this.answerFile.file.url
    },

    fileName () {
      return this.fileUrl.split('/').reverse()[0]
    },

    fileSize () {
      return bytes(this.answerFile.fileSize)
    }
  }
}
</script>

<template>
  <figure class="item" :class="{ image: isImage }">
    <a v-if="isImage" :href="fileUrl" target="_blank">
      <img :src="fileUrl" />
    </a>
    <div v-if="!isImage" class="bot-message-body">
      <p>
        <a
          class="file-link"
          :href="answerFile.file.url"
          target="_blank"
        >
          {{fileName}}
        </a>
      </p>
      <span class="badge badge-info">{{answerFile.fileType}}</span>
      <span class="badge badge-info">{{fileSize}}</span>
    </div>
  </figure>
</template>

<style lang="scss" scoped>
@import './css/gradient';

.item {
  @include blue-gradient;
  box-shadow: 0 16px 24px -8px rgba(94,185,255,0.2);
  display: inline-block;
  max-width: 200px;
  height: 140px;
  margin: 0 16px 0 0;
  border-radius: 6px;
  padding: 12px;
  color: #fff;
  word-break: break-all;
  white-space: normal;
  vertical-align: top;
  -webkit-overflow-scrolling: touch;

  &.image {
    padding: 0;
  }

  img {
    max-height: 100%;
    border-radius: 4px;
  }

  .file-link {
    color: #fff;
  }
}
</style>
