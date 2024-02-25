/datum/mutation/human/telepathy
	name = "心灵感应"
	desc = "一种罕见的基因变异，可以让使用者与他人进行心灵交流."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>你可以在脑海中听到自己的声音回响!</span>"
	text_lose_indication = "<span class='notice'>脑海中的回声逐渐消逝.</span>"
	difficulty = 12
	power_path = /datum/action/cooldown/spell/list_target/telepathy
	instability = 10
	energy_coeff = 1
