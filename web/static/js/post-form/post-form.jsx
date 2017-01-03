import React from 'react';

import { Input, TextArea, CheckBox, Submit } from './form-fields';

export default class extends React.Component {
  static get propTypes() {
    return {
      post: React.PropTypes.object.isRequired,
      action: React.PropTypes.string,
      errors: React.PropTypes.object.isRequired,
      title: React.PropTypes.string,
      description: React.PropTypes.string,
      body: React.PropTypes.string,
      tags: React.PropTypes.string,
      publish: React.PropTypes.bool,
      csrfToken: React.PropTypes.string.isRequired,
      changeField: React.PropTypes.func.isRequired,
      addImage: React.PropTypes.func.isRequired,
    };
  }

  get isUpdate() {
    return !!this.props.post.id;
  }

  get formAction() {
    if (this.isUpdate) {
      return `/admin/posts/${this.props.post.slug}`;
    }
    return '/admin/posts';
  }

  putField() {
    if (!this.isUpdate) { return null; }

    return <input name="_method" type="hidden" value="put" />;
  }

  errorFor(field) {
    if (!this.props.action) { return null; }

    return this.props.errors[field];
  }

  render() {
    return (
      <form action={this.formAction} method="post">
        {this.putField()}
        <input name="_csrf_token" value={this.props.csrfToken} type="hidden" />
        <Input
          name="post[title]"
          label="Title"
          error={this.errorFor('title')}
          inputProps={{
            value: this.props.title,
            onChange: e => this.props.changeField('title', e.target.value),
          }}
        />
        <Input
          name="post[slug]"
          label="Slug"
          error={this.errorFor('slug')}
          inputProps={{
            readOnly: true,
            defaultValue: this.props.post.slug,
            placeholder: 'Will be generated automatically',
          }}
        />
        <Input
          name="post[description]"
          label="Description"
          error={this.errorFor('description')}
          inputProps={{
            defaultValue: this.props.description,
            onChange: e => this.props.changeField('description', e.target.value),
          }}
        />
        <TextArea
          name="post[body]"
          label="Body"
          error={this.errorFor('body')}
          inputProps={{
            value: this.props.body,
            onChange: e => this.props.changeField('body', e.target.value),
          }}
        />
        <Input
          name="post[tags]"
          label="Tags"
          error={this.errorFor('tags')}
          inputProps={{
            value: this.props.tags,
            onChange: e => this.props.changeField('tags', e.target.value),
          }}
        />
        <CheckBox
          name="post[publish]"
          label="Publish"
          error={this.errorFor('publish')}
          inputProps={{
            checked: this.props.publish,
            onChange: e => this.props.changeField('publish', e.target.checked),
          }}
        />
        <Submit name="Submit" />
        &nbsp;
        <a onClick={() => this.props.addImage()} className="button">Add an Image</a>
      </form>
    );
  }
}
