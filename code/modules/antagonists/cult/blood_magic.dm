/// how many units of blood one charge of blood rites is worth
#define USES_TO_BLOOD 2
/// blood rites charges gained from sapping blood from a victim
#define BLOOD_DRAIN_GAIN 50
/// penalty for self healing, 1 point of damage * this # = charges required
#define SELF_HEAL_PENALTY 1.65

/datum/action/innate/cult/blood_magic //Blood magic handles the creation of blood spells (formerly talismans)
	name = "准备血魔法"
	button_icon_state = "carve"
	desc = "通过在肉体上划刻符文来准备血魔法，使用<b>赋能符文</b>会很容易做到."
	default_button_position = DEFAULT_BLOODSPELLS
	var/list/spells = list()
	var/channeling = FALSE

/datum/action/innate/cult/blood_magic/Remove()
	for(var/X in spells)
		qdel(X)
	..()

/datum/action/innate/cult/blood_magic/IsAvailable(feedback = FALSE)
	if(!IS_CULTIST(owner))
		return FALSE
	return ..()

/datum/action/innate/cult/blood_magic/proc/Positioning()
	for(var/datum/hud/hud as anything in viewers)
		var/our_view = hud.mymob?.canon_client?.view || "15x15"
		var/atom/movable/screen/movable/action_button/button = viewers[hud]
		var/position = screen_loc_to_offset(button.screen_loc)
		var/list/position_list = list()
		for(var/possible_position in 1 to MAX_BLOODCHARGE)
			position_list += possible_position
		for(var/datum/action/innate/cult/blood_spell/blood_spell in spells)
			if(blood_spell.positioned)
				position_list.Remove(blood_spell.positioned)
				continue
			var/atom/movable/screen/movable/action_button/moving_button = blood_spell.viewers[hud]
			if(!moving_button)
				continue
			var/first_available_slot = position_list[1]
			var/our_x = position[1] + first_available_slot * world.icon_size // Offset any new buttons into our list
			hud.position_action(moving_button, offset_to_screen_loc(our_x, position[2], our_view))
			blood_spell.positioned = first_available_slot

/datum/action/innate/cult/blood_magic/Activate()
	var/rune = FALSE
	var/limit = RUNELESS_MAX_BLOODCHARGE
	for(var/obj/effect/rune/empower/R in range(1, owner))
		rune = TRUE
		break
	if(rune)
		limit = MAX_BLOODCHARGE
	if(length(spells) >= limit)
		if(rune)
			to_chat(owner, span_cultitalic("你无法储存超过[MAX_BLOODCHARGE]个法术. <b>选择一个法术来移除.</b>"))
		else
			to_chat(owner, span_cultitalic("<b><u>没有赋能符文的情况下你无法储存超过[RUNELESS_MAX_BLOODCHARGE]个法术!选择一个法术来移除.</b></u>"))
		var/nullify_spell = tgui_input_list(owner, "移除法术", "当前法术", spells)
		if(isnull(nullify_spell))
			return
		qdel(nullify_spell)
	var/entered_spell_name
	var/datum/action/innate/cult/blood_spell/BS
	var/list/possible_spells = list()
	for(var/I in subtypesof(/datum/action/innate/cult/blood_spell))
		var/datum/action/innate/cult/blood_spell/J = I
		var/cult_name = initial(J.name)
		possible_spells[cult_name] = J
	possible_spells += "(移除法术)"
	entered_spell_name = tgui_input_list(owner, "准备血魔法", "选择法术", possible_spells)
	if(isnull(entered_spell_name))
		return
	if(entered_spell_name == "(移除法术)")
		var/nullify_spell = tgui_input_list(owner, "移除法术", "当前法术", spells)
		if(isnull(nullify_spell))
			return
		qdel(nullify_spell)
	BS = possible_spells[entered_spell_name]
	if(QDELETED(src) || owner.incapacitated() || !BS || (rune && !(locate(/obj/effect/rune/empower) in range(1, owner))) || (length(spells) >= limit))
		return
	to_chat(owner,span_warning("你开始在肉身上刻下不自然的符号!"))
	SEND_SOUND(owner, sound('sound/weapons/slice.ogg',0,1,10))
	if(!channeling)
		channeling = TRUE
	else
		to_chat(owner, span_cult_italic("你已经可以施展血魔法了!"))
		return
	if(do_after(owner, 100 - rune*60, target = owner))
		if(ishuman(owner))
			var/mob/living/carbon/human/human_owner = owner
			human_owner.bleed(40 - rune*32)
		var/datum/action/innate/cult/blood_spell/new_spell = new BS(owner.mind)
		new_spell.Grant(owner, src)
		spells += new_spell
		Positioning()
		to_chat(owner, span_warning("力量从你的伤口上渗出，你已经准备好了施展[new_spell.name]!"))
	channeling = FALSE

/datum/action/innate/cult/blood_spell //The next generation of talismans, handles storage/creation of blood magic
	name = "血魔法"
	button_icon_state = "telerune"
	desc = "畏惧上古之血."
	var/charges = 1
	var/magic_path = null
	var/obj/item/melee/blood_magic/hand_magic
	var/datum/action/innate/cult/blood_magic/all_magic
	var/base_desc //To allow for updating tooltips
	var/invocation
	var/health_cost = 0
	/// Have we already been positioned into our starting location?
	var/positioned = FALSE
	/// If false, the spell will not delete after running out of charges
	var/deletes_on_empty = TRUE

/datum/action/innate/cult/blood_spell/Grant(mob/living/owner, datum/action/innate/cult/blood_magic/BM)
	if(health_cost)
		desc += "<br>每次使用对你的手臂造成<u>[health_cost]伤害</u>."
	base_desc = desc
	desc += "<br><b><u>还能使用[charges]次</u></b>."
	all_magic = BM
	return ..()

