let read_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

module Coord = struct
  type t = int * int
  let compare = compare
end
module SK = Set.Make(String)
module CS = Set.Make(Coord)

let change x y = function
  | '>' -> (x+1, y)
  | '<' -> (x-1, y)
  | 'v' -> (x, y-1)
  | _ ->   (x, y+1)

let check s e = if CS.mem e s then 0 else 1

let part1 s =
  let len = String.length s in 
  let rec aux coords i x y =
    let d = if CS.mem (x, y) coords then 0 else 1 in
    let ns = CS.add (x, y) coords in
    let (dx, dy) as e = change x y s.[i] in
    d + if i+1 < len then aux ns (i+1) dx dy else (check ns e) in
  aux CS.empty 0 0 0

let part2 s =
  let len = String.length s in 
  let rec aux coords i x y xr yr =
    let d = check coords (x, y) in
    let ns = CS.add (x, y) coords in
    let (dx, dy) = change x y s.[i] in
    d + if i+1 < len then aux ns (i+1) xr yr dx dy else (check ns (xr, yr)) in
  aux CS.empty 0 0 0 0 0

let () =
  let input = read_file "03.in" in
  Printf.printf "Part 1: %d\nPart 2: %d\n" (part1 input) (part2 input)
