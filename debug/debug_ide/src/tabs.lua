---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local debug_ide = _G[modname]

local function clamp(val, min, max)
    return math.min(math.max(val, min), max)
end

local function get_id(ide_player)
    ide_player.last_tab_id = ide_player.last_tab_id + 1
    return ide_player.last_tab_id
end

local function tab_index_from_id(ide_player, id)
    for i, tab in ipairs(ide_player.tabs) do
        if tab.id == id then
            return i
        end
    end
end

---@diagnostic disable-next-line:deprecated
local unpack = table.unpack or unpack

function debug_ide.make_tabs(ide_player)
    local WIDTH = debug_ide.WIDTH
    local UNIT = debug_ide.UNIT
    local TAB_WIDTH = debug_ide.TAB_WIDTH

    local tabs = ide_player.tabs
    local num = #tabs
    local tree = {}

    local tab_width = clamp((WIDTH - 2 * UNIT) / num, 2 * UNIT, TAB_WIDTH)

    -- FIXME: if enough tabs are spawned, the tab bounds can be overflowed
    -- a scrollbar should be used in this case

    for i, tab in ipairs(tabs) do
        local id = tab.id
        local name = tab.name

        if tab.id == ide_player.selected then
            name = minetest.colorize(debug_ide.SELECT_COLOR, name)
        end

        table.insert(tree, {
            type = "container",
            x = (i - 1) * tab_width .. "c",
            y = 0,
            {
                -- tab button
                type = "button",
                x = 0,
                y = 0,
                w = tab_width - UNIT .. "c",
                h = UNIT .. "c",
                name = "tab:" .. id,
                label = name,
            },
            {
                -- close button
                type = "button",
                x = tab_width - UNIT .. "c",
                y = 0,
                w = UNIT .. "c",
                h = UNIT .. "c",
                name = "closetab:" .. id,
                label = "X",
            }
        })
    end

    table.insert(tree, {
        -- new tab button
        type = "button",
        x = tab_width * num .. "c",
        y = 0,
        w = UNIT .. "c",
        h = UNIT .. "c",
        name = "newtab",
        label = "+",
    })

    return tree
end

function debug_ide.new_tab(ide_player)
    local index =
        #ide_player.untitled_tabs > 0
        and math.max(unpack(ide_player.untitled_tabs)) + 1
        or 1

    table.insert(ide_player.untitled_tabs, index)

    local tab = {
        id = get_id(ide_player),
        name = "Untitled " .. index .. ".lua",
        untitled = index,
    }

    table.insert(ide_player.tabs, tab)

    ide_player.selected = tab.id

    debug_ide.show_ide(ide_player)
end

function debug_ide.ununtitle_tab(ide_player, tab)
    if not tab.untitled then
        return
    end

    for i, index in ipairs(ide_player.untitled_tabs) do
        if tab.untitled == index then
            table.remove(ide_player.untitled_tabs, i)
            break
        end
    end
end

function debug_ide.close_tab(ide_player, id)
    local i = tab_index_from_id(ide_player, id)
    local tab = ide_player.tabs[i]

    debug_ide.ununtitle_tab(ide_player, tab)
    table.remove(ide_player.tabs, i)

    if tab.id == ide_player.selected then
        ide_player.selected =
            ide_player.tabs[i - 1]
            and ide_player.tabs[i - 1].id
            or ide_player.tabs[i]
            and ide_player.tabs[i].id
    end

    debug_ide.show_ide(ide_player)
end

function debug_ide.select_tab(ide_player, id)
    ide_player.selected = id
    debug_ide.show_ide(ide_player)
end
