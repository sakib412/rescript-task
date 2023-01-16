%%raw("import './App.css'")
%%raw("import './Task.css'")

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  let comp = switch url.path {
  | list{"login"} => <Login />
  | list{} => <Task />
  | _ => <PageNotFound />
  }

  <Layout> {comp} </Layout>
}
