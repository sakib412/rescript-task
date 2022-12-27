%%raw("/* eslint-disable react-hooks/exhaustive-deps */")

%%raw("import './App.css'")
%%raw("import './Task.css'")

module Window = {
  @scope("window") @val
  external alert: string => unit = "alert"
}
type task = {
  id: int,
  title: string,
  created_at: string,
  updated_at: string,
}

// here we only care about the data field
type tasks = {data: array<task>}
type createTaskRes = {data: task}

@scope("default") @module("axios") external axiosGet: string => Promise.t<tasks> = "get"

type newTask = {title: string}
@scope("default") @module("axios")
external axiosPost: (string, newTask) => Promise.t<createTaskRes> = "post"

@react.component
let make = () => {
  let (tasks, setTasks) = React.useState(() => [])
  let (title, setTitle) = React.useState(() => "")
  let (taskForm, setTaskForm) = React.useState(() => false)

  React.useEffect0(() => {
    open Promise
    let _ =
      axiosGet("http://localhost:3000/api/v1/tasks")
      ->then(res => {
        Js.log(res)
        setTasks(_ => res.data)
        res->resolve
      })
      ->catch(err => {
        Js.log(err)

        err->reject
      })

    None
  })

  let onTitleChange = e => {
    setTitle(_ => ReactEvent.Form.target(e)["value"])
  }

  let onSubmit = e => {
    e->ReactEvent.Form.preventDefault

    if title == "" {
      Window.alert("Title and body are required")
    } else {
      open Promise

      let _ =
        axiosPost("http://localhost:3000/api/v1/tasks", {title: title})
        ->then(res => {
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
    }
  }
  <div className="section">
    <h1 className="text-center"> {"Task list"->React.string} </h1>
    <div className="row d-flex justify-content-center container main">
      <div className="col-md-8">
        <div className="card-hover-shadow-2x mb-3 card">
          <div className="card-header-tab card-header">
            <div className="card-header-title font-size-lg text-capitalize font-weight-normal">
              <i className="fa fa-tasks mr-2" />
              <span>
                {"Task Lists"->React.string}
                {React.string(" (" ++ tasks->Belt.Array.length->Belt.Int.toString ++ ") ")}
              </span>
            </div>
          </div>
          <div className="scroll-area-sm">
            <div className="ps-show-limits">
              <div style={ReactDOM.Style.make(~position="static", ())} className="ps ps--active-y">
                <div className="ps-content">
                  <ul className="list-group list-group-flush">
                    <li className="list-group-item">
                      // <div className="todo-indicator bg-info" />
                      <div className="widget-content p-0">
                        <div className="widget-content-wrapper">
                          <div className="widget-content-left flex2 w-100">
                            {taskForm == true
                              ? <form className="d-flex" onSubmit>
                                  <input
                                    value={title}
                                    onChange={onTitleChange}
                                    className="form-control ml-1"
                                  />
                                  <div className="widget-content-right d-flex">
                                    <button
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
                    </li>
                    {tasks
                    ->Belt.Array.map(task => {
                      <li key={task.id->Belt.Int.toString} className="list-group-item">
                        <div className="todo-indicator bg-success" />
                        <div className="widget-content p-0">
                          <div className="widget-content-wrapper">
                            <div className="widget-content-left mr-2">
                              <div className="custom-checkbox custom-control">
                                <input
                                  className="custom-control-input"
                                  id="exampleCustomCheckbox10"
                                  type_="checkbox"
                                />
                                <label
                                  className="custom-control-label"
                                  htmlFor="exampleCustomCheckbox10">
                                  {" "->React.string}
                                </label>
                              </div>
                            </div>
                            <div className="widget-content-left flex2">
                              <div className="widget-heading"> {task.title->React.string} </div>
                              // <div className="widget-subheading">
                              //   {"By Charlie"->React.string}
                              // </div>
                            </div>
                            <div className="widget-content-right">
                              <button className="border-0 btn-transition btn btn-outline-success">
                                <i className="fa fa-check" />
                              </button>
                              <button className="border-0 btn-transition btn btn-outline-danger">
                                <i className="fa fa-trash" />
                              </button>
                            </div>
                          </div>
                        </div>
                      </li>
                    })
                    ->React.array}
                  </ul>
                </div>
              </div>
            </div>
          </div>
          <div className="d-flex justify-content-center card-footer">
            <button className="mr-2 btn btn-link btn-sm"> {"Cancel"->React.string} </button>
            <button className="btn btn-primary"> {"Add Task"->React.string} </button>
          </div>
        </div>
      </div>
    </div>
  </div>
}
