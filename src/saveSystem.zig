const std = @import("std");
const rl = @import("raylib");

const settings = @import("settings.zig");
const buttonMapping = @import("buttonMapping.zig");

const GameState = extern struct {
    gameSettings: settings.settings,
    buttonMap: buttonMapping.buttonMapping,

    pub fn writeToFile(self: *const GameState, file_path: []const u8) !void {
        const file = try std.fs.cwd().createFile(file_path, .{ .truncate = true });
        defer file.close();

        const writer = file.writer();
        try writer.writeStruct(self.*);
    }

    pub fn readFromFile(file_path: []const u8) !GameState {
        const file = try std.fs.cwd().openFile(file_path, .{});
        defer file.close();

        const reader = file.reader();
        return try reader.readStruct(GameState);
    }

    pub fn ensureSaveDirectoryExists(path: []const u8) !void {
        const fs = std.fs;

        const cwd = fs.cwd();
        const result = cwd.openDir(path, .{}) catch |err| switch (err) {
            error.FileNotFound => {
                // Directory does not exist, so create it
                try cwd.makeDir(path);
                return;
            },
            else => return err,
        };

        // Directory exists; close it
        result.close();
    }
};
