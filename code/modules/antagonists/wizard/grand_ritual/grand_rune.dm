/// 需要在法阵上施法的次数以完成它
#define GRAND_RUNE_INVOKES_TO_COMPLETE 3
/// 完成法阵的每个阶段所需的基础时间.这个过程要重复三次才能完成法阵.
#define BASE_INVOKE_TIME 7 SECONDS
/// 每次完成一个法阵后，每个步骤增加的时间.
#define ADD_INVOKE_TIME 2 SECONDS

/**
 * 大仪式中使用的魔法法阵.
 * 一个巫师坐在这东西上，挥舞双手一会儿，喊着荒谬的词语.
 * 然后某些事情（通常是坏事）会发生.
 */
/obj/effect/grand_rune
	name = "大法阵"
	desc = "大小圆圈嵌套重叠，陌生文字三向罗列，线条在你眼前扭曲颤动."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "wizard_rune"
	pixel_x = -33
	pixel_y = 16
	pixel_z = -48
	anchored = TRUE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	/// 完成了多少次大仪式？
	var/potency = 0
	/// 每次法阵调用所需的时间.
	var/invoke_time = BASE_INVOKE_TIME
	/// 防止仪式点击过多.
	var/is_in_use = FALSE
	/// 此法阵已被调用的次数
	var/times_invoked = 0
	/// 你在通道中发光的颜色
	var/spell_colour = "#de3aff48"
	/// 向另一个领域献祭了多少奶酪（如果有的话）
	var/cheese_sacrificed = 0
	/// 法阵完成后留下的残余类型
	var/remains_typepath = /obj/effect/decal/cleanable/grand_remains
	/// 你在调用仪式时说的魔法词语
	var/list/magic_words = list()
	/// 你在调用法阵时可能会喊出的词语
	var/static/list/possible_magic_words = list(
		list("*scream", "*scream", "*scream"),
		list("Abra...", "Cadabra...", "Alakazam!"),
		list("Azarath!", "Metrion!", "Zinthos!!"),
		list("Bibbity!", "Bobbity!", "Boo!"),
		list("Bish", "Bash", "Bosh!"),
		list("Eenie... ", "Meenie... ", "Minie'Mo!!"),
		list("Esaelp!", "Ouy Knaht!", "Em Esucxe!!"),
		list("Fus", "Roh", "Dah!!"),
		list("git checkout origin master", "git reset --hard HEAD~2", "git push origin master --force!!"),
		list("Hocus Pocus!", "Flim Flam!", "Wabbajack!"),
		list("I wish I may...", "I wish I might...", "Have this wish I wish tonight!"),
		list("Klaatu!", "Barada!", "Nikto!!"),
		list("Let expanse contract!", "Let eon become instant!", "Throw wide the gates!!"),
		list("Levios!", "Graviole!", "Explomb!!"),
		list("Micrato", "Raepij", "Sathonich!"),
		list("Noctu!", "Orfei!", "Aude! Fraetor!"),
		list("Quas!", "Wex!", "Exort!"),
		list("Sim!", "Sala!", "Bim!"),
		list("Seven shadows cast, seven fates foretold!", "Let their words echo in your empty soul!", "Ruination is come!!"),
		list("Swiftcast! Hastega! Abjurer's Ward II! Extend IV! Tenser's Advanced Enhancement! Protection from Good! Enhance Effect III! Arcane Re...",
			"...inforcement IV! Turn Vermin X! Protection from Evil II! Mage's Shield! Venerious's Mediocre Enhancement II! Expand Power! Banish Hu...",
			"...nger II! Protection from Neutral! Surecastaga! Refresh! Refresh II! Sharpcast X! Aetherial Manipulation! Ley Line Absorption! Invoke Grand Ritual!!"),
		list("Ten!", "Chi!", "Jin!"),
		list("Ultimate School of Magic!", "Ultimate Ritual!", "Macrocosm!!"),
		list("Y-abbaa", "Dab'Bah", "Doom!!"),
	)

/// Prepare magic words and hide from silicons
/obj/effect/grand_rune/Initialize(mapload, potency = 0)
	. = ..()
	src.potency = potency
	invoke_time = get_invoke_time()
	if(!length(magic_words))
		magic_words = pick(possible_magic_words)
	var/image/silicon_image = image(icon = 'icons/effects/eldritch.dmi', icon_state = null, loc = src)
	silicon_image.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "wizard_rune", silicon_image)
	announce_rune()

