import React from 'react';

import request, { postForm } from './request';
import Tabs from './post-form/tabs';
import PostForm from './post-form/post-form';
import Modal from './bulma/modal';
import Images from './post-form/images';

const WRITE = 'Write';
const PREVIEW = 'Preview';

const tabNames = [WRITE, PREVIEW];

export default class extends React.Component {
  static get propTypes() {
    return {
      changeset: React.PropTypes.object.isRequired,
      csrfToken: React.PropTypes.string.isRequired,
    };
  }

  constructor(props) {
    super(props);

    this.state = {
      activeTab: tabNames[0],
      title: this.props.changeset.post.title || '',
      body: this.props.changeset.post.body || '',
      tags: this.props.changeset.post.tags || '',
      publish: this.props.changeset.post.publish || false,
    };
  }

  fetchPreview() {
    const data = {
      _csrf_token: this.props.csrfToken,
      post: {
        title: this.state.title,
        body: this.state.body,
        tags: this.state.tags,
      },
    };
    return request('/admin/post-preview', {
      method: 'POST',
      data: JSON.stringify(data),
      contentType: 'application/json',
    }).then(response => this.setState({ preview: response }))
      .catch(() => this.setState({ preview: '<div class="notification is-danger has-margin-bottom">Sorry, something went wrong generating your preview</div>' }));
  }

  tabChanged(newTab) {
    if (newTab === PREVIEW) {
      this.fetchPreview().then(() => this.setState({ activeTab: newTab }));
    } else {
      this.setState({ activeTab: newTab });
    }
  }

  addImage() {
    request('/admin/images').then((response) => {
      this.setState({ showModal: true, images: JSON.parse(response) });
    });
  }

  addImages(form) {
    postForm('/admin/images', form)
      .then(() => this.addImage());
  }

  selectImage(imageUrl) {
    this.setState({
      body: `${this.state.body}\n\n![Image](${imageUrl})`,
      showModal: false,
    });
  }

  renderTabs() {
    return (
      <Tabs
        tabNames={tabNames}
        active={this.state.activeTab}
        tabClicked={tab => this.tabChanged(tab)}
      />
    );
  }

  renderForm() {
    if (this.state.activeTab !== WRITE) { return null; }
    return (
      <PostForm
        action={this.props.changeset.action}
        post={this.props.changeset.post}
        title={this.state.title}
        body={this.state.body}
        tags={this.state.tags}
        publish={this.state.publish}
        errors={this.props.changeset.errors}
        csrfToken={this.props.csrfToken}
        changeField={(field, value) => this.setState({ [field]: value })}
        addImage={() => this.addImage()}
      />
    );
  }

  renderPreview() {
    if (this.state.activeTab !== PREVIEW) { return null; }
    if (!this.state.preview) { return <p>loading...</p>; }
    return (
      <div
        onClick={e => e.preventDefault()}
        dangerouslySetInnerHTML={{ __html: this.state.preview }}
      />
    );
  }

  renderModal() {
    if (!this.state.showModal) { return null; }
    return (
      <Modal closeModal={() => this.setState({ showModal: false })}>
        <Images
          images={this.state.images}
          selectImage={imageUrl => this.selectImage(imageUrl)}
          csrfToken={this.props.csrfToken}
          addImages={form => this.addImages(form)}
        />
      </Modal>
    );
  }

  render() {
    return (
      <div>
        {this.renderTabs()}
        {this.renderForm()}
        {this.renderPreview()}
        {this.renderModal()}
      </div>
    );
  }
}
