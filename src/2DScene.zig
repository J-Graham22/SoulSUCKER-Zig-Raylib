const std = @import("std");
const rl = @import("raylib");

const Tileset = @import("tileset.zig");

pub const Scene2D = extern struct {
    tilemapPath: [*]const u8,
    tileMapPathLen: usize,
    tileset: [3][*]const u8, //TODO: change this to use a []TileInfo later
    playerPosX: i32,
    playerPosY: i32,


};
