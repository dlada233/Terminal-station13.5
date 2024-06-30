
/// List of all teleport runes
GLOBAL_LIST(teleport_runes)
/// Assoc list of every rune that can be drawn by ritual daggers. [rune_name] = [typepath]
GLOBAL_LIST_INIT(rune_types, generate_cult_rune_types())

/// Returns an associated list of rune types. [rune.cultist_name] = [typepath]
/proc/generate_cult_rune_types()
	RETURN_TYPE(/list)

	var/list/runes = list()
	for(var/obj/effect/rune/rune as anything in subtypesof(/obj/effect/rune))
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.cultist_name)] = rune // Uses the cultist name for displaying purposes

	return runes

/*

This file contains runes.
Runes are used by the cult to cause many different effects and are paramount to their success.
They are drawn with a ritual dagger in blood, and are distinguishable to cultists and normal crew by examining.
Fake runes can be drawn in crayon to fool people.
Runes can either be invoked by one's self or with many different cultists. Each rune has a specific incantation that the cultists will say when invoking it.


*/

/obj/effect/rune
	name = "符文"
	desc = "一组奇怪的符号，似乎是用血画的."
	anchored = TRUE
	icon = 'icons/obj/antags/cult/rune.dmi'
	icon_state = "1"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	color = RUNE_COLOR_RED

	/// The name of the rune to cultists
	var/cultist_name = "基础符文"
	/// The description of the rune shown to cultists who examine it
	var/cultist_desc = "没有任何作用的基础符文."
	/// This is said by cultists when the rune is invoked.
	var/invocation = "Aiy ele-mayo!"
	/// The amount of cultists required around the rune to invoke it.
	var/req_cultists = 1
	/// If we have a description override for required cultists to invoke
	var/req_cultists_text
	/// Used for some runes, this is for when you want a rune to not be usable when in use.
	var/rune_in_use = FALSE
	/// Used when you want to keep track of who erased the rune
	var/log_when_erased = FALSE
	/// Whether this rune can be scribed or if it's admin only / special spawned / whatever
	var/can_be_scribed = TRUE
	/// How long the rune takes to erase
	var/erase_time = 1.5 SECONDS
	/// How long the rune takes to create
	var/scribe_delay = 4 SECONDS
	/// If a rune cannot be speed boosted while scribing on certain turfs
	var/no_scribe_boost = FALSE
	/// Hhow much damage you take doing it
	var/scribe_damage = 0.1
	/// How much damage invokers take when invoking it
	var/invoke_damage = 0
	/// If constructs can invoke it
	var/construct_invoke = TRUE
	/// If the rune requires a keyword when scribed
	var/req_keyword = FALSE
	/// The actual keyword for the rune
	var/keyword
	/// Global proc to call while the rune is being created
	var/started_creating
	/// Global proc to call if the rune fails to be created
	var/failed_to_create

/obj/effect/rune/Initialize(mapload, set_keyword)
	. = ..()
	if(set_keyword)
		keyword = set_keyword
	var/image/I = image(icon = 'icons/effects/blood.dmi', icon_state = null, loc = src)
	I.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "cult_runes", I)

/obj/effect/rune/examine(mob/user)
	. = ..()
	if(IS_CULTIST(user) || user.stat == DEAD) //If they're a cultist or a ghost, tell them the effects
		. += "<b>名称:</b> [cultist_name]\n"+\
		"<b>效果:</b> [capitalize(cultist_desc)]\n"+\
		"<b>需要教徒:</b> [req_cultists_text ? "[req_cultists_text]":"[req_cultists]"]"
		if(req_keyword && keyword)
			. += "<b>关键词:</b> [keyword]"

/obj/effect/rune/attack_paw(mob/living/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/effect/rune/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!IS_CULTIST_OR_CULTIST_MOB(user))
		to_chat(user, span_warning("你无法理解[src]的文字."))
		return
	var/list/invokers = can_invoke(user)
	if(length(invokers) >= req_cultists)
		invoke(invokers)
		SSblackbox.record_feedback("tally", "cult_rune_invoke", 1, "[name]")
	else
		to_chat(user, span_danger("你需要[req_cultists - length(invokers)]位教徒相邻才能使用这个符文."))
		fail_invoke()

/obj/effect/rune/attack_animal(mob/living/user, list/modifiers)
	if(!isshade(user) && !isconstruct(user))
		return
	if(HAS_TRAIT(user, TRAIT_ANGELIC))
		to_chat(user, span_warning("你清除了符文!"))
		qdel(src)
	else if(construct_invoke || !IS_CULTIST(user)) //if you're not a cult construct we want the normal fail message
		attack_hand(user)
	else
		to_chat(user, span_warning("你无法激活符文!"))

/obj/effect/rune/proc/conceal() //for talisman of revealing/hiding
	visible_message(span_danger("[src]慢慢消失."))
	SetInvisibility(INVISIBILITY_OBSERVER, id=type)
	alpha = 100 //To help ghosts distinguish hidden runes

/obj/effect/rune/proc/reveal() //for talisman of revealing/hiding
	RemoveInvisibility(type)
	visible_message(span_danger("[src]慢慢消失!"))
	alpha = initial(alpha)

/*

There are a few different procs each rune runs through when a cultist activates it.
can_invoke() is called when a cultist activates the rune with an empty hand. If there are multiple cultists, this rune determines if the required amount is nearby.
invoke() is the rune's actual effects.
fail_invoke() is called when the rune fails, via not enough people around or otherwise. Typically this just has a generic 'fizzle' effect.
structure_check() searches for nearby cultist structures required for the invocation. Proper structures are pylons, forges, archives, and altars.

*/

/obj/effect/rune/proc/can_invoke(mob/living/user=null)
	//This proc determines if the rune can be invoked at the time. If there are multiple required cultists, it will find all nearby cultists.
	var/list/invokers = list() //people eligible to invoke the rune
	if(user)
		invokers += user
	if(req_cultists > 1 || istype(src, /obj/effect/rune/convert))
		for(var/mob/living/cultist in range(1, src))
			if(!IS_CULTIST(cultist))
				continue
			var/datum/antagonist/cult/cultist_datum = locate(/datum/antagonist/cult) in cultist.mind.antag_datums
			if(!cultist_datum.check_invoke_validity()) //We can assume there's a datum here since we can't get past the previous check otherwise.
				continue
			if(cultist == user)
				continue
			if(!cultist.can_speak(allow_mimes = TRUE))
				continue
			if(cultist.stat != CONSCIOUS)
				continue
			invokers += cultist

	return invokers

/obj/effect/rune/proc/invoke(list/invokers)
	//This proc contains the effects of the rune as well as things that happen afterwards. If you want it to spawn an object and then delete itself, have both here.
	for(var/atom/invoker in invokers)
		if(istype(invoker, /obj/item/toy/plush/narplush))
			invoker.visible_message(span_cult_italic("[src]大声尖叫!"))
			continue
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "血教祷文")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_cult_italic("[src]削弱了你的力量!"))

	do_invoke_glow()

