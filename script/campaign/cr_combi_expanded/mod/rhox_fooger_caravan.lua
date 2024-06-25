local fooger_faction_key = "ovn_mar_house_fooger"



local rhox_caravan_exception_list = {
    ["hkrul_mar_caravan_master"] = true,
    ["hkrul_mar_caravan_master_horse"] = true,
    ["hkrul_crispijn"] = true,
    ["hkrul_guzunda"] = true,
    ["hkrul_lisette"] = true,
    ["hkrul_cross"] = true,
    ["hkrul_pg"] = true,
    ["hkrul_fooger_caravan_master"] = true,
    ["hkrul_rasha"] = true,
    ["hkrul_ogg"] = true,
    ["hkrul_paldee"] = true,
}




local rhox_mar_fooger_event_tables = {

    ["banditExtort"] =
    --returns its probability [1]
    { function(world_conditions)
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = math.floor(bandit_threat / 10) + 3;

        local event_region = world_conditions["event_region"];
        local enemy_faction = event_region:owning_faction();

        local enemy_faction_name = enemy_faction:name();
        if enemy_faction_name == "rebels" then
            enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
        end

        local eventname = "banditExtort" .. "?"
            .. event_region:name() .. "*"
            .. enemy_faction_name .. "*"
            .. tostring(bandit_threat) .. "*";

        local caravan_faction = world_conditions["faction"];
        if enemy_faction:name() == caravan_faction:name() then
            probability = 0;
        end;

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("banditExtort action called")
            local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_1A";
            local caravan = caravan_handle;

            --Decode the string into arguments-- read_out_event_params explains encoding
            local decoded_args = caravans:read_out_event_params(event_conditions, 3);

            local is_ambush = false;
            local target_faction = decoded_args[2];
            local enemy_faction;
            local target_region = decoded_args[1];

            local bandit_threat = tonumber(decoded_args[3]);

            local attacking_force = caravans:generate_attackers(bandit_threat, "");

            --Handles the custom options for the dilemmas, such as battles (only?)
            local enemy_cqi = caravans:attach_battle_to_dilemma(
                dilemma_name,
                caravan,
                attacking_force,
                is_ambush,
                target_faction,
                enemy_faction,
                target_region,
                function()
                    cm:set_caravan_cargo(caravan_handle, caravan_handle:cargo() - 200)
                end
            );
            out.design(enemy_cqi);

            local target_faction_object = cm:get_faction(target_faction);

            --Trigger dilemma to be handled by above function
            local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
            local faction_key = caravan_handle:caravan_force():faction():name();

            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            dilemma_builder:add_choice_payload("FIRST", payload_builder);
            payload_builder:clear();

            local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
            cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
            cargo_bundle:set_duration(0);

            payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
            local own_faction = caravan_handle:caravan_force():faction();
            if target_faction_object:subculture() == "wh3_main_sc_ogr_ogre_kingdoms" and not target_faction_object:name() == "wh3_main_ogr_ogre_kingdoms_qb1" then
                --for anyone searching for diplomatic_attitude_adjustment: the int ranges from -6 -> 6, and selects a value set in the DB
                payload_builder:diplomatic_attitude_adjustment(target_faction_object, 6);
            else
                out.design("Use best ogre faction " .. caravans:get_best_ogre_faction(own_faction:name()):name())
                payload_builder:diplomatic_attitude_adjustment(caravans:get_best_ogre_faction(own_faction:name()), 6);
            end
            dilemma_builder:add_choice_payload("SECOND", payload_builder);

            dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
            dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

            out.design("Triggering dilemma:" .. dilemma_name)
            cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
        end,
        true },

    ["banditAmbush"] =
    --returns its probability [1]
    { function(world_conditions)
        local bandit_threat = world_conditions["bandit_threat"];
        local event_region = world_conditions["event_region"];
        local enemy_faction = event_region:owning_faction();

        local enemy_faction_name = enemy_faction:name();
        if enemy_faction_name == "rebels" then
            enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
        end

        local eventname = "banditAmbush" .. "?"
            .. event_region:name() .. "*"
            .. enemy_faction_name .. "*"
            .. tostring(bandit_threat) .. "*";

        local probability = math.floor(bandit_threat / 20) + 3;

        local caravan_faction = world_conditions["faction"];
        if enemy_faction:name() == caravan_faction:name() then
            probability = 0;
        end;

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("banditAmbush action called")
            local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_2A";
            local caravan = caravan_handle;

            --Decode the string into arguments-- Need to specify the argument encoding
            local decoded_args = caravans:read_out_event_params(event_conditions, 3);

            local is_ambush = true;
            local target_faction = decoded_args[2];
            local enemy_faction;
            local target_region = decoded_args[1];

            local bandit_threat = tonumber(decoded_args[3]);
            local attacking_force = caravans:generate_attackers(bandit_threat)


            --If anti ambush skill, then roll for detected event, if passed trigger event with battle
            -- else just ambush
            if caravan:caravan_master():character_details():has_skill("wh3_main_skill_cth_caravan_master_scouts") or cm:random_number(3, 0) == 3 then
                local enemy_cqi = caravans:attach_battle_to_dilemma(
                    dilemma_name,
                    caravan,
                    attacking_force,
                    false,
                    target_faction,
                    enemy_faction,
                    target_region,
                    nil
                );

                --Trigger dilemma to be handled by aboove function
                local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
                local settlement_target = cm:get_region(target_region):settlement();

                out.design("Triggering dilemma:" .. dilemma_name)

                local haggling_skill = caravan_handle:caravan_master():character_details():character():bonus_values()
                :scripted_value("rhox_mar_lower_toll", "value");
                if haggling_skill < -95 then
                    haggling_skill = -95 --fail safe you're not going to get money from it
                end

                --Trigger dilemma to be handled by above function
                local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
                local payload_builder = cm:create_payload();

                dilemma_builder:add_choice_payload("FIRST", payload_builder);

                payload_builder:treasury_adjustment(math.floor(-1000 * ((100 + haggling_skill) / 100)));

                dilemma_builder:add_choice_payload("SECOND", payload_builder);

                dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
                dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

                out.design("Triggering dilemma:" .. dilemma_name)
                cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
            else
                --Immidiately ambush
                --create_caravan_battle(caravan, attacking_force, target_region, true)
                caravans:spawn_caravan_battle_force(caravan, attacking_force, target_region, true, true);
            end;
        end,
        true },

    ["banditHungryOgres"] =
    --returns its probability [1]
    { function(world_conditions)
        local bandit_threat = world_conditions["bandit_threat"];
        local event_region = world_conditions["event_region"];
        local enemy_faction_name = event_region:owning_faction():name();

        if enemy_faction_name == "rebels" then
            enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
        end
        local enemy_faction = cm:get_faction(enemy_faction_name);

        local random_unit = "NONE";
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()

        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items() - 1, 1))
            :unit_key();

            if random_unit == "wh3_main_cth_cha_lord_caravan_master" or random_unit == "wh3_main_cth_cha_lord_magistrate_0" then
                random_unit = "NONE";
            end
            out.design("Random unit to be eaten: " .. random_unit);
        end;

        --Construct targets
        local eventname = "banditHungryOgres" .. "?"
            .. event_region:name() .. "*"
            .. random_unit .. "*"
            .. tostring(bandit_threat) .. "*"
            .. enemy_faction_name .. "*";


        --Calculate probability
        local probability = 0;

        if random_unit == "NONE" then
            probability = 0;
        else
            probability = math.min(bandit_threat, 10);

            if enemy_faction:subculture() == "wh3_main_sc_ogr_ogre_kingdoms" then
                probability = probability + 3;
            end
        end
        local caravan_faction = world_conditions["faction"];
        if enemy_faction:name() == caravan_faction:name() then
            probability = 0;
        end;

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("banditHungryOgres action called")
            local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_3";
            local caravan = caravan_handle;

            --Decode the string into arguments-- Need to specify the argument encoding
            local decoded_args = caravans:read_out_event_params(event_conditions, 3);

            local is_ambush = true;
            local target_faction = decoded_args[4];
            local enemy_faction;
            local target_region = decoded_args[1];
            local custom_option = nil;

            local random_unit = decoded_args[2];
            local bandit_threat = tonumber(decoded_args[3]);
            local attacking_force = caravans:generate_attackers(bandit_threat, "ogres")

            --Battle to option 1, eat unit to 2
            local enemy_force_cqi = caravans:attach_battle_to_dilemma(
                dilemma_name,
                caravan,
                attacking_force,
                false,
                target_faction,
                enemy_faction,
                target_region,
                nil
            );

            --Trigger dilemma to be handled by above function

            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            dilemma_builder:add_choice_payload("FIRST", payload_builder);

            local target_faction_object = cm:get_faction(target_faction);
            local own_faction = caravan_handle:caravan_force():faction();
            if target_faction_object:subculture() == "wh3_main_sc_ogr_ogre_kingdoms" and not target_faction_object:name() == "wh3_main_ogr_ogre_kingdoms_qb1" then
                --for anyone searching for diplomatic_attitude_adjustment: the int ranges from -6 -> 6, and selects a value set in the DC
                payload_builder:diplomatic_attitude_adjustment(target_faction_object, 6);
            else
                out.design("Use best ogre faction " .. caravans:get_best_ogre_faction(own_faction:name()):name())
                payload_builder:diplomatic_attitude_adjustment(caravans:get_best_ogre_faction(own_faction:name()), 6);
            end
            payload_builder:remove_unit(caravan:caravan_force(), random_unit);
            dilemma_builder:add_choice_payload("SECOND", payload_builder);

            out.design("Triggering dilemma:" .. dilemma_name)
            dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));

            dilemma_builder:add_target("target_military_1", caravan:caravan_force());

            cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        end,
        true },

    ["genericShortcut"] =
    --returns its probability [1]
    { function(world_conditions)
        local eventname = "genericShortcut" .. "?";
        local probability = 2;

        local has_scouting = world_conditions["caravan_master"]:character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
            
            
        if has_scouting >0 then
            probability = probability + 6
        end

        local caravan_character_list = world_conditions["caravan_master"]:character():military_force():character_list()
        for i = 0, caravan_character_list:num_items() - 1 do
            local current_character = caravan_character_list:item_at(i);
            if current_character:has_skill("hkrul_crispijn_special_1_1") then
                out("Rhox mar: Find hkrul_crispijn with a skill!")
                probability = probability + 6
            end
            if current_character:has_skill("hkrul_guzunda_special_1_0") then
                out("Rhox mar: Find hkrul_gzunda with a skill!")
                probability = probability + 6
            end
            if current_character:has_skill("hkrul_cross_special_1_0") then
                out("Rhox mar: Find hkrul_cross with a skill!")
                probability = probability + 6
            end
            if current_character:has_skill("hkrul_pg_special_3_1") then
                out("Rhox mar: Find hkrul_pg with a skill!")
                probability = probability + 6
            end
        end

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("genericShortcut action called")
            local dilemma_list = { "wh3_main_dilemma_cth_caravan_1A", "wh3_main_dilemma_cth_caravan_1B" }
            local dilemma_name = dilemma_list[cm:random_number(2, 1)];

            --Decode the string into arguments-- Need to specify the argument encoding
            --none to decode

            --Trigger dilemma to be handled by aboove function
            local faction_key = caravan_handle:caravan_force():faction():name();
            local force_cqi = caravan_handle:caravan_force():command_queue_index();

            caravans:attach_battle_to_dilemma(
                dilemma_name,
                caravan_handle,
                nil,
                false,
                nil,
                nil,
                nil,
                function()
                    cm:move_caravan(caravan_handle);
                end
            );

            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
            if scout_skill < -99 then
                scout_skill = -99 --fail safe you're not going to get money from it
            end
            dilemma_builder:add_choice_payload("FIRST", payload_builder);
            payload_builder:clear();

            payload_builder:treasury_adjustment(math.floor(-500 * ((100 + scout_skill) / 100)));
            dilemma_builder:add_choice_payload("SECOND", payload_builder);

            dilemma_builder:add_target("default", caravan_handle:caravan_force());

            out.design("Triggering dilemma:" .. dilemma_name)
            cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        end,
        false },

    ["genericCharacter"] =
    --returns its probability [1]
    { function(world_conditions)
        local eventname = "genericCharacter" .. "?";

        local probability = 1;

        local caravan_force = world_conditions["caravan"]:caravan_force();
        local hero_list = { "wh3_main_ogr_cha_hunter_0", "wh_main_emp_cha_captain_0", "wh2_main_hef_cha_noble_0" }

        if not cm:military_force_contains_unit_type_from_list(caravan_force, hero_list) then
            out.design("No characters - increase probability")
            probability = 5;
        end

        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()

        if caravan_force_unit_list:num_items() >= 19 then
            probability = 0;
        end

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("genericCharacter action called")

            local AorB = { "A", "B" };
            local choice = AorB[cm:random_number(#AorB, 1)]

            local dilemma_name = "wh3_main_dilemma_cth_caravan_3" .. choice;

            --Decode the string into arguments-- Need to specify the argument encoding
            --none to decode

            --Trigger dilemma to be handled by aboove function
            local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
            local force_cqi = caravan_handle:caravan_force():command_queue_index();
            local hero_list = { "wh3_main_ogr_cha_hunter_0", "wh_main_emp_cha_captain_0", "wh2_main_hef_cha_noble_0" };


            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            dilemma_builder:add_choice_payload("FIRST", payload_builder);

            if choice == "B" then
                payload_builder:treasury_adjustment(-500);
            end
            payload_builder:add_unit(caravan_handle:caravan_force(), hero_list[cm:random_number(#hero_list, 1)], 1, 0);
            dilemma_builder:add_choice_payload("SECOND", payload_builder);
            payload_builder:clear();

            dilemma_builder:add_target("default", caravan_handle:caravan_force());

            out.design("Triggering dilemma:" .. dilemma_name)
            cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        end,
        false },

    ["genericCargoReplenish"] =
    --returns its probability [1]
    { function(world_conditions)
        local eventname = "genericCargoReplenish" .. "?";
        local caravan_force = world_conditions["caravan"]:caravan_force();

        local probability = 4;

        if cm:military_force_average_strength(caravan_force) == 100 and world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0
        end

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("genericCargoReplenish action called")
            local dilemma_name = "wh3_main_dilemma_cth_caravan_2B";

            --Decode the string into arguments-- Need to specify the argument encoding
            --none to decode

            --Trigger dilemma to be handled by aboove function
            local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
            local force_cqi = caravan_handle:caravan_force():command_queue_index();

            caravans:attach_battle_to_dilemma(
                dilemma_name,
                caravan_handle,
                nil,
                false,
                nil,
                nil,
                nil,
                function()
                    cm:set_caravan_cargo(caravan_handle, caravan_handle:cargo() + 200)
                end
            );

            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
            replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
            replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory",
                "force_to_force_own", 1);
            replenish:set_duration(2);

            payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), replenish);
            dilemma_builder:add_choice_payload("FIRST", payload_builder);
            payload_builder:clear();

            local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
            cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 200);
            cargo_bundle:set_duration(0);

            payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
            dilemma_builder:add_choice_payload("SECOND", payload_builder);

            dilemma_builder:add_target("default", caravan_handle:caravan_force());

            out.design("Triggering dilemma:" .. dilemma_name)
            cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        end,
        false },

    ["recruitmentChoiceA"] =
    --returns its probability [1]
    { function(world_conditions)
        local eventname = "recruitmentChoiceA" .. "?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()

        local probability = math.floor((20 - army_size) / 2);

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("recruitmentChoiceA action called")
            local dilemma_name = "wh3_main_dilemma_cth_caravan_4A";

            --Decode the string into arguments-- Need to specify the argument encoding
            --none to decode

            caravans:attach_battle_to_dilemma(
                dilemma_name,
                caravan_handle,
                nil,
                false,
                nil,
                nil,
                nil,
                nil
            );

            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            local ranged_list = { "hkrul_mar_inf_handgun", "hkrul_mar_riverwarden", "wh_main_emp_inf_crossbowmen",
                "wh2_main_hef_inf_lothern_sea_guard_1" };
            local melee_list = { "wh_main_emp_inf_halberdiers", "wh_main_emp_inf_swordsmen", "hkrul_mar_inf_goedendagers" };

            payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list, 1)], 2, 0);
            dilemma_builder:add_choice_payload("FIRST", payload_builder);
            payload_builder:clear();

            payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list, 1)], 3, 0);
            dilemma_builder:add_choice_payload("SECOND", payload_builder);

            dilemma_builder:add_target("default", caravan_handle:caravan_force());

            out.design("Triggering dilemma:" .. dilemma_name)
            cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        end,
        false },

    ["recruitmentChoiceB"] =
    --returns its probability [1]
    { function(world_conditions)
        local eventname = "recruitmentChoiceB" .. "?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()

        local probability = math.floor((20 - army_size) / 2);

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("recruitmentChoiceB action called")
            local dilemma_name = "wh3_main_dilemma_cth_caravan_4B";

            --Decode the string into arguments-- Need to specify the argument encoding
            --none to decode

            caravans:attach_battle_to_dilemma(
                dilemma_name,
                caravan_handle,
                nil,
                false,
                nil,
                nil,
                nil,
                nil
            );

            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            local ranged_list = { "hkrul_mar_inf_handgun", "hkrul_mar_riverwarden", "wh_main_emp_inf_crossbowmen" };
            local melee_list = { "wh_main_emp_inf_halberdiers", "wh3_main_ogr_inf_maneaters_2", "wh3_main_ogr_inf_maneaters_0" };

            payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list, 1)], 3, 0);
            dilemma_builder:add_choice_payload("SECOND", payload_builder);
            payload_builder:clear();

            payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list, 1)], 2, 0);
            dilemma_builder:add_choice_payload("FIRST", payload_builder);

            dilemma_builder:add_target("default", caravan_handle:caravan_force());

            out.design("Triggering dilemma:" .. dilemma_name)
            cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        end,
        false },

    ["giftFromInd"] =
    --returns its probability [1]
    { function(world_conditions)
        local eventname = "giftFromInd" .. "?";
        local turn_number = cm:turn_number();

        local probability = 1 + math.floor(turn_number / 100);

        if turn_number < 25 then
            probability = 0;
        end

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("giftFromInd action called")
            local dilemma_name = "wh3_main_dilemma_cth_caravan_5";

            caravans:attach_battle_to_dilemma(
                dilemma_name,
                caravan_handle,
                nil,
                false,
                nil,
                nil,
                nil,
                function()
                    cm:set_caravan_cargo(caravan_handle, caravan_handle:cargo() + 1000)
                end
            );

            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            --FIRST double cargo capacity and value, and additional cargo
            payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),
                "wh3_main_trait_blessed_by_ind_riches", false)

            local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
            cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 1000);
            cargo_bundle:set_duration(0);
            payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

            dilemma_builder:add_choice_payload("FIRST", payload_builder);
            payload_builder:clear();

            --SECOND trait and free units
            payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),
                "wh3_main_trait_blessed_by_ind_blades", false)
            local num_units = caravan_handle:caravan_force():unit_list():num_items()

            if num_units < 20 then
                payload_builder:add_unit(caravan_handle:caravan_force(), "wh3_main_cth_inf_dragon_guard_0",
                    math.min(3, 20 - num_units), 9);
            end

            dilemma_builder:add_choice_payload("SECOND", payload_builder);

            dilemma_builder:add_target("default", caravan_handle:caravan_force());

            out.design("Triggering dilemma:" .. dilemma_name)
            cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        end,
        false },

    ["daemonIncursion"] =
    --returns its probability [1]
    { function(world_conditions)
        --Pick random unit
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()

        local random_unit = "NONE";
        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items() - 1, 0))
            :unit_key();

            if random_unit == "wh3_main_cth_cha_lord_caravan_master" then
                random_unit = "NONE";
            end
            out.design("Random unit to be killed: " .. random_unit);
        end;

        local bandit_threat = world_conditions["bandit_threat"];
        local event_region = world_conditions["event_region"];

        --Construct targets
        local eventname = "daemonIncursion" .. "?"
            .. event_region:name() .. "*"
            .. random_unit .. "*"
            .. tostring(bandit_threat) .. "*";


        --Calculate probability
        local probability = 1 + math.floor(cm:model():turn_number() / 100);

        local turn_number = cm:turn_number();
        if turn_number < 25 then
            probability = 0;
        end

        return { probability, eventname }
    end,
        --enacts everything for the event: creates battle, fires dilemma etc. [2]
        function(event_conditions, caravan_handle)
            out.design("daemonIncursion action called")
            local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_4";
            local caravan = caravan_handle;

            --Decode the string into arguments-- Need to specify the argument encoding
            local decoded_args = caravans:read_out_event_params(event_conditions, 3);

            local is_ambush = true;
            local target_faction;
            local enemy_faction = "wh3_main_kho_khorne_qb1";
            local target_region = decoded_args[1];

            local bandit_threat = tonumber(decoded_args[3]);
            local attacking_force = caravans:generate_attackers(bandit_threat, "daemon_incursion")

            --Battle to option 1, eat unit to 2
            local enemy_force_cqi = caravans:attach_battle_to_dilemma(
                dilemma_name,
                caravan,
                attacking_force,
                false,
                target_faction,
                enemy_faction,
                target_region,
                nil
            );

            --Trigger dilemma to be handled by above function
            local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
            local payload_builder = cm:create_payload();

            --Battle the daemons - need a custom trait for winning this
            payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),
                "wh3_main_trait_caravan_daemon_hunter", false)

            local daemon_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_daemon_hunter");
            daemon_bundle:add_effect("wh3_main_effect_attribute_enable_causes_fear_vs_dae", "faction_to_force_own", 1);
            daemon_bundle:set_duration(0);
            payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), daemon_bundle);

            dilemma_builder:add_choice_payload("FIRST", payload_builder);

            payload_builder:clear();

            --Lose soldiers - coward trait?
            local random_unit = decoded_args[2];
            payload_builder:remove_unit(caravan:caravan_force(), random_unit);
            dilemma_builder:add_choice_payload("SECOND", payload_builder);

            out.design("Triggering dilemma:" .. dilemma_name)
            dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
            dilemma_builder:add_target("target_military_1", caravan:caravan_force());

            cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        end,
        true }

};





