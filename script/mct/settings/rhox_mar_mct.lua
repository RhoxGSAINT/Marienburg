if not get_mct then return end
local mct = get_mct()
local mct_mod = mct:register_mod("hkrul_mar")
mct_mod:set_title("Marienburg: The Merchant Empire", true)
mct_mod:set_author("SCM")
mct_mod:set_description("Some of the options for the players want a easier game", true)

local landship = mct_mod:add_new_option("rhox_mar_additional_landship", "slider")
landship:slider_set_min_max(0, 10)
landship:slider_set_step_size(1)
landship:set_default_value(0)
landship:set_text("Additional landships Jaan will recieve", true)
landship:set_tooltip_text("Marienburg's Jaan will start with this amount of additional landships besides one he already own at the start of the game.", true)


local rebellion = mct_mod:add_new_option("rhox_mar_rebellion", "checkbox")
rebellion:set_default_value(false)
rebellion:set_text("Invalidate Jaan skill's rebellion", true)
rebellion:set_tooltip_text("AI Jaan's skill will not trigger rebellion if this option is set to true", true)


local rebellion = mct_mod:add_new_option("rhox_mar_blue_pirate", "checkbox")
rebellion:set_default_value(false)
rebellion:set_text("Kill blue pirates", true)
rebellion:set_tooltip_text("The script will kill all the blue pirates if this option is turned on. [[col:red]]They have their uses and it might cause unwanted consequences[[/col]]", true)



