pub const Stat = enum { Health, Attack, MagicAttack, Defense, MagicDefense, Speed };

pub const Move = struct { name: []const u8, stat: Stat, value: i16 };

pub const BattleUnit = struct { name: []const u8, level: u8, currentHealth: u16, maxHealth: u16, currentAttack: u16, baseAttack: u16, currentMagicAttack: u16, baseMagicAttack: u16, currentDefense: u16, baseDefense: u16, currentMagicDefense: u16, baseMagicDefense: u16, currentSpeed: u16, baseSpeed: u16, moves: [6]Move, backRow: bool };

pub const Action = struct { unit: *BattleUnit, target: *BattleUnit, move: *Move };