/obj/effect/rune/proc/do_invoke_glow()
	set waitfor = FALSE
	animate(src, transform = matrix()*2, alpha = 0, time = 5, flags = ANIMATION_END_NOW) //fade out
	sleep(0.5 SECONDS)
	animate(src, transform = matrix(), alpha = 255, time = 0, flags = ANIMATION_END_NOW)

/obj/effect/rune/proc/fail_invoke()
	//This proc contains the effects of a rune if it is not invoked correctly, through either invalid wording or not enough cultists. By default, it's just a basic fizzle.
	visible_message(span_warning("标记闪出一小束红光，然后逐渐暗淡."))
	var/oldcolor = color
	color = rgb(255, 0, 0)
	animate(src, color = oldcolor, time = 5)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)

//Malformed Rune: This forms if a rune is not drawn correctly. Invoking it does nothing but hurt the user.
/obj/effect/rune/malformed
	cultist_name = "畸形的符文"
	cultist_desc = "用胡言乱语写出的无意义的符文，激活它没有任何好处."
	invocation = "Ra'sha yoka!"
	invoke_damage = 30
	can_be_scribed = FALSE

/obj/effect/rune/malformed/Initialize(mapload, set_keyword)
	. = ..()
	icon_state = "[rand(1,7)]"
	color = rgb(rand(0,255), rand(0,255), rand(0,255))

/obj/effect/rune/malformed/invoke(list/invokers)
	..()
	qdel(src)

//Rite of Offering: Converts or sacrifices a target.
/obj/effect/rune/convert
	cultist_name = "供给"
	cultist_desc = "将该符文上的不信者交给Nar'Sie，可以使他们皈依，也可以将他们献祭."
	req_cultists_text = "2名教徒用于皈依，3名教徒用于献祭."
	invocation = "Mah'weyh pleggh at e'ntrath!"
	icon_state = "3"
	color = RUNE_COLOR_OFFER
	req_cultists = 1
	rune_in_use = FALSE

/obj/effect/rune/convert/do_invoke_glow()
	return

/obj/effect/rune/convert/invoke(list/invokers)
	if(rune_in_use)
		return

	var/list/myriad_targets = list()
	for(var/mob/living/non_cultist in loc)
		if(!IS_CULTIST(non_cultist))
			myriad_targets += non_cultist

	if(!length(myriad_targets) && !try_spawn_sword())
		fail_invoke()
		return

	rune_in_use = TRUE
	visible_message(span_warning("[src] pulses blood red!"))
	color = RUNE_COLOR_DARKRED

	if(length(myriad_targets))
		var/mob/living/new_convertee = pick(myriad_targets)
		var/mob/living/first_invoker = invokers[1]
		var/datum/antagonist/cult/first_invoker_datum = first_invoker.mind.has_antag_datum(/datum/antagonist/cult)
		var/datum/team/cult/cult_team = first_invoker_datum.get_team()

		var/is_convertable = is_convertable_to_cult(new_convertee, cult_team)
		if(new_convertee.stat != DEAD && is_convertable)
			invocation = "Mah'weyh pleggh at e'ntrath!"
			..()
			do_convert(new_convertee, invokers, cult_team)

		else
			invocation = "Barhah hra zar'garis!"
			..()
			do_sacrifice(new_convertee, invokers, cult_team)

		cult_team.check_size() // Triggers the eye glow or aura effects if the cult has grown large enough relative to the crew

	else
		do_invoke_glow()

	animate(src, color = initial(color), time = 0.5 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)
	rune_in_use = FALSE
	return ..()

/obj/effect/rune/convert/proc/do_convert(mob/living/convertee, list/invokers, datum/team/cult/cult_team)
	ASSERT(convertee.mind)

	if(length(invokers) < 2)
		for(var/invoker in invokers)
			to_chat(invoker, span_warning("你至少需要两名教徒来激活符文，以使[convertee]皈依!"))
		return FALSE

	if(convertee.can_block_magic(MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY, charge_cost = 0)) //No charge_cost because it can be spammed
		for(var/invoker in invokers)
			to_chat(invoker, span_warning("有什么东西保护了[convertee]的思维!"))
		return FALSE

	var/brutedamage = convertee.getBruteLoss()
	var/burndamage = convertee.getFireLoss()
	if(brutedamage || burndamage)
		convertee.adjustBruteLoss(-(brutedamage * 0.75))
		convertee.adjustFireLoss(-(burndamage * 0.75))

	convertee.visible_message(
		span_warning("[convertee]在痛苦中挣扎 [(brutedamage || burndamage) \
			? "即使其伤口正愈合" \
			: "身下的标记发出血色光芒"]!"),
		span_cult_large("<i>AAAAAAAAAAAAAA-</i>"),
	)

	// We're not guaranteed to be a human but we'll cast here since we use it in a few branches
	var/mob/living/carbon/human/human_convertee = convertee

	if(check_holidays(APRIL_FOOLS) && prob(10))
		convertee.Paralyze(10 SECONDS)
		if(istype(human_convertee))
			human_convertee.force_say()
		convertee.say("You son of a bitch! I'm in.", forced = "That son of a bitch! They're in. (April Fools)")

	else
		convertee.Unconscious(10 SECONDS)

	new /obj/item/melee/cultblade/dagger(get_turf(src))
	convertee.mind.special_role = ROLE_CULTIST
	convertee.mind.add_antag_datum(/datum/antagonist/cult, cult_team)

	to_chat(convertee, span_cult_bold_italic("你的血液涌动. 你的头脑抽痛. 世界溶入红色. \
		你意识到一件非常非常可怕的事实. 现实的帷幕被无情地撕开，而邪恶扎下了根."))
	to_chat(convertee, span_cult_bold_italic("协助你的新同伴们进行黑暗事业. \
		你的目标就是他们的目标，而他们的目标也是你的目标. 服侍几何血尊的使命高于一切，将它带回来."))

	if(istype(human_convertee))
		human_convertee.uncuff()
		human_convertee.remove_status_effect(/datum/status_effect/speech/slurring/cult)
		human_convertee.remove_status_effect(/datum/status_effect/speech/stutter)
	if(isshade(convertee))
		convertee.icon_state = "shade_cult"
		convertee.name = convertee.real_name
	return TRUE

