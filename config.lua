Config = {}

Config.Weapons = {
    `weapon_smg_mk2`,
    `weapon_microsmg`,
    `weapon_combatpdw`,
    `weapon_smg`,
    `weapon_assaultsmg`,
    `weapon_bullpupshotgun`,
    `weapon_dbshotgun`,
    `weapon_carbinerifle`,
    `weapon_compactrifle`,
    `weapon_pumpshotgun`,
    `weapon_assaultrifle`,
    `weapon_pumpshotgun_mk2`,
    `weapon_appistol`
}

Config.Zones = {
    {
        type = "green",
        title = "Bezpieczna Strefa",
        id = 487,
        clr = 2,

        enter = "Znajdujesz się w bezpiecznej strefie!",
        leave = "Opuściłeś bezpieczną strefę!",
        color = { r = 1, g = 143, b = 1 },

        bubbles = {
            vector4(718.71, -963.32, 21.54, 30.0)
        } 
    },
    {
        type = "yellow",
        title = "Żółta Strefa",
        id = 487,
        clr = 5,

        enter = "Znajdujesz się w żółtej strefie!",
        leave = "Opuściłeś żółtą strefę!",
        color = { r = 217, g = 195, b = 0 },

        bubbles = {
            vector4(783.67, -1005.29, 21.0, 100.0)
        }
    },
    {
        type = "red",
        title = "Czerwona Strefa",
        id = 487,
        clr = 49,

        enter = "Znajdujesz się w czerwonej strefie!",
        leave = "Opuściłeś czerwoną strefę!",
        color = { r = 140, g = 2, b = 2 },

        bubbles = {
            vector4(-196.66, -2555.17, -11.0, 200.0),
            vector4(2419.89, 4877.87, 30.0, 200.0),
            vector4(664.34, 2986.14, 30.0, 200.0),          
            vector4(36.83, 6418.23, 21.24, 200.0)
        }
    }
}