--------------------------------------------------------------------------------------------------
--Functions

function rhox_mar_fooger_event_handler(context)
    --package up some world state
    --generate an event
    local caravan_master = context:caravan_master();
    local faction = context:faction();

    if context:from():is_null_interface() or context:to():is_null_interface() then
        return false
    end;

    local from_node = context:caravan():position():network():node_for_position(context:from());
    local to_node = context:caravan():position():network():node_for_position(context:to());

    local route_segment = context:caravan():position():network():segment_between_nodes(
        from_node, to_node);

    if route_segment:is_null_interface() then
        return false
    end

    local list_of_regions = route_segment:regions();

    local num_regions;
    local event_region;
    --pick a region from the route at random - don't crash the game if empty
    if list_of_regions:is_empty() ~= true then
        num_regions = list_of_regions:num_items()
        event_region = list_of_regions:item_at(cm:random_number(num_regions - 1, 0)):region();
    else
        out.design("*** No Regions in an Ivory Road segment - Need to fix data in DaVE: campaign_map_route_segments ***")
        out.design("*** Rest of this script will fail ***")
    end;

    local bandit_list_of_regions = {};

    --override region if one is at war
    for i = 0, num_regions - 1 do
        table.insert(bandit_list_of_regions, list_of_regions:item_at(i):region():name())

        if list_of_regions:item_at(i):region():owning_faction():at_war_with(context:faction()) then
            event_region = list_of_regions:item_at(i):region()
        end;
    end


    local bandit_threat = math.floor(cm:model():world():caravans_system():total_banditry_for_regions_by_key(
    bandit_list_of_regions) / num_regions);
    local conditions = {
        ["caravan"] = context:caravan(),
        ["caravan_master"] = caravan_master,
        ["list_of_regions"] = list_of_regions,
        ["event_region"] = event_region,
        ["bandit_threat"] = bandit_threat,
        ["faction"] = faction
    };

    local contextual_event, is_battle = rhox_mar_fooger_generate_event(conditions);

    out("Rhox Fooger: Chosen event is: " .. tostring(contextual_event))
    --if battle then waylay

    if is_battle == true and contextual_event ~= nil then
        context:flag_for_waylay(contextual_event);
    elseif is_battle == false and contextual_event ~= nil then
        context:flag_for_waylay(contextual_event);
        --needs to survive a save load at this point
    end;
