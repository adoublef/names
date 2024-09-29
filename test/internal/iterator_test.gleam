import gleam/iterator as std_iterator
import gleam/list
import gleeunit/should
import internal/iterator

pub fn try_to_list_until_test() {
  // we do not read beyond 3 values
  [Ok(1), Ok(2), Ok(3), Ok(4), Ok(5), Ok(6)]
  |> std_iterator.from_list
  |> iterator.try_to_list_until([1, 2])
  |> should.be_ok
  |> list.length
  |> should.equal(2)
}

pub fn try_to_list_until_err_test() {
  [Ok(1), Error(2), Ok(3), Ok(4), Ok(5), Ok(6)]
  |> std_iterator.from_list
  |> iterator.try_to_list_until([2])
  |> should.be_error
  |> should.equal(2)
}
