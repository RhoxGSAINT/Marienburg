local mundvard_faction_key = "ovn_mar_the_wasteland"

local rhox_mar_mundvard_events_cooldown = {}
local rhox_mar_mundvard_event_max_cooldown = 15

local rhox_caravan_exception_list={
    ["hkrul_mar_caravan_master"] =true,
    ["hkrul_mar_caravan_master_horse"] =true,
    ["hkrul_crispijn"] =true,
    ["hkrul_guzunda"] =true,
    ["hkrul_lisette"] =true,
    ["hkrul_cross"] =true,
    ["hkrul_pg"] =true
}


local rhox_mar_mundvard_event_tables = {

    --Format is [key] == {probability function, event function}
    ["daemonsCargo"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local dilemma_name = "rhox_mar_mundvard_dilemma_portals_part_2";
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 0;
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key]["rhox_mar_mundvard_dilemma_portals_part_1"] > 0 and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] <= 0 then
            probability = 1
        end	

        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh3_main_kho_khorne_qb1"
        
        local eventname = "daemonsCargo".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("daemonsCargo action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_portals_part_2";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = caravans:generate_attackers(bandit_threat, "daemon_incursion_convoy");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to remove cargo
        function remove_cargo()
            cm:set_caravan_cargo(caravan_handle, cargo_amount-100)
        end
        
        custom_option = remove_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        payload_builder:text_display("dummy_convoy_portal_2_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();
        payload_builder:text_display("dummy_convoy_portal_2_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        out.design(rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name]);
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["cathayCargo"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_cathay_caravan";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0;
        end
        
        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end

        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh3_main_cth_cathay_qb1"
        
        local eventname = "cathayCargo".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("cathayCargo action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_cathay_caravan";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = caravans:generate_attackers(bandit_threat, "cathay_caravan_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_cathay_caravan_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_cathay_caravan_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["genericShortcut"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "genericShortcut".."?";
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_the_guide"
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("genericShortcut action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_the_guide"			
        
        function extra_move()
            --check if more than 1 move from the end
            cm:move_caravan(caravan_handle);
        end
        custom_option = extra_move;
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            custom_option);
        
        local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        local faction_key = caravan_handle:caravan_force():faction():name();

        local own_faction = caravan_handle:caravan_force():faction();

        payload_builder:text_display("dummy_convoy_guide_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:treasury_adjustment(math.floor(-500*((100+scout_skill)/100)));

        payload_builder:text_display("dummy_convoy_guide_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        dilemma_builder:add_target("default", caravan_handle:caravan_force());

        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
        
    end,
    false},

    ["daemonsPortal"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "daemonsPortal".."?";
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_portals_part_1"
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();	
        
        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0
        end

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("daemonsPortal action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_portals_part_1"	
        local faction_key = caravan_handle:caravan_force():faction():name();	
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode

        --Trigger dilemma to be handled by aboove function
        
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        custom_option = add_cargo;
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            custom_option);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();	

        payload_builder:text_display("dummy_convoy_portal_1_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        payload_builder:text_display("dummy_convoy_portal_1_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());

        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["daemonsRecruitment"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "daemonsRecruitment".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local dilemma_name = "rhox_mar_mundvard_dilemma_portals_part_3_a";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        local probability = 0;

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key]["rhox_mar_mundvard_dilemma_portals_part_2"] > 0 and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] <= 0 then
            probability = math.floor((20 - army_size)/2); 
        end	
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("daemonsRecruitment action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_portals_part_3_a";
        local faction_key = caravan_handle:caravan_force():faction():name();
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local infantry_list = {"wh3_main_kho_inf_bloodletters_1","wh3_main_nur_inf_plaguebearers_1","wh3_main_sla_inf_daemonette_1","wh3_main_tze_inf_pink_horrors_1"};
        local monster_list = {"wh3_main_kho_cav_bloodcrushers_0","wh3_main_nur_cav_plague_drones_1","wh3_main_sla_mon_fiends_of_slaanesh_0", "wh3_main_pro_tze_mon_screamers_0"};
        
        payload_builder:add_unit(caravan_handle:caravan_force(), monster_list[cm:random_number(#monster_list,1)], 1, 0);
        payload_builder:text_display("dummy_convoy_portal_3_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        payload_builder:add_unit(caravan_handle:caravan_force(), infantry_list[cm:random_number(#infantry_list,1)], 1, 0);
        payload_builder:text_display("dummy_convoy_portal_3_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["ogreRecruitment"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "ogreRecruitment".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local dilemma_name = "rhox_mar_mundvard_dilemma_ogre_mercenaries";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        local probability = math.floor((20 - army_size)/2);

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("ogreRecruitment action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_ogre_mercenaries";
        local faction_key = caravan_handle:caravan_force():faction():name();
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local ogre_list = {"wh3_main_ogr_inf_maneaters_0","wh3_main_ogr_inf_maneaters_1","wh3_main_ogr_inf_maneaters_2"};
        
        payload_builder:add_unit(caravan_handle:caravan_force(), ogre_list[cm:random_number(#ogre_list,1)], 1, 0);
        payload_builder:treasury_adjustment(-1000);
        payload_builder:text_display("dummy_convoy_ogres_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        payload_builder:text_display("dummy_convoy_ogres_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["skavenShortcut"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_rats_in_a_tunnel";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_skv_skaven_qb1"
        
        local eventname = "skavenShortcut".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("skavenShortcut action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_rats_in_a_tunnel";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = caravans:generate_attackers(bandit_threat, "skaven_shortcut_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        function extra_move()
            --check if more than 1 move from the end
            cm:move_caravan(caravan_handle);
        end
        custom_option = extra_move;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local own_faction = caravan_handle:caravan_force():faction();

        payload_builder:text_display("dummy_convoy_rats_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_rats_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["dwarfsConvoy"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_dwarfs";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0
        end

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh_main_dwf_dwarfs_qb1"
        
        local eventname = "dwarfsConvoy".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("dwarfsConvoy action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_dwarfs";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = caravans:generate_attackers(bandit_threat, "dwarf_convoy_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );

                                                
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();

        payload_builder:text_display("dummy_convoy_dwarfs_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        payload_builder:clear();
        payload_builder:text_display("dummy_convoy_cathay_caravan_second"); --it says cathay but it's just avoid battle so it's okay
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        
    
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["ogreAmbush"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_the_ambush";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end

        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh3_main_ogr_ogre_kingdoms_qb1"
        
        local eventname = "ogreAmbush".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("ogreAmbush action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_the_ambush";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = caravans:generate_attackers(bandit_threat, "ogre_bandit_high_b");
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );

        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();

        local own_faction = caravan_handle:caravan_force():faction();
        payload_builder:text_display("dummy_convoy_ambush_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());

        payload_builder:clear();
        payload_builder:text_display("dummy_convoy_ambush_second");										
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["hobgoblinTribute"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "hobgoblinTribute".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local dilemma_name = "rhox_mar_mundvard_dilemma_fresh_battlefield";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local probability = math.floor((20 - army_size)/2);

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("hobgoblinTribute action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_fresh_battlefield";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        --local hobgoblin_list = {"wh3_dlc23_chd_inf_hobgoblin_cutthroats","wh3_dlc23_chd_inf_hobgoblin_archers","wh3_dlc23_chd_inf_hobgoblin_sneaky_gits"};
        local raise_dead_list = {"wh_main_vmp_inf_grave_guard_0","wh_main_vmp_inf_grave_guard_1","wh_main_vmp_cav_black_knights_0"};
        
        payload_builder:add_unit(caravan_handle:caravan_force(), raise_dead_list[cm:random_number(#raise_dead_list,1)], 2, 0);
        payload_builder:text_display("dummy_convoy_hobgoblin_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
        replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
        replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 1);
        replenish:set_duration(2);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), replenish);
        payload_builder:text_display("dummy_convoy_hobgoblin_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["hungryDaemons"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local event_region = world_conditions["event_region"];
        local enemy_faction_name = "wh_main_chs_chaos_qb1";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local enemy_faction = cm:get_faction(enemy_faction_name);
        
        local random_unit ="NONE";
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
        
        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
            
            if rhox_caravan_exception_list[random_unit] then
                random_unit = "NONE";
            end
            out.design("Random unit to be eaten: "..random_unit);
        end;
        
        --Construct targets
        local eventname = "hungryDaemons".."?"
            ..event_region:name().."*"
            ..random_unit.."*"
            ..tostring(bandit_threat).."*"
            ..enemy_faction_name.."*";
            
        
        --Calculate probability
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_hungry_daemons";
        
        if random_unit == "NONE" then
            probability = 0;
        else
            probability = 1;
            
            if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
                probability = 0;
            end
        end

        

        local caravan_faction = world_conditions["faction"];
        if enemy_faction:name() == caravan_faction:name() then
            probability = 0;
        end;
        
        --probability = 10000
        
        return {probability,eventname}
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("hungryDaemons action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_hungry_daemons";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = true;
        local target_faction = decoded_args[4];
        local enemy_faction = decoded_args[4];
        local target_region = decoded_args[1];
        local custom_option = nil;
        
        local random_unit = decoded_args[2];
        local bandit_threat = tonumber(decoded_args[3]);
        local attacking_force = caravans:generate_attackers(bandit_threat,"hungry_chaos_army")
        
        
        --Eat unit to option 2
        function eat_unit_outcome()
            if random_unit ~= nil then
                local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
                cm:remove_unit_from_character(
                caravan_master_lookup,
                random_unit);

            else
                out("Script error - should have a unit to eat?")
            end
        end
        
        custom_option = nil; --eat_unit_outcome;
        
        --Battle to option 1, eat unit to 2
        local enemy_force_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                    dilemma_name,
                                                    caravan,
                                                    attacking_force,
                                                    false,
                                                    target_faction,
                                                    enemy_faction,
                                                    target_region,
                                                    custom_option
                                                    );
    
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        payload_builder:text_display("dummy_convoy_hungry_daemons_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        local target_faction_object =  cm:get_faction(target_faction);
        
        payload_builder:remove_unit(caravan:caravan_force(), random_unit);

        payload_builder:text_display("dummy_convoy_hungry_daemons_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        out.design("Triggering dilemma:"..dilemma_name)
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
        
        dilemma_builder:add_target("target_military_1", caravan:caravan_force());
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["trainingCamp"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "trainingCamp".."?";
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_training_camp";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions, caravan_handle)
        
        out.design("trainingCamp action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_training_camp";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();

        local experience = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_convoy_experience");
        experience:add_effect("wh2_main_effect_captives_unit_xp", "force_to_force_own", 2000);
        experience:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), experience);
        payload_builder:text_display("dummy_convoy_training_camp_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_training_camp_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["wayofLava"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "wayofLava".."?";
        
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_way_of_lava";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000

        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions, caravan_handle)
        
        out.design("wayofLava action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_way_of_lava";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();

        payload_builder:text_display("dummy_convoy_way_of_lava_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        local attrition = cm:create_new_custom_effect_bundle("rhox_mar_mundvard_dilemma_attrition");
        attrition:add_effect("wh_main_effect_campaign_enable_attrition", "force_to_force_own", 500);
        attrition:set_duration(3);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), attrition);

        payload_builder:text_display("dummy_convoy_way_of_lava_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["offenceorDefence"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "offenceorDefence".."?";
        
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_offence_or_defence";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions, caravan_handle)
        
        out.design("wayofLava action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_offence_or_defence";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            nil);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();

        local offence = cm:create_new_custom_effect_bundle("rhox_mar_mundvard_dilemma_offence");
        offence:add_effect("wh_main_effect_force_stat_melee_attack", "force_to_force_own", 10);
        offence:add_effect("wh_main_effect_force_stat_weapon_strength", "force_to_force_own", 20);
        offence:set_duration(5);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), offence);

        payload_builder:text_display("dummy_convoy_offence_defence_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        local defence = cm:create_new_custom_effect_bundle("rhox_mar_mundvard_dilemma_defence");
        defence:add_effect("wh_main_effect_force_stat_melee_defence", "force_to_force_own", 10);
        defence:add_effect("wh_main_effect_force_stat_armour", "force_to_force_own", 20);
        defence:set_duration(5);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), defence);

        payload_builder:text_display("dummy_convoy_offence_defence_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["localisedElfs"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_localised_elfs";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0;
        end

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_main_hef_high_elves_qb1"
        
        local eventname = "localisedElfs".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        
        --probability = 10000
        
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("localisedElfs action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_localised_elfs";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = caravans:generate_attackers(bandit_threat, "high_elf_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_localised_elfs_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_localised_elfs_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["readDeadify"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local event_region = world_conditions["event_region"];
        local enemy_faction_name = "wh_main_vmp_vampire_counts_qb1";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local enemy_faction = cm:get_faction(enemy_faction_name);
        
        local random_unit ="NONE";
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
        
        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
            
            if rhox_caravan_exception_list[random_unit] then
                random_unit = "NONE";
            end
            out.design("Random unit to be eaten: "..random_unit);
        end;
        
        --Construct targets
        local eventname = "readDeadify".."?"
            ..event_region:name().."*"
            ..random_unit.."*"
            ..tostring(bandit_threat).."*"
            ..enemy_faction_name.."*";
            
        
        --Calculate probability
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_redeadify";
        
        if random_unit == "NONE" then
            probability = 0;
        else
            probability = 1;
            if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
                probability = 0;
            end
        end
        local caravan_faction = world_conditions["faction"];
        if enemy_faction:name() == caravan_faction:name() then
            probability = 0;
        end;
        
        --probability = 10000
        
        return {probability,eventname}
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("hungryDaemons action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_redeadify";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = true;
        local target_faction = decoded_args[4];
        local enemy_faction = decoded_args[4];
        local target_region = decoded_args[1];
        local custom_option = nil;
        
        local random_unit = decoded_args[2];
        local bandit_threat = tonumber(decoded_args[3]);
        local attacking_force = caravans:generate_attackers(bandit_threat,"vampire_count_army")
        
        
        --Eat unit to option 2
        function eat_unit_outcome()
            if random_unit ~= nil then
                local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
                cm:remove_unit_from_character(
                caravan_master_lookup,
                random_unit);

            else
                out("Script error - should have a unit to eat?")
            end
        end
        
        custom_option = nil; --eat_unit_outcome;
        
        --Battle to option 1, eat unit to 2
        local enemy_force_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                    dilemma_name,
                                                    caravan,
                                                    attacking_force,
                                                    false,
                                                    target_faction,
                                                    enemy_faction,
                                                    target_region,
                                                    custom_option
                                                    );
    
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        payload_builder:text_display("dummy_convoy_redeadify_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        local target_faction_object =  cm:get_faction(target_faction);
        
        payload_builder:remove_unit(caravan:caravan_force(), random_unit);

        payload_builder:text_display("dummy_convoy_redeadify_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        out.design("Triggering dilemma:"..dilemma_name)
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
        
        dilemma_builder:add_target("target_military_1", caravan:caravan_force());
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},
    
    ["farfromHome"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local bandit_threat = world_conditions["bandit_threat"];
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_far_from_home";
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if world_conditions["caravan"]:cargo() >= 1000 then
            probability = 0;
        end

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        
        local event_region = world_conditions["event_region"];
        local enemy_faction = "wh2_dlc09_tmb_tombking_qb1"
        
        local eventname = "farfromHome".."?"
            ..event_region:name().."*"
            ..enemy_faction.."*"
            ..tostring(bandit_threat).."*";
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
    
        out.design("farfromHome action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_far_from_home";
        local caravan = caravan_handle;
        
        --Decode the string into arguments-- read_out_event_params explains encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3);
        
        local is_ambush = false;
        local target_faction = decoded_args[2]; --enemy faction name
        local enemy_faction = decoded_args[2];
        local target_region = decoded_args[1]; --event region name
        local custom_option = nil;
        
        local bandit_threat = tonumber(decoded_args[3]);
    
        local attacking_force = caravans:generate_attackers(bandit_threat, "tomb_kings_army");
        
        local cargo_amount = caravan_handle:cargo();
        
        --Dilemma option to add cargo
        function add_cargo()
            local cargo = caravan_handle:cargo();
            cm:set_caravan_cargo(caravan_handle, cargo+100)
        end
        
        custom_option = add_cargo;
        
        --Handles the custom options for the dilemmas, such as battles (only?)
        local enemy_cqi = rhox_mar_mundvard_attach_battle_to_dilemma(
                                                dilemma_name,
                                                caravan,
                                                attacking_force,
                                                is_ambush,
                                                target_faction,
                                                enemy_faction,
                                                target_region,
                                                custom_option
                                                );
        
        local target_faction_object = cm:get_faction(target_faction);
        
        --Trigger dilemma to be handled by above function
        local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
        local own_faction = caravan_handle:caravan_force():faction();
        
        payload_builder:text_display("dummy_convoy_far_from_home_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_far_from_home_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
        dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
    end,
    false},

    ["quickWayDown"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "quickWayDown".."?";
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_quick_way_down"
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();	

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("quickWayDown action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_quick_way_down"	
        local faction_key = caravan_handle:caravan_force():faction():name();		
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        local cargo_amount = caravan_handle:cargo();

        function remove_cargo()
            cm:set_caravan_cargo(caravan_handle, cargo_amount-50)
        end
        
        custom_option = remove_cargo;
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
            dilemma_name,
            caravan_handle,
            nil,
            false,
            nil,
            nil,
            nil,
            custom_option);
        
        local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local own_faction = caravan_handle:caravan_force():faction();

        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -50);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        payload_builder:text_display("dummy_convoy_quick_way_down_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_quick_way_down_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        dilemma_builder:add_target("default", caravan_handle:caravan_force());

        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
        
    end,
    false},

    ["tradingDarkElfs"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local eventname = "tradingDarkElfs".."?";
        local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        local probability = math.floor((20 - army_size)/2);
        local dilemma_name = "rhox_mar_mundvard_dilemma_trading_dark_elfs";

        if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
            probability = 0;
        end
        --probability = 10000
        return {probability,eventname}
        
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("tradingDarkElfs action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_trading_dark_elfs";
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        local cargo_amount = caravan_handle:cargo();

        function remove_cargo()
            cm:set_caravan_cargo(caravan_handle, cargo_amount-100)
        end
        
        custom_option = remove_cargo;

        rhox_mar_mundvard_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    custom_option);
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -100);
        cargo_bundle:set_duration(0);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

        local monster_list = {"wh2_dlc10_def_mon_kharibdyss_0","wh2_twa03_def_mon_war_mammoth_0","wh2_main_def_mon_black_dragon"};
        
        payload_builder:add_unit(caravan_handle:caravan_force(), monster_list[cm:random_number(#monster_list,1)], 1, 0);
        payload_builder:text_display("dummy_convoy_trading_dark_elfs_first");
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();
        
        payload_builder:text_display("dummy_convoy_trading_dark_elfs_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        
        out.design("Triggering dilemma:"..dilemma_name)
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},

    ["powerOverwhelming"] = 
    --returns its probability [1]
    {function(world_conditions)
        
        local random_unit ="NONE";
        local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
        local event_region = world_conditions["event_region"];
        local faction_key = world_conditions["caravan"]:caravan_force():faction():name();
        
        if caravan_force_unit_list:num_items() > 1 then
            random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
            
            if rhox_caravan_exception_list[random_unit] then
                random_unit = "NONE";
            end
            out.design("Random unit to be eaten: "..random_unit);
        end;
        
        --Construct targets
        local eventname = "powerOverwhelming".."?"
            ..event_region:name().."*"
            ..random_unit.."*";

        --Calculate probability
        local probability = 1;
        local dilemma_name = "rhox_mar_mundvard_dilemma_power_overwhelming";

        if random_unit == "NONE" then
            probability = 0;
        else
            probability = 1;
            if rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] ~= nil and rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] > 0 then
                probability = 0;
            end
        end;

        --probability = 10000
        return {probability,eventname}
    end,
    --enacts everything for the event: creates battle, fires dilemma etc. [2]
    function(event_conditions,caravan_handle)
        
        out.design("powerOverwhelming action called")
        local dilemma_name = "rhox_mar_mundvard_dilemma_power_overwhelming";
        local caravan = caravan_handle;
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        local decoded_args = caravans:read_out_event_params(event_conditions,3); --use vanilla
        
        local is_ambush = true;
        local target_faction = decoded_args[4];
        local target_region = decoded_args[1];
        local custom_option = nil;
        
        local random_unit = decoded_args[2];
        
        function eat_unit_outcome()
            if random_unit ~= nil then
                local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
                cm:remove_unit_from_character(
                caravan_master_lookup,
                random_unit);

            else
                out("Script error - should have a unit to eat?")
            end
        end
        
        local faction_key = caravan_handle:caravan_force():faction():name();
        
        --Decode the string into arguments-- Need to specify the argument encoding
        --none to decode
        
        rhox_mar_mundvard_attach_battle_to_dilemma(
                    dilemma_name,
                    caravan_handle,
                    nil,
                    false,
                    nil,
                    nil,
                    nil,
                    nil);

    
        --Trigger dilemma to be handled by above function
        
        local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
        local payload_builder = cm:create_payload();
        
        local power = cm:create_new_custom_effect_bundle("wh3_dlc23_dilemma_chd_power_overwhelming");
        power:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 5);
        power:add_effect("wh_main_effect_force_stat_speed", "force_to_force_own", 10);
        power:add_effect("wh_main_effect_force_stat_ap_damage", "force_to_force_own", 10);
        power:add_effect("wh_main_effect_force_stat_leadership_pct", "force_to_force_own", 15);
        power:add_effect("wh_main_effect_force_stat_ward_save", "force_to_force_own", 15);
        power:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 10);
        power:set_duration(10);
        
        payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), power);
        payload_builder:text_display("dummy_convoy_power_overwhelming_first");
        payload_builder:remove_unit(caravan:caravan_force(), random_unit);
        dilemma_builder:add_choice_payload("FIRST", payload_builder);
        payload_builder:clear();

        payload_builder:text_display("dummy_convoy_power_overwhelming_second");
        dilemma_builder:add_choice_payload("SECOND", payload_builder);
        
        out.design("Triggering dilemma:"..dilemma_name)
        
        dilemma_builder:add_target("default", caravan_handle:caravan_force());
        rhox_mar_mundvard_events_cooldown[faction_key][dilemma_name] = rhox_mar_mundvard_event_max_cooldown;
        cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
        
    end,
    false},
    
};




















--------------------------------------------------------------------------------------------------
--Functions

function rhox_mar_mundvard_event_handler(context)
	
	--package up some world state
	--generate an event
	--out("Rhox Mundvard: In here")
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
		event_region = list_of_regions:item_at(cm:random_number(num_regions-1,0)):region();
	else
		out.design("*** No Regions in an Ivory Road segment - Need to fix data in DaVE: campaign_map_route_segments ***")
		out.design("*** Rest of this script will fail ***")
	end;
	
	local bandit_list_of_regions = {};
	
	--override region if one is at war
	for i = 0,num_regions-1 do
		table.insert(bandit_list_of_regions,list_of_regions:item_at(i):region():name())
		
		if list_of_regions:item_at(i):region():owning_faction():at_war_with(context:faction()) then
			event_region=list_of_regions:item_at(i):region()
		end;
	end
	
	
	local bandit_threat = math.floor( cm:model():world():caravans_system():total_banditry_for_regions_by_key(bandit_list_of_regions) / num_regions);	
	local conditions = {
		["caravan"]=context:caravan(),
		["caravan_master"]=caravan_master,
		["list_of_regions"]=list_of_regions,
		["event_region"]=event_region,
		["bandit_threat"]=bandit_threat,
		["faction"]=faction
		};
	
	local contextual_event, is_battle = rhox_mar_mundvard_generate_event(conditions);
	
	out("Rhox Mundvard: Chosen event is: ".. tostring(contextual_event))
	--if battle then waylay
	
	if is_battle == true and contextual_event ~= nil then
		context:flag_for_waylay(contextual_event);
	elseif is_battle == false and contextual_event ~= nil then
		context:flag_for_waylay(contextual_event);
		--needs to survive a save load at this point
	end;
	
end

function rhox_mar_mundvard_generate_event(conditions)

	--look throught the events table and create a table for weighted roll
	--pick one and return the event name
	
	local weighted_random_list = {};
	local total_probability = 0;
	local i = 0;

	local events = rhox_mar_mundvard_event_tables
	
	--build table for weighted roll
	for key, val in pairs(events) do
		
		i = i + 1;
		
		--Returns the probability of the event 
		local args = val[1](conditions)
		local prob = args[1];
		out("Rhox Mundvard: Event name is ".. args[2] .. "and probability is ".. args[1])
		total_probability = prob + total_probability;
		--Returns the name and target of the event
		local name_args = args[2];
		
		--Returns if a battle is possible from this event
		--i.e. does it need to waylay
		local is_battle = val[3];
		
		weighted_random_list[i] = {total_probability,name_args,is_battle}

	end
	
	--check all the probabilites until matched
	local no_event_chance = 25;
	local random_int = cm:random_number(total_probability + no_event_chance,1);
	local is_battle = nil;
	local contextual_event_name = nil;

	for j=1,i do
		if weighted_random_list[j][1] >= random_int then
            contextual_event_name = weighted_random_list[j][2];
			is_battle = weighted_random_list[j][3];
			break;
		end
	end
	
	return contextual_event_name, is_battle
end;


function rhox_mar_mundvard_waylaid_caravan_handler(context)
	
	local event_name_formatted = context:context();
	local caravan_handle = context:caravan();
	
	local event_key = caravans:read_out_event_key(event_name_formatted); --use vanilla
	out("Rhox Mundvard: rhox_mar_mundvard_waylaid_caravan_handler Going to call event: ".. event_key)
	local events = rhox_mar_mundvard_event_tables
	--call the action side of the event
	events[event_key][2](event_name_formatted,caravan_handle);
	
end





function rhox_mar_mundvard_attach_battle_to_dilemma(
			dilemma_name,
			caravan,
			attacking_force,
			is_ambush,
			target_faction,
			enemy_faction,
			target_region,
			custom_option)
	
	--Create the enemy force
	local enemy_force_cqi = nil;
	local x = nil;
	local y = nil;
	
	if attacking_force ~= nil then
		enemy_force_cqi, x, y = caravans:spawn_caravan_battle_force(caravan, attacking_force, target_region, is_ambush, false, enemy_faction) --we don't need new function for these
	end
	
	function ivory_road_dilemma_choice(context)
		local dilemma = context:dilemma();
		local choice = context:choice();
		local faction = context:faction();
		local faction_key = faction:name();
		
		if dilemma == dilemma_name then
			--if battle option is chosen
			core:remove_listener("rhox_mar_mundvard_cth_DilemmaChoiceMadeEvent_"..faction_key);
			
			if choice == 3 then
				return;
			end

			local choice_zero_dilemmas = 
				{
					rhox_mar_mundvard_dilemma_cathay_caravan = true,
					rhox_mar_mundvard_dilemma_rats_in_a_tunnel = true,
					rhox_mar_mundvard_dilemma_dwarfs = true,
					rhox_mar_mundvard_dilemma_localised_elfs = true,
					rhox_mar_mundvard_dilemma_far_from_home = true
				};
			local choice_one_dilemmas = 
				{
					rhox_mar_mundvard_dilemma_cathay_caravan = true,
					rhox_mar_mundvard_dilemma_rats_in_a_tunnel = true,
					rhox_mar_mundvard_dilemma_portals_part_1 = true,
					rhox_mar_mundvard_dilemma_the_ambush = true,
					rhox_mar_mundvard_dilemma_dwarfs = true,
					rhox_mar_mundvard_dilemma_localised_elfs = true,
					rhox_mar_mundvard_dilemma_far_from_home = true,
					rhox_mar_mundvard_dilemma_quick_way_down = true,
					rhox_mar_mundvard_dilemma_trading_dark_elfs = true
				};	

			local not_move_dilemmas = 
				{
					rhox_mar_mundvard_dilemma_training_camp = true,
					rhox_mar_mundvard_dilemma_portals_part_1 = true,
					rhox_mar_mundvard_dilemma_way_of_lava = true,
					rhox_mar_mundvard_dilemma_quick_way_down = true
				};	

			local move_dilemma_one =
				{
					rhox_mar_mundvard_dilemma_the_ambush = true
				};

			local cargo_dilemmas =
				{
					rhox_mar_mundvard_dilemma_portals_part_1 = true,
					rhox_mar_mundvard_dilemma_trading_dark_elfs = true
				}

			if choice == 0 and attacking_force ~= nil and not choice_zero_dilemmas[dilemma_name] then
				caravans:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush); --we don't need new functions for these
			elseif attacking_force ~= nil and (choice == 0 and choice_zero_dilemmas[dilemma_name]) then
				caravans:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush);
				custom_option();
			end	
			if (choice ~= 0 and not move_dilemma_one[dilemma_name]) or (choice == 0 and attacking_force == nil and not not_move_dilemmas[dilemma_name]) then
				cm:move_caravan(caravan);
			end	
			
			if (choice == 0 and attacking_force == nil and cargo_dilemmas[dilemma_name]) or (custom_option ~= nil and choice == 1 and not choice_one_dilemmas[dilemma_name]) then
				custom_option();
			end
			
			if choice == 0 and attacking_force == nil and dilemma_name == "rhox_mar_mundvard_dilemma_quick_way_down" then
				cm:move_caravan(caravan);
				cm:move_caravan(caravan);
				custom_option();
			end
		end
	end
	
	local faction_key = caravan:caravan_master():character():faction():name()

	core:add_listener(
		"rhox_mar_mundvard_cth_DilemmaChoiceMadeEvent_"..faction_key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			ivory_road_dilemma_choice(context) 
		end,
		true
	);
	
	return enemy_force_cqi
end;

function rhox_mar_mundvard_adjust_end_node_values_for_demand()

	local temp_end_nodes = rhox_mar_mundvard_safe_get_saved_value_ivory_road_demand()
	
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val.." for passive demand increase.")
		rhox_mar_mundvard_adjust_end_node_value(key, 2, "add")
	end

end



function rhox_mar_mundvard_initalize_end_node_values()

	--randomise the end node values
	local end_nodes = {
        ["wh3_main_combi_region_bay_of_blades"]				=75-cm:random_number(50,0),
        ["wh3_main_combi_region_troll_fjord"]				=75-cm:random_number(50,0),
        ["wh3_main_combi_region_sjoktraken"]				=75-cm:random_number(50,0),
        ["wh3_main_combi_region_karond_kar"]				=75-cm:random_number(50,0),
        ["wh3_main_combi_region_fortress_of_the_damned"]	=75-cm:random_number(50,0),
        ["wh3_main_combi_region_port_reaver"]				=cm:random_number(150,60),
        ["wh3_main_combi_region_sartosa"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_arnheim"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_sorcerers_islands"]			=cm:random_number(150,60)
        
    };
 
	
	--save them
	cm:set_saved_value("rhox_mar_mundvard_slave_demand", end_nodes);
	local temp_end_nodes = rhox_mar_mundvard_safe_get_saved_value_ivory_road_demand() 
	
	--apply the effect bundles
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val)
		rhox_mar_mundvard_adjust_end_node_value(key, val, "replace")--TODO
	end
end

function rhox_mar_mundvard_safe_get_saved_value_ivory_road_demand()
	
	return cm:get_saved_value("rhox_mar_mundvard_slave_demand");

end		




function rhox_mar_mundvard_adjust_end_node_value(region_name, value, operation, apply_variance)
	
	local region = cm:get_region(region_name);
	if not region then
		script_error("Could not find region " ..region_name.. " for caravan script")
		return false
	end
	local cargo_value_bundle = cm:create_new_custom_effect_bundle("wh3_main_ivory_road_end_node_value");
	cargo_value_bundle:set_duration(0);


	
	if operation == "replace" then
		local temp_end_nodes = rhox_mar_mundvard_safe_get_saved_value_ivory_road_demand()
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);
		
		temp_end_nodes[region_name]=value;
		cm:set_saved_value("rhox_mar_mundvard_slave_demand", temp_end_nodes);
		
	elseif operation == "add" then
		local temp_end_nodes = rhox_mar_mundvard_safe_get_saved_value_ivory_road_demand()
		local old_value = temp_end_nodes;

		if old_value == nil then
			out.design("*******   Error in ivory road script    *********")
			return 0;
		end
		
		old_value = old_value[region_name]

		local new_value = math.min(old_value+value,200)
		new_value = math.max(old_value+value,-60)
		
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", new_value);
		
		temp_end_nodes[region_name]=new_value;
		cm:set_saved_value("rhox_mar_mundvard_slave_demand", temp_end_nodes);
	--elseif operation == "duration" then --not doing duration
	end
	
	if region:has_effect_bundle("wh3_main_ivory_road_end_node_value") then
		cm:remove_effect_bundle_from_region("wh3_main_ivory_road_end_node_value", region_name);
	end;
	
	cm:apply_custom_effect_bundle_to_region(cargo_value_bundle, region);
end

------------------------------listeners

core:add_listener(
    "rhox_mar_mundvard_caravan_finished",
    "CaravanCompleted",
    function(context)
        return context:faction():name() == mundvard_faction_key
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
            --rhox_mar_mundvard_reward_item_check(faction, region_name, context:caravan_master()) --we don't have any. Why check them?
            if faction:has_effect_bundle("rhox_mar_bundle_pirate_cove_created") == false and faction:faction_leader():has_military_force() then --mundvard need to have military force in order to spawn the character
                local x,y = cm:find_valid_spawn_location_for_character_from_character(faction:name(), cm:char_lookup_str(faction:faction_leader()), true, 5)
                cm:spawn_agent_at_position(faction, x, y, "dignitary","rhox_mar_mundvard_criminal")
                local agent = cm:get_most_recently_created_character_of_type(faction:name(), "dignitary", "rhox_mar_mundvard_criminal")
                if agent then
                    local incident_builder = cm:create_incident_builder("rhox_mar_mundvard_criminal_recruited")
                    incident_builder:add_target(agent)
                    local payload_builder = cm:create_payload()
                    payload_builder:text_display("rhox_mar_mundvard_criminal_recruited")
                    incident_builder:set_payload(payload_builder)
                    cm:launch_custom_incident_from_builder(incident_builder, faction)
                    cm:replenish_action_points(cm:char_lookup_str(agent))
                end
            end
        end
        --faction has tech that grants extra trade tariffs bonus after every caravan - create scripted bundle
            
        if not region_owner:is_null_interface() then
            local region_owner_key = region_owner:name()
            cm:cai_insert_caravan_diplomatic_event(region_owner_key,faction_key)

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
        local value = math.floor(-cargo/18)
        cm:callback(function()rhox_mar_mundvard_adjust_end_node_value(region_name, value, "add") end, 5);
                    
    end,
    true
);



core:add_listener(
    "rhox_mar_mundvard_caravan_waylay_query",
    "QueryShouldWaylayCaravan",
    function(context)
        return context:faction():is_human() and context:faction():name() == mundvard_faction_key
    end,
    function(context)
        out("Rhox Mundvard: In the QueryShouldWaylayCaravan listener")
        local faction_key = context:faction():name()
        if rhox_mar_mundvard_event_handler(context) == false then
            out.design("Caravan not valid for event");
        end
    end,
    true
);


core:add_listener(
    "rhox_mar_mundvard_caravan_waylaid",
    "CaravanWaylaid",
    function(context)
        return context:faction():name() == mundvard_faction_key
    end,
    function(context)
        rhox_mar_mundvard_waylaid_caravan_handler(context);
    end,
    true
);


local innate_1 = {
	"wh_main_vmp_inf_grave_guard_0",
	"wh_main_vmp_inf_grave_guard_0",
	"wh_main_vmp_inf_grave_guard_0",
	"wh_main_vmp_inf_grave_guard_0",
	"wh_main_vmp_cav_black_knights_0",
	"wh_main_vmp_cav_black_knights_0",
	"wh_main_vmp_cav_black_knights_0",
	"wh_main_vmp_cav_black_knights_0"
	};
	
local innate_2 = {
	"wh_main_vmp_inf_skeleton_warriors_1",
	"wh_main_vmp_inf_skeleton_warriors_1",
	"wh_main_vmp_inf_skeleton_warriors_1",
	"wh_main_vmp_inf_skeleton_warriors_1",
	"wh_dlc04_vmp_veh_mortis_engine_0",
	"wh_main_vmp_mon_vargheists",
	"wh_main_vmp_mon_vargheists",
	"wh_main_vmp_mon_varghulf"
	};


function rhox_mar_mundvard_add_inital_force(caravan)
	
	out.design("Try to add inital force to caravan, based on trait")
	
	local force_cqi = caravan:caravan_force():command_queue_index();
	local lord_cqi = caravan:caravan_force():general_character():command_queue_index();
	local lord_str = cm:char_lookup_str(lord_cqi);
	
	if caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_slaver_innate_1") then
		for i=1, #innate_1 do
			cm:grant_unit_to_character(lord_str, innate_1[i]);
		end
		--fully heal when returning
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_slaver_innate_2") then
		for i=1, #innate_2 do
			cm:grant_unit_to_character(lord_str, innate_2[i]);
		end
	else
        for i=1, #innate_1 do
			cm:grant_unit_to_character(lord_str, innate_1[i]);
		end
		out("*** Unknown Caravan Master ??? ***")
	end
end


core:add_listener(
	"rhox_mar_mundvard_add_inital_force",
	"CaravanRecruited",
	function(context)
		return context:faction():name() == mundvard_faction_key
	end,
	function(context)
		out.design("*** Caravan recruited ***");
		if context:caravan():caravan_force():unit_list():num_items() < 2 then
			local caravan = context:caravan();
			rhox_mar_mundvard_add_inital_force(caravan); 
			cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
		end;
	end,
	true
);

core:add_listener(
	"rhox_mar_mundvard_add_inital_bundles",
	"CaravanSpawned",
	function(context)
		return context:faction():name() == mundvard_faction_key
	end,
	function(context)
		out.design("*** Caravan deployed ***");
		local caravan = context:caravan();
		hkrul_mar_add_effectbundle(caravan);--reuse this one
		cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
		cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
	end,
	true
);

core:add_listener(
    "rhox_mar_mudvard_new_contracts_update",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        return faction:is_human() and faction:name() == mundvard_faction_key
    end,
    function(context)
        local turn = cm:model():turn_number();
        local faction_key = context:faction():name()
        if turn == 5 then
            --cm:trigger_incident(faction_key, "rhox_mar_convoy_unlocked", true);
            --[[
        elseif (turn % 10 == 0) then
            --cm:trigger_incident(faction_key, "wh3_dlc23_chd_convoy_new_contracts", true); --it's done by DB, not doing this becuase we only got one type of contract
            --]]
        end
    end,
    true
);

core:add_listener(
    "rhox_mar_mundvard_caravans_increase_demand",
    "WorldStartRound",
    true,
    function(context)
        rhox_mar_mundvard_adjust_end_node_values_for_demand();
    end,
    true
);

core:add_listener(
	"rhox_mar_mundvard_caravan_master_heal",
	"CaravanMoved",
	function(context)
		return context:faction():name() == mundvard_faction_key
	end,
	function(context)
		--Heal Lord
		local caravan_force_list = context:caravan_master():character():military_force():unit_list();
		local unit = nil;
		for i=0, caravan_force_list:num_items()-1 do
			unit = caravan_force_list:item_at(i);
			if rhox_caravan_exception_list[unit:unit_key()] then --caravan master or LH
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






-- Logic --
--Setup
cm:add_first_tick_callback_new(
	function()
		rhox_mar_mundvard_initalize_end_node_values()
		if cm:get_local_faction_name(true) == mundvard_faction_key then --ui thing and should be local
            cm:set_script_state("caravan_camera_x",451);
            cm:set_script_state("caravan_camera_y",657);
        end
        
        if cm:get_faction(mundvard_faction_key):is_human() then
            rhox_mar_mundvard_events_cooldown[mundvard_faction_key] = {
                ["rhox_mar_mundvard_dilemma_cathay_caravan"] = 0,
                ["rhox_mar_mundvard_dilemma_dwarfs"] = 0,
                ["rhox_mar_mundvard_dilemma_far_from_home"] = 0,
                ["rhox_mar_mundvard_dilemma_fresh_battlefield"] = 0,
                ["rhox_mar_mundvard_dilemma_hungry_daemons"] = 0,
                ["rhox_mar_mundvard_dilemma_localised_elfs"] = 0,
                ["rhox_mar_mundvard_dilemma_offence_or_defence"] = 0,
                ["rhox_mar_mundvard_dilemma_ogre_mercenaries"] = 0,
                ["rhox_mar_mundvard_dilemma_portals_part_1"] = 0,
                ["rhox_mar_mundvard_dilemma_portals_part_2"] = 0,
                ["rhox_mar_mundvard_dilemma_portals_part_3_a"] = 0,
                ["rhox_mar_mundvard_dilemma_power_overwhelming"] = 0,
                ["rhox_mar_mundvard_dilemma_quick_way_down"] = 0,
                ["rhox_mar_mundvard_dilemma_rats_in_a_tunnel"] = 0,
                ["rhox_mar_mundvard_dilemma_redeadify"] = 0,
                ["rhox_mar_mundvard_dilemma_the_ambush"] = 0,
                ["rhox_mar_mundvard_dilemma_the_guide"] = 0,
                ["rhox_mar_mundvard_dilemma_trading_dark_elfs"] = 0,
                ["rhox_mar_mundvard_dilemma_training_camp"] = 0,
                ["rhox_mar_mundvard_dilemma_way_of_lava"] = 0
            }
		end
		

		local all_factions = cm:model():world():faction_list();
		local faction = nil;
		for i=0, all_factions:num_items()-1 do
			faction = all_factions:item_at(i)
			if not faction:is_human() and faction:name() == mundvard_faction_key then
				cm:apply_effect_bundle("wh3_main_caravan_AI_threat_reduction", faction:name(),0)
			end
		end
	end
);





--panel ui thing
cm:add_first_tick_callback(
	function ()
        ------rhox-----------------
        if cm:get_local_faction_name(true)== mundvard_faction_key then --ui thing and should be local
            
            core:add_listener(--this is where changing all the localization, resource for mundvard happens
                "rhox_mar_mundvard_convoy_open_listener",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "military_convoys";
                end,
                function()
                    out("Rhox Mar: Opened military convoy panel")
                    local resource_holder = find_uicomponent(core:get_ui_root(), "military_convoys", "left_panel", "content_list", "header_container", "resource_list");
                    if not resource_holder then
                        out("Rhox Mar: There was no resource holder, bye")
                        return
                    end
                    local dread_ui = find_uicomponent(resource_holder, "dy_dread");
                    if not dread_ui then
                        out("Rhox Mar: There was no dread ui, bye")
                        return
                    end
                    dread_ui:SetVisible(false)
                    
                    local result = core:get_or_create_component("rhox_mundvard_slave_holder", "ui/campaign ui/rhox_mar_munvard_slavery_holder.twui.xml", resource_holder)
                    if not result then
                        script_error("Rhox Mar: ".. "ERROR: could not create mundvard ui slave component? How can this be?");
                        return false;
                    end;
                    --local dread_icon = find_uicomponent(dread_ui, "dread_icon");
                    --dread_icon:SetImagePath("ui/skins/default/icon_slaves.png")
                end,
                true
            )

        end


	end
);
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_mar_mundvard_events_cooldown", rhox_mar_mundvard_events_cooldown, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			rhox_mar_mundvard_events_cooldown = cm:load_named_value("rhox_mar_mundvard_events_cooldown", rhox_mar_mundvard_events_cooldown, context);
		end;
	end
);