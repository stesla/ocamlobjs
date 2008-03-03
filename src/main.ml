let _ =
  let deps = Parse.parse_dependencies Dep.Set.empty in
  let f x =
    match x with
      (dep, deps) ->
        print_endline dep;
        print_endline (List.fold_left (fun s x -> s ^ "\t" ^ x ^ "\n") "" deps)
  in
  Dep.Set.iter f deps
