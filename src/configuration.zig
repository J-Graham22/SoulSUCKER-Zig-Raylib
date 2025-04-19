const std = @import("std");

const rl = @import("raylib");

const battleModels = @import("battleModels.zig");

pub fn LoadPlayerParty() [*]battleModels.BattleUnit {

    //TODO: integrate logic to pull player data from a json file or something
    //
    //

    const aMove: battleModels.Move = battleModels.Move{ .name = "the wham bam attack", .stat = battleModels.Stat.Attack, .value = 30 };

    const moves: [6]battleModels.Move = [6]battleModels.Move{ aMove, aMove, aMove, aMove, aMove, aMove };

    const unit1: battleModels.BattleUnit = battleModels.BattleUnit{ .name = "player1", .level = 5, .currentHealth = 20, .maxHealth = 30, .currentAttack = 10, .baseAttack = 10, .currentMagicAttack = 15, .baseMagicAttack = 15, .currentDefense = 12, .baseDefense = 12, .currentMagicDefense = 8, .baseMagicDefense = 8, .currentSpeed = 30, .baseSpeed = 30, .moves = moves, .backRow = false };

    const unit2: battleModels.BattleUnit = battleModels.BattleUnit{ .name = "player2", .level = 5, .currentHealth = 20, .maxHealth = 30, .currentAttack = 10, .baseAttack = 10, .currentMagicAttack = 15, .baseMagicAttack = 15, .currentDefense = 12, .baseDefense = 12, .currentMagicDefense = 8, .baseMagicDefense = 8, .currentSpeed = 30, .baseSpeed = 30, .moves = moves, .backRow = true };

    const unit3: battleModels.BattleUnit = battleModels.BattleUnit{ .name = "player3", .level = 5, .currentHealth = 20, .maxHealth = 30, .currentAttack = 10, .baseAttack = 10, .currentMagicAttack = 15, .baseMagicAttack = 15, .currentDefense = 12, .baseDefense = 12, .currentMagicDefense = 8, .baseMagicDefense = 8, .currentSpeed = 30, .baseSpeed = 30, .moves = moves, .backRow = true };

    const unit4: battleModels.BattleUnit = battleModels.BattleUnit{ .name = "player4", .level = 5, .currentHealth = 20, .maxHealth = 30, .currentAttack = 10, .baseAttack = 10, .currentMagicAttack = 15, .baseMagicAttack = 15, .currentDefense = 12, .baseDefense = 12, .currentMagicDefense = 8, .baseMagicDefense = 8, .currentSpeed = 30, .baseSpeed = 30, .moves = moves, .backRow = false };

    var playerParty = [_]battleModels.BattleUnit{ unit1, unit2, unit3, unit4 };

    return &playerParty;
}

pub fn LoadEnemyParty() [*]battleModels.BattleUnit {

    //TODO: integrate logic to pull player data from a json file or something
    //
    //

    const aMove: battleModels.Move = battleModels.Move{ .name = "the wham bam attack", .stat = battleModels.Stat.Attack, .value = 30 };

    const moves: [6]battleModels.Move = [6]battleModels.Move{ aMove, aMove, aMove, aMove, aMove, aMove };

    const unit1: battleModels.BattleUnit = battleModels.BattleUnit{ .name = "enemy1", .level = 5, .currentHealth = 20, .maxHealth = 30, .currentAttack = 10, .baseAttack = 10, .currentMagicAttack = 15, .baseMagicAttack = 15, .currentDefense = 12, .baseDefense = 12, .currentMagicDefense = 8, .baseMagicDefense = 8, .currentSpeed = 30, .baseSpeed = 30, .moves = moves, .backRow = false };

    const unit2: battleModels.BattleUnit = battleModels.BattleUnit{ .name = "enemy2", .level = 5, .currentHealth = 20, .maxHealth = 30, .currentAttack = 10, .baseAttack = 10, .currentMagicAttack = 15, .baseMagicAttack = 15, .currentDefense = 12, .baseDefense = 12, .currentMagicDefense = 8, .baseMagicDefense = 8, .currentSpeed = 30, .baseSpeed = 30, .moves = moves, .backRow = false };

    const unit3: battleModels.BattleUnit = battleModels.BattleUnit{ .name = "enemy3", .level = 5, .currentHealth = 20, .maxHealth = 30, .currentAttack = 10, .baseAttack = 10, .currentMagicAttack = 15, .baseMagicAttack = 15, .currentDefense = 12, .baseDefense = 12, .currentMagicDefense = 8, .baseMagicDefense = 8, .currentSpeed = 30, .baseSpeed = 30, .moves = moves, .backRow = true };

    const unit4: battleModels.BattleUnit = battleModels.BattleUnit{ .name = "enemy4", .level = 5, .currentHealth = 20, .maxHealth = 30, .currentAttack = 10, .baseAttack = 10, .currentMagicAttack = 15, .baseMagicAttack = 15, .currentDefense = 12, .baseDefense = 12, .currentMagicDefense = 8, .baseMagicDefense = 8, .currentSpeed = 30, .baseSpeed = 30, .moves = moves, .backRow = true };

    var playerParty = [_]battleModels.BattleUnit{ unit1, unit2, unit3, unit4 };

    return &playerParty;
}
