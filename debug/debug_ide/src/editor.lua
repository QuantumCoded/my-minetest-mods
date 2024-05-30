---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local debug_ide = _G[modname]

function debug_ide.make_editor(ide_player)
    local UNIT = debug_ide.UNIT
    local WIDTH = debug_ide.WIDTH
    local HEIGHT = debug_ide.HEIGHT

    if not ide_player.selected then
        return
    end

    return {
        type = "textarea",
        x = UNIT .. "c",
        y = 2 * UNIT .. "c",
        w = WIDTH - 2 * UNIT .. "c",
        -- not sure where the magic number comes from, but it works well enough
        h = (HEIGHT - 3 * UNIT) * 1.126 .. "c",
        name = "debug_ide:" .. ide_player.name,
    }
end
