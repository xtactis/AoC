module Main
import Data.String 

findResidual : List Integer -> Integer -> Bool
findResidual [] _ = False
findResidual (h :: t) x = (h == x) || findResidual t x

findSum : List Integer -> Integer -> Bool
findSum [] _ = False
findSum (h :: t) x = (findResidual t (x-h)) || findSum t x

part1 : List Integer -> List Integer -> Integer
part1 use [] = -1 -- shouldn't happen
part1 (uh :: ut) (h :: t) = if (findSum (uh :: ut) h) then part1 (ut ++ [h]) t else h

max1 : Integer -> Integer -> Integer
max1 x y = if (x > y) then x else y

min1 : Integer -> Integer -> Integer
min1 x y = if (x > y) then y else x

max : List Integer -> Integer
max [] = -1 -- stop iterating lol
max (h :: t) = max1 h (max t)

min : List Integer -> Integer
min [] = 9999999999 -- stop iterating lol
min (h :: t) = min1 h (min t)

part2 : List Integer-> Integer -> List Integer -> Integer -> Integer
part2 (selh :: selt) cur (numh :: numt) target with (cur > target)
    | True = part2 selt (cur-selh) (numh :: numt) target
    | _ with (cur == target)
        | True = (min (selh :: selt)) + (max (selh :: selt))
        | _ = part2 ((selh :: selt) ++ [numh]) (cur+numh) numt target

p1 : List Integer -> Integer
p1 nums = part1 (Prelude.List.take 25 nums) (Prelude.List.drop 25 nums)

p2 : List Integer -> Integer -> Integer
p2 (h :: t) target = part2 [h] h (h :: t) target 

solve : List Integer -> List Integer
solve nums = [x, p2 nums x]
where x = p1 nums

processInput : String -> List Integer
processInput text = map (\x => fromMaybe 0 (parseInteger x)) (lines text)

main : IO()
main = do 
    file <- readFile "input.txt"
    case file of
        Right text => printLn $ solve $ processInput text
        Left err => printLn err
    