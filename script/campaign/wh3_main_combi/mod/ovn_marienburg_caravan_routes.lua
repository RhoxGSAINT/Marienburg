rhox_mar_trade_factions ={ --changed it to global so other mods can access to it
    ["wh_main_emp_marienburg"] = true,
    ["ovn_mar_house_den_euwe"] = true,
    ["wh_main_emp_empire"] = true,
    ["wh2_dlc13_emp_golden_order"] = true,
    ["wh2_dlc13_emp_the_huntmarshals_expedition"] = true,
    ["wh3_main_emp_cult_of_sigmar"] = true
}

if vfs.exists("script/campaign/mod/twill_old_world_caravans.lua")then
    rhox_mar_trade_factions ={ --changed it to global so other mods can access to it
        ["wh_main_emp_marienburg"] = true,
        ["ovn_mar_house_den_euwe"] = true,
    }
end


local enemy_to_kill={}


out.design("*** Marienburg Caravan Route script loaded ***");


-- Data --


--Inital caravan forces

local rough_rider = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_privateers_dual_swords",
	"hkrul_privateers_dual_swords",
	"hkrul_mar_cav_rijders",
	"hkrul_mar_cav_rijders",
	"hkrul_mar_cav_rijders",
	"hkrul_mar_cav_rijders"
	};
	
local inventor = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_privateers_dual_swords",
	"hkrul_privateers_dual_swords",
	"hkrul_mar_inf_handgun",
	"hkrul_mar_inf_handgun"
	};
	
local clandestine = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"wh2_dlc11_cst_inf_sartosa_free_company_0",
	"wh2_dlc11_cst_inf_sartosa_free_company_0",
	"wh3_main_ksl_inf_armoured_kossars_1",
	"wh3_main_ksl_inf_armoured_kossars_1",
	"wh3_main_ksl_inf_streltsi_0",
	"wh3_main_ksl_inf_kossars_0",
	"wh3_main_ksl_inf_kossars_0"
	};
	
local favoured = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_crossbow",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_mar_inf_greatsword",
	"hkrul_mar_inf_greatsword",
	"hkrul_mar_inf_crossbow",
	"hkrul_mar_inf_crossbow",
	"hkrul_burgher"
	};
	
local Solkan = {
    "hkrul_mar_cleansing_flame",
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_goedendagers",
	"hkrul_mar_inf_goedendagers"
	};
	
local Former_Artillery_Officer = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_swords",
	"hkrul_mar_inf_swords",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_art_scheepskanon",
	"hkrul_mar_art_scheepskanon"
	};
	
local Norscan_Heritage = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"wh_dlc08_nor_mon_war_mammoth_0",
	"wh_dlc08_nor_inf_marauder_hunters_1",
	"wh_main_nor_inf_chaos_marauders_1",
	"wh_main_nor_inf_chaos_marauders_1",
	"hkrul_mar_inf_halberd",
	"wh_dlc08_nor_inf_marauder_berserkers_0"
	};
	
local Griffon_Whisperer = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_knights_griffon",
	"hkrul_mar_knights_griffon"
	};
	
local Dwarf_Ally = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_qual_great",
	"hkrul_mar_qual_great",
	"hkrul_mar_qual",
	"hkrul_mar_qual",
	"hkrul_mar_qual",
	"wh_main_dwf_inf_longbeards",
	"wh_main_dwf_inf_longbeards",
	"wh_main_dwf_art_organ_gun"
	};
	
local Ogre_Ally = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"wh3_main_ogr_inf_maneaters_0",
	"wh3_main_ogr_inf_maneaters_0",
	"wh3_main_ogr_inf_maneaters_1"
	};
	
local Elf_Ally = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"wh2_main_hef_inf_lothern_sea_guard_1",
	"wh2_main_hef_inf_lothern_sea_guard_1",
	"wh2_main_hef_inf_lothern_sea_guard_1",
	"wh2_main_hef_inf_lothern_sea_guard_1"
	};
	
local Eastern_Idealist = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warrior_crossbowmen_1",
	"wh3_main_cth_inf_jade_warrior_crossbowmen_1"
	};

local Manann = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"wh2_dlc11_cst_inf_sartosa_militia_0",
	"hkrul_mar_sons_of_manann",
	"hkrul_mar_sons_of_manann"
	};
	
local Bretonnia = {
	"hkrul_mar_inf_boogschutter",
	"hkrul_mar_inf_boogschutter",
	"hkrul_burgher",
	"hkrul_burgher",
	"hkrul_mar_inf_crossbow",
	"wh_main_brt_cav_knights_of_the_realm",
	"wh_main_brt_cav_knights_of_the_realm",
	"wh_dlc07_brt_cav_knights_errant_0",
	"wh_dlc07_brt_cav_knights_errant_0"
	};
	
local Teb = {
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_halberd",
	"hkrul_mar_inf_crossbow",
	"hkrul_mar_inf_crossbow",
	"hkrul_mar_inf_crossbow",
	"hkrul_mar_inf_crossbow"
	};

local Cataph_Teb = {
	"teb_pikemen",
	"teb_pikemen",
	"teb_pavisiers",
	"teb_pavisiers",
	"teb_half_pikes",
	"teb_half_pikes",
	"teb_xbowmen",
	"teb_xbowmen"
	};
	
	
	
local item_data = {}


local item_data_combi = {
	["wh3_main_combi_region_altdorf"]		 		= "hkrul_mar_testament", -- 
    ["wh3_main_combi_region_erengrad"]				= "hkrul_mar_loyal",
	["wh3_main_combi_region_arnheim"]				= "hkrul_mar_follower_sun",
	["wh3_main_combi_region_sjoktraken"]			= "hkrul_mar_follower_norsca",
	["wh3_main_combi_region_karond_kar"]			= "hkrul_mar_item_arnheim",
	["wh3_main_combi_region_bordeleaux"]			= "hkrul_mar_baron",
	["wh3_main_combi_region_port_reaver"]			= "hkrul_crispijn",
	["wh3_main_combi_region_lothern"]				= "hkrul_cross", 
	["wh3_main_combi_region_magritta"]				= "hkrul_mar_follower_roelef",
	["wh3_main_combi_region_sartosa"]				= "hkrul_mar_item_vargheist",
	["wh3_main_combi_region_miragliano"]			= "hkrul_mar_lupo",  --
	["wh3_main_combi_region_myrmidens"]				= "hkrul_mar_follower_bret",
	["wh3_main_combi_region_barak_varr"]			= "hkrul_guzunda",
	["wh3_main_combi_region_al_haikk"]				= "hkrul_mar_follower_bard",
	["wh3_main_combi_region_zandri"]				= "hkrul_mar_item_trident_manann",
	["wh3_main_combi_region_lashiek"]				= "hkrul_mar_thom",
	["wh3_main_combi_region_sudenburg"]				= "hkrul_lisette",
	["wh3_main_combi_region_fortress_of_dawn"]		= "hkrul_mar_item_fence", 
	["wh3_main_combi_region_tower_of_the_sun"]		= "hkrul_mar_follower_elf",
	["wh3_main_combi_region_fu_hung"]				= "hkrul_mar_rat",
	["wh3_main_combi_region_dai_cheng"]				= "hkrul_mar_item_shield_manann",
	["wh3_main_combi_region_fu_chow"]				= "hkrul_mar_follower_ship",
	["wh3_main_combi_region_beichai"]				= "hkrul_mar_bonsai",
	["wh3_main_combi_region_haichai"]				= "hkrul_mar_follower_cathay",
	["wh3_main_combi_region_marienburg"]			= "hkrul_mar_marienburg_anc",
	["wh3_main_combi_region_bechafen"]				= "hkrul_pg",
	["cr_combi_region_nippon_3_1"]				= "rhox_mar_grant_of_land",--put real item when the ancillary is ready
	["cr_combi_region_ind_4_2"]				= "rhox_mar_bejewelled_dagger",--put real item when the ancillary is ready
	["cr_combi_region_ihan_3_1"]				= "rhox_mar_frost_wyrm_skull",--put real item when the ancillary is ready
	["cr_combi_region_elithis_1_1"]				= "rhox_mar_mirror_blade"--put real item when the ancillary is ready
}







local region_to_incident = {}

local region_to_incident_combi = {
	["wh3_main_combi_region_altdorf"]		 		= "rhox_mar_convoy_completed_altdorf",
    ["wh3_main_combi_region_erengrad"]				= "rhox_mar_convoy_completed_erengrad",
	["wh3_main_combi_region_arnheim"]				= "rhox_mar_convoy_completed_arnheim",
	["wh3_main_combi_region_sjoktraken"]			= "rhox_mar_convoy_completed_sjoktraken",
	["wh3_main_combi_region_karond_kar"]			= "rhox_mar_convoy_completed_karond_kar",
	["wh3_main_combi_region_bordeleaux"]			= "rhox_mar_convoy_completed_bordeleaux",
	["wh3_main_combi_region_port_reaver"]			= "rhox_mar_convoy_completed_port_reaver",
	["wh3_main_combi_region_lothern"]				= "rhox_mar_convoy_completed_lothern",
	["wh3_main_combi_region_magritta"]				= "rhox_mar_convoy_completed_magritta",
	["wh3_main_combi_region_sartosa"]				= "rhox_mar_convoy_completed_sartosa",
	["wh3_main_combi_region_miragliano"]			= "rhox_mar_convoy_completed_miragliano",
	["wh3_main_combi_region_myrmidens"]				= "rhox_mar_convoy_completed_myrmidens",
	["wh3_main_combi_region_barak_varr"]			= "rhox_mar_convoy_completed_barak_varr",
	["wh3_main_combi_region_al_haikk"]				= "rhox_mar_convoy_completed_al_haikk",
	["wh3_main_combi_region_zandri"]				= "rhox_mar_convoy_completed_zandri",
	["wh3_main_combi_region_lashiek"]				= "rhox_mar_convoy_completed_lashiek",
	["wh3_main_combi_region_sudenburg"]				= "rhox_mar_convoy_completed_sudenburg",
	["wh3_main_combi_region_fortress_of_dawn"]		= "rhox_mar_convoy_completed_fortress_of_dawn",
	["wh3_main_combi_region_tower_of_the_sun"]		= "rhox_mar_convoy_completed_tower_of_the_sun",
	["wh3_main_combi_region_fu_hung"]				= "rhox_mar_convoy_completed_fu_hung",
	["wh3_main_combi_region_dai_cheng"]				= "rhox_mar_convoy_completed_dai_cheng",
	["wh3_main_combi_region_fu_chow"]				= "rhox_mar_convoy_completed_fu_chow",
	["wh3_main_combi_region_beichai"]				= "rhox_mar_convoy_completed_beichai",
	["wh3_main_combi_region_haichai"]				= "rhox_mar_convoy_completed_haichai",
	["wh3_main_combi_region_marienburg"]			= "rhox_mar_convoy_completed_marienburg",
	["wh3_main_combi_region_bechafen"]				= "rhox_mar_convoy_completed_bechafen",
	["cr_combi_region_nippon_3_1"]				= "rhox_mar_convoy_completed_nippon",
	["cr_combi_region_ind_4_2"]				= "rhox_mar_convoy_completed_ind",
	["cr_combi_region_ihan_3_1"]				= "rhox_mar_convoy_completed_ihan",
	["cr_combi_region_elithis_1_1"]				= "rhox_mar_convoy_completed_elithis"
}





local rhox_caravan_exception_list={
    ["hkrul_mar_caravan_master"] =true,
    ["hkrul_mar_caravan_master_horse"] =true,
    ["hkrul_crispijn"] =true,
    ["hkrul_guzunda"] =true,
    ["hkrul_lisette"] =true,
    ["hkrul_cross"] =true,
    ["hkrul_pg"] =true,
    ["hkrul_rasha"] = true,
    ["hkrul_ogg"] = true,
    ["hkrul_paldee"] = true,
}



--low (8)
--DEF A
random_army_manager:new_force("wh2_main_def_dark_elves_qb1_low_a");
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_low_a", "wh2_main_def_inf_dreadspears_0", 4);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_low_a", "wh2_main_def_inf_darkshards_1", 2);

random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_low_a", "wh2_main_def_cav_dark_riders_1", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_low_a", "wh2_main_def_cav_dark_riders_2", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_low_a", "wh2_main_def_art_reaper_bolt_thrower", 1);