/obj/effect/rune/convert/proc/do_sacrifice(mob/living/sacrificial, list/invokers, datum/team/cult/cult_team)
	var/big_sac = FALSE
	if((((ishuman(sacrificial) || iscyborg(sacrificial)) && sacrificial.stat != DEAD) || cult_team.is_sacrifice_target(sacrificial.mind)) && length(invokers) < 3)
		for(var/invoker in invokers)
			to_chat(invoker, span_cult_italic("[sacrificial]与世界的太过紧密，你需要三名教徒!"))
		return FALSE

	var/signal_result = SEND_SIGNAL(sacrificial, COMSIG_LIVING_CULT_SACRIFICED, invokers, cult_team)
	if(signal_result & STOP_SACRIFICE)
		return FALSE

	if(sacrificial.mind)
		LAZYADD(GLOB.sacrificed, WEAKREF(sacrificial.mind))
		for(var/datum/objective/sacrifice/sac_objective in cult_team.objectives)
			if(sac_objective.target == sacrificial.mind)
				sac_objective.sacced = TRUE
				sac_objective.clear_sacrifice()
				sac_objective.update_explanation_text()
				big_sac = TRUE
	else
		LAZYADD(GLOB.sacrificed, WEAKREF(sacrificial))

	new /obj/effect/temp_visual/cult/sac(loc)

	if(!(signal_result & SILENCE_SACRIFICE_MESSAGE))
		for(var/invoker in invokers)
			if(big_sac)
				to_chat(invoker, span_cult_large("\"没错! 这就是我想要的! 你做得很好.\""))
				continue
			if(ishuman(sacrificial) || iscyborg(sacrificial))
				to_chat(invoker, span_cult_large("\"我接受你的祭品.\""))
			else
				to_chat(invoker, span_cult_large("\"即便如此薄礼，我也照收不误.\""))

	if(iscyborg(sacrificial))
		var/construct_class = show_radial_menu(invokers[1], sacrificial, GLOB.construct_radial_images, require_near = TRUE, tooltips = TRUE)
		if(QDELETED(sacrificial) || !construct_class)
			return FALSE
		sacrificial.grab_ghost()
		make_new_construct_from_class(construct_class, THEME_CULT, sacrificial, invokers[1], TRUE, get_turf(src))
		var/mob/living/silicon/robot/sacriborg = sacrificial
		sacrificial.log_message("作为赛博被献祭了.", LOG_GAME)
		sacriborg.mmi = null
		qdel(sacrificial)
		return TRUE

	var/obj/item/soulstone/stone = new(loc)
	if(sacrificial.mind && !HAS_TRAIT(sacrificial, TRAIT_SUICIDED))
		stone.capture_soul(sacrificial,  invokers[1], forced = TRUE)

	if(sacrificial)
		playsound(sacrificial, 'sound/magic/disintegrate.ogg', 100, TRUE)
		sacrificial.investigate_log("被血教献祭而碎尸.", INVESTIGATE_DEATHS)
		sacrificial.gib(DROP_ALL_REMAINS)

	try_spawn_sword() // after sharding and gibbing, which potentially dropped a null rod
	return TRUE

/// Tries to convert a null rod over the rune to a cult sword
/obj/effect/rune/convert/proc/try_spawn_sword()
	for(var/obj/item/nullrod/rod in loc)
		if(rod.anchored || (rod.resistance_flags & INDESTRUCTIBLE))
			continue

		var/num_slain = LAZYLEN(rod.cultists_slain)
		var/displayed_message = "[rod]发出不洁的红光并开始转变..."
		if(GET_ATOM_BLOOD_DNA_LENGTH(rod))
			displayed_message += " The blood of [num_slain] fallen cultist[num_slain == 1 ? "":"s"] is absorbed into [rod]!"

		rod.visible_message(span_cult_italic(displayed_message))
		switch(num_slain)
			if(0, 1)
				animate_spawn_sword(rod, /obj/item/melee/cultblade/dagger)
			if(2)
				animate_spawn_sword(rod, /obj/item/melee/cultblade)
			else
				animate_spawn_sword(rod, /obj/item/cult_bastard)
		return TRUE

	return FALSE

/// Does an animation of a null rod transforming into a cult sword
/obj/effect/rune/convert/proc/animate_spawn_sword(obj/item/nullrod/former_rod, new_blade_typepath)
	playsound(src, 'sound/effects/magic.ogg', 33, vary = TRUE, extrarange = SILENCED_SOUND_EXTRARANGE, frequency = 0.66)
	former_rod.anchored = TRUE
	former_rod.Shake()
	animate(former_rod, alpha = 0, transform = matrix(former_rod.transform).Scale(0.01), time = 2 SECONDS, easing = BOUNCE_EASING, flags = ANIMATION_PARALLEL)
	QDEL_IN(former_rod, 2 SECONDS)

	var/obj/item/new_blade = new new_blade_typepath(loc)
	var/matrix/blade_matrix_on_spawn = matrix(new_blade.transform)
	new_blade.name = "converted [new_blade.name]"
	new_blade.anchored = TRUE
	new_blade.alpha = 0
	new_blade.transform = matrix(new_blade.transform).Scale(0.01)
	new_blade.Shake()
	animate(new_blade, alpha = 255, transform = blade_matrix_on_spawn, time = 2 SECONDS, easing = BOUNCE_EASING, flags = ANIMATION_PARALLEL)
	addtimer(VARSET_CALLBACK(new_blade, anchored, FALSE), 2 SECONDS)

/obj/effect/rune/empower
	cultist_name = "赋能"
	cultist_desc = "允许血教以更少的成本准备更多的血魔法."
	invocation = "H'drak v'loso, mir'kanas verbot!"
	icon_state = "3"
	color = RUNE_COLOR_TALISMAN
	construct_invoke = FALSE

/obj/effect/rune/empower/invoke(list/invokers)
	. = ..()
	var/mob/living/user = invokers[1] //the first invoker is always the user
	for(var/datum/action/innate/cult/blood_magic/BM in user.actions)
		BM.Activate()

/obj/effect/rune/teleport
	cultist_name = "传送"
	cultist_desc = "将上面的所有东西扭曲到另一个对应的传送符文处."
	invocation = "Sas'so c'arta forbici!"
	icon_state = "2"
	color = RUNE_COLOR_TELEPORT
	req_keyword = TRUE
	light_power = 4
	var/obj/effect/temp_visual/cult/portal/inner_portal //The portal "hint" for off-station teleportations
	var/obj/effect/temp_visual/cult/rune_spawn/rune2/outer_portal
	var/listkey


/obj/effect/rune/teleport/Initialize(mapload, set_keyword)
	. = ..()
	var/area/A = get_area(src)
	var/locname = initial(A.name)
	listkey = set_keyword ? "[set_keyword] [locname]":"[locname]"
	LAZYADD(GLOB.teleport_runes, src)

/obj/effect/rune/teleport/Destroy()
	LAZYREMOVE(GLOB.teleport_runes, src)
	if(inner_portal)
		QDEL_NULL(inner_portal)
	if(outer_portal)
		QDEL_NULL(outer_portal)
	return ..()

