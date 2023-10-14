core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            mixer_change_lord_name("826095916", "hkrul_dauphine") 
            mixer_enable_custom_faction("826095916")
            mixer_add_starting_unit_list_for_faction("ovn_mar_cult_of_manann", {"hkrul_manann_flagellant", "hkrul_mar_sons_of_manann", "wh_dlc04_emp_inf_free_company_militia_0", "hkrul_mar_culverin", "ovn_mar_inf_knights_mariner_0"})
            mixer_add_faction_to_major_faction_list("ovn_mar_cult_of_manann")

            
            mixer_change_lord_name("1357494483", "chaos_whale_cst_kou") 
            mixer_enable_custom_faction("1357494483")
            mixer_add_starting_unit_list_for_faction("rhox_rogue_spirits_of_stromfel", {"ovn_mar_mon_augas_fish_0", "ovn_mar_mon_augas_fish_1", "urg_dae_inf_sphenisci_daemon"})
        end        
    end
)

