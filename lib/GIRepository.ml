(** GIRepository — GObject Introspection repository manager module
  GIRepository is used to manage repositories of namespaces. Namespaces are
  represented on disk by type libraries (.typelib files).
*)
open GIBaseInfo

type repository
type typelib

(** Returns the singleton process-global default GIRepository. *)
external get_default:
  unit -> repository = "caml_g_irepository_get_default_c"

(** Force the namespace namespace_ to be loaded if it isn't already. If
 namespace_ is not loaded, this function will search for a ".typelib" file
 using the repository search path. ( TODO : In addition, a version version of
 namespace may be specified. If version is not specified, the latest will be used).
 *)
external require:
  repository -> string -> typelib = "caml_g_irepository_require_c"

(** Return an list of all (transitive) versioned dependencies for namespace_ .
 Returned strings are of the form namespace-version.
 Note: namespace_ must have already been loaded using a function such as
 GIRepository.require before calling this function. To get only the immediate
 dependencies for namespace_ , use GIRepository.get_immediate_dependencies.
 *)
external get_dependencies:
  repository -> string -> string list = "caml_g_irepository_get_dependencies_c"

(* TODO : Commented out because of GI Travis v. 1.40 and this function need v >= 1.44
 * external get_immediate_dependencies:
 *   repository -> string -> string list = "caml_g_irepository_get_immediate_dependencies_c" *)

(** This function returns the number of metadata entries in given namespace
 namespace_ . The namespace must have already been loaded before calling this
 function.
 *)
external get_n_infos:
  repository -> string -> int = "caml_g_irepository_get_n_infos_c"
external get_info:
  repository -> string -> int -> baseinfo option = "caml_g_irepository_get_info_c"
external get_loaded_namespaces:
  repository -> string list = "caml_g_irepository_get_loaded_namespaces_c"
external get_c_prefix:
  repository -> string -> string = "caml_g_irepository_get_c_prefix_c"
external enumerate_versions:
  repository -> string -> string list = "caml_g_irepository_enumerate_versions_c"
external prepend_library_path:
  string -> unit = "caml_g_irepository_prepend_library_path_c"
external prepend_search_path:
  string -> unit = "caml_g_irepository_prepend_search_path_c"
external get_shared_library:
  repository -> string -> string = "caml_g_irepository_get_shared_library_c"
external get_search_path:
  unit -> string list = "caml_g_irepository_get_search_path_c"
external get_typelib_path:
  repository -> string -> string = "caml_g_irepository_get_typelib_path_c"
external get_version:
  repository -> string -> string = "caml_g_irepository_get_version_c"
external find_by_name:
  repository option -> string -> string -> baseinfo option = "caml_g_irepository_find_by_name_c"
