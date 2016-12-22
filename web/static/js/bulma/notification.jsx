import React from 'react';

export default class extends React.Component {
  static get propTypes() {
    return {
      notificationClass: React.PropTypes.string.isRequired,
      content: React.PropTypes.string.isRequired,
    };
  }

  constructor() {
    super();

    this.state = {
      dismissed: false,
    };
  }

  render() {
    if (this.state.dismissed) { return null; }

    return (
      <div className={`notification ${this.props.notificationClass}`}>
        <button className="delete" onClick={() => this.setState({ dismissed: true })} />
        <div className="container">
          {this.props.content}
        </div>
      </div>
    );
  }
}
