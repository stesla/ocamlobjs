include OUnit
include TestCase

let add = Dependency.Map.add
let empty = Dependency.Map.empty
let test expected deps root =
  assert_equal_string expected (Dependency.analyze deps root)

let suite = "Dependency Analyzer" >:::
  ["no deps" >::
   (fun () -> test "main.cmo" empty "main.cmo");

   "deps for other files" >::
   (fun () ->
     let deps = add "foo.cmo" ["bar.cmo"] empty in
     test "main.cmo" deps "main.cmo");

   "single level of deps" >::
   (fun () ->
     let deps = add "main.cmo" ["foo.cmo"; "bar.cmo"] empty in
     test "foo.cmo bar.cmo main.cmo" deps "main.cmo");

   "more deps" >::
   (fun () ->
     let deps = add "main.cmo" ["bar.cmo"; "foo.cmo"] empty in
     let deps = add "foo.cmo" ["bar.cmo"; "baz.cmo"] deps in
     test "bar.cmo baz.cmo foo.cmo main.cmo" deps "main.cmo");

   "deps with interfaces" >::
   (fun () ->
     let deps = add "main.cmo" ["bar.cmo"; "foo.cmi"] empty in
     let deps = add "foo.cmi" ["baz.cmo"] deps in
     let deps = add "foo.cmo" ["baz.cmo"; "foo.cmi"] deps in
     test "baz.cmo bar.cmo foo.cmo main.cmo" deps "main.cmo");

   "deeper tree" >::
   (fun () ->
     let deps = add "main.cmo" ["foo.cmo"] empty in
     let deps = add "foo.cmo" ["bar.cmo"] deps in
     let deps = add "bar.cmo" ["baz.cmo"] deps in
     let deps = add "baz.cmo" ["quux.cmo"] deps in
     test "quux.cmo baz.cmo bar.cmo foo.cmo main.cmo" deps "main.cmo")]


