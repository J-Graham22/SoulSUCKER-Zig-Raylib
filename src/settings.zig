const std = @import("std");

const resolution = enum {
    RES_1920x1080,
    RES_1280x720,
};

pub const settings = extern struct {
    screenWidth: i32,
    screenHeight: i32,
    masterVolume: u8,
    musicVolume: u8,
    sfxVolume: u8,

    pub fn GetSettingsAtStartup() settings {
        if(CheckForExistingSettings()) {
            // existing settings
            return ReadExistingSettings();
        } else {
            return init();
        }
    }

    pub fn init() settings {
        //TODO: insert some logic here to determine the ideal screen width and height based on the user's monitor
        return settings{
            .screenWidth = 1280,
            .screenHeight = 720,
            .masterVolume = 100,
            .musicVolume = 100,
            .sfxVolume = 100,
        };

        //TODO: separate the settings out from the save data 
    }

    fn CheckForExistingSettings() bool {
        //TODO: update with actual logic
        return false;
    }

    fn ReadExistingSettings() settings {
        //TODO: update with actual logic
        return init();
    }
};
