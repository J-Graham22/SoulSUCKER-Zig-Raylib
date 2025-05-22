const rl = @import("raylib");
const std = @import("std");

const walkableTiles = @import("tileset.zig").walkableTileset;
const nonWalkableTiles = @import("tileset.zig").nonwalkableTileset;

const TileErrors = error{
    ImageNotFound,
    TextureNotLoaded,
    FileAccessError,
    TileListError,
    OutOfMemoryError,
    //std.fmt.ParseIntError,
    //std.os.OpenError,
};

pub const Tile = struct {
    id: usize,
    walkable: bool,
    tilemapX: u32,
    tilemapY: u32,
    worldX: u32,
    worldY: u32,
    texture: ?rl.Texture,
};

pub const Tilemap = struct {
    mapWidth: u32,
    mapHeight: u32,
    tileSize: u8,
    tileSet: [3][]const u8, // TODO: change later to something different, need to figure out a way to coerce or something

    pub fn init(mapWidth: u32, mapHeight: u32, tileSize: u8, tileSet: [3][]const u8) Tilemap {
        return Tilemap {
            .mapWidth = mapWidth,
            .mapHeight = mapHeight,
            .tileSize = tileSize,
            .tileSet = tileSet,
        };
    }

    pub fn loadTileMapFile(self: *Tilemap, tilemapFile: []const u8) TileErrors![]const Tile {
        const allocator = std.heap.page_allocator;
        const arrSize: usize = self.mapWidth * self.mapHeight;

        const tileSlice = allocator.alloc(Tile, arrSize) catch {
            return TileErrors.OutOfMemoryError;
        };

        var file = std.fs.cwd().openFile(tilemapFile, .{}) catch {
            return TileErrors.FileAccessError;
        };
        defer file.close();

        var buffReader = std.io.bufferedReader(file.reader());
        var inStream = buffReader.reader();


        var tilesAdded: u32 = 0;

        while (true) {
            var buf: [1024]u8 = undefined;
            const line_or_err = inStream.readUntilDelimiterOrEof(&buf, '\n') catch |err| {
                if(err == error.EndOfStream) {
                    std.debug.print("end of file", .{});
                    break;
                } else {
                    return TileErrors.FileAccessError;
                }
            };
            if (line_or_err) |line| {
                // process `line` here
                std.debug.print("line: {s}\n", .{line});
                var iter = std.mem.splitSequence(u8, line, ",");
                
                while(iter.next()) |part| {
                    std.debug.print("the unparsed part is {s}\n", .{part});
                    const indexIsize = std.fmt.parseInt(isize, part, 10) catch {
                        return TileErrors.FileAccessError;
                    };

                    if(indexIsize == -1) {
                        const tile: Tile = Tile{
                            .id = 12,
                            .walkable = true,
                            .texture = null,
                        };
                        tileSlice[tilesAdded] = tile;
                        tilesAdded += 1;
                        continue;
                    }

                    const index: usize = @intCast(indexIsize);

                    const pathBeforeCast = self.tileSet[index];
                    const tileImagePath: [:0]const u8 = @ptrCast(pathBeforeCast);

                    const tileImage = rl.loadImage(tileImagePath) catch |err| {
                        std.debug.print("the index is {}\n", .{index});
                        std.debug.print("encountered error opening image - {}\n", .{err});
                        return TileErrors.ImageNotFound;
                    };

                    const tileTexture = rl.loadTextureFromImage(tileImage) catch {
                        return TileErrors.TextureNotLoaded;
                    };
                    tileImage.unload();
                    //rl.unloadImage(tileImage);

                    const tileX: i32 = @intCast(@mod(tilesAdded, self.mapWidth));
                    const tileY: i32 = @intCast((tilesAdded / self.mapWidth));

                    const realX: i32 = tileX * self.tileSize;
                    const realY: i32 = tileY * self.tileSize;

                    const tile: Tile = Tile{
                        .id = 12,
                        .walkable = if(indexIsize == -1) false else true, //TODO: replace with a function that determines if the index is in a list of walkable tiles
                        .texture = tileTexture,
                        .tilemapX = tileX,
                        .tilemapY = tileY,
                        .worldX = realX,
                        .worldY = realY,
                    };

                    std.debug.print("tiles Slice length is {}\n", .{tileSlice.len});
                    std.debug.print("adding tile at index {}\n", .{tilesAdded});
                    tileSlice[tilesAdded] = tile;
                    tilesAdded += 1;
                }
            } else {
                std.debug.print("end of file", .{});
                break; // End of file
            }
        }

        return tileSlice;
    }

    pub fn draw(self: *Tilemap, tiles: []const Tile) void {
        for(tiles, 0..) |tile, i| {
            const x: i32 = @intCast(@mod(i, self.mapWidth) * self.tileSize);
            const y: i32 = @intCast((i / self.mapWidth) * self.tileSize);

            if(tile.texture == null) {
                //std.debug.print("drawing void at {},{}\n", .{x, y});
                rl.drawRectangle(x, y, x + self.tileSize, y + self.tileSize, rl.Color.white);
                continue;
            }

            //std.debug.print("drawing tile at {},{}\n", .{x, y});
            rl.drawTexture(tile.texture.?, x, y, rl.Color.red);
        }
    }

};
