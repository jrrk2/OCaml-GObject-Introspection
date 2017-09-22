(*
 * Copyright 2017 Cedric LE MOIGNE, cedlemo@gmx.com
 * This file is part of OCaml-GObject-Introspection.
 *
 * OCaml-GObject-Introspection is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * OCaml-GObject-Introspection is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OCaml-GObject-Introspection.  If not, see <http://www.gnu.org/licenses/>.
 *)

open Test_utils
open OUnit2
open GObject_introspection

let test_escape_OCaml_keywords test_ctxt =
  let escaped = Binding_utils.escape_OCaml_keywords "end" in
  assert_equal_string "_end" escaped

let test_escape_OCaml_types test_ctxt =
  let escaped = Binding_utils.escape_OCaml_types "int" in
  assert_equal_string "_int" escaped

let test_escape_Ctypes_types test_ctxt =
  let escaped = Binding_utils.escape_Ctypes_types "double" in
  assert_equal_string "_double" escaped

let test_escape_number_at_beginning test_ctxt =
  let escaped = Binding_utils.escape_number_at_beginning "3D" in
  assert_equal_string "_3D" escaped

let test_ensure_valid_variable_name test_ctxt =
  let rec test = function
    | [] -> ()
    | h :: q -> let reference = "_" ^ h in
    let escaped = Binding_utils.ensure_valid_variable_name h in
    assert_equal_string reference escaped
  in test ["end"; "int"; "double"; "3D"]

let test_lexer_snake_case test_ctxt =
  let values = [
    ("CapitalizedSnakeCase", "Capitalized_snake_case");
    ("CAPITALizedSnakeCASe", "CAPITALized_snake_case");
    ("", "");
    ("Ca", "Ca");
    ("IOChannel", "IOChannel");
    ("PollFD", "Poll_fd");
    ("SList", "SList");
    ("IConv", "IConv");
    ("MemVTable", "Mem_vtable");
    ("DoubleIEEE754", "Double_ieee754");
  ] in
  let rec _check = function
    | [] -> ()
    | (str_to_test, str_result) :: values'->
        let str_result' = Lexer.snake_case str_to_test in
        let _ = assert_equal_string str_result str_result' in
        _check values'
  in _check values

let test_string_pattern_remove test_ctxt =
  let values = [
    ("pattern", "pattern", "");
    ("__pattern", "pattern", "__");
    ("__pattern__pattern", "pattern", "____");
    ] in
  List.iter (fun (str, pattern, expected) ->
    let ret = Binding_utils.string_pattern_remove str pattern in
    assert_equal_string expected ret
  ) values

module UFile = Binding_utils.File

let test_file_create test_ctxt =
  let filename = "test_file" in
  let test_f = UFile.create filename in
  let test_f_name = UFile.name test_f in
  let _ = assert_equal_string filename test_f_name in
  let _ = assert_file_exists test_f_name in
  let _ = UFile.close test_f in
  Sys.remove filename

let test_file_write_open_module test_ctxt =
  let filename = "test_file1" in
  let test_f = UFile.create filename in
  let _ = UFile.write_open_module test_f "A_module" in
  let _ = UFile.close test_f in
  let expected_content = "open A_module" in
  let _ = check_file_and_content filename expected_content in
  Sys.remove filename

let test_file_create_sources test_ctxt =
  let filename = "test_file2" in
  let sources = UFile.create_sources filename in
  let _ = assert_file_exists @@ filename ^ ".ml" in
  let _ = assert_file_exists @@ filename ^ ".mli" in
  let _ = Sys.remove @@ filename ^ ".ml" in
  Sys.remove @@ filename ^ ".mli"

let test_file_create_ctypes_sources test_ctxt =
  let filename = "test_file3" in
  let sources = UFile.create_ctypes_sources filename in
  let _ = UFile.close_sources sources in
  let mli_file = filename ^ ".mli" in
  let ml_file =  filename ^ ".ml" in
  let mli_content = "open Ctypes\n" in
  let ml_content = "open Ctypes\nopen Foreign\n" in
  let _ = check_file_and_content mli_file mli_content in
  let _ = check_file_and_content ml_file ml_content in
  let _ = Sys.remove @@ filename ^ ".ml" in
  Sys.remove @@ filename ^ ".mli"


let tests =
  "GObject Introspection Binding_utils tests" >:::
  [
    "Test escape OCaml keywords" >:: test_escape_OCaml_keywords;
    "Test escape OCaml types" >:: test_escape_OCaml_types;
    "Test escape Ctypes types" >:: test_escape_Ctypes_types;
    "Test escape number at beginning" >:: test_escape_number_at_beginning;
    "Test ensure valid variable name" >:: test_ensure_valid_variable_name;
    "Test lexer snake case" >:: test_lexer_snake_case;
    "Test remove" >:: test_string_pattern_remove;
    "Test file create" >:: test_file_create;
    "Test file write open module" >:: test_file_write_open_module;
    "Test file create sources" >:: test_file_create_sources;
    "Test file create ctypes sources" >:: test_file_create_ctypes_sources
  ]
