cmake_minimum_required(VERSION 3.19)

set(regexes "^#.*$;^.#.*$;^..#.*$;^...#.*$;^....#.*$;^.....#.*$;^......#.*$;^.......#.*$;^........#.*$;^.........#.*$;^..........#.*$;^...........#.*$;^............#.*$;^.............#.*$;^..............#.*$;^...............#.*$;^................#.*$;^.................#.*$;^..................#.*$;^...................#.*$;^....................#.*$;^.....................#.*$;^......................#.*$;^.......................#.*$;^........................#.*$;^.........................#.*$;^..........................#.*$;^...........................#.*$;^............................#.*$;^.............................#.$;^..............................#$")

file(READ DayThree.in lines)
string(REPLACE "\n" ";" linesList "${lines}")

set(ans1 0)
set(ans3 0)
set(ans5 0)
set(ans7 0)

set(posx1 0)
set(posx3 0)
set(posx5 0)
set(posx7 0)
    
foreach(line ${linesList})
    list(GET regexes ${posx1} re)
    if (line MATCHES ${re})
        math(EXPR ans1 "${ans1} + 1")
    endif()
    math(EXPR posx1 "(${posx1} + 1) % 31")

    list(GET regexes ${posx3} re)
    if (line MATCHES ${re})
        math(EXPR ans3 "${ans3} + 1")
    endif()
    math(EXPR posx3 "(${posx3} + 3) % 31")

    list(GET regexes ${posx5} re)
    if (line MATCHES ${re})
        math(EXPR ans5 "${ans5} + 1")
    endif()
    math(EXPR posx5 "(${posx5} + 5) % 31")

    list(GET regexes ${posx7} re)
    if (line MATCHES ${re})
        math(EXPR ans7 "${ans7} + 1")
    endif()
    math(EXPR posx7 "(${posx7} + 7) % 31")
endforeach(line)

set(ans12 0)
set(posx12 0)
list(LENGTH linesList len)

foreach(i RANGE 0 ${len} 2)
    list(GET linesList ${i} line)
    list(GET regexes ${posx12} re)
    if (line MATCHES ${re})
        math(EXPR ans12 "${ans12} + 1")
    endif()
    math(EXPR posx12 "(${posx12} + 1) % 31")
endforeach(line)

message(${ans3})
math(EXPR part2 "${ans1} * ${ans3} * ${ans5} * ${ans7} * ${ans12}")
message(${part2})