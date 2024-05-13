---@diagnostic disable:undefined-global

local M = minetest.get_modpath

local material = {
    color = "#FFF",
    override_material = { ore = { color = "#E3C0AA" }, },
    override_definition = { ore = { groups = { pickaxey = 3 } } },
}

if M("mcl_core") then
    material.override_definition.ore = mf_core.override(
        material.override_definition.ore,
        {
            sounds = mcl_sounds.node_sound_stone_defaults(),
            _mcl_blast_resistance = 3,
            _mcl_hardness = 3,
            _mcl_fortune_drop = mcl_core.fortune_drop_ore,
        }
    )
end

mf_core.register_material("iron", material)

mf_core.register_material_forms("iron", {
    mf_blocks = { block = "node" },
    mf_ingots = { ingot = "item" },
    mf_ores = { ore = "node" },
})
