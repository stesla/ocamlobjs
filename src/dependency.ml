module Map = Map.Make(String)

let add file list = if List.mem file list then list else file::list

let analyze deps root =
  let rec analyze' deps acc =
    let fold_deps l f = if Map.mem f deps then (Map.find f deps)::l else l in
    let new_deps = List.fold_left fold_deps [] acc in
    let fold_acc l f = if List.mem f acc then l else f::l in
    let new_acc = List.fold_left fold_acc acc (List.flatten new_deps) in
    if new_acc = acc then acc else analyze' deps new_acc
  in
  String.concat " " (analyze' deps [root])
