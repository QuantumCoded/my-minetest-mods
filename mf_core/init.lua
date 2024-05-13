---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local mf_core = {
    materials = {},
    item_forms = {},
    node_forms = {},
    tool_forms = {},
}

_G[modname] = mf_core

dofile(modpath .. "/src/override.lua")
dofile(modpath .. "/src/register.lua")
dofile(modpath .. "/src/textures.lua")

function mf_core.pascal_case(str)
    local words = {}

    for word in str:gmatch("[^_- ]+") do
        table.insert(words, ({ word:gsub("^%l", string.upper) })[1])
    end

    return table.concat(words, " ")
end

function mf_core.material_display_name(material)
    return material.description or mf_core.pascal_case(material.name)
end

function mf_core.set_material_attribute(material_name, key, value)
    assert(
        mf_core.materials[material_name] ~= nil,
        "material '" .. material_name .. "' has not been registered."
    )

    mf_core.materials[material_name].attributes[key] = value
end

function mf_core.get_material_attribute(material_name, key)
    if mf_core.materials[material_name] == nil then
        return nil
    end

    return mf_core.materials[material_name].attributes[key]
end
