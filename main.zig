const std = @import("std");
const config = @import("config.zig");
const request = @import("request.zig");

const response = @import("response.zig");

pub fn main() !void {

    const stdout = std.io.getStdOut().writer();

    const socket = try config.Socket.init();
    defer socket.deinit();
    try stdout.print("Listening to {any}\n", .{socket.address});

    var server = try socket.address.listen(.{});
    const conn = try server.accept();
    //slice
    var buf: [1000]u8 = undefined;
    @memset(&buf, 0);

    try request.read(conn, &buf);

    const allocator = std.heap.page_allocator;
    const req = try request.parse(allocator, &buf);

    if( req.method == request.RequestMethod.GET) {
        if (std.mem.eql(u8, req.uri, "/")) {
            try response.send_ok(conn);
        }else{
            try response.send_ok(conn);
            std.debug.print("Finished not found", .{});
        }
    }
}