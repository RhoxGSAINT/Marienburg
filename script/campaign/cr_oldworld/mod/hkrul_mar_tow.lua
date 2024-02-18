
local marienburg_faction_key = "wh_main_emp_marienburg"
--new and fancy Jaan
local jaan_details = {
    general_faction = marienburg_faction_key,
    unit_list = "snek_hkrul_mar_landship,hkrul_privateers,hkrul_mar_inf_goedendagers,hkrul_mar_inf_greatsword,hkrul_mar_inf_boogschutter,hkrul_carriers_ror,hkrul_mar_inf_goedendagers", -- unit keys from main_units table
    region_key = "",
    type = "general",																				-- Agent type
    subtype = "hkrul_jk",																	-- Agent subtype
    forename = "names_name_7470711888",															-- From local_en names table, Bernhoff the Butcher is now ruler of Reikland
    clanname = "",																					-- From local_en names table
    surname = "names_name_7470711866",																-- From local_en names table
    othername = "",																					-- From local_en names table
    is_faction_leader = true																		-- Bool for whether the general being replaced is the new faction leader
}


RHOX_MAR_MCT_SETTING={
    additional_landship=0,
    block_rebellion = false,
    kill_blue_pirate = false,
    disable_rite=false,
}

local function rhox_mar_kill_blue()
    for i=1,#roving_pirates.pirate_details do
        local faction_key = roving_pirates.pirate_details[i].faction_key
        --out("Rhox Mar: Pirate key ".. faction_key)
        local faction = cm:get_faction(faction_key)
        if faction and faction:is_dead() == false then
            --out("Rhox Mar: Killing them")
            cm:kill_all_armies_for_faction(faction)
        end
    end
end

local function setup_mct(context)
    -- get the mct object
    local mct = context:mct()
    local my_mod = mct:get_mod_by_key("hkrul_mar")
    
    local additional_landship = my_mod:get_option_by_key("rhox_mar_additional_landship")
    RHOX_MAR_MCT_SETTING.additional_landship = additional_landship:get_finalized_setting()
    
    local block_rebellion = my_mod:get_option_by_key("rhox_mar_rebellion")
    RHOX_MAR_MCT_SETTING.block_rebellion = block_rebellion:get_finalized_setting()
    
    local kill_blue_pirate = my_mod:get_option_by_key("rhox_mar_blue_pirate")
    RHOX_MAR_MCT_SETTING.kill_blue_pirate = kill_blue_pirate:get_finalized_setting()
    
    local disable_rite = my_mod:get_option_by_key("rhox_mar_jaan_rite")
    RHOX_MAR_MCT_SETTING.disable_rite = disable_rite:get_finalized_setting()
    
end

core:add_listener(
    "rhox_mar_mct_initialize",
    "MctInitialized",
    true,
    function(context)
        setup_mct(context)
    end,
    true
)


core:add_listener(
    "rhox_mar_mct_setting_change",
    "MctOptionSettingFinalized",
    true,
    function(context)
        setup_mct(context)
        if RHOX_MAR_MCT_SETTING.kill_blue_pirate then
            rhox_mar_kill_blue()
        end
    end,
    true
)


-- make sure Jaan doesn't have the "wh3_main_bundle_character_restrict_experience_gain" EB
core:add_listener(
    "hkrul_CharacterTurnStart",
    "CharacterTurnStart",
    function(context)
        return context:character():character_subtype(jaan_details.subtype)
    end,
    function(context)    
        local character = context:character()
        cm:callback(
            function()
                if character:has_effect_bundle("wh3_main_bundle_character_restrict_experience_gain") then
                    cm:remove_effect_bundle_from_character("wh3_main_bundle_character_restrict_experience_gain", character)
                end
            end,
            0.1
        )
    end,
    true
)

local function cr_change_marienburg_campaign_display()
    --change the campaign settlement model used
	cm:override_building_chain_display("wh_main_EMPIRE_settlement_major", "cr_mar_special_settlement_marienburg", "cr_oldworld_region_marienburg")
end




local marienburg_ancillary_list={--cause I don't want to make caravan and mission in non-IE
    "hkrul_mar_testament",
    "hkrul_mar_loyal",
    "hkrul_mar_follower_sun",
    "hkrul_mar_follower_norsca",
    "hkrul_mar_item_arnheim",
    "hkrul_mar_baron",
    "hkrul_mar_follower_roelef",
    "hkrul_mar_item_vargheist",
    "hkrul_mar_lupo",
    "hkrul_mar_follower_bret",
    "hkrul_mar_follower_bard",
    "hkrul_mar_item_trident_manann",
    "hkrul_mar_thom",
    "hkrul_mar_item_fence", 
    "hkrul_mar_follower_elf",
    "hkrul_mar_rat",
    "hkrul_mar_item_shield_manann",
    "hkrul_mar_follower_ship",
    "hkrul_mar_bonsai",
    "hkrul_mar_follower_cathay",
    "hkrul_mar_marienburg_anc",
    "hkrul_mar_nijmenk",
    "hkrul_mar_frost_globe",
    "hkrul_mar_roelef",
    "hkrul_mar_hakim",
    "hkrul_mar_fooger",
    "hkrul_mar_rothemuur",
    "hkrul_mar_scheldt",
    "hkrul_mar_leo",
    "hkrul_mar_thijs",
}