/datum/action/innate/cult/blood_spell/Remove()
	if(all_magic)
		all_magic.spells -= src
	if(hand_magic)
		qdel(hand_magic)
		hand_magic = null
	..()

/datum/action/innate/cult/blood_spell/IsAvailable(feedback = FALSE)
	if(!IS_CULTIST(owner) || owner.incapacitated() || (!charges && deletes_on_empty))
		return FALSE
	return ..()

/datum/action/innate/cult/blood_spell/Activate()
	if(!magic_path) // only concerned with spells that flow from the hand
		return
	if(hand_magic)
		qdel(hand_magic)
		hand_magic = null
		to_chat(owner, span_warning("你掐灭了法术，以备后用."))
		return
	hand_magic = new magic_path(owner, src)
	if(!owner.put_in_hands(hand_magic))
		qdel(hand_magic)
		hand_magic = null
		to_chat(owner, span_warning("你没有空闲的手来施展血魔法!"))
		return
	to_chat(owner, span_notice("你的伤口因施展[name]而渗出光."))

//Cult Blood Spells
/datum/action/innate/cult/blood_spell/stun
	name = "眩晕"
	desc = "让你的手在接触时使目标眩晕并失声."
	button_icon_state = "hand"
	magic_path = "/obj/item/melee/blood_magic/stun"
	health_cost = 10

/datum/action/innate/cult/blood_spell/teleport
	name = "传送"
	desc = "让你的手在接触时使自己或其他教徒传送到传送符文处."
	button_icon_state = "tele"
	magic_path = "/obj/item/melee/blood_magic/teleport"
	health_cost = 7

/datum/action/innate/cult/blood_spell/emp
	name = "电磁脉冲"
	desc = "释放大范围的电磁脉冲."
	button_icon_state = "emp"
	health_cost = 10
	invocation = "Ta'gh fara'qha fel d'amar det!"

/datum/action/innate/cult/blood_spell/emp/Activate()
	owner.whisper(invocation, language = /datum/language/common)
	owner.visible_message(span_warning("[owner]的手闪出蓝光!"), \
		span_culti_talic("你说出了咒语，一股电磁脉冲随即从手中施放."))
	empulse(owner, 2, 5)
	charges--
	SSblackbox.record_feedback("tally", "cult_spell_invoke", 1, "[name]")
	if(charges <= 0)
		qdel(src)

/datum/action/innate/cult/blood_spell/shackles
	name = "影缚"
	desc = "让你的手在接触时使目标失声并被铐上."
	button_icon_state = "cuff"
	charges = 4
	magic_path = "/obj/item/melee/blood_magic/shackles"

/datum/action/innate/cult/blood_spell/construction
	name = "扭曲建筑"
	desc = "让你的手能腐蚀某些金属物体.<br><u>可以将:</u><br>塑钢转化为符文金属<br>50金属转化为建筑者躯壳<br>活跃赛博在延迟后转化为建筑者<br>赛博躯体转化为建筑者躯体<br>纯净灵魂石(以及里面的任何幽影)转化为血教灵魂石<br>气闸门在延迟后转化为脆弱的符文气闸门(战斗模式)"
	button_icon_state = "transmute"
	magic_path = "/obj/item/melee/blood_magic/construction"
	health_cost = 12

/datum/action/innate/cult/blood_spell/equipment
	name = "召唤战斗装备"
	desc = "让你的手在接触血教徒时可以召唤出装备到其身上，包括血教护甲、血教流星锤和血教剑. 在血教暴露前不建议使用."
	button_icon_state = "equip"
	magic_path = "/obj/item/melee/blood_magic/armor"

/datum/action/innate/cult/blood_spell/dagger
	name = "召唤仪式匕首"
	desc = "让你召唤一把仪式匕首."
	invocation = "Wur d'dai leev'mai k'sagan!" //where did I leave my keys, again?
	button_icon_state = "equip" //this is the same icon that summon equipment uses, but eh, I'm not a spriter
	/// The item given to the cultist when the spell is invoked. Typepath.
	var/obj/item/summoned_type = /obj/item/melee/cultblade/dagger

/datum/action/innate/cult/blood_spell/dagger/Activate()
	var/turf/owner_turf = get_turf(owner)
	owner.whisper(invocation, language = /datum/language/common)
	owner.visible_message(span_warning("[owner]的手渗出红光."), \
		span_cult_italic("你的请求得到回应，光点闪烁并在你手中汇聚塑形!"))
	var/obj/item/summoned_blade = new summoned_type(owner_turf)
	if(owner.put_in_hands(summoned_blade))
		to_chat(owner, span_warning("一把[summoned_blade]出现在你的手中!"))
	else
		owner.visible_message(span_warning("一把[summoned_blade]出现在[owner]的脚下!"), \
			span_cult_italic("一把[summoned_blade]在你脚下成形."))
	SEND_SOUND(owner, sound('sound/effects/magic.ogg', FALSE, 0, 25))
	charges--
	SSblackbox.record_feedback("tally", "cult_spell_invoke", 1, "[name]")
	if(charges <= 0)
		qdel(src)

/datum/action/innate/cult/blood_spell/horror
	name = "幻觉"
	desc = "远距离使目标产生幻觉. 一种无声无形."
	button_icon_state = "horror"
	charges = 4
	click_action = TRUE
	enable_text = span_cult("你准备好发动精神攻击了...")
	disable_text = span_cult("你掐灭了魔法...")

