--[[
core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            mixer_change_lord_name("1030160671", "hkrul_fooger") 
            mixer_enable_custom_faction("1030160671")
            mixer_add_starting_unit_list_for_faction("ovn_mar_house_fooger", {"hkrul_mar_fooger_qual", "hkrul_mar_fooger_qual_great", "hkrul_carriers", "hkrul_mar_mortar", "hkrul_fooger_ror"})
            mixer_add_faction_to_major_faction_list("ovn_mar_house_fooger")

        end        
    end
)
]]