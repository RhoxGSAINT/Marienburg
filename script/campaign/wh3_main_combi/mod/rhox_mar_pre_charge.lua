local function remove_power_of_money_effect_bundles(cqi)
	local effect_bundle = "ovn_bundle_pre_battle_purchase_the_power_of_money_"
	for i = 0, 5 do
		cm:remove_effect_bundle_from_characters_force(effect_bundle .. tostring(i), cqi)
	end
end





local function rhox_setup_power_of_money(faction)
    local local_faction = faction
    local purchasable_holder_ui = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel", "army", "units_and_banners_parent", "purchasable_effects");
    if is_uicomponent(purchasable_holder_ui) then
        purchasable_holder_ui:SetVisible(true) -- there was a quick battle
        --refund the price if the player has spent any
        local pb = cm:model():pending_battle()
        local attacker = pb:attacker()
        local defender = pb:defender()
        
        local character_cqi
        if (local_faction:name() == attacker:faction():name()) then
            character_cqi = attacker:cqi()
        end
        if (local_faction:name() == defender:faction():name()) then
            character_cqi = defender:cqi()
        end
        
        local military_force = cm:get_character_by_cqi(character_cqi):military_force()
        for i=1,5 do
            if military_force:has_effect_bundle("ovn_bundle_pre_battle_purchase_the_power_of_money_"..tostring(i)) then
                out("Rhox mar: It had effect bundle before the quick save.")
                cm:remove_effect_bundle_from_force("ovn_bundle_pre_battle_purchase_the_power_of_money_"..tostring(i), military_force:command_queue_index())
                cm:treasury_mod(local_faction:name(), 5000*i)
            end
        end
        
    else
        out("Rhox mar: There was no quick battle")
        return; --no quick battle thing let's return
    end
    local ability_charge_panel = find_uicomponent(purchasable_holder_ui, "ability_charge_panel");
    if is_uicomponent(ability_charge_panel) then
        ability_charge_panel:SetVisible(true) --we're going to change it from menace below to power of money
    end
    local ogre_charge_panel = find_uicomponent(purchasable_holder_ui, "ogre_charge");
    if is_uicomponent(ogre_charge_panel) then
        ogre_charge_panel:SetVisible(false) --we don't need this
    end
    
    --Change title
    local tx_header = find_uicomponent(ability_charge_panel, "tx_header")
    if is_uicomponent(tx_header) then
        tx_header:SetText(common.get_localised_string("effect_bundles_localised_title_ovn_bundle_pre_battle_purchase_the_power_of_money_0"))
    end
    
    
	--Change icon
	local ability_icon = find_uicomponent(ability_charge_panel, "ability_holder", "charges_holder", "ability_frame", "ability_icon")
	if is_uicomponent(ability_icon) then
		ability_icon:SetImagePath("ui/battle ui/ability_icons/hkrul_mar_power_money.png")
	end
	
	--Starting state = 0 charges
	local charges = 0
	
	local dy_charges = find_uicomponent(ability_charge_panel, "ability_holder", "charges_holder", "dy_charges")
	if is_uicomponent(dy_charges) then
		dy_charges:SetText("x 0")
	end
	
	--Starting state, button disabled and tooltip
	local button_remove_charges = find_uicomponent(ability_charge_panel, "ability_holder", "charges_holder", "dy_charges", "button_remove_charges")
	if is_uicomponent(button_remove_charges) then
		button_remove_charges:SetState("inactive")
		button_remove_charges:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_money_cant_decrease_tooltip"), true)
	end
	
	--Starting state, tooltip
	local button_add_charges = find_uicomponent(ability_charge_panel, "ability_holder", "charges_holder", "dy_charges", "button_add_charges")
	if is_uicomponent(button_add_charges) then
		button_add_charges:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_money_increase_tooltip"), true)
		if local_faction:treasury() < 5000 then --you have no money, set it to inactive
            button_add_charges:SetState("inactive")
            button_add_charges:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_money_lack_money_increase_tooltip"), true)
		end
	end
	
	
	--Remove the help button, which leads to menace below's help
	local button_info = find_uicomponent(ability_charge_panel, "button_info")
	if is_uicomponent(button_info) then
		button_info:SetVisible(false)
	end
	
	core:add_listener(
		"ovn_mar_add_charges_ComponentLClickUp",
		"ComponentLClickUp", 
		function(context)
			local local_faction = cm:get_faction("wh_main_emp_marienburg")
			return context.string == "button_add_charges" and charges < 5 and local_faction:treasury() >= 5000
		end,
		function(context)
			--effect bundle
			local pb = cm:model():pending_battle()
			local attacker = pb:attacker()
			local defender = pb:defender()
	
			local local_faction = cm:get_faction("wh_main_emp_marienburg")
			
			local character_cqi
			if (local_faction:name() == attacker:faction():name()) then
				character_cqi = attacker:cqi()
			end
			if (local_faction:name() == defender:faction():name()) then
				character_cqi = defender:cqi()
			end
			
			charges = charges + 1
			if is_uicomponent(dy_charges) then
				dy_charges:SetText("x " .. tostring(charges))
			end
			if is_uicomponent(button_remove_charges) then
				button_remove_charges:SetState("active")
				button_remove_charges:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_money_decrease_tooltip"), true)
			end
			if is_uicomponent(button_add_charges) then
				if charges == 5 then
					button_add_charges:SetState("inactive")
					button_add_charges:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_money_cant_increase_tooltip"), true)
				elseif local_faction:treasury() < 10000 then
					button_add_charges:SetState("inactive")
					button_add_charges:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_money_lack_money_increase_tooltip"), true)
				end
			end
	
			local effect_bundle = "ovn_bundle_pre_battle_purchase_the_power_of_money_" .. tostring(charges)
			CampaignUI.TriggerCampaignScriptEvent(character_cqi, "ovn_mar_add_charges|" .. effect_bundle)
		end,
		true
	)
	core:add_listener(
		"ovn_mar_remove_charges_ComponentLClickUp",
		"ComponentLClickUp", 
		function(context)
			return context.string == "button_remove_charges" and charges > 0
		end,
		function(context)
			--effect bundle
			local pb = cm:model():pending_battle()
			local attacker = pb:attacker()
			local defender = pb:defender()

			local local_faction = cm:get_faction("wh_main_emp_marienburg")
			
			local character_cqi
			if (local_faction:name() == attacker:faction():name()) then
				character_cqi = attacker:cqi()
			end
			if (local_faction:name() == defender:faction():name()) then
				character_cqi = defender:cqi()
			end

			charges = charges - 1
	
			if is_uicomponent(dy_charges) then
				dy_charges:SetText("x " .. tostring(charges))
			end
			if is_uicomponent(button_add_charges) then
				button_add_charges:SetState("active")
				button_add_charges:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_money_increase_tooltip"), true)
			end
			if is_uicomponent(button_remove_charges) and charges == 0 then
				button_remove_charges:SetState("inactive")
				button_remove_charges:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_money_cant_decrease_tooltip"), true)
			end
			
			local effect_bundle = "ovn_bundle_pre_battle_purchase_the_power_of_money_" .. tostring(charges)
			CampaignUI.TriggerCampaignScriptEvent(character_cqi, "ovn_mar_remove_charges|" .. effect_bundle)
		end,
		true
	)
