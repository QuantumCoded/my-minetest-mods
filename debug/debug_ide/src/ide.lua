---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local debug_ide = _G[modname]

function debug_ide.show_ide(ide_player)
    local WIDTH = debug_ide.WIDTH
    local HEIGHT = debug_ide.HEIGHT
    local UNIT = debug_ide.UNIT

    local tree = {
        { type = "size", w = WIDTH .. "c", h = HEIGHT .. "c" },
        { type = "padding", x = 0, y = 0 },
        { type = "no_prepend" },
        { type = "bgcolor", bgcolor = "#0000" },
        {
            -- background
            type = "box",
            x = 0,
            y = 0,
            w = WIDTH .. "c",
            h = HEIGHT .. "c",
            color = "#222F",
        },
        {
            -- close button
            type = "button_exit",
            x = WIDTH - UNIT .. "c",
            y = 0,
            w = UNIT .. "c",
            h = UNIT .. "c",
            name = "close",
            label = minetest.colorize("red", "X"),
        },
    }

    local tabs = debug_ide.make_tabs(ide_player)
    for _, tab in ipairs(tabs) do
        table.insert(tree, tab)
    end

    local editor = debug_ide.make_editor(ide_player)
    if editor then
        table.insert(tree, editor)
    end

    local formspec = formspec_ast.unparse(tree)
    formspec = string.gsub(formspec, "%]container%[", "]margin[")
    formspec = string.gsub(formspec, "%]container_end%[", "]margin_end[")
    formspec = scarlet.translate_96dpi(formspec)
    minetest.show_formspec(ide_player.name, "debug_ide", formspec)
end
