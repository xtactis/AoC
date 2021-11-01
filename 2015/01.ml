let read_file filename =
    let ch = open_in filename in
    let s = really_input_string ch (in_channel_length ch) in
    close_in ch;
    s

let part1 = List.fold_left (fun acc x -> if x = '(' then acc+1 else acc-1) 0

let part2 l =
  let ftype c = if c = '(' then 1 else -1 in
  let rec helper index floor = function
    | [] -> -1
    | h::t ->
       if floor+(ftype h) < 0 then index else
         helper (index+1) (floor+(ftype h)) t in
  helper 1 0 l

let explode s =
  let rec helper i l =
    if i < 0 then l else helper (i-1) (s.[i] :: l) in
  helper (String.length s - 1) []

let () =
  let input = read_file "01.in" in
  let exploded = explode input in
  Printf.printf "Part 1: %d\nPart 2: %d\n" (part1 exploded) (part2 exploded)
    
