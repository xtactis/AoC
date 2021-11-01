let read_file filename =
    let ch = open_in filename in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s

let part1 = List.fold_left (+) 0

let part2 l =
  let rec find_neg index floor = function
    | [] -> -1
    | h::t ->
       if floor+h < 0 then index else find_neg (index+1) (floor+h) t in
  find_neg 1 0 l

let convert s =
  let convert_one c = if c = '(' then 1 else -1 in
  let rec helper i l =
    if i < 0 then l else helper (i-1) ((convert_one s.[i]) :: l) in
  helper (String.length s - 1) []

let () =
  let raw_input = read_file "01.in" in
  let input = convert raw_input in
  Printf.printf "Part 1: %d\nPart 2: %d\n" (part1 input) (part2 input)
    
