exception Invalid_input of string

let rec read_line_with_continue str =
  let line = read_line () in
  let regexp = Str.regexp "^\\(.*\\)\\\\$" in
  if Str.string_match regexp line 0 then
    let new_str = str ^ (Str.matched_group 1 line) in
    read_line_with_continue new_str
  else
    str ^ line

let split_dep_line str =
  match Str.split (Str.regexp ": ") str with
    [file; deps] -> (file, Str.split (Str.regexp "[ \t]+") deps)
  | _ -> raise (Invalid_input str)

let is_object_file file =
  try
    Str.search_forward (Str.regexp "\\.cm[ox]$") file 0 <> 0
  with Not_found ->
    false

let rec parse_dependencies deps =
  try
    let line = read_line_with_continue "" in
    let (file, file_deps) = split_dep_line line in
    let filtered_deps = List.filter is_object_file file_deps in
    parse_dependencies (Dependency.Map.add file filtered_deps deps)
  with End_of_file ->
    deps
