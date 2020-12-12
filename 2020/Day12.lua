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

function left3(val)
  val = math.rad(val)
  local c = math.cos(val)
  local s = math.sin(val)
  wayx, wayy = c*wayx-s*wayy, s*wayx+c*wayy
end

optable = {
  ['E'] = function(val) wayx = wayx + val end,
  ['S'] = function(val) wayy = wayy - val end,
  ['W'] = function(val) wayx = wayx - val end,
  ['N'] = function(val) wayy = wayy + val end,
  ['F'] = function(val) posx, posy = posx + wayx*val, posy + wayy*val end,
  ['L'] = left3,
  ['R'] = function(val) left3(360-val) end
}

for _, s in pairs(lines) do
  op = s[0]
  val = tonumber(string.match(s, "%d+"))
  optable[op](val)
end

part2 = math.abs(posx)+math.abs(posy)
print("part 1: ", part1, "\npart 2: ", part2)