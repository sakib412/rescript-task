type size = [#small | #middle | #large]

type fieldData = {
  errors: array<string>,
  name: array<string>,
  touched: bool,
  validating: bool,
  value: unit,
}

type col = {
  flex?: string, // TODO: should be string | int , don't know how to do it
  offset?: int,
  order?: int,
  pull?: int,
  push?: int,
  span?: int,
  // TODO: should be int | obj , don't know how to do it
  xs?: int,
  sm?: int,
  md?: int,
  lg?: int,
  xl?: int,
  xxl?: int,
}

type onFinishFailedProps = {
  errorFields: array<fieldData>,
  outOfDate: bool,
  values: Js.Json.t,
}

@module("antd") @react.component
external make: (
  ~children: React.element=?,
  ~className: string=?,
  ~layout: [#horizontal | #vertical | #inline]=?,
  ~colon: bool=?,
  ~disabled: bool=?,
  ~component: string=?, // TODO: should be React.componentType
  ~fields: array<fieldData>=?,
  ~name: string=?,
  ~labelCol: col=?,
  ~wrapperCol: col=?,
  ~initialValues: {..}=?, // TODO: copilot suggest me this, I am not sure if it is correct
  ~onFinish: {..} => unit=?,
  ~onFinishFailed: onFinishFailedProps => unit=?,
  ~size: size=?,
  ~autoComplete: string=?,
) => React.element = "Form"

module Item = FormItem
