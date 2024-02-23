local confederation_cooldown = 20
local confederation_ended = false



local elector_treaties_to_disable = { --this is copy from wh2_dlc13_empire_politics.lua
	"form confederation",
	"military alliance",
	"defensive alliance",
	"break soft military access",
	"break defensive alliance",
	"break vassal",
	"break client state",
	"break trade",
	"break alliance"
}


core:add_listener(
	"rhox_mar_enable_marienburg_confederation", --vanilla script disables Empire factions from making alliance and confederation with all the Empires, should make it available
	"FactionRoundStart",
	function(context)
		local faction = context:faction();

		return faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false
	end,
	function(context)
		local faction = context:faction();
		local faction_key = faction:name();
		cm:callback(
			function()
				for i = 1, #elector_treaties_to_disable do
					cm:force_diplomacy("faction:" .. faction_key, "faction:ovn_mar_house_den_euwe",
						elector_treaties_to_disable[i], true, true, false)
					cm:force_diplomacy("faction:" .. faction_key, "faction:ovn_mar_cult_of_manann",
						elector_treaties_to_disable[i], true, true, false)
					cm:force_diplomacy("faction:" .. faction_key, "faction:ovn_mar_house_fooger",
						elector_treaties_to_disable[i], true, true, false)
				end
			end,
			1 --we need it to start after the vanilla script has been fired
		)
	end,
	true
)



local function rhox_mar_confederation_dilemma_choice(context)
	local dilemma = context:dilemma();
	local choice = context:choice();
	local faction = context:faction();
	local faction_key = faction:name();


	-- CONFEDERATION
	local confederation_faction_key = "ovn_mar_house_den_euwe";
	local confederation_faction = cm:model():world():faction_by_key(confederation_faction_key);


	if choice == 0 then
		cm:force_confederation(faction_key, confederation_faction_key);
		confederation_ended = true
	elseif choice == 1 then
		confederation_ended = true  --they refused and there wern't be any confederation offer
	elseif choice == 2 then
		confederation_cooldown = 10 --just increase the cooldown so they can see the event 10 turns later  --rhox temp change it to 10 after testing
	end
end



