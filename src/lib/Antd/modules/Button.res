type size = [#small | #middle | #large]

@module("antd") @react.component
external make: (
  ~children: React.element=?,
  ~block: bool=?,
  ~danger: bool=?,
  ~disabled: bool=?,
  ~ghost: bool=?,
  ~href: string=?,
  ~htmlType: string=?,
  ~icon: React.element=?,
  ~loading: bool=?,
  ~shape: string=?,
  ~size: size=?,
  ~target: string=?,
  ~\"type": string=?,
  ~onClick: ReactEvent.Mouse.t => unit=?,
) => React.element = "Button"
