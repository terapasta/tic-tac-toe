import React, { Component, PropTypes } from 'react';
import { withFormik } from 'formik';
import Yup from 'yup';
import toastr from 'toastr';
import isEmpty from 'is-empty';
import Cookies from 'js-cookie';
import get from 'lodash/get';

import * as GuestUserAPI from '../../api/guest-user';

import ChatRow from './row';
import ChatContainer from './container';

class Static extends Component {
  render() {
    const { name, email, onClickEditButton } = this.props;
    return (
      <div>
        <div className="form-group">
          以下の内容でユーザー情報を登録しています
        </div>
        <div className="form-group">
          <label>お名前</label>
          <p className="mb-0" style={{ fontSize: '16px' }}>{name}</p>
        </div>
        <div className="form-group">
          <label>メールアドレス</label>
          <p className="mb-0" style={{ fontSize: '16px' }}>
            {!isEmpty(email) && email}
            {isEmpty(email) && '未登録'}
          </p>
        </div>
        <div className="form-group mb-0 text-center">
          <button
            className="btn btn-secondary"
            onClick={onClickEditButton}
          >編集</button>
        </div>
      </div>
    );
  }
}

class Form extends Component {
  render() {
    const {
      values,
      touched,
      errors,
      handleChange,
      handleSubmit,
      isSubmitting,
      isPersisted,
      handleClickCancel,
    } = this.props;

    return (
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          チャット後のサポートに役立てるために、<br />以下の情報をご入力下さい（任意）
        </div>
        <div className="form-group">
          <label>お名前 <span className="text-danger">*</span></label>
          <input
            id="guest-user-name"
            type="text"
            name="name"
            className="form-control"
            onChange={handleChange}
            value={values.name}
          />
        {errors.name && (
            <div className="text-danger">{errors.name}</div>
          )}
        </div>
        <div className="form-group">
          <label>メールアドレス</label>
          <input
            id="guest-user-email"
            type="email"
            name="email"
            className="form-control"
            onChange={handleChange}
            value={values.email}
          />
          {touched.email && errors.email && (
            <div className="text-danger">{errors.email}</div>
          )}
        </div>
        <div className="form-group mb-0 text-center">
          <input
            id="guest-user-submit"
            type="submit"
            value="送信"
            className="btn btn-success"
            disabled={isSubmitting}
          />
          {isPersisted && (
            <button
              className="btn btn-link"
              onClick={handleClickCancel}
            >キャンセル</button>
          )}
        </div>
      </form>
    );
  }
}

const FormikForm = withFormik({
  mapPropsToValus: props => ({ name: '', email: '' }),
  validationSchema: Yup.object().shape({
    name: Yup.string().required('お名前は必須項目です'),
    email: Yup.string().email('メールアドレスの形式が正しくありません')
  }),
  handleSubmit(values, { props, setSubmitting }) {
    const { name, email } = values;
    const guestKey = Cookies.get('guest_key');
    let request, isCreate;

    if (props.isPersisted) {
      isCreate = false;
      request = GuestUserAPI.update(guestKey, { name, email });
    } else {
      isCreate = true;
      request = GuestUserAPI.create({ name, email });
    }

    request.then((res) => {
      setSubmitting(false);
      props.handleSaved(res.data.guestUser);
      if (isCreate && typeof props.handleRegistered === 'function') {
        props.handleRegistered();
      }
    }).catch((err) => {
      setSubmitting(false);
      const { errors, error } = err.response.data;
      const message = !isEmpty(errors) ? errors.join("\n") : error;
      toastr.error(message, 'エラー');
    });
  }
})(Form);

class GuestUserForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      guestUser: null,
      isLoading: false,
      isEditing: false,
    };
    this.handleClickEditButton = this.handleClickEditButton.bind(this);
    this.handleSaved = this.handleSaved.bind(this);
  }

  handleClickEditButton(e) {
    e.preventDefault();
    this.setState({ isEditing: true });
  }

  handleSaved(guestUser) {
    this.setState({ guestUser, isEditing: false });
    toastr.success('ユーザー情報を保存しました');
  }

  componentDidMount() {
    const guestKey = Cookies.get('guest_key');
    if (isEmpty(guestKey)) { return; }
    this.setState({ isLoading: true });

    GuestUserAPI.fetch(guestKey).then((res) => {
      this.setState({ isLoading: false });
      const { guestUser } = res.data;
      this.setState({ guestUser });
    }).catch((err) => {
      console.error(err);
      this.setState({ isLoading: false })
    });
  }

  render() {
    const { handleRegistered } = this.props;
    const { guestUser, isEditing, isLoading } = this.state;

    return (
      <div style={{ textAlign: 'left' }}>
        {isLoading && <div className="chat-guest-user-form">読み込み中...</div>}
        {(isEmpty(guestUser) || isEditing) && !isLoading && (
          <FormikForm
            isPersisted={!isEmpty(guestUser)}
            name={get(guestUser, 'name', '')}
            email={get(guestUser, 'email', '')}
            handleSaved={this.handleSaved}
            handleClickCancel={() => this.setState({ isEditing: false })}
            handleRegistered={handleRegistered}
          />
        )}
        {(!isEmpty(guestUser) && !isEditing && !isLoading) && (
          <Static
            name={guestUser.name}
            email={guestUser.email}
            onClickEditButton={this.handleClickEditButton}
          />
        )}
      </div>
    );
  }
}

GuestUserForm.propTypes = {
  handleRegistered: PropTypes.func,
};

export default GuestUserForm;