end

function rhox_mar_fooger_generate_event(conditions)
    --look throught the events table and create a table for weighted roll
    --pick one and return the event name

    local weighted_random_list = {};
    local total_probability = 0;
    local i = 0;

    local events = rhox_mar_fooger_event_tables

    --build table for weighted roll
    for key, val in pairs(events) do
        i = i + 1;

        --Returns the probability of the event
        local args = val[1](conditions)
        local prob = args[1];
        out("Rhox Fooger: Event name is " .. args[2] .. "and probability is " .. args[1])
        total_probability = prob + total_probability;
        --Returns the name and target of the event
        local name_args = args[2];

        --Returns if a battle is possible from this event
        --i.e. does it need to waylay
        local is_battle = val[3];

        weighted_random_list[i] = { total_probability, name_args, is_battle }
    end

    --check all the probabilites until matched
    local no_event_chance = 25;
    local random_int = cm:random_number(total_probability + no_event_chance, 1);
    local is_battle = nil;
    local contextual_event_name = nil;

    for j = 1, i do
        if weighted_random_list[j][1] >= random_int then
            contextual_event_name = weighted_random_list[j][2];
            is_battle = weighted_random_list[j][3];
            break;
        end
    end

    return contextual_event_name, is_battle
end;

function rhox_mar_fooger_waylaid_caravan_handler(context)
    local event_name_formatted = context:context();
    local caravan_handle = context:caravan();

    local event_key = caravans:read_out_event_key(event_name_formatted); --use vanilla
    out("Rhox Fooger: rhox_mar_fooger_waylaid_caravan_handler Going to call event: " .. event_key)
    local events = rhox_mar_fooger_event_tables
    --call the action side of the event
    events[event_key][2](event_name_formatted, caravan_handle);
