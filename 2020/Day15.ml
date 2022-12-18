open Printf

let rec helper hist prev i n =
    if i == n then prev
    else let pi = (if hist.(prev) == -1 then i else hist.(prev)) in begin
        hist.(prev) <- i;
        helper hist (i - pi) (i+1) n
    end

let rec solve stuff hist n cnt prev =
    match stuff with
      []   -> helper hist 0 cnt n
    | h::t -> begin
        hist.(h) <- cnt;
        solve t hist n (cnt+1) h
    end

let () =
    let input = List.map int_of_string (String.split_on_char ',' (read_line ())) in begin
        printf "part 1: %d\n" (solve input (Array.make 2020 ~-1) 2020 1 0);
        printf "part 2: %d\n" (solve input (Array.make 30000000 ~-1) 30000000 1 0)
    end
