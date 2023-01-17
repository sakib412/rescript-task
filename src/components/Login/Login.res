%%raw("import './Login.css'")
let base_url: string = Env.apiUrl

type loginData = {
  email: string,
  password: string,
}

@react.component
let make = (~setUser) => {
  let onFinish = values => {
    open Promise
    let data: loginData = {
      email: values["email"],
      password: values["password"],
    }
    Axios.post(base_url ++ "/auth/login", ~data, ())
    ->then(response => {
      "Login success"->Antd.Message.success
      LocalStorage.setItem("token", response.data["token"])
      "/"->RescriptReactRouter.push
      setUser(response.data["user"])

      response->resolve
    })
    ->catch(err => {
      switch err {
      | JsError(jsExn) =>
        switch jsExn->Axios.getErrorResponse {
        | Some(response) =>
          response.data["errors"]->Belt.Array.forEach(error => {
            Antd.Message.error(error)
          })

          ignore("")

        | None =>
          Antd.Message.error(Js.Exn.message(jsExn)->Belt.Option.getWithDefault("Unknown error"))
        }

      | _ => Js.log("Not a JS error")
      }
      err->reject
    })
    ->ignore
  }

  <div className="">
    <Antd.Form
      name="login"
      onFinish={onFinish}
      className="login-form mx-auto"
      autoComplete="off"
      layout=#vertical>
      <Form.Item
        label="Email"
        name="email"
        rules={[
          {
            required: true,
            message: "Please input your username!",
          },
          {
            \"type": "email",
            message: "The input is not valid E-mail!",
          },
        ]}>
        <Input size=#large />
      </Form.Item>
      <Form.Item
        label="Password"
        name="password"
        rules={[
          {
            required: true,
            message: "Please input your password!",
          },
        ]}>
        <Input.Password size=#large />
      </Form.Item>
      <Form.Item>
        <Antd.Button \"type"="primary" htmlType="submit" size=#large>
          {"Login"->React.string}
        </Antd.Button>
      </Form.Item>
      {"Or "->React.string}
      <Link href="/signup"> {" Register now!"->React.string} </Link>
    </Antd.Form>
  </div>
}