cm:add_first_tick_callback(
	function()
		local marienburg_faction = cm:get_faction("wh_main_emp_marienburg")
		if marienburg_faction and marienburg_faction:is_human() and confederation_ended == false then
			core:add_listener(
				"rhox_mar_confederation_RoundStart",
				"FactionRoundStart",
				function(context)
					return context:faction():name() == "wh_main_emp_marienburg"
				end,
				function(context)
					local confederation_faction_key = "ovn_mar_house_den_euwe";
					local confederation_faction = cm:model():world():faction_by_key(confederation_faction_key);

					if not confederation_faction then
						return --don't do anything if it does not exist
					end

					if cm:model():turn_number() == 15 then                        --it has nothing to do with conf, but put in here, it won't be affected.
						cm:trigger_incident("wh_main_emp_marienburg", "rhox_mar_free_witch_hunter", true)
						hkrul_mar_setup_solkan_missions("wh_main_emp_marienburg") --free witch hunter and mission to get Solkan
					end


					if cm:model():turn_number() == 18 and confederation_faction:is_null_interface() == false and confederation_faction:is_dead() == false then --show them warning so they can prepare money for it
						cm:trigger_incident("wh_main_emp_marienburg", "rhox_mar_conf_warning", true)
					end
					confederation_cooldown = confederation_cooldown - 1;


					if confederation_cooldown == 0 then
						if confederation_faction:is_null_interface() == false and confederation_faction:is_dead() == false then
							--trigger dilemma
							cm:trigger_dilemma_with_targets(context:faction():command_queue_index(),
								"rhox_mar_confederation_dilemma", confederation_faction:command_queue_index(), 0, 0, 0, 0,
								0);
						else --it means faction is dead just increase the cooldown by 10
							confederation_cooldown = 10
						end
					end
				end,
				true
			)
			core:add_listener(
				"mar_DilemmaChoiceMadeEvent",
				"DilemmaChoiceMadeEvent",
				function(context)
					return context:dilemma() == "rhox_mar_confederation_dilemma"
				end,
				function(context) rhox_mar_confederation_dilemma_choice(context) end,
				true
			);
		end

		if vfs.exists("script/frontend/mod/mixu_frontend_le_darkhand.lua") and marienburg_faction and marienburg_faction:is_human() and cm:get_saved_value("rhox_mar_edvard_dilemma_triggered") ~= true then
			core:add_listener(
				"rhox_mar_edvard_dilemma_checker",
				"FactionRoundStart",
				function(context)
					local edvard_faction = cm:get_faction("mixer_emp_van_der_kraal")
					return context:faction():name() == "wh_main_emp_marienburg" and edvard_faction and
					edvard_faction:is_dead() and edvard_faction:was_confederated() == false and
					cm:get_saved_value("rhox_mar_edvard_dilemma_triggered") ~= true
				end,
				function(context)
					local faction = context:faction()
					cm:set_saved_value("rhox_mar_edvard_dilemma_triggered", true)
					local dilemma_builder = cm:create_dilemma_builder("rhox_mar_edvard_confederation_dilemma");
					local payload_builder = cm:create_payload();


					payload_builder:text_display("rhox_mar_dummy_edvard_appears")


					payload_builder:treasury_adjustment(-12500);


					dilemma_builder:add_choice_payload("FIRST", payload_builder);
					payload_builder:clear();

					dilemma_builder:add_choice_payload("SECOND", payload_builder);

					cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
				end,
				false
			)
			core:add_listener(
				"mar_DilemmaChoiceMadeEvent",
				"DilemmaChoiceMadeEvent",
				function(context)
					return context:dilemma() == "rhox_mar_edvard_confederation_dilemma" and context:choice() == 0
				end,
				function(context)
					local general_x_pos, general_y_pos = cm:find_valid_spawn_location_for_character_from_settlement(
					"mixer_emp_van_der_kraal", marienburg_faction:home_region():name(), false, true, 5)
					cm:create_force_with_general(
						"mixer_emp_van_der_kraal",
						"snek_hkrul_mar_landship,snek_hkrul_mar_landship,"..
						"mixu_emp_inf_pirate_deckhands_swords,mixu_emp_inf_pirate_deckhands_swords,mixu_emp_inf_pirate_deckhands_polearms,mixu_emp_inf_pirate_deckhands_polearms,"..
						"mixu_emp_inf_buccaneers_great_axe,mixu_emp_inf_buccaneers_great_axe,mixu_emp_inf_buccaneers_sword_and_bombs,mixu_emp_inf_buccaneers_sword_and_bombs,"..
						"mixu_emp_inf_gunnery_mob_pistols,mixu_emp_inf_gunnery_mob_pistols,mixu_emp_inf_gunnery_mob_pistols,mixu_emp_inf_gunnery_mob_pistols,mixu_emp_inf_gunnery_mob_pistols,mixu_emp_inf_gunnery_mob_pistols,"..
						"mixu_emp_art_carronade,mixu_emp_art_carronade",
						marienburg_faction:home_region():name(),
						general_x_pos,
						general_y_pos,
						"general",
						"mixu_emp_fleet_admiral_male",
						"",
						"",
						"",
						"",
						false,
						function(cqi)
							cm:apply_effect_bundle_to_characters_force("wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition",cqi,0)
							cm:force_alliance("mixer_emp_van_der_kraal", "wh_main_emp_marienburg", true)
						end
					)
				end,
				false
			);
		end
	end
);

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_mar_confederation_cooldown", confederation_cooldown, context)
		cm:save_named_value("rhox_mar_confederation_ended", confederation_ended, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			confederation_cooldown = cm:load_named_value("rhox_mar_confederation_cooldown", confederation_cooldown,
				context)
			confederation_ended = cm:load_named_value("rhox_mar_confederation_ended", confederation_ended, context)
		end
	end
)
