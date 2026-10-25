local roelef_faction = "mixer_emp_house_de_roelef"

-- Resource types whose buildings grant a per-type cargo value bundle
local rhox_roelef_cargo_resources = {
    "animals", "dyes", "gems", "gold", "ivory", "medicine", "obsidian", "spices",
    "furs", "iron", "salt", "marble", "pastures", "pottery", "timber", "wine"
}

local function rhox_roelef_update_resource_cargo(faction)
    for _, resource in ipairs(rhox_roelef_cargo_resources) do
        local bundle_key = "rhox_mar_roelef_cargo_" .. resource
        local has_resource = cm:get_factions_bonus_value(faction, "rhox_mar_roelef_supply_" .. resource) > 0
        if has_resource and not faction:has_effect_bundle(bundle_key) then
            cm:apply_effect_bundle(bundle_key, roelef_faction, 0)
        elseif not has_resource and faction:has_effect_bundle(bundle_key) then
            cm:remove_effect_bundle(bundle_key, roelef_faction)
        end
    end
end


cm:add_first_tick_callback(
    function()
        core:add_listener(
            "rhox_roelef_resource_cargo",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == roelef_faction
            end,
            function(context)
                rhox_roelef_update_resource_cargo(context:faction())
            end,
            true
        )
    end
)
