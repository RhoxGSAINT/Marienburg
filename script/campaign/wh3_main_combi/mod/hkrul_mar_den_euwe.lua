local deneuwe_faction_key = "ovn_mar_house_den_euwe"
--new and fancy Jaan
local egmond_details = {
    general_faction = deneuwe_faction_key,
    unit_list = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears,wh3_dlc20_chs_inf_chaos_marauders_mtze_spears,hkrul_privateers_dual_swords,hkrul_mar_inf_crossbow,hkrul_mar_inf_crossbow,snek_hkrul_mar_landship,wh3_dlc20_chs_inf_chaos_warriors_mtze,wh3_dlc20_chs_inf_chaos_warriors_mtze", -- unit keys from main_units table
    region_key = "",
    type = "general",																				-- Agent type
    subtype = "hkrul_mar_egmond",																	-- Agent subtype
    forename = "names_name_605123616",															-- From local_en names table, Bernhoff the Butcher is now ruler of Reikland
    clanname = "",																					-- From local_en names table
    surname = "names_name_605123615",																-- From local_en names table
    othername = "",																					-- From local_en names table
    is_faction_leader = true																		-- Bool for whether the general being replaced is the new faction leader
}

core:add_listener(
    "hkrul_egmond_CharacterTurnStart",
    "CharacterTurnStart",
    function(context)
        return context:character():character_subtype(egmond_details.subtype)
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

-- Replaces the starting general for a specific faction
local function hkrul_den_euwe()
    cm:callback(
        function() 
            local deneuwe_faction = cm:get_faction(deneuwe_faction_key)
            if deneuwe_faction:is_null_interface() == false and deneuwe_faction:is_dead() == false then

                local x, y = 1360, 499
                --x, y  = cm:find_valid_spawn_location_for_character_from_settlement(deneuwe_faction_key, "wh3_main_combi_region_fu_chow", false, true, 8)

                -- Shaping starting setup
                local fu_chow_region = cm:get_region("wh3_main_combi_region_fu_chow")
                cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
                cm:transfer_region_to_faction("wh3_main_combi_region_fu_chow", deneuwe_faction_key)
                cm:force_declare_war(deneuwe_faction_key, "wh3_dlc21_cst_dead_flag_fleet", false, false) --declare war
                local fu_chow_cqi = fu_chow_region:cqi()
                cm:heal_garrison(fu_chow_cqi)
                local previous_leader_cqi = deneuwe_faction:faction_leader():cqi()
                -- replace previous leader with new one
                cm:create_force_with_general(
                    egmond_details.general_faction,
                    egmond_details.unit_list,
                    deneuwe_faction:home_region():name(),
                    x,
                    y,
                    egmond_details.type,
                    egmond_details.subtype,
                    egmond_details.forename,
                    egmond_details.clanname,
                    egmond_details.surname,
                    egmond_details.othername,
                    egmond_details.is_faction_leader,
                    function(cqi)
                        local char_str = cm:char_lookup_str(cqi)
                        cm:set_character_unique(char_str, true)

                        --kill previous leader and dummy force leader
                        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                        local previous_leader_str = cm:char_lookup_str(previous_leader_cqi)
                        cm:set_character_immortality(previous_leader_str, false)
                        cm:kill_character(previous_leader_str, true)
                        
                        local x, y = cm:find_valid_spawn_location_for_character_from_character(deneuwe_faction_key, "character_cqi:"..cqi, true)
                        cm:spawn_agent_at_position(cm:get_faction(deneuwe_faction_key), x, y, "champion", "wh_main_emp_captain") --additional captain. He will have a hard time fighting major settlement and Lokhir
                        
                        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 0.5)
                    end
                )
                
                
                --the first enemy you should fight
                cm:create_force_with_general(
                    "wh3_dlc21_cst_dead_flag_fleet",
                    "wh2_dlc11_cst_inf_zombie_deckhands_mob_0,wh2_dlc11_cst_inf_zombie_deckhands_mob_0,wh2_dlc11_cst_inf_zombie_gunnery_mob_0,wh2_dlc11_cst_inf_zombie_gunnery_mob_0,wh2_dlc11_cst_inf_zombie_gunnery_mob_1,wh2_dlc11_cst_inf_zombie_gunnery_mob_1",
                    deneuwe_faction:home_region():name(),
                    1365,
                    494,
                    "general",
                    "wh2_dlc11_cst_admiral_death",
                    "",
                    "",
                    "",
                    "",
                    false,
                    function(cqi)
                        cm:set_force_has_retreated_this_turn(cm:get_character_by_cqi(cqi):military_force())
                    end
                )
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
            end
        end, 0.1 --delay to make sure this runs after wh2_campaign_custom_starts.lua
    )
end



