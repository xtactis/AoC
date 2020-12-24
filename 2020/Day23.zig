const std = @import("std");
const print = @import("std").debug.print;
const TailQueue = std.TailQueue;

const L = TailQueue(u32);
const N = 1_000_001;

var arr: [N]L.Node = undefined;

pub fn init(input: *const [9]u8) L {
    var list = L{};
    for (input) |c| {
        arr[c-'0'] = L.Node{ .data = c-'0'};
        list.append(&arr[c-'0']);
    }
    return list;
}

pub fn step(list: *L, max: u32) void {
    const cur = list.popFirst().?;
    const first = list.popFirst().?;
    const second = list.popFirst().?;
    const third = list.popFirst().?;
    var next = cur.data-1;
    if (next == 0) next = max;
    while (next == cur.data or next == first.data or next == second.data or next == third.data) {
        next -= 1;
        if (next == 0) next = max;
    }
    const target = &arr[next];
    list.insertAfter(target, third);
    list.insertAfter(target, second);
    list.insertAfter(target, first);
    list.append(cur);
}

pub fn reset(list: *L) void {
    while (list.first.?.data != 1) {
        list.append(list.popFirst().?);
    }
}

pub fn part1(input: *const [9]u8) void {
    var list = init(input);

    {var i: u32 = 0; while (i < 100) : (i += 1) {
        step(&list, 9);
    }}
    reset(&list);

    print("part1: ", .{});
    {var it = list.first.?.next; while (it) |node| : (it = node.next) {
        print("{}", .{ it.?.data });
    }}
    print("\n", .{});
}

pub fn part2(input: *const [9]u8) void {
    var list = init(input);
    {var i: u32 = 10; while (i < N) : (i += 1) {
        arr[i] = L.Node{ .data = i };
        list.append(&arr[i]);
    }}

    {var i: u32 = 0; while (i < 10_000_000) : (i += 1) {
        step(&list, N-1);
    }}
    reset(&list);

    var p2: u64 = list.first.?.next.?.data;
    p2 *= list.first.?.next.?.next.?.data;
    print("part2: {}\n", .{p2});
}

pub fn main() !void {
    const input = "962713854";
    part1(input);
    part2(input);
}