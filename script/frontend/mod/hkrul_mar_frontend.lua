
core:add_ui_created_callback(
	function(context)
		if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
		
			mixer_change_lord_name("567023710", "hkrul_jk")
            mixer_change_lord_name("59940405", "hkrul_jk")--roc
            mixer_change_lord_name("916127680", "hkrul_jk")--tow
	
	
			mixer_add_starting_unit_list_for_faction("wh_main_emp_marienburg", {"snek_hkrul_mar_landship","hkrul_privateers","hkrul_mar_inf_goedendagers","hkrul_mar_inf_greatsword","hkrul_carriers_ror","hkrul_mar_inf_boogschutter"})
			mixer_add_faction_to_major_faction_list("wh_main_emp_marienburg")	

		--ovn_mar_house_den_euwe
            mixer_enable_custom_faction("234757388")
            mixer_add_starting_unit_list_for_faction("ovn_mar_house_den_euwe", {"wh3_dlc20_chs_inf_chaos_marauders_mtze_spears","hkrul_privateers_dual_swords","hkrul_mar_inf_crossbow","wh3_dlc20_chs_inf_chaos_warriors_mtze","snek_hkrul_mar_landship"})
            mixer_change_lord_name("234757388", "hkrul_mar_egmond")
            mixer_add_faction_to_major_faction_list("ovn_mar_house_den_euwe")	

		--ovn_mar_wasteland
            mixer_enable_custom_faction("1621578361")
            mixer_add_starting_unit_list_for_faction("ovn_mar_the_wasteland", {"wh_main_vmp_inf_zombie","hkrul_burgher","wh_dlc04_vmp_veh_corpse_cart_1","wh_main_vmp_cav_black_knights_0","wh_main_vmp_mon_fell_bats","wh_main_vmp_mon_crypt_horrors"})
            mixer_change_lord_name("1621578361", "hkrul_mar_munvard_01")
            mixer_add_faction_to_major_faction_list("ovn_mar_the_wasteland")	
            
		end		
	end
)
