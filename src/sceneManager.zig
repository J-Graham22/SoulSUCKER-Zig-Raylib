const std = @import("std");
const rl = @import("raylib");
const rg = @import("raygui");

const Scene2D = @import("2DScene.zig").Scene2D;
const tilemap = @import("tilemap.zig");
const tileset = @import("tileset.zig");
const player = @import("overworld_player.zig");
const battleModels = @import("battleModels.zig");
const configuration = @import("configuration.zig");

pub fn Load2DScene(scene: Scene2D) !void {
    //TODO: update this to be a more robust solution

    //TODO: update this to take in the globals
    const SCREEN_HEIGHT: f32 = 720.0;
    const SCREEN_WIDTH: f32 = 1280.0;

    //const tileMapPath = "src/assets/tilemaps/test.csv";
    const tileMapPath = scene.tilemapPath;
    var mapWidth: u32 = 0;
    var mapHeight: u32 = 0;

    try tilemap.Tilemap.getTilemapDimensions(tileMapPath, &mapWidth, &mapHeight);

    var sceneTiles = tilemap.Tilemap.init(mapWidth, mapHeight, 32, tileset.walkableTileset);
    //const tiles = sceneTiles.loadTileMapFile("src/assets/tilemaps/test.csv") catch |err| {
    const tiles = sceneTiles.loadTileMapFile(tileMapPath) catch |err| {
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

    //const gokuImage = try rl.loadImage("src/assets/goku.png");
    //const gokuTexture = try rl.loadTextureFromImage(gokuImage);

    //rl.unloadImage(gokuImage);
    //defer rl.unloadTexture(gokuTexture);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.sky_blue);

        rl.beginMode2D(camera);

        sceneTiles.draw(tiles);

        playerCharacter.handleMovement(sceneTiles, tiles);

        camera.target.x = @floatFromInt(playerCharacter.x);
        camera.target.y = @floatFromInt(playerCharacter.y);

        playerCharacter.draw();

        rl.endMode2D();
    }

}

pub fn Load3DScene() !void {
    var camera = rl.Camera3D{
        .position = .{ .x = 4.0, .y = 2.0, .z = 4.0 },
        .target = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
        .projection = rl.CameraProjection.perspective,
    };

    const playerParty: [*]battleModels.BattleUnit = configuration.LoadPlayerParty();
    var units: [4]sceneUnit = LoadSceneUnits(playerParty);

    const enemyParty: [*]battleModels.BattleUnit = configuration.LoadEnemyParty();
    var enemyUnits: [4]sceneUnit = LoadEnemySceneUnits(enemyParty);

    var debugCamera = false;

    while (!rl.windowShouldClose()) {
        const deltaTime: f32 = rl.getFrameTime();
        if (rl.isKeyPressed(rl.KeyboardKey.apostrophe)) debugCamera = !debugCamera;
        if (debugCamera) MoveCameraDebug(deltaTime, &camera);

        //mainMenu.main_menu.loadMainMenu();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.sky_blue);

        rl.beginMode3D(camera);
        defer rl.endMode3D();

        for (units[0..4], 0..4) |_, i| {
            //const model = rl.loadModel(units[i].pathToModel);
            const model = try rl.loadModel("src/assets/FinalBaseMesh.obj");
            defer rl.unloadModel(model);

            rl.drawModel(model, units[i].position, 1.0, units[i].color);

            //rl.drawCube(rl.Vector3{ .x = units[i].position.x, .y = units[i].position.y, .z = units[i].position.z }, 2, 2, 2, units[i].color);
            //rl.drawCubeWires(rl.Vector3{ .x = units[i].position.x, .y = units[i].position.y, .z = units[i].position.z }, 2, 2, 2, rl.Color.black);
        }
        for (enemyUnits[0..4], 0..4) |_, _| {
            //rl.drawCube(rl.Vector3{ .x = enemyUnits[j].position.x, .y = enemyUnits[j].position.y, .z = enemyUnits[j].position.z }, 2, 2, 2, enemyUnits[j].color);
            //rl.drawCubeWires(rl.Vector3{ .x = enemyUnits[j].position.x, .y = enemyUnits[j].position.y, .z = enemyUnits[j].position.z }, 2, 2, 2, rl.Color.black);
        }

        rl.drawGrid(10, 1.0);
        //rl.drawCube(rl.Vector3{ .x = 0, .y = 1, .z = 0 }, 2, 2, 2, rl.Color.red);
        //rl.drawCubeWires(rl.Vector3{ .x = 0, .y = 1, .z = 0 }, 2, 2, 2, rl.Color.black);

        //rl.drawText("Use WASD to move, mouse to look", 10, 10, 20, rl.Color.black);
        //rl.drawTexture(gokuTexture, 200, 200, rl.Color.green);
    }
}

fn MoveCameraDebug(deltaTime: f32, camera: *rl.Camera3D) void {
    camera.update(rl.CameraMode.first_person);

    const speed: f32 = 5.0;

    if (rl.isKeyDown(rl.KeyboardKey.space)) {
        camera.position.y += speed * deltaTime;
    }
    if (rl.isKeyDown(rl.KeyboardKey.left_control)) {
        camera.position.y -= speed * deltaTime;
    }
}

const sceneUnit = struct { unit: *battleModels.BattleUnit, color: rl.Color, position: rl.Vector3, pathToModel: [:0]const u8 };

fn LoadSceneUnits(playerParty: [*]battleModels.BattleUnit) [4]sceneUnit {
    var units: [4]sceneUnit = .{undefined} ** 4;

    for (playerParty[0..4], 0..4) |_, i| {
        const color: rl.Color = switch (@mod(i, 4)) {
            0 => rl.Color.red,
            1 => rl.Color.blue,
            2 => rl.Color.yellow,
            3 => rl.Color.green,
            else => rl.Color.white,
        };

        const position: rl.Vector3 = .{ .x = @floatFromInt(5 * i), .y = 1, .z = if (playerParty[i].backRow) -5 else 0 };

        const unit: sceneUnit = .{ .unit = &playerParty[i], .color = color, .position = position, .pathToModel = playerParty[i].pathToModel, };
        units[i] = unit;
    }

    return units;
}

fn LoadEnemySceneUnits(playerParty: [*]battleModels.BattleUnit) [4]sceneUnit {
    var units: [4]sceneUnit = .{undefined} ** 4;

    for (playerParty[0..4], 0..4) |_, i| {
        const color: rl.Color = rl.Color.purple;
        const position: rl.Vector3 = .{ .x = @floatFromInt(5 * i), .y = 1, .z = if (playerParty[i].backRow) 10 else 5 };

        const unit: sceneUnit = .{ .unit = &playerParty[i], .color = color, .position = position, .pathToModel = playerParty[i].pathToModel, };
        units[i] = unit;
    }

    return units;
}
