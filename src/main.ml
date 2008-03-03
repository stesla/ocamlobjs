let _ =
  let deps = Parser.parse_dependencies Dependency.Set.empty in
  let f x =
    match x with
      (dep, deps) ->
        print_endline dep;
        print_endline (List.fold_left (fun s x -> s ^ "\t" ^ x ^ "\n") "" deps)
  in
  Dependency.Set.iter f deps
