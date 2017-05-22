import React, { Component } from "react";
import includes from "lodash/includes";
import last from "lodash/last";
import bytes from "bytes";

const ImageFileTypes = [
  "image/jpg",
  "image/jpeg",
  "image/png",
  "image/gif",
];

export default class AnswerFilePreview extends Component {
  render() {
    const { answerFile } = this.props;

    if (includes(ImageFileTypes, answerFile.fileType)) {
      return this.renderImage();
    } else {
      return this.renderLink();
    }
  }

  renderImage() {
    const { answerFile } = this.props;

    return (
      <div>
        <img src={answerFile.file.url} />
      </div>
    );
  }

  renderLink() {
    const { answerFile } = this.props;
    const fileName = last(answerFile.file.url.split("/"));

    return (
      <div>
        <a href={answerFile.file.url} target="_blank">{fileName}</a>
        <br />
        <small>ファイルタイプ：{answerFile.fileType}, ファイルサイズ：{bytes(answerFile.fileSize)}</small>
      </div>
    );
  }
}
