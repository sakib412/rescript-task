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

type rules = {
  required?: bool,
  message?: string,
  whitespace?: bool,
  \"type"?: string,
  pattern?: Js.Re.t,
  enum?: array<unit>,
  len?: int,
  min?: int,
  max?: int,
  transform?: unit => unit,
  validator?: unit => bool,
}

type fieldType = [
  | #string
  | #number
  | #boolean
  | #method
  | #regexp
  | #integer
  | #float
  | #array
  | #url
  | #object
  | #enum
  | #date
  | #email
  | #hex
  | #any
]

@module("antd") @scope("Form") @react.component
external make: (
  ~children: React.element=?,
  ~colon: bool=?,
  ~disabled: bool=?,
  ~component: string=?, // TODO: should be React.componentType
  ~name: string=?,
  ~labelCol: col=?,
  ~wrapperCol: col=?,
  ~label: string=?,
  ~rules: array<rules>=?,
  ~valuePropName: string=?,
) => React.element = "Item"