/datum/action/innate/cult/blood_spell/horror/InterceptClickOn(mob/living/caller, params, atom/clicked_on)
	var/turf/caller_turf = get_turf(caller)
	if(!isturf(caller_turf))
		return FALSE

	if(!ishuman(clicked_on) || get_dist(caller, clicked_on) > 7)
		return FALSE

	var/mob/living/carbon/human/human_clicked = clicked_on
	if(IS_CULTIST(human_clicked))
		return FALSE

	return ..()

/datum/action/innate/cult/blood_spell/horror/do_ability(mob/living/caller, mob/living/carbon/human/clicked_on)

	clicked_on.set_hallucinations_if_lower(240 SECONDS)
	SEND_SOUND(caller, sound('sound/effects/ghost.ogg', FALSE, TRUE, 50))

	var/image/sparkle_image = image('icons/effects/cult.dmi', clicked_on, "bloodsparkles", ABOVE_MOB_LAYER)
	clicked_on.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/cult, "cult_apoc", sparkle_image, NONE)

	addtimer(CALLBACK(clicked_on, TYPE_PROC_REF(/atom/, remove_alt_appearance), "cult_apoc", TRUE), 4 MINUTES, TIMER_OVERRIDE|TIMER_UNIQUE)
	to_chat(caller, span_cult_bold("[clicked_on]被逼真的噩梦所折磨!"))

	charges--
	desc = base_desc
	desc += "<br><b><u>还有[charges]次</u></b>."
	build_all_button_icons()
	SSblackbox.record_feedback("tally", "cult_spell_invoke", 1, "[name]")
	if(charges <= 0)
		to_chat(caller, span_cult("你已经耗尽了法术的力量!"))
		qdel(src)

	return TRUE

/datum/action/innate/cult/blood_spell/veiling
	name = "隐藏与存在"
	desc = "交替隐藏和显示附近的血教建筑和符文."
	invocation = "Kla'atu barada nikt'o!"
	button_icon_state = "gone"
	charges = 10
	var/revealing = FALSE //if it reveals or not

/datum/action/innate/cult/blood_spell/veiling/Activate()
	if(!revealing)
		owner.visible_message(span_warning("[owner]的手中落下细小的灰尘!"), \
			span_cultitalic("你施展隐藏法术，隐藏了附近的符文."))
		charges--
		SEND_SOUND(owner, sound('sound/magic/smoke.ogg',0,1,25))
		owner.whisper(invocation, language = /datum/language/common)
		for(var/obj/effect/rune/R in range(5,owner))
			R.conceal()
		for(var/obj/structure/destructible/cult/S in range(5,owner))
			S.conceal()
		for(var/turf/open/floor/engine/cult/T  in range(5,owner))
			if(!T.realappearance)
				continue
			T.realappearance.alpha = 0
		for(var/obj/machinery/door/airlock/cult/AL in range(5, owner))
			AL.conceal()
		revealing = TRUE
		name = "显示符文"
		button_icon_state = "back"
	else
		owner.visible_message(span_warning("[owner]的手中闪过一道光!"), \
			span_cultitalic("你施展存在法术，显示附近的符文."))
		charges--
		owner.whisper(invocation, language = /datum/language/common)
		SEND_SOUND(owner, sound('sound/magic/enter_blood.ogg',0,1,25))
		for(var/obj/effect/rune/R in range(7,owner)) //More range in case you weren't standing in exactly the same spot
			R.reveal()
		for(var/obj/structure/destructible/cult/S in range(6,owner))
			S.reveal()
		for(var/turf/open/floor/engine/cult/T  in range(6,owner))
			if(!T.realappearance)
				continue
			T.realappearance.alpha = initial(T.realappearance.alpha)
		for(var/obj/machinery/door/airlock/cult/AL in range(6, owner))
			AL.reveal()
		revealing = FALSE
		name = "隐藏符文"
		button_icon_state = "gone"
	SSblackbox.record_feedback("tally", "cult_spell_invoke", 1, "Conceal Runes")
	if(charges <= 0)
		qdel(src)
	desc = base_desc
	desc += "<br><b><u>还有[charges]次</u></b>."
	build_all_button_icons()

/datum/action/innate/cult/blood_spell/manipulation
	name = "血仪式"
	desc = "让你的手可以吸取用于高级仪式的血液，或治疗所接触的血教徒. 使用手中法术来释放高级仪式."
	invocation = "Fel'th Dol Ab'orod!"
	button_icon_state = "manip"
	charges = 5
	magic_path = "/obj/item/melee/blood_magic/manipulator"
	deletes_on_empty = FALSE

// The "magic hand" items
/obj/item/melee/blood_magic
	name = "\improper 法气"
	desc = "一股邪恶的法气，扭曲了周围的现实流动."
	icon = 'icons/obj/weapons/hand.dmi'
	lefthand_file = 'icons/mob/inhands/items/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/touchspell_righthand.dmi'
	icon_state = "disintegrate"
	inhand_icon_state = "disintegrate"
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/invocation
	var/uses = 1
	var/health_cost = 0 //The amount of health taken from the user when invoking the spell
	var/datum/action/innate/cult/blood_spell/source

/obj/item/melee/blood_magic/Initialize(mapload, spell)
	. = ..()
	if(spell)
		source = spell
		uses = source.charges
		health_cost = source.health_cost

/obj/item/melee/blood_magic/Destroy()
	if(!QDELETED(source))
		if(uses <= 0 && source.deletes_on_empty)
			source.hand_magic = null
			qdel(source)
			source = null
		else
			source.hand_magic = null
			source.charges = uses
			source.desc = source.base_desc
			source.desc += "<br><b><u>还有[uses]次</u></b>."
			source.build_all_button_icons()
	return ..()

