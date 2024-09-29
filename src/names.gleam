import gleam/erlang/process
import internal/file_system
import internal/net/http
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  // A context is constructed to hold the database connection.
  let assert Ok(priv) = file_system.priv_directory("names")
  let context = http.Context(priv)

  // The handle_request function is partially applied with the context to make
  // the request handler function that only takes a request.
  let assert Ok(_) =
    http.handle_request(_, context)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}
