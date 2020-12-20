(* what am I doing with my life *)

datatype rule
  = Literal of char
  | Through of int
  | Concat of int * int
  | Pipe of int * int
  | PipeR of rule * rule
  | None

fun match tree [] _ = (false, [])
  | match tree _ None = (false, [])
  | match tree str (Through next) = match tree str (Array.sub (tree, next))
  | match tree (h::t) (Literal value) = (value = h, t)
  | match tree str (Concat (left, right)) = let
      val ll = match tree str (Array.sub (tree, left))
    in
      if (#1 ll) then match tree (#2 ll) (Array.sub (tree, right)) else (false, [])
    end
  | match tree str (Pipe (left, right)) = let 
      val ll = match tree str (Array.sub (tree, left))
    in
      if (#1 ll) then ll else match tree str (Array.sub (tree, right))
    end
  | match tree str (PipeR (left, right)) = let 
      val ll = match tree str left
    in
      if (#1 ll) then ll else match tree str right
    end

fun makeInt s =
    case Int.fromString s of
         SOME i => i
       | NONE => raise Fail ("Could not convert string '" ^ s ^ "' to int!")

fun getIndex s = makeInt (hd (String.tokens (fn c => c = #":") s))
fun getValue s = List.last (String.tokens (fn c => c = #":") s)

fun populate arr (h::t) = let in 
    Array.update (arr, (getIndex h), (getValue h));
    populate arr t
  end
  | populate arr [] = arr

fun createTreeHelper s = 
    case (String.tokens (fn c => c = #" ") s) of
        [x, y, "|", z, w] => (PipeR (Concat ((makeInt x), (makeInt y)), Concat ((makeInt z), (makeInt w))))
      | [x, "|", y] => (Pipe ((makeInt x), (makeInt y)))
      | [x, y] => (Concat ((makeInt x), (makeInt y)))
      | [] => None
      | other => if (String.isPrefix "\"" (hd other))
                  then (Literal (String.sub ((hd other), 1)))
                  else (Through (makeInt (hd other)))

fun createTree arr treeArr 300 = treeArr
  | createTree arr treeArr pos = let in
    Array.update (treeArr, pos, (createTreeHelper (Array.sub (arr, pos))));
    createTree arr treeArr (pos+1)
  end

fun findSplit (h::t) = if h = "" then 0 else 1+(findSplit t)
  | findSplit _ = raise Fail ("there should be a split tho")

fun checkDone (true, []) = true
  | checkDone (_, _) = false

fun part1 testData syntaxTree = let 
    val zero = (Array.sub (syntaxTree, 0))
    val checked = (List.map (fn line => (match syntaxTree (explode line) zero)) testData)
  in
    Int.toString (List.length (List.filter checkDone checked))
  end

fun manyR31 line syntaxTree cnt = let
    val r31 = (Array.sub (syntaxTree, 31))
    val p31 = match syntaxTree line r31
  in
    if (#1 p31) andalso (#2 p31) <> []
    then manyR31 (#2 p31) syntaxTree (cnt+1)
    else (p31, cnt)
  end

fun p2helper line syntaxTree cnt = let
    val r42 = (Array.sub (syntaxTree, 42))
    val r31 = (Array.sub (syntaxTree, 31))
    val p42 = match syntaxTree line r42
    val p31 = manyR31 (#2 p42) syntaxTree 0
  in
    if (#1 p42) andalso checkDone (#1 p31)
    then (if (#2 p31) < cnt then (true, []) else p2helper (#2 p42) syntaxTree (cnt+1))
    else if (#1 p42)
         then p2helper (#2 p42) syntaxTree (cnt+1)
         else (false, [])
  end

fun part2 testData syntaxTree = let
    val checked = (List.map (fn line => (p2helper (explode line) syntaxTree 0)) testData)
  in
    Int.toString (List.length (List.filter checkDone checked))
  end

val _ = 
let
  val ins = TextIO.openIn "input.txt"
  val data = String.fields (fn c => c = #"\n") (TextIO.inputAll ins)
  val splitPoint = findSplit data
  val testData = List.drop (data, splitPoint+1)
  val syntaxTree = createTree (populate (Array.array (300, "")) (List.take (data, splitPoint))) (Array.array (300, None)) 0
in
  TextIO.closeIn ins;
  print ("part 1: " ^ (part1 testData syntaxTree) ^ "\n");
  print ("part 2: " ^ (part2 testData syntaxTree) ^ "\n")
end
