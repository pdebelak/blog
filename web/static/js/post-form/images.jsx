import React from 'react';

import { Submit } from './form-fields';

const defaultLabelText = 'Choose a file';

export function labelText(event) {
  if (!(event || event.target)) { return defaultLabelText; }
  const input = event.target;
  if (input.files && input.files.length > 1) {
    return `${input.files.length} files selected`;
  }
  return input.value.split('\\').pop() || defaultLabelText;
}

export default class extends React.Component {
  static get propTypes() {
    return {
      addImages: React.PropTypes.func.isRequired,
      images: React.PropTypes.arrayOf(React.PropTypes.object),
      csrfToken: React.PropTypes.string.isRequired,
      selectImage: React.PropTypes.func.isRequired,
    };
  }

  constructor() {
    super();

    this.state = {
      labelText: defaultLabelText,
    };
  }

  handleFormSubmit(e) {
    e.preventDefault();
    this.setState({ labelText: defaultLabelText });
    this.props.addImages(this.form);
  }

  updateLabelText(e) {
    this.setState({ labelText: labelText(e) });
  }

  get hasImages() {
    return !!this.props.images.length;
  }

  renderForm() {
    return (
      <section className="has-margin-bottom">
        <h1 className="subtitle">Upload new image</h1>
        <form
          onSubmit={e => this.handleFormSubmit(e)}
          encType="multipart/form-data"
          ref={(form) => { this.form = form; }}
        >
          <input name="_csrf_token" value={this.props.csrfToken} type="hidden" />
          <div className="columns is-mobile">
            <div className="column is-narrow">
              <input
                type="file"
                id="image_file"
                name="image[file][]"
                className="file-input"
                onChange={e => this.updateLabelText(e)}
                multiple
              />
              <label htmlFor="image_file" className="button">{this.state.labelText}</label>
            </div>
            <div className="column is-narrow">
              <Submit name="Upload" />
            </div>
          </div>
        </form>
      </section>
    );
  }

  renderImages() {
    if (!this.hasImages) { return null; }

    return (
      <section>
        <h1 className="subtitle">Select Image</h1>
        <div className="columns is-multiline is-mobile">
          {this.props.images.map(image =>
            <div key={image.id} className="column is-narrow">
              <a onClick={() => this.props.selectImage(image.full)}>
                <img src={image.thumb} role="presentation" />
              </a>
            </div>)
          }
        </div>
      </section>
    );
  }

  render() {
    return (
      <div>
        {this.renderForm()}
        {this.hasImages ? <hr /> : null}
        {this.renderImages()}
      </div>
    );
  }
}
