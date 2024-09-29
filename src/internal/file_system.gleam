import file_streams/file_stream.{type FileStream}
import file_streams/file_stream_error.{type FileStreamError, Enoent, Eof}
import gleam/iterator.{type Iterator, Done, Next}
import gleam/result
import gleam/string
import wisp

pub fn priv_directory(path: String) -> Result(String, FileStreamError) {
  wisp.priv_directory(path) |> result.replace_error(Enoent)
}

pub fn with_file_stream(
  path: String,
  with handle_file_stream: fn(FileStream) -> a,
) -> Result(a, FileStreamError) {
  use stream <- result.try(file_stream.open_read(path))
  let a = handle_file_stream(stream)
  use _ <- result.try(file_stream.close(stream))
  Ok(a)
}

pub fn to_iterator(
  stream: FileStream,
) -> Iterator(Result(String, FileStreamError)) {
  let yield = fn(acc) {
    case acc {
      Ok(line) ->
        Next(
          accumulator: stream |> file_stream.read_line,
          element: Ok(line |> string.trim_right),
        )
      Error(Eof) -> Done
      // any other error shall be handled?
      e -> Next(e, e)
    }
  }
  file_stream.read_line(stream) |> iterator.unfold(yield)
}

pub fn with_file_stream_iterator(
  path: String,
  // why not just return the right error here?
  with handle_iterator: fn(Iterator(Result(String, FileStreamError))) -> a,
) -> Result(a, Nil) {
  // cannot replace the result so not really a viable idea
  with_file_stream(path, fn(stream) { handle_iterator(stream |> to_iterator) })
  |> result.replace_error(Nil)
}
