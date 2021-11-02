let read_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

let preprocess_input l =
  let lines = String.split_on_char '\n' l in
  List.map (fun l -> List.map int_of_string (String.split_on_char 'x' l)) lines

let listmin l =
  let rec aux cur = function
  | [] -> cur
  | h::t -> aux (Stdlib.min h cur) t in
  aux (List.hd l) l

let rec part1 l =
  let single = function
    | a::b::c::[] -> 2*(a*b+b*c+a*c)+(listmin [a*b; b*c; a*c])
    | _ -> 0 in
  List.fold_left (fun acc x -> acc + single x) 0 l

let part2 l =
  let single = function
    | a::b::c::[] -> a*b*c+(listmin [2*(a+b); 2*(b+c); 2*(a+c)])
    | _ -> 0 in
  List.fold_left (fun acc x -> acc + single x) 0 l

let () =
  let raw_input = read_file "02.in" in
  let input = preprocess_input raw_input in
  Printf.printf "Part 1: %d\nPart 2: %d\n" (part1 input) (part2 input)