end

function rhox_mar_fooger_adjust_end_node_values_for_demand()
    local temp_end_nodes = rhox_mar_fooger_safe_get_saved_value_ivory_road_demand()

    for key, val in pairs(temp_end_nodes) do
        out.design("Key: " .. key .. " and value: " .. val .. " for passive demand increase.")
        rhox_mar_fooger_adjust_end_node_value(key, 1, "add")
    end
end

function rhox_mar_fooger_initalize_end_node_values()
    --randomise the end node values
    local end_nodes = {
        ["wh3_main_combi_region_frozen_landing"]   = cm:random_number(75, 25),
        ["wh3_main_combi_region_myrmidens"]        = cm:random_number(75, 25),
        ["wh3_main_combi_region_erengrad"]         = cm:random_number(75, 25),
        ["wh3_main_combi_region_karaz_a_karak"]    = cm:random_number(150, 60),
        ["wh3_main_combi_region_castle_drakenhof"] = cm:random_number(150, 60),
        ["wh3_main_combi_region_altdorf"]          = cm:random_number(150, 60),
        ["wh3_main_combi_region_marienburg"]       = cm:random_number(150, 60)
    };


    --save them
    cm:set_saved_value("rhox_mar_fooger_demand", end_nodes);
    local temp_end_nodes = rhox_mar_fooger_safe_get_saved_value_ivory_road_demand()

    --apply the effect bundles
    for key, val in pairs(temp_end_nodes) do
        out.design("Key: " .. key .. " and value: " .. val)
        rhox_mar_fooger_adjust_end_node_value(key, val, "replace")
    end
