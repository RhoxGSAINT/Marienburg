-- Empire
-- Thyrus when building the Mage Tower

local haeyndrik_recruited = false



cm:add_first_tick_callback(
    function()
        if haeyndrik_recruited == false then --don't do this if he is already recruited
            core:add_listener(
                    "HendrikBuildingCompleted",
                    "BuildingCompleted",
                    function(context)
                        local building = context:building()
                        local building_faction = building:faction()
                        return building:name() == "hkrul_mar_temple_haeyndrik" and building_faction:culture() == "wh_main_emp_empire"
                    end,
                    function(context)
                        haeyndrik_recruited = true
                        local faction = context:building():faction()
                        local marienburg_faction_cqi = faction:command_queue_index();  
                        local character_detail_script_interface = cm:spawn_character_to_pool(faction:name(), "names_name_605123686", "names_name_605123685", "", "", 50, true, "general", "hkrul_hendrik", true, "");
                        --out("Rhox Mar: Are you dead here?")
                        --out("Rhox Mar: Is it available?: "..character_detail_script_interface:primary_character():get_forename())
                        --out("Rhox Mar: CQI: "..character_detail_script_interface:primary_character():command_queue_index())
                        cm:trigger_incident(faction:name(), "rhox_mar_ll_hendrik_available", true)
                    end,
                    false
            )
        end
        core:add_listener(
                "HendrikRecruited",
                "CharacterCreated",
                function(context)
                    return context:character():character_subtype_key() == "hkrul_hendrik"
                end,
                function(context)
                    --out("Rhox Mar: I'm here")
                    local forename =  common:get_localised_string("names_name_605123686")
                    local surname =  common:get_localised_string("names_name_605123685")
                    cm:change_character_custom_name(context:character(), forename, surname,"","") --for emp as they don't have this name group
                end,
                false
        )
    end
);
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_mar_haeyndrik_recruited", haeyndrik_recruited, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			haeyndrik_recruited = cm:load_named_value("rhox_mar_haeyndrik_recruited", haeyndrik_recruited, context)
		end
	end
)