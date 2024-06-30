//defines the drill hat's yelling setting
#define DRILL_DEFAULT "default"
#define DRILL_SHOUTING "shouting"
#define DRILL_YELLING "yelling"
#define DRILL_CANADIAN "canadian"

//厨师
/obj/item/clothing/head/utility/chefhat
	name = "厨师帽"
	inhand_icon_state = "chefhat"
	icon_state = "chef"
	desc = "厨师长的头饰."
	strip_delay = 10
	equip_delay_other = 10
	dog_fashion = /datum/dog_fashion/head/chef
	/// 鼠标在帽子内移动时，将其移动传递给穿戴者的概率
	var/mouse_control_probability = 20
	/// 移动之间的允许时间
	COOLDOWN_DECLARE(move_cooldown)

/// 厨师帽的管理员变体，其中每个老鼠驾驶员输入都将始终传递给穿戴者
/obj/item/clothing/head/utility/chefhat/i_am_assuming_direct_control
	desc = "厨师长的头饰，仔细观察，里面似乎有数十个小杠杆、按钮、拨轮和显示屏，到底是怎么回事...？"
	mouse_control_probability = 100

/obj/item/clothing/head/utility/chefhat/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/chefhat)

/obj/item/clothing/head/utility/chefhat/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	var/mob/living/basic/new_boss = get_mouse(arrived)
	if(!new_boss)
		return
	RegisterSignal(new_boss, COMSIG_MOB_PRE_EMOTED, PROC_REF(on_mouse_emote))
	RegisterSignal(new_boss, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_mouse_moving))
	RegisterSignal(new_boss, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE, PROC_REF(on_mouse_moving))

/obj/item/clothing/head/utility/chefhat/Exited(atom/movable/gone, direction)
	. = ..()
	var/mob/living/basic/old_boss = get_mouse(gone)
	if(!old_boss)
		return
	UnregisterSignal(old_boss, list(COMSIG_MOB_PRE_EMOTED, COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOB_CLIENT_PRE_LIVING_MOVE))

/// Returns a mob stored inside a mob container, if there is one
/obj/item/clothing/head/utility/chefhat/proc/get_mouse(atom/possible_mouse)
	if (!ispickedupmob(possible_mouse))
		return
	var/obj/item/clothing/head/mob_holder/mousey_holder = possible_mouse
	return locate(/mob/living/basic) in mousey_holder.contents

/// Relays emotes emoted by your boss to the hat wearer for full immersion
/obj/item/clothing/head/utility/chefhat/proc/on_mouse_emote(mob/living/source, key, emote_message, type_override)
	SIGNAL_HANDLER
	var/mob/living/carbon/wearer = loc
	if(!wearer || wearer.incapacitated(IGNORE_RESTRAINTS))
		return
	if (!prob(mouse_control_probability))
		return COMPONENT_CANT_EMOTE
	INVOKE_ASYNC(wearer, TYPE_PROC_REF(/mob, emote), key, type_override, emote_message, FALSE)
	return COMPONENT_CANT_EMOTE

/// Relays movement made by the mouse in your hat to the wearer of the hat
/obj/item/clothing/head/utility/chefhat/proc/on_mouse_moving(mob/living/source, atom/moved_to)
	SIGNAL_HANDLER
	if (!prob(mouse_control_probability) || !COOLDOWN_FINISHED(src, move_cooldown))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE // Didn't roll well enough or on cooldown

	var/mob/living/carbon/wearer = loc
	if(!wearer || wearer.incapacitated(IGNORE_RESTRAINTS))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE // Not worn or can't move

	var/move_direction = get_dir(wearer, moved_to)
	if(!wearer.Process_Spacemove(move_direction))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE // Currently drifting in space
	if(!has_gravity() || !isturf(wearer.loc))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE // Not in a location where we can move

	step_towards(wearer, moved_to)
	var/move_delay = wearer.cached_multiplicative_slowdown
	if (ISDIAGONALDIR(move_direction))
		move_delay *= sqrt(2)
	COOLDOWN_START(src, move_cooldown, move_delay)
	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/obj/item/clothing/head/utility/chefhat/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]戴上了[src]！看起来想成为一名厨师."))
	user.say("BOOORK！", forced = "chef hat suicide")
	sleep(2 SECONDS)
	user.visible_message(span_suicide("[user]爬进了一个想象中的烤箱！"))
	user.say("BOOORK！", forced = "chef hat suicide")
	playsound(user, 'sound/machines/ding.ogg', 50, TRUE)
	return FIRELOSS

