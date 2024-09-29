import gleam/iterator.{type Iterator}
import gleam/list
import gleam/pair
import gleam/result

pub fn try_to_list_until(
  iterator: Iterator(Result(a, b)),
  with positions: List(Int),
) -> Result(List(a), b) {
  iterator
  |> iterator.fold_until(#(0, Ok([])), fn(acc, x) {
    case x {
      Error(e) -> list.Stop(#(0, Error(e)))
      Ok(a) -> {
        let #(index, value) = acc
        let index = index + 1
        case value {
          Ok(lines) -> {
            case list.length(lines) >= list.length(positions) {
              True -> list.Stop(acc)
              False -> {
                case list.contains(positions, index - 1) {
                  False -> list.Continue(#(index, value))
                  _ -> {
                    list.Continue(#(
                      index,
                      result.try(value, fn(x) { Ok(list.append(x, [a])) }),
                    ))
                  }
                }
              }
            }
          }
          Error(e) -> list.Stop(#(0, Error(e)))
        }
      }
    }
  })
  |> pair.second
}
