-- I know indexing lists is trash, but I can't be bothered to figure out how arrays work
-- for now at least

import Data.Set as Set ( insert, member, empty )

getOp line = head $ words line

parseInt ('+':t) = read t :: Int
parseInt ('-':t) = -1 * read t :: Int

getVal line = parseInt $ last $ words line

p1 codeLines ind bio acc
    | member ind bio || ind >= length codeLines = (acc, ind)
    | otherwise = runTheTrap $ codeLines !! ind
    where runTheTrap ("nop", _) = p1 codeLines (ind+1) (insert ind bio) acc
          runTheTrap ("jmp", v) = p1 codeLines (ind+v) (insert ind bio) acc
          runTheTrap ("acc", v) = p1 codeLines (ind+1) (insert ind bio) (acc+v)

part1 codeLines = p1 codeLines 0 Set.empty 0

replace ("jmp", v) = ("nop", v)
replace ("nop", v) = ("jmp", v)
replace t = t


-- also this is stupid and should be done more betterer, but graphs in haskell...
p2 codeLines replaceIndex 
    | replaceIndex >= len = (-1, -1) -- shouldn't happen
    | otherwise = do
        let front = take replaceIndex codeLines
        let back = drop replaceIndex codeLines
        let newCodeLines = front ++ [replace $ head back] ++ tail back
        let ret = part1 newCodeLines
        if snd ret == len then ret else p2 codeLines (replaceIndex+1)
    where len = length codeLines

part2 codeLines = p2 codeLines 0

parseInput = map (\ h -> (getOp h, getVal h))

main = do 
    text <- readFile "input.txt"
    let input = parseInput $ lines text
    print $ part1 input
    print $ part2 input