end




cm:add_first_tick_callback(
    function()
        local power_of_money_activated = cm:get_faction("wh_main_emp_marienburg"):bonus_values():scripted_value("rhox_mar_enable_power_of_money", "value")
        cm:callback(
			function()
				if power_of_money_activated > 0 then
                    rhox_setup_power_of_money(cm:get_faction("wh_main_emp_marienburg")) --for quick save
                end
			end,
			0.5
		)
        
        
        --out("Rhox mar: First tick check")
        --out("Rhox mar: Power of mooney value: "..power_of_money_activated)
        if cm:get_local_faction_name(true) == "wh_main_emp_marienburg" then
            core:add_listener(
                "rhox_mar_popup_pre_battle", --to remove menace below opener
                "PanelOpenedCampaign",
                function(context)
                    local power_of_money_activated = cm:get_faction("wh_main_emp_marienburg"):bonus_values():scripted_value("rhox_mar_enable_power_of_money", "value")
                    return context.string == "popup_pre_battle" and power_of_money_activated > 0;
                end,
                function()
                    CampaignUI.TriggerCampaignScriptEvent(cm:get_local_faction(true):command_queue_index(), "rhox_mar_trigger_power_of_money_setup") --we're not going to use faction cqi, but let's just put it there
                end,
                true
            )
         end
         
         if cm:get_faction("wh_main_emp_marienburg"):is_human() then
            core:add_listener(
                "rhox_mar_panel_opened_UITrigger",
                "UITrigger",
                function(context)
                    return context:trigger():starts_with("rhox_mar_trigger_power_of_money_setup")
                end,
                function(context)
                    rhox_setup_power_of_money(cm:get_faction("wh_main_emp_marienburg"))
                end,
                true
            )
         
         
         
            -- Applies an effect bundle to character, removes 5000 from character's faction's treasury
            core:add_listener(
                "ovn_mar_add_charges_UITrigger",
                "UITrigger",
                function(context)
                    return context:trigger():starts_with("ovn_mar_add_charges|")
                end,
                function(context)
                    local str = context:trigger()
                    local character_cqi = context:faction_cqi() --it says faction but what we passed is character
                    local effect_bundle = string.gsub(str, "ovn_mar_add_charges|", "")
                        
                        
                    out("Rhox mar: inccrease button, effect bundle is: "..effect_bundle)
                    -- update effect bundle
                    --out("Rhox mar CQI recieved: "..character_cqi)
                    remove_power_of_money_effect_bundles(character_cqi)
                    cm:apply_effect_bundle_to_characters_force(effect_bundle, character_cqi, 1)

                    -- charge 5000 dollarydoos
                    local character = cm:get_character_by_cqi(character_cqi)
                    local faction_name = character:faction():name()
                    cm:treasury_mod(faction_name, -5000)
                end,
                true
            )
            
            -- Applies an effect bundle to character, adds 5000 to character's faction's treasury
            core:add_listener(
                "ovn_mar_remove_charges_UITrigger",
                "UITrigger",
                function(context)
                    return context:trigger():starts_with("ovn_mar_remove_charges|")
                end,
                function(context)
                    local str = context:trigger()
                    local character_cqi = context:faction_cqi() --it says faction but what we passed is character
                    local effect_bundle = string.gsub(str, "ovn_mar_remove_charges|", "")

                    out("Rhox mar: decrease button, effect bundle is: "..effect_bundle)
                    -- update effect bundle
                    remove_power_of_money_effect_bundles(character_cqi)
                    cm:apply_effect_bundle_to_characters_force(effect_bundle, character_cqi, 1)

                    -- refund 5000 dollarydoos
                    local character = cm:get_character_by_cqi(character_cqi)
                    local faction_name = character:faction():name()
                    cm:treasury_mod(faction_name, 5000)
                end,
                true
            )
            
            -- Removes the effect bundles (if present) from armies involved in the battle
            -- I think this is fine as-is, with no local_faction/UITrigger trickery needed
            core:add_listener(
                "ovn_mar_burgemeister_cleanup",
                "BattleCompleted",
                function()
                    local pb = cm:model():pending_battle()
                    
                    if pb:has_been_fought() then
                        local attacker_cqi, attacker_force_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
                        local defender_cqi, defender_force_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1)
                        local attacker = cm:get_faction(attacker_faction_name)
                        local defender = cm:get_faction(defender_faction_name)
                        
                        return (attacker and attacker:name() == "wh_main_emp_marienburg") or (defender and defender:name() == "wh_main_emp_marienburg")
                    else
                        return (pb:has_attacker() and pb:attacker():faction():name() == "wh_main_emp_marienburg") or (pb:has_defender() and pb:defender():faction():name() == "wh_main_emp_marienburg")
                    end
                end,
                function()
                    local pb = cm:model():pending_battle()
                    -- refund any spent money if you retreated instead of fought the battle
                    if not pb:has_been_fought() then
                        --out("Rhox mar: They didn't fought")
                        local military_force
                        local faction_name
                        if pb:has_attacker() and pb:attacker():faction():name() == "wh_main_emp_marienburg" then
                            --out("Rhox mar: Was attacker")
                            military_force = pb:attacker():military_force()
                            faction_name = pb:attacker():faction():name()
                        end
                        
                        if pb:has_defender() and pb:defender():faction():name() == "wh_main_emp_marienburg" then
                            --out("Rhox mar: Was defender")
                            military_force = pb:defender():military_force()
                            faction_name = pb:defender():faction():name()
                        end
                        if military_force:has_effect_bundle("ovn_bundle_pre_battle_purchase_the_power_of_money_1") then
                            cm:treasury_mod(faction_name, 5000)
                        elseif military_force:has_effect_bundle("ovn_bundle_pre_battle_purchase_the_power_of_money_2") then
                            cm:treasury_mod(faction_name, 10000)
                        elseif military_force:has_effect_bundle("ovn_bundle_pre_battle_purchase_the_power_of_money_3") then
                            cm:treasury_mod(faction_name, 15000)
                        elseif military_force:has_effect_bundle("ovn_bundle_pre_battle_purchase_the_power_of_money_4") then
                            cm:treasury_mod(faction_name, 20000)
                        elseif military_force:has_effect_bundle("ovn_bundle_pre_battle_purchase_the_power_of_money_5") then
                            cm:treasury_mod(faction_name, 25000)
                        end
                    end
                    
                    
                    if pb:has_attacker() then
                        remove_power_of_money_effect_bundles(pb:attacker():cqi())
                    end
                    
                    if pb:has_defender() then
                        remove_power_of_money_effect_bundles(pb:defender():cqi())
                    end
                    
                    -- remove these listeners (until the next battle involving a burgemeister)
                    core:remove_listener("ovn_mar_add_charges_ComponentLClickUp")
                    core:remove_listener("ovn_mar_remove_charges_ComponentLClickUp")
            
                    
                end,
                true
            )
        end
    end
);