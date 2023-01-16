// Found this source here: https://github.com/DCKT/rescript-axios, but modified as need

type config

module Headers = {
  type t
  external fromObj: Js.t<{..}> => t = "%identity"
  external fromDict: Js.Dict.t<string> => t = "%identity"
}

module CancelToken = {
  type t
  @module("axios")
  external source: unit => t = "source"
}

type requestTransformer<'data, 'a, 'transformedData> = ('data, Js.t<'a>) => 'transformedData
type responseTransformer<'data, 'transformedData> = 'data => 'transformedData
type paramsSerializer<'params, 'serializedParams> = 'params => 'serializedParams
type auth = {
  username: string,
  password: string,
}
type proxy = {host: int, port: int, auth: auth}

type response<'data> = {
  data: 'data,
  status: int,
  statusText: string,
  headers: Js.Dict.t<string>,
  config: config,
}

type error<'responseData, 'request> = {
  request: option<'request>,
  response: option<response<'responseData>>,
  message: string,
}

@get external getErrorResponse: Js.Exn.t => option<response<'data>> = "response"

type adapter<'a, 'err> = config => Promise.t<response<'a>>

@module("axios")
external isAxiosError: error<'a, 'c> => bool = "isAxiosError"

@obj
external makeConfig: (
  ~url: string=?,
  ~_method: string=?,
  ~baseURL: string=?,
  ~transformRequest: array<requestTransformer<'data, Js.t<'a>, 'tranformedData>>=?,
  ~transformResponse: array<responseTransformer<'data, 'tranformedData>>=?,
  ~headers: Headers.t=?,
  ~params: Js.t<'params>=?,
  ~paramsSerializer: paramsSerializer<'params, 'serializedParams>=?,
  ~data: Js.t<'data>=?,
  ~timeout: int=?,
  ~withCredentials: bool=?,
  ~adapter: adapter<'a, 'err>=?,
  ~auth: auth=?,
  ~responseType: string=?,
  ~xsrfCookieName: string=?,
  ~xsrfHeaderName: string=?,
  ~onUploadProgress: 'uploadProgress => unit=?,
  ~onDownloadProgress: 'downloadProgress => unit=?,
  ~maxContentLength: int=?,
  ~validateStatus: int => bool=?,
  ~maxRedirects: int=?,
  ~socketPath: string=?,
  ~proxy: proxy=?,
  ~cancelToken: CancelToken.t=?,
  unit,
) => config = ""

type res = {
  data: Js.Dict.t<string>,
  status: int,
  statusText: string,
  headers: Js.Dict.t<string>,
  config: config,
}

type axiosInstance = {
  get: (string, ~config: config=?, unit) => Promise.t<res>,
  post: (string, ~data: Js.Dict.t<string>, unit) => Promise.t<res>,
  put: (string, ~data: Js.Dict.t<string>, ~config: config=?, unit) => Promise.t<res>,
  patch: (string, ~data: Js.Dict.t<string>, ~config: config=?, unit) => Promise.t<res>,
  delete: (string, ~config: config=?, unit) => Promise.t<res>,
  defaults: config,
}

@module("axios") @scope("default")
external create: {..} => axiosInstance = "create"

@module("axios") @scope("default")
external get: (string, ~config: config=?, unit) => Promise.t<response<'data>> = "get"

@module("axios") @scope("default")
external post: (string, ~data: 'a, ~config: config=?, unit) => Promise.t<response<'data>> = "post"

@module("axios") @scope("default")
external put: (string, ~data: 'a, ~config: config=?, unit) => Promise.t<response<'data>> = "put"

@module("axios")
external patch: (string, ~data: 'a, ~config: config=?, unit) => Promise.t<response<'data>> = "patch"

@module("axios") @scope("default")
external delete: (string, ~config: config=?, unit) => Promise.t<response<'data>> = "delete"

@module("axios")
external options: (string, ~config: config=?, unit) => Promise.t<response<'data>> = "options"

module Interceptors = {
  @module("axios") @scope(("default", "interceptors", "request"))
  external requestInterceptor: ('config => Promise.t<'updatedConfig>) => unit = "use"

  @module("axios") @scope(("default", "interceptors", "response"))
  external responseInterceptor: ('response => Promise.t<'updatedResponse>) => unit = "use"
}