/// 我释放召唤安保
/obj/effect/grand_rune/proc/announce_rune()
	var/area/created_area = get_area(src)
	if (potency >= GRAND_RITUAL_IMMINENT_FINALE_POTENCY)
		priority_announce("在[created_area.name]检测到重大异常时空波动.", "异常警报")
		return
	if (potency >= GRAND_RITUAL_RUNES_WARNING_POTENCY)
		priority_announce("在[created_area.name]检测到异常能量波动.", "异常警报")
		return

/obj/effect/grand_rune/examine(mob/user)
	. = ..()
	if (times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		. += span_notice("它的力量似乎已经耗尽.")
		return
	if(!IS_WIZARD(user))
		return
	. += span_notice("再启动此法阵[GRAND_RUNE_INVOKES_TO_COMPLETE - times_invoked]次以完成仪式.")

/obj/effect/grand_rune/can_interact(mob/living/user)
	. = ..()
	if(!.)
		return
	if(!IS_WIZARD(user))
		return FALSE
	if(is_in_use)
		return FALSE
	if (times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		return FALSE
	return TRUE

/obj/effect/grand_rune/interact(mob/living/user)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(invoke_rune), user)
	return TRUE

/// Actually does the whole invoking thing
/obj/effect/grand_rune/proc/invoke_rune(mob/living/user)
	is_in_use = TRUE
	add_channel_effect(user)
	user.balloon_alert(user, "启动法阵...")

	if(!do_after(user, invoke_time, src))
		remove_channel_effect(user)
		user.balloon_alert(user, "被打断!")
		is_in_use = FALSE
		return

	times_invoked++

	//fetch cheese on the rune
	var/list/obj/item/food/cheese/wheel/cheese_list = list()
	for(var/obj/item/food/cheese/wheel/nearby_cheese in range(1, src))
		if(HAS_TRAIT(nearby_cheese, TRAIT_HAUNTED)) //already haunted
			continue
		cheese_list += nearby_cheese
	//handle cheese sacrifice - haunt a part of all cheese on the rune with each invocation, then delete it
	var/list/obj/item/food/cheese/wheel/cheese_to_haunt = list()
	cheese_list = shuffle(cheese_list)
	//the intent here is to sacrifice cheese in parts, roughly in thirds since we invoke the rune three times
	//so hopefully this will properly do that, and on the third invocation it will just eat all remaining cheese
	cheese_to_haunt = cheese_list.Copy(1, min(round(length(cheese_list) * times_invoked * 0.4), max(length(cheese_list), 3)))
	for(var/obj/item/food/cheese/wheel/sacrifice as anything in cheese_to_haunt)
		sacrifice.AddComponent(\
			/datum/component/haunted_item, \
			haunt_color = spell_colour, \
			haunt_duration = 10 SECONDS, \
			aggro_radius = 0, \
			spawn_message = span_revenwarning("[sacrifice]开始浮起并在空中旋转，被异世界的能量包围..."), \
		)
		addtimer(CALLBACK(sacrifice, TYPE_PROC_REF(/obj/item/food/cheese/wheel, consume_cheese)), 10 SECONDS)
	cheese_sacrificed += length(cheese_to_haunt)

	user.say(magic_words[times_invoked], forced = "grand ritual invocation")
	remove_channel_effect(user)

	for(var/obj/machinery/light/light in orange(4, src.loc))
		light.flicker()

	if(times_invoked >= GRAND_RUNE_INVOKES_TO_COMPLETE)
		on_invocation_complete(user)
		return
	flick("[icon_state]_flash", src)
	playsound(src,'sound/magic/staff_animation.ogg', 75, TRUE)
	INVOKE_ASYNC(src, PROC_REF(invoke_rune), user)

/// Add special effects for casting a spell, basically you glow and hover in the air.
/obj/effect/grand_rune/proc/add_channel_effect(mob/living/user)
	user.AddElement(/datum/element/forced_gravity, 0)
	user.add_filter("channeling_glow", 2, list("type" = "outline", "color" = spell_colour, "size" = 2))

/// Remove special effects for casting a spell
/obj/effect/grand_rune/proc/remove_channel_effect(mob/living/user)
	user.RemoveElement(/datum/element/forced_gravity, 0)
	user.remove_filter("channeling_glow")

/obj/effect/grand_rune/proc/get_invoke_time()
	return  (BASE_INVOKE_TIME) + (potency * (ADD_INVOKE_TIME))

/// Called when you actually finish the damn thing
/obj/effect/grand_rune/proc/on_invocation_complete(mob/living/user)
	is_in_use = FALSE
	playsound(src,'sound/magic/staff_change.ogg', 75, TRUE)
	INVOKE_ASYNC(src, PROC_REF(summon_round_event), user) // Running the event sleeps
	trigger_side_effects()
	tear_reality()
	SEND_SIGNAL(src, COMSIG_GRAND_RUNE_COMPLETE, cheese_sacrificed)
	flick("[icon_state]_activate", src)
	addtimer(CALLBACK(src, PROC_REF(remove_rune)), 0.6 SECONDS)
	SSblackbox.record_feedback("amount", "grand_runes_invoked", 1)

/obj/effect/grand_rune/proc/remove_rune()
	new remains_typepath(get_turf(src))
	qdel(src)

/// Triggers some form of event somewhere on the station
/obj/effect/grand_rune/proc/summon_round_event(mob/living/user)
	var/list/possible_events = list()

	var/player_count = get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE)
	for(var/datum/round_event_control/possible_event as anything in SSevents.control)
		if (!possible_event.can_spawn_event(player_count, allow_magic = TRUE))
			continue
		if (possible_event.min_wizard_trigger_potency > potency)
			continue
		if (possible_event.max_wizard_trigger_potency < potency)
			continue
		possible_events += possible_event

	if (!length(possible_events))
		visible_message(span_notice("[src]发出悲伤的嗡鸣声."))
		return

	var/datum/round_event_control/final_event = pick(possible_events)
	final_event.run_event(event_cause = "大仪式法阵")
	to_chat(user, span_notice("你释放出了影响船员的魔法: [final_event.name]!"))