--CST A
random_army_manager:new_force("wh2_dlc11_cst_vampire_coast_qb1_low_a");
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_low_a", "wh2_dlc11_cst_inf_zombie_gunnery_mob_0", 4);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_low_a", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 2);

random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_low_a", "wh2_dlc11_cst_mon_bloated_corpse_0", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_low_a", "wh2_dlc11_cst_art_mortar", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_low_a", "wh2_dlc11_cst_mon_fell_bats", 1);

--NOR A
random_army_manager:new_force("wh_main_nor_norsca_qb1_low_a");
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_low_a", "wh_main_nor_inf_chaos_marauders_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_low_a", "wh_dlc08_nor_inf_marauder_spearman_0", 1);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_low_a", "wh_dlc08_nor_inf_marauder_hunters_0", 1);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_low_a", "wh_dlc08_nor_mon_skinwolves_0", 1);

random_army_manager:add_unit("wh_main_nor_norsca_qb1_low_a", "wh_main_nor_inf_chaos_marauders_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_low_a", "wh_dlc08_nor_inf_marauder_spearman_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_low_a", "wh_dlc08_nor_inf_marauder_hunters_0", 1);

--DEF B
random_army_manager:new_force("wh2_main_def_dark_elves_qb1_low_b");
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_low_b", "wh2_main_def_inf_darkshards_1", 2);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_low_b", "wh2_main_def_inf_bleakswords_0", 4);

random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_low_b", "wh2_main_def_cav_dark_riders_1", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_low_b", "wh2_main_def_cav_dark_riders_2", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_low_b", "wh2_main_def_art_reaper_bolt_thrower", 1);

--CST B
random_army_manager:new_force("wh2_dlc11_cst_vampire_coast_qb1_low_b");
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_low_b", "wh2_dlc11_cst_inf_zombie_deckhands_mob_1", 4);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_low_b", "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 2);

random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_low_b", "wh2_dlc11_cst_mon_bloated_corpse_0", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_low_b", "wh2_dlc11_cst_inf_zombie_gunnery_mob_2", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_low_b", "wh2_dlc11_cst_inf_zombie_gunnery_mob_3", 1);

--NOR B
random_army_manager:new_force("wh_main_nor_norsca_qb1_low_b");
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_low_b", "wh_dlc08_nor_inf_marauder_champions_0", 1);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_low_b", "wh_dlc08_nor_inf_marauder_hunters_0", 1);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_low_b", "wh_dlc08_nor_mon_skinwolves_0", 1);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_low_b", "wh_main_nor_inf_chaos_marauders_0", 2);

random_army_manager:add_unit("wh_main_nor_norsca_qb1_low_b", "wh_main_nor_inf_chaos_marauders_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_low_b", "wh_dlc08_nor_inf_marauder_spearman_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_low_b", "wh_dlc08_nor_inf_marauder_hunters_0", 1);


--med (12)
--DEF A
random_army_manager:new_force("wh2_main_def_dark_elves_qb1_med_a");
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_main_def_inf_dreadspears_0", 3);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_main_def_inf_darkshards_1", 3);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_main_def_inf_bleakswords_0", 3);

random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_main_def_inf_shades_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_main_def_inf_shades_1", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_main_def_inf_shades_2", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_main_def_cav_cold_one_knights_0", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_main_def_cav_cold_one_chariot", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_a", "wh2_dlc10_def_cav_doomfire_warlocks_0", 2);
--CST A
random_army_manager:new_force("wh2_dlc11_cst_vampire_coast_qb1_med_a");
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_inf_zombie_deckhands_mob_1", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_inf_zombie_gunnery_mob_0", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 2);

random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_art_carronade", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_art_mortar", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_mon_rotting_prometheans_0", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_mon_animated_hulks_0", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh2_dlc11_cst_mon_mournguls_0", 1);
--NOR A
random_army_manager:new_force("wh_main_nor_norsca_qb1_med_a");
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_a", "wh_main_nor_inf_chaos_marauders_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_a", "wh_dlc08_nor_inf_marauder_spearman_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_a", "wh_dlc08_nor_inf_marauder_hunters_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_a", "wh_main_nor_mon_chaos_trolls", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_a", "wh_dlc08_nor_mon_war_mammoth_0", 1);

random_army_manager:add_unit("wh_main_nor_norsca_qb1_med_a", "wh_dlc08_nor_cav_marauder_warwolves_chariot_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_med_a", "wh_dlc08_nor_mon_skinwolves_1", 1);


--DEF B
random_army_manager:new_force("wh2_main_def_dark_elves_qb1_med_b");
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_main_def_inf_black_ark_corsairs_0", 4);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_main_def_inf_black_ark_corsairs_1", 4);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_dlc10_def_inf_sisters_of_slaughter", 2);

random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_main_def_inf_shades_0", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_main_def_inf_shades_1", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_main_def_inf_shades_2", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_main_def_cav_cold_one_knights_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_main_def_cav_cold_one_chariot", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_med_b", "wh2_main_def_inf_witch_elves_0", 1);
--CST B
random_army_manager:new_force("wh2_dlc11_cst_vampire_coast_qb1_med_b");
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_med_b", "wh2_dlc11_cst_inf_zombie_deckhands_mob_1", 4);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_med_b", "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 4);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_med_b", "wh2_dlc11_cst_inf_zombie_gunnery_mob_2", 2);

random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_b", "wh2_dlc11_cst_art_carronade", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_b", "wh2_dlc11_cst_art_mortar", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_b", "wh2_dlc11_cst_mon_rotting_prometheans_0", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_b", "wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_med_b", "wh2_dlc11_cst_mon_rotting_leviathan_0", 1);
--NOR B
random_army_manager:new_force("wh_main_nor_norsca_qb1_med_b");
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_b", "wh_dlc08_nor_inf_marauder_champions_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_b", "wh_main_nor_inf_chaos_marauders_0", 1);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_b", "wh_dlc08_nor_inf_marauder_spearman_0", 1);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_b", "wh_dlc08_nor_inf_marauder_hunters_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_med_b", "wh_main_nor_mon_chaos_trolls", 2);

random_army_manager:add_unit("wh_main_nor_norsca_qb1_med_b", "wh_dlc08_nor_mon_war_mammoth_0", 2);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_med_b", "wh_dlc08_nor_cav_marauder_warwolves_chariot_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_med_b", "wh_dlc08_nor_mon_skinwolves_1", 1);

--high 15
--DEF A
random_army_manager:new_force("wh2_main_def_dark_elves_qb1_high_a");
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_main_def_inf_dreadspears_0", 4);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_main_def_inf_darkshards_1", 4);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_main_def_inf_har_ganeth_executioners_0", 2);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_main_def_inf_black_guard_0", 2);

random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_main_def_mon_war_hydra_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_dlc10_def_mon_kharibdyss_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_main_def_mon_black_dragon", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_dlc14_def_veh_bloodwrack_shrine_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_dlc14_def_mon_bloodwrack_medusa_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_a", "wh2_dlc10_def_mon_feral_manticore_0", 2);
--CST A
random_army_manager:new_force("wh2_dlc11_cst_vampire_coast_qb1_high_a");
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_inf_zombie_deckhands_mob_1", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_inf_zombie_gunnery_mob_0", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_inf_zombie_gunnery_mob_2", 2);

random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_art_carronade", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_art_mortar", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_inf_depth_guard_0", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_inf_depth_guard_1", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh2_dlc11_cst_mon_rotting_leviathan_0", 1);
--NOR A
random_army_manager:new_force("wh_main_nor_norsca_qb1_high_a");
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_inf_marauder_champions_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_inf_marauder_hunters_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_high_a", "wh_main_nor_mon_chaos_trolls", 2);

random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_mon_war_mammoth_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_mon_frost_wyrm_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_mon_war_mammoth_1", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_mon_war_mammoth_2", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_feral_manticore", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_cav_marauder_warwolves_chariot_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_a", "wh_dlc08_nor_mon_skinwolves_1", 1);


--DEF B
random_army_manager:new_force("wh2_main_def_dark_elves_qb1_high_b");
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_high_b", "wh2_main_def_inf_shades_2", 4);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_high_b", "wh2_main_def_inf_har_ganeth_executioners_0", 4);
random_army_manager:add_mandatory_unit("wh2_main_def_dark_elves_qb1_high_b", "wh2_main_def_inf_black_guard_0", 4);

random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_b", "wh2_main_def_mon_war_hydra_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_b", "wh2_dlc10_def_mon_kharibdyss_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_b", "wh2_dlc10_def_inf_sisters_of_slaughter", 2);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_b", "wh2_dlc14_def_veh_bloodwrack_shrine_0", 1);
random_army_manager:add_unit("wh2_main_def_dark_elves_qb1_high_b", "wh2_main_def_art_reaper_bolt_thrower", 1);
--CST B
random_army_manager:new_force("wh2_dlc11_cst_vampire_coast_qb1_high_b");
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_inf_zombie_deckhands_mob_1", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_inf_zombie_gunnery_mob_0", 2);
random_army_manager:add_mandatory_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_inf_zombie_gunnery_mob_2", 2);

random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_art_carronade", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_art_mortar", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_cav_deck_droppers_2", 2);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_mon_terrorgheist", 1);
random_army_manager:add_unit("wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh2_dlc11_cst_mon_necrofex_colossus_0", 1);
--NOR B
random_army_manager:new_force("wh_main_nor_norsca_qb1_high_b");
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_high_b", "wh_dlc08_nor_inf_marauder_champions_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_high_b", "wh_main_nor_inf_chaos_marauders_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_high_b", "wh_dlc08_nor_inf_marauder_spearman_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_high_b", "wh_dlc08_nor_inf_marauder_hunters_0", 2);
random_army_manager:add_mandatory_unit("wh_main_nor_norsca_qb1_high_b", "wh_main_nor_mon_chaos_trolls", 2);

random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_b", "wh_dlc08_nor_mon_war_mammoth_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_b", "wh_dlc08_nor_mon_frost_wyrm_0", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_b", "wh_dlc08_nor_mon_war_mammoth_1", 1);
random_army_manager:add_unit("wh_main_nor_norsca_qb1_high_b", "wh_dlc08_nor_mon_war_mammoth_2", 1);



--[[--vanilla will make it. We don't need to make one
-- Daemon Army
random_army_manager:new_force("daemon_incursion");
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_inf_bloodletters_0", 3);
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_inf_chaos_warhounds_0", 4);
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_cav_gorebeast_chariot", 1);
--]]

--below global variables are created by rhox

local random_pirate_faction ={
    "wh2_main_def_dark_elves_qb1",
    "wh2_dlc11_cst_vampire_coast_qb1",
    "wh2_dlc13_nor_norsca_invasion"
}

