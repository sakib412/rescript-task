%%raw("/* eslint-disable react-hooks/exhaustive-deps */")

@send external focus: Dom.element => unit = "focus"

let base_url: string = Env.apiUrl

type task = {
  id: int,
  title: string,
  status: option<string>,
  created_at: string,
  updated_at: string,
}

// here we only care about the data field
type tasks = {data: array<task>}
type createTaskRes = {data: task}
type newTask = {title: option<string>, status: option<string>}

module TaskItem = {
  @react.component
  let make = (~task: task, ~setTasks) => {
    let (loading, setLoading) = React.useState(() => false)
    let token = LocalStorage.getItem("token")

    let config = Axios.makeConfig(
      ~baseURL=base_url,
      ~headers=Axios.Headers.fromObj({
        "Authorization": "Bearer " ++ token->Belt.Option.getWithDefault(""),
      }),
      (),
    )

    let onTaskDelete = async taskId => {
      let conf = Window.confirm("Are you sure you want to delete this task?")
      if conf {
        let _ = await Axios.delete(`/tasks/` ++ taskId->Belt.Int.toString, ~config, ())
        "Task deleted!"->Antd.Message.success
        setTasks(prevState => {prevState->Belt.Array.keep(task => task.id != taskId)})
      } else {
        Js.log("Task not deleted")
      }
    }

    let updateTask = async task => {
      setLoading(_ => true)
      let res = await Axios.put(
        `/tasks/` ++ task.id->Belt.Int.toString,
        ~data={
          title: Some(task.title),
          status: task.status == Some("done") ? Some("done") : Some(""),
        },
        ~config,
        (),
      )
      setTasks(prevState => {
        prevState->Belt.Array.map(task =>
          task.id == res.data.id ? {...task, status: res.data.status} : task
        )
      })
      setLoading(_ => false)
    }
    <li key={task.id->Belt.Int.toString} className="list-group-item">
      <div
        className={`todo-indicator ${task.status == Some("done") ? "bg-success" : "bg-danger"}`}
      />
      <div className="widget-content p-0">
        <div className="widget-content-wrapper">
          <div className="widget-content-left mr-2">
            <div className="custom-checkbox custom-control">
              <input
                checked={task.status == Some("done")}
                onChange={_e => {
                  let _ = updateTask({
                    ...task,
                    status: task.status == Some("done") ? Some("") : Some("done"),
                  })
                }}
                className="custom-control-input"
                id={"task-" ++ task.id->Belt.Int.toString}
                type_="checkbox"
              />
              <label
                className="custom-control-label" htmlFor={"task-" ++ task.id->Belt.Int.toString}>
                {" "->React.string}
              </label>
            </div>
          </div>
          <div className="widget-content-left flex2">
            <div
              className="widget-heading"
              style={ReactDOM.Style.make(
                ~textDecoration=task.status == Some("done") ? "line-through" : "auto",
                (),
              )}>
              {task.title->React.string}
            </div>
          </div>
          <div className="widget-content-right">
            {task.status == Some("done")
              ? <button
                  disabled={loading}
                  onClick={_ => {
                    updateTask({...task, status: None})->ignore
                  }}
                  title="Mark as undone"
                  className="border-0 btn-transition btn btn-outline-warning">
                  <i className="fa fa-undo" />
                </button>
              : <button
                  disabled={loading}
                  onClick={_ => {
                    updateTask({...task, status: Some("done")})->ignore
                  }}
                  title="Mark as done"
                  className="border-0 btn-transition btn btn-outline-success">
                  <i className="fa fa-check" />
                </button>}
            <button
              title="Delete"
              onClick={_e => {
                onTaskDelete(task.id)->ignore
              }}
              className="border-0 btn-transition btn btn-outline-danger">
              <i className="fa fa-trash" />
            </button>
          </div>
        </div>
      </div>
    </li>
  }
}

