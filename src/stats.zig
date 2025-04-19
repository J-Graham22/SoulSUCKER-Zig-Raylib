const battleModels = @import("battleModels.zig");

const StatModifier = struct {
    stat: battleModels.Stat,
    value: i4,
};

pub fn CalculateExpEarned(partyMember: *battleModels.BattleUnit, enemyParty: []battleModels.BattleUnit) u16 {}
