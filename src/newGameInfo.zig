const std = @import("std");
const rl = @import("raylib");
const saveSystem = @import("saveSystem.zig");
const serializableModels = @import("saveModels.zig");

const Scene2D = @import("2DScene.zig").Scene2D;
const BattleModels = @import("battleModels.zig");
const Tileset = @import("tileset.zig");

//should contain functionality to create a new save game file
//
//
// - things that should be save independent
// settings
// button mapping
//
// - things that should be save dependent
// 2d map 
// map position
// party makeup
// inventory?
// any important story triggers

pub fn loadNewSaveInfo(playerParty: *[4]?BattleModels.BattleUnit, current2DScene: *Scene2D) void {
    const testing: [3][*]const u8 = [_][*]const u8 {
        Tileset.walkableTileset[0].ptr,
        Tileset.walkableTileset[1].ptr,
        Tileset.walkableTileset[2].ptr,
    };

    const mapPath = "src/assets/tilemaps/test.csv";

    current2DScene.* = Scene2D{
        .tileset = testing,
        .tilemapPath = mapPath,
        .tileMapPathLen = mapPath.len,
        .playerPosX = 0,
        .playerPosY = 0,
    };


    const playerMoves: [6]?BattleModels.Move = [6]?BattleModels.Move {
        .{ .value = 10, .name = "Example Move", .stat = BattleModels.Stat.Attack, },
        null,
        null,
        null,
        null,
        null,
    };
    playerParty.* = [4]?BattleModels.BattleUnit {
        BattleModels.BattleUnit {
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
}

pub fn createNewSave(saveSlot: u16) !void {
    const testing: [3][*]const u8 = [_][*]const u8 {
        Tileset.walkableTileset[0].ptr,
        Tileset.walkableTileset[1].ptr,
        Tileset.walkableTileset[2].ptr,
    };

    const mapPath = "src/assets/tilemaps/test.csv";

    const overworldScene: Scene2D = Scene2D{
        .tileset = testing,
        .tilemapPath = mapPath,
        .tileMapPathLen = mapPath.len,
        .playerPosX = 0,
        .playerPosY = 0,
    };
    try saveSystem.writeToFile(overworldScene, saveSlot, "overworld_scene");

    //so this one doesn't work for some reason?
    const playerParty: serializableModels.SerializablePlayerParty = serializableModels.SerializablePlayerParty{
        .unit1 = &serializableModels.SerializableBattleUnit{ 
            .name = "player1",
            .level = 5,
            .currentHealth = 20,
            .maxHealth = 30,
            .baseAttack = 10,
            .baseMagicAttack = 15,
            .baseDefense = 12,
            .baseMagicDefense = 8,
            .baseSpeed = 30,
            .move1 = &.{ .value = 10, .name = "Example Move", .stat = BattleModels.Stat.Attack, },
            .move2 = null,
            .move3 = null,
            .move4 = null,
            .move5 = null,
            .move6 = null,
            .backRow = false,
            .exp = 15,
            .expToNextLevel = 30,
            .pathToModel = "src/assets/FinalBaseMesh.obj",
        },
        .unit2 = null,
        .unit3 = null,
        .unit4 = null,
    };
    try saveSystem.writeToFile(playerParty, saveSlot, "player_party");
}

