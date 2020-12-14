import math
import tables
import bitops # figure out something nice
import strscans
import strutils

type
  OpType = enum
    Mask, Mem
  Op = object
    case kind: OpType
    of Mask: m1, m2, m3: int
    of Mem: ind, val: int

proc parse(file: string): seq[Op] = 
  var input: seq[Op]
  input.add(Op(kind: Mask, m1: 0, m2: 2^36-1))
  for line in lines file:
    var ind, val, m1, m2: int
    if scanf(line, "mem[$i] = $i", ind, val):
      input.add(Op(kind: Mem, ind: ind, val: val))
    else:
      let mask = line[7 .. ^1]
      m1 = parseBinInt(mask.replace('X', '0'))
      m2 = parseBinInt(mask.replace('X', '1'))
      input.add(Op(kind: Mask, m1: m1, m2: m2))
  return input

proc part1(input: seq[Op]): int =
  var mem: Table[int, int]
  var m1, m2, ret: int
  for op in input:
    case op.kind:
      of Mask:
        m1 = op.m1
        m2 = op.m2
      of Mem:
        mem[op.ind] = (op.val or m1) and m2
  for e in mem.values:
    ret += e
  return ret

proc storeMem(ind, val, mask: int, mem: var Table[int, int]) =
  var i = mask.firstSetBit()-1
  if i == -1:
    mem[ind] = val
  else:
    storeMem(ind or (2^i), val, mask and not (2^i), mem)
    storeMem(ind and not (2^i), val, mask and not (2^i), mem)

proc part2(input: seq[Op]): int =
  var mem: Table[int, int]
  var m1, m2, ret: int
  for op in input:
    case op.kind:
      of Mask: 
        m1 = op.m1
        m2 = op.m2
      of Mem:
        storeMem(op.ind or m1, op.val, m1 xor m2, mem)
  for e in mem.values:
    ret += e
  return ret

let input = parse "input.txt"
echo part1(input)
echo part2(input)
