const std = @import("std");
const Connection = std.net.Server.Connection;

const MethodMap = std.static_string_map.StaticStringMap(RequestMethod).initComptime(.{
    .{"GET", RequestMethod.GET},
    .{"POST", RequestMethod.POST},
    .{"PUT", RequestMethod.PUT},
    .{"PATCH", RequestMethod.PATCH},
    .{"DELETE", RequestMethod.DELETE},
});

pub const RequestMethod  = enum {
    GET,
    POST,
    PUT,
    PATCH,
    DELETE,
    pub fn init(name: []const u8) !RequestMethod {
        return MethodMap.get(name).?;
    }
    pub fn is_supported(name: []const u8) bool {
        if (MethodMap.get(name)) |_| {
            return true;
        }
        return false;
    }
};

const Request = struct {
    method: RequestMethod,
    version: []const u8,
    uri: []const u8,
    headers: std.StringHashMap([]const u8),
    body: ?[]const u8,
    pub fn init(method: RequestMethod, uri: []const u8, version: []const u8, headers: std.StringHashMap([]const u8), body: ?[]const u8) Request {
        return Request {
            .method = method,
            .version = version,
            .uri = uri,
            .headers = headers,
            .body = body,
        };
    }
};


pub fn read(conn: Connection, buffer: []u8) !void {
    const reader = conn.stream.reader();
    _ = try reader.read(buffer);
}

pub fn parse(allocator: std.mem.Allocator, buffer: []u8) !Request {

    var headers_and_body = std.mem.split(u8, buffer, "\n\n");

    const request_headers = headers_and_body.next().?;
    const request_body = headers_and_body.next();


    var parts_and_headers = std.mem.split(u8, request_headers, "\n");


    const first_line  = parts_and_headers.next().?;

    var parts = std.mem.split(u8, first_line, " ");

    const method = try RequestMethod.init(parts.next().?);
    const uri = parts.next().?;
    const version = parts.next().?;


    var headersMap = std.StringHashMap([]const u8).init(allocator);

    while (parts_and_headers.next()) |header| {
        var keyvalue = std.mem.split(u8, header, ":");
        const key = keyvalue.next() orelse continue;
        const value = keyvalue.next() orelse continue;
        headersMap.put(key, value) catch unreachable;
    }
    return Request.init(method, uri, version, headersMap, request_body);
}