/// Applies some local side effects to the area
/obj/effect/grand_rune/proc/trigger_side_effects(mob/living/user)
	if (potency == 0) // Not on the first one
		return
	var/list/possible_effects = list()
	for (var/effect_path in subtypesof(/datum/grand_side_effect))
		var/datum/grand_side_effect/effect = new effect_path()
		if (!effect.can_trigger(loc))
			continue
		possible_effects += effect

	var/datum/grand_side_effect/final_effect = pick(possible_effects)
	final_effect.trigger(potency, loc, user)

/**
 * Invoking the ritual spawns up to three reality tears based on potency.
 * Each of these has a 50% chance to spawn already expended.
 */
/obj/effect/grand_rune/proc/tear_reality()
	var/max_tears = 0
	switch(potency)
		if(0 to 2)
			max_tears = 1
		if (3 to 5)
			max_tears = 2
		if (6 to 7)
			max_tears = 3

	var/to_create = rand(0, max_tears)
	if (to_create == 0)
		return
	var/created = 0
	var/location_sanity = 0
	// Copied from the influences manager, but we don't want to obey the cap on influences per heretic.
	while(created < to_create && location_sanity < 100)
		var/turf/chosen_location = get_safe_random_station_turf()

		// We don't want them close to each other - at least 1 tile of seperation
		var/list/nearby_things = range(1, chosen_location)
		var/obj/effect/heretic_influence/what_if_i_have_one = locate() in nearby_things
		var/obj/effect/visible_heretic_influence/what_if_i_had_one_but_its_used = locate() in nearby_things
		if(what_if_i_have_one || what_if_i_had_one_but_its_used)
			location_sanity++
			continue

		var/obj/effect/heretic_influence/new_influence = new(chosen_location)
		if (prob(50))
			new_influence.after_drain()
		created++

#undef GRAND_RUNE_INVOKES_TO_COMPLETE

#undef BASE_INVOKE_TIME
#undef ADD_INVOKE_TIME

/**
 * Variant rune used for the Final Ritual
 */
/obj/effect/grand_rune/finale
	/// What does the player want to do?
	var/datum/grand_finale/finale_effect
	/// Has the player chosen an outcome?
	var/chosen_effect = FALSE
	/// If we need to warn the crew, have we done so?
	var/dire_warnings_given = 0

/obj/effect/grand_rune/finale/invoke_rune(mob/living/user)
	if(!finale_effect)
		return ..()
	if (!finale_effect.dire_warning)
		return ..()
	if (dire_warnings_given != times_invoked)
		return ..()
	var/area/created_area = get_area(src)
	var/announce = null
	switch (dire_warnings_given)
		if (0)
			announce = "在:[created_area.name]发现大规模异常能量波动."
		if (1)
			announce = "自动因果稳定化失败，建议对[created_area.name]进行紧急干预."
		if (2)
			announce = "在[created_area.name]发生的局部现实故障迫在眉睫，所有船员请准备撤离."
	if (announce)
		priority_announce(announce, "异常警报")
	dire_warnings_given++
	return ..()

