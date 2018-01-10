import React, { Component } from 'react';
import PropTypes from 'prop-types';
import isEmpty from 'is-empty';
import bindAll from 'lodash/bindAll';
import copyToClipboard from 'copy-to-clipboard';

const makeCode = (token, width, height) => {
  const { protocol, host } = window.location;
  const origin = `${protocol}//${host}`;
  const src = `${origin}/embed/${token}/chats`;
  const w = isEmpty(width) ? 0 : width;
  const h = isEmpty(height) ? 0 : height;
  return `<iframe width="${w}" height="${h}" src="${src}" style="border: 1px solid #c0c0c0;" allowfullscreen></iframe>`;
};

class EmbedCodeGenerator extends Component {
  constructor(props) {
    super(props);
    this.state = {
      width: 750,
      height: 500,
      isCopied: false,
    };
    bindAll(this, ['handleClickCopyButton']);
  }

  componentWillUnmount() {
    clearTimeout(this.timeID);
  }

  handleClickCopyButton(e) {
    e.preventDefault();
    const { width, height } = this.state;
    const code = makeCode(this.props.token, width, height);
    if (window.clipboardData) {
      window.clipboardData.setData('Text', code);
    } else {
      copyToClipboard(code);
    }
    this.setState({ isCopied: true });
    this.timerID = setTimeout(() => {
      this.setState({ isCopied: false });
    }, 5000);
  }

  render() {
    const {
      width,
      height,
      isCopied,
    } = this.state;

    return (
      <div>
        <div className="form-group">
          <label>高さ</label>
          <input
            className="form-control"
            type="number"
            value={height}
            onChange={e => this.setState({ height: e.target.value })}
          />
        </div>
        <div className="form-group">
          <label>横幅</label>
          <input
            className="form-control"
            type="number"
            value={width}
            onChange={e => this.setState({ width: e.target.value })}
          />
        </div>
        <div className="form-group">
          <label>埋め込みコード</label>
          <textarea
            className="form-control"
            name="embed"
            readOnly
            rows={4}
            ref={(node) => { this.textArea = node; }}
            onFocus={() => this.textArea.select()}
            value={makeCode(this.props.token, width, height)}
          />
        </div>
        <button
          className="btn btn-secondary"
          onClick={this.handleClickCopyButton}
        >
          <i className="material-icons">content_copy</i>
          <span>クリップボードにコピー</span>
        </button>
        &nbsp;
        {isCopied && <span className="text-success">コピーしました</span>}
      </div>
    );
  }
}

EmbedCodeGenerator.componentName = 'EmbedCodeGenerator';
EmbedCodeGenerator.propTypes = {
  token: PropTypes.string.isRequired,
};

export default EmbedCodeGenerator;
