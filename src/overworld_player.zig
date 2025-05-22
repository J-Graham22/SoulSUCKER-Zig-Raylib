const std = @import("std");
const rl = @import("raylib");

const tilemap = @import("tilemap.zig");

const dir = enum {
    LEFT,
    RIGHT,
    UP,
    DOWN, 
};

const TWEEN_FRAMES: u8 = 10;

pub const OverworldPlayer = struct {
    x: i32,
    y: i32,
    tileSize: u8,
    texture: rl.Texture2D,

    direction: dir = undefined,
    numberOfFramesLeftForTween: u8 = 0,
    targetX: i32,
    targetY: i32,
    

    pub fn init(x: i32, y: i32, tileSize: u8, texturePath: []const u8) OverworldPlayer {
        const playerImagePath: [:0]const u8 = @ptrCast(texturePath);

        const playerTextureImage = rl.loadImage(playerImagePath) catch unreachable;
        const playerTexture = rl.loadTextureFromImage(playerTextureImage) catch unreachable;
        playerTextureImage.unload();

        return OverworldPlayer{
            .x = x,
            .y = y,
            .tileSize = tileSize,
            .texture = playerTexture,
            .targetX = x,
            .targetY = y,
        };
    }

    pub fn handleMovement(self: *OverworldPlayer, map: tilemap.Tilemap, tilesSlice: []const tilemap.Tile) void {
        if(self.numberOfFramesLeftForTween > 0) {
            //now target pos has been set, let's see if we can move there
            std.debug.print("checking if target x {} and target y {} is a valid position\n", .{self.targetX, self.targetY});
            var validTarget = true;
            if((self.targetX < 0 or self.targetX > map.mapWidth * map.tileSize) or
                (self.targetY < 0 or self.targetY > map.mapHeight * map.tileSize)) {
                std.debug.print("outside tilemap\n", .{});
                validTarget = false; //ban areas outside tilemap
            }

            const xPosTileSpace: i32 = @divFloor(self.targetX, self.tileSize);
            const yPosTileSpace: i32 = @divFloor(self.targetY, self.tileSize);
            const mapWidth_i32Cast: i32 = @intCast(map.mapWidth);
            const tileIndex_isize: isize = @intCast((yPosTileSpace * mapWidth_i32Cast) + xPosTileSpace);
            
            std.debug.print("got tile index {}\n", .{tileIndex_isize});
            if(tileIndex_isize < 0 or tileIndex_isize >= tilesSlice.len) validTarget = false;

            const tileIndex: usize = @intCast(tileIndex_isize);
            std.debug.print("is tile walkable? {}\n", .{tilesSlice[tileIndex].walkable});
            if(tilesSlice[tileIndex].walkable == false) validTarget = false;

            if(!validTarget) {
                std.debug.print("ILLEGAL!! *BUZZER* target pos is outside tile map\n", .{});
                //can't walk there
                self.numberOfFramesLeftForTween = 0; //reset tween frames
                self.targetX = self.x; //reset target pos
                self.targetY = self.y;
                return;
            }

            // we want it to take a like 10 frames to move
            const pixelsToMovePerFrame: u8 = self.tileSize / TWEEN_FRAMES; //10 frames of tweening

            switch (self.direction) {
                dir.LEFT => {
                    //const pixelsToMove: i32 = if(self.x - pixelsToMovePerFrame >= self.targetX) pixelsToMovePerFrame else self.targetX - self.x;
                    //self.x -= pixelsToMove;
                    self.x -= pixelsToMovePerFrame;
                },
                dir.RIGHT => {
                    //const pixelsToMove: i32 = if(self.x + pixelsToMovePerFrame <= self.targetX) pixelsToMovePerFrame else self.targetX - self.x;
                    //self.x += pixelsToMove; 
                    self.x += pixelsToMovePerFrame; 
                },
                dir.UP => {
                    //const pixelsToMove: i32 = if(self.y - pixelsToMovePerFrame >= self.targetY) pixelsToMovePerFrame else self.targetY - self.y;
                    //self.y -= pixelsToMove; 
                    self.y -= pixelsToMovePerFrame; 
                },
                dir.DOWN => {
                    //const pixelsToMove: i32 = if(self.y + pixelsToMovePerFrame <= self.targetY) pixelsToMovePerFrame else self.targetY - self.y;
                    //self.y += pixelsToMove;
                    self.y += pixelsToMovePerFrame;
                },
            }
            self.numberOfFramesLeftForTween -= 1;
        } else {
            //here we know the the animation has finished, so we can double check to make sure that the player hit target pos
            if(self.x != self.targetX or self.y != self.targetY) {
                self.x = self.targetX; 
                self.y = self.targetY;
            }

            if (rl.isKeyPressed(rl.KeyboardKey.w)) {
                self.numberOfFramesLeftForTween = TWEEN_FRAMES;
                self.targetY -= 32;
                self.direction = dir.UP;
            }
            if (rl.isKeyPressed(rl.KeyboardKey.a)) {
                self.numberOfFramesLeftForTween = TWEEN_FRAMES;
                self.targetX -= 32;
                self.direction = dir.LEFT;
            }
            if (rl.isKeyPressed(rl.KeyboardKey.s)) {
                self.numberOfFramesLeftForTween = TWEEN_FRAMES;
                self.targetY += 32;
                self.direction = dir.DOWN;
            }
            if (rl.isKeyPressed(rl.KeyboardKey.d)) {
                self.numberOfFramesLeftForTween = TWEEN_FRAMES;
                self.targetX += 32;
                self.direction = dir.RIGHT;
            }
        }
    }

    pub fn draw(self: *OverworldPlayer) void {
        rl.drawTexture(self.texture, self.x, self.y, rl.Color.white);
    }

};
