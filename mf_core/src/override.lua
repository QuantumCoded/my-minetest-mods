---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local mf_core = _G[modname]

function mf_core.override(bottom, top)
    local override = {}

    for key, value in pairs(top) do
        override[key] = value
    end

    for key, value in pairs(bottom) do
        if override[key] == nil then
            override[key] = value
        end
    end

    return override
end

function mf_core.override_material(material, form_name)
    if
        material.override_material == nil
        or material.override_material[form_name] == nil
    then
        return material
    end

    return mf_core.override(material, material.override_material[form_name])
end

function mf_core.override_definition(material, form_name, definition)
    if
        material.override_definition == nil
        or material.override_definition[form_name] == nil
    then
        return definition
    end

    return mf_core.override(definition, material.override_definition[form_name])
end