local force_to_faction_name={
    ["wh2_main_def_dark_elves_qb1_low_a"] ="wh2_main_def_dark_elves_qb1",
    ["wh2_main_def_dark_elves_qb1_low_b"] ="wh2_main_def_dark_elves_qb1",
    ["wh2_main_def_dark_elves_qb1_med_a"] ="wh2_main_def_dark_elves_qb1",
    ["wh2_main_def_dark_elves_qb1_med_b"] ="wh2_main_def_dark_elves_qb1",
    ["wh2_main_def_dark_elves_qb1_high_a"] ="wh2_main_def_dark_elves_qb1",
    ["wh2_main_def_dark_elves_qb1_high_b"] ="wh2_main_def_dark_elves_qb1",
    ["wh2_dlc11_cst_vampire_coast_qb1_low_a"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["wh2_dlc11_cst_vampire_coast_qb1_low_b"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["wh2_dlc11_cst_vampire_coast_qb1_med_a"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["wh2_dlc11_cst_vampire_coast_qb1_med_b"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["wh2_dlc11_cst_vampire_coast_qb1_high_a"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["wh2_dlc11_cst_vampire_coast_qb1_high_b"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["wh_main_nor_norsca_qb1_low_a"] ="wh2_dlc13_nor_norsca_invasion",
    ["wh_main_nor_norsca_qb1_low_b"] ="wh2_dlc13_nor_norsca_invasion",
    ["wh_main_nor_norsca_qb1_med_a"] ="wh2_dlc13_nor_norsca_invasion",
    ["wh_main_nor_norsca_qb1_med_b"] ="wh2_dlc13_nor_norsca_invasion",
    ["wh_main_nor_norsca_qb1_high_a"] ="wh2_dlc13_nor_norsca_invasion",
    ["wh_main_nor_norsca_qb1_high_b"] ="wh2_dlc13_nor_norsca_invasion",
}

local lh_reard_check_table={
    ["wh_main_emp_marienburg"]={
        ["hkrul_guzunda"] = false,
        ["hkrul_crispijn"] = false,
        ["hkrul_cross"] = false,
        ["hkrul_lisette"] = false,
        ["hkrul_pg"] = false
    },
    ["ovn_mar_house_den_euwe"]={
        ["hkrul_guzunda"] = false,
        ["hkrul_crispijn"] = false,
        ["hkrul_cross"] = false,
        ["hkrul_lisette"] = false,
        ["hkrul_pg"] = false
    },
    ["wh_main_emp_empire"]={
        ["hkrul_guzunda"] = false,
        ["hkrul_crispijn"] = false,
        ["hkrul_cross"] = false,
        ["hkrul_lisette"] = false,
        ["hkrul_pg"] = false
    },
    ["wh2_dlc13_emp_golden_order"]={
        ["hkrul_guzunda"] = false,
        ["hkrul_crispijn"] = false,
        ["hkrul_cross"] = false,
        ["hkrul_lisette"] = false,
        ["hkrul_pg"] = false
    },
    ["wh2_dlc13_emp_the_huntmarshals_expedition"]={
        ["hkrul_guzunda"] = false,
        ["hkrul_crispijn"] = false,
        ["hkrul_cross"] = false,
        ["hkrul_lisette"] = false,
        ["hkrul_pg"] = false
    },
    ["wh3_main_emp_cult_of_sigmar"]={
        ["hkrul_guzunda"] = false,
        ["hkrul_crispijn"] = false,
        ["hkrul_cross"] = false,
        ["hkrul_lisette"] = false,
        ["hkrul_pg"] = false
    }
}


--Events

local event_table = {

	["banditExtort"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local bandit_threat = world_conditions["bandit_threat"];
		local probability = math.floor(bandit_threat/10) +3;
		
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();
		
		local enemy_faction_name = enemy_faction:name();
		if enemy_faction_name == "rebels" then
			enemy_faction_name = random_pirate_faction[cm:random_number(#random_pirate_faction)]
		end
		
		local eventname = "banditExtort".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*"
			..tostring(bandit_threat).."*";
		
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
	
		out.design("banditExtort action called")
		local dilemma_list = {"rhox_mar_dilemma_cth_caravan_battle_1A", "rhox_mar_dilemma_cth_caravan_battle_1B"}
		local dilemma_name = dilemma_list[cm:random_number(2,1)];
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- read_out_event_params explains encoding
		local decoded_args = hkrul_mar_read_out_event_params(event_conditions,3);
		
		local is_ambush = false;
		local target_faction = decoded_args[2];
		local target_region = decoded_args[1];
		local custom_option = nil;
		
		local bandit_threat = tonumber(decoded_args[3]);
        local enemy_faction_name =nil;
		local attacking_force, enemy_faction_name = hkrul_mar_generate_attackers(bandit_threat, "");
		
		local cargo_amount = caravan_handle:cargo();
		
		--Dilemma option to remove cargo
		function remove_cargo()
			cm:set_caravan_cargo(caravan_handle, cargo_amount - 200)
		end
		
		custom_option = remove_cargo;
		
		--Handles the custom options for the dilemmas, such as battles (only?)
		local enemy_cqi = hkrul_mar_attach_battle_to_dilemma(
												dilemma_name,
												caravan,
												attacking_force,
												is_ambush,
												target_faction,
												enemy_faction_name,
												target_region,
												custom_option
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
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
		dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
	end,
	true},
	
	["banditAmbush"] = 
	--returns its probability [1]
	{function(world_conditions)
	
		local bandit_threat = world_conditions["bandit_threat"];
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();
	
		local enemy_faction_name = enemy_faction:name();
		if enemy_faction_name == "rebels" then
			enemy_faction_name = random_pirate_faction[cm:random_number(#random_pirate_faction)]  
		end
		
		local eventname = "banditAmbush".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*"
			..tostring(bandit_threat).."*";
		
		local probability = math.floor(bandit_threat/20) +3;
		
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		--probability = 100; --rhox temp
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("banditAmbush action called")
		local dilemma_list = {"rhox_mar_dilemma_cth_caravan_battle_2A", "rhox_mar_dilemma_cth_caravan_battle_2B"}
		local dilemma_name = dilemma_list[cm:random_number(2,1)];
		
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = hkrul_mar_read_out_event_params(event_conditions,3);
		
		local is_ambush = true;
		local target_faction = decoded_args[2];
		local target_region = decoded_args[1];
		local custom_option;
		
        local enemy_faction_name =nil;
		local bandit_threat = tonumber(decoded_args[3]);
		local attacking_force, enemy_faction_name = hkrul_mar_generate_attackers(bandit_threat)
		
		
		--If anti ambush skill, then roll for detected event, if passed trigger event with battle
		-- else just ambush
		if caravan:caravan_master():character_details():has_skill("wh3_main_skill_cth_caravan_master_scouts") or cm:random_number(1,0) == 1 then --rhox reduced ambush cahnce 75% -> 50%
			local enemy_cqi = hkrul_mar_attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													false,
													target_faction,
													enemy_faction_name,
													target_region,
													custom_option
													);
			
			--Trigger dilemma to be handled by aboove function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local settlement_target = cm:get_region(target_region):settlement();
			
			out.design("Triggering dilemma:"..dilemma_name)
			
			local haggling_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("rhox_mar_lower_toll", "value");
			if haggling_skill < -95 then
                haggling_skill = -95 --fail safe you're not going to get money from it
            end
			
			--Trigger dilemma to be handled by above function
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			dilemma_builder:add_choice_payload("FIRST", payload_builder);

			payload_builder:treasury_adjustment(math.floor(-1000*((100+haggling_skill)/100)));
			
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		else
			--Immidiately ambush
			--hkrul_mar_create_caravan_battle(caravan, attacking_force, target_region, true)
			hkrul_mar_spawn_caravan_battle_force(caravan, attacking_force, target_region, true, true, enemy_faction_name);
		end;
	end,
	true},
	
	["banditHungryOgres"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local bandit_threat = world_conditions["bandit_threat"];
		local event_region = world_conditions["event_region"];
		local enemy_faction_name = event_region:owning_faction():name();
		
		if enemy_faction_name == "rebels" then
			enemy_faction_name = random_pirate_faction[cm:random_number(#random_pirate_faction)] 
		end
		local enemy_faction = cm:get_faction(enemy_faction_name);
		
		local random_unit ="NONE";
		local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
		
		if caravan_force_unit_list:num_items() > 1 then
			random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
			
			if rhox_caravan_exception_list[random_unit] then --no caravan master or LHs
				random_unit = "NONE";
			end
			out.design("Random unit to be eaten: "..random_unit);
		end;
		
		--Construct targets
		local eventname = "banditHungryOgres".."?"
			..event_region:name().."*"
			..random_unit.."*"
			..tostring(bandit_threat).."*"
			..enemy_faction_name.."*";
			
		
		--Calculate probability
		local probability = 0;
		
		if random_unit == "NONE" then
			probability = 0;
		else
			probability = math.min(bandit_threat,10);
		end
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		--probability = 100 --rhox temp for test
		return {probability,eventname}
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("banditHungryOgres action called")
		local dilemma_name = "rhox_mar_dilemma_cth_caravan_battle_3";
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = hkrul_mar_read_out_event_params(event_conditions,3);
		
		local is_ambush = true;
		local target_faction = decoded_args[4];

		local target_region = decoded_args[1];
		local custom_option = nil;
		
		local random_unit = decoded_args[2];
		local bandit_threat = tonumber(decoded_args[3]);
        local enemy_faction_name = nil;
		local attacking_force, enemy_faction_name = hkrul_mar_generate_attackers(bandit_threat,"random")
		out("Enemy faction from outcome: ".. enemy_faction_name)
		
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
		local enemy_force_cqi = hkrul_mar_attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													false,
													target_faction,
													enemy_faction_name,
													target_region,
													custom_option
													);
	
		--Trigger dilemma to be handled by above function
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		local target_faction_object =  cm:get_faction(target_faction);
		local own_faction = caravan_handle:caravan_force():faction();
		payload_builder:remove_unit(caravan:caravan_force(), random_unit);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		out.design("Triggering dilemma:"..dilemma_name)
		dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
		
		dilemma_builder:add_target("target_military_1", caravan:caravan_force());
		
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	true},
	
	["genericShortcut"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericShortcut".."?";
		local probability = 2;
		--caravan_master is a FAMILY_MEMBER_SCRIPT_INTERFACE
		local has_scouting = world_conditions["caravan_master"]:character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
            
        if has_scouting >0 then
            probability = probability + 6
        end
		
		
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericShortcut action called")
		local dilemma_list = {"rhox_mar_dilemma_cth_caravan_1A", "rhox_mar_dilemma_cth_caravan_1B"}
		local dilemma_name = dilemma_list[cm:random_number(2,1)];
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_key = caravan_handle:caravan_force():faction():name();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		
		function extra_move()
			--check if more than 1 move from the end
			out.design(force_cqi);
			cm:move_caravan(caravan_handle);
		end
		custom_option = extra_move;
		
		hkrul_mar_attach_battle_to_dilemma(
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
		
		local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
		if scout_skill < -99 then
            scout_skill = -99 --fail safe you're not going to get money from it
		end
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		payload_builder:treasury_adjustment(math.floor(-500*((100+scout_skill)/100)));
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["genericCharacter"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericCharacter".."?";
		
		local probability = 1;
		
		local caravan_force = world_conditions["caravan"]:caravan_force();
		local hero_list = {"wh3_main_ogr_cha_hunter_0","wh_main_emp_cha_captain_0","wh2_main_hef_cha_noble_0"}
		
		if not cm:military_force_contains_unit_type_from_list(caravan_force, hero_list) then
			out.design("No characters - increase probability")
			probability = 5;
		end
		
		local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
		
		if caravan_force_unit_list:num_items() >= 19 then
			probability = 0;
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericCharacter action called")
		
		local AorB = {"A","B"};
		local choice = AorB[cm:random_number(#AorB,1)]
		
		local dilemma_name = "rhox_mar_dilemma_cth_caravan_3"..choice;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		local hero_list = {"wh2_dlc14_def_cha_master_0","wh_main_emp_cha_captain_0","wh2_main_hef_cha_noble_0"};
		
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		if choice == "B" then
			payload_builder:treasury_adjustment(-500);
		end
		payload_builder:add_unit(caravan_handle:caravan_force(), hero_list[cm:random_number(#hero_list,1)], 1, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["genericCargoReplenish"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericCargoReplenish".."?";
		local caravan_force = world_conditions["caravan"]:caravan_force();
		
		local probability = 4;
		
		if cm:military_force_average_strength(caravan_force) == 100 and world_conditions["caravan"]:cargo() >= 1000 then
			probability = 0
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericCargoReplenish action called")
		local dilemma_name = "rhox_mar_dilemma_cth_caravan_2B";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		
		function add_cargo()
			local cargo = caravan_handle:cargo();
			cm:set_caravan_cargo(caravan_handle, cargo+200)
		end
		custom_option = add_cargo;
		
		hkrul_mar_attach_battle_to_dilemma(
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
		
		local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
		replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
		replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 1);
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
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["recruitmentChoiceA"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "recruitmentChoiceA".."?";
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		
		local probability = math.floor((20 - army_size)/2);
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("recruitmentChoiceA action called")
		local dilemma_name = "rhox_mar_dilemma_cth_caravan_4A";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		hkrul_mar_attach_battle_to_dilemma(
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
		
		local ranged_list = {"hkrul_mar_inf_handgun","hkrul_mar_riverwarden","hkrul_mar_inf_crossbow","wh2_main_hef_inf_lothern_sea_guard_1"};
		local melee_list = {"hkrul_mar_inf_halberd","hkrul_mar_inf_swords","hkrul_mar_inf_goedendagers"};
		
		payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list,1)], 2, 0);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list,1)], 3, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["recruitmentChoiceB"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "recruitmentChoiceB".."?";
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		
		local probability = math.floor((20 - army_size)/2);
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("recruitmentChoiceB action called")
		local dilemma_name = "rhox_mar_dilemma_cth_caravan_4B";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		hkrul_mar_attach_battle_to_dilemma(
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
		
		local ranged_list = {"hkrul_mar_inf_handgun","hkrul_mar_riverwarden","hkrul_mar_inf_crossbow"};
		local melee_list = {"hkrul_mar_inf_halberd","wh3_main_ogr_inf_maneaters_2","wh3_main_ogr_inf_maneaters_0"};
		
		payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list,1)], 3, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list,1)], 2, 0);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["giftFromInd"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "giftFromInd".."?";
		local turn_number = cm:turn_number();
		
		local probability = 1 + math.floor(turn_number / 100);
		
		if turn_number < 25 then
			probability = 0;
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("giftFromInd action called")
		local dilemma_name = "rhox_mar_dilemma_cth_caravan_5";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		hkrul_mar_attach_battle_to_dilemma(
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
		
		--FIRST double cargo capacity and value, and additional cargo
		payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_blessed_by_ind_riches",false)
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
		cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 1000);
		cargo_bundle:set_duration(0);
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		--SECOND trait and free units
		payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_blessed_by_ind_blades",false)
		local num_units = caravan_handle:caravan_force():unit_list():num_items()
		
		if num_units < 20 then
			payload_builder:add_unit(caravan_handle:caravan_force(), "hkrul_mar_inf_greatsword", math.min(3, 20 - num_units), 9);
		end
		
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["daemonIncursion"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		--Pick random unit
		local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
		
		local random_unit ="NONE";
		if caravan_force_unit_list:num_items() > 1 then
			random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,0)):unit_key();
			
			if rhox_caravan_exception_list[random_unit] then --no caravan masters or LHs
				random_unit ="NONE";
			end
			out.design("Random unit to be killed: "..random_unit);
		end;
		
		local bandit_threat = world_conditions["bandit_threat"];
		local event_region = world_conditions["event_region"];
		
		--Construct targets
		local eventname = "daemonIncursion".."?"
			..event_region:name().."*"
			..random_unit.."*"
			..tostring(bandit_threat).."*";
			
		
		--Calculate probability
		local probability = 1 + math.floor(cm:model():turn_number() / 100);
		
		local turn_number = cm:turn_number();
		if turn_number < 25 then
			probability = 0;
		end
		--probability = 100; --rhox temp
		return {probability,eventname}
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("daemonIncursion action called")
		local dilemma_name = "rhox_mar_dilemma_cth_caravan_battle_4";
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = hkrul_mar_read_out_event_params(event_conditions,3);
		
		local is_ambush = true;
		local target_faction;
		local enemy_faction = "wh3_main_kho_khorne_qb1";
		local target_region = decoded_args[1];
		local custom_option = nil;
		
		local bandit_threat = tonumber(decoded_args[3]);
        local enemy_faction_name =nil;
		local attacking_force, enemy_faction_name = hkrul_mar_generate_attackers(bandit_threat,"daemon_incursion")
		
		
		--Battle to option 1, eat unit to 2
		local enemy_force_cqi = hkrul_mar_attach_battle_to_dilemma(
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
		
		--Battle the daemons - need a custom trait for winning this
		payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_caravan_daemon_hunter",false)
		
		local daemon_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_daemon_hunter");
		daemon_bundle:add_effect("wh3_main_effect_attribute_enable_causes_fear_vs_dae","faction_to_force_own",1);
		daemon_bundle:set_duration(0);
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), daemon_bundle);
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		payload_builder:clear();
		
		--Lose soldiers - coward trait?
		local random_unit = decoded_args[2];
		payload_builder:remove_unit(caravan:caravan_force(), random_unit);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		out.design("Triggering dilemma:"..dilemma_name)
		dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
		dilemma_builder:add_target("target_military_1", caravan:caravan_force());
		
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	true}
	
};

-- Logic --
--Setup
cm:add_first_tick_callback_new(
	function()
		hkrul_mar_recruit_starter_caravan();
		hkrul_mar_initalise_end_node_values();
		cm:callback(--because otherwise vanilla overrides it
            function()
                if cm:get_local_faction_name(true) == "wh_main_emp_marienburg" then --ui thing and local
                    cm:set_script_state("caravan_camera_x",451);
                    cm:set_script_state("caravan_camera_y",657);
                elseif cm:get_local_faction_name(true) == "ovn_mar_house_den_euwe" then --ui thing and local
                    cm:set_script_state("caravan_camera_x",1356);
                    cm:set_script_state("caravan_camera_y",557);
                elseif rhox_mar_trade_factions[cm:get_local_faction_name(true)] then --use Marienburg
                    cm:set_script_state("caravan_camera_x",451);
                    cm:set_script_state("caravan_camera_y",657);
                end
            end,
            3
        )
		

		local all_factions = cm:model():world():faction_list();
		local faction = nil;
		for i=0, all_factions:num_items()-1 do
			faction = all_factions:item_at(i)
			if not faction:is_human() and rhox_mar_trade_factions[faction:name()] then
				cm:apply_effect_bundle("wh3_main_caravan_AI_threat_reduction", faction:name(),0)
			end
		end
	end
);


local function rhox_loop_and_find_flag()
    local node_list_ui = find_uicomponent(core:get_ui_root(), "cathay_caravans", "node_list");
    local node_count = node_list_ui:ChildCount()
    --out("Rhox Mar: Current child count: "..node_count)
    for i=0, node_count-1 do
        local child = find_child_uicomponent_by_index(node_list_ui, i)
        local flag_parent = find_uicomponent(child, "node_overlay")
        local flag = find_uicomponent(flag_parent, "flag_ripple")
        --out("Rhox Mar: Checking the loop: "..child:Id())
        if flag:Visible() then
            --out("Rhox Mar: This one is visible: "..child:Id())
            flag:SetVisible(false)
            local result = core:get_or_create_component("rhox_convoy_flag", "ui/campaign ui/rhox_mar_convoy_flag.twui.xml", flag_parent)
            if not result then
                script_error("Rhox Mar: ".. "ERROR: could not create flag ui component? How can this be?");
                return false;
            end;
            result:SetVisible(true)
        end
    end
end

local function rhox_mar_finish_dilemma_unit_add(caravan)
    local dilemma_name = "rhox_mar_dilemma_final_reward"
    local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
    local payload_builder = cm:create_payload();
    
    local marienburg_list = {
        {unit = "hkrul_mar_inf_handgun", count =2},
        {unit = "hkrul_mar_riverwarden", count =3},
        {unit = "hkrul_mar_inf_crossbow", count =3},
        {unit = "hkrul_privateers_dual_swords", count =2},
        {unit = "hkrul_privateers", count =2},
        {unit = "hkrul_mar_art_scheepskanon", count =1},
        {unit = "hkrul_mar_culverin", count =1},
        {unit = "hkrul_mar_handguns", count =2}
    };
    
    local normal_target_index = cm:random_number(#marienburg_list,1)
    payload_builder:add_unit(caravan:caravan_force(), marienburg_list[normal_target_index].unit, marienburg_list[normal_target_index].count, 0);
    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:clear();
    
    
    local special_list = {
        {unit = "hkrul_mar_inf_handgun", count =3},
        {unit = "hkrul_mar_riverwarden", count =3},
        {unit = "hkrul_mar_inf_crossbow", count =3},
        {unit = "hkrul_mar_inf_halberd", count =3}
    }; --it means nothing just a failsafe
    
    
    
    if caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_cavalry") then
        special_list = {
            {unit = "wh3_main_ksl_cav_winged_lancers_0", count =2},
            {unit = "wh3_main_cth_cav_jade_lancers_0", count =2},
            {unit = "wh_main_emp_cav_empire_knights", count =2},
            {unit = "wh2_main_hef_cav_silver_helms_0", count =2},
            {unit = "wh_main_brt_cav_knights_of_the_realm", count =2},
            {unit = "wh2_dlc16_wef_cav_glade_riders_2", count =3}                  
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_gunner") then
        special_list = {
            {unit = "wh_main_emp_inf_handgunners", count =2},
            {unit = "wh_dlc04_emp_inf_free_company_militia_0", count =3},
            {unit = "wh_main_emp_cav_outriders_0", count =2},
            {unit = "wh_main_emp_cav_outriders_1", count =1},
            {unit = "wh2_dlc13_emp_veh_war_wagon_1", count =1},
            {unit = "wh2_dlc13_emp_veh_war_wagon_0", count =1}                  
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_aristocratic") then
        special_list = {
            {unit = "wh2_dlc13_emp_cav_pistoliers_ror_0", count =1},
            {unit = "wh_main_emp_inf_greatswords", count =1},
            {unit = "wh_main_emp_cav_empire_knights", count =2},
            {unit = "wh_main_emp_inf_swordsmen", count =2},
            {unit = "wh_main_emp_inf_handgunners", count =2}                  
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_reformed_criminal") then
        special_list = {
            {unit = "wh3_main_ksl_veh_light_war_sled_0", count =2},
            {unit = "wh3_main_ksl_veh_heavy_war_sled_0", count =1},
            {unit = "wh3_main_ksl_inf_kossars_1", count =3},
            {unit = "wh3_main_ksl_inf_tzar_guard_0", count =1},
            {unit = "wh3_main_ksl_inf_tzar_guard_1", count =1},
            {unit = "wh3_main_pro_ksl_inf_armoured_kossars_0", count =3}                  
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_solkan_zealot") then
        special_list = {
            {unit = "wh_dlc04_emp_inf_flagellants_0", count =2},
            {unit = "wh_dlc04_emp_cav_knights_blazing_sun_0", count =1},
            {unit = "wh_main_emp_veh_luminark_of_hysh_0", count =1},
            {unit = "wh_dlc04_emp_inf_flagellants_0", count =2}                 
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_former-artillery-officer") then
        special_list = {
            {unit = "hkrul_mar_culverin", count =1},
            {unit = "hkrul_mar_mortar", count =2},
            {unit = "wh_main_emp_veh_steam_tank", count =1},
            {unit = "hkrul_mar_hellstorm", count =1},
            {unit = "hkrul_mar_hellblaster", count =1}                  
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_norscan_heritage") then
        special_list = {
            {unit = "wh_dlc08_nor_inf_marauder_hunters_0", count =2},
            {unit = "wh_dlc08_nor_inf_marauder_hunters_1", count =2},
            {unit = "wh_dlc08_nor_cav_marauder_warwolves_chariot_0", count =1},
            {unit = "wh_dlc08_nor_inf_marauder_berserkers_0", count =2},
            {unit = "wh_dlc08_nor_inf_marauder_spearman_0", count =3},
            {unit = "wh_dlc08_nor_cha_shaman_sorcerer_metal_0", count =1},
            {unit = "wh_dlc08_nor_inf_marauder_champions_0", count =1}          
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_griffon-whisperer") then
        special_list = {
            {unit = "wh2_dlc13_emp_inf_huntsmen_0", count =2},
            {unit = "wh2_dlc13_emp_inf_archers_0", count =3},
            {unit = "wh_main_emp_cav_demigryph_knights_0", count =1},
            {unit = "wh_dlc07_brt_cav_royal_hippogryph_knights_0", count =1},
            {unit = "wh_main_emp_inf_crossbowmen", count =2}                  
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_dwarf-ally") then
        special_list = {
            {unit = "wh_main_dwf_inf_thunderers_0", count =2},
            {unit = "wh_main_dwf_inf_dwarf_warrior_0", count =3},
            {unit = "wh_main_dwf_inf_hammerers", count =1},
            {unit = "wh_main_dwf_art_cannon", count =1},
            {unit = "wh_main_dwf_inf_longbeards_1", count =2}          
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_ogre-ally") then
        special_list = {
            {unit = "wh3_main_ogr_inf_maneaters_0", count =1},
            {unit = "wh3_main_ogr_inf_maneaters_2", count =1},
            {unit = "wh3_main_ogr_mon_sabretusk_pack_0", count =2},
            {unit = "wh3_main_ogr_cav_mournfang_cavalry_0", count =1},
            {unit = "wh3_main_ogr_inf_ironguts_0", count =1},
            {unit = "wh3_main_ogr_inf_maneaters_3", count =1}                  
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_elf-ally") then
        special_list = {
            {unit = "wh2_main_hef_inf_lothern_sea_guard_1", count =2},
            {unit = "wh2_main_hef_inf_spearmen_0", count =3},
            {unit = "wh2_dlc15_hef_mon_arcane_phoenix_0", count =1},
            {unit = "wh2_dlc15_hef_inf_silverin_guard_0", count =1},
            {unit = "wh2_main_hef_mon_great_eagle", count =1}
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_eastern-idealist") then
        special_list = {
            {unit = "wh3_main_cth_inf_peasant_archers_0", count =3},
            {unit = "wh3_main_cth_inf_jade_warriors_1", count =2},
            {unit = "wh3_main_cth_inf_iron_hail_gunners_0", count =2},
            {unit = "wh3_main_cth_veh_sky_lantern_0", count =1},
            {unit = "wh3_main_cth_art_grand_cannon_0", count =1},
            {unit = "wh3_main_cth_inf_crane_gunners_0", count =1}          
        };
    elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_manann_zealot") then
        special_list = {
            {unit = "hkrul_mar_sons_of_manann", count =1},
            {unit = "wh2_dlc11_cst_inf_sartosa_free_company_0", count =2},
            {unit = "wh2_dlc11_cst_inf_sartosa_militia_0", count =2}
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_bretonnia") then
        special_list = {
            {unit = "wh_main_brt_inf_men_at_arms", count =3},
            {unit = "wh_main_brt_inf_spearmen_at_arms", count =3},
            {unit = "wh_dlc07_brt_inf_foot_squires_0", count =2},
            {unit = "wh_main_brt_art_field_trebuchet", count =1},
            {unit = "wh_main_brt_cav_pegasus_knights", count =1},
            {unit = "wh_dlc07_brt_cav_knights_errant_0", count =2},
            {unit = "wh_main_brt_cav_knights_of_the_realm", count =2},
            {unit = "wh_main_brt_cav_mounted_yeomen_1", count =2}          
        };
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_teb") then
        if vfs.exists("script/frontend/mod/cataph_teb.lua")then --you have Cataph's TEB installed! Here is a little gift for you.
            special_list = {
            {unit = "teb_galloper", count =1},
            {unit = "teb_half_pikes", count =2},
            {unit = "teb_duellists", count =2},
            {unit = "teb_light_cannon", count =1},
            {unit = "teb_pikemen", count =2},
            {unit = "teb_xbowmen", count =2}
        };
        else
            special_list = {
                {unit = "hkrul_mar_inf_handgun", count =2},
                {unit = "hkrul_mar_riverwarden", count =3},
                {unit = "hkrul_mar_inf_crossbow", count =3},
                {unit = "hkrul_privateers_dual_swords", count =2},
                {unit = "hkrul_privateers", count =2},
                {unit = "hkrul_mar_art_scheepskanon", count =1},
                {unit = "hkrul_mar_culverin", count =1},
                {unit = "hkrul_mar_handguns", count =2}
            };
        end
		
	else
		out("*** Unknown Caravan Master ??? ***")
	end
	
	local target_index = cm:random_number(#special_list,1)
	payload_builder:add_unit(caravan:caravan_force(), special_list[target_index].unit, special_list[target_index].count, 0);
    dilemma_builder:add_choice_payload("SECOND", payload_builder);
    
    dilemma_builder:add_target("default", caravan:caravan_force());
    
    out.design("Triggering dilemma:"..dilemma_name)
    cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan:caravan_force():faction());
end

--[[--for multi caravan not using it anymore
core:add_listener(
    "rhox_mar_realtime_caravan_panel",
    "RealTimeTrigger",
    function(context)
        return context.string == "rhox_mar_realtime_caravan_panel"
    end,
    function()
        local dispatch_hlist = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "dispatch_holder", "hlist");
        local dispatch_destination_list = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "dispatch_holder", "destination_list");
        
        if not dispatch_hlist or not dispatch_destination_list then
            real_timer.unregister("rhox_mar_realtime_caravan_panel")
            return
        end
        dispatch_hlist:SetVisible(true)
        dispatch_destination_list:SetVisible(true)
    end,
    true
)
--]]

cm:add_first_tick_callback(
	function ()
		-- Setup event and region data for each campaign
		if cm:get_campaign_name() == "main_warhammer" then
			region_to_incident = region_to_incident_combi;
			item_data = item_data_combi;
			------rhox-----------------
			if rhox_mar_trade_factions[cm:get_local_faction_name(true)] then --ui thing and should be local
                local caravan_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_caravan");
                caravan_button:SetTooltipText(common.get_localised_string("ui_text_replacements_localised_text_ovn_ivory_road_tooltip_ovn_sc_mar_marienburg"), true) --this changes faction button docker tooltip
                
                
                core:add_listener(--this is where changing all the localization, flag, and movie for CARAVAN-COVOY happens
                    "rhox_mar_caravan_open_listener",
                    "PanelOpenedCampaign",
                    function(context)
                        return context.string == "cathay_caravans";
                    end,
                    function()
                        local caravan_head_text = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "header_holder", "tx_header");
                        if not caravan_head_text then
                            return
                        end
                        caravan_head_text:SetText(common.get_localised_string("ui_text_replacements_localised_text_ovn_ivory_road"))
                        
                        local reserve_caravan_text_parent = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel");
                        local reserve_caravan_text = find_child_uicomponent(reserve_caravan_text_parent, "tx_header")
                        reserve_caravan_text:SetText(common.get_localised_string("campaign_localised_strings_string_rhox_reserve_convoy"))
                        
                        local reserve_caravan_no_caravan_text = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "tx_no_caravans");
                        reserve_caravan_no_caravan_text:SetText(common.get_localised_string("campaign_localised_strings_string_rhox_no_active_convoy"))
                        
                        local reserve_caravan_active_caravan_text = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "active_holder", "tx_active_header");
                        reserve_caravan_active_caravan_text:SetText(common.get_localised_string("campaign_localised_strings_string_rhox_active_convoy"))
                        
                        local caravan_head_movie_holder = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "header_holder");
                        local caravan_head_movie = find_uicomponent(caravan_head_movie_holder, "background_movie");
                        caravan_head_movie:SetVisible(false) --we don't want to see the caravan movie
                        
                        
                        
                        --local caravan_dispatch_button = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "dispatch_holder", "button_dispatch");
                        --caravan_dispatch_button:SetState("active")--double test, it didn't work
                        
                        
                        --real_timer.unregister("rhox_mar_realtime_caravan_panel")
                        --real_timer.register_repeating("rhox_mar_realtime_caravan_panel", 100)
                        
                        --local temp_value = dispatch_hlist:GetContextObject("CcoScriptObject")
                        --out("Rhox Mar temp: " .. tostring(temp_value))
                        --out("Rhox Mar temp: " .. tostring(temp_value:Call("ContextVisibilitySetter.StringValue")))
                        
                        
                        
                        local result = core:get_or_create_component("rhox_convoy_movie", "ui/campaign ui/rhox_convoy_movie.twui.xml", caravan_head_movie_holder)
                        if not result then
                            script_error("Rhox Mar: ".. "ERROR: could not create movie ui component? How can this be?");
                            return false;
                        end;
                        
                        --[[--Things I did for double caravan not doing it because it needed vanilla twui override
                        local second_active_parent = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "active_parent", "active_holder");
                        local result2 = core:get_or_create_component("rhox_mar_caravan_second_active", "ui/campaign ui/rhox_mar_second_holder.twui.xml", second_active_parent)
                        if not result2 then
                            script_error("Rhox Mar: ".. "ERROR: could not create second_holder ui component? How can this be?");
                            return false;
                        end;
                        
                        
                        
                        local active_parent = find_uicomponent(core:get_ui_root(), "cathay_caravans", "caravans_panel", "active_parent");
                        if result2:Visible() then
                            active_parent:Resize(400, 300)
                        end
                        ]]--
                        
                        cm:callback(
                            function()
                                rhox_loop_and_find_flag()
                            end,
                            1
                        )
                    end,
                    true
                )
            end
            local is_human_mar_trade_faction = false
            for key, value in pairs(rhox_mar_trade_factions) do
                if cm:get_faction(key):is_human() then
                    is_human_mar_trade_faction = true
                end
            end

            if is_human_mar_trade_faction then
                core:add_listener(
                    "rhox_mar_LH_failsafe_RoundStart",
                    "FactionRoundStart",
                    function(context)
                        return rhox_mar_trade_factions[context:faction():name()] and context:faction():is_human()
                    end,
                    function(context)
                        local faction_key = context:faction():name()
                        if lh_reard_check_table[faction_key]["hkrul_crispijn"] == true then
                            local reward = "hkrul_crispijn"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction():name(), "champion", reward)
                            if unique_agent then 
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                            end
                        end
                        if lh_reard_check_table[faction_key]["hkrul_guzunda"] == true then
                            local reward = "hkrul_guzunda"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction():name(), "champion", reward)
                            if unique_agent then 
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                            end
                        end
                        if lh_reard_check_table[faction_key]["hkrul_cross"] == true then
                            local reward = "hkrul_cross"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction():name(), "champion", reward)
                            if unique_agent then 
                                cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_cross"), "", "", "")
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                            end
                        end
                        if lh_reard_check_table[faction_key]["hkrul_lisette"] == true then
                            local reward = "hkrul_lisette"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction():name(), "spy", reward)
                            if unique_agent then 
                                cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_lisette"), "", "", "")--rename her
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi())) --do not teleport her She maybe summoned earlier
                            end
                        end
                        if lh_reard_check_table[faction_key]["hkrul_pg"] == true then
                            local reward = "hkrul_pg"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction():name(), "champion", reward)
                            if unique_agent then 
                                cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_pg"), "", "", "")
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                            end
                        end
                        if cm:get_saved_value("rhox_solkan_summoned") == true then
                            hkrul_spawn_solkan(context:faction():name(), "hkrul_solkan")
                        end
                        
                    end,
                    true
                )
                
                
                
                if lh_reard_check_table["wh_main_emp_marienburg"]["hkrul_crispijn"] ==false then --you don't have to check it if player has already recieved Crispijin
                    core:add_listener(
                        "rhox_mar_crispijn_notify_check_RoundStart",
                        "FactionRoundStart",
                        function(context)
                            return context:faction():name() == "wh_main_emp_marienburg" and context:faction():is_human() and cm:model():turn_number() == 25 --popup thing at turn 25 --only for Mairenburg
                        end,
                        function(context)
                            if lh_reard_check_table["wh_main_emp_marienburg"]["hkrul_crispijn"] ==false then --player might have recieved the item after the first tick
                                cm:trigger_incident("wh_main_emp_marienburg", "rhox_mar_crispijn_notify", true)
                            end
                        end,
                        false --don't have to notify twice
                    )
                end
            else --you're not Marienburg or Egmond so the AI is getting these rewards
                core:add_listener(
                    "rhox_mar_AI_caravan_LH_RoundStart",
                    "FactionRoundStart",
                    function(context)
                        return context:faction():name() == "wh_main_emp_marienburg"
                    end,
                    function(context)
                        local faction_key = "wh_main_emp_marienburg"
                        if lh_reard_check_table[faction_key]["hkrul_crispijn"] == true or cm:model():turn_number() == 10 then
                            lh_reard_check_table[faction_key]["hkrul_crispijn"] = true
                            local reward = "hkrul_crispijn"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction(), "champion", reward)
                            if unique_agent then 
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                            end
                        end
                        if lh_reard_check_table[faction_key]["hkrul_guzunda"] == true or cm:model():turn_number() == 20 then
                            lh_reard_check_table[faction_key]["hkrul_guzunda"] = true
                            local reward = "hkrul_guzunda"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction(), "champion", reward)
                            if unique_agent then 
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                            end
                        end
                        if lh_reard_check_table[faction_key]["hkrul_cross"] == true or cm:model():turn_number() == 30 then
                            lh_reard_check_table[faction_key]["hkrul_cross"] = true
                            local reward = "hkrul_cross"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction(), "champion", reward)
                            if unique_agent then 
                                cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_cross"), "", "", "")
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                            end
                        end
                        if lh_reard_check_table[faction_key]["hkrul_lisette"] == true or cm:model():turn_number() == 40 then
                            lh_reard_check_table[faction_key]["hkrul_lisette"] = true
                            local reward = "hkrul_lisette"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction(), "spy", reward)
                            if unique_agent then 
                                cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_lisette"), "", "", "")--rename her
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi())) --do not teleport her She maybe summoned earlier
                            end
                        end                        
                        if lh_reard_check_table[faction_key]["hkrul_pg"] == true or cm:model():turn_number() == 50 then
                            lh_reard_check_table[faction_key]["hkrul_pg"] = true
                            local reward = "hkrul_pg"
                            cm:spawn_unique_agent(context:faction():command_queue_index(), reward, true)
                            local unique_agent = cm:get_most_recently_created_character_of_type(context:faction(), "champion", reward)
                            if unique_agent then 
                                cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_pg"), "", "", "")
                                cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                            end
                        end
                    end,
                    true
                )
			end
        end


	end
);

    

--Listeners
core:add_listener(
	"hkrul_mar_caravan_waylay_query",
	"QueryShouldWaylayCaravan",
	function(context)
		return context:faction():is_human() and rhox_mar_trade_factions[context:faction():name()]
	end,
	function(context)
		out.design("Roll for hkrul Mar Ivory Road Event");
		cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true) --for each turn will it work?
		if hkrul_mar_ivory_road_event_handler(context) == false then
			out.design("Caravan not valid for event");
		end;
		
	end,
	true
);

core:add_listener(
	"hkrul_mar_caravan_waylaid",
	"CaravanWaylaid",
	function(context)
		return rhox_mar_trade_factions[context:faction():name()]
	end,
	function(context)
		out.design("Handle a waylaid caravan");
		hkrul_mar_waylaid_caravan_handler(context);
		
		--rhox this will make him force stance each turn?
		
		local caravan = context:caravan();
		local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
		local caravan_is_at_sea = caravan:caravan_force():general_character():is_at_sea()
		if caravan_is_at_sea then
            out("Rhox Mar: Ask them to go to partol mode. Don't know whether he is going to listen to this or not.")
            cm:force_character_force_into_stance(caravan_master_lookup, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_PATROL")
		else
            out("Rhox Mar: They are not in sea and I asked them to go on fixed camp mode")
            cm:force_character_force_into_stance(caravan_master_lookup, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP")
        end
        --]]
	end,
	true
);

core:add_listener(
	"hkrul_mar_add_inital_force",
	"CaravanRecruited",
	function(context)
		return rhox_mar_trade_factions[context:faction():name()]
	end,
	function(context)
		out.design("*** Caravan recruited ***");
		if context:caravan():caravan_force():unit_list():num_items() < 2 then
			local caravan = context:caravan();
			hkrul_mar_add_inital_force(caravan);
			cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
		end;
	end,
	true
);

core:add_listener(
	"hkrul_mar_add_inital_bundles",
	"CaravanSpawned",
	function(context)
		return rhox_mar_trade_factions[context:faction():name()]
	end,
	function(context)
		out.design("*** Caravan deployed ***");
		local caravan = context:caravan();
		hkrul_mar_add_effectbundle(caravan);
		cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
		cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
		rhox_mar_add_initial_cargo(context:caravan())
		out("Rhox Mar: Checking if it hasn't broke something")
	end,
	true
);

core:add_listener(
	"hkrul_mar_caravan_finished",
	"CaravanCompleted",
	function(context)
		return rhox_mar_trade_factions[context:faction():name()]
	end,
	function(context)
		-- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
		local node = context:complete_position():node()
		local region_name = node:region_key()
        out.design("Caravan (player) arrived in: "..region_name)
		local region_owner = node:region_data():region():owning_faction();
		
		
		
		local faction = context:faction()
		local faction_key = faction:name();
		local prev_total_goods_moved = cm:get_saved_value("hkrul_mar_caravan_goods_moved_" .. faction_key) or 0;
		local num_caravans_completed = cm:get_saved_value("hkrul_mar_caravans_completed_" .. faction_key) or 0;
		cm:set_saved_value("hkrul_mar_caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
		cm:set_saved_value("hkrul_mar_caravans_completed_" .. faction_key, num_caravans_completed + 1);
		core:trigger_event("ScriptEventCaravanCompleted", context);
		
		local character = context:caravan_master():character() --caravan master
		if character:has_effect_bundle("rhox_mar_bundle_caravan_heroes") then
            cm:remove_effect_bundle_from_character("rhox_mar_bundle_caravan_heroes", character)
        end-- remove the cargo effect from the heroes
		
		
		if faction:is_human() then
			hkrul_mar_reward_item_check(faction, region_name, context:caravan_master())
			local caravan_master = context:caravan_master()
			local caravan_military_force = caravan_master:character():military_force()
            local caravan_military_unit_number = caravan_military_force:unit_list():num_items()
            if caravan_military_unit_number < 18 then -- you need to have at least 3 unit slots left
                out("Rhox mar: You have at least 3 free spaces")
                rhox_mar_finish_dilemma_unit_add(context:caravan())
			end
		end
			
		if not region_owner:is_null_interface() then
			
			local region_owner_key = region_owner:name()
			out.design("Inserting a diplomatic event for caravan arriving. Factions: "..region_owner_key..", "..faction_key)
			cm:cai_insert_caravan_diplomatic_event(region_owner_key,faction_key)

			if region_owner:is_human() and faction_key ~= region_owner_key then
				cm:trigger_incident_with_targets(
					region_owner:command_queue_index(),
					"hkrul_mar_caravan_completed_received",
					0,
					0,
					context:caravan_master():character():command_queue_index(),
					0,
					0,
					0
				)
			end
		
		end
		
		--Reduce demand
		local cargo = context:caravan():cargo()
		local value = math.floor(-cargo/18);
		out.design("Reduce "..region_name)
		
		cm:callback(function()hkrul_mar_adjust_end_node_value(region_name, value, "add") end, 5);
					
	end,
	true
);

core:add_listener(
	"hkrul_mar_caravans_increase_demand",
	"WorldStartRound",
	true,
	function(context)
		hkrul_mar_adjust_end_node_values_for_demand();
		for j = 1, #enemy_to_kill do
            cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");	
            cm:kill_character("character_cqi:"..enemy_to_kill[j], true)
            cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, 0.2);
        end
        enemy_to_kill = {}
	end,
	true
);

core:add_listener(
	"hkrul_mar_caravan_master_heal",
	"CaravanMoved",
	function(context)
		return rhox_mar_trade_factions[context:faction():name()]
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


--[[--let's not do this
core:add_listener(
	"hkrul_mar_clean_up_attacker",
	"FactionTurnStart",
	function(context)
		return context:faction():name() == "wh2_main_def_dark_elves_qb1" or context:faction():name() == "wh2_dlc11_cst_vampire_coast_qb1" or context:faction():name() == "wh2_dlc13_nor_norsca_invasion"
	end,
	function(context)
		cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");

		cm:kill_all_armies_for_faction(context:faction());

		cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, 0.2);
	end,
	true
);
--]]

core:add_listener(
	"hkrul_mar_unlock_retreat_caravan",
	"CharacterCompletedBattle",
	function(context)
		local character = context:character();
		local caravan_system = cm:model():world():caravans_system():faction_caravans(character:faction())
		
		if not caravan_system:is_null_interface() then
			local active_caravans = caravan_system:active_caravans()
			return not active_caravans:is_empty() and character:command_queue_index() == active_caravans:item_at(0):caravan_master():character():command_queue_index()
		end
	end,
	function(context)
		out.design("Move caravan from the generic listener")
		cm:move_caravan(cm:model():world():caravans_system():faction_caravans(context:character():faction()):active_caravans():item_at(0))
		
		uim:override("retreat"):unlock()
		out.design("Enable retreat button")
	end,
	true
);

core:add_listener(
	"hkrul_mar_reenable_event_feed_post_caravan_battle",
	"BattleCompleted",
	function()
		return cm:pending_battle_cache_faction_is_involved("wh2_main_def_dark_elves_qb1") or cm:pending_battle_cache_faction_is_involved("wh2_dlc11_cst_vampire_coast_qb1") or cm:pending_battle_cache_faction_is_involved("wh2_dlc13_nor_norsca_invasion")
	end,
	function()
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared")
				cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed")
				cm:disable_event_feed_events(false, "", "", "character_dies_battle")
			end,
			0.2
		)
	end,
	true
);

--Functions

function hkrul_mar_ivory_road_event_handler(context)
	
	--package up some world state
	--generate an event
	
	local caravan_master = context:caravan_master();
	local faction = context:faction();
	
	if context:from():is_null_interface() or context:to():is_null_interface() then
		return false
	end;
	--out("Rhox caravan: False1")
	local from_node = context:caravan():position():network():node_for_position(context:from());
	local to_node = context:caravan():position():network():node_for_position(context:to());
	
	local route_segment = context:caravan():position():network():segment_between_nodes(
	from_node, to_node);
	
	if route_segment:is_null_interface() then
		return false
	end
	--out("Rhox caravan: False2")
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
	out("Rhox caravan number of regions: "..num_regions)
	local bandit_list_of_regions = {};
	
	--override region if one is at war
	for i = 0,num_regions-1 do
		out.design("iterate regions: "..i)
		local reg = list_of_regions:item_at(i):region()
		if not reg:is_null_interface() then
			table.insert(bandit_list_of_regions,reg:name())

			out.design("Bandit for region: ")
			out.design(cm:model():world():caravans_system():banditry_for_region_by_key(
			reg:name()))
			
			if list_of_regions:item_at(i):region():owning_faction():at_war_with(context:faction()) then
				event_region=list_of_regions:item_at(i):region()
			end;
		else
			out("Rhox Caravan: null_interface (sea region?)")
		end;
	end
    out("Rhox caravan: after bandit")
    
	
	
	local bandit_threat = math.floor( cm:model():world():caravans_system():total_banditry_for_regions_by_key(bandit_list_of_regions) / num_regions);
	out.design("Average bandit threat: "..tostring(bandit_threat));
    if event_region == nil then
        out("Rhox caravan is nil! prepare for big fat error!")
    else
        out("Rhox caravan event region: ".. event_region:name())
    end

	
	local conditions = {
		["caravan"]=context:caravan(),
		["caravan_master"]=caravan_master,
		["list_of_regions"]=list_of_regions,
		["event_region"]=event_region,
		["bandit_threat"]=bandit_threat,
		["faction"]=faction
		};
	
	out("Rhox Caravan: Call generate event")
	local contextual_event, is_battle = hkrul_mar_generate_event(conditions);
	
	--if battle then waylay
	
	if is_battle == true and contextual_event ~= nil then
		out.design("Generated event "..contextual_event..". Waylay a caravan")
		context:flag_for_waylay(contextual_event);
	elseif is_battle == false and contextual_event ~= nil then
		out.design("Generated event "..contextual_event)
		context:flag_for_waylay(contextual_event);
		--needs to survive a save load at this point
	elseif is_battle == nil and contextual_event == nil then
		out.design("No caravan event this turn");
	end;
	
	
	
end


function hkrul_mar_generate_event(conditions)
	
	--look throught the events table and create a table for weighted roll
	--pick one and return the event name
	
	local weighted_random_list = {};
	local total_probability = 0;
	local i = 0;
	
	--build table for weighted roll
	for key, val in pairs(event_table) do
		
		i = i + 1;
		
		--Returns the probability of the event 
		local args = val[1](conditions)
		local prob = args[1];
		total_probability = prob + total_probability;
		--Returns the name and target of the event
		local name_args = args[2];
		
		--Returns if a battle is possible from this event
		--i.e. does it need to waylay
		local is_battle = val[3];
		
		out.design("Adding "..name_args.." with probability: "..prob)
		weighted_random_list[i] = {total_probability,name_args,is_battle}

	end
	
	--check all the probabilites until matched
	local no_event_chance = 25;
	local random_int = cm:random_number(total_probability + no_event_chance,1);
	local is_battle = nil;
	local contextual_event_name = nil;
	
	out.design("********")
	out.design("Caravan Event -> Random number: "..random_int.." out of: "..total_probability)
	out.design("********")
	for j=1,i do
		if weighted_random_list[j][1] >= random_int then
			
			--out.design(tostring(weighted_random_list[j][1]).." is greater than "..tostring(random_int))
			contextual_event_name = weighted_random_list[j][2];
			is_battle = weighted_random_list[j][3];
			break;
		end
	end
	
	if cm:tol_campaign_key() then
		contextual_event_name = nil;
	end;
	
	return contextual_event_name, is_battle
end;


function hkrul_mar_waylaid_caravan_handler(context)
	
	local event_name_formatted = context:context();
	local caravan_handle = context:caravan();
	
	out.design("Formatted string caught by handler: "..event_name_formatted);
	
	local event_key = hkrul_mar_read_out_event_key(event_name_formatted);
	out.design(tostring(event_key));
	
	--call the action side of the event
	event_table[event_key][2](event_name_formatted,caravan_handle);
	
end


function hkrul_mar_read_out_event_key(event_string)
	
	t = {}
	s = event_string          --format is "banditAttack?first*second*third*"
	for v in string.gmatch(s, "(%a+)?") do
		table.insert(t, v)
	end
	
	return(t[1])
end;

function hkrul_mar_read_out_event_params(event_string,num_args)
	
	local arg_table = {};
	
	local i = 0;
	for v in string.gmatch(event_string, "[_%w]+*") do
		i=i+1;
		
		local substring = v:sub(1, #v - 1)
		arg_table[i] = substring;
		
	end
	
	return(arg_table)
end;


function hkrul_mar_find_battle_coords_from_region(faction_key, region_key)
	
	local x,y = cm:find_valid_spawn_location_for_character_from_settlement(
		faction_key,
		region_key,
		false,
		true,
		20
		);
	
	--if cm:get_campaign_name() == "wh3_main_chaos" then
--
	--	local no_spawn_list = hkrul_mar_build_list_of_nodes();
	--		
	--	if hkrul_mar_is_pair_in_list({x,y},no_spawn_list) then
	--		x,y = cm:find_valid_spawn_location_for_character_from_settlement(
	--			faction_key,
	--			region_key,
	--			false,
	--			true,
	--			30
	--			);
	--	end
--
	--end
	
	return x,y
end

function hkrul_mar_spawn_caravan_battle_force(caravan, attacking_force, region, is_ambush, immediate_battle, optional_faction)

	out.design("Battle created");
    out("Rhox Mar Optional faction: "..optional_faction)
    local enemy_faction = optional_faction 
	
	local caravan_faction = caravan:caravan_force():faction();
	local enemy_force_cqi = 0;
	
	local x,y = hkrul_mar_find_battle_coords_from_region(caravan_faction:name(), region);
	
	--spawn enemy army
	--ideal solution is that the owner of the force are the regions rebel faction
	cm:create_force(
		enemy_faction,
		attacking_force,
		region,
		x,
		y,
		true,
		function(char_cqi,force_cqi)
			enemy_force_cqi = force_cqi;
			
			cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
			cm:force_declare_war(enemy_faction, caravan_faction:name(), false, false);	
			cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared") end, 0.2);
			cm:disable_movement_for_character(cm:char_lookup_str(char_cqi));
			cm:set_force_has_retreated_this_turn(cm:get_military_force_by_cqi(force_cqi));
			
			table.insert(enemy_to_kill, char_cqi)
		end
	);

	if immediate_battle == true then
		if cm:is_multiplayer() then
			hkrul_mar_create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush)
		else
			cm:trigger_transient_intervention(
				"spawn_caravan_battle_force",
				function(inv)
					hkrul_mar_create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush)
					inv:complete()
				end
			);
		end
	elseif immediate_battle == false then 
		return enemy_force_cqi, x, y
	end