//Captain
/obj/item/clothing/head/hats/caphat
	name = "舰长帽"
	desc = "做国王的感觉真好."
	icon_state = "captain"
	inhand_icon_state = "that"
	flags_inv = 0
	armor_type = /datum/armor/hats_caphat
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/captain

//Captain: This is no longer space-worthy
/datum/armor/hats_caphat
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50
	wound = 5

/obj/item/clothing/head/hats/caphat/parade
	name = "舰长三角帽"
	desc = "只有那些具有丰富气质的舰长才会戴上它."
	icon_state = "capcap"
	dog_fashion = null

/obj/item/clothing/head/caphat/beret
	name = "舰长贝雷帽"
	desc = "为那些以时尚而闻名的舰长而设计."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#0070B7#FFCE5B"

//Head of Personnel
/obj/item/clothing/head/hats/hopcap
	name = "人事部长帽"
	icon_state = "hopcap"
	desc = "官僚管理的真正象征."
	armor_type = /datum/armor/hats_hopcap
	dog_fashion = /datum/dog_fashion/head/hop

//Chaplain
/datum/armor/hats_hopcap
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	fire = 50
	acid = 50

/obj/item/clothing/head/chaplain/nun_hood
	name = "修女兜帽"
	desc = "这个星系中最虔诚的服饰."
	icon_state = "nun_hood"
	flags_inv = HIDEHAIR
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/chaplain/habit_veil
	name = "修女面纱"
	desc = "没有废话的服装."
	icon_state = "nun_hood_alt"
	flags_inv = HIDEHAIR | HIDEEARS
	clothing_flags = SNUG_FIT // 不能被扔纸帽子撞落.

/obj/item/clothing/head/chaplain/bishopmitre
	name = "主教的礼帽"
	desc = "一顶奢华的帽子，功能上可以是通向上帝的天线，也可以是避雷针，取决于你问谁这个问题."
	icon_state = "bishopmitre"

#define CANDY_CD_TIME 2 MINUTES

//Detective
/obj/item/clothing/head/fedora/det_hat
	name = "侦探软呢帽"
	desc = "如果有这么一个人能嗅出犯罪的肮脏气味，那么他很可能就戴着这顶帽子."
	armor_type = /datum/armor/fedora_det_hat
	icon_state = "detective"
	inhand_icon_state = "det_hat"
	interaction_flags_click = NEED_DEXTERITY|NEED_HANDS|ALLOW_RESTING
	dog_fashion = /datum/dog_fashion/head/detective
	/// Path for the flask that spawns inside their hat roundstart
	var/flask_path = /obj/item/reagent_containers/cup/glass/flask/det
	/// Cooldown for retrieving precious candy corn with rmb
	COOLDOWN_DECLARE(candy_cooldown)


/datum/armor/fedora_det_hat
	melee = 25
	bullet = 5
	laser = 25
	energy = 35
	fire = 30
	acid = 50
	wound = 5


/obj/item/clothing/head/fedora/det_hat/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/small/fedora/detective)

	register_context()

	new flask_path(src)


/obj/item/clothing/head/fedora/det_hat/examine(mob/user)
	. = ..()
	. += span_notice("Alt+点击以取出一颗玉米糖.")


/obj/item/clothing/head/fedora/det_hat/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	context[SCREENTIP_CONTEXT_ALT_LMB] = "Candy Time"

	return CONTEXTUAL_SCREENTIP_SET


/// Now to solve where all these keep coming from
/obj/item/clothing/head/fedora/det_hat/click_alt(mob/user)
	if(!COOLDOWN_FINISHED(src, candy_cooldown))
	to_chat(user, span_warning("你刚刚拿了一颗玉米糖！你应该等几分钟，以免用完你的存货."))
		return CLICK_ACTION_BLOCKING

	var/obj/item/food/candy_corn/sweets = new /obj/item/food/candy_corn(src)
	user.put_in_hands(sweets)
	to_chat(user, span_notice("你从帽子里拿出一颗玉米糖."))
	COOLDOWN_START(src, candy_cooldown, CANDY_CD_TIME)

	return CLICK_ACTION_SUCCESS


#undef CANDY_CD_TIME

/obj/item/clothing/head/fedora/det_hat/minor
	flask_path = /obj/item/reagent_containers/cup/glass/flask/det/minor

