import React, { Component } from "react";
import includes from "lodash/includes";
import last from "lodash/last";
import merge from "lodash/merge";
import bytes from "bytes";

import ImageFileTypes from "../../modules/image-file-types";

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
    const baseStyle = { maxWidth: "320px", maxHeight: "320px" };
    const opacityStyle = answerFile.isDeleted ? { opacity: "0.4" } : {};
    const style = merge(baseStyle, opacityStyle);

    return (
      <div>
        <img src={answerFile.file.url} style={style} />
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
