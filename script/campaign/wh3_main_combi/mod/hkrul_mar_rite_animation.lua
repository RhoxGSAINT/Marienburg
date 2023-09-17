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



core:add_listener(
    "rhox_mar_rite_animation",
    "RitualStartedEvent",
    function(context)
        return rite_images[context:ritual():ritual_key()] and context:performing_faction() == cm:get_local_faction(true) and cm:get_local_faction_name(true) == "wh_main_emp_marienburg" --ui thing and should be local
    end,
    function(context)
        cm:callback(function()
            play_rite(context:ritual():ritual_key())
        end, 0)
    end,
    true
)



