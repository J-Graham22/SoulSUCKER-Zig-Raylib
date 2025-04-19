const std = @import("std");
const battleModels = @import("battleModels.zig");
const battleUI = @import("battleUI.zig");

const BattlePhases = enum {
    BATTLE_START,
    PLAYER_TURN,
    ENEMY_TURN,
    EXECUTE_TURN,
    PLAYER_WIN,
    ENEMY_WIN
};

pub fn BattleLoop(playerParty: []battleModels.BattleUnit, enemyParty: []battleModels.BattleUnit) void {
    var battlePhase: BattlePhases = BattlePhases.BATTLE_START;

    //TODO: insert logic for setting up battle, would include start of battle moves

    while(battlePhase != BattlePhases.PLAYER_WIN and battlePhase != BattlePhases.ENEMY_WIN) {
        //if we break out of the loop, then 1 side has won

        battlePhase = BattlePhases.PLAYER_TURN;

        const alloc = std.heap.page_allocator;
        var battleActions = std.ArrayList(battleModels.Action).init(alloc);

        //get the actions needed for a turn
        battleUI.GetPlayerActions(&battleActions, &playerParty);
        battleUI.GetEnemyActions(&battleActions, &enemyParty);

        PlayActions(&battleActions);

    }



}

