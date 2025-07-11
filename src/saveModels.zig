const BattleModels = @import("battleModels.zig");

pub const SerializablePlayerParty = extern struct {
    unit1: ?*const SerializableBattleUnit,
    unit2: ?*const SerializableBattleUnit,
    unit3: ?*const SerializableBattleUnit,
    unit4: ?*const SerializableBattleUnit,
};

pub const SerializableBattleUnit = extern struct {
    name: [*]const u8,
    level: u8,
    exp: u16,
    expToNextLevel: u16,
    currentHealth: u16,
    maxHealth: u16,
    baseAttack: u16,
    baseMagicAttack: u16,
    baseDefense: u16,
    baseMagicDefense: u16,
    baseSpeed: u16,
    move1: ?*const BattleModels.Move,
    move2: ?*const BattleModels.Move,
    move3: ?*const BattleModels.Move,
    move4: ?*const BattleModels.Move,
    move5: ?*const BattleModels.Move,
    move6: ?*const BattleModels.Move,
    backRow: bool,
    pathToModel: [*]const u8,
};

pub fn savePlayerParty(_: [4]?BattleModels.BattleUnit) SerializablePlayerParty {

}

pub fn loadPlayerParty(saveDataParty: SerializablePlayerParty) [4]?BattleModels.BattleUnit {
    var playerParty: [4]?BattleModels.BattleUnit = undefined;

    for(0..playerParty.len) |i| {
        var unit: ?*const SerializableBattleUnit = undefined;

        switch (i) {
            0 => unit = saveDataParty.unit1,
            1 => unit = saveDataParty.unit2,
            2 => unit = saveDataParty.unit3,
            3 => unit = saveDataParty.unit4,
        }

        if(unit == null) {
            playerParty[i] = null;
            continue;
        }

        var moves: [6]?BattleModels.Move = undefined;

        for(0..moves.len) |j| {
            var move: ?*const BattleModels.Move = undefined;
            switch (j) {
                0 => move = unit.?.move1,
                1 => move = unit.?.move2,
                2 => move = unit.?.move3,
                3 => move = unit.?.move4,
                4 => move = unit.?.move5,
                5 => move = unit.?.move6,
            }

            if(move == null) {
                moves[j] = null;
            } else {
                moves[j] = BattleModels.Move{ .name = move.?.name, .stat = move.?.stat, .value = move.?.value };
            }
        }
    }

    return playerParty;
}
