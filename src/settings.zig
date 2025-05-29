const std = @import("std");

const resolution = enum {
    RES_1920x1080,
    RES_1280x720,
};

const settings = struct {
    screenWidth: u32,
    screenHeight: u32,
    masterVolume: u8,
    musicVolume: u8,
    sfxVolume: u8,
};
