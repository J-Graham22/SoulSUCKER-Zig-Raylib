const std = @import("std");
const rl = @import("raylib");

pub const buttonMapping = extern struct {
    up: rl.KeyboardKey,
    down: rl.KeyboardKey,
    left: rl.KeyboardKey,
    right: rl.KeyboardKey,
    confirm: rl.KeyboardKey,
    back: rl.KeyboardKey,
    pause: rl.KeyboardKey,

    //TODO: separate this one out from the save system as well
};
