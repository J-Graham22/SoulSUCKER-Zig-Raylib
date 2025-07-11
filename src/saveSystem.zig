const std = @import("std");
const rl = @import("raylib");

const settings = @import("settings.zig");
const buttonMapping = @import("buttonMapping.zig");

pub fn writeToFile(structToWrite: anytype, saveSlot: u16, saveName: []const u8) !void {
    var buffer: [100]u8 = undefined;
    const filePath = try std.fmt.bufPrint(&buffer, "src/saves/{}/{s}.dat", .{saveSlot, saveName});

    const file = try std.fs.cwd().createFile(filePath, .{ .truncate = true });
    defer file.close();

    const writer = file.writer();
    try writer.writeStruct(structToWrite);
}

pub fn readFromFile(saveSlot: u16, saveFileName: []const u8, comptime T: type) !T {
    var buffer: [100]u8 = undefined;
    const filePath = try std.fmt.bufPrint(&buffer, "src/saves/{}/{s}.dat", .{saveSlot, saveFileName});

    const file = try std.fs.cwd().openFile(filePath, .{});
    defer file.close();

    const reader = file.reader();
    return try reader.readStruct(T);
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

pub fn checkIfSaveDataExists() !bool {
    var saveDataExists = false;
    const fs = std.fs;

    for(0..6) |i| {
        var buffer: [100]u8 = undefined;
        const filePath = try std.fmt.bufPrint(&buffer, "src/saves/{}/save.dat", .{i});

        const cwd = fs.cwd();
        var result = cwd.openFile(filePath, .{}) catch |err| switch (err) {
            error.FileNotFound => {
                // Directory does not exist, so create it
                continue;
            },
            else => {
                std.debug.print("unexpected error: {}\n", .{err});
                continue;
            }
        };

        // Directory exists; close it
        result.close();
        saveDataExists = true;
    }

    return saveDataExists;
}

