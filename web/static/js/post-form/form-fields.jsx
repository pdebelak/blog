import React from 'react';

function renderError(error) {
  if (!error) { return null; }

  return <span className="help is-danger">{error}</span>;
}

export const Input = ({ name, label, error, inputProps }) =>
  <Field
    name={name}
    label={label}
    error={error}
  >
    <input className="input" type="text" name={name} {...inputProps} />
  </Field>;

export const TextArea = ({ name, label, error, inputProps }) =>
  <Field
    name={name}
    label={label}
    error={error}
  >
    <textarea className="textarea" name={name} {...inputProps} />
  </Field>;

const Field = ({ name, label, error, children }) =>
  <FieldWrapper>
    <label className="label" htmlFor={name}>{label}</label>
    {children}
    {renderError(error)}
  </FieldWrapper>;

export const CheckBox = ({ name, label, error, inputProps }) =>
  <FieldWrapper>
    <label className="checkbox" htmlFor={name}>
      <input name={name} type="hidden" value="false" />
      <input className="checkbox" name={name} type="checkbox" value="true" {...inputProps} />
      &nbsp;{label}
    </label>
  </FieldWrapper>;

export const Submit = ({ name }) =>
  <button className="button is-primary" type="submit">{name}</button>;

const FieldWrapper = ({ children }) =>
  <p className="control">{children}</p>;