end

function rhox_mar_fooger_safe_get_saved_value_ivory_road_demand()
    return cm:get_saved_value("rhox_mar_fooger_demand");
end

function rhox_mar_fooger_adjust_end_node_value(region_name, value, operation, apply_variance)
    local region = cm:get_region(region_name);
    if not region then
        script_error("Could not find region " .. region_name .. " for caravan script")
        return false
    end
    local cargo_value_bundle = cm:create_new_custom_effect_bundle("wh3_main_ivory_road_end_node_value");
    cargo_value_bundle:set_duration(0);



    if operation == "replace" then
        local temp_end_nodes = rhox_mar_fooger_safe_get_saved_value_ivory_road_demand()
        cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);

        temp_end_nodes[region_name] = value;
        cm:set_saved_value("rhox_mar_fooger_demand", temp_end_nodes);
    elseif operation == "add" then
        local temp_end_nodes = rhox_mar_fooger_safe_get_saved_value_ivory_road_demand()
        local old_value = temp_end_nodes;

        if old_value == nil then
            out.design("*******   Error in ivory road script    *********")
            return 0;
        end

        old_value = old_value[region_name]

        local new_value = math.min(old_value + value, 200)
        new_value = math.max(old_value + value, -60)

        cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", new_value);

        temp_end_nodes[region_name] = new_value;
        cm:set_saved_value("rhox_mar_fooger_demand", temp_end_nodes);
        --elseif operation == "duration" then --not doing duration
    end

    if region:has_effect_bundle("wh3_main_ivory_road_end_node_value") then
        cm:remove_effect_bundle_from_region("wh3_main_ivory_road_end_node_value", region_name);
    end;

    cm:apply_custom_effect_bundle_to_region(cargo_value_bundle, region);