/obj/item/melee/blood_magic/attack_self(mob/living/user)
	afterattack(user, user, TRUE)

/obj/item/melee/blood_magic/attack(mob/living/M, mob/living/carbon/user)
	if(!iscarbon(user) || !IS_CULTIST(user))
		uses = 0
		qdel(src)
		return
	log_combat(user, M, "施展了血教法术", source.name, "")
	SSblackbox.record_feedback("tally", "cult_spell_invoke", 1, "[name]")
	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey

/obj/item/melee/blood_magic/afterattack(atom/target, mob/living/carbon/user, proximity)
	. = ..()
	if(invocation)
		user.whisper(invocation, language = /datum/language/common)
	if(health_cost)
		if(user.active_hand_index == 1)
			user.apply_damage(health_cost, BRUTE, BODY_ZONE_L_ARM)
		else
			user.apply_damage(health_cost, BRUTE, BODY_ZONE_R_ARM)
	if(uses <= 0)
		qdel(src)
	else if(source)
		source.desc = source.base_desc
		source.desc += "<br><b><u>还有[uses]次</u></b>."
		source.build_all_button_icons()

//Stun
/obj/item/melee/blood_magic/stun
	name = "眩晕法气"
	desc = "在接触时使人晕倒并失声."
	color = RUNE_COLOR_RED
	invocation = "Fuu ma'jin!"

/obj/item/melee/blood_magic/stun/afterattack(mob/living/target, mob/living/carbon/user, proximity)
	if(!isliving(target) || !proximity)
		return
	if(IS_CULTIST(target))
		return
	var/datum/antagonist/cult/cultist = IS_CULTIST(user)
	if(!isnull(cultist))
		var/datum/team/cult/cult_team = cultist.get_team()
		var/effect_coef = 1 - (cult_team.cult_risen ? 0.4 : 0) - (cult_team.cult_ascendent ? 0.5 : 0)
		user.visible_message(span_warning("[user]抬起手，红光一闪而过!"), \
		span_cult_italic("你试图用咒术击晕[target]!"))
		user.mob_light(range = 1.1, power = 2, color = LIGHT_COLOR_BLOOD_MAGIC, duration = 0.2 SECONDS)
		if(IS_HERETIC(target))
			to_chat(user, span_warning("有比你更强大的力量在干预! [target]受到了某些被遗忘神祇的保护!"))
			to_chat(target, span_warning("你所忠于的遗忘神祇们保护了你."))
			var/old_color = target.color
			target.color = rgb(0, 128, 0)
			animate(target, color = old_color, time = 1 SECONDS, easing = EASE_IN)

		// SKYRAT EDIT START
		if(IS_CLOCK(target))
			to_chat(user, span_warning("某种比你更强大的力量介入了! [target]受到了异教徒拉特瓦的保护!"))
			to_chat(target, span_warning("你所忠于的拉特瓦保护了你!"))
			var/old_color = target.color
			target.color = rgb(190, 135, 0)
			animate(target, color = old_color, time = 1 SECONDS, easing = EASE_IN)
		// SKYRAT EDIT END

		else if(target.can_block_magic())
			to_chat(user, span_warning("法术不起效果!"))
		else
			to_chat(user, span_cultitalic("红光闪过，[target]倒地!"))
			target.Paralyze(16 SECONDS * effect_coef)
			target.flash_act(1, TRUE)
			if(issilicon(target))
				var/mob/living/silicon/silicon_target = target
				silicon_target.emp_act(EMP_HEAVY)
			else if(iscarbon(target))
				var/mob/living/carbon/carbon_target = target
				carbon_target.adjust_silence(12 SECONDS * effect_coef)
				carbon_target.adjust_stutter(30 SECONDS * effect_coef)
				carbon_target.adjust_timed_status_effect(30 SECONDS * effect_coef, /datum/status_effect/speech/slurring/cult)
				carbon_target.set_jitter_if_lower(30 SECONDS * effect_coef)
		uses--
	..()

//Teleportation
/obj/item/melee/blood_magic/teleport
	name = "传送法气"
	color = RUNE_COLOR_TELEPORT
	desc = "将接触到的血教徒传送到传送符文."
	invocation = "Sas'so c'arta forbici!"

/obj/item/melee/blood_magic/teleport/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/mob/mob_target = target
	if(istype(mob_target) && !IS_CULTIST(mob_target) || !proximity)
		to_chat(user, span_warning("该法术只能传送相邻的血教徒!"))
		return
	if(IS_CULTIST(user))
		var/list/potential_runes = list()
		var/list/teleportnames = list()
		for(var/obj/effect/rune/teleport/teleport_rune as anything in GLOB.teleport_runes)
			potential_runes[avoid_assoc_duplicate_keys(teleport_rune.listkey, teleportnames)] = teleport_rune

		if(!length(potential_runes))
			to_chat(user, span_warning("没有有效的符文可以传送!"))
			return

		var/turf/T = get_turf(src)
		if(is_away_level(T.z))
			to_chat(user, span_cultitalic("你不在正确的空间范围!"))
			return

		var/input_rune_key = tgui_input_list(user, "传送到的符文", "传送目标", potential_runes) //we know what key they picked
		if(isnull(input_rune_key))
			return
		if(isnull(potential_runes[input_rune_key]))
			to_chat(user, span_warning("你必须选择一个有效的符文!"))
			return
		var/obj/effect/rune/teleport/actual_selected_rune = potential_runes[input_rune_key] //what rune does that key correspond to?
		if(QDELETED(src) || !user || !user.is_holding(src) || user.incapacitated() || !actual_selected_rune || !proximity)
			return
		var/turf/dest = get_turf(actual_selected_rune)
		if(dest.is_blocked_turf(TRUE))
			to_chat(user, span_warning("目标符文被堵住了，你无法传送到那里."))
			return
		uses--
		var/turf/origin = get_turf(user)
		var/mob/living/L = target
		if(do_teleport(L, dest, channel = TELEPORT_CHANNEL_CULT))
			origin.visible_message(span_warning("[user]的手中流出灰尘，并且随着尖锐的破裂声消失了!"), \
				span_cultitalic("你念出了咒语然后发现自己到了别的地方!"), "<i>你听到一声尖锐的破裂声.</i>")
			dest.visible_message(span_warning("有什么东西出现在符文上方，一阵爆炸的气流涌出!"), null, "<i>你听到一声爆炸.</i>")
		..()

