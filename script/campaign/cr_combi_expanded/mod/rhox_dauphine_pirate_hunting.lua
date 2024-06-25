local dauphine_faction = "ovn_mar_cult_of_manann"  



--rhox_dauphine_hunt_1

local pirate_lairs={
    cr_combi_region_isles_of_the_monkey_king = "rhox_mar_dauphine_pirate_hunting_1",--Ulliogtha Outpost
    cr_combi_region_melay= "rhox_mar_dauphine_pirate_hunting_2",-- Melay
    cr_combi_region_khuresh_3_1="rhox_mar_dauphine_pirate_hunting_3",--Honai
    cr_combi_region_nippon_1_1="rhox_mar_dauphine_pirate_hunting_4",    --Mizushima
}

local function rhox_mar_dauphine_trigger_mission()
    for region, mission_key in pairs(pirate_lairs) do
        local mm = mission_manager:new(dauphine_faction, mission_key)
        mm:add_new_objective("CAPTURE_REGIONS");
        mm:add_condition("region "..region);
        mm:add_condition("ignore_allies");
        mm:add_payload("effect_bundle{bundle_key ".. mission_key  ..";turns 0;}")
        mm:trigger()
    end
    local mm = mission_manager:new(dauphine_faction, "rhox_mar_whale_hunting_1")
    mm:add_new_objective("KILL_X_ENTITIES")
    mm:add_condition("total 1000")
    mm:add_payload("money 1000")
    mm:add_payload("text_display rhox_dauphine_whale_hunt");
    mm:add_payload("text_display rhox_dauphine_whale_weak_1");
    mm:trigger()
end






local rhox_dauphine_reinforcements_units={
    --"rhox_dauphine_hkrul_mar_defenders",
    "rhox_dauphine_hkrul_mar_black_caps",
    "rhox_dauphine_hkrul_mar_cleansing_flame",
    "rhox_dauphine_hkrul_mar_art_scheepskanon",
    "rhox_dauphine_hkrul_mar_inf_greatsword",
    "rhox_dauphine_hkrul_mar_inf_handgun",
    "rhox_dauphine_hkrul_mar_riverwarden",
    "rhox_dauphine_hkrul_privateers_dual_swords",
    "rhox_dauphine_hkrul_privateers"
}


cm:add_first_tick_callback_new(
    function()  
        local faction = cm:get_faction(dauphine_faction)
        for i=1,#rhox_dauphine_reinforcements_units do
            local unit = rhox_dauphine_reinforcements_units[i]
            cm:add_unit_to_faction_mercenary_pool(faction,unit,"rhox_dauphine_reinforcements",0,100,20,0,"","","",true,unit)
        end
        if cm:get_faction(dauphine_faction):is_human() then
            rhox_mar_dauphine_trigger_mission()
        end
        rhox_dauphine_sea_monsters:setup_sea_monsters() --just summon them regardless of Dauphine is human or not
        
        
    end
)



local base_chance =3

core:add_listener(
    "rhox_dauphine_turn_start",
    "FactionTurnStart",
    function(context)
        if context:faction():name() ~= dauphine_faction then
            return false
        end
        
        local faction = context:faction()
        
        local chance = base_chance
        
        if faction:bonus_values():scripted_value("rhox_dauphine_incident_chance", "value") > 0 then
            chance= chance+faction:bonus_values():scripted_value("rhox_dauphine_incident_chance", "value")
        end
        
        out("Rhox Dauphine: Chance is ".. chance)
        if cm:model():turn_number() == 1 then --don't trigger it on the first turn
            return false
        end
        
        return cm:model():random_percent(chance)
    end,
    function(context)
        out("Rhox Dauphine: Giving units to: ".. context:faction():name())
        local faction = context:faction()
        if faction:is_human() then --trigger dilemma
            
            local incident_builder = cm:create_incident_builder("rhox_dauphine_reinforcements")
            --incident_builder:add_target("default", faction)
            
            local payload_builder = cm:create_payload()
            for i=1,4 do
                local unit_key = rhox_dauphine_reinforcements_units[cm:random_number(#rhox_dauphine_reinforcements_units)]
                payload_builder:add_mercenary_to_faction_pool(unit_key, 1)  
            end
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        else --just give units
            for i=1,4 do
                local unit_key = rhox_dauphine_reinforcements_units[cm:random_number(#rhox_dauphine_reinforcements_units)]
                cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(),unit_key, 1)
            end
        end
    end,
    true
)








cm:add_first_tick_callback(
	function()
        if cm:get_local_faction_name(true) == dauphine_faction then  --ui thing and should be local
            local pieces_of_eight_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts");
            pieces_of_eight_button:SetVisible(true)
            pieces_of_eight_button:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_dauphine_panel_open_button"),true)
            local treasure_hunt_count_ui = find_uicomponent(pieces_of_eight_button, "label_hunts_count");
            treasure_hunt_count_ui:SetVisible(false)
            
            
            core:add_listener(
                "rhox_dauphine_treasure_panel_open_listener",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "treasure_hunts";
                end,
                function()
                    local pieces_tab = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "pieces");
                    pieces_tab:SimulateLClick();
                    
                    local pieces_text = find_uicomponent(pieces_tab, "tx");
                    pieces_text:SetText(common.get_localised_string("campaign_localised_strings_string_rhox_dauphine_piece_tab"))
                    
                    
                    
                    
                    local treasure_tab = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "hunts");
                    treasure_tab:SetVisible(false) --we're not using this button and should disable it. 
                end,
                true
            )
        end
	end
);