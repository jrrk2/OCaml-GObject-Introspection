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

(** GIRepository — GObject Introspection repository manager module
  GIRepository is used to manage repositories of namespaces. Namespaces are
  represented on disk by type libraries (.typelib files).
*)

open Ctypes
open Foreign

type repository = unit ptr
let repository : repository typ = ptr void

type typelib = unit ptr
let typelib : typelib typ = ptr void

let get_default =
  foreign "g_irepository_get_default" (void @-> returning repository)

let require =
  foreign "g_irepository_require" (repository @-> string_opt @-> string_opt @-> int @->  void @-> returning typelib)