end

function hkrul_mar_create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush)
	out.design("Move armies for battle")
	local caravan_faction = caravan:caravan_force():faction();
	
	--find caravan army spawn
	--find move coords for caravan
	local caravan_x, caravan_y = cm:find_valid_spawn_location_for_character_from_position(
		caravan_faction:name(),
		x,
		y,
		false
	);
	
	local caravan_teleport_cqi = caravan:caravan_force():general_character():command_queue_index();
	local caravan_lookup = cm:char_lookup_str(caravan_teleport_cqi)
	out.design(caravan_lookup);
	
	--move the carvan here
	cm:teleport_to(caravan_lookup,  caravan_x,  caravan_y);
	
	out.design("Attack opportunity:");
	out.design("1 Passed CQI "..tostring(enemy_force_cqi));
	out.design("2 Passed CQI "..tostring(caravan:caravan_master():command_queue_index()));
	out.design("Ambush: "..tostring(is_ambush));
	
	--add callack to delete enemy force after battle
	local uim = cm:get_campaign_ui_manager();
	uim:override("retreat"):lock();
	out.design("Disable retreat button");
	
	--suppress events
	cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");
	cm:disable_event_feed_events(true, "", "", "character_dies_battle");
	
	--attack of opportunity
	cm:force_attack_of_opportunity(
		enemy_force_cqi, 
		caravan:caravan_force():command_queue_index(),
		is_ambush
	);