//Shackles
/obj/item/melee/blood_magic/shackles
	name = "束缚法气"
	desc = "给接触的目标带上手铐并且失声."
	invocation = "In'totum Lig'abis!"
	color = COLOR_BLACK // black

/obj/item/melee/blood_magic/shackles/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(IS_CULTIST(user) && iscarbon(target) && proximity)
		var/mob/living/carbon/C = target
		if(C.canBeHandcuffed())
			CuffAttack(C, user)
		else
			user.visible_message(span_cultitalic("这名目标没有足够的手臂来带上手铐!"))
			return
		..()

/obj/item/melee/blood_magic/shackles/proc/CuffAttack(mob/living/carbon/C, mob/living/user)
	if(!C.handcuffed)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 30, TRUE, -2)
		C.visible_message(span_danger("[user]开始用黑魔法束缚[C]!"), \
								span_userdanger("[user]开始在你的手腕上塑造黑魔法手铐!"))
		if(do_after(user, 3 SECONDS, C))
			if(!C.handcuffed)
				C.set_handcuffed(new /obj/item/restraints/handcuffs/energy/cult/used(C))
				C.update_handcuffed()
				C.adjust_silence(10 SECONDS)
				to_chat(user, span_notice("你铐上了[C]."))
				log_combat(user, C, "铐上了")
				uses--
			else
				to_chat(user, span_warning("[C]已经被束缚了."))
		else
			to_chat(user, span_warning("你没能铐上[C]."))
	else
		to_chat(user, span_warning("[C]已经被束缚了."))


/obj/item/restraints/handcuffs/energy/cult //For the shackling spell
	name = "影缚"
	desc = "用邪恶魔法给目标上手铐."
	trashtype = /obj/item/restraints/handcuffs/energy/used
	item_flags = DROPDEL

/obj/item/restraints/handcuffs/energy/cult/used/dropped(mob/user)
	user.visible_message(span_danger("[user]的镣铐在黑魔法的溃能中破碎了!"), \
							span_userdanger("你的[src]在黑魔法的溃能中破碎了!"))
	. = ..()


//Construction: Converts 50 iron to a construct shell, plasteel to runed metal, airlock to brittle runed airlock, a borg to a construct, or borg shell to a construct shell
/obj/item/melee/blood_magic/construction
	name = "扭曲法气"
	desc = "腐蚀某些金属物体."
	invocation = "Ethra p'ni dedol!"
	color = COLOR_BLACK // black
	var/channeling = FALSE

