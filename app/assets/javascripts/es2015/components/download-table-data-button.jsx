import React, { Component, PropTypes } from 'react';
import { findDOMNode } from 'react-dom';
import json2csv from 'json2csv';

const BOM = new Uint8Array([0xEF, 0xBB, 0xBF]);
const ContentType = { type: 'text/csv' };
const Fields = ['question', 'answer'];

export default class DownloadTableDataButton extends Component {
  static get componentName() {
    return "DownloadTableDataButton";
  }

  static get propTypes() {
    return {
      targetSelector: PropTypes.string.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      data: null,
    };
  }

  componentDidMount(){
    const { targetSelector } = this.props;
    const target = document.querySelector(targetSelector);
    if (target == null) { return; }

    const data = [].map.call(target.children, (tr) => {
      let row = {};
      [].forEach.call(tr.children, (td, i) => {
        return row[Fields[i]] = td.textContent;
      });
      return row;
    });
    const csv = json2csv({ data, fields: Fields });
    const blob = new Blob([BOM, csv], ContentType);

    this.setState({ data: blob });
  }

  render() {
    const { data } = this.state;

    return (
      <a
        href="#"
        ref="button"
        className="btn btn-success"
        onClick={this.onClickButton.bind(this)}
      >
        <i className="material-icons">file_download</i>
        {' '}
        CSVファイルダウンロード
      </a>
    );
  }

  onClickButton(e) {
    const { data } = this.state;
    const fileName = `bot-test-${ new Date().getTime() }.csv`;
    if (data == null) { return; }

    if (window.navigator.msSaveBlob) {
      window.navigator.msSaveBlob(data, fileName);
      // msSaveOrOpenBlobの場合はファイルを保存せずに開ける
      // window.navigator.msSaveOrOpenBlob(blob, "test.csv");
    } else {
      findDOMNode(this.refs.button).href = window.URL.createObjectURL(data);
    }
  }
}
