import gleeunit/should
import internal/file_system

pub fn with_file_test() {
  let assert Ok(priv) = file_system.priv_directory("names")

  let noop = fn(stream) { stream }
  file_system.with_file_stream(priv <> "/testdata/hello.txt", noop)
  |> should.be_ok
}
