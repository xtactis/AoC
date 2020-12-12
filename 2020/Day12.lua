-- for indexing strings nicely (from 0)
getmetatable('').__index = function(str,i) return string.sub(str,i+1,i+1) end

function lines_from(file)
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

local dir = 0
local posx = 0
local posy = 0

local dirtable = {
  [0] = 'E',
  [1] = 'S',
  [2] = 'W',
  [3] = 'N'
}

local optable = {
  ['E'] = function(val) posx = posx + val end,
  ['S'] = function(val) posy = posy - val end,
  ['W'] = function(val) posx = posx - val end,
  ['N'] = function(val) posy = posy + val end,
  ['L'] = function(val) dir = (dir - val/90 + 4) % 4 end,
  ['R'] = function(val) dir = (dir + val/90) % 4 end
}

local lines = lines_from('input.txt')
for _, s in pairs(lines) do
  op = s[0]
  val = tonumber(string.match(s, "%d+"))
  if op == 'F' then op = dirtable[dir] end
  optable[op](val)
end

part1 = math.abs(posx)+math.abs(posy)

posx = 0
posy = 0
wayx = 10
wayy = 1

local lefttable = {
  [ 0] = {
    [ 0] = { 0,  0},
    [ 1] = {-1,  0},
    [-1] = { 1,  0}
  },
  [ 1] = {
    [ 0] = { 0,  1},
    [ 1] = {-1,  1},
    [-1] = { 1,  1},
  },
  [-1] = {
    [ 0] = { 0, -1},
    [ 1] = {-1, -1},
    [-1] = { 1, -1},
  },
}

function sign(x)
  return (x > 0 and 1) or (x == 0 and 0) or -1
end

function left2(val)
  val = val / 90
  local x = sign(wayx)
  local y = sign(wayy)
  if val % 2 == 1 then
    wayx, wayy = wayy, wayx
  end
  while val ~= 0 do
    tmp = lefttable[x][y]
    x = tmp[1]
    y = tmp[2]
    val = val - 1
  end
  wayx = math.abs(wayx)*x
  wayy = math.abs(wayy)*y
end

optable = {
  ['E'] = function(val) wayx = wayx + val end,
  ['S'] = function(val) wayy = wayy - val end,
  ['W'] = function(val) wayx = wayx - val end,
  ['N'] = function(val) wayy = wayy + val end,
  ['F'] = function(val) posx, posy = posx + wayx*val, posy + wayy*val end,
  ['L'] = left2,
  ['R'] = function(val) left2(360-val) end
}

for _, s in pairs(lines) do
  op = s[0]
  val = tonumber(string.match(s, "%d+"))
  optable[op](val)
end

part2 = math.abs(posx)+math.abs(posy)
print("part 1: ", part1, "\npart 2: ", part2)