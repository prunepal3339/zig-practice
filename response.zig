const std = @import("std");

const Connection = std.net.Server.Connection;

pub fn send_ok(conn: Connection) !void {
    const message = (
        "HTTP/1.1 200 OK\n"
    ++ "Content-Type: text/html\n\n"
    ++ "<h1>Hello World!</h1>"
    );
    _ = try conn.stream.write(message);
}

pub fn send_not_found(conn: Connection) !void {
    const message = (
        "HTTP/1.1 Not Found\n"
    ++ "Content-Type: text/html\n\n"
    ++ "<h1>Not Found</h1>"
    );
    _ = try conn.stream.write(message);
}