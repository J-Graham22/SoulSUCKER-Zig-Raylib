const std = @import("std");
const rl = @import("raylib");
const rgui = @import("raygui");

pub const main_menu = struct {
    pub fn loadMainMenu() void {
        rl.beginDrawing();
        defer rl.endDrawing();

        std.debug.print("loading menu\n", .{});
        var currentScreen: enum { MainMenu, Options, Game, Exit } = .MainMenu;
        while (!rl.windowShouldClose() and currentScreen != .Exit) {
            std.debug.print("beginning of while loop\n", .{});
            rl.clearBackground(rl.Color.white);

            rl.drawText("My Game", 330, 100, 40, rl.Color.gray);

            //TODO: do some calculations to actually place these buttons relative to screen size

            switch (currentScreen) {
                .MainMenu => {
                    std.debug.print("main menu\n", .{});
                    if (rgui.guiButton(rl.Rectangle{ .x = 300, .y = 150, .width = 200, .height = 50 }, "Start Game") > 0) {
                        currentScreen = .Game;
                    }
                    if (rgui.guiButton(rl.Rectangle{ .x = 300, .y = 220, .width = 200, .height = 50 }, "Options") > 0) {
                        currentScreen = .Options;
                    }
                    if (rgui.guiButton(rl.Rectangle{ .x = 300, .y = 290, .width = 200, .height = 50 }, "Quit") > 0) {
                        currentScreen = .Exit;
                    }
                },
                .Options => {
                    std.debug.print("options menu\n", .{});
                    if (rgui.guiButton(rl.Rectangle{ .x = 300, .y = 300, .width = 200, .height = 50 }, "Back") > 0) {
                        currentScreen = .MainMenu;
                    }
                },
                .Game => {
                    std.debug.print("game menu\n", .{});
                    if (rgui.guiButton(rl.Rectangle{ .x = 10, .y = 10, .width = 100, .height = 30 }, "Main Menu") > 0) {
                        currentScreen = .MainMenu;
                    }
                },
                else => {},
            }
        }
    }

};

