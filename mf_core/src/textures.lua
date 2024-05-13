---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local mf_core = _G[modname]

function mf_core.colorize_material(material)
    if material.colorize_modifier then
        return material.colorize_modifier
    end

    return "^[multiply:" .. material.color
end

function mf_core.material_texture(material, texture)
    local modifier = mf_core.colorize_material(material)
    return texture .. modifier
end

function mf_core.material_overlay(material, bottom, top)
    local overlay = mf_core.material_texture(material, top)
    return string.format("%s^(%s)", bottom, overlay)
end
