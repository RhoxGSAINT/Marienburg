local rite_images={
    hkrul_mar_ritual_voyage ="ui/skins/default/hkrul_mar_rite_1.png",
    hkrul_mar_ritual_rebels="ui/skins/default/hkrul_mar_rite_2.png",
    hkrul_mar_ritual_merchant="ui/skins/default/hkrul_mar_rite_3.png",
    hkrul_mar_ritual_diplomacy="ui/skins/default/hkrul_mar_rite_4.png",
}


local function play_rite(rite_key)
    out("Rhox mar: Inside the rite visibility function")
	local orig_rite_performed = find_uicomponent(core:get_ui_root(), "rite_performed")
	if not orig_rite_performed then 
        out("Rhox mar: I don't see any rite")
        --return --not summoned so let's do this
    end

	local rite = core:get_or_create_component("rhox_mar_rite", "ui/campaign ui/rite_performed", core:get_ui_root())
	if not rite then
        out("Rhox mar: Could not create it? Why?")
	end
	for i = 0, rite:ChildCount() - 1 do
		local uic_child = UIComponent(rite:Find(i));
		uic_child:SetVisible(false)
	end;
	
    
    local wh2_main_def_hag_graef = find_uicomponent(rite, "wh2_main_def_hag_graef")
	wh2_main_def_hag_graef:SetVisible(true)
	for i = 0, wh2_main_def_hag_graef:ChildCount() - 1 do
		local uic_child = UIComponent(wh2_main_def_hag_graef:Find(i));
		if uic_child:Id() ~= "circle2" then
			uic_child:SetVisible(false)
		end
		if uic_child:Id() == "circle2" then
			uic_child:SetDockOffset(-10, 0)
			uic_child:SetImagePath(rite_images[rite_key], 0)
		end
		
		if uic_child:Id() == "text_holder" then
			uic_child:SetImagePath("ui/skins/warhammer2/rite_hef_text_holder.png", 0)
			uic_child:SetVisible(true)
			uic_child:SetDockOffset(0, 24-24-25)
			local rite_text = find_uicomponent(uic_child, "tx_rite_reformed")
			if rite_text then
				rite_text:SetDockOffset(-15, 0)
				--rite_text:SetStateText(common.get_localised_string("uied_component_texts_localised_string_tx_rite_reformed_NewState_Text_480012")) -- this is a loc with the text
			end
		end
		
	end
end




cm:add_first_tick_callback(function() 
    if cm:is_new_game() then
        if core:is_mod_loaded("!mixer_global_functions") then    
            mixer_set_faction_trait("wh_main_emp_marienburg", "hkrul_mar", true)
        else
            cm:apply_effect_bundle("hkrul_mar", "wh_main_emp_marienburg", 0)
        end
    end
end)


local function add_landship_ror()
    -- Easy data table for faction info and unit info

    local ror_table = { -- A table of many RoR's ---- BEGIN REWRITE
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "snek_hkrul_mar_ror_landship", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_landship_ror", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { --Rhox: I'm putting them here since Egmond does not gain access to this. 
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_fooger_ror", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_fooger_ror", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, 
    } -- Closing out the ror_table variable!

    ---- END REWRITE.

    -- List of default values to shove into the function before; shouldn't need to be changed, usecase may vary.
    local defaults = {
        replen_chance = 100,
        max = 1,
        max_per_turn = 0.1,
        xp_level = 0,
        faction_restriction = "", 
        subculture_restriction = "",
        tech_restriction = "",
        partial_replenishment = true,
    }

    for i, ror in pairs(ror_table) do
        local faction_key, unit_key = ror.faction_key, ror.unit_key
        local merc_pool, merc_group = ror.merc_pool, ror.merc_group
        local count = ror.count or 1 -- if ror.count is undefined, we'll just use the default of 1!

        local faction = cm:get_faction(faction_key)
        if faction then
            cm:add_unit_to_faction_mercenary_pool(
                faction,
                unit_key,
                merc_pool,
                count,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                merc_group
            )
        end
    end
end

cm:add_first_tick_callback_new(
    function()
        add_landship_ror()
    end
);

core:add_listener(
    "rhox_mar_rite_animation",
    "RitualStartedEvent",
    function(context)
        return context:performing_faction() == cm:get_local_faction(true) and cm:get_local_faction_name(true) == "wh_main_emp_marienburg"
    end,
    function(context)
        cm:callback(function()
            play_rite(context:ritual():ritual_key())
        end, 0)
    end,
    true
)

core:add_listener(
    "landship_ror_unlock",
    "RitualCompletedEvent",
    function(context)
        return context:performing_faction():is_human() and context:ritual():ritual_key() == "hkrul_mar_ritual_rebels"
    end,
    function(context)
        cm:remove_event_restricted_unit_record_for_faction("snek_hkrul_mar_ror_landship", context:performing_faction():name())
    end,
    true
)    

