const std = @import("std");
const rl = @import("raylib");

const tilemap = @import("tilemap.zig");
const tileset = @import("tileset.zig");
const player = @import("overworld_player.zig");

pub fn Load2DScene() !void {
    //TODO: update this to be a more robust solution

    //TODO: update this to take in the globals
    const SCREEN_HEIGHT: f32 = 720.0;
    const SCREEN_WIDTH: f32 = 1280.0;

    var sceneTiles = tilemap.Tilemap.init(30, 20, 32, tileset.walkableTileset);
    //const tiles = sceneTiles.loadTileMapFile("src/assets/tilemaps/testMap.txt") catch |err| {
    const tiles = sceneTiles.loadTileMapFile("src/assets/tilemaps/test.csv") catch |err| {
        std.debug.print("the error was {}\n", .{err});
        @panic("whooooooa\n");
    };
    std.debug.print("tiles! {}\n", .{tiles.len});


    var playerCharacter: player.OverworldPlayer = player.OverworldPlayer.init(0, 0, 32, "src/assets/tiles/PlaceholderPlayer.png");

    var camera: rl.Camera2D = rl.Camera2D{
        .target = rl.Vector2{ .x = @floatFromInt(playerCharacter.x), .y = @floatFromInt(playerCharacter.y) },
        .offset = rl.Vector2{ .x = SCREEN_WIDTH / 2.0, .y = SCREEN_HEIGHT / 2.0 },
        .rotation = 0.0,
        .zoom = 1.0,
    };

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.sky_blue);

        rl.beginMode2D(camera);
        defer rl.endMode2D();

        sceneTiles.draw(tiles);

        playerCharacter.handleMovement(sceneTiles, tiles);

        camera.target.x = @floatFromInt(playerCharacter.x);
        camera.target.y = @floatFromInt(playerCharacter.y);

        playerCharacter.draw();
    }

}
