
function caravans:rhox_mar_caravan_replace_listener()   --replace pre-existing Cathay caravan listeners

	--[[ --not now guys
        if vfs.exists("script/campaign/mod/twill_old_world_caravans.lua") then --for compatibility
            return
        end
        --]]
    core:remove_listener("caravan_waylay_query")
    core:add_listener(
        "caravan_waylay_query",
        "QueryShouldWaylayCaravan",
        function(context)
            return context:faction():is_human() and caravans.culture_to_faction[context:faction():culture()]
        end,
        function(context)
            local faction_key = context:faction():name()

            if caravans.events_fired[faction_key] == nil or caravans.events_fired[faction_key] == false then
                if self:event_handler(context) == false then
                    out.design("Caravan not valid for event");
                elseif caravans.events_fired[faction_key] ~= nil then
                    caravans.events_fired[faction_key] = true
                end
            end
        end,
        true
    );


    core:remove_listener("caravan_waylaid")
    core:add_listener(
        "caravan_waylaid",
        "CaravanWaylaid",
        function(context)
            return caravans.culture_to_faction[context:faction():culture()]
        end,
        function(context)
            self:waylaid_caravan_handler(context);
        end,
        true
    );

    
    
    core:remove_listener("add_inital_force")
    core:add_listener(
		"add_inital_force",
		"CaravanRecruited",
		function(context)
            return caravans.culture_to_faction[context:faction():culture()]
        end,
		function(context)
			out.design("*** Caravan recruited ***");
			if context:caravan():caravan_force():unit_list():num_items() < 2 then
				local caravan = context:caravan();
				self:add_inital_force(caravan);
				cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
			end;
		end,
		true
	);

    
    
    
    core:remove_listener("add_inital_bundles")
    core:add_listener(
		"add_inital_bundles",
		"CaravanSpawned",
		function(context)
            return caravans.culture_to_faction[context:faction():culture()]
        end,
		function(context)
			out.design("*** Caravan deployed ***");
			local caravan = context:caravan();
			self:set_stance(caravan);
			cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
		end,
		true
	);

    
    core:remove_listener("caravan_finished")   
    core:add_listener(
		"caravan_finished",
		"CaravanCompleted",
		function(context)
            return caravans.culture_to_faction[context:faction():culture()]
        end,
		function(context)
			-- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
			local node = context:complete_position():node()
			local region_name = node:region_key()
			local region = node:region_data():region()
			local region_owner = region:owning_faction();
			
			out.design("Caravan (player) arrived in: "..region_name)
			
			local faction = context:faction()
			local faction_key = faction:name();
			local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
			local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
			cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
			cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
			core:trigger_event("ScriptEventCaravanCompleted", context);
			
			if faction:is_human() then
				self:reward_item_check(faction, region_name, context:caravan_master())
			end
			--faction has tech that grants extra trade tariffs bonus after every caravan - create scripted bundle
			if faction:has_technology("wh3_dlc23_tech_chd_industry_24") then
				local temp_trade = self.trade_modifier + 5
				self.trade_modifier = temp_trade
				local trade_effect = "wh_main_effect_economy_trade_tariff_mod"
				local trade_effect_bundle = cm:create_new_custom_effect_bundle("wh3_dlc23_effect_chd_convoy_trade_tariff_scripted_bundle")

				trade_effect_bundle:add_effect(trade_effect, "faction_to_faction_own_unseen", temp_trade)
				trade_effect_bundle:set_duration(0)

				if faction:has_effect_bundle(trade_effect_bundle:key()) then
					cm:remove_effect_bundle(trade_effect_bundle:key(), faction:name())
				end				
				cm:apply_custom_effect_bundle_to_faction(trade_effect_bundle, faction)

			end
				
			if not region_owner:is_null_interface() then
				local region_owner_key = region_owner:name()
				cm:cai_insert_caravan_diplomatic_event(region_owner_key,faction_key)

				if region_owner:is_human() and faction_key ~= region_owner_key then
					cm:trigger_incident_with_targets(
						region_owner:command_queue_index(),
						"wh3_main_cth_caravan_completed_received",
						0,
						0,
						0,
						0,
						region:cqi(),
						0
					)
				end
			end
			
			--Reduce demand
			local cargo = context:caravan():cargo()
			local value = math.floor(-cargo/18)
			local faction = self.culture_to_faction[context:faction():culture()];
			cm:callback(function()self:adjust_end_node_value(region_name, value, "add", faction) end, 5);
						
		end,
		true
	);

    
    
    
    
    
    core:remove_listener("caravan_master_heal")
    core:add_listener(
		"caravan_master_heal",
		"CaravanMoved",
		function(context)
			return not context:caravan():is_null_interface() and caravans.culture_to_faction[context:faction():culture()];
		end,
		function(context)
			--Heal Lord
			local caravan_force_list = context:caravan_master():character():military_force():unit_list();
			local unit = nil;
			for i=0, caravan_force_list:num_items()-1 do
				unit = caravan_force_list:item_at(i);

				---TODO way to make this generic?
				if unit:unit_key() == "wh3_main_cth_cha_lord_caravan_master" then
					cm:set_unit_hp_to_unary_of_maximum(unit, 1);
				end
			end
			--Spread out caravans
			local caravan_lookup = cm:char_lookup_str(context:caravan():caravan_force():general_character():command_queue_index())
			local x,y = cm:find_valid_spawn_location_for_character_from_character(
				context:faction():name(),
				caravan_lookup,
				true,
				cm:random_number(15,5)
				)
			cm:teleport_to(caravan_lookup,  x,  y);
		end,
		true
	);


end