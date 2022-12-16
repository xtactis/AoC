import java.io.File

var dy = intArrayOf(-1, -1, -1,  0, 0,  1, 1, 1)
var dx = intArrayOf(-1,  0,  1, -1, 1, -1, 0, 1)

fun solve(brod: ArrayList<ArrayList<Char>>, part: Int): Int {
  var buf1 = ArrayList<ArrayList<Char>>()
  var buf2 = ArrayList<ArrayList<Char>>()
  for (row in brod) {
    buf1.add(ArrayList<Char>())
    buf2.add(ArrayList<Char>())
    for (cell in row) {
      buf1[buf1.size-1].add(cell)
      buf2[buf2.size-1].add(cell)
    }
  }
  var ret = 0
  var changed = true
  while (changed) {
    changed = false
    ret = 0
    for (i in buf1.indices) {
      for (j in buf1[i].indices) {
        var center: Char = buf1[i][j]
        if (center == '.') {
          buf2[i][j] = '.'
          continue
        }
        var cnt = 0;
        for (k in 0..7) {
          var y = i
          var x = j
          if (part == 1) {
            y += dy[k]
            x += dx[k]
          } else {
            do {
              y += dy[k]
              x += dx[k]
              if (y < 0 || y >= buf1.size) break
              if (x < 0 || x >= buf1[i].size) break
            } while (buf1[y][x] == '.')
          }
          if (y < 0 || y >= buf1.size) continue
          if (x < 0 || x >= buf1[i].size) continue
          if (buf1[y][x] == '#') ++cnt
        }
        if (center == 'L' && cnt == 0) {
          buf2[i][j] = '#'
          ++ret
          changed = true
        } else if (center == '#' && cnt >= part+3) { 
          // so we can just use the part number as the limit for occupied seats (4/5)
          buf2[i][j] = 'L'
          changed = true
        } else {
          if (buf1[i][j] == '#') ++ret
          buf2[i][j] = buf1[i][j]
        }
      }
    }
    buf1 = buf2.also {buf2 = buf1}
  }
  return ret
}

fun main(args: Array<String>) {
  var brod = ArrayList<ArrayList<Char>>()
  File("input.txt").forEachLine { 
    brod.add(ArrayList<Char>())
    for (c in it) {
      brod[brod.size-1].add(c)
    }
  }
  print("part 1: ")
  println(solve(brod, 1))
  print("part 2: ")
  println(solve(brod, 2))
}