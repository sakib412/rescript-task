// Don't know how to create axiosninstance with token in the header  in the first place, tried this one but it didn't work
let base_url: string = Env.apiUrl

let config = {
  "baseURL": base_url,
  "timeout": 1000,
  "headers": {
    "Content-Type": "application/json",
  },
}

let axiosInstance = Axios.create(config)

let token = LocalStorage.getItem("token")

%%raw("
if (token) {
  axiosInstance.defaults.headers.common['Authorization'] = 'Bearer ' + token;
} else {
  delete axiosInstance.defaults.headers.common['Authorization'];
}
")
