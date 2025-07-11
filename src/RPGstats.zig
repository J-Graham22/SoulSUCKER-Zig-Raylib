const std = @import("std");
const rl = @import("raylib");
const BattleModels = @import("battleModels.zig");

pub const MoveLearn = extern struct {
    moveId: u16,
    level: u8,
};

pub const UnitInfo = extern struct {
    name: [*]const u8,
    currentLevel: u8,
    currentExp: u16,
    healthLvl1: u16,
    attackLvl1: u16,
    magicAttackLvl1: u16,
    defenseLvl1: u16,
    magicDefenseLvl1: u16,
    speedLvl1: u16,
    movesToLearn: []MoveLearn,
    movesToLearnLen: usize,
    pathToModel: [*]const u8,
    
    pub fn GetExpToLevel(level: u8) u16 {
        return level * 10; //TODO: replace this with a real function for calculating the exp curve later
    }

    pub fn GetAllMovesForLevel(self: *UnitInfo) []BattleModels.Move {
        const allocator = std.heap.page_allocator;
        var movesList = std.ArrayList(BattleModels.Move).init(allocator);

        for(0..self.movesToLearnLen) |i| {
            const move = self.movesToLearn[i];

            if(move.level > self.currentLevel) continue;


        }
    }
};
