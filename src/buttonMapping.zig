const std = @import("std");
const rl = @import("raylib");

const buttonMapping = struct {
    up: rl.KeyboardKey,
    down: rl.KeyboardKey,
    left: rl.KeyboardKey,
    right: rl.KeyboardKey,
    confirm: rl.KeyboardKey,
    back: rl.KeyboardKey,
    pause: rl.KeyboardKey,
};
