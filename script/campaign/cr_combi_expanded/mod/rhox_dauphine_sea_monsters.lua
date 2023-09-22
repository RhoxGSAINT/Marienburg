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
			patrol_route = {"start", {x = 1238, y = 29}, {x = 1224, y = 96}, {x = 1342, y = 24}, {x = 1351, y = 81}}
		},
		
		{
			faction_key = "rhox_rogue_spirits_of_stromfel",
			spawn_pos = {x = 1538, y = 725},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 0,
			level = 20,
			item_owned = "piece_of_eight",
			behaviour = "monster",	
			patrol_route = {"start", {x = 1538, y = 725}, {x = 1519, y = 644}, {x = 1499, y = 583}, {x = 1482, y = 666}},
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
                "",
                "cr_combi_region_khuresh_4_1",
                pirate.spawn_pos.x,
                pirate.spawn_pos.y,
                "general",
                "wh2_main_def_dreadlord",
                "names_name_1480988115",
                "",
                "names_name_1473200750",
                "",
                false,
                function(cqi) 
                    local character = cm:get_character_by_cqi(cqi)
                    rogue_force = character:military_force()
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
                
                mm:add_payload("effect_bundle{bundle_key "..mission_key..";turns 0;}")
                mm:trigger()
            end
        elseif pirate.behaviour == "roving" then
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
		end
		
		
	end
    cm:change_custom_faction_name("wh2_dlc11_cst_harpoon_the_sunken_land_corsairs", common:get_localised_string("rhox_dauphine_pirate_new_name"))--TODO temp
end



core:add_listener(
	"rhox_mar_dauphine_chaos_whale_hunted",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "rhox_mar_dauphine_pirate_hunting_5"
	end,
	function(context)
        local cqi = cm:get_faction(dauphine_faction):faction_leader():cqi()
        local x, y = cm:find_valid_spawn_location_for_character_from_character(dauphine_faction, "character_cqi:"..cqi, true)
        cm:spawn_agent_at_position(cm:get_faction(dauphine_faction), x, y, "champion", "wh_main_emp_captain") --you can't recruit him, so he is a unique one.
        local spawned_agent = cm:get_most_recently_created_character_of_type(cm:get_faction(dauphine_faction), "champion", "wh_main_emp_captain")
        if spawned_agent then 
            cm:replenish_action_points(cm:char_lookup_str(spawned_agent:cqi())) --restore action point
        end
	end,
	true
);
