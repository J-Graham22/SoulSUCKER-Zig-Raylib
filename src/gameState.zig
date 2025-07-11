const std = @import("std");
const rl = @import("raylib");

const Scene2D = @import("2DScene.zig").Scene2D;

pub const GameState = extern struct {
    overworldMap: Scene2D,


    gameSettings: settings.settings,
    buttonMap: buttonMapping.buttonMapping,

};
