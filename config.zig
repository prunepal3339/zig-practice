const std = @import("std");


pub const Socket = struct {
    address: std.net.Address,
    stream: std.net.Stream,

    ///Creates new Socket
    ///STEPS:
    ///Address(Host, Port)
    pub fn init() !Socket {
        const host = [_]u8{127, 0, 0, 1};
        const addr = std.net.Address.initIp4(host, 8848);
        const socket = try std.posix.socket(
            addr.any.family,
            std.posix.SOCK.STREAM,
            std.posix.IPPROTO.TCP
        );
        const stream = std.net.Stream {.handle = socket};
        return Socket {
            .address = addr,
            .stream = stream
        };
    }
    pub fn deinit(self: *const Socket) void {
        //closes the socket stream
        self.stream.close();
    }
};