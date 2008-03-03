let last_char str = String.get str (String.length str - 1)

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

let _ =
  try
    while true do
      let line = read_line_with_continue "" in
      let (file, deps) = split_dep_line line in
      print_endline file;
      print_endline (List.fold_left (fun s x -> s ^ "\t" ^ x ^ "\n") "" deps)
    done
  with End_of_file ->
    exit 0
