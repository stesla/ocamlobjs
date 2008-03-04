let _ =
  let deps = Parser.parse_dependencies Dependency.Map.empty in
  print_endline (Dependency.analyze deps Sys.argv.(1))