@react.component
let make = () => {
  let (tasks, setTasks) = React.useState(() => [])
  let (title, setTitle) = React.useState(() => "")
  let (taskForm, setTaskForm) = React.useState(() => false)
  let (loading, setLoading) = React.useState(() => false)

  let titleInput = React.useRef(Js.Nullable.null)
  let token = LocalStorage.getItem("token")

  let config = Axios.makeConfig(
    ~baseURL=base_url,
    ~headers=Axios.Headers.fromObj({
      "Authorization": "Bearer " ++ token->Belt.Option.getWithDefault(""),
    }),
    (),
  )

  React.useEffect1(() => {
    if taskForm {
      switch titleInput.current->Js.Nullable.toOption {
      | Some(dom) => dom->focus
      | None => ()
      }
      None
    } else {
      None
    }
  }, [taskForm])

  React.useEffect0(() => {
    open Promise

    Axios.get(`/tasks`, ~config, ())
    ->then(res => {
      setTasks(_ => res.data)
      res->resolve
    })
    ->catch(err => {
      switch err {
      | Promise.JsError(jsExn) =>
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

    None
  })

  let onTitleChange = e => {
    setTitle(_ => ReactEvent.Form.target(e)["value"])
  }

  let onSubmit = e => {
    e->ReactEvent.Form.preventDefault
    setLoading(_ => true)

    if title == "" {
      Window.alert("Title and body are required")
    } else {
      open Promise

      Axios.post(`/tasks`, ~data={title: Some(title), status: None}, ~config, ())
      ->then(res => {
        "Task added successfully"->Antd.Message.success
        setTasks(prevState => Belt.Array.concat([res.data], prevState))
        setTitle(_ => "")
        res->resolve
      })
      ->catch(e => {
        switch e {
        | JsError(obj) =>
          switch Js.Exn.message(obj) {
          | Some(msg) => Js.log("Some JS error msg: " ++ msg)
          | None => Js.log("Must be some non-error value")
          }
        | _ => Js.log("Some unknown error")
        }
        e->reject
      })
      ->finally(_ => setLoading(_ => false))
      ->ignore
    }
  }

  <div>
    <h1 className="text-center">
      {"Task list"->React.string}
      {React.string(" (" ++ tasks->Belt.Array.length->Belt.Int.toString ++ ") ")}
    </h1>
    <div className="row d-flex justify-content-center container main">
      <div className="col-md-8">
        <div className="card-hover-shadow-2x mb-3 card">
          <div className="card-header-tab card-header">
            <div className="widget-content p-0">
              <div className="widget-content-wrapper">
                <div className="widget-content-left w-100">
                  {taskForm == true
                    ? <form className="d-flex mx-3" onSubmit>
                        <input
                          value={title}
                          ref={ReactDOM.Ref.domRef(titleInput)}
                          onChange={onTitleChange}
                          className="form-control ml-1"
                        />
                        <div className="widget-content-right d-flex">
                          <button
                            disabled={loading}
                            type_="submit"
                            className="ml-1 btn-transition btn btn-outline-success">
                            {"Add"->React.string}
                          </button>
                          <button
                            onClick={_e => {
                              setTaskForm(_ => false)
                            }}
                            className="ml-1 btn-transition btn btn-outline-danger">
                            {"Cancel"->React.string}
                          </button>
                        </div>
                      </form>
                    : <div className="d-flex justify-content-center">
                        <button
                          className="btn btn-primary "
                          onClick={_e => {
                            setTaskForm(_ => true)
                          }}>
                          {"Add new task"->React.string}
                        </button>
                      </div>}
                </div>
              </div>
            </div>
          </div>
          <div className="scroll-area-sm">
            <div className="ps-show-limits">
              <div style={ReactDOM.Style.make(~position="static", ())} className="ps ps--active-y">
                <div className="ps-content">
                  <ul className="list-group list-group-flush">
                    {tasks->Belt.Array.size == 0
                      ? <li className="list-group-item">
                          <div className="todo-indicator bg-warning" />
                          <div className="widget-content p-0">
                            <div className="widget-content-wrapper">
                              <div className="widget-content-left">
                                <div className="widget-heading">
                                  {"No tasks found"->React.string}
                                </div>
                              </div>
                            </div>
                          </div>
                        </li>
                      : tasks
                        ->Belt.Array.map(task => {
                          <TaskItem task key={Belt.Int.toString(task.id)} setTasks />
                        })
                        ->React.array}
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
}
