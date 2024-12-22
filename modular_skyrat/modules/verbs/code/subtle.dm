#define SUBTLE_DEFAULT_DISTANCE 1
#define SUBTLE_SAME_TILE_DISTANCE 0
#define SUBTLER_TELEKINESIS_DISTANCE 7

#define SUBTLE_ONE_TILE_TEXT "1-Tile Range"
#define SUBTLE_SAME_TILE_TEXT "Same Tile"

/datum/emote/living/subtle
	key = "subtle"
	key_third_person = "subtle"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)

/datum/emote/living/subtle/run_emote(mob/user, params, type_override = null)
	if(!can_run_emote(user))
		to_chat(user, span_warning("你当前无法这样做."))
		return FALSE
	var/subtle_message
	var/subtle_emote = params
	if(SSdbcore.IsConnected() && is_banned_from(user, "emote"))
		to_chat(user, "你无法发送微表情 (被封禁).")
		return FALSE
	else if(user.client?.prefs.muted & MUTE_IC)
		to_chat(user, "你无法发送IC信息 (被禁言).")
		return FALSE
	else if(!params)
		subtle_emote = tgui_input_text(user, "输入微表情来展示.", "微表情", null, MAX_MESSAGE_LEN, TRUE)
		if(!subtle_emote)
			return FALSE
		subtle_message = subtle_emote
	else
		subtle_message = params
		if(type_override)
			emote_type = type_override

	if(!can_run_emote(user))
		to_chat(user, span_warning("你当前无法这样做."))
		return FALSE

	user.log_message(subtle_message, LOG_SUBTLE)

	var/space = should_have_space_before_emote(html_decode(subtle_emote)[1]) ? " " : ""

	subtle_message = span_emote("<b>[user]</b>[space]<i>[user.say_emphasis(subtle_message)]</i>")

	var/list/viewers = get_hearers_in_view(SUBTLE_DEFAULT_DISTANCE, user)

	var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
	if(hologram)
		viewers |= get_hearers_in_view(SUBTLE_DEFAULT_DISTANCE, hologram)

	for(var/obj/effect/overlay/holo_pad_hologram/iterating_hologram in viewers)
		if(iterating_hologram?.Impersonation?.client)
			viewers |= iterating_hologram.Impersonation

	for(var/mob/ghost as anything in GLOB.dead_mob_list)
		if((ghost.client?.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(ghost in viewers))
			ghost.show_message(subtle_message)

	for(var/mob/receiver in viewers)
		receiver.show_message(subtle_message, alt_msg = subtle_message)

	return TRUE

/*
*	SUBTLE 2: NO GHOST BOOGALOO
*/

/datum/emote/living/subtler
	key = "subtler"
	key_third_person = "subtler"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)

/datum/emote/living/subtler/run_emote(mob/user, params, type_override = null)
	if(!can_run_emote(user))
		to_chat(user, span_warning("你当前无法这样做."))
		return FALSE
	var/subtler_message
	var/subtler_emote = params
	var/target
	var/subtler_range = SUBTLE_DEFAULT_DISTANCE

	var/datum/dna/dna = user.has_dna()
	if(dna && dna?.check_mutation(/datum/mutation/human/telekinesis))
		subtler_range = SUBTLER_TELEKINESIS_DISTANCE

	if(SSdbcore.IsConnected() && is_banned_from(user, "emote"))
		to_chat(user, span_warning("你无法发送微表情 (被封禁)."))
		return FALSE
	else if(user.client?.prefs.muted & MUTE_IC)
		to_chat(user, span_warning("你无法发送IC信息 (被禁言)."))
		return FALSE
	else if(!subtler_emote)
		subtler_emote = tgui_input_text(user, "输入微表情来展示.", "微表情" , null, MAX_MESSAGE_LEN, TRUE)
		if(!subtler_emote)
			return FALSE

		var/list/in_view = get_hearers_in_view(subtler_range, user)

		var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
		if(hologram)
			in_view |= get_hearers_in_view(1, hologram)

		in_view -= GLOB.dead_mob_list
		in_view.Remove(user)

		for(var/mob/camera/ai_eye/ai_eye in in_view)
			in_view.Remove(ai_eye)

		var/list/targets = list(SUBTLE_ONE_TILE_TEXT, SUBTLE_SAME_TILE_TEXT) + in_view
		target = tgui_input_list(user, "选择一个目标", "目标选择", targets)
		if(!target)
			return FALSE

		switch(target)
			if(SUBTLE_ONE_TILE_TEXT)
				target = SUBTLE_DEFAULT_DISTANCE
			if(SUBTLE_SAME_TILE_TEXT)
				target = SUBTLE_SAME_TILE_DISTANCE
		subtler_message = subtler_emote
	else
		target = SUBTLE_DEFAULT_DISTANCE
		subtler_message = subtler_emote
		if(type_override)
			emote_type = type_override

	if(!can_run_emote(user))
		to_chat(user, span_warning("你当前无法这样做."))
		return FALSE

	user.log_message(subtler_message, LOG_SUBTLER)

	var/space = should_have_space_before_emote(html_decode(subtler_emote)[1]) ? " " : ""

	subtler_message = span_emote("<b>[user]</b>[space]<i>[user.say_emphasis(subtler_message)]</i>")

	if(istype(target, /mob))
		var/mob/target_mob = target
		user.show_message(subtler_message, alt_msg = subtler_message)
		var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
		if((get_dist(user.loc, target_mob.loc) <= subtler_range) || (hologram && get_dist(hologram.loc, target_mob.loc) <= subtler_range))
			target_mob.show_message(subtler_message, alt_msg = subtler_message)
		else
			to_chat(user, span_warning("你的微表情无法传达给目标: 太远了."))
	else if(istype(target, /obj/effect/overlay/holo_pad_hologram))
		var/obj/effect/overlay/holo_pad_hologram/hologram = target
		if(hologram.Impersonation?.client)
			hologram.Impersonation.show_message(subtler_message, alt_msg = subtler_message)
	else
		var/ghostless = get_hearers_in_view(target, user) - GLOB.dead_mob_list

		var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
		if(hologram)
			ghostless |= get_hearers_in_view(target, hologram)

		for(var/obj/effect/overlay/holo_pad_hologram/holo in ghostless)
			if(holo?.Impersonation?.client)
				ghostless |= holo.Impersonation

		for(var/mob/receiver in ghostless)
			receiver.show_message(subtler_message, alt_msg = subtler_message)

	return TRUE

/*
*	VERB CODE
*/

/mob/living/proc/subtle_keybind()
	var/message = input(src, "", "subtle") as text|null
	if(!length(message))
		return
	return subtle(message)

/mob/living/verb/subtle()
	set name = "微表情"
	set category = "IC.动作"
	if(GLOB.say_disabled)	// This is here to try to identify lag problems
		to_chat(usr, span_danger("发言已经被管理员禁止了."))
		return
	usr.emote("subtle")

/*
*	VERB CODE 2
*/

/mob/living/verb/subtler()
	set name = "微表情(反幽灵)"
	set category = "IC.动作"
	if(GLOB.say_disabled)	// This is here to try to identify lag problems
		to_chat(usr, span_danger("发言已经被管理员禁止了."))
		return
	usr.emote("subtler")

#undef SUBTLE_DEFAULT_DISTANCE
#undef SUBTLE_SAME_TILE_DISTANCE
#undef SUBTLER_TELEKINESIS_DISTANCE

#undef SUBTLE_ONE_TILE_TEXT
#undef SUBTLE_SAME_TILE_TEXT
