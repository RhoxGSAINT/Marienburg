local fooger_faction = "ovn_mar_house_fooger"  

core:add_listener(
	"rhox_mar_fooger_alliance_success",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "rhox_mar_fooger_alliance"
	end,
	function(context)
        local cqi = cm:get_faction(fooger_faction):faction_leader():cqi()
        local x, y = cm:find_valid_spawn_location_for_character_from_character(fooger_faction, "character_cqi:"..cqi, true)
        cm:spawn_agent_at_position(cm:get_faction(fooger_faction), x, y, "champion", "wh_main_dwf_thane") --you can't recruit him, so he is a unique one.
        local spawned_agent = cm:get_most_recently_created_character_of_type(cm:get_faction(fooger_faction), "champion", "wh_main_dwf_thane")
        if spawned_agent then 
            cm:replenish_action_points(cm:char_lookup_str(spawned_agent:cqi())) --restore action point
        end
	end,
	true
);

core:add_listener(
	"rhox_mar_fooger_special_0_2_skill_point_allocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return skill == "hkrul_fooger_special_0_2"
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		local faction_name = faction:name()
		local dwarf_interface = cm:get_faction("wh_main_dwf_dwarfs")
		
		if dwarf_interface and not dwarf_interface:is_dead() then
			cm:force_make_trade_agreement(faction_name, "wh_main_dwf_dwarfs")
            cm:make_diplomacy_available(faction_name, "wh_main_dwf_dwarfs")
		end
	end,
	true
)