import gleam/list
import gleeunit/should
import internal/math

pub fn to_list_random_test() {
  math.to_list_random(3, 10) |> list.length |> should.equal(3)
}