///Detectives Fedora, but like Inspector Gadget. Not a subtype to not inherit candy corn stuff
/obj/item/clothing/head/fedora/inspector_hat
	name = "侦探特工软呢帽"
	desc = "只有一个人可以阻止邪恶的恶棍."
	armor_type = /datum/armor/fedora_det_hat
	icon_state = "detective"
	inhand_icon_state = "det_hat"
	dog_fashion = /datum/dog_fashion/head/detective
	interaction_flags_click = FORBID_TELEKINESIS_REACH|ALLOW_RESTING
	///prefix our phrases must begin with
	var/prefix = "go go gadget"
	///an assoc list of regex = item (like regex datum = revolver item)
	var/list/items_by_regex = list()
	///A an assoc list of regex = phrase (like regex datum = gun text)
	var/list/phrases_by_regex = list()
	///how many gadgets can we hold
	var/max_items = 4
	///items above this weight cannot be put in the hat
	var/max_weight = WEIGHT_CLASS_NORMAL

/obj/item/clothing/head/fedora/inspector_hat/Initialize(mapload)
	. = ..()
	become_hearing_sensitive(ROUNDSTART_TRAIT)
	QDEL_NULL(atom_storage)

/obj/item/clothing/head/fedora/inspector_hat/proc/set_prefix(desired_prefix)

	prefix = desired_prefix

	// Regenerated the phrases here.
	for(var/old_regex in phrases_by_regex)
		var/old_phrase = phrases_by_regex[old_regex]
		var/obj/item/old_item = items_by_regex[old_regex]
		items_by_regex -= old_regex
		phrases_by_regex -= old_regex
		set_phrase(old_phrase,old_item)

	return TRUE

/obj/item/clothing/head/fedora/inspector_hat/proc/set_phrase(desired_phrase,obj/item/associated_item)

	var/regex/phrase_regex = regex("[prefix]\[\\s\\W\]+[desired_phrase]","i")

	phrases_by_regex[phrase_regex] = desired_phrase
	items_by_regex[phrase_regex] = associated_item

	return TRUE

/obj/item/clothing/head/fedora/inspector_hat/examine(mob/user)
	. = ..()
	. += span_notice("你可以把物品放在里面，通过说出定制短语或在手中使用来取出物品！")
	. += span_notice("前缀是<b>[prefix]</b>，你可以通过 Alt+点击 更改它！\n")
	for(var/found_regex in phrases_by_regex)
		var/found_phrase = phrases_by_regex[found_regex]
		var/obj/item/found_item = items_by_regex[found_regex]
		. += span_notice("[icon2html(item, user)]你可以通过说出<b>\"[prefix] [phrase]\"</b>取出[item]！")

/obj/item/clothing/head/fedora/inspector_hat/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), message_range)
	. = ..()
	var/mob/living/carbon/wearer = loc
	if(!istype(wearer) || speaker != wearer) //if we are worn
		return

	raw_message = htmlrendertext(raw_message)

	for(var/regex/found_regex as anything in phrases_by_regex)
		if(!found_regex.Find(raw_message))
			continue
		var/obj/item/found_item = items_by_regex[found_regex]
		if(wearer.put_in_hands(found_item))
			wearer.visible_message(span_warning("[src] 将 [result] 交给了 [wearer]！"))
			. = TRUE
		else
			balloon_alert(wearer, "不能放在手中！")
			break

	return .

