const std = @import("std");

pub fn main() !void {

    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    // Generating a psuedo random number 
    var seed: u64 = undefined;
    try std.os.getrandom(std.mem.asBytes(&seed));
    
    var prng = std.rand.DefaultPrng.init(seed);
    const rand = prng.random();
    const target_number = rand.intRangeAtMost(u8, 1, 100);

    try stdout.print("Target number: {}\n", .{target_number});
    while (true) {
        try stdout.writeAll("Enter a number: ");

        const buffer = try stdin.readUntilDelimiterAlloc(std.heap.page_allocator, '\n', std.mem.page_size);
        defer std.heap.page_allocator.free(buffer);
        const line = std.mem.trim(u8, buffer, "\r"); //remove carriage return specific to Windows Machine
        
        // const guess_number = try std.fmt.parseInt(u8, line, 10);

        const guess_number = std.fmt.parseInt(u8, line, 10) catch |err| switch (err) {
            error.Overflow => {
                try stdout.writeAll("Please enter a positive number between 1 to 100");
                continue;
            },
            error.InvalidCharacter => {
                try stdout.writeAll("Please enter a valid number!");
                continue;
            }
        }

        if (target_number < guess_number) {
            try stdout.print("Your guess is too high!\n", .{});
        }
        if (target_number > guess_number) {
            try stdout.print("Your guess is too low!\n", .{});
        }
        if (target_number == guess_number) {
            try stdout.print("Congratulation! You win this game!\n", .{});
            break;
        }
    }
}