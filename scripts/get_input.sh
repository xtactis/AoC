#!/usr/bin/bash
set -x

cookie=$AOC_COOKIE
user_data="github.com/xtactis/AoC by matija.dizdar@pm.me"

day=${1:-$(date +%-d)}
year=${2:-$(date +%Y)}

#echo "curl -A $user_data -b $cookie -o $(printf "%02d.in" $day) https://adventofcode.com/$year/day/$day/input"
curl -A "$user_data" -b $cookie -o $(printf "/home/md/sources/AoC/%d/input/%02d.in" $year $day) https://adventofcode.com/$year/day/$day/input
