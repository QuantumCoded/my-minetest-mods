---@diagnostic disable:undefined-global

local modname = minetest.get_current_modname()
local mf_ores = {}

_G[modname] = mf_ores

function mf_ores.register_ore(material_name)
    mf_core.register_node(material_name, "ore")
end

mf_core.register_node_form("ore", {
    from_material = function(material)
        local description =
            mf_core.material_display_name(material)
            .. " Ore"

        -- minetest.register_node(
        --     material.mod .. ":stone_with_" .. material.name,
        --     mf_core.override_definition(
        --         material,
        --         "ore",
        --         {
        --             short_description = description,
        --             description = description,
        --
        --             tiles = {
        --                 mf_core.material_overlay(
        --                     material,
        --                     "default_stone.png",
        --                     "mf_ores_ore.png"
        --                 )
        --             },
        --         }
        --     )
        -- )

        return material.mod .. ":stone_with_" .. material.name, {
            short_description = description,
            description = description,

            tiles = {
                mf_core.material_overlay(
                    material,
                    "default_stone.png",
                    "mf_ores_ore.png"
                )
            },
        }
    end,
})

