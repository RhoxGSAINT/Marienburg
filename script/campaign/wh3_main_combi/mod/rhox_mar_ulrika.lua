cm:add_first_tick_callback(
	function()
        
		if cm:get_faction("wh_main_emp_marienburg"):is_human() then
            if cm:is_new_game() then 
                out("Rhox mar: Locking Vanilla Ulrika mission")
                character_unlocking.character_data["ulrika"].factions_involved["wh_main_emp_marienburg"] = true --this will make vanilla script not trigger Ulrika mission chain
            end
            cm:add_faction_turn_start_listener_by_name(
                "rhox_mar_ulrika_trigger_listner",
                "wh_main_emp_marienburg",
                function(context)
                    local faction = context:faction()
                    local faction_name = faction:name()

                    if cm:get_saved_value("rhox_mar_ulrika_triggered") ~=true and faction:faction_leader():rank() >= 11 then
                        out("Rhox Mar: triggering mission!")
                        cm:set_saved_value("rhox_mar_ulrika_triggered", true)
                        
                        local mm = mission_manager:new(faction_name, "wh3_dlc23_ie_emp_ulrika_stage_1")
                        mm:add_new_objective("CONSTRUCT_N_BUILDINGS_INCLUDING");
                        mm:add_condition("faction " .. faction_name);
                        
                        
                        local building_level = "rhox_mar_emp_garrison_1"
                        
                        mm:add_condition("building_level " .. building_level);
                        mm:add_condition("total 1");
                        mm:add_payload("text_display dummy_mission_1_ulrika");
                        mm:trigger() 
                    end
                end,
                true
            )
        end
        
        if cm:get_faction("ovn_mar_house_den_euwe"):is_human() then
            if cm:is_new_game() then 
                out("Rhox mar: Locking Vanilla Ulrika mission")
                character_unlocking.character_data["ulrika"].factions_involved["ovn_mar_house_den_euwe"] = true --this will make vanilla script not trigger Ulrika mission chain
            end
            cm:add_faction_turn_start_listener_by_name(
                "rhox_mar_egmond_ulrika_trigger_listner",
                "ovn_mar_house_den_euwe",
                function(context)
                    local faction = context:faction()
                    local faction_name = faction:name()

                    if cm:get_saved_value("rhox_mar_egmond_ulrika_triggered") ~=true and faction:faction_leader():rank() >= 11 then
                        out("Rhox Mar: triggering mission!")
                        cm:set_saved_value("rhox_mar_egmond_ulrika_triggered", true)
                        
                        local mm = mission_manager:new(faction_name, "wh3_dlc23_ie_emp_ulrika_stage_1")
                        mm:add_new_objective("CONSTRUCT_N_BUILDINGS_INCLUDING");
                        mm:add_condition("faction " .. faction_name);
                        
                        
                        local building_level = "rhox_egmond_emp_garrison_1"
                        
                        mm:add_condition("building_level " .. building_level);
                        mm:add_condition("total 1");
                        mm:add_payload("text_display dummy_mission_1_ulrika");
                        mm:trigger() 
                    end
                end,
                true
            )
        end    
        
        
        if cm:get_faction("wh_main_emp_marienburg"):is_human() or cm:get_faction("ovn_mar_house_den_euwe"):is_human() then
            core:add_listener(
                "rhox_mar_ulrica_listener",
                "MissionSucceeded",
                function(context)
                    local faction = context:faction()
                    local faction_name = faction:name()
                    return context:mission():mission_record_key() == "wh3_dlc23_ie_emp_ulrika_stage_1" and (faction_name == "wh_main_emp_marienburg" or faction_name == "ovn_mar_house_den_euwe")
                end,
                function(context)
                    local faction = context:faction()
                    local faction_name = faction:name()
                    cm:trigger_mission(faction_name, "wh3_dlc23_ie_emp_ulrika_stage_2", true)
                end,
                false
            );
		end
		
		
	end
);
