switch ReactDOM.querySelector("#root") {
| Some(rootElement) => {
    let root = ReactDOM.Client.createRoot(rootElement)
    ReactDOM.Client.Root.render(
      root,
      <React.StrictMode>
        <App />
      </React.StrictMode>,
    )
  }

| None => ()
}