end

local rhox_mar_fooger_item_data = {
    wh3_main_combi_region_altdorf             = "hkrul_ogg",
    wh3_main_combi_region_marienburg          = "hkrul_paldee",
    wh3_main_combi_region_frozen_landing      = "wh3_main_anc_caravan_frost_wyrm_skull",
    wh3_main_combi_region_shattered_stone_bay = "wh3_main_anc_caravan_sky_titan_relic",
    wh3_main_combi_region_novchozy            = "wh3_main_anc_caravan_frozen_pendant",
    wh3_main_combi_region_erengrad            = "wh3_main_anc_caravan_gryphon_legion_lance",
    wh3_main_combi_region_castle_drakenhof    = "wh3_main_anc_caravan_von_carstein_blade",
    wh3_main_combi_region_karaz_a_karak       = "wh2_dlc10_dwf_anc_talisman_the_ankor_chain_caravan",
    wh3_main_combi_region_Ind                 = "wh3_main_anc_caravan_bejewelled_dagger",
    wh3_main_combi_region_myrmidens           = "wh3_main_anc_caravan_grant_of_land",
    wh3_main_combi_region_estalia             = "wh3_main_anc_caravan_spy_in_court",
    wh3_main_chaos_region_zharr_naggrund      = "wh3_main_anc_caravan_statue_of_zharr", --for random reward
    old_altdorf             = "wh3_main_anc_caravan_luminark_lens", --for random reward
    old_marienburg          = "wh3_main_anc_caravan_warrant_of_trade", --for random reward
}
local rhox_mar_fooger_region_to_incident = {
    wh3_main_combi_region_altdorf             = "rhox_fooger_caravan_completed_hkrul_ogg",
    wh3_main_combi_region_marienburg          = "rhox_fooger_caravan_completed_hkrul_paldee",
    wh3_main_combi_region_castle_drakenhof    = "wh3_main_cth_caravan_completed_castle_drakenhof",
    wh3_main_combi_region_erengrad            = "wh3_main_cth_caravan_completed_erengrad",
    wh3_main_combi_region_estalia             = "wh3_main_cth_caravan_completed_estalia",
    wh3_main_combi_region_frozen_landing      = "wh3_main_cth_caravan_completed_frozen_landing",
    wh3_main_combi_region_Ind                 = "wh3_main_cth_caravan_completed_ind",
    wh3_main_combi_region_novchozy            = "wh3_main_cth_caravan_completed_novchozy",
    wh3_main_combi_region_shattered_stone_bay = "wh3_main_cth_caravan_completed_stone_bay",
    wh3_main_combi_region_karaz_a_karak       = "wh3_main_cth_caravan_completed_zharr_nagrund",
    wh3_main_combi_region_myrmidens           = "wh3_main_cth_caravan_completed_tilea",
    old_altdorf             = "wh3_main_anc_caravan_luminark_lens",
    old_marienburg          = "wh3_main_anc_caravan_warrant_of_trade",
}