cm:add_first_tick_callback_new(
	function()
        hkrul_den_euwe() --for initial setting
        if cm:get_local_faction_name(true) == "ovn_mar_house_den_euwe" then
            cm:apply_effect_bundle("rhox_egmond_hidden_effect_bundle", "ovn_mar_house_den_euwe", 0)--for Tzeentch diplomatic manipulation feature
            
            
            local faction_name = cm:get_local_faction_name(true)
            local title = "event_feed_strings_text_wh2_scripted_event_how_they_play_title";
            local primary_detail = "factions_screen_name_" .. faction_name;
            local secondary_detail = "";
            local pic = nil;
            secondary_detail = "event_feed_strings_text_rhox_mar_event_feed_string_scripted_event_intro_egmond_secondary_detail";
            pic = 591;
            cm:show_message_event(
                faction_name,
                title,
                primary_detail,
                secondary_detail,
                true,
                pic
            );
            
            
            local mm = mission_manager:new("ovn_mar_house_den_euwe", "rhox_mar_conquer_beichai")
            mm:add_new_objective("CAPTURE_REGIONS");
            mm:add_condition("region wh3_main_combi_region_beichai");
            mm:add_payload("money 2500");
            mm:trigger() 
        end
          
        --cm:force_alliance("ovn_mar_house_den_euwe", "wh_main_emp_marienburg", true) --temp for watching, remove this befroe the release
	end
);



cm:add_first_tick_callback(
	function()
        pcall(function()
            mixer_set_faction_trait("ovn_mar_house_den_euwe", "hkrul_deneuwe", true)
        end)
        if cm:get_local_faction_name(true) == deneuwe_faction_key then
            --out("Rhox Egmond: In the first tick callback")
            
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_egmond_grimoire_holder", "ui/campaign ui/rhox_egmond_grimoire_holder.twui.xml", parent_ui)
            if not result then
                script_error("Rhox Egmond: ".. "ERROR: could not create Grimoire component? How can this be?");
                return false;
            end;
            result:SetVisible(true)

            if cm:model():turn_number() < 13 then
                core:add_listener(
                    "rhox_mar_egmond_RoundStart",
                    "FactionRoundStart",
                    function(context)
                        return context:faction():name() == "ovn_mar_house_den_euwe"
                    end,
                    function(context)
                        if cm:model():turn_number() == 2 then
                            cm:trigger_incident("ovn_mar_house_den_euwe", "rhox_mar_egmond_turn2")
                        end
                        if cm:model():turn_number() == 13 then 
                            cm:trigger_dilemma("ovn_mar_house_den_euwe", "rhox_mar_egmond_choose_side")
                        end
                    end,
                    true
                )
                core:add_listener(
                    "rhox_egmond_vilitch_DilemmaChoiceMadeEvent",
                    "DilemmaChoiceMadeEvent",
                    function(context)
                        return context:dilemma() == "rhox_mar_egmond_choose_side"
                    end,
                    function(context)
                        local choice = context:choice();
                        
                        
                        if choice == 0 then --tzeentch side --don't do the things if factions are dead
                            if not cm:get_faction("wh3_dlc20_chs_vilitch"):is_dead() then
                                cm:force_alliance("wh3_dlc20_chs_vilitch", "ovn_mar_house_den_euwe", true)
                                --cm:force_alliance("ovn_mar_house_den_euwe", "wh3_dlc20_chs_vilitch", true)
                            end
                            if not cm:get_faction("wh_main_emp_marienburg"):is_dead() then
                                cm:force_declare_war("wh_main_emp_marienburg", "ovn_mar_house_den_euwe", true, true)
                            end
                            --summon cultist
                            local cqi = cm:get_faction(deneuwe_faction_key):faction_leader():cqi()
                            local x, y = cm:find_valid_spawn_location_for_character_from_character(deneuwe_faction_key, "character_cqi:"..cqi, true)
                            cm:spawn_agent_at_position(cm:get_faction(deneuwe_faction_key), x, y, "dignitary", "wh3_main_tze_cultist") --you can't recruit him, so he is a unique one.
                            local spawned_agent = cm:get_most_recently_created_character_of_type(cm:get_faction(deneuwe_faction_key), "dignitary", "wh3_main_tze_cultist")
                            if spawned_agent then 
                                cm:replenish_action_points(cm:char_lookup_str(spawned_agent:cqi())) --restore action point
                            end
                            
                        else --marienburg side  --don't do the things if factions are dead
                            if not cm:get_faction("wh3_dlc20_chs_vilitch"):is_dead() then
                                cm:force_declare_war("wh3_dlc20_chs_vilitch", "ovn_mar_house_den_euwe", true, true)
                            end
                            if not cm:get_faction("wh_main_emp_marienburg"):is_dead() then
                                cm:force_alliance("wh_main_emp_marienburg", "ovn_mar_house_den_euwe", true)
                                --cm:force_alliance("ovn_mar_house_den_euwe", "wh_main_emp_marienburg", true)
                            end
                        end
                    end,
                    false --no need to do twice
                );
            end
        end
	end
);