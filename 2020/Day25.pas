program Day25;
const
    DATUM = 20201227;
    BASE_SN = 7;

function step(val: Int64; subject_number: Int64): Int64;
begin
    step := (val * subject_number) mod DATUM; // might need to change them to Int64s
end;

function findLoopSize(key: Int64): Int64;
var
    val, curLoop: Int64;
begin
    val := 1;
    curLoop := 0;
    while val <> key do begin
        val := step(val, BASE_SN);
        curLoop := curLoop + 1;
    end;
    findLoopSize := curLoop;
end;

function transform(loop_size: Int64; key: Int64): Int64;
var
    cur, i: Int64;
begin
    cur := 1;
    for i := 1 to loop_size do cur := step(cur, key);
    transform := cur;
end;

var
door_public, card_public: Int64;
begin
    door_public := 1717001;
    card_public := 523731;
    writeln('part 1: ', transform(findLoopSize(door_public), card_public));
end.
