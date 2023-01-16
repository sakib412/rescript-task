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
      email: values["username"],
      password: values["password"],
    }
    Axios.post(base_url ++ "/auth/login", ~data, ())
    ->then(response => {
      LocalStorage.setItem("token", response.data["token"])
      "/"->RescriptReactRouter.push
      setUser(response.data["user"])

      response->resolve
    })
    ->catch(err => {
      Js.log(err)
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
        label="Username"
        name="username"
        rules={[
          {
            required: true,
            message: "Please input your username!",
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
      <Link href=""> {" Register now!"->React.string} </Link>
    </Antd.Form>
  </div>
}
