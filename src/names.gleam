import argv
import gleam/erlang/process
import gleam/io
import glint
import internal/file_system
import internal/net/http
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  // io.println is the command output
  // 
  glint.run_and_handle(run(), argv.load().arguments, io.debug)
}

fn run() {
  glint.new()
  |> glint.group_flag([], port_flag())
  |> glint.add(at: ["serve"], do: serve())
}

fn serve() -> glint.Command(Nil) {
  use _, _, flags <- glint.command()
  let assert Ok(port) = glint.get_flag(flags, port_flag())

  wisp.configure_logger()
  // have this be set via an environment variable
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
    |> mist.port(port)
    |> mist.start_http

  process.sleep_forever()
}

fn port_flag() -> glint.Flag(Int) {
  glint.int_flag("port")
  |> glint.flag_default(8000)
  |> glint.flag_help("http listening port")
}