-- Replaces the starting general for a specific faction
local function hkrul_mar()
    local marienburg_faction =  cm:get_faction(marienburg_faction_key)
	if cm:is_new_game() then
        --cr_change_marienburg_campaign_display() --overlaps with elftown
        cm:callback(
			function() 
                if marienburg_faction:is_null_interface() == false and marienburg_faction:is_dead() == false then

                    local general_x_pos, general_y_pos = cm:find_valid_spawn_location_for_character_from_settlement(jaan_details.general_faction, marienburg_faction:home_region():name(), false, true, 5)

                    general_x_pos = 639
                    general_y_pos  = 895

                    
                    -- Creating replacement Emil with new fancy Jaan
                    cm:create_force_with_general(
                        jaan_details.general_faction,
                        jaan_details.unit_list,
                        marienburg_faction:home_region():name(),
                        general_x_pos,
                        general_y_pos,
                        jaan_details.type,
                        jaan_details.subtype,
                        jaan_details.forename,
                        jaan_details.clanname,
                        jaan_details.surname,
                        jaan_details.othername,
                        jaan_details.is_faction_leader,
                        function(cqi)
                            local char_str = cm:char_lookup_str(cqi)
                            cm:set_character_unique(char_str, true) --makes Jaan a undisbandable "Legendary Lord"
                            --cm:set_character_immortality(char_str, true) --not needed since immortality is enabled in db
                            if RHOX_MAR_MCT_SETTING.additional_landship ~= 0 then
                                for i=0,RHOX_MAR_MCT_SETTING.additional_landship do
                                    cm:grant_unit_to_character(char_str, "snek_hkrul_mar_landship")
                                end
                            end
                            if marienburg_faction:is_human() ==false then
                                cm:add_agent_experience(char_str, 3, true) --add level. Below's level restriction is 3
                                cm:add_skill(cm:get_character_by_cqi(cqi), "hkrul_jaan_special_4_0", true, true)--AI can't take care of the upkeep and adding skill here for them
                            end
                        end
                    )
                    
                    local unique_agent=nil
                    --creating hkrul pg here so he could spawn near the new lord
                    local marienburg_faction_cqi = marienburg_faction:command_queue_index();  
                    cm:spawn_unique_agent(marienburg_faction_cqi,"hkrul_harb",true);
                    local hkrul_harb = cm:get_most_recently_created_character_of_type("wh_main_emp_marienburg", "champion", "hkrul_harb")
                    cm:replenish_action_points(cm:char_lookup_str(hkrul_harb:cqi())) 
                    cm:teleport_to(cm:char_lookup_str(hkrul_harb:cqi()), 468, 655) --because now the faction leader has moved
                    cm:spawn_unique_agent(marienburg_faction_cqi,"hkrul_harb",true);
                    cm:spawn_unique_agent(marienburg_faction_cqi,"hkrul_pg",true);
                    cm:spawn_unique_agent(marienburg_faction_cqi,"hkrul_solkan",true);
                    unique_agent = cm:get_most_recently_created_character_of_type(marienburg_faction_key, "champion", "hkrul_solkan")
                    if unique_agent then 
                        cm:change_character_custom_name(unique_agent, common:get_localised_string("names_name_605123635"), common:get_localised_string("names_name_605123636"), "", "")
                        cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                    end
                    cm:spawn_unique_agent(marienburg_faction_cqi,"hkrul_crispijn",true);
                    cm:spawn_unique_agent(marienburg_faction_cqi,"hkrul_guzunda",true);
                    cm:spawn_unique_agent(marienburg_faction_cqi,"hkrul_lisette",true);
                    unique_agent = cm:get_most_recently_created_character_of_type(marienburg_faction_key, "spy", "hkrul_lisette")
                    if unique_agent then 
                        cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_lisette"), "", "", "")
                        cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                    end
                    cm:spawn_unique_agent(marienburg_faction_cqi,"hkrul_cross",true);
                    unique_agent = cm:get_most_recently_created_character_of_type(marienburg_faction_key, "champion", "hkrul_cross")
                    if unique_agent then 
                        cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_cross"), "", "", "")
                        cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                    end
                    cm:spawn_character_to_pool(marienburg_faction_key, "names_name_605123686", "names_name_605123685", "", "", 50, true, "general", "hkrul_hendrik",true, "");
                    

                    for i=1,#marienburg_ancillary_list do
                        cm:add_ancillary_to_faction(marienburg_faction, marienburg_ancillary_list[i],true)    
                    end
                    

                    -- Killing old (generic) Emil permanently
                    local char_list = marienburg_faction:character_list()
                    local char_subtype = "wh_main_emp_lord" -- old (generic) Emil's agent subtype
                    local char_forename = "names_name_2147344088" -- old (generic) Emil's forename

                    for i = 0, char_list:num_items() - 1 do
                        local current_char = char_list:item_at(i)
                        local char_str = cm:char_lookup_str(current_char)

                        if current_char:is_null_interface() == false and current_char:character_subtype_key() == char_subtype and current_char:get_forename() == char_forename and current_char:has_military_force() == true then
                            cm:set_character_immortality(char_str, false)
                            cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                            cm:kill_character(current_char:command_queue_index(), true, true)
                            cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 0.5)
                            out("Killing original " .. char_subtype .. " with forename " .. char_forename .. " for " .. marienburg_faction_key .. " permanently")
                        end
                    end
                    
                    
                    if RHOX_MAR_MCT_SETTING.kill_blue_pirate then
                        rhox_mar_kill_blue()
                    end
                end
            end, 0.1 --delay to make sure this runs after wh2_campaign_custom_starts.lua
        )
	end
end




cm:add_first_tick_callback(
    function() 
        if cm:is_new_game() and cm:is_multiplayer() then
            mixer_disable_starting_zoom = true
        end
        pcall(function()
            mixer_set_faction_trait("wh_main_emp_marienburg", "hkrul_mar", true)
        end)
        hkrul_mar() 
        mixer_disable_lord_recruitment("wh_main_emp_marienburg", "wh_dlc04_emp_arch_lector", "emp_arch_lector" ,"wh_main_emp_lord")
    end
)