/obj/effect/grand_rune/finale/interact(mob/living/user)
	if (!chosen_effect)
		select_finale(user)
		return
	var/round_time_passed = world.time - SSticker.round_start_time
	if (chosen_effect && finale_effect.minimum_time >= round_time_passed)
		to_chat(user, span_warning("所选的最终仪式只能在<b>[DisplayTimeText(finale_effect.minimum_time - round_time_passed)]</b>后进行!"))
		return
	return ..()


#define PICK_NOTHING "继续"

/// Make a selection from a radial menu.
/obj/effect/grand_rune/finale/proc/select_finale(mob/living/user)
	var/list/options = list()
	var/list/picks_to_instances = list()
	for (var/typepath in subtypesof(/datum/grand_finale))
		var/datum/grand_finale/finale_type = new typepath()
		var/datum/radial_menu_choice/choice = finale_type.get_radial_choice()
		if (!choice)
			continue
		options += list("[choice.name]" = choice)
		picks_to_instances[choice.name] = finale_type

	var/datum/radial_menu_choice/choice_none = new()
	choice_none.name = PICK_NOTHING
	choice_none.image = image(icon = 'icons/mob/actions/actions_cult.dmi', icon_state = "draw")
	choice_none.info = "使用你汇聚至今的所有魔力！他们绝对想不到你已拥有何等的磅礴伟力! 要成就何等的辉煌伟业!"
	options += list("[choice_none.name]" = choice_none)

	var/pick = show_radial_menu(user, user, options, require_near = TRUE, tooltips = TRUE)
	if (!pick)
		return
	chosen_effect = TRUE
	if (pick == PICK_NOTHING)
		return
	finale_effect = picks_to_instances[pick]
	invoke_time = get_invoke_time()
	if (finale_effect.glow_colour)
		spell_colour = finale_effect.glow_colour
	add_filter("finale_picked_glow", 2, list("type" = "outline", "color" = spell_colour, "size" = 2))

/obj/effect/grand_rune/finale/summon_round_event(mob/living/user)
	user.client?.give_award(/datum/award/achievement/misc/grand_ritual_finale, user)
	if (!finale_effect)
		return ..()
	SSblackbox.record_feedback("tally", "grand_ritual_finale", 1, finale_effect)
	finale_effect.trigger(user)

/obj/effect/grand_rune/finale/get_invoke_time()
	if (!finale_effect)
		return ..()
	return finale_effect.ritual_invoke_time


/**
 * 在之前的伟大仪式中牺牲了50个或更多奶酪时生成.
 * 将代替通常的伟大仪式符文生成，其效果已经设置且无法更改.
 * 抱歉，这次无法在开放海洋上与独角鲸战斗.
 */
/obj/effect/grand_rune/finale/cheesy
	name = "特别的大法阵"
	desc = "圈圈套套中尽是疯狂的形状轮廓，仅其存在本身就对理智构成侮辱."
	icon_state = "wizard_rune_cheese"
	magic_words = list("问候！致敬！", "欢迎！现在请离开.", "离开，逃跑，或者死.")
	remains_typepath = /obj/effect/decal/cleanable/grand_remains/cheese

/obj/effect/grand_rune/finale/cheesy/Initialize(mapload, potency)
	. = ..()
	finale_effect = new /datum/grand_finale/cheese()
	chosen_effect = TRUE
	add_filter("finale_picked_glow", 2, list("type" = "outline", "color" = spell_colour, "size" = 2))


/**
 * 在我们完成符文时生成
 */
/obj/effect/decal/cleanable/grand_remains
	name = "灰烬圈"
	desc = "看起来有人在地上用灰画了奇怪的形状."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "wizard_rune_burned"
	pixel_x = -28
	pixel_y = -34
	anchored = TRUE
	mergeable_decal = FALSE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	clean_type = CLEAN_TYPE_HARD_DECAL
	layer = SIGIL_LAYER

/obj/effect/decal/cleanable/grand_remains/cheese
	name = "奶酪灰烬痕迹"
	desc = "原来，地上的奇怪形状是烧成黑焦油的奶酪皮."
	icon_state = "wizard_rune_cheese_burned"

#undef PICK_NOTHING
