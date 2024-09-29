import gleam/int
import gleam/set.{type Set} as std_set

pub fn to_list_random(count: Int, max: Int) -> List(Int) {
  // max must be greater else it wont work
  // count and max must be positive but can handle that later
  let assert True = count <= max
  std_set.new() |> do_insert_random(count, max) |> std_set.to_list()
}

fn do_insert_random(set: Set(Int), count: Int, max: Int) -> Set(Int) {
  case count {
    0 -> set
    _ -> {
      let random_int = int.random(max)
      let new_set = std_set.insert(set, random_int)
      // has the size grown?
      case std_set.size(new_set) > std_set.size(set) {
        True -> do_insert_random(new_set, count - 1, max)
        _ -> do_insert_random(set, count, max)
      }
    }
  }
}
