const rl = @import("raylib");
const rg = @import("raygui");
const std = @import("std");

const battleModels = @import("battleModels.zig");
const configuration = @import("configuration.zig");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("ZigRaylibGame_lib");

var debugCamera: bool = false;


pub fn main() !void {
    rl.initWindow(1280, 720, "gaming!!");
    defer rl.closeWindow();

    const gokuImage = try rl.loadImage("src/assets/goku.png");
    const gokuTexture = try rl.loadTextureFromImage(gokuImage);

    rl.unloadImage(gokuImage);
    defer rl.unloadTexture(gokuTexture);

    var camera = rl.Camera3D{
        .position = .{ .x = 4.0, .y = 2.0, .z = 4.0 },
        .target = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .up = .{ .x = 0.0, .y = 1.0, .z = 0.0 },
        .fovy = 45.0,
        .projection = rl.CameraProjection.perspective,
    };

    rl.setTargetFPS(60);

    const playerParty: [*]battleModels.BattleUnit = configuration.LoadPlayerParty();
    var units: [4]sceneUnit = LoadSceneUnits(playerParty);

    const enemyParty: [*]battleModels.BattleUnit = configuration.LoadEnemyParty();
    var enemyUnits: [4]sceneUnit = LoadEnemySceneUnits(enemyParty);

    while (!rl.windowShouldClose()) {
        const deltaTime: f32 = rl.getFrameTime();
        if (rl.isKeyPressed(rl.KeyboardKey.apostrophe)) debugCamera = !debugCamera;
        if (debugCamera) MoveCameraDebug(deltaTime, &camera);

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.sky_blue);

        rl.beginMode3D(camera);
        defer rl.endMode3D();

        for (units[0..4], 0..4) |_, i| {
            rl.drawCube(rl.Vector3{ .x = units[i].position.x, .y = units[i].position.y, .z = units[i].position.z }, 2, 2, 2, units[i].color);
            rl.drawCubeWires(rl.Vector3{ .x = units[i].position.x, .y = units[i].position.y, .z = units[i].position.z }, 2, 2, 2, rl.Color.black);
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

const sceneUnit = struct { unit: *battleModels.BattleUnit, color: rl.Color, position: rl.Vector3 };

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

        const unit: sceneUnit = .{ .unit = &playerParty[i], .color = color, .position = position };
        units[i] = unit;
    }

    return units;
}

fn LoadEnemySceneUnits(playerParty: [*]battleModels.BattleUnit) [4]sceneUnit {
    var units: [4]sceneUnit = .{undefined} ** 4;

    for (playerParty[0..4], 0..4) |_, i| {
        const color: rl.Color = rl.Color.purple;
        const position: rl.Vector3 = .{ .x = @floatFromInt(5 * i), .y = 1, .z = if (playerParty[i].backRow) 10 else 5 };

        const unit: sceneUnit = .{ .unit = &playerParty[i], .color = color, .position = position };
        units[i] = unit;
    }

    return units;
}
