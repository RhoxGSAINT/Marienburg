local dauphine_faction = "ovn_mar_cult_of_manann"  


rhox_dauphine_sea_monsters = {
	pirate_details = {
		{
			faction_key = "wh2_dlc11_cst_harpoon_the_sunken_land_corsairs",
			spawn_pos = {x = 1287, y = 44},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 0,
			level = 20,
			item_owned = "piece_of_eight",
			behaviour = "roving",	
			patrol_route = {"start", {x = 1324, y = 61}, {x = 1343, y = 21}, {x = 1239, y = 64}, {x = 1207, y = 47}}
		},
		
		{
			faction_key = "rhox_rogue_spirits_of_stromfel",
			general_subtype="chaos_whale_kou",
			spawn_pos = {x = 1538, y = 725},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 0,
			level = 20,
			item_owned = "piece_of_eight",
			behaviour = "monster",	
			patrol_route = {"start", {x = 1523, y = 654}, {x = 1464, y = 551}, {x = 1477, y = 666}, {x = 1534, y = 723}},
            mission_key = "rhox_mar_dauphine_pirate_hunting_5"
		}
	    
    },

	aggro_radius = 300,
	aggro_cooldown = 5,
	aggro_abort = 3,
}


function rhox_dauphine_sea_monsters:setup_sea_monsters()
	local human_factions = cm:get_human_factions()

	
	for i = 1, #rhox_dauphine_sea_monsters.pirate_details do
		local pirate = rhox_dauphine_sea_monsters.pirate_details[i]
		
		

		-- Spawn force and create patrol route invasion
        local rogue_force = nil
		if pirate.behaviour == "monster" then
            local invasion_key = pirate.faction_key.."_MONSTER"
			pirate.has_spawned = true

            
            cm:create_force_with_general(
                -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                pirate.faction_key,
                "ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_0,ovn_mar_mon_augas_fish_1,ovn_mar_mon_augas_fish_1,ovn_mar_mon_augas_fish_1",
                "cr_combi_region_khuresh_4_1",
                pirate.spawn_pos.x,
                pirate.spawn_pos.y,
                "general",
                pirate.general_subtype,
                "names_name_1480988115",
                "",
                "names_name_1473200750",
                "",
                false,
                function(cqi) 
                    local character = cm:get_character_by_cqi(cqi)
                    rogue_force = character:military_force()
                    local forename =  common:get_localised_string("land_units_onscreen_name_chaos_whale_cst_kou")
                    cm:change_character_custom_name(character, forename, "","","")
                end
            );
			cm:force_diplomacy("all", "faction:"..pirate.faction_key, "all", false, false, true)
			cm:force_diplomacy("all", "faction:"..pirate.faction_key, "payments", false, false, true)

			for j = 1, #human_factions do
				local faction_key = human_factions[j]
				cm:force_diplomacy("faction:"..faction_key, "faction:"..pirate.faction_key, "war", true, true, false)
				cm:force_diplomacy("faction:"..pirate.faction_key, "faction:"..faction_key, "war", false, false, false)
			end
            if not rogue_force then
                out("Rhox Dauphine: Error rogue force was not created!")
                return
            end
			 
			local roving_pirate = invasion_manager:new_invasion_from_existing_force(invasion_key, rogue_force)
			if not roving_pirate then
                out("Rhox Dauphine: Error Invasion was not created!")
                return
            end
			roving_pirate:set_target("PATROL", pirate.patrol_route)
			roving_pirate:add_aggro_radius(roving_pirates.aggro_radius, human_factions, roving_pirates.aggro_cooldown, roving_pirates.aggro_abort)
			
			if pirate.effect ~= nil and pirate.effect ~= "" then
				roving_pirate:apply_effect(pirate.effect, -1)
			end
			if pirate.xp ~= nil and pirate.xp > 0 then
				roving_pirate:add_unit_experience(pirate.xp)
			end
			if pirate.level ~= nil and pirate.level > 0 then
				roving_pirate:add_character_experience(pirate.level, true)
			end
			
			roving_pirate:should_maintain_army(true, 50)
			roving_pirate:start_invasion()
			if cm:get_faction("ovn_mar_cult_of_manann"):is_human() then
                -- Trigger Piece of Eight missions
                local faction_key = "ovn_mar_cult_of_manann"
                local mission_key = pirate.mission_key
                local mm = mission_manager:new(faction_key, mission_key)
                mm:set_mission_issuer("CLAN_ELDERS")
                
                mm:add_new_objective("ENGAGE_FORCE")
                mm:add_condition("cqi "..rogue_force:command_queue_index())
                mm:add_condition("requires_victory")
                mm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_dauphine_crown;}");
                mm:add_payload("effect_bundle{bundle_key "..mission_key..";turns 1;}")
                mm:trigger()
            end
        elseif pirate.behaviour == "roving" and cm:get_faction("ovn_mar_cult_of_manann"):is_human() then --this is vanilla key and we can't just use it anytime
                local invasion_key = pirate.faction_key.."_PIRATE"
                pirate.has_spawned = true
    
                cm:spawn_rogue_army(pirate.faction_key, pirate.spawn_pos.x, pirate.spawn_pos.y);
	
                local rogue_leader = cm:get_faction(pirate.faction_key):faction_leader();
                local rogue_force = rogue_leader:military_force();
                local roving_pirate = invasion_manager:new_invasion_from_existing_force(invasion_key, rogue_force);
                if not roving_pirate then
                    out("Rhox Dauphine: Error Invasion was not created!")
                    return
                end
                cm:force_diplomacy("all", "faction:"..pirate.faction_key, "all", false, false, true)
                cm:force_diplomacy("all", "faction:"..pirate.faction_key, "payments", false, false, true)
    
                for j = 1, #human_factions do
                    local faction_key = human_factions[j]
                    cm:force_diplomacy("faction:"..faction_key, "faction:"..pirate.faction_key, "war", true, true, false)
                    cm:force_diplomacy("faction:"..pirate.faction_key, "faction:"..faction_key, "war", false, false, false)
                end
                 
                
                roving_pirate:set_target("PATROL", pirate.patrol_route)
                roving_pirate:add_aggro_radius(roving_pirates.aggro_radius, human_factions, roving_pirates.aggro_cooldown, roving_pirates.aggro_abort)
                
                if pirate.effect ~= nil and pirate.effect ~= "" then
                    roving_pirate:apply_effect(pirate.effect, -1)
                end
                if pirate.xp ~= nil and pirate.xp > 0 then
                    roving_pirate:add_unit_experience(pirate.xp)
                end
                if pirate.level ~= nil and pirate.level > 0 then
                    roving_pirate:add_character_experience(pirate.level, true)
                end
                
                roving_pirate:should_maintain_army(true, 50)
                roving_pirate:start_invasion()
                cm:change_custom_faction_name("wh2_dlc11_cst_harpoon_the_sunken_land_corsairs", common:get_localised_string("rhox_dauphine_pirate_new_name"))
		end
		
		
	end
    
