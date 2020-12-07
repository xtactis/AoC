package main

import (
  "fmt"
  "bufio"
  "os"
  "strings"
)

const N = 21234

type Node struct {
  ind, number int
}

var (
  str2int = map[string]int{}
  bagnames = []string{}
  g = [N][]Node{}
  bio = [N]bool{}
  ans = [N]bool{}
)

func getInd(bag string) int {
  ret, ok := str2int[bag]
  if !ok {
    ret = len(bagnames)
    str2int[bag] = ret
    bagnames = append(bagnames, bag)
  }
  return ret
}

// a simpler but slower solution would be to not remember visited nodes
// then, dfs will be called on every node and we'll check whether it leads
// to the target node
func dfs(u, target int) bool {
  if u == target {
    return true
  }
  bio[u] = true
  ret := false
  for _, v := range(g[u]) {
    if bio[v.ind] {
      ret = ret || ans[v.ind]
      continue
    }
    ret = ret || dfs(v.ind, target)
  }
  ans[u] = ans[u] || ret
  return ret
}

func part2(u int) int {
  ret := 1
  for _, v := range(g[u]) {
    ret += v.number * part2(v.ind)
  }
  return ret
}

func main() {
  file, _ := os.Open("input.txt") // handling errors is for nerds
  defer file.Close()

  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
    bags := strings.Split(scanner.Text(), ", ")
    begin := strings.Split(bags[0], " bags contain ")
    bags[0] = begin[1]
    
    root := getInd(begin[0])

    for i := 0; i < len(bags)-1; i++ {
      bags[i] = strings.TrimSuffix(bags[i], "s")
      bags[i] = strings.TrimSuffix(bags[i], " bag")
      
      zagreb := strings.SplitN(bags[i], " ", 2)
      bags[i] = zagreb[1]
      var number int
      fmt.Sscanf(zagreb[0], "%d", &number)

      g[root] = append(g[root], Node{getInd(bags[i]), number})
    }
    lastBag := len(bags)-1
    bags[lastBag] = bags[lastBag][:len(bags[lastBag])-1]
    bags[lastBag] = strings.TrimSuffix(bags[lastBag], "s")
    bags[lastBag] = strings.TrimSuffix(bags[lastBag], " bag")
    
    trogir := strings.SplitN(bags[lastBag], " ", 2)
    bags[lastBag] = trogir[1]
    var number int
    fmt.Sscanf(trogir[0], "%d", &number)

    g[root] = append(g[root], Node{getInd(bags[lastBag]), number})
  }

  target := str2int["shiny gold"]
  for i := 0; i < len(bagnames); i++ {
    if i == target || bio[i] {
      continue
    }
    dfs(i, target)
  }
  part1 := 0
  for i := 0; i < len(bagnames); i++ {
    if ans[i] {
      part1++
    }
  }
  fmt.Printf("part 1: %d\npart 2: %d\n", part1, part2(target)-1)
}