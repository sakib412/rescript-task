let base_url: string = Env.apiUrl

type signUpData = {
  full_name: option<string>,
  email: string,
  password: string,
  password_confirmation: string,
}

@react.component
let make = () => {
  let (loading, setLoading) = React.useState(_ => false)
  let onFinish = values => {
    setLoading(_ => true)
    open Promise
    let data: signUpData = {
      full_name: values["full_name"],
      email: values["email"],
      password: values["password"],
      password_confirmation: values["confirm_password"],
    }
    Axios.post(base_url ++ "/users", ~data, ())
    ->then(response => {
      "You have successfully signed up!, Please login now"->Antd.Message.success
      "/login"->RescriptReactRouter.push

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
    ->finally(_ => {
      setLoading(_ => false)
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
      <Antd.Form.Item label="Full name" name="full_name">
        <Antd.Input size=#large />
      </Antd.Form.Item>
      <Antd.Form.Item
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
      </Antd.Form.Item>
      <Antd.Form.Item
        label="Password"
        name="password"
        rules={[
          {
            required: true,
            message: "Please input your password!",
          },
        ]}>
        <Antd.Input.Password size=#large />
      </Antd.Form.Item>
      <Form.Item
        name="confirm_password"
        label="Confirm Password"
        dependencies={["password"]}
        hasFeedback=true
        rules={[
          {
            required: true,
            message: "Please confirm your password!",
          },
          %raw(`
           { getFieldValue }) => ({
              validator(_, value) {
                if (!value || getFieldValue('password') === value) {
                  return Promise.resolve();
                }
                return Promise.reject(new Error('The two passwords that you entered do not match!'));
              },
            }
             
             `),
        ]}>
        <Input.Password />
      </Form.Item>
      <Antd.Form.Item>
        <Antd.Button \"type"="primary" loading htmlType="submit" size=#large>
          {"Signup"->React.string}
        </Antd.Button>
      </Antd.Form.Item>
      {"Or "->React.string}
      <Link href="/login"> {" Login now!"->React.string} </Link>
    </Antd.Form>
  </div>
}