end


local whale_hunting_mission_string = "rhox_mar_whale_hunting_"
local whale_weakness_string = "rhox_mar_dauphine_whale_hunting_"



core:add_listener(
	"rhox_mar_dauphine_whale_missions",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key():starts_with(whale_hunting_mission_string)
	end,
	function(context)
        local mission_key=context:mission():mission_record_key()
        local id = string.gsub(mission_key, whale_hunting_mission_string, "")
        local whale = cm:get_faction("rhox_rogue_spirits_of_stromfel"):faction_leader()
        --out("Rhox mar: Mission id: "..id)
        
        if id == "5" then --teleport whale to you
            local dauphine = cm:get_faction(dauphine_faction):faction_leader()
            if dauphine:is_at_sea() and dauphine:has_military_force() and whale then
                local x, y = cm:find_valid_spawn_location_for_character_from_character("rhox_rogue_spirits_of_stromfel", cm:char_lookup_str(dauphine), true)
                cm:teleport_to(cm:char_lookup_str(whale), x, y)
            end
        elseif id == "4" then
            local mm = mission_manager:new(dauphine_faction, "rhox_mar_whale_hunting_5")
            mm:add_new_objective("DEFEAT_N_ARMIES_OF_FACTION");
            mm:add_condition("subculture wh2_main_rogue");
            mm:add_condition("total 3");
            mm:add_payload("text_display rhox_dauphine_whale_hunt_final");
            mm:add_payload("text_display rhox_dauphine_whale_weak_5");
            mm:add_payload("money 1000")
            mm:trigger()
        elseif id == "3" then    
            local mm = mission_manager:new(dauphine_faction, "rhox_mar_whale_hunting_4")
            mm:add_new_objective("MOVE_TO_REGION");
            mm:add_condition("region cr_combi_region_elithis_2_1");
            mm:add_payload("money 1000")
            mm:add_payload("text_display rhox_dauphine_whale_hunt");
            mm:add_payload("text_display rhox_dauphine_whale_weak_4");
            mm:trigger()
        elseif id == "2" then
            local mm = mission_manager:new(dauphine_faction, "rhox_mar_whale_hunting_3")
            mm:add_new_objective("MOVE_TO_REGION");
            mm:add_condition("region cr_combi_region_gates_of_calith_1");
            mm:add_payload("money 1000")
            mm:add_payload("text_display rhox_dauphine_whale_hunt");
            mm:add_payload("text_display rhox_dauphine_whale_weak_3");
            mm:trigger()
        elseif id == "1" then
            local mm = mission_manager:new(dauphine_faction, "rhox_mar_whale_hunting_2")
            mm:add_new_objective("MOVE_TO_REGION");
            mm:add_condition("region wh3_main_combi_region_altar_of_facades");
            mm:add_payload("money 1000")
            mm:add_payload("text_display rhox_dauphine_whale_hunt");
            mm:add_payload("text_display rhox_dauphine_whale_weak_2");
            mm:trigger()
        end
        
        if whale then
            cm:apply_effect_bundle_to_character(whale_weakness_string..id,whale,-1)
        end
	end,
	true
);




