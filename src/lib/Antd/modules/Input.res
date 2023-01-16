@module("antd") @react.component
external make: (~children: React.element=?, ~size: [#large | #middle | #small]=?) => React.element =
  "Input"

module Password = InputPassword
