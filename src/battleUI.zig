const std = @import("std");

const rl = @import("raylib");
const rg = @import("raygui");

const battleModels = @import("battleModels.zig");

pub fn GetPlayerActions(actions: *std.ArrayList(battleModels.Action), playerParty: *[]battleModels.BattleUnit) void {
    for (playerParty) |playerCharacter| {
        var moveChosen: bool = false;

        while(!moveChosen) {

        }
    }
}

pub fn GetEnemyActions(actions: *std.ArrayList(battleModels.Action), playerParty: *[]battleModels.BattleUnit) void {
    
}

pub fn DrawActionsDialog(playerCharacter: *battleModels.BattleUnit) void {
    rg.GuiPanel(rl.Rectangle{ .x = 50, .y = 400, .width = 700, .height = 150 });

    if(rg.GuiButton(rl.Rectangle{ .x = 650, .y = 480, .width = 80, .height = 30 }, "Attack")) {

    }
    if(rg.GuiButton(rl.Rectangle{ .x = 650, .y = 480, .width = 80, .height = 30 }, "Magic")) {

    }
    if(rg.GuiButton(rl.Rectangle{ .x = 650, .y = 480, .width = 80, .height = 30 }, "Defend")) {

    }
    if(rg.GuiButton(rl.Rectangle{ .x = 650, .y = 480, .width = 80, .height = 30 }, "Item")) {

    }
}


