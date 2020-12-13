% input
file = fopen('input.txt','rt');
time = int64(str2double(fgetl(file)));
buses = split(fgetl(file), ',');
% part 1
busesClean = [];
offset = [];
part1 = time*time;
bus = -1;
for i = 1:size(buses, 1)
    if ~isequal(buses{i}, 'x')
        busesClean(end+1) = str2double(buses{i});
        x = int64(busesClean(end));
        offset(end+1) = mod(x-(i-1), x);
        new = idivide(time, x, 'ceil') * x;
        if new < part1
            part1 = new;
            bus = x;
        end
    end
end
fclose(file);
part1 = (part1-time)*bus;
% part 2
r = zeros(size(busesClean, 2), size(busesClean, 2));
for i = 1:size(busesClean, 2)
    for j = 1:size(busesClean, 2)
        r(i, j) = binpow(int64(busesClean(i)), int64(busesClean(j)-2), int64(busesClean(j)));
    end
end
x = offset;
part2 = 0;
for i = 1:size(busesClean, 2)
    for j = 1:i-1
       x(i) = r(j, i) * (x(i) - x(j));
       x(i) = mod(x(i), busesClean(i));
       if x(i) < 0
           x(i) = x(i) + busesClean(i);
       end
    end
    cur = x(i);
    for j = 1:i-1
        cur = cur * busesClean(j);
    end
    part2 = part2 + cur;
end
% output
fprintf('part 1: %ld\npart 2: %ld\n', part1, part2);
% idk how to put functions at the top so this is here lol
function ret = binpow(b, e, p)
    if e == 0
        ret = 1;
    elseif mod(e, 2) == 1
       ret = mod(b*binpow(b, e-1, p), p);
    else
       ret = binpow(mod(b*b, p), idivide(e, int64(2), "floor"), p);
    end
end