/obj/item/melee/blood_magic/construction/examine(mob/user)
	. = ..()
	. += {"<u>可以将:</u>\n
	>塑钢转化为符文金属\n
	[IRON_TO_CONSTRUCT_SHELL_CONVERSION]铁转化为建筑者躯壳\n
	活跃赛博在延迟后转化为建筑者\n
	赛博躯体转化为建筑者躯体\n
	纯净灵魂石(以及里面的任何幽影)转化为血教灵魂石\n
	气闸门在延迟后转化为脆弱的符文气闸门(战斗模式)"}

/obj/item/melee/blood_magic/construction/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag && IS_CULTIST(user))
		if(channeling)
			to_chat(user, span_cultitalic("你已经施展了扭曲建筑!"))
			return
		. |= AFTERATTACK_PROCESSED_ITEM
		var/turf/T = get_turf(target)
		if(istype(target, /obj/item/stack/sheet/iron))
			var/obj/item/stack/sheet/candidate = target
			if(candidate.use(IRON_TO_CONSTRUCT_SHELL_CONVERSION))
				uses--
				to_chat(user, span_warning("黑气从你的手中散发出来，蒙住了眼前的铁块，将其扭曲成了一具建筑者的躯壳!"))
				new /obj/structure/constructshell(T)
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
			else
				to_chat(user, span_warning("你需要[IRON_TO_CONSTRUCT_SHELL_CONVERSION]块铁来创造躯壳!"))
				return
		else if(istype(target, /obj/item/stack/sheet/plasteel))
			var/obj/item/stack/sheet/plasteel/candidate = target
			var/quantity = candidate.amount
			if(candidate.use(quantity))
				uses --
				new /obj/item/stack/sheet/runed_metal(T,quantity)
				to_chat(user, span_warning("黑气从你的手中散发出来，蒙住了眼前的塑钢，将其转化成了符文金属!"))
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
		else if(istype(target,/mob/living/silicon/robot))
			var/mob/living/silicon/robot/candidate = target
			if(candidate.mmi || candidate.shell)
				channeling = TRUE
				user.visible_message(span_danger("黑气从[user]的手中散发出来，蒙住了[candidate]!"))
				playsound(T, 'sound/machines/airlock_alien_prying.ogg', 80, TRUE)
				var/prev_color = candidate.color
				candidate.color = "black"
				if(do_after(user, 9 SECONDS, target = candidate))
					candidate.undeploy()
					candidate.emp_act(EMP_HEAVY)
					var/construct_class = show_radial_menu(user, src, GLOB.construct_radial_images, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
					if(!check_menu(user))
						return
					if(QDELETED(candidate))
						channeling = FALSE
						return
					candidate.grab_ghost()
					user.visible_message(span_danger("[candidate]上的黑气退散，[construct_class]显露出来!"))
					make_new_construct_from_class(construct_class, THEME_CULT, candidate, user, FALSE, T)
					uses--
					qdel(candidate)
					channeling = FALSE
				else
					channeling = FALSE
					candidate.color = prev_color
					return
			else
				uses--
				to_chat(user, span_warning("黑气从你的手中散发出来，蒙住了眼前的[candidate] - 正将其扭曲成建筑者!"))
				new /obj/structure/constructshell(T)
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
				qdel(candidate)
		else if(istype(target,/obj/machinery/door/airlock))
			channeling = TRUE
			playsound(T, 'sound/machines/airlockforced.ogg', 50, TRUE)
			do_sparks(5, TRUE, target)
			if(do_after(user, 5 SECONDS, target = user))
				if(QDELETED(target))
					channeling = FALSE
					return
				target.narsie_act()
				uses--
				to_chat(user, span_warning("黑气从你的手中散发出来，蒙住了眼前的[candidate] - 正将其扭曲成建筑者!"))
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
				channeling = FALSE
			else
				channeling = FALSE
				return
		else if(istype(target,/obj/item/soulstone))
			var/obj/item/soulstone/candidate = target
			if(candidate.corrupt())
				uses--
				to_chat(user, span_warning("你腐化了[candidate]!"))
				SEND_SOUND(user, sound('sound/effects/magic.ogg',0,1,25))
		else
			to_chat(user, span_warning("法术对[target]不起作用!"))
			return
		return . | ..()

/obj/item/melee/blood_magic/construction/proc/check_menu(mob/user)
	if(!istype(user))
		CRASH("The cult construct selection radial menu was accessed by something other than a valid user.")
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE


//Armor: Gives the target (cultist) a basic cultist combat loadout
/obj/item/melee/blood_magic/armor
	name = "唤装法气"
	desc = "给接触到的血教徒换上战斗装备."
	color = "#33cc33" // green

/obj/item/melee/blood_magic/armor/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/mob/living/carbon/carbon_target = target
	if(istype(carbon_target) && IS_CULTIST(carbon_target) && proximity)
		uses--
		var/mob/living/carbon/C = target
		C.visible_message(span_warning("异界的盔甲突然出现在了[C]身上!"))
		C.equip_to_slot_or_del(new /obj/item/clothing/under/color/black,ITEM_SLOT_ICLOTHING)
		C.equip_to_slot_or_del(new /obj/item/clothing/suit/hooded/cultrobes/alt(user), ITEM_SLOT_OCLOTHING)
		C.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult/alt(user), ITEM_SLOT_FEET)
		C.equip_to_slot_or_del(new /obj/item/storage/backpack/cultpack(user), ITEM_SLOT_BACK)
		if(C == user)
			qdel(src) //Clears the hands
		C.put_in_hands(new /obj/item/melee/cultblade/dagger(user))
		C.put_in_hands(new /obj/item/restraints/legcuffs/bola/cult(user))
		..()

/obj/item/melee/blood_magic/manipulator
	name = "血仪式法气"
	desc = "通过触摸吸取任何血液. 触摸血教徒和建筑对其进行治疗. 在手中使用则释放高级仪式."
	color = "#7D1717"

/obj/item/melee/blood_magic/manipulator/examine(mob/user)
	. = ..()
	. += "血戟，血弹幕和血激流分别消耗[BLOOD_HALBERD_COST]，[BLOOD_BARRAGE_COST]和[BLOOD_BEAM_COST]的费用."

/**
 * handles inhand use of blood rites on constructs, humans, or non-living blood sources
 *
 * see '/obj/item/melee/blood_magic/manipulator/proc/heal_construct' for construct/shade behavior
 * see '/obj/item/melee/blood_magic/manipulator/proc/heal_cultist' for human cultist behavior
 * see '/obj/item/melee/blood_magic/manipulator/proc/drain_victim' for human non-cultist behavior
 * if any of the above procs return FALSE, '/obj/item/melee/blood_magic/afterattack' will not be called
 *
 * '/obj/item/melee/blood_magic/manipulator/proc/blood_draw' handles blood pools/trails and does not affect parent proc
 */
/obj/item/melee/blood_magic/manipulator/afterattack(atom/target, mob/living/carbon/human/user, proximity)
	if(!proximity)
		return

	if((isconstruct(target) || isshade(target)) && !heal_construct(target, user))
		return
	if(istype(target, /obj/effect/decal/cleanable/blood) || istype(target, /obj/effect/decal/cleanable/trail_holder) || isturf(target))
		blood_draw(target, user)
	if(ishuman(target))
		var/mob/living/carbon/human/human_bloodbag = target
		if(HAS_TRAIT(human_bloodbag, TRAIT_NOBLOOD))
			human_bloodbag.balloon_alert(user, "没有血液!")
			return
		if(human_bloodbag.stat == DEAD)
			human_bloodbag.balloon_alert(user, "死着的!")
			return

		if(IS_CULTIST(human_bloodbag) && !heal_cultist(human_bloodbag, user))
			return
		if(!IS_CULTIST(human_bloodbag) && !drain_victim(human_bloodbag, user))
			return
	..()

/**
 * handles blood rites usage on constructs
 *
 * will only return TRUE if some amount healing is done
 */
