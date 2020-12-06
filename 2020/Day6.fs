open System

let part1 (group: string) = 
  '\n' :: [for c in group -> c]
  |> List.distinct 
  |> List.length

let part2 (group: string) = 
  group.Split '\n'
  |> Array.map (fun s -> [for c in s -> c] |> Set.ofList)
  |> Set.intersectMany
  |> Set.count

let input = (System.IO.File.ReadAllText "input.txt").Split([|"\n\n"|], StringSplitOptions.None)

printf "%A\n" ((input |> Array.map part1 |> Array.sum)-input.Length)
printf "%A\n" (input |> Array.map part2 |> Array.sum)