/obj/effect/rune/teleport/invoke(list/invokers)
	var/mob/living/user = invokers[1] //the first invoker is always the user
	var/list/potential_runes = list()
	var/list/teleportnames = list()
	for(var/obj/effect/rune/teleport/teleport_rune as anything in GLOB.teleport_runes)
		if(teleport_rune != src && !is_away_level(teleport_rune.z))
			potential_runes[avoid_assoc_duplicate_keys(teleport_rune.listkey, teleportnames)] = teleport_rune

	if(!length(potential_runes))
		to_chat(user, span_warning("没有有效的符文可以传送!"))
		log_game("[user]激活[COORD(src)]处的传送符文失败 - 没有其他的传送符文.")
		fail_invoke()
		return

	var/turf/T = get_turf(src)
	if(is_away_level(T.z))
		to_chat(user, "<span class='cult italic'>你不在正确的纬度!</span>")
		log_game("[user]激活[COORD(src)]处的传送符文失败 - [user]在远征任务中.")
		fail_invoke()
		return

	var/input_rune_key = tgui_input_list(user, "符文传送至", "传送目的地", potential_runes) //we know what key they picked
	if(isnull(input_rune_key))
		return
	if(isnull(potential_runes[input_rune_key]))
		fail_invoke()
		return
	var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
	if(!Adjacent(user) || QDELETED(src) || user.incapacitated() || !actual_selected_rune)
		fail_invoke()
		return

	var/turf/target = get_turf(actual_selected_rune)
	if(target.is_blocked_turf(TRUE))
		to_chat(user, span_warning("目标符文被阻挡. 尝试传送过去是不明智的."))
		log_game("[user]激活[COORD(src)]处的传送符文失败 - 目的地被阻挡.")
		fail_invoke()
		return
	var/movedsomething = FALSE
	var/moveuserlater = FALSE
	var/movesuccess = FALSE
	for(var/atom/movable/A in T)
		if(istype(A, /obj/effect/dummy/phased_mob))
			continue
		if(ismob(A))
			if(!isliving(A)) //Let's not teleport ghosts and AI eyes.
				continue
			if(ishuman(A))
				new /obj/effect/temp_visual/dir_setting/cult/phase/out(T, A.dir)
				new /obj/effect/temp_visual/dir_setting/cult/phase(target, A.dir)
		if(A == user)
			moveuserlater = TRUE
			movedsomething = TRUE
			continue
		if(!A.anchored)
			movedsomething = TRUE
			if(do_teleport(A, target, channel = TELEPORT_CHANNEL_CULT))
				movesuccess = TRUE
	if(movedsomething)
		..()
		if(moveuserlater)
			if(do_teleport(user, target, channel = TELEPORT_CHANNEL_CULT))
				movesuccess = TRUE
		if(movesuccess)
			visible_message(span_warning("随着一阵急促的气流，符文上方的一切都消失了!"), null, "<i>你听见碎裂声.</i>")
			to_chat(user, span_cult("你[moveuserlater ? "的视线模糊，然后突然到了别的地方":"将符文上的一切都传走了"]."))
		else
			to_chat(user, span_cult("你[moveuserlater ? "的视线模糊，但什么都没有发生":"尝试将符文上的一切都传走，但传送失败了"]."))
		if(is_mining_level(z) && !is_mining_level(target.z)) //No effect if you stay on lavaland
			actual_selected_rune.handle_portal("lava")
		else
			var/area/A = get_area(T)
			if(initial(A.name) == "Space")
				actual_selected_rune.handle_portal("space", T)
		if(movesuccess)
			target.visible_message(span_warning("有什么东西出现在符文上，空气四散爆裂!"), null, "<i>你听到爆裂声.</i>")
	else
		fail_invoke()

/obj/effect/rune/teleport/proc/handle_portal(portal_type, turf/origin)
	var/turf/T = get_turf(src)
	close_portal() // To avoid stacking descriptions/animations
	playsound(T, 'sound/effects/portal_travel.ogg', 100, TRUE, 14)
	inner_portal = new /obj/effect/temp_visual/cult/portal(T)
	if(portal_type == "space")
		set_light_color(color)
		desc += "<br><b>出现在现实中的裂口显映出广阔黑暗的空间，点点星光分布其间...看起来不久前有东西从太空传送到这里.<br><u>虚空似乎要将你拉向[dir2text(get_dir(T, origin))]!</u></b>"
	else
		inner_portal.icon_state = "lava"
		set_light_color(LIGHT_COLOR_FIRE)
		desc += "<br><b>出现在现实中的裂口显映出一条奔流的岩浆河...看起来不久前有东西从拉瓦兰矿场传送到这里!</b>"
	outer_portal = new(T, 600, color)
	set_light_range(4)
	update_light()
	addtimer(CALLBACK(src, PROC_REF(close_portal)), 600, TIMER_UNIQUE)

/obj/effect/rune/teleport/proc/close_portal()
	QDEL_NULL(inner_portal)
	QDEL_NULL(outer_portal)
	desc = initial(desc)
	set_light_range(0)
	update_light()

//Ritual of Dimensional Rending: Calls forth the avatar of Nar'Sie upon the station.
/obj/effect/rune/narsie
	cultist_name = "Nar'Sie"
	cultist_desc = "撕裂维度的阻隔，召唤出几何血尊，需要九名教徒来激活符文."
	invocation = "TOK-LYR RQA-NAP G'OLT-ULOFT!!"
	req_cultists = 9
	icon = 'icons/effects/96x96.dmi'
	color = RUNE_COLOR_DARKRED
	icon_state = "rune_large"
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = 16
	pixel_z = -48
	scribe_delay = 50 SECONDS //how long the rune takes to create
	scribe_damage = 40.1 //how much damage you take doing it
	log_when_erased = TRUE
	no_scribe_boost = TRUE
	erase_time = 5 SECONDS
	// We're gonna do some effects with starlight and parallax to make things... spooky
	started_creating = /proc/started_narsie_summon
	failed_to_create = /proc/failed_narsie_summon
	///Has the rune been used already?
	var/used = FALSE

/obj/effect/rune/narsie/Initialize(mapload, set_keyword)
	. = ..()
	SSpoints_of_interest.make_point_of_interest(src)

/obj/effect/rune/narsie/conceal() //can't hide this, and you wouldn't want to
	return

GLOBAL_VAR_INIT(narsie_effect_last_modified, 0)
GLOBAL_VAR_INIT(narsie_summon_count, 0)
/proc/set_narsie_count(new_count)
	GLOB.narsie_summon_count = new_count
	SEND_GLOBAL_SIGNAL(COMSIG_NARSIE_SUMMON_UPDATE, GLOB.narsie_summon_count)

/// When narsie begins to be summoned, slowly dim the saturation of parallax and starlight
/proc/started_narsie_summon()
	set waitfor = FALSE

	set_narsie_count(GLOB.narsie_summon_count + 1)
	if(GLOB.narsie_summon_count > 1)
		return

	var/started = world.time
	GLOB.narsie_effect_last_modified = started

	var/starting_color = GLOB.starlight_color
	var/list/target_color = rgb2hsv(starting_color)
	target_color[2] = target_color[2] * 0.4
	target_color[3] = target_color[3] * 0.5
	var/mid_color = hsv2rgb(target_color)
	var/end_color = "#c21d57"
	for(var/i in 1 to 9)
		if(GLOB.narsie_effect_last_modified > started)
			return
		var/starlight_color = hsv_gradient(i, 1, starting_color, 3, mid_color, 6, mid_color, 9, end_color)
		set_starlight(starlight_color)
		sleep(8 SECONDS)

/// Summon failed, time to work backwards
/proc/failed_narsie_summon()
	set waitfor = FALSE
	set_narsie_count(GLOB.narsie_summon_count - 1)

	if(GLOB.narsie_summon_count > 1)
		return
	var/started = world.time
	GLOB.narsie_effect_last_modified = started
	var/starting_color = GLOB.starlight_color
	var/end_color = GLOB.base_starlight_color
	// We get 4 steps to fade in
	for(var/i in 1 to 4)
		if(GLOB.narsie_effect_last_modified > started)
			return
		var/starlight_color = BlendHSV(i / 4, starting_color, end_color)
		set_starlight(starlight_color)
		sleep(8 SECONDS)

