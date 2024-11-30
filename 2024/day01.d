import std.stdio, std.array, std.algorithm, std.conv;

void main()
{
    int[] line = readln.split.map!(s => parse!int(s)).array;
    writeln(line[0]);
}
