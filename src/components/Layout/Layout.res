@react.component
let make = (~children: React.element) => {
  let url = RescriptReactRouter.useUrl()

  let activeClass = (path: list<string>) => {
    if url.path == path {
      " active"
    } else {
      ""
    }
  }

  <>
    <header>
      <nav className="navbar navbar-expand-lg navbar-light bg-light">
        <div className="container">
          <Link className="navbar-brand" href="/"> {"Task"->React.string} </Link>
          <div className="">
            <ul className="navbar-nav mr-auto mb-2 mb-lg-0 flex-row">
              <li className="nav-item mr-2">
                <Link className={`nav-link${list{}->activeClass}`} href="/">
                  {"Home"->React.string}
                </Link>
              </li>
              <li className="nav-item">
                <Link className={`nav-link${list{"login"}->activeClass}`} href="/login">
                  {"Login"->React.string}
                </Link>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </header>
    <main className="container pt-5" style={ReactDOM.Style.make(~minHeight="80vh", ())}>
      {children}
    </main>
    <footer className="container d-flex justify-content-center">
      <p className="">
        {"Created by "->React.string}
        <a target="_blank" href="https://github.com/sakib412"> {"Najmus Sakib"->React.string} </a>
      </p>
    </footer>
  </>
}
