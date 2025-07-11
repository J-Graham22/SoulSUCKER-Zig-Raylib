const rl = @import("raylib");
const rg = @import("raygui");
const std = @import("std");

const mainMenu = @import("mainMenu.zig");

const battleModels = @import("battleModels.zig");
const configuration = @import("configuration.zig");
const sceneManager = @import("sceneManager.zig");

const settings = @import("settings.zig").settings;
const buttonMap = @import("buttonMapping.zig");
const saving = @import("saveSystem.zig");

const Scene2D = @import("2DScene.zig").Scene2D;
const Scene3D = @import("3DScene.zig").Scene3D;
const Tilemap = @import("tileset.zig");

pub const global = struct {
    const testing: [3][*]const u8 = [_][*]const u8 {
        Tilemap.walkableTileset[0].ptr,
        Tilemap.walkableTileset[1].ptr,
        Tilemap.walkableTileset[2].ptr,
    };

    const mapPath = "src/assets/tilemaps/test.csv";

    pub var current2DScene: Scene2D = Scene2D{
        .tileset = testing,
        .tilemapPath = mapPath,
        .tileMapPathLen = mapPath.len,
        .playerPosX = 0,
        .playerPosY = 0,
    };


    const playerMoves: [6]?battleModels.Move = [6]?battleModels.Move {
        .{ .value = 10, .name = "Example Move", .stat = battleModels.Stat.Attack, },
        null,
        null,
        null,
        null,
        null,
    };
    pub var playerParty: [4]?battleModels.BattleUnit = [4]?battleModels.BattleUnit {
        battleModels.BattleUnit {
            .name = "player1",
            .level = 5,
            .currentHealth = 20,
            .maxHealth = 30,
            .baseAttack = 10,
            .baseMagicAttack = 15,
            .baseDefense = 12,
            .baseMagicDefense = 8,
            .baseSpeed = 30,
            .moves = playerMoves,
            .backRow = false,
            .exp = 15,
            .expToNextLevel = 30,
            .pathToModel = "src/assets/FinalBaseMesh.obj",
        },
        null,
        null,
        null,
    };
};
