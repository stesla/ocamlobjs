module Map = Map.Make(String)

let add file list = if List.mem file list then list else file::list

let dedup list = List.fold_right (fun s x -> add s x) list []

let file_deps deps file = 
  if Map.mem file deps then Map.find file deps else []

let object_file file =
  Str.replace_first (Str.regexp "\\.cmi$") ".cmo" file

let rec gather deps root =
  let shallow = file_deps deps (object_file root) in
  let filtered = List.filter (fun file -> (object_file file) <> (object_file root)) shallow in
  let deep = List.rev_map (fun file -> gather deps file) filtered in
  let result = (List.rev_append filtered (List.flatten deep)) in
  dedup (List.map (fun f -> object_file f) result)

let analyze deps root =
  String.concat " " (List.rev (root :: gather deps root))
