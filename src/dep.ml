module Set = Set.Make(
  struct
    type t = string * string list
    let compare x y = match (x,y) with ((x',_),(y',_)) -> compare x' y'
  end)