/obj/item/melee/blood_magic/manipulator/proc/heal_construct(atom/target, mob/living/carbon/human/user)
	var/mob/living/basic/construct_thing = target
	if(!IS_CULTIST(construct_thing))
		return FALSE
	var/missing_health = construct_thing.maxHealth - construct_thing.health
	if(!missing_health)
		to_chat(user,span_cult("那个血教徒不需要治疗!"))
		return FALSE
	if(uses <= 0)
		construct_thing.balloon_alert(user, "缺少血液!")
		return FALSE
	if(uses > missing_health)
		construct_thing.adjust_health(-missing_health)
		construct_thing.visible_message(span_warning("[construct_thing]被[user]的血魔法完全修补好了!"))
		uses -= missing_health
	else
		construct_thing.adjust_health(-uses)
		construct_thing.visible_message(span_warning("[construct_thing]被[user]的血魔法部分修补好了!"))
		uses = 0
	playsound(get_turf(construct_thing), 'sound/magic/staff_healing.ogg', 25)
	user.Beam(construct_thing, icon_state="sendbeam", time = 1 SECONDS)
	return TRUE

/**
 * handles blood rites usage on human cultists
 *
 * first restores blood, then heals damage. healing damage is more expensive, especially if performed on oneself
 * returns TRUE if some amount of blood is restored and/or damage is healed
 */
/obj/item/melee/blood_magic/manipulator/proc/heal_cultist(mob/living/carbon/human/human_bloodbag, mob/living/carbon/human/user)
	if(uses <= 0)
		human_bloodbag.balloon_alert(user, "缺少血液!")
		return FALSE

	/// used to ensure the proc returns TRUE if we completely restore an undamaged persons blood
	var/blood_donor = FALSE
	if(human_bloodbag.blood_volume < BLOOD_VOLUME_SAFE)
		var/blood_needed = BLOOD_VOLUME_SAFE - human_bloodbag.blood_volume
		/// how much blood we are capable of restoring, based on spell charges
		var/blood_bank = USES_TO_BLOOD * uses
		if(blood_bank < blood_needed)
			human_bloodbag.blood_volume += blood_bank
			to_chat(user,span_danger("你用最后的血仪式来恢复你自身的血液"))
			uses = 0
			return TRUE
		blood_donor = TRUE
		human_bloodbag.blood_volume = BLOOD_VOLUME_SAFE
		uses -= round(blood_needed / USES_TO_BLOOD)
		to_chat(user,span_warning("你的血仪式将[human_bloodbag == user ? "你的" : "目标的"]血液水平恢复到安全水平!"))

	var/overall_damage = human_bloodbag.getBruteLoss() + human_bloodbag.getFireLoss() + human_bloodbag.getToxLoss() + human_bloodbag.getOxyLoss()
	if(overall_damage == 0)
		if(blood_donor)
			return TRUE
		to_chat(user,span_cult("这名血教徒不需要治疗!!"))
		return FALSE
	/// how much damage we can/will heal
	var/damage_healed = -1 * min(uses, overall_damage)
	/// how many spell charges will be consumed to heal said damage
	var/healing_cost = damage_healed
	if(human_bloodbag == user)
		to_chat(user,span_cult("<b>对自己使用时，血仪式的治疗效率很低!</b>"))
		damage_healed = -1 * min(uses * (1 / SELF_HEAL_PENALTY), overall_damage)
		healing_cost = damage_healed * SELF_HEAL_PENALTY
	uses += round(healing_cost)
	human_bloodbag.visible_message(span_warning("[human_bloodbag]被[human_bloodbag == user ? "[human_bloodbag.p_their()]":"[human_bloodbag]的"]血魔法![uses == 0 ? "部分治愈了":"完全治愈了"]."))

	var/need_mob_update = FALSE
	need_mob_update += human_bloodbag.adjustOxyLoss(damage_healed * (human_bloodbag.getOxyLoss() / overall_damage), updating_health = FALSE)
	need_mob_update += human_bloodbag.adjustToxLoss(damage_healed * (human_bloodbag.getToxLoss() / overall_damage), updating_health = FALSE)
	need_mob_update += human_bloodbag.adjustFireLoss(damage_healed * (human_bloodbag.getFireLoss() / overall_damage), updating_health = FALSE)
	need_mob_update += human_bloodbag.adjustBruteLoss(damage_healed * (human_bloodbag.getBruteLoss() / overall_damage), updating_health = FALSE)
	if(need_mob_update)
		human_bloodbag.updatehealth()
	playsound(get_turf(human_bloodbag), 'sound/magic/staff_healing.ogg', 25)
	new /obj/effect/temp_visual/cult/sparks(get_turf(human_bloodbag))
	if (user != human_bloodbag) //Dont create beam from the user to the user
		user.Beam(human_bloodbag, icon_state="sendbeam", time = 15)
	return TRUE

/**
 * handles blood rites use on a non-cultist human
 *
 * returns TRUE if blood is successfully drained from the victim
 */
/obj/item/melee/blood_magic/manipulator/proc/drain_victim(mob/living/carbon/human/human_bloodbag, mob/living/carbon/human/user)
	if(human_bloodbag.has_status_effect(/datum/status_effect/speech/slurring/cult))
		to_chat(user,span_danger("目标的血液已经被另一种更强大的血魔法污染了，这种血我们无法利用!"))
		return FALSE
	if(human_bloodbag.blood_volume <= BLOOD_VOLUME_SAFE)
		to_chat(user,span_warning("目标失血太多 - 你没法再吸了!"))
		return FALSE
	human_bloodbag.blood_volume -= BLOOD_DRAIN_GAIN * USES_TO_BLOOD
	uses += BLOOD_DRAIN_GAIN
	user.Beam(human_bloodbag, icon_state="drainbeam", time = 1 SECONDS)
	playsound(get_turf(human_bloodbag), 'sound/magic/enter_blood.ogg', 50)
	human_bloodbag.visible_message(span_danger("[user]吸收了一些[human_bloodbag]的血液!"))
	to_chat(user,span_cult_italic("你吸取了[human_bloodbag]的血液，血仪式获得了50点的可消耗费用."))
	new /obj/effect/temp_visual/cult/sparks(get_turf(human_bloodbag))
	return TRUE

