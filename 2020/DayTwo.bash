#!/usr/bin/env bash

# absolutely terrible bash solution for day 2 of advent of code
# I know I could've just used awk or sed for this badboy, but
# seeing as the point of this exercise is to challenge myself
# to work with things I don't understand, I decided not to use
# any external processes (unless necessary, e.g. for echoing)

# DISCLAIMER: when it comes to bash I'm a total script kiddie
# and have no idea what I'm doing

# pass the input file as the first parameter, that's all

tot=0
part2=0
while read line; do
  IFS=' '
  read -a strarr <<< "$line"
  strarr[1]=${strarr[1]//[:]}
  res="${strarr[2]//[^${strarr[1]}]}"
  res="${#res}"
  IFS='-'
  read -a minmax <<< "${strarr[0]}"
  if (( res >= minmax[0] && res <= minmax[1] )); then
    ((tot = tot + 1))
  fi
  (( minmax[0] = minmax[0] - 1 ))
  (( minmax[1] = minmax[1] - 1 ))

  # don't bully me, bash is impossible and this is the best
  # I could get to work
  x=0; [ "${strarr[2]:minmax[0]:1}" = "${strarr[1]}" ] && x=1
  y=0; [ "${strarr[2]:minmax[1]:1}" = "${strarr[1]}" ] && y=1
  if (( x != y )); then
    (( part2 = part2 + 1))
  fi
done < $1
echo ${tot}
echo ${part2}