local rhox_mar_fooger_region_reward_list = {
    "wh3_main_combi_region_estalia",
    "wh3_main_combi_region_Ind",
    "wh3_main_chaos_region_zharr_naggrund",
    "old_altdorf",
    "old_marienburg",
}


local function rhox_mar_fooger_reward_item_check(faction, region_key, caravan_master)
    local reward = rhox_mar_fooger_item_data[region_key]
    if not reward then
        return false
    end
    local character = caravan_master:character()
    if (reward == "hkrul_ogg" or reward == "hkrul_paldee") and cm:get_saved_value(rhox_mar_fooger_region_to_incident[region_key])~= true then
        
        cm:set_saved_value(rhox_mar_fooger_region_to_incident[region_key],true)
        local payload_builder = cm:create_payload();
        payload_builder:text_display("rhox_mar_dummy_"..reward);
        cm:spawn_unique_agent(faction:command_queue_index(), reward, true)
        local incident_builder = cm:create_incident_builder(rhox_mar_fooger_region_to_incident[region_key])
        incident_builder:add_target(character:family_member())
        incident_builder:set_payload(payload_builder)
        cm:launch_custom_incident_from_builder(incident_builder, faction)
        local caravan_military_force = caravan_master:character():military_force()
        local caravan_military_unit_number = caravan_military_force:unit_list():num_items()
        if caravan_military_unit_number < 20 then --it has a place for a hero, if it doesn't, don't embed him
            local unique_agent = cm:get_most_recently_created_character_of_type(faction:name(), "champion", reward)
            if unique_agent then 
                cm:embed_agent_in_force(unique_agent ,caravan_military_force)
            end
        end
    elseif not faction:ancillary_exists(reward) then
        local payload_builder = cm:create_payload();
        payload_builder:character_ancillary_gain(character, reward, false)
        cm:trigger_custom_incident_with_targets(
            faction:command_queue_index(),
            rhox_mar_fooger_region_to_incident[region_key],
            true,
            payload_builder,
            0,
            0,
            character:command_queue_index(),
            0,
            0,
            0
        )
        return 0
    end
    if cm:random_number(10, 1) == 1 then
        return rhox_mar_fooger_reward_item_check(faction,
            rhox_mar_fooger_region_reward_list[cm:random_number(#rhox_mar_fooger_region_reward_list, 1)], caravan_master)
    end
end


rhox_fooger_reinforcements_units = {
    "rhox_fooger_wh_main_dwf_inf_miners_0",
    "rhox_fooger_wh_main_dwf_inf_miners_1",
    "rhox_fooger_wh_main_dwf_inf_longbeards",
    "rhox_fooger_wh_main_dwf_inf_longbeards_1",
    "rhox_fooger_wh_main_dwf_inf_thunderers_0",
    "rhox_fooger_wh_dlc06_dwf_inf_rangers_0",
    "rhox_fooger_wh_dlc06_dwf_inf_rangers_1",
    "rhox_fooger_wh_main_dwf_art_organ_gun"
}


local function rhox_mar_fooger_start_listeners()
    core:add_listener(
        "rhox_mar_fooger_caravan_finished",
        "CaravanCompleted",
        function(context)
            return context:faction():name() == fooger_faction_key
        end,
        function(context)
            -- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
            local node = context:complete_position():node()
            local region_name = node:region_key()
            local region = node:region_data():region()
            local region_owner = region:owning_faction();

            out.design("Caravan (player) arrived in: " .. region_name)

            local faction = context:faction()
            local faction_key = faction:name();
            local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
            local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
            cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
            cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
            core:trigger_event("ScriptEventCaravanCompleted", context);

            if faction:is_human() then
                local incident_builder = cm:create_incident_builder("rhox_fooger_reinforcements")


                local payload_builder = cm:create_payload()
                for i = 1, 4 do
                    local unit_key = rhox_fooger_reinforcements_units
                    [cm:random_number(#rhox_fooger_reinforcements_units)]
                    payload_builder:add_mercenary_to_faction_pool(unit_key, 1)
                end
                incident_builder:set_payload(payload_builder)
                cm:launch_custom_incident_from_builder(incident_builder, faction)
                rhox_mar_fooger_reward_item_check(faction, region_name, context:caravan_master())
            else --just give units
                for i = 1, 4 do
                    local unit_key = rhox_fooger_reinforcements_units
                    [cm:random_number(#rhox_fooger_reinforcements_units)]
                    cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), unit_key, 1)
                end
            end

            --faction has tech that grants extra trade tariffs bonus after every caravan - create scripted bundle

            if not region_owner:is_null_interface() then
                local region_owner_key = region_owner:name()
                cm:cai_insert_caravan_diplomatic_event(region_owner_key, faction_key)

                if region_owner:is_human() and faction_key ~= region_owner_key then
                    cm:trigger_incident_with_targets(
                        region_owner:command_queue_index(),
                        "wh3_main_cth_caravan_completed_received", --it's actually a slave, but let's just insert it.
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
            local value = math.floor(-cargo / 18)
            cm:callback(function() rhox_mar_fooger_adjust_end_node_value(region_name, value, "add") end, 5);
        end,
        true
    );



    core:add_listener(
        "rhox_mar_fooger_caravan_waylay_query",
        "QueryShouldWaylayCaravan",
        function(context)
            return context:faction():is_human() and context:faction():name() == fooger_faction_key
        end,
        function(context)
            out("Rhox Fooger: In the QueryShouldWaylayCaravan listener")
            local faction_key = context:faction():name()
            if rhox_mar_fooger_event_handler(context) == false then
                out.design("Caravan not valid for event");
            end
        end,
        true
    );


    core:add_listener(
        "rhox_mar_fooger_caravan_waylaid",
        "CaravanWaylaid",
        function(context)
            return context:faction():name() == fooger_faction_key
        end,
        function(context)
            rhox_mar_fooger_waylaid_caravan_handler(context);
        end,
        true
    );



    core:add_listener(
        "rhox_mar_fooger_add_inital_force",
        "CaravanRecruited",
        function(context)
            return context:faction():name() == fooger_faction_key
        end,
        function(context)
            out.design("*** Caravan recruited ***");
            if context:caravan():caravan_force():unit_list():num_items() < 2 then
                local caravan = context:caravan();
                hkrul_mar_add_inital_force(caravan)
                cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
            end;
        end,
        true
    );

    core:add_listener(
        "rhox_mar_fooger_add_inital_bundles",
        "CaravanSpawned",
        function(context)
            return context:faction():name() == fooger_faction_key
        end,
        function(context)
            out.design("*** Caravan deployed ***");
            local caravan = context:caravan();
            hkrul_mar_add_effectbundle(caravan);          --reuse this one
            cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
            rhox_mar_add_initial_cargo(context:caravan()) --for Marienburg guys
            cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
        end,
        true
    );



    core:add_listener(
        "rhox_mar_fooger_caravans_increase_demand",
        "WorldStartRound",
        true,
        function(context)
            rhox_mar_fooger_adjust_end_node_values_for_demand();
        end,
        true
    );

    core:add_listener(
        "rhox_mar_fooger_caravan_master_heal",
        "CaravanMoved",
        function(context)
            return context:faction():name() == fooger_faction_key
        end,
        function(context)
            --Heal Lord
            local caravan_force_list = context:caravan_master():character():military_force():unit_list();
            local unit = nil;
            for i = 0, caravan_force_list:num_items() - 1 do
                unit = caravan_force_list:item_at(i);
                if rhox_caravan_exception_list[unit:unit_key()] then --caravan master or LH
                    cm:set_unit_hp_to_unary_of_maximum(unit, 1);
                end
            end
            --Spread out caravans
            local caravan_lookup = cm:char_lookup_str(context:caravan():caravan_force():general_character()
            :command_queue_index())
            local x, y = cm:find_valid_spawn_location_for_character_from_character(
                context:faction():name(),
                caravan_lookup,
                true,
                cm:random_number(15, 5)
            )
            cm:teleport_to(caravan_lookup, x, y);
        end,
        true
    );
    
    
    local fooger_faction = cm:get_faction(fooger_faction_key)
    if fooger_faction:is_human() == false then
        core:add_listener(
            "rhox_ai_fooger_turn_start",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == fooger_faction_key
            end,
            function(context)
                local faction = context:faction()
                local turn = cm:model():turn_number();
                if turn >= 15 then
                    cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_ogg", true)
                end
                if turn >= 25 then
                    cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_paldee", true)
                end
            end,
            true
        )
    end
end



-- Logic --
--Setup
cm:add_first_tick_callback(
    function()
        if cm:is_new_game() then
            rhox_mar_fooger_initalize_end_node_values()
            if cm:get_local_faction_name(true) == fooger_faction_key then --ui thing and should be local
                cm:set_script_state("caravan_camera_x", 1130);
                cm:set_script_state("caravan_camera_y", 394);
            end



            local all_factions = cm:model():world():faction_list();
            local faction = nil;
            for i = 0, all_factions:num_items() - 1 do
                faction = all_factions:item_at(i)
                if not faction:is_human() and faction:name() == fooger_faction_key then
                    cm:apply_effect_bundle("wh3_main_caravan_AI_threat_reduction", faction:name(), 0)
                end
            end
        end
        rhox_mar_fooger_start_listeners()
    end
);