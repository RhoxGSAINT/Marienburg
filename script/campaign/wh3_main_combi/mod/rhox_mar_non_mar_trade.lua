--root > hud_campaign > faction_buttons_docker > button_group_management > button_caravan

rhox_mar_non_mar_trade_factions ={ --global so others can access to it
    ["wh_main_emp_empire"] = true,
    ["wh2_dlc13_emp_golden_order"] = true,
    ["wh2_dlc13_emp_the_huntmarshals_expedition"] = true,
    ["wh3_main_emp_cult_of_sigmar"] = true,
    ["wh_main_emp_wissenland"]=true,
}

if vfs.exists("script/campaign/mod/twill_old_world_caravans.lua") then
    rhox_mar_non_mar_trade_factions ={
    }
end

local function rhox_remove_caravan_button()
    local caravan_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_caravan");
    if not caravan_button then
        return--return rather than breaking
    end
    if cm:get_saved_value("rhox_mar_unlocked_guilded_" .. cm:get_local_faction_name(true)) ~=true then
        cm:callback(function()
            caravan_button:SetVisible(false)
            end,
        5)
    else
        cm:callback(function()
            caravan_button:SetVisible(true)
            end,
        5)
    end
end

cm:add_first_tick_callback(
    function()
        if rhox_mar_non_mar_trade_factions[cm:get_local_faction_name(true)] then --ui thing, need to check local
            rhox_remove_caravan_button()
            core:add_listener(
                "rhox_mar_round_start_caravan_check",
                "FactionRoundStart",
                function(context)
                    return rhox_mar_non_mar_trade_factions[context:faction():name()] and context:faction():is_human()
                end,
                function(context)
                    rhox_remove_caravan_button()
                end,
                true
            )
        end
    end
);


core:add_listener(
    "rhox_mar_region_faction_changed",
    "RegionFactionChangeEvent",
    function(context)
        local region = context:region();
        local owner = region:owning_faction():name();
        return region:name() == "wh3_main_combi_region_marienburg" and rhox_mar_non_mar_trade_factions[owner] and cm:get_saved_value("rhox_mar_unlocked_guilded_" .. owner) ~=true
    end,
    function(context)
        local region = context:region();
        local faction = region:owning_faction();
        local owner = region:owning_faction():name();
        cm:set_saved_value("rhox_mar_unlocked_guilded_" .. owner, true)
        if faction:is_human() then
            cm:trigger_incident(owner, "rhox_mar_gained_access_to_the_guilded")
            cm:callback(function()
                rhox_remove_caravan_button()
                end,
            5)
        end
    end,
    true
)

core:add_listener(
    "rhox_mar_guilded_faction_roundstart_check",
    "FactionRoundStart",
    function(context)
        local region = cm:get_region("wh3_main_combi_region_marienburg")
        local owner = region:owning_faction():name();
        local current_faction_name = context:faction():name()
        return current_faction_name == owner and rhox_mar_non_mar_trade_factions[owner] and cm:get_saved_value("rhox_mar_unlocked_guilded_" .. owner) ~=true
    end,
    function(context)
        local region = cm:get_region("wh3_main_combi_region_marienburg")
        local owner = region:owning_faction():name();
        cm:set_saved_value("rhox_mar_unlocked_guilded_" .. owner, true)
        if faction:is_human() then
            cm:trigger_incident(owner, "rhox_mar_gained_access_to_the_guilded")
            rhox_remove_caravan_button()
        end
    end,
    true
)