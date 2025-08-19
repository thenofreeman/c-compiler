(* OCC - The OCaml-to-C Compiler *)

let is_flag arg = String.get arg 0 = '-'

let print_err code str =
  print_endline str;
  exit code

let delete_file filename =
  (try Sys.remove filename with 
    | Sys_error e -> Printf.eprintf "Error deleting file: %s\n" e)

let run_driver input_filename flag =
  let _ = flag in 

  (* TODO: check flag for --lex --parse --codegen *)

  let output_filename = Filename.chop_extension input_filename in

  let pp_filename = output_filename ^ ".i" in

  let preprocess_cmd = Printf.sprintf "gcc -E -P %s -o %s" input_filename pp_filename in
  let preprocess_status = Sys.command preprocess_cmd in

  if preprocess_status <> 0 then print_err 1 "Preprocessing failed.";

  (* TODO: Compile the preprocessed file here first *)

  let asm_filename = output_filename ^ ".s" in

  (delete_file pp_filename);

  let link_cmd = Printf.sprintf "gcc %s -o %s" asm_filename output_filename in
  let link_status = Sys.command link_cmd in

  (delete_file asm_filename);

  if link_status <> 0 then print_err 1 "Linking failed.";

  ()

let () =
  let argc = Array.length Sys.argv - 1 in
 
  match argc with
  | 0 -> print_err 1 "Filename expected."
  | 1 -> if is_flag Sys.argv.(1) then print_err 1 "Filename expected. Given flag."
         else run_driver Sys.argv.(1) ""
  | 2 -> if is_flag Sys.argv.(1) then run_driver Sys.argv.(2) Sys.argv.(1)
         else print_err 1 "Bad argument order."
  | _ -> print_err 1 "Too many arguments."