/obj/effect/rune/narsie/invoke(list/invokers)
	if(used)
		return
	if(!is_station_level(z))
		return
	var/mob/living/user = invokers[1]
	var/datum/antagonist/cult/user_antag = user.mind.has_antag_datum(/datum/antagonist/cult, TRUE)
	var/datum/objective/eldergod/summon_objective = locate() in user_antag.cult_team.objectives
	var/area/place = get_area(src)
	if(!(place in summon_objective.summon_spots))
		to_chat(user, span_cult_large("几何血尊只能在帷幕薄弱的地方被召唤 - 比如[english_list(summon_objective.summon_spots)]!"))
		return
	if(locate(/obj/narsie) in SSpoints_of_interest.narsies)
		for(var/invoker in invokers)
			to_chat(invoker, span_warning("Nar'Sie 已经在这个维度了!"))
		log_game("[user]激活于[COORD(src)]处的Nar'Sie符文失败 - 已经召唤.")
		return

	//BEGIN THE SUMMONING
	used = TRUE
	var/datum/team/cult/cult_team = user_antag.cult_team
	if (cult_team.narsie_summoned)
		for (var/datum/mind/cultist_mind in cult_team.members)
			var/mob/living/cultist_mob = cultist_mind.current
			cultist_mob.client?.give_award(/datum/award/achievement/misc/narsupreme, cultist_mob)

	cult_team.narsie_summoned = TRUE
	..()
	sound_to_playing_players('sound/effects/dimensional_rend.ogg')
	var/turf/rune_turf = get_turf(src)
	for(var/datum/mind/cult_mind as anything in cult_team.members)
		cult_team.true_cultists += cult_mind
	sleep(4 SECONDS)
	if(src)
		color = RUNE_COLOR_RED

	var/obj/narsie/harbinger = new /obj/narsie(rune_turf) //Causes Nar'Sie to spawn even if the rune has been removed
	harbinger.start_ending_the_round()

//Rite of Resurrection: Requires a dead or inactive cultist. When reviving the dead, you can only perform one revival for every three sacrifices your cult has carried out.
/obj/effect/rune/raise_dead
	cultist_name = "复活"
	cultist_desc = "通过在符文上放置一个死亡的、无意识的或不活动的血教徒，每献祭三具身体，就会有一具血教徒身体可被修复，意识也随之唤回."
	invocation = "Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!" //Depends on the name of the user - see below
	icon_state = "1"
	color = RUNE_COLOR_MEDIUMRED

/obj/effect/rune/raise_dead/examine(mob/user)
	. = ..()
	if(IS_CULTIST(user) || user.stat == DEAD)
		. += "<b>未得报偿的献祭:</b> [LAZYLEN(GLOB.sacrificed) - GLOB.sacrifices_used]"

/obj/effect/rune/raise_dead/invoke(list/invokers)
	if(rune_in_use)
		return
	rune_in_use = TRUE
	var/mob/living/mob_to_revive
	var/list/potential_revive_mobs = list()
	var/mob/living/user = invokers[1]

	for(var/mob/living/target in loc)
		if(IS_CULTIST(target) && (target.stat == DEAD || isnull(target.client) || target.client.is_afk()))
			potential_revive_mobs += target

	if(!length(potential_revive_mobs))
		to_chat(user, "<span class='cult italic'>符文上没有死去的教徒!</span>")
		log_game("[user]于[COORD(src)]激活复活符文失败 - 没有教徒可复活.")
		fail_invoke()
		return

	if(length(potential_revive_mobs) > 1 && user.mind)
		mob_to_revive = tgui_input_list(user, "复活教徒", "复活", potential_revive_mobs)
		if(isnull(mob_to_revive))
			return
	else
		mob_to_revive = potential_revive_mobs[1]

	if(QDELETED(src) || !validness_checks(mob_to_revive, user))
		fail_invoke()
		return

	invocation = (user.name == "Herbert West") ? "To life, to life, I bring them!" : initial(invocation)// 克苏鲁神话《赫伯特•韦斯特 — 尸体复生者》Herbert West—Reanimator

	if(mob_to_revive.stat == DEAD)
		var/diff = LAZYLEN(GLOB.sacrificed) - SOULS_TO_REVIVE - GLOB.sacrifices_used
		if(diff < 0)
			to_chat(user, span_warning("你的血教必须进行[abs(diff)]或更多献祭，才能复活另一名教徒!"))
			fail_invoke()
			return
		GLOB.sacrifices_used += SOULS_TO_REVIVE
		mob_to_revive.revive(ADMIN_HEAL_ALL) //This does remove traits and such, but the rune might actually see some use because of it! //Why did you think this was a good idea

	if(!mob_to_revive.client || mob_to_revive.client.is_afk())
		set waitfor = FALSE
		var/mob/chosen_one = SSpolling.poll_ghosts_for_target("你想要扮演[span_danger(mob_to_revive.real_name)]，[span_notice("AFK的血教徒")]吗?", check_jobban = ROLE_CULTIST, role = ROLE_CULTIST, poll_time = 5 SECONDS, checked_target = mob_to_revive, alert_pic = mob_to_revive, role_name_text = "inactive cultist")
		if(chosen_one)
			to_chat(mob_to_revive.mind, "由于你长时间不活跃，你的物质形态已经被另一个灵魂接管了! 如果你想要恢复，管理员也许可以帮助你.")
			message_admins("[key_name_admin(chosen_one)]取代了AFK玩家，获得了([key_name_admin(mob_to_revive)])的控制权.")
			mob_to_revive.ghostize(FALSE)
			mob_to_revive.key = chosen_one.key
		else
			fail_invoke()
			return
	SEND_SOUND(mob_to_revive, 'sound/ambience/antag/bloodcult/bloodcult_gain.ogg')
	to_chat(mob_to_revive, span_cult_large("\"PASNAR SAVRAE YAM'TOTH. Arise.\""))
	mob_to_revive.visible_message(span_warning("[mob_to_revive]深深地吸了一口气，双眼中闪烁出红光."), \
		span_cult_large("你从虚无中醒来，你复活了!"))
	rune_in_use = FALSE
	return ..()

/obj/effect/rune/raise_dead/proc/validness_checks(mob/living/target_mob, mob/living/user)
	if(QDELETED(user))
		return FALSE
	if(!Adjacent(user) || user.incapacitated())
		return FALSE
	if(QDELETED(target_mob))
		return FALSE
	if(!(target_mob in loc))
		to_chat(user, "<span class='cult italic'>需要复活的教徒被移动了!</span>")
		log_game("[user]于[COORD(src)]的复活符文激活失败 - 复活目标被移动了.")
		return FALSE
	return TRUE

/obj/effect/rune/raise_dead/fail_invoke()
	..()
	rune_in_use = FALSE
	for(var/mob/living/cultist in loc)
		if(IS_CULTIST(cultist) && cultist.stat == DEAD)
			cultist.visible_message(span_warning("[cultist]抽搐."))

