cookie=$AOC_COOKIE
user_data="github.com/xtactis/AoC by matija.dizdar@pm.me"

level=${3:-1}
day=${1:-$(date +%-d)}
year=${2:-$(date +%Y)}
answer=`cat | tail -n 1`

curl -s -b $cookie -A $user_data -X POST -d "level=$level&answer=$answer" https://adventofcode.com/$year/day/$day/answer | lynx -stdin --dump --nolist -width 200 | tail -n 1

