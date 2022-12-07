cookie=$AOC_COOKIE
user_data="github.com/xtactis/AoC by matija.dizdar@pm.me"

day=${1:-$(date +%-d)}
year=${2:-$(date +%Y)}

echo "curl -A user_data -b $cookie https://adventofcode.com/$year/day/$day/input"
curl -s -A user_data -b $cookie https://adventofcode.com/$year/day/$day/input -o $(printf "%02d.in" $day)

