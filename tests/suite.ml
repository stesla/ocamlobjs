open OUnit

let suite = "OCaml Objs" >:::
  [Test_dependency.suite]

let _ = run_test_tt_main suite
