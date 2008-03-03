open OUnit

let suite = "OCaml Objs" >:::
  [Test_deps.suite]

let _ = run_test_tt_main suite