core:add_listener(
	"rhox_mar_dauphine_chaos_whale_hunted",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "rhox_mar_dauphine_pirate_hunting_5"
	end,
	function(context)
        cm:fail_custom_mission(dauphine_faction, whale_hunting_mission_string.."_1")
        cm:fail_custom_mission(dauphine_faction, whale_hunting_mission_string.."_2")
        cm:fail_custom_mission(dauphine_faction, whale_hunting_mission_string.."_3")
        cm:fail_custom_mission(dauphine_faction, whale_hunting_mission_string.."_4")
        cm:fail_custom_mission(dauphine_faction, whale_hunting_mission_string.."_5")--you don't need follow up missions since you completed it
	
	
        local cqi = cm:get_faction(dauphine_faction):faction_leader():cqi()
        local x, y = cm:find_valid_spawn_location_for_character_from_character(dauphine_faction, "character_cqi:"..cqi, true)
        cm:spawn_agent_at_position(cm:get_faction(dauphine_faction), x, y, "champion", "hkrul_arbatt") --you can't recruit him, so he is a unique one.
        local spawned_agent = cm:get_most_recently_created_character_of_type(cm:get_faction(dauphine_faction), "champion", "hkrul_arbatt")
        if spawned_agent then 
            cm:replenish_action_points(cm:char_lookup_str(spawned_agent:cqi())) --restore action point
            local forename =  common:get_localised_string("land_units_onscreen_name_hkrul_arbatt")
            cm:change_character_custom_name(spawned_agent, forename, "","","")
        end
	end,
	true
);
