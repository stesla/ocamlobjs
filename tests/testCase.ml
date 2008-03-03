let assert_equal_bool expected actual =
  OUnit.assert_equal ?printer:(Some string_of_bool) expected actual

let assert_equal_string expected actual =
  OUnit.assert_equal ?printer:(Some (fun s -> s)) expected actual

let assert_equal_char expected actual =
  OUnit.assert_equal ?printer:(Some (fun c -> String.make 1 c)) expected actual

let assert_equal_int expected actual =
  OUnit.assert_equal ?printer:(Some (fun i -> string_of_int i)) expected actual