//Rite of the Corporeal Shield: When invoked, becomes solid and cannot be passed. Invoke again to undo.
/obj/effect/rune/wall
	cultist_name = "屏障"
	cultist_desc = "当激活时，创建一道无形的墙壁来阻隔通路. 通过再次激活来取消墙壁."
	invocation = "Khari'd! Eske'te tannin!"
	icon_state = "4"
	color = RUNE_COLOR_DARKRED
	///The barrier summoned by the rune when invoked. Tracked as a variable to prevent refreshing the barrier's integrity.
	var/obj/structure/emergency_shield/cult/barrier/barrier //barrier is the path and variable name.... i am not a clever man

/obj/effect/rune/wall/Destroy()
	if(barrier)
		QDEL_NULL(barrier)
	return ..()

/obj/effect/rune/wall/invoke(list/invokers)
	var/mob/living/user = invokers[1]
	..()
	if(!barrier)
		barrier = new /obj/structure/emergency_shield/cult/barrier(src.loc)
		barrier.parent_rune = src
	barrier.Toggle()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.apply_damage(2, BRUTE, pick(GLOB.arm_zones))

//Rite of Joined Souls: Summons a single cultist.
/obj/effect/rune/summon
	cultist_name = "召唤血教徒"
	cultist_desc = "召唤一名血教徒至符文上，需要两名激活者."
	invocation = "N'ath reth sh'yro eth d'rekkathnor!"
	req_cultists = 2
	invoke_damage = 10
	icon_state = "3"
	color = RUNE_COLOR_SUMMON

/obj/effect/rune/summon/invoke(list/invokers)
	var/mob/living/user = invokers[1]
	var/list/cultists = list()
	for(var/datum/mind/M as anything in get_antag_minds(/datum/antagonist/cult))
		if(!(M.current in invokers) && M.current && M.current.stat != DEAD)
			cultists |= M.current
	if(length(cultists) <= 1)
		to_chat(user, span_warning("无血教徒可召唤!"))
		fail_invoke()
		return
	var/mob/living/cultist_to_summon = tgui_input_list(user, "你想要呼唤谁至[src]?", "几何血尊追随者", cultists)
	var/fail_logmsg = "[user]于[COORD(src)]激活召唤血教徒符文失败 - "
	if(!Adjacent(user) || !src || QDELETED(src) || user.incapacitated())
		return
	if(isnull(cultist_to_summon))
		to_chat(user, "<span class='cult italic'>你需要一个召唤目标!</span>")
		fail_logmsg += "无目标."
		log_game(fail_logmsg)
		fail_invoke()
		return
	if(cultist_to_summon.stat == DEAD)
		to_chat(user, "<span class='cult italic'>[cultist_to_summon]已经死了!</span>")
		fail_logmsg += "目标已死亡."
		log_game(fail_logmsg)
		fail_invoke()
		return
	if(cultist_to_summon.pulledby || cultist_to_summon.buckled)
		to_chat(user, "<span class='cult italic'>[cultist_to_summon]被固定在原地!</span>")
		fail_logmsg += "目标被束缚."
		log_game(fail_logmsg)
		fail_invoke()
		return
	if(!IS_CULTIST(cultist_to_summon))
		to_chat(user, "<span class='cult italic'>[cultist_to_summon]不是几何血尊的追随者!</span>")
		fail_logmsg += "目标不是血教徒."
		log_game(fail_logmsg)
		fail_invoke()
		return
	if(is_away_level(cultist_to_summon.z))
		to_chat(user, "<span class='cult italic'>[cultist_to_summon]不在我们的维度中!</span>")
		fail_logmsg += "目标在远征任务中."
		log_game(fail_logmsg)
		fail_invoke()
		return
	cultist_to_summon.visible_message(span_warning("[cultist_to_summon]突然消失在一片红光中!"), \
									  "<span class='cult italic'><b>随着你被抛向空中，压倒性的眩晕袭来!</b></span>")
	..()
	visible_message(span_warning("一个朦胧的身影在[src]上成形，然后凝固成了[cultist_to_summon]!"))
	if(!do_teleport(cultist_to_summon, get_turf(src)))
		to_chat(user, span_warning("召唤[cultist_to_summon]完全失败了!"))
		fail_logmsg += "目标不符合可传送对象的标准." //catch-all term, just means they failed do_teleport somehow. The most common reasons why someone should fail to be summoned already have verbose messages.
		log_game(fail_logmsg)
		fail_invoke()
		return
	qdel(src)

//Rite of Boiling Blood: Deals extremely high amounts of damage to non-cultists nearby
/obj/effect/rune/blood_boil
	cultist_name = "血液沸腾"
	cultist_desc = "让看到该符文的不信者血液沸腾，迅速造成极大的伤害. 需要三名教徒."
	invocation = "Dedo ol'btoh!"
	icon_state = "4"
	color = RUNE_COLOR_BURNTORANGE
	light_color = LIGHT_COLOR_LAVA
	req_cultists = 3
	invoke_damage = 10
	construct_invoke = FALSE
	var/tick_damage = 25
	rune_in_use = FALSE

/obj/effect/rune/blood_boil/do_invoke_glow()
	return

/obj/effect/rune/blood_boil/invoke(list/invokers)
	if(rune_in_use)
		return
	..()
	rune_in_use = TRUE
	var/turf/T = get_turf(src)
	visible_message(span_warning("[src]发出耀眼明亮的橙光!"))
	color = "#FC9B54"
	set_light(6, 1, color)
	for(var/mob/living/target in viewers(T))
		if(!IS_CULTIST(target) && target.blood_volume)
			if(target.can_block_magic(charge_cost = 0))
				continue
			to_chat(target, span_cult_large("你血管里的血液在沸腾!"))
	animate(src, color = "#FCB56D", time = 4)
	sleep(0.4 SECONDS)
	if(QDELETED(src))
		return
	do_area_burn(T, 0.5)
	animate(src, color = "#FFDF80", time = 5)
	sleep(0.5 SECONDS)
	if(QDELETED(src))
		return
	do_area_burn(T, 1)
	animate(src, color = "#FFFDF4", time = 6)
	sleep(0.6 SECONDS)
	if(QDELETED(src))
		return
	do_area_burn(T, 1.5)
	new /obj/effect/hotspot(T)
	qdel(src)

/obj/effect/rune/blood_boil/proc/do_area_burn(turf/T, multiplier)
	set_light(6, 1, color)
	for(var/mob/living/target in viewers(T))
		if(!IS_CULTIST(target) && target.blood_volume)
			if(target.can_block_magic(charge_cost = 0))
				continue
			target.take_overall_damage(tick_damage*multiplier, tick_damage*multiplier)

//Rite of Spectral Manifestation: Summons a ghost on top of the rune as a cultist human with no items. User must stand on the rune at all times, and takes damage for each summoned ghost.
/obj/effect/rune/manifest
	cultist_name = "灵魂世界"
	cultist_desc = "显化一个几何血尊仆人的灵魂，也允许你自己化成恶鬼. 激活者自己必须一直位于符文上，并且每召唤一个灵魂自身都会受到伤害."
	invocation = "Gal'h'rfikk harfrandid mud'gib!" //how the fuck do you pronounce this
	icon_state = "7"
	invoke_damage = 10
	construct_invoke = FALSE
	color = RUNE_COLOR_DARKRED
	var/mob/living/affecting = null
	var/ghost_limit = 3
	var/ghosts = 0

