let () =
  let namespace = "Gtk" in
  let repo = GIRepository.get_default () in
  let _ = GIRepository.require repo namespace in
  let info_10 = GIRepository.get_info repo namespace 10 in
  let info_20 = GIRepository.get_info repo namespace 20 in
  let name_10 = GIBaseInfo.get_name info_10 in
  print_endline ("GIBaseInfo i = 10 name : " ^ name_10);
  let name_20 = GIBaseInfo.get_name info_20 in
  print_endline ("GIBaseInfo i = 20 name : " ^ name_20)
