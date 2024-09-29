import gleam/int

pub type Word {
  Collections
  Objects
  Predicates
  Teams
}

pub fn to_string(word: Word) -> String {
  case word {
    Collections -> "collections"
    Objects -> "objects"
    Predicates -> "predicates"
    Teams -> "teams"
  }
}

pub fn to_int(word: Word) -> Int {
  case word {
    Collections -> 70
    Objects -> 3064
    Predicates -> 1450
    Teams -> 130
  }
}

pub fn max(a: Word, b: Word) -> Int {
  int.max(a |> to_int, b |> to_int)
}

pub fn parse_string(input: String) -> Result(Word, Nil) {
  case input {
    "collections" -> Ok(Collections)
    "objects" -> Ok(Objects)
    "predicates" -> Ok(Predicates)
    "teams" -> Ok(Teams)
    _ -> Error(Nil)
  }
}
