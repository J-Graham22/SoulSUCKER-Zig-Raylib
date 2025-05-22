const rl = @import("raylib");

pub const walkableTileset: [3][]const u8 = [_][]const u8 {
    "src/assets/tiles/PlaceholderGround.png",
    "src/assets/tiles/PlaceholderPlayer.png",
    "src/assets/tiles/PlaceholderVoid.png",
};

pub const nonwalkableTileset = [_][]const u8 {
    "src/assets/tiles/PlaceholderVoid.png",
};
