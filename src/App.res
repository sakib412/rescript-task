%%raw("/* eslint-disable react-hooks/exhaustive-deps */")

%%raw("import './App.css'")
%%raw("import './Task.css'")

@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  let (user, setUser) = React.useState(_ => Js.Obj.empty())

  let token = LocalStorage.getItem("token")

  let config = Axios.makeConfig(
    ~baseURL=Env.apiUrl,
    ~headers=Axios.Headers.fromObj({
      "Authorization": "Bearer " ++ token->Belt.Option.getWithDefault(""),
    }),
    (),
  )

  React.useEffect0(() => {
    open Promise
    Axios.get("/auth/me", ~config, ())
    ->then(res => {
      setUser(_ => res.data)
      RescriptReactRouter.push("/")

      res->resolve
    })
    ->catch(err => {
      switch err {
      | JsError(jsExn) =>
        switch jsExn->Axios.getErrorResponse {
        | Some(response) =>
          if response.status == 401 {
            LocalStorage.removeItem("token")
            RescriptReactRouter.push("/login")
          }
        | None => Js.log(Js.Exn.message(jsExn))
        }
      | _ => Js.log("Not a JS error")
      }

      err->reject
    })
    ->ignore
    Some(
      () => {
        setUser(_ => Js.Obj.empty())
      },
    )
  })

  let comp = switch url.path {
  | list{"login"} => <Login setUser />
  | list{} => <Task />
  | _ => <PageNotFound />
  }

  <Layout user={user} setUser> {comp} </Layout>
}
