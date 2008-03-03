let rec read_line_with_continue str =
  let line = read_line () in
  let regexp = Str.regexp "^\\(.*\\)\\\\$" in
  if Str.string_match regexp line 0 then
    let new_str = str ^ (Str.matched_group 1 line) in
    read_line_with_continue new_str
  else
    str ^ line

exception Invalid

let split_dep_line str =
  match Str.split (Str.regexp ": ") str with
    [file; deps] -> (file, Str.split (Str.regexp "[ \t]+") deps)
  | _ -> raise Invalid

module S = Set.Make(
  struct
    type t = string * string list
    let compare x y = match (x,y) with ((x',_),(y',_)) -> compare x' y'
  end)

let rec parse_dependencies deps =
  try
    let line = read_line_with_continue "" in
    let dep = split_dep_line line in
    parse_dependencies (S.add dep deps)
  with End_of_file ->
    deps

let _ =
  let deps = parse_dependencies S.empty in
  let f x =
    match x with
      (dep, deps) ->
        print_endline dep;
        print_endline (List.fold_left (fun s x -> s ^ "\t" ^ x ^ "\n") "" deps)
  in
  S.iter f deps
