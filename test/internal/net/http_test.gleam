import gleam/dynamic
import gleam/json
import gleam/list
import gleeunit/should
import internal/file_system
import internal/net/http
import wisp/testing

type TestCase {
  HandleWords(path: String, want: Int)
}

pub fn handle_ready_test() {
  let request = testing.get("ready", [])
  let response = http.handle_request(request, http.Context(priv: ""))

  response.status
  |> should.equal(200)
}

pub fn handle_words_test() {
  let assert Ok(priv) = file_system.priv_directory("names")

  use testcase <- list.map([
    HandleWords(path: "teams", want: 200),
    HandleWords(path: "predicates", want: 422),
    HandleWords(path: "never", want: 400),
  ])

  let response =
    testing.get(testcase.path, [])
    |> http.handle_request(http.Context(priv))

  response.status
  |> should.equal(testcase.want)
}

pub fn handle_words_query_test() {
  let assert Ok(priv) = file_system.priv_directory("names")

  // bad request if invalid param
  let response =
    testing.get("teams?n=1", []) |> http.handle_request(http.Context(priv))

  response.status
  |> should.equal(200)
  // body to string
  testing.string_body(response)
  |> json.decode(dynamic.string |> dynamic.list)
  |> should.be_ok
  |> list.length
  |> should.equal(1)
}
