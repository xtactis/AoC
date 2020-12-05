-module('Day5').
-export([main/0]).

get_id_helper([], Lo, _) -> Lo;
get_id_helper([H|T], Lo, Hi) ->
    case H of
        $F -> get_id_helper(T, Lo, (Hi + Lo) div 2);
        $B -> get_id_helper(T, (Hi + Lo + 1) div 2, Hi);
        $L -> get_id_helper(T, Lo, (Hi + Lo) div 2);
        $R -> get_id_helper(T, (Hi + Lo + 1) div 2, Hi);
        _ -> get_id_helper([], Lo, Hi)
    end.

get_id(Str) -> get_id_helper(string:slice(Str, 0, 7), 0, 127)*8 + get_id_helper(string:slice(Str, 7), 0, 7).

get_all_tickets(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> [get_id(Line)] ++ get_all_tickets(Device)
    end.

find_my_seat([]) -> -1; % this shouldn't happen
find_my_seat([F,S|_]) when S-F > 1 -> F+1;
find_my_seat([_|T]) -> find_my_seat(T).

bang_it_out(Tix) -> [lists:max(Tix), find_my_seat(lists:usort(Tix))].

read_lines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try bang_it_out(get_all_tickets(Device))
      after file:close(Device)
    end.
    
main() -> io:format("part 1: ~p~npart 2: ~p~n", read_lines("input.txt")).
