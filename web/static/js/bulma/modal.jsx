import React from 'react';

export default ({ children, closeModal }) =>
  <div className="modal is-active">
    <div className="modal-background" onClick={closeModal} />
    <div className="modal-content">
      <div className="section">
        {children}
      </div>
    </div>
    <button className="modal-close" onClick={closeModal} />
  </div>;
