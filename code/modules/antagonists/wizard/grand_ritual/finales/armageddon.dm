#define DOOM_SINGULARITY "singularity"
#define DOOM_TESLA "tesla"
#define DOOM_METEORS "meteors"

/// Kill yourself and probably a bunch of other people
/datum/grand_finale/armageddon
	name = "湮灭"
	desc = "我受够这伙人的不断冒犯了，哪怕牺牲自我，也要给所有人来个大的. \
		你自己无法幸存."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "legion_head"
	minimum_time = 90 MINUTES // This will probably immediately end the round if it gets finished.
	ritual_invoke_time = 60 SECONDS // Really give the crew some time to interfere with this one.
	dire_warning = TRUE
	glow_colour = "#be000048"
	/// Things to yell before you die
	var/static/list/possible_last_words = list(
		"火焰与毁灭!",
		"末末末末末末日!!",
		"HAHAHAHAHAHA!! AHAHAHAHAHAHAHAHAA!!",
		"Hee hee hee!! Hoo hoo hoo!! Ha ha haaa!!",
		"Ohohohohohoho!!",
		"尖叫畏缩吧，渺小凡人!",
		"在我荣光前颤抖!",
		"选个神开始祈祷吧!",
		"毫无用处!",
		"我存在就是上帝抛弃你的证明!",
		"上帝之所以在天堂，是因为我在人间!",
		"毁灭将至!",
		"万物臣服于我!",
	)

/datum/grand_finale/armageddon/trigger(mob/living/carbon/human/invoker)
	priority_announce(pick(possible_last_words), null, 'sound/magic/voidblink.ogg', sender_override = "[invoker.real_name]", color_override = "purple")
	var/turf/current_location = get_turf(invoker)
	invoker.gib(DROP_ALL_REMAINS)

	var/static/list/doom_options = list()
	if (!length(doom_options))
		doom_options = list(DOOM_SINGULARITY, DOOM_TESLA)
		if (!SSmapping.config.planetary)
			doom_options += DOOM_METEORS

	switch(pick(doom_options))
		if (DOOM_SINGULARITY)
			var/obj/singularity/singulo = new(current_location)
			singulo.energy = 300
		if (DOOM_TESLA)
			var/obj/energy_ball/tesla = new (current_location)
			tesla.energy = 200
		if (DOOM_METEORS)
			var/datum/dynamic_ruleset/roundstart/meteor/meteors = new()
			meteors.meteordelay = 0
			SSdynamic.execute_roundstart_rule(meteors) // Meteors will continue until morale is crushed.
			priority_announce("在空间站运行轨道上发现陨石.", "陨石警报", ANNOUNCER_METEORS)

#undef DOOM_SINGULARITY
#undef DOOM_TESLA
#undef DOOM_METEORS
