#define NT_GOODBYE_COOLDOWN (20 SECONDS)

/mob/living/simple_animal/hostile/abnormality/nothing_there
	name = "一无所有"
	desc = "A wicked creature that consists of various human body parts and organs."
	icon = 'icons/mob/simple/abnormality/64x96.dmi'
	icon_state = "nothing"
	icon_living = "nothing"
	icon_dead = "nothing_dead"
	portrait = "nothing_there"
	health = 4000
	maxHealth = 4000
	attack_verb_continuous = "撕裂"
	attack_verb_simple = "撕裂"
	attack_sound = 'sound/weapons/slash.ogg'
	melee_damage_lower = 55
	melee_damage_upper = 65
	obj_damage = 100
	move_to_delay = 3
	ranged = TRUE
	stat_attack = HARD_CRIT
	status_flags = NONE
	mob_size = MOB_SIZE_LARGE
	gold_core_spawnable = NO_SPAWN

	var/saved_appearance
	var/can_act = TRUE
	var/hello_cooldown
	var/hello_cooldown_time = 6 SECONDS
	var/hello_damage = 120
	var/goodbye_cooldown
	var/goodbye_cooldown_time = 20 SECONDS
	var/goodbye_damage = 500

	var/last_heal_time = 0
	var/heal_percent_per_second = 0.0085

	var/datum/looping_sound/nothingthere_ambience/soundloop
	var/datum/looping_sound/nothingthere_heartbeat/heartbeat

	//Speaking Variables, not sure if I want to use the automated speach at the moment.
	var/heard_words = list()
	var/listen_chance = 10 // 20 for testing, 10 for base
	var/utterance = 5 // 10 for testing, 5 for base
	var/worker = null

	//PLAYABLES ATTACKS
	attack_action_types = list(
		/datum/action/cooldown/nt_goodbye,
		/datum/action/innate/abnormality_attack/toggle/nt_hello_toggle,
	)

/datum/action/cooldown/nt_goodbye
	name = "Goodbye"
	button_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "nt_goodbye"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = NT_GOODBYE_COOLDOWN //20 seconds

/datum/action/cooldown/nt_goodbye/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/nothing_there))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/nothing_there/nothing_there = owner
	StartCooldown()
	nothing_there.Goodbye()
	return TRUE

/datum/action/innate/abnormality_attack/toggle/nt_hello_toggle
	name = "Toggle Hello"
	button_icon_state = "nt_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't shoot anymore.")
	button_icon_toggle_activated = "nt_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now shoot a welcoming sonic wave.")
	button_icon_toggle_deactivated = "nt_toggle0"

/mob/living/simple_animal/hostile/abnormality/nothing_there/Initialize()
	. = ..()
	saved_appearance = appearance
	soundloop = new(list(src), FALSE)
	heartbeat = new(list(src), FALSE)

/mob/living/simple_animal/hostile/abnormality/nothing_there/Destroy()
	TransferVar(1, heard_words)
	QDEL_NULL(soundloop)
	QDEL_NULL(heartbeat)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/Moved()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(!client)
		if((goodbye_cooldown <= world.time) && prob(35))
			return Goodbye()
		if((hello_cooldown <= world.time) && prob(35))
			var/turf/target_turf = get_turf(target)
			for(var/i = 1 to 3)
				target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
			return Hello(target_turf)
	return ..()

/mob/living/simple_animal/hostile/abnormality/nothing_there/OpenFire()
	if(!can_act)
		return
	if(current_stage == 3)
		if(client)
			switch(chosen_attack)
				if(1)
					Hello(target)
			return
		if(hello_cooldown <= world.time)
			Hello(target)
		if((goodbye_cooldown <= world.time) && (get_dist(src, target) < 3))
			Goodbye()

	return

/mob/living/simple_animal/hostile/abnormality/nothing_there/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus)
	. = ..()
	if(damage < 10)
		return
	last_heal_time = world.time + 15 SECONDS // Heal delayed when taking damage; Doubled because it was a little too quick.

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/Hello(target)
	if(hello_cooldown > world.time)
		return
	hello_cooldown = world.time + hello_cooldown_time
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_cast.ogg', 75, 0, 3)
	icon_state = "nothing_ranged"
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	// Close range gives you more time to dodge
	var/hello_delay = (get_dist(src, target) <= 2) ? (1 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(hello_delay, src)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/smash_effect(TF)
			been_hit = HurtInTurf(TF, been_hit, hello_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_clash.ogg', 75, 0, 3)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/nothing_there/proc/Goodbye()
	if(goodbye_cooldown > world.time)
		return
	goodbye_cooldown = world.time + goodbye_cooldown_time
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_cast.ogg', 75, 0, 5)
	icon_state = "nothing_blade"
	SLEEP_CHECK_DEATH(8, src)
	for(var/turf/T in view(2, src))
		new /obj/effect/temp_visual/nt_goodbye(T)
		for(var/mob/living/L in HurtInTurf(T, list(), goodbye_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE, hurt_structure = TRUE))
			if(L.health < 0)
				L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 7)
	SLEEP_CHECK_DEATH(3, src)
	icon_state = icon_living
	can_act = TRUE
