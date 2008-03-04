module Map = Map.Make(String)

let add file list = if List.mem file list then list else file::list

let dedup list = List.fold_right (fun s x -> add s x) list []

let file_deps file deps =
  if Map.mem file deps then Map.find file deps else []

let rec gather deps root =
  let shallow = file_deps root deps in
  let deep = List.rev_map (fun file -> file_deps file deps) shallow in
  dedup (List.rev_append shallow (List.flatten deep))

let analyze deps root =
  String.concat " " (List.rev (root :: gather deps root))
