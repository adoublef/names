import gleam/bool
import gleam/http.{Get}
import gleam/int
import gleam/iterator.{type Iterator} as std_iterator
import gleam/json
import gleam/list
import gleam/result
import internal/file_system
import internal/iterator
import internal/math
import internal/words
import wisp.{type Request, type Response}

pub type Context {
  Context(priv: String)
}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- middleware(req)

  case wisp.path_segments(req) {
    ["ready"] -> wisp.ok()
    [word] -> handle_words(req, ctx, word)
    _ -> wisp.not_found()
  }
}

fn handle_words(req: Request, ctx: Context, word: String) -> Response {
  use <- wisp.require_method(req, Get)
  // seems to be the idiom to handle all errors in a single scope and then
  // pattern match later
  let result = {
    use word <- result.try(
      word |> words.parse_string |> result.replace_error(BadRequest),
    )
    // note: cannot use Predicate
    use <- bool.guard(
      word == words.Predicates,
      return: Error(UnprocessableEntity),
    )
    use count <- result.try(
      wisp.get_query(req)
      |> list.key_find("n")
      |> result.unwrap(or: "1")
      |> int.parse
      |> result.replace_error(BadRequest),
    )
    // count must not be greater than the largest file count
    let predicates_count = words.Predicates |> words.to_int
    let word_count = word |> words.to_int
    // prevent bad numbers
    use <- bool.guard(
      when: count > int.min(word_count, predicates_count) || count < 0,
      return: Error(UnprocessableEntity),
    )
    // we always include the predicates but can I hide this?
    let predicate_positions = math.to_list_random(count, predicates_count)
    let words_positions = math.to_list_random(count, word_count)
    // we want: predicates-{teams|collections|objects}
    // i want to flatten this callback error
    use predicates, words <- do_with_file_stream2(ctx, word)
    // wish there was a try_map2 as asserting here is not very good
    let predicates = iterator.try_to_list_until(predicates, predicate_positions)
    let words = iterator.try_to_list_until(words, words_positions)
    // try_map2 would be nice here
    // if there are any errors I don't seem to be handling them here
    case predicates, words {
      Ok(predicates), Ok(words) -> {
        {
          use x, y <- list.map2(predicates, words)
          x <> "-" <> y
        }
      }
      _, _ -> []
    }
  }

  case result {
    Ok(result) -> {
      result
      |> json.array(of: json.string)
      |> json.to_string_builder
      |> wisp.json_response(200)
    }
    Error(error) -> handle_error(error)
  }
}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use req <- wisp.handle_head(req)

  handle_request(req)
}

type HttpError {
  BadRequest
  UnprocessableEntity
  InternalServerError
}

fn handle_error(error: HttpError) -> Response {
  case error {
    BadRequest -> wisp.bad_request()
    UnprocessableEntity -> wisp.unprocessable_entity()
    InternalServerError -> wisp.internal_server_error()
  }
}

fn do_with_file_stream2(
  ctx: Context,
  word: words.Word,
  with f: fn(
    Iterator(Result(String, HttpError)),
    Iterator(Result(String, HttpError)),
  ) ->
    a,
) -> Result(a, HttpError) {
  // may be possible to abstract furthure but no real purpose right now.
  {
    use predicates <- file_system.with_file_stream(
      ctx.priv <> "/words/" <> words.Predicates |> words.to_string <> ".txt",
    )

    let predicates =
      predicates
      |> file_system.to_iterator
      |> std_iterator.map(result.replace_error(_, InternalServerError))

    use words <- file_system.with_file_stream(
      ctx.priv <> "/words/" <> word |> words.to_string <> ".txt",
    )

    let words =
      words
      |> file_system.to_iterator
      |> std_iterator.map(result.replace_error(_, InternalServerError))

    f(predicates, words)
  }
  |> result.flatten
  |> result.replace_error(InternalServerError)
}
