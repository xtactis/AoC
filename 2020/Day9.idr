module Main
import Data.String 

findResidual : List Integer -> Integer -> Bool
findResidual [] _ = False
findResidual (h :: t) x with (h == x)
    | True = True
    | _ = findResidual t x

findSum : List Integer -> Integer -> Bool
findSum [] _ = False
findSum (h :: t) x with (findResidual t (x-h))
    | True = True
    | _ = findSum t x

part1 : List Integer -> List Integer -> Integer
part1 use [] = -1 -- shouldn't happen
part1 (uh :: ut) (h :: t) with (findSum (uh :: ut) h)
    | True = part1 (ut ++ [h]) t
    | _ = h

max1 : Integer -> Integer -> Integer
max1 x y with (x > y)
    | True = x
    | _ = y

min1 : Integer -> Integer -> Integer
min1 x y with (x > y)
    | True = y
    | _ = x

max : List Integer -> Integer
max [] = -1 -- stop iterating lol
max (h :: t) = max1 h (max t)

min : List Integer -> Integer
min [] = 9999999999 -- stop iterating lol
min (h :: t) = min1 h (min t)

part2 : List Integer-> Integer -> List Integer -> Integer
--part2 selected cur nums
part2 (selh :: selt) cur (numh :: numt) with (cur > 22406676)
    | True = part2 selt (cur-selh) (numh :: numt)
    | _ with (cur == 22406676)
        | True = (min (selh :: selt)) + (max (selh :: selt))
        | _ = part2 ((selh :: selt) ++ [numh]) (cur+numh) numt

p1 : List Integer -> Integer
p1 nums = part1 (Prelude.List.take 25 nums) (Prelude.List.drop 25 nums)

p2 : List Integer -> Integer
p2 (h :: t) = part2 [h] h (h :: t)

solve : List Integer -> List Integer
solve nums = [p1 nums, p2 nums]

processInput : String -> List Integer
processInput text = map (\x => fromMaybe 0 (parseInteger x)) (lines text)

main : IO()
main = do 
    file <- readFile "input.txt"
    case file of
        Right text => printLn $ solve $ processInput text
        Left err => printLn err
    