end;


--Handles battles for dilemmas

function hkrul_mar_attach_battle_to_dilemma(
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
	--out("Rhox Mar enemy faction in hkrul_mar_attach_battle_to_dilemma: "..enemy_faction)
	if attacking_force ~= nil then
		out.design("Create enemy force dilemma: "..dilemma_name)
		enemy_force_cqi, x, y = hkrul_mar_spawn_caravan_battle_force(caravan, attacking_force, target_region, is_ambush, false, enemy_faction)
	end
	
	function hkrul_mar_ivory_road_dilemma_choice(context)
		local dilemma = context:dilemma();
		local choice = context:choice();
		local faction = context:faction();
		local faction_key = faction:name();
		out.design("Caught a dilemma: "..dilemma);
		out.design("Choice made: "..tostring(choice));
		
		if dilemma == dilemma_name then
			--if battle option is chosen
			core:remove_listener("hkrul_mar_DilemmaChoiceMadeEvent_"..faction_key);
			
			if choice == 0 and attacking_force ~= nil then
				hkrul_mar_create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush);
				out.design("Battle option chosen in dilemma "..dilemma_name)
			end
			
			if custom_option ~= nil and choice == 1 then
				custom_option();
			end
			
			if choice ~= 0 then
				out.design("Complete the carvan move");
				cm:move_caravan(caravan);
			end;
			
			if choice == 0 and attacking_force == nil then
				out.design("Complete the carvan move");
				cm:move_caravan(caravan)
			end
			
		
		else
			out.design("Wrong dilemma...");
		end
	end
	
	local faction_key = caravan:caravan_master():character():faction():name()

	core:add_listener(
		"hkrul_mar_DilemmaChoiceMadeEvent_"..faction_key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			hkrul_mar_ivory_road_dilemma_choice(context) 
		end,
		true
	);
	
	return enemy_force_cqi
