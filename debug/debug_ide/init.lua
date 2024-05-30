---@diagnostic disable:undefined-global

local storage = minetest.get_mod_storage()
local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local debug_ide = {
    players = {},
    WIDTH = 18,
    HEIGHT = 12,
    UNIT = 0.5,
    TAB_WIDTH = 4,
    SELECT_COLOR = "dodgerblue",
}

_G[modname] = debug_ide

dofile(modpath .. "/src/editor.lua")
dofile(modpath .. "/src/ide.lua")
dofile(modpath .. "/src/tabs.lua")

function debug_ide.save(ide_player)
    debug.send("SAVING!")
    storage:set_string(ide_player.name, minetest.serialize(ide_player))
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local name = player:get_player_name()
    local ide_player = debug_ide.players[name]

    if formname ~= "debug_ide" then
        return
    end

    if fields.newtab then
        debug_ide.new_tab(ide_player)
    end

    local s = ""
    for field, _ in pairs(fields) do
        s = s .. field .. ", "
        local event, id = string.match(field, "(%w+):(%d+)")

        id = tonumber(id)

        if event == "closetab" then
            debug_ide.close_tab(ide_player, id)
            break
        end

        if event == "tab" then
            debug_ide.select_tab(ide_player, id)
            break
        end
    end

    debug.send(s)
end)

minetest.register_chatcommand("ide", {
    description = "Opens an IDE for working on Minetest scripts",
    func = function(name)
        local ide_player = debug_ide.players[name]

        if #ide_player.tabs == 0 then
            debug_ide.new_tab(ide_player)
            return
        end

        debug_ide.show_ide(ide_player)
    end,
})

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()

    debug_ide.players[name] =
        minetest.deserialize(storage:get_string(name))
        or {
            name = name,
            tabs = {},
            untitled_tabs = {},
            last_tab_id = 0,
        }
end)

minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    debug_ide.players[name] = nil
end)
