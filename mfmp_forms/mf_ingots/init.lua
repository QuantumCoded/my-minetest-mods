---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local mf_ingots = {}

_G[modname] = mf_ingots

function mf_ingots.register_ingot(material_name)
    mf_core.register_item(material_name, "ingot")
end

mf_core.register_item_form("ingot", {
    from_material = function(material)
        local description =
            mf_core.material_display_name(material)
            .. " Ingot"

        return material.mod .. ":" .. material.name .. "_ingot", {
            short_description = description,
            description = description,

            inventory_image = mf_core.material_texture(
                material,
                "mf_ingots_ingot.png"
            ),
        }
    end,
})