end;

--Generate first so can be used as target
function hkrul_mar_generate_character()
	
	out.design("Generate a hero/agent + trait")
	--Pick a unit type
	local heroes = {"wizard","engineer"};
	local hero_pick = heroes[cm:random_number(#heroes,1)];
	
	--Pick a trait traits
	local traits = {"wh3_main_trait_dummy_caravan_ex_bandit","wh3_main_trait_dummy_caravan_con_artist","wh3_main_trait_dummy_caravan_soldier"};
	local trait_pick = traits[cm:random_number(#traits,1)];
	
	
	return hero_pick, trait_pick;
end

function hkrul_mar_add_character_to_caravan(caravan, hero_pick, trait_pick)
	
	out.design("Attempt to spawn and embed hero/agent")
	
	local force = caravan:caravan_force();
	local faction = caravan:caravan_force():faction();
	
	local x = force:general_character():logical_position_x() + 1;
	local y = force:general_character():logical_position_y() + 1;
	
	local agent = cm.game_interface:spawn_agent_at_position(faction, x, y, hero_pick);
	
	if not agent:is_null_interface() then
		out.design("agent = "..tostring(agent));
		CampaignUI.ClearSelection();
		
		out.design("attempt to embed agent with this cqi "..tostring(agent:cqi()));
		
		cm:embed_agent_in_force(agent, force);
			
		local lookup_str = cm:char_lookup_str(agent:command_queue_index());
		cm:force_add_trait(lookup_str, trait_pick,1);
		
		out.design("Spawned and embedded hero/agent");
	else
	out.design("Error: Agent did not spawn");
	end
end;

--[[
function hkrul_mar_initalise_bandity()

	--only fire for a new game

	--get network handled
	cm:world()
	
	--loop over regions and add small bandity randomly
	cm:random
	cm:set_region_caravan_banditry(REGION_DATA_SCRIPT_INTERFACE region, int value);
end

]]

function hkrul_mar_add_inital_force(caravan)
	
	out.design("Try to add inital force to caravan, based on trait")
	
	local force_cqi = caravan:caravan_force():command_queue_index();
	local lord_cqi = caravan:caravan_force():general_character():command_queue_index();
	local lord_str = cm:char_lookup_str(lord_cqi);
	
	if caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_cavalry") then
		for i=1, #rough_rider do
			cm:grant_unit_to_character(lord_str, rough_rider[i]);
		end
		--fully heal when returning
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_gunner") then
		for i=1, #inventor do
			cm:grant_unit_to_character(lord_str, inventor[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_aristocratic") then
		for i=1, #favoured do
			cm:grant_unit_to_character(lord_str, favoured[i]); --should have xp/t innate skill
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_reformed_criminal") then
		for i=1, #clandestine do
			cm:grant_unit_to_character(lord_str, clandestine[i]);
		end
		cm:add_experience_to_units_commanded_by_character(lord_str, 4)
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_solkan_zealot") then
		for i=1, #Solkan do
			cm:grant_unit_to_character(lord_str, Solkan[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_former-artillery-officer") then
		for i=1, #Former_Artillery_Officer do
			cm:grant_unit_to_character(lord_str, Former_Artillery_Officer[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_norscan_heritage") then
		for i=1, #Norscan_Heritage do
			cm:grant_unit_to_character(lord_str, Norscan_Heritage[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_griffon-whisperer") then
		for i=1, #Griffon_Whisperer do
			cm:grant_unit_to_character(lord_str, Griffon_Whisperer[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_dwarf-ally") then
		for i=1, #Dwarf_Ally do
			cm:grant_unit_to_character(lord_str, Dwarf_Ally[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_ogre-ally") then
		for i=1, #Ogre_Ally do
			cm:grant_unit_to_character(lord_str, Ogre_Ally[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_elf-ally") then
		for i=1, #Elf_Ally do
			cm:grant_unit_to_character(lord_str, Elf_Ally[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_eastern-idealist") then
		for i=1, #Eastern_Idealist do
			cm:grant_unit_to_character(lord_str, Eastern_Idealist[i]);
		end
    elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_manann_zealot") then
		for i=1, #Manann do
			cm:grant_unit_to_character(lord_str, Manann[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_bretonnia") then
		for i=1, #Bretonnia do
			cm:grant_unit_to_character(lord_str, Bretonnia[i]);
		end	
	elseif caravan:caravan_master():character_details():has_skill("hkrul_skill_innate_mar_caravan_master_teb") then
        if vfs.exists("script/frontend/mod/cataph_teb.lua")then --you have Cataph's TEB installed! Here is a little gift for you.
            for i=1, #Cataph_Teb do
                cm:grant_unit_to_character(lord_str, Cataph_Teb[i]);
            end	
        else
            for i=1, #Teb do
                cm:grant_unit_to_character(lord_str, Teb[i]);
            end	
        end
		
	else
        for i=1, #Eastern_Idealist do
			cm:grant_unit_to_character(lord_str, Eastern_Idealist[i]);
		end
		out("*** Unknown Caravan Master ??? ***")
	end
end


function hkrul_mar_add_effectbundle(caravan)
	--local force_cqi = caravan:caravan_force():command_queue_index();
	local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
	
	cm:force_character_force_into_stance(caravan_master_lookup, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP")
	--cm:apply_effect_bundle_to_character("wh3_main_caravan_post_battle_loot_bonus_bundle",caravan:caravan_force():general_character(),-1)
end;

function hkrul_mar_recruit_starter_caravan()
	out.design("Recruit a starter caravan");
	local model = cm:model();
	local faction = cm:get_faction("wh_main_emp_marienburg")--It does not work for Egmond, and other guys shouldn't get access to it at the start
    if faction:is_human() and (cm:model():campaign_name_key() == "wh3_main_combi" or cm:model():campaign_name_key() == "cr_combi_expanded") then
        local available_caravans = 
            model:world():caravans_system():faction_caravans(faction):available_caravan_recruitment_items();
        
        if available_caravans:is_empty() then
            out.design("No caravans in the pool! Needs one at this point to start the player with one")
        else
            local temp_caravan = available_caravans:item_at(0);
            if temp_caravan:is_null_interface() then
                out.design("***Caravan is null interface***")
            end
            --Recruit the caravan
            local starter_caravan = cm:recruit_caravan(faction, temp_caravan);
            if not starter_caravan:is_null_interface() then
                cm:set_character_excluded_from_trespassing(starter_caravan:caravan_master():character(), true)
            end
            --out("Rhox Mar: this is for initial caravan")
            CampaignUI.ClearSelection();
        end;
    end;
	
end;

function hkrul_mar_initalise_end_node_values()

	--randomise the end node values
	local end_nodes = {}
    if cm:get_faction("wh_main_emp_marienburg"):is_human() then
        end_nodes = {
            ["wh3_main_combi_region_myrmidens"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_altdorf"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_arnheim"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_sjoktraken"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_karond_kar"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_bordeleaux"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_port_reaver"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_lothern"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_magritta"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_sartosa"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_miragliano"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_barak_varr"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_al_haikk"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_zandri"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_lashiek"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_sudenburg"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_fortress_of_dawn"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_tower_of_the_sun"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_fu_hung"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_dai_cheng"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_fu_chow"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_beichai"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_haichai"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_marienburg"]			=75-cm:random_number(50,0), --not going to visit here
            ["wh3_main_combi_region_bechafen"]				=75-cm:random_number(50,0)
        };
        if cm:model():campaign_name_key() == "cr_combi_expanded" then
            end_nodes["cr_combi_region_nippon_3_1"]=cm:random_number(150,60)
            end_nodes["cr_combi_region_ind_4_2"]=cm:random_number(150,60)
            end_nodes["cr_combi_region_ihan_3_1"]=cm:random_number(150,60)
            end_nodes["cr_combi_region_elithis_1_1"]=cm:random_number(150,60)
        end
    elseif cm:get_faction("ovn_mar_house_den_euwe"):is_human() then --he's starting from Cathay so the number should be the opposite
        end_nodes = {
            ["wh3_main_combi_region_myrmidens"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_altdorf"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_arnheim"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_sjoktraken"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_karond_kar"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_bordeleaux"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_port_reaver"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_lothern"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_magritta"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_sartosa"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_miragliano"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_barak_varr"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_al_haikk"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_zandri"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_lashiek"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_sudenburg"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_fortress_of_dawn"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_tower_of_the_sun"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_fu_hung"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_dai_cheng"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_fu_chow"]				=75-cm:random_number(50,0),--not going to visit here
            ["wh3_main_combi_region_beichai"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_haichai"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_marienburg"]			=cm:random_number(150,60),
            ["wh3_main_combi_region_bechafen"]				=cm:random_number(150,60)
        };
        if cm:model():campaign_name_key() == "cr_combi_expanded" then
            end_nodes["cr_combi_region_nippon_3_1"]=75-cm:random_number(50,0)
            end_nodes["cr_combi_region_ind_4_2"]=75-cm:random_number(50,0)
            end_nodes["cr_combi_region_ihan_3_1"]=75-cm:random_number(50,0)
            end_nodes["cr_combi_region_elithis_1_1"]=75-cm:random_number(50,0)
        end
    else --for apply Marienburg thing when player are neither
        end_nodes = {
            ["wh3_main_combi_region_myrmidens"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_altdorf"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_arnheim"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_sjoktraken"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_karond_kar"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_bordeleaux"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_port_reaver"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_lothern"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_magritta"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_sartosa"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_miragliano"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_barak_varr"]				=75-cm:random_number(50,0),
            ["wh3_main_combi_region_al_haikk"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_zandri"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_lashiek"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_sudenburg"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_fortress_of_dawn"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_tower_of_the_sun"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_fu_hung"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_dai_cheng"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_fu_chow"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_beichai"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_haichai"]				=cm:random_number(150,60),
            ["wh3_main_combi_region_marienburg"]			=75-cm:random_number(50,0),
            ["wh3_main_combi_region_bechafen"]				=75-cm:random_number(50,0)
        };
        if cm:model():campaign_name_key() == "cr_combi_expanded" then
            end_nodes["cr_combi_region_nippon_3_1"]=cm:random_number(150,60)
            end_nodes["cr_combi_region_ind_4_2"]=cm:random_number(150,60)
            end_nodes["cr_combi_region_ihan_3_1"]=cm:random_number(150,60)
            end_nodes["cr_combi_region_elithis_1_1"]=cm:random_number(150,60)
        end
    end
	
	--save them
	cm:set_saved_value("hkrul_mar_ivory_road_demand", end_nodes);
	local temp_end_nodes = hkrul_mar_safe_get_saved_value_ivory_road_demand()
	
	--apply the effect bundles
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val)
		hkrul_mar_adjust_end_node_value(key, val, "replace")
	end
end

function hkrul_mar_adjust_end_node_values_for_demand()
	local temp_end_nodes = hkrul_mar_safe_get_saved_value_ivory_road_demand()
	
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val.." for passive demand increase.")
		hkrul_mar_adjust_end_node_value(key, 1, "add")
	end
end


function hkrul_mar_adjust_end_node_value(region_name, value, operation)
	
	local region = cm:get_region(region_name);
	local cargo_value_bundle = cm:create_new_custom_effect_bundle("wh3_main_ivory_road_end_node_value");
	cargo_value_bundle:set_duration(0);
	
	if operation == "replace" then
		local temp_end_nodes = hkrul_mar_safe_get_saved_value_ivory_road_demand()
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);
		
		temp_end_nodes[region_name]=value;
		cm:set_saved_value("hkrul_mar_ivory_road_demand", temp_end_nodes);
		out.design("Change trade to "..value.." demand for caravans in "..region_name)
		
	elseif operation == "add" then
		local temp_end_nodes = hkrul_mar_safe_get_saved_value_ivory_road_demand()
		local old_value = temp_end_nodes[region_name];
		
		if old_value == nil then
			out.design("*******   Error in ivory road script    *********")
			return 0;
		end
		
		local new_value = math.min(old_value+value,200)
		new_value = math.max(old_value+value,-60)
		
		out.design("new value is "..new_value)
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", new_value);
		
		temp_end_nodes[region_name]=new_value;
		cm:set_saved_value("hkrul_mar_ivory_road_demand", temp_end_nodes);
		out.design("Change trade to "..new_value.." demand for caravans in "..region_name)
	end
	
	if region:has_effect_bundle("wh3_main_ivory_road_end_node_value") then
		cm:remove_effect_bundle_from_region("wh3_main_ivory_road_end_node_value", region_name);
	end;
	
	cm:apply_custom_effect_bundle_to_region(cargo_value_bundle,region);
end

function hkrul_mar_safe_get_saved_value_ivory_road_demand()
	
	local ivory_road_demand = cm:get_saved_value("hkrul_mar_ivory_road_demand");
	
	if ivory_road_demand ~= nil then
		return ivory_road_demand
	else
		hkrul_mar_initalise_end_node_values()
		ivory_road_demand = cm:get_saved_value("hkrul_mar_ivory_road_demand");
		if ivory_road_demand ~= nil then
			return ivory_road_demand
		else
			script_error("Cannot load the caravan supply/demand list")
		end
	end
end

function hkrul_mar_generate_attackers(bandit_threat, force_name)
	
	local difficulty = cm:get_difficulty(false);
	local turn_number = cm:turn_number();
	
	out.design("Generate caravan attackers for banditry: "..bandit_threat)
	
	if force_name == "daemon_incursion" then
		return random_army_manager:generate_force(force_name, 5, false), force_name;
	end
	
	if bandit_threat < 50 then
			force_name = {"wh2_main_def_dark_elves_qb1_low_a","wh2_dlc11_cst_vampire_coast_qb1_low_a", "wh_main_nor_norsca_qb1_low_a", "wh2_main_def_dark_elves_qb1_low_b", "wh2_dlc11_cst_vampire_coast_qb1_low_b", "wh_main_nor_norsca_qb1_low_b"}
            local target_force = force_name[cm:random_number(#force_name,1)]
            local enemy_faction_name = force_to_faction_name[target_force]
            out("Rhox force name: "..target_force)
            out("Rhox faction name: "..force_to_faction_name[target_force])
			return random_army_manager:generate_force(target_force, 8, false), enemy_faction_name;
		elseif bandit_threat >= 50 and bandit_threat < 70 then
			force_name = {"wh2_main_def_dark_elves_qb1_med_a","wh2_dlc11_cst_vampire_coast_qb1_med_a", "wh_main_nor_norsca_qb1_med_a", "wh2_main_def_dark_elves_qb1_med_b", "wh2_dlc11_cst_vampire_coast_qb1_med_b","wh_main_nor_norsca_qb1_med_b"}
            local target_force = force_name[cm:random_number(#force_name,1)]
            local enemy_faction_name = force_to_faction_name[target_force]
			return random_army_manager:generate_force(target_force, 11, false), enemy_faction_name;
		elseif bandit_threat >= 70 then
			force_name = {"wh2_main_def_dark_elves_qb1_high_a","wh2_dlc11_cst_vampire_coast_qb1_high_a", "wh_main_nor_norsca_qb1_high_a", "wh2_main_def_dark_elves_qb1_high_b", "wh2_dlc11_cst_vampire_coast_qb1_high_b", "wh_main_nor_norsca_qb1_high_b"}
            local target_force = force_name[cm:random_number(#force_name,1)]
            local enemy_faction_name = force_to_faction_name[target_force]
			return random_army_manager:generate_force(target_force, 14, false), enemy_faction_name;
	end
end



function hkrul_mar_is_pair_in_list(pair, list)
	for i,v in ipairs(list) do
		if (v[1] == pair[1] and v[2] == pair[2]) then
			return true
		end
	end
	return false
end


function hkrul_mar_reward_item_check(faction,region_key,caravan_master)
	
	local reward = item_data[region_key]
	local faction_key = faction:name()
	if reward == "hkrul_guzunda" or reward == "hkrul_crispijn" or reward == "hkrul_lisette" or reward == "hkrul_cross" or reward == "hkrul_pg" then --it means they're legendary heroes
        if lh_reard_check_table[faction_key][reward] ==false then
            cm:trigger_incident_with_targets(
			faction:command_queue_index(),
			region_to_incident[region_key],
			0,
			0,
			caravan_master:character():command_queue_index(),
			0,
			0,
			0
			)
            lh_reard_check_table[faction_key][reward] = true
            cm:spawn_unique_agent(faction:command_queue_index(), reward, true)
            if reward == "hkrul_lisette" then --some more stuff for Lisette
                local unique_agent = cm:get_most_recently_created_character_of_type(faction:name(), "spy", reward)--rename her
                if unique_agent then 
                    cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_lisette"), "", "", "")
                    cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                    local general_x_pos, general_y_pos = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), "wh3_main_combi_region_marienburg", false, true, 5)

                    cm:teleport_to(cm:char_lookup_str(unique_agent:cqi()), general_x_pos, general_y_pos) 
                end
            elseif reward == "hkrul_cross" then --change the name of him
                local unique_agent = cm:get_most_recently_created_character_of_type(faction:name(), "champion", reward)--rename her
                if unique_agent then 
                    cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_cross"), "", "", "")
                    cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                end
            elseif reward == "hkrul_pg" then --change the name of him
                local unique_agent = cm:get_most_recently_created_character_of_type(faction:name(), "champion", reward)--rename her
                if unique_agent then 
                    cm:change_character_custom_name(unique_agent, common:get_localised_string("land_units_onscreen_name_hkrul_pg"), "", "", "")
                    cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                end
            else  --just replenish action points
                local unique_agent = cm:get_most_recently_created_character_of_type(faction:name(), "champion", reward)--rename her
                if unique_agent then 
                    cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
                end
            end
            --cm:embed_agent_in_force(unique_agent ,caravan_military_force)
            
            local caravan_military_force = caravan_master:character():military_force()
            local caravan_military_unit_number = caravan_military_force:unit_list():num_items()
            if caravan_military_unit_number < 20 then --it has a place for a hero, if it doesn't, don't embed him
                if reward == "hkrul_lisette" then
                    --do nothing. she will spawn at the capital
                else
                    local unique_agent = cm:get_most_recently_created_character_of_type(faction:name(), "champion", reward)
                    if unique_agent then 
                        cm:embed_agent_in_force(unique_agent ,caravan_military_force)
                    end
                end
                
            end
        end
	elseif not faction:ancillary_exists(reward) then
		
		cm:trigger_incident_with_targets(
			faction:command_queue_index(),
			region_to_incident[region_key],
			0,
			0,
			caravan_master:character():command_queue_index(),
			0,
			0,
			0
			)
	end
	
	

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_lh_reard_check_table", lh_reard_check_table, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			lh_reard_check_table = cm:load_named_value("rhox_lh_reard_check_table", lh_reard_check_table, context)
		end
	end
)