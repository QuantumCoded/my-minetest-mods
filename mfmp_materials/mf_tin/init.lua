---@diagnostic disable:undefined-global

mf_core.register_material("tin", {
    colorize_modifier = "^[brighten",
})

mf_core.register_material_forms("tin", {
    mf_blocks = { block = "node" },
    mf_ingots = { ingot = "item" },
    mf_ores = { ore = "node" },
})
