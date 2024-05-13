---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local mf_core = _G[modname]

local function _register_form(tbl, name, form)
    assert(
        tbl[name] == nil,
        "item form '" .. name .. "' already registered."
    )

    form.name = name

    tbl[name] = form
end

local function _register_item(form_type, material_name, form_name)
    local mt_form_type = form_type == "item" and "craftitem" or form_type

    assert(
        mf_core.materials[material_name] ~= nil,
        "material '" .. material_name .. "' has not been registered."
    )

    assert(
        mf_core[form_type .. "_forms"][form_name] ~= nil,
        form_type .. " form '" .. form_name .. "' has not been registered."
    )

    local material = mf_core.override_material(
        mf_core.materials[material_name],
        form_name
    )

    local name, definition = mf_core[form_type .. "_forms"][form_name]
        .from_material(material)

    minetest["register_" .. mt_form_type](
        name,
        mf_core.override_definition(material, form_name, definition)
    )
end

function mf_core.register_item_form(name, form)
    _register_form(mf_core.item_forms, name, form)
end

function mf_core.register_node_form(name, form)
    _register_form(mf_core.node_forms, name, form)
end

function mf_core.register_tool_form(name, form)
    _register_form(mf_core.tool_forms, name, form)
end

function mf_core.register_item(material_name, form_name)
    _register_item("item", material_name, form_name)
end

function mf_core.register_node(material_name, form_name)
    _register_item("node", material_name, form_name)
end

function mf_core.register_tool(material_name, form_name)
    _register_item("tool", material_name, form_name)
end

function mf_core.register_material_forms(material_name, modmap)
    for mod_name, form_names in pairs(modmap) do
        if not minetest.get_modpath(mod_name) then
            goto continue
        end

        if type(form_names) ~= "table" then
            form_names = { form_names }
        end

        for form_name, type in pairs(form_names) do
            mf_core["register_" .. type](material_name, form_name)
        end

        ::continue::
    end
end

function mf_core.register_material(name, material)
    assert(
        mf_core.materials[name] == nil,
        "material '" .. name .. "' already registered."
    )

    material.name = name
    material.mod = minetest.get_current_modname()
    material.overrides = material.overrides or {}
    material.attributes = {}

    mf_core.materials[name] = material
end