/obj/effect/rune/manifest/Initialize(mapload)
	. = ..()


/obj/effect/rune/manifest/can_invoke(mob/living/user)
	if(!(user in get_turf(src)))
		to_chat(user, "<span class='cult italic'>你必须站在[src]上!</span>")
		fail_invoke()
		log_game("显化符文激活失败 - 使用者没有站在符文上")
		return list()
	if(user.has_status_effect(/datum/status_effect/cultghost))
		to_chat(user, "<span class='cult italic'>灵魂不能召唤更多灵魂!</span>")
		fail_invoke()
		log_game("显化符文激活失败 - 使用者是个灵魂")
		return list()
	return ..()

/obj/effect/rune/manifest/invoke(list/invokers)
	. = ..()
	var/mob/living/user = invokers[1]
	var/turf/T = get_turf(src)
	var/choice = tgui_alert(user, "你架起与灵界的连接...", "灵魂世界", list("显化血教徒灵魂", "自己化身成恶鬼"))
	if(choice == "显化血教徒灵魂")
		if(!is_station_level(T.z))
			to_chat(user, span_cult_italic("<b>帷幕不够脆弱，无法显现灵魂，你必须位于空间站上!</b>"))
			return
		if(ghosts >= ghost_limit)
			to_chat(user, span_cult_italic("你承受了太多的灵魂，无法召唤更多!"))
			fail_invoke()
			log_game("显化符文激活失败 - 太多生成的灵魂")
			return list()
		notify_ghosts(
			"[get_area(src)]处的显化符文已激活.",
			source = src,
			header = "显化符文",
			ghost_sound = 'sound/effects/ghost2.ogg',
		)
		var/list/ghosts_on_rune = list()
		for(var/mob/dead/observer/O in T)
			if(O.client && !is_banned_from(O.ckey, ROLE_CULTIST) && !QDELETED(src) && !(isAdminObserver(O) && (O.client.prefs.toggles & ADMIN_IGNORE_CULT_GHOST)) && !QDELETED(O))
				ghosts_on_rune += O
		if(!length(ghosts_on_rune))
			to_chat(user, span_cultitalic("[src]附近没有灵魂!"))
			fail_invoke()
			log_game("显化符文激活失败 - 附近没有灵魂")
			return list()
		var/mob/dead/observer/ghost_to_spawn = pick(ghosts_on_rune)

		// Dear god, why is /mob/living/carbon/human/cult_ghost not a simple mob or species
		// someone please fix this at some point -TimT August 2022
		var/mob/living/carbon/human/cult_ghost/new_human = new(T)
		new_human.real_name = ghost_to_spawn.real_name
		new_human.alpha = 150 //Makes them translucent
		new_human.equipOutfit(/datum/outfit/ghost_cultist) //give them armor
		new_human.apply_status_effect(/datum/status_effect/cultghost) //ghosts can't summon more ghosts
		new_human.set_invis_see(SEE_INVISIBLE_OBSERVER)
		new_human.add_traits(list(TRAIT_NOBREATH, TRAIT_PERMANENTLY_MORTAL), INNATE_TRAIT) // permanently mortal can be removed once this is a bespoke kind of mob
		ghosts++
		playsound(src, 'sound/magic/exit_blood.ogg', 50, TRUE)
		visible_message(span_warning("红雾弥漫在[src]上，几步之内...一个[new_human.gender == FEMALE ? "女":"男"]人."))
		to_chat(user, span_cult_italic("你的血流入[src]. 你必须寸步不离和强打精神来维持召唤仪式. 这会缓慢地伤害你，但肯定也..."))
		var/obj/structure/emergency_shield/cult/weak/N = new(T)
		if(ghost_to_spawn.mind && ghost_to_spawn.mind.current)
			new_human.AddComponent( \
				/datum/component/temporary_body, \
				old_mind = ghost_to_spawn.mind, \
				old_body = ghost_to_spawn.mind.current, \
			)
		new_human.key = ghost_to_spawn.key
		var/datum/antagonist/cult/created_cultist = new_human.mind?.add_antag_datum(/datum/antagonist/cult)
		created_cultist?.silent = TRUE
		to_chat(new_human, span_cult_italic("<b>你是几何血尊的仆人. Nar'Sie血教让你变成了半物质的形态，你要不惜一切代价为他们服务.</b>"))

		while(!QDELETED(src) && !QDELETED(user) && !QDELETED(new_human) && (user in T))
			if(user.stat != CONSCIOUS || HAS_TRAIT(new_human, TRAIT_CRITICAL_CONDITION))
				break
			user.apply_damage(0.1, BRUTE)
			sleep(0.1 SECONDS)

		qdel(N)
		ghosts--
		if(new_human)
			new_human.visible_message(span_warning("[new_human]突然融化成了骨头灰烬."), \
					span_cult_large("你与世界的联系消失了，你的身体随之崩溃."))
			for(var/obj/I in new_human)
				new_human.dropItemToGround(I, TRUE)
			new_human.mind?.remove_antag_datum(/datum/antagonist/cult)
			new_human.dust()

	else if(choice == "自己化身成恶鬼")
		affecting = user
		affecting.add_atom_colour(RUNE_COLOR_DARKRED, ADMIN_COLOUR_PRIORITY)
		affecting.visible_message(span_warning("[affecting]冻结了一样，发出不寻常的红光."), \
						span_cult("你看到远方的事物，一切都昭然若揭，在这样的形态下，你的声音能响彻四方，你能为整个血教标记目标."))
		var/mob/dead/observer/G = affecting.ghostize(TRUE)
		var/datum/action/innate/cult/comm/spirit/CM = new
		var/datum/action/innate/cult/ghostmark/GM = new
		G.name = "黑暗的[G.name]"
		G.color = "red"
		CM.Grant(G)
		GM.Grant(G)
		while(!QDELETED(affecting))
			if(!(affecting in T))
				user.visible_message(span_warning("一根灵质的卷须缠绕住[affecting]，将其拉回到了符文!"))
				Beam(affecting, icon_state="drainbeam", time = 2)
				affecting.forceMove(get_turf(src)) //NO ESCAPE :^)
			if(affecting.key)
				affecting.visible_message(span_warning("[affecting]慢慢放松下来，周围的光芒渐渐暗淡."), \
					span_danger("你与你的物质形态重新结合了. [src]解除了对你的控制."))
				affecting.Paralyze(40)
				break
			if(affecting.health <= 10)
				to_chat(G, span_cult_italic("你的身体不能在维持这种联系了!"))
				break
			sleep(0.5 SECONDS)
		CM.Remove(G)
		GM.Remove(G)
		affecting.remove_atom_colour(ADMIN_COLOUR_PRIORITY, RUNE_COLOR_DARKRED)
		affecting.grab_ghost()
		affecting = null
		rune_in_use = FALSE

/mob/living/carbon/human/cult_ghost/spill_organs(drop_bitflags=NONE)
	drop_bitflags &= ~DROP_BRAIN //cult ghosts never drop a brain
	. = ..()

