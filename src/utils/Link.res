@react.component
let make = (~children: React.element, ~href: string="#", ~className: string="") => {
  let onClick = (e: ReactEvent.Mouse.t) => {
    e->ReactEvent.Mouse.preventDefault
    href->RescriptReactRouter.push
  }
  <a href className onClick> {children} </a>
}