/**
 * handles blood rites use on turfs, blood pools, and blood trails
 */
/obj/item/melee/blood_magic/manipulator/proc/blood_draw(atom/target, mob/living/carbon/human/user)
	var/blood_to_gain = 0
	var/turf/our_turf = get_turf(target)
	if(!our_turf)
		return
	for(var/obj/effect/decal/cleanable/blood/blood_around_us in range(our_turf,2))
		if(blood_around_us.blood_state != BLOOD_STATE_HUMAN)
			break
		if(blood_around_us.bloodiness == 100) // Bonus for "pristine" bloodpools, also to prevent cheese with footprint spam
			blood_to_gain += 30
		else
			blood_to_gain += max((blood_around_us.bloodiness**2)/800,1)
		new /obj/effect/temp_visual/cult/turf/floor(get_turf(blood_around_us))
		qdel(blood_around_us)
	for(var/obj/effect/decal/cleanable/trail_holder/trail_around_us in range(our_turf, 2))
		if(trail_around_us.blood_state != BLOOD_STATE_HUMAN)
			break
		blood_to_gain += 5 //These don't get bloodiness, so we'll just increase this by a fixed value
		new /obj/effect/temp_visual/cult/turf/floor(get_turf(trail_around_us))
		qdel(trail_around_us)

	if(!blood_to_gain)
		return
	user.Beam(our_turf,icon_state="drainbeam", time = 15)
	new /obj/effect/temp_visual/cult/sparks(get_turf(user))
	playsound(our_turf, 'sound/magic/enter_blood.ogg', 50)
	to_chat(user, span_cult_italic("Your blood rite has gained [round(blood_to_gain)] charge\s from blood sources around you!"))
	uses += max(1, round(blood_to_gain))

/**
 * handles untargeted use of blood rites
 *
 * allows user to trade in spell uses for equipment or spells
 */
/obj/item/melee/blood_magic/manipulator/attack_self(mob/living/user)
	var/static/list/spells = list(
		"血戟 (150)" = image(icon = 'icons/obj/weapons/spear.dmi', icon_state = "occultpoleaxe0"),
		"血弹幕 (300)" = image(icon = 'icons/obj/weapons/guns/ballistic.dmi', icon_state = "arcane_barrage"),
		"血激流 (500)" = image(icon = 'icons/obj/weapons/hand.dmi', icon_state = "disintegrate")
		)
	var/choice = show_radial_menu(user, src, spells, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE)
	if(!check_menu(user))
		to_chat(user, span_cult_italic("你决定不施展更大的血仪式."))
		return

	switch(choice)
		if("血戟 (150)")
			if(uses < BLOOD_HALBERD_COST)
				to_chat(user, span_cult_italic("你需要[BLOOD_HALBERD_COST]费用来施展该仪式."))
				return
			uses -= BLOOD_HALBERD_COST
			var/turf/current_position = get_turf(user)
			qdel(src)
			var/datum/action/innate/cult/halberd/halberd_act_granted = new(user)
			var/obj/item/melee/cultblade/halberd/rite = new(current_position)
			halberd_act_granted.Grant(user, rite)
			rite.halberd_act = halberd_act_granted
			if(user.put_in_hands(rite))
				to_chat(user, span_cult_italic("一把[rite.name]出现在你的手中!"))
			else
				user.visible_message(span_warning("一把[rite.name]出现在[user]的脚下!"), \
					span_cult_italic("一把[rite.name]出现在你的脚下."))

		if("血弹幕 (300)")
			if(uses < BLOOD_BARRAGE_COST)
				to_chat(user, span_cult_italic("你需要[BLOOD_BARRAGE_COST]费用来施展该仪式."))
				return
			var/obj/rite = new /obj/item/gun/magic/wand/arcane_barrage/blood()
			uses -= BLOOD_BARRAGE_COST
			qdel(src)
			if(user.put_in_hands(rite))
				to_chat(user, span_cult("<b>你的手汇聚了力量!</b>"))
			else
				to_chat(user, span_cult_italic("你需要空闲的手来完成仪式!"))
				qdel(rite)

		if("血激流 (500)")
			if(uses < BLOOD_BEAM_COST)
				to_chat(user, span_cult_italic("你需要[BLOOD_BEAM_COST]费用来施展该仪式."))
				return
			var/obj/rite = new /obj/item/blood_beam()
			uses -= BLOOD_BEAM_COST
			qdel(src)
			if(user.put_in_hands(rite))
				to_chat(user, span_cult_large("<b>你的手汇聚了千钧般的力量!!!</b>"))
			else
				to_chat(user, span_cult_italic("你需要空闲的手来完成仪式!"))
				qdel(rite)

/obj/item/melee/blood_magic/manipulator/proc/check_menu(mob/living/user)
	if(!istype(user))
		CRASH("The Blood Rites manipulator radial menu was accessed by something other than a valid user.")
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

#undef USES_TO_BLOOD
#undef BLOOD_DRAIN_GAIN
#undef SELF_HEAL_PENALTY