/mob/living/carbon/human/cult_ghost/get_organs_for_zone(zone, include_children)
	. = ..()
	for(var/obj/item/organ/internal/brain/B in .) //they're not that smart, really
		. -= B


/obj/effect/rune/apocalypse
	cultist_name = "天启"
	cultist_desc = "末日的预兆. 威力会随着血教的绝望而增大，但有着一定的...副作用风险"
	invocation = "Ta'gh fara'qha fel d'amar det!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "apoc"
	pixel_x = -32
	pixel_y = 16
	pixel_z = -48
	color = RUNE_COLOR_DARKRED
	req_cultists = 3
	scribe_delay = 100

/obj/effect/rune/apocalypse/invoke(list/invokers)
	if(rune_in_use)
		return
	. = ..()

	var/area/place = get_area(src)
	var/mob/living/user = invokers[1]
	var/datum/antagonist/cult/user_antag = user.mind.has_antag_datum(/datum/antagonist/cult,TRUE)
	var/datum/objective/eldergod/summon_objective = locate() in user_antag.cult_team.objectives
	if(length(summon_objective.summon_spots) <= 1)
		to_chat(user, span_cult_large("只剩下最后一个仪式地点了 - 它必须留给最后的召唤!"))
		return
	if(!(place in summon_objective.summon_spots))
		to_chat(user, span_cult_large("天启符文将占用一个可用的仪式地点，在那里可以召唤出Nar'Sie，该符文只能在[english_list(summon_objective.summon_spots)]里被画出!"))
		return

	summon_objective.summon_spots -= place
	rune_in_use = TRUE

	var/turf/T = get_turf(src)
	new /obj/effect/temp_visual/dir_setting/curse/grasp_portal/fading(T)
	var/intensity = 0
	for(var/mob/living/M in GLOB.player_list)
		if(IS_CULTIST(M))
			intensity++
	intensity = max(60, 360 - (360*(intensity/length(GLOB.player_list) + 0.3)**2)) //significantly lower intensity for "winning" cults
	var/duration = intensity*10

	playsound(T, 'sound/magic/enter_blood.ogg', 100, TRUE)
	visible_message(span_warning("一股巨大的能量冲击波从符文中爆发出来，在此过程中将符文一并分解了!"))

	for(var/mob/living/target in range(src, 3))
		target.Paralyze(30)
	empulse(T, 0.42*(intensity), 1)

	var/list/images = list()
	var/datum/atom_hud/sec_hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
	for(var/mob/living/M in GLOB.alive_mob_list)
		if(!is_valid_z_level(T, get_turf(M)))
			continue
		if(ishuman(M))
			if(!IS_CULTIST(M))
				sec_hud.hide_from(M)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(hudFix), M), duration)
			var/image/A = image('icons/mob/nonhuman-player/cult.dmi',M,"cultist", ABOVE_MOB_LAYER)
			A.override = 1
			add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/noncult, "human_apoc", A, NONE)
			addtimer(CALLBACK(M, TYPE_PROC_REF(/atom/, remove_alt_appearance),"human_apoc",TRUE), duration)
			images += A
			SEND_SOUND(M, pick(sound('sound/ambience/antag/bloodcult/bloodcult_gain.ogg'),sound('sound/voice/ghost_whisper.ogg'),sound('sound/misc/ghosty_wind.ogg')))
		else
			var/construct = pick("wraith","artificer","juggernaut")
			var/image/B = image('icons/mob/nonhuman-player/cult.dmi',M,construct, ABOVE_MOB_LAYER)
			B.override = 1
			add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/noncult, "mob_apoc", B, NONE)
			addtimer(CALLBACK(M, TYPE_PROC_REF(/atom/, remove_alt_appearance),"mob_apoc",TRUE), duration)
			images += B
		if(!IS_CULTIST(M))
			if(M.client)
				var/image/C = image('icons/effects/cult.dmi',M,"bloodsparkles", ABOVE_MOB_LAYER)
				add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/cult, "cult_apoc", C, NONE)
				addtimer(CALLBACK(M, TYPE_PROC_REF(/atom/, remove_alt_appearance),"cult_apoc",TRUE), duration)
				images += C
		else
			to_chat(M, span_cult_large("天启符文在[place.name]被激活，该地点不再能用作召唤地点!"))
			SEND_SOUND(M, 'sound/effects/pope_entry.ogg')
	image_handler(images, duration)
	if(intensity >= 285) // Based on the prior formula, this means the cult makes up <15% of current players
		var/outcome = rand(1,100)
		switch(outcome)
			if(1 to 10)
				force_event_async(/datum/round_event_control/disease_outbreak, "天启符文")
				force_event_async(/datum/round_event_control/mice_migration, "天启符文")
			if(11 to 20)
				force_event_async(/datum/round_event_control/radiation_storm, "天启符文")

			if(21 to 30)
				force_event_async(/datum/round_event_control/brand_intelligence, "天启符文")

			if(31 to 40)
				force_event_async(/datum/round_event_control/immovable_rod, "天启符文")
				force_event_async(/datum/round_event_control/immovable_rod, "天启符文")
				force_event_async(/datum/round_event_control/immovable_rod, "天启符文")

			if(41 to 50)
				force_event_async(/datum/round_event_control/meteor_wave, "天启符文")

			if(51 to 60)
				force_event_async(/datum/round_event_control/spider_infestation, "天启符文")

			if(61 to 70)
				force_event_async(/datum/round_event_control/anomaly/anomaly_flux, "天启符文")
				force_event_async(/datum/round_event_control/anomaly/anomaly_grav, "天启符文")
				force_event_async(/datum/round_event_control/anomaly/anomaly_pyro, "天启符文")
				force_event_async(/datum/round_event_control/anomaly/anomaly_vortex, "天启符文")

			if(71 to 80)
				force_event_async(/datum/round_event_control/spacevine, "天启符文")
				force_event_async(/datum/round_event_control/grey_tide, "天启符文")

			if(81 to 100)
				force_event_async(/datum/round_event_control/portal_storm_narsie, "天启符文")

	qdel(src)

/obj/effect/rune/apocalypse/proc/image_handler(list/images, duration)
	var/end = world.time + duration
	set waitfor = 0
	while(end>world.time)
		for(var/image/I in images)
			I.override = FALSE
			animate(I, alpha = 0, time = 25, flags = ANIMATION_PARALLEL)
		sleep(3.5 SECONDS)
		for(var/image/I in images)
			animate(I, alpha = 255, time = 25, flags = ANIMATION_PARALLEL)
		sleep(2.5 SECONDS)
		for(var/image/I in images)
			if(I.icon_state != "bloodsparkles")
				I.override = TRUE
		sleep(19 SECONDS)



/proc/hudFix(mob/living/carbon/human/target)
	if(!target || !target.client)
		return
	var/obj/O = target.get_item_by_slot(ITEM_SLOT_EYES)
	if(istype(O, /obj/item/clothing/glasses/hud/security))
		var/datum/atom_hud/sec_hud = GLOB.huds[DATA_HUD_SECURITY_ADVANCED]
		sec_hud.show_to(target)
