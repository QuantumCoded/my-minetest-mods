---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local mf_ores = {}

_G[modname] = mf_ores

function mf_ores.register_ore(material_name)
    mf_core.register_node(material_name, "block")
end

mf_core.register_node_form("block", {
    from_material = function(material)
        local description =
            mf_core.material_display_name(material)
            .. " Block"

        return material.mod .. ":" .. material.name .. "_block", {
            short_description = description,
            description = description,

            tiles = {
                mf_core.material_texture(
                    material,
                    "mf_blocks_block.png"
                )
            },
        }
    end,
})
