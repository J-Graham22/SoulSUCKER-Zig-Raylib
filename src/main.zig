const rl = @import("raylib");
const rg = @import("raygui");
const std = @import("std");

const mainMenu = @import("mainMenu.zig");

const battleModels = @import("battleModels.zig");
const configuration = @import("configuration.zig");
const sceneManager = @import("sceneManager.zig");

const settings = @import("settings.zig").settings;
const buttonMap = @import("buttonMapping.zig");
const saving = @import("saveSystem.zig");

const Scene2D = @import("2DScene.zig").Scene2D;
const Scene3D = @import("3DScene.zig").Scene3D;
const Tilemap = @import("tileset.zig");

const NewGame = @import("newGameInfo.zig");

const Global = @import("globalVariables.zig").global;
/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("ZigRaylibGame_lib");

pub var gameSettings: settings = undefined;


var debugCamera: bool = false;


pub fn main() !void {
    // Flow of opening the game

    // 1. Check for existing settings. 
    // If there are none, then this is the first time that the game has been opened here.
    // In which case, we need to do some logic to determine the best settings
    // If settings are already there, then we apply them
    gameSettings = settings.GetSettingsAtStartup(); 

    rl.initWindow(gameSettings.screenWidth, gameSettings.screenHeight, "Necrobution");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    //const gokuImage = try rl.loadImage("src/assets/goku.png");
    //const gokuTexture = try rl.loadTextureFromImage(gokuImage);

    //rl.unloadImage(gokuImage);
    //defer rl.unloadTexture(gokuTexture);

    std.debug.print("loading menu\n", .{});

    var currentScreen: enum { MainMenu, Options, Game, Exit } = .MainMenu;

    const font = try rl.loadFont("src/assets/fonts/CloisterBlack.ttf");
    defer rl.unloadFont(font);

    rg.guiSetFont(font);

    while (!rl.windowShouldClose() and currentScreen != .Exit) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.yellow);

        rl.drawText("NECTROBUTION", 330, 100, 40, rl.Color.gray);
        //TODO: improve this main menu screen a lot
        rl.drawText("WIP title screen", 530, 170, 40, rl.Color.gray);

        //TODO: do some calculations to actually place these buttons relative to screen size

        switch (currentScreen) {
            .MainMenu => {
                const saveDataExists = try saving.checkIfSaveDataExists();

                if(saveDataExists) {
                    if (rg.guiButton(rl.Rectangle{ .x = 300, .y = 300, .width = 200, .height = 50 }, "Continue") > 0) {
                        currentScreen = .Game;
                    }
                }
                if (rg.guiButton(rl.Rectangle{ .x = 300, .y = 370, .width = 200, .height = 50 }, "New Game") > 0) {
                    //const data = &[_][]const u8
                    //const tilesetLen = Tilemap.walkableTileset.len;
                    //const data: [tilesetLen][]const u8 = &[_][]const u8{Tilemap.walkableTileset[0..];
                    //try NewGame.createNewSave(1);
                    //NewGame.loadNewSaveInfo(&playerParty, &current2DScene);

                    //const startScene: Scene2D = Scene2D{
                        //.tilemapPath = "src/assets/tilemaps/test.csv",
                        //.tileset = Tilemap.walkableTileset,
                        //.playerPosX = 0.0,
                        //.playerPosY = 0.0,
                    //};
                    try sceneManager.Load2DScene(Global.current2DScene);
                }
                if (rg.guiButton(rl.Rectangle{ .x = 300, .y = 420, .width = 200, .height = 50 }, "Options") > 0) {
                    currentScreen = .Options;
                }
                if (rg.guiButton(rl.Rectangle{ .x = 300, .y = 490, .width = 200, .height = 50 }, "Quit") > 0) {
                    currentScreen = .Exit;
                }
            },
            .Options => {
                if (rg.guiButton(rl.Rectangle{ .x = 300, .y = 300, .width = 200, .height = 50 }, "Back") > 0) {
                    currentScreen = .MainMenu;
                }
            },
            .Game => {
                if (rg.guiButton(rl.Rectangle{ .x = 10, .y = 10, .width = 100, .height = 30 }, "Main Menu") > 0) {
                    currentScreen = .MainMenu;
                }
            },
            else => {},
        }
    }
}