/obj/item/clothing/head/fedora/inspector_hat/attackby(obj/item/item, mob/user, params)
	. = ..()

	if(LAZYLEN(contents) >= max_items)
		balloon_alert(user, "已满！")
		return
	if(item.w_class > max_weight)
		balloon_alert(user, "太大了！")
		return

	var/desired_phrase = tgui_input_text(user, "激活短语是什么？", "激活短语", "gadget", max_length = 26)
	if(!desired_phrase || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return

	if(item.loc != user || !user.transferItemToLoc(item, src))
		return

	to_chat(user, span_notice("你将 [item] 安装到了 [src] 的第 [thtotext(contents.len)] 个插槽中."))
	playsound(src, 'sound/machines/click.ogg', 30, TRUE)
	set_phrase(desired_phrase,item)

	return TRUE

/obj/item/clothing/head/fedora/inspector_hat/attack_self(mob/user)
	. = ..()
	if(!length(items_by_regex))
		return CLICK_ACTION_BLOCKING
	var/list/found_items = list()
	for(var/found_regex in items_by_regex)
		found_items += items_by_regex[found_regex]
	var/obj/found_item = tgui_input_list(user, "你想移除哪个物品？", "物品移除", found_items)
	if(!found_item || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return CLICK_ACTION_BLOCKING
	user.put_in_inactive_hand(found_item)

/obj/item/clothing/head/fedora/inspector_hat/click_alt(mob/user)
	var/new_prefix = tgui_input_text(user, "新前缀是什么？", "激活前缀", prefix, max_length = 24)
	if(!new_prefix || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return CLICK_ACTION_BLOCKING
	set_prefix(new_prefix)
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/head/fedora/inspector_hat/Exited(atom/movable/gone, direction)
	. = ..()
	for(var/found_regex in items_by_regex)
		var/obj/item/found_item = items_by_regex[found_regex]
		if(gone != found_item)
			continue
		items_by_regex -= found_regex
		phrases_by_regex -= found_regex
		break

/obj/item/clothing/head/fedora/inspector_hat/atom_destruction(damage_flag)

	var/atom/atom_location = drop_location()
	for(var/found_regex in items_by_regex)
		var/obj/item/result = items_by_regex[found_regex]
		result.forceMove(atom_location)
		items_by_regex -= found_regex
		phrases_by_regex -= found_regex

	return ..()

/obj/item/clothing/head/fedora/inspector_hat/Destroy()
	QDEL_LIST_ASSOC(items_by_regex) //Anything that failed to drop gets deleted.
	return ..()

//Mime
/obj/item/clothing/head/beret
	name = "贝雷帽"
	desc = "贝雷帽，默剧演员最喜欢的头饰."
	icon_state = "beret"
	dog_fashion = /datum/dog_fashion/head/beret
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"
	flags_1 = IS_PLAYER_COLORABLE_1

//Security
/obj/item/clothing/head/hats/hos
	name = "标准安保帽"
	desc = "若有发现，请联系纳米传讯服装部门."
	armor_type = /datum/armor/hats_hos
	strip_delay = 8 SECONDS

/obj/item/clothing/head/hats/hos/cap
	name = "安保部长帽"
	desc = "配发给安保部长的耐用帽子，向安保们展示谁才是老大，尺寸看起来有点宽大了."
	icon_state = "hoscap"

/obj/item/clothing/head/hats/hos/cap/Initialize(mapload)
	. = ..()
	// Give it a little publicity
	var/static/list/slapcraft_recipe_list = list(\
		/datum/crafting_recipe/sturdy_shako,\
		)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/datum/armor/hats_hos
	melee = 40
	bullet = 30
	laser = 25
	energy = 35
	bomb = 25
	bio = 10
	fire = 50
	acid = 60
	wound = 10

/obj/item/clothing/head/hats/hos/cap/syndicate
	name = "辛迪加帽"
	desc = "一顶黑色的帽子，适合高级别的辛迪加长官."

/obj/item/clothing/head/hats/hos/shako
	name = "耐用军帽"
	desc = "戴上这个让你想对别人大喊：“趴下，给我做二十个俯卧撑！”"
	icon_state = "hosshako"
	worn_icon = 'icons/mob/large-worn-icons/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/hats/hos/beret
	name = "安保部长贝雷帽"
	desc = "适合安保部长贝雷帽，既有防护作用，也有时尚功能."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#39393f#f0cc8f"

/obj/item/clothing/head/hats/hos/beret/navyhos
	name = "安保部长正式贝雷帽"
	desc = "一顶特殊的贝雷帽，印有安保部长的标志，是卓越的象征，勇气的勋章，专业的证明."
	greyscale_colors = "#638799#f0cc8f"

/obj/item/clothing/head/hats/hos/beret/syndicate
	name = "辛迪加贝雷帽"
	desc = "一款带有厚实护甲内衬的黑色贝雷帽，时尚而耐用."

/obj/item/clothing/head/hats/warden
	name = "典狱长帽"
	desc = "这是专门发给典狱长的特制防护帽，能保护头部免受冲击."
	icon_state = "policehelm"
	armor_type = /datum/armor/hats_warden
	strip_delay = 60
	dog_fashion = /datum/dog_fashion/head/warden

/datum/armor/hats_warden
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 30
	acid = 60
	wound = 6

/obj/item/clothing/head/hats/warden/police
	name = "警官帽"
	desc = "一顶警官帽.这顶帽子强调你就是法律的化身."

/obj/item/clothing/head/hats/warden/red
	name = "典狱长帽"
	desc = "一顶红色的典狱长帽.看着它让你有想要把人长时间关在牢房里的感觉."
	icon_state = "wardenhat"
	dog_fashion = /datum/dog_fashion/head/warden_red

/obj/item/clothing/head/hats/warden/drill
	name = "典狱长军帽"
	desc = "一顶特制的装甲军帽，上面印有安全标志.采用加固织物提供防护."
	icon_state = "wardendrill"
	inhand_icon_state = null
	dog_fashion = null
	var/mode = DRILL_DEFAULT

/obj/item/clothing/head/hats/warden/drill/screwdriver_act(mob/living/carbon/human/user, obj/item/I)
	if(..())
		return TRUE
	switch(mode)
		if(DRILL_DEFAULT)
			to_chat(user, span_notice("你将语音回路设置为中间位置."))
			mode = DRILL_SHOUTING
		if(DRILL_SHOUTING)
			to_chat(user, span_notice("你将语音回路设置为最后位置."))
			mode = DRILL_YELLING
		if(DRILL_YELLING)
			to_chat(user, span_notice("你将语音回路设置为第一个位置."))
			mode = DRILL_DEFAULT
		if(DRILL_CANADIAN)
			to_chat(user, span_danger("你调整了语音回路，但没有任何反应，可能是因为它坏了."))
	return TRUE

/obj/item/clothing/head/hats/warden/drill/wirecutter_act(mob/living/user, obj/item/I)
	..()
	if(mode != DRILL_CANADIAN)
		to_chat(user, span_danger("你搞坏了语音回路！"))
		mode = DRILL_CANADIAN
	return TRUE

/obj/item/clothing/head/hats/warden/drill/equipped(mob/M, slot)
	. = ..()
	if (slot & ITEM_SLOT_HEAD)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/hats/warden/drill/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/head/hats/warden/drill/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		switch (mode)
			if(DRILL_SHOUTING)
				message += "!"
			if(DRILL_YELLING)
				message += "!!"
			if(DRILL_CANADIAN)
				message = "[message]"
				var/list/canadian_words = strings("canadian_replacement.json", "canadian")

				for(var/key in canadian_words)
					var/value = canadian_words[key]
					if(islist(value))
						value = pick(value)

					message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
					message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
					message = replacetextEx(message, " [key]", " [value]")

				if(prob(30))
					message += pick(", eh?", ", EH?")
		speech_args[SPEECH_MESSAGE] = message

/obj/item/clothing/head/beret/sec
	name = "安保贝雷帽"
	desc = "一款坚固的贝雷帽，上面印有安保标志，采用加固织物提供防护."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#a52f29#F2F2F2"
	armor_type = /datum/armor/cosmetic_sec
	strip_delay = 60
	dog_fashion = null
	flags_1 = NONE

/datum/armor/cosmetic_sec
	melee = 30
	bullet = 25
	laser = 25
	energy = 35
	bomb = 25
	fire = 20
	acid = 50
	wound = 4

/obj/item/clothing/head/beret/sec/navywarden
	name = "典狱长贝雷帽"
	desc = "一顶特制的贝雷帽，上面印有典狱长标志.适合有品位的典狱长."
	greyscale_colors = "#638799#ebebeb"
	strip_delay = 60

/obj/item/clothing/head/beret/sec/navyofficer
	desc = "一顶特制的贝雷帽，上面印有保安的标志.适合有品位的警官."
	greyscale_colors = "#638799#a52f29"

//Science
/obj/item/clothing/head/beret/science
	name = "科研贝雷帽"
	desc = "一款科研风格的贝雷帽，为我们辛勤工作的科学家设计."
	greyscale_colors = "#8D008F"
	flags_1 = NONE

/obj/item/clothing/head/beret/science/rd
	desc = "上面别有代表研究主管的紫色徽章，满足你内心的官迷情结！"
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#7e1980#c9cbcb"

//Medical
/obj/item/clothing/head/beret/medical
	name = "医疗贝雷帽"
	desc = "一款医疗风格的贝雷帽，适合你的医生身份！"
	greyscale_colors = COLOR_WHITE
	flags_1 = NONE

/obj/item/clothing/head/beret/medical/paramedic
	name = "急救员贝雷帽"
	desc = "以时尚的方式找到尸体！"
	greyscale_colors = "#16313D"

/obj/item/clothing/head/beret/medical/cmo
	name = "首席医疗官贝雷帽"
	desc = "一款独特的外科蓝贝雷帽！"
	greyscale_colors = "#5EB8B8"

/obj/item/clothing/head/utility/surgerycap
	name = "蓝色手术帽"
	icon_state = "surgicalcap"
	desc = "蓝色的手术帽，可以防止外科医生的头发进入病人的体内！"
	flags_inv = HIDEHAIR //Cover your head doctor!
	w_class = WEIGHT_CLASS_SMALL //surgery cap can be easily crumpled

/obj/item/clothing/head/utility/surgerycap/attack_self(mob/user)
	. = ..()
	if(.)
		return
	balloon_alert(user, "[flags_inv & HIDEHAIR ? "放松" : "收紧"] 了绳子...")
	if(!do_after(user, 3 SECONDS, src))
		return
	flags_inv ^= HIDEHAIR
	balloon_alert(user, "[flags_inv & HIDEHAIR ? "收紧" : "放松"] 了绳子")
	return TRUE

/obj/item/clothing/head/utility/surgerycap/examine(mob/user)
	. = ..()
	. += span_notice("在手术使用以[flags_inv & HIDEHAIR ? "放松" : "收紧"]绳子.")

/obj/item/clothing/head/utility/surgerycap/purple
	name = "酒红色手术帽"
	icon_state = "surgicalcapwine"
	desc = "一款酒红色的外科手术帽，可以防止外科医生的头发进入病人的体内！"

/obj/item/clothing/head/utility/surgerycap/green
	name = "绿色手术帽"
	icon_state = "surgicalcapgreen"
	desc = "一款绿色的外科手术帽，可以防止外科医生的头发进入病人的体内！"

/obj/item/clothing/head/utility/surgerycap/cmo
	name = "青绿色手术帽"
	icon_state = "surgicalcapcmo"
	desc = "首席医疗官的外科手术帽，可以防止他们的头发进入病人的体内！"

/obj/item/clothing/head/utility/surgerycap/black
	name = "黑色手术帽"
	icon_state = "surgicalcapblack"
	desc = "一款黑色的外科手术帽，可以防止外科医生的头发进入病人的体内！"

/obj/item/clothing/head/utility/head_mirror
	name = "头戴式反光镜"
	desc = "医生用来观察病人的眼睛、耳朵和嘴巴的工具.\
		现在有了更先进的技术，所以这个工具没什么用处了，但它确实能装点外观."
	icon_state = "headmirror"
	body_parts_covered = NONE

/obj/item/clothing/head/utility/head_mirror/examine(mob/user)
	. = ..()
	. += span_notice("在光线充足的房间里，你可以使用这个工具更仔细地观察人们的眼睛、耳朵和嘴巴.")

/obj/item/clothing/head/utility/head_mirror/equipped(mob/living/user, slot)
	. = ..()
	if(slot & slot_flags)
		RegisterSignal(user, COMSIG_MOB_EXAMINING_MORE, PROC_REF(examining))
	else
		UnregisterSignal(user, COMSIG_MOB_EXAMINING_MORE)

/obj/item/clothing/head/utility/head_mirror/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_EXAMINING_MORE)

/obj/item/clothing/head/utility/head_mirror/proc/examining(mob/living/examiner, atom/examining, list/examine_list)
	SIGNAL_HANDLER
	if(!ishuman(examining) || examining == examiner || examiner.is_blind() || !examiner.Adjacent(examining))
		return
	var/mob/living/carbon/human/human_examined = examining
	if(!human_examined.get_bodypart(BODY_ZONE_HEAD))
		return
	if(!examiner.has_light_nearby())
		examine_list += span_warning("你试图使用你的[name]更仔细地检查[examining]的头部...但是太暗了.应该假装一个头灯的.")
		return
	if(examiner.dir == examining.dir) // 禁止从后面检查 - 其他方向都可以
		examine_list += span_warning("你试图使用你的[name]更仔细地检查[examining]的头部...但是病人没有面朝你.")
		return

	var/list/final_message = list("你用[name]更仔细地检查了[examining]的头部，你注意到[examining.p_have()]...")
	if(human_examined.is_mouth_covered())
		final_message += "\t你看不到病人的嘴."
	else
		var/obj/item/organ/internal/tongue/has_tongue = human_examined.get_organ_slot(ORGAN_SLOT_TONGUE)
		var/pill_count = 0
		for(var/datum/action/item_action/hands_free/activate_pill/pill in human_examined.actions)
			pill_count++

		if(pill_count >= 1 && has_tongue)
			final_message += "\t病人的嘴里有[pill_count]颗药片，以及一个[has_tongue]."
		else if(pill_count >= 1)
			final_message += "\t病人的嘴里有[pill_count]颗药片，但是没有舌头."
		else if(has_tongue)
			final_message += "\t[has_tongue]在病人的嘴里 - 搞不懂."
		else
			final_message += "\t奇怪的是，病人的嘴里没有舌头."

	if(human_examined.is_ears_covered())
		final_message += "\t你看不到病人的耳朵."
	else
		var/obj/item/organ/internal/ears/has_ears = human_examined.get_organ_slot(ORGAN_SLOT_EARS)
		if(has_ears)
			if(has_ears.deaf)
				final_message += "\t病人的耳膜受损."
			else
				final_message += "\t一对[has_ears.damage ? "" : "健康的 "][has_ears.name]."
		else
			final_message += "\t没有耳膜和空的耳道...多么奇怪."

	if(human_examined.is_eyes_covered())
		final_message += "\t你看不到病人的眼睛."
	else
		var/obj/item/organ/internal/eyes/has_eyes = human_examined.get_organ_slot(ORGAN_SLOT_EYES)
		if(has_eyes)
			final_message += "\t一双[has_eyes.damage ? "" : "健康的 "][has_eyes.name]."
		else
			final_message += "\t空的眼眶."

	examine_list += span_notice("<i>[jointext(final_message, "\n")]</i>")

// 工程
/obj/item/clothing/head/beret/engi
	name = "工程贝雷帽"
	desc = "也许不能保护你免受辐射，但绝对能保护你成土狗！"
	greyscale_colors = "#FFBC30"
	flags_1 = NONE

// 货仓
/obj/item/clothing/head/beret/cargo
	name = "货仓贝雷帽"
	desc = "当你可以戴上这顶贝雷帽时，就不需要报酬了！"
	greyscale_colors = "#b7723d"
	flags_1 = NONE

// 馆长
/obj/item/clothing/head/fedora/curator
	name = "宝藏猎人软呢帽"
	desc = "虽然今天你得到了red text，但这并不意味着你就会喜欢它."
	icon_state = "curator"

/obj/item/clothing/head/beret/durathread
	name = "杜拉棉贝雷帽"
	desc = "由杜拉棉制成的贝雷帽，其坚韧的纤维为佩戴者提供了一些保护."
	icon_state = "beret_badge"
	icon_preview = 'icons/obj/fluff/previews.dmi'
	icon_state_preview = "beret_durathread"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#C5D4F3#ECF1F8"
	armor_type = /datum/armor/beret_durathread

/datum/armor/beret_durathread
	melee = 15
	bullet = 5
	laser = 15
	energy = 25
	bomb = 10
	fire = 30
	acid = 5
	wound = 4

/obj/item/clothing/head/beret/highlander
	desc = "那是白色的织物.<i>是的.</i>"
	dog_fashion = null // 这是用于屠宰，而不是小狗

/obj/item/clothing/head/beret/highlander/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER_TRAIT)

// 中央指挥部
/obj/item/clothing/head/beret/centcom_formal
	name = "\improper 中央指挥部正式贝雷帽"
	desc = "时尚与实用时常不可兼得，但好在因纳米传讯最近的纳米织物耐用性提升，这次情况并非如此."
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#46b946#f2c42e"
	armor_type = /datum/armor/beret_centcom_formal
	strip_delay = 10 SECONDS


#undef DRILL_DEFAULT
#undef DRILL_SHOUTING
#undef DRILL_YELLING
#undef DRILL_CANADIAN

/datum/armor/beret_centcom_formal
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 100
	acid = 90
	wound = 10

// 独立民兵
/obj/item/clothing/head/beret/militia
	name = "\improper 义勇兵贝雷帽"
	desc = "这是Spinward星区人民的战斗之声，穿戴这个的英雄们会将挡住来自银河系恐怖侵袭，一分钟就是他们是响应时间！"
	icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#43523d#a2abb0"
	armor_type = /datum/armor/cosmetic_sec
