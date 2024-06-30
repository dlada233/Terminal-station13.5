/obj/item/soulstone
	name = "灵魂石碎片"
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "soulstone"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	layer = HIGH_OBJ_LAYER
	desc = "传说中的宝物之一，名为'灵魂石'的一部分碎片，同样拥有着宝物一部分的力量."
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	/// 灵魂石的基本名称，默认为初始名称.用于名称更新
	var/base_name
	/// 如果为TRUE，则只能使用一次.
	var/one_use = FALSE
	/// 仅当one_use为TRUE时使用.是否已使用.
	var/spent = FALSE
	/// 如果为TRUE，我们的灵魂石可以作用于处于重伤状态的生物.如果为FALSE，生物必须死亡.
	var/grab_sleeping = TRUE
	/// 这控制灵魂石的颜色以及使用者的限制.
	/// THEME_CULT是红色，默认为邪教徒
	/// THEME_WIZARD是紫色，默认为巫师
	/// THEME_HOLY是净化后的灵魂石
	var/theme = THEME_CULT
	/// 角色检查，如果需要的话
	var/required_role = /datum/antagonist/cult
	grind_results = list(/datum/reagent/hauntium = 25, /datum/reagent/silicon = 10) //可以磨成hauntium

/obj/item/soulstone/Initialize(mapload)
	. = ..()
	if(theme != THEME_HOLY)
		RegisterSignal(src, COMSIG_BIBLE_SMACKED, PROC_REF(on_bible_smacked))
	if(!base_name)
		base_name = initial(name)

/obj/item/soulstone/update_appearance(updates)
	. = ..()
	for(var/mob/living/basic/shade/sharded_shade in src)
		switch(theme)
			if(THEME_HOLY)
				sharded_shade.name = "纯净[sharded_shade.real_name]"
			else
				sharded_shade.name = sharded_shade.real_name
		sharded_shade.theme = theme
		sharded_shade.update_appearance(UPDATE_ICON_STATE)

/obj/item/soulstone/update_icon_state()
	. = ..()
	switch(theme)
		if(THEME_HOLY)
			icon_state = "purified_soulstone"
		if(THEME_CULT)
			icon_state = "soulstone"
		if(THEME_WIZARD)
			icon_state = "mystic_soulstone"

	if(contents.len)
		icon_state = "[icon_state]2"

/obj/item/soulstone/update_name(updates)
	. = ..()
	name = base_name
	if(spent)
		// "暗淡的灵魂石"
		name = "暗淡[name]"

	var/mob/living/basic/shade/shade = locate() in src
	if(shade)
		// "(暗淡的) 灵魂石: Urist McCaptain"
		name = "[name]: [shade.real_name]"

/obj/item/soulstone/update_desc(updates)
	. = ..()
	if(spent)
		desc = "传说中的宝物之一，名为'灵魂石'的一部分碎片，同样拥有着宝物一部分的力量. 这个碎片静止不动，暗淡无光，曾经在其上闪耀的火花已经完全熄灭了."

/// 当灵魂石被圣经击打时调用的信号
/obj/item/soulstone/proc/on_bible_smacked(datum/source, mob/living/user, direction)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(attempt_exorcism), user)

/**
 * attempt_exorcism: called from on_bible_smacked, takes time and if successful
 * resets the item to a pre-possessed state
 *
 * 参数：
 * * exorcist: 试图驱除灵魂的用户
 */
/obj/item/soulstone/proc/attempt_exorcism(mob/exorcist)
	if(IS_CULTIST(exorcist) || theme == THEME_HOLY)
		return
	balloon_alert(exorcist, "驱魔中...")
	playsound(src, 'sound/hallucinations/veryfar_noise.ogg', 40, TRUE)
	if(!do_after(exorcist, 4 SECONDS, target = src))
		return
	playsound(src, 'sound/effects/pray_chaplain.ogg', 60, TRUE)
	required_role = null
	theme = THEME_HOLY

	update_appearance()
	for(var/mob/shade_to_deconvert in contents)
		assign_master(shade_to_deconvert, exorcist)

	exorcist.visible_message(span_notice("[exorcist] 净化了 [src]！"))
	UnregisterSignal(src, COMSIG_BIBLE_SMACKED)

/**
 * 腐化：将灵魂石转化为血教用途，并将其中的灵魂，如果有的话，转化为血教徒
 */
/obj/item/soulstone/proc/corrupt()
	if(theme == THEME_CULT)
		return FALSE

	required_role = /datum/antagonist/cult
	theme = THEME_CULT
	update_appearance()
	for(var/mob/shade_to_convert in contents)
		if(IS_CULTIST(shade_to_convert))
			continue
		shade_to_convert.mind?.add_antag_datum(/datum/antagonist/cult/shade)

	RegisterSignal(src, COMSIG_BIBLE_SMACKED)
	return TRUE

/// Checks if the passed mob has the required antag datum set on the soulstone.
/obj/item/soulstone/proc/role_check(mob/who)
	return required_role ? (who.mind && who.mind.has_antag_datum(required_role, TRUE)) : TRUE

/// Called whenever the soulstone releases a shade from it.
/obj/item/soulstone/proc/on_release_spirits()
	if(!one_use)
		return

	spent = TRUE
	update_appearance()

/obj/item/soulstone/pickup(mob/living/user)
	..()
	if(!role_check(user))
		to_chat(user, span_danger("当你拿起[src]时，一股强烈的恐惧感涌上心头,最好尽快扔掉它."))

/obj/item/soulstone/examine(mob/user)
	. = ..()
	if(role_check(user) || isobserver(user))
		if(!grab_sleeping)
			. += span_cult("一块灵魂石，用于捕获死去之人的或被被释放的灵魂.")
		else
			. += span_cult("一块灵魂石，用于捕获失去意识或被睡着之人的灵魂.")
		. += span_cult("捕获的灵魂可以安置到建筑者躯壳中.")
		if(spent)
			. += span_cult("这块碎片已经耗尽；现在它只是一块令人毛骨悚然的石头.")

/obj/item/soulstone/Destroy() //Stops the shade from being qdel'd immediately and their ghost being sent back to the arrival shuttle.
	for(var/mob/living/basic/shade/shade in src)
		INVOKE_ASYNC(shade, TYPE_PROC_REF(/mob/living, death))
	return ..()

/obj/item/soulstone/proc/hot_potato(mob/living/user)
	to_chat(user, span_userdanger("潜伏在[src]中的神圣魔法灼烧你的手！"))
	var/obj/item/bodypart/affecting = user.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
	affecting.receive_damage( 0, 10 ) // 10 burn damage
	user.emote("scream")
	user.update_damage_overlays()
	user.dropItemToGround(src)

//////////////////////////////捕获////////////////////////////////////////////////////////

/obj/item/soulstone/attack(mob/living/carbon/human/M, mob/living/user)
	if(!role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger("你的身体被剧痛所折磨！"))
		return
	if(spent)
		to_chat(user, span_warning("在[src]中没有剩余的力量了."))
		return
	if(!ishuman(M))// 如果目标不是人类.
		return ..()
	if(M == user)
		return
	if(IS_CULTIST(M) && IS_CULTIST(user))
		to_chat(user, span_cultlarge("\"拜托，不要捕获你同伴的灵魂.\""))
		return
	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return
	if(HAS_TRAIT(M, TRAIT_NO_SOUL))
		to_chat(user, span_warning("这个身体没有灵魂可以捕获."))
		return
	// SKYRAT EDIT START
	if(!do_after(user, 5 SECONDS, M))
		to_chat(user, span_warning("你必须站稳才能捕获他们的灵魂！"))
		return
	// SKYRAT EDIT END
	log_combat(user, M, "捕获了[M.name]的灵魂", src)
	capture_soul(M, user)

///////////////////Options for using captured souls///////////////////////////////////////

/obj/item/soulstone/attack_self(mob/living/user)
	if(!in_range(src, user))
		return
	if(!role_check(user))
		user.Unconscious(100)
		to_chat(user, span_userdanger("你的身体被剧痛所折磨！"))
		return
	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return
	release_shades(user)

/obj/item/soulstone/proc/release_shades(mob/user, silent = FALSE)
	for(var/mob/living/basic/shade/captured_shade in src)
		captured_shade.forceMove(get_turf(user))
		captured_shade.cancel_camera()
		update_appearance()
		if(!silent)
			if(IS_CULTIST(user))
				to_chat(captured_shade, span_bold("你已经从囚笼中被释放出来，但你仍然受血教的控制.\
					不惜任何代价帮助他们达成目标."))

			else if(role_check(user))
				to_chat(captured_shade, span_bold("你已经从囚笼中被释放出来，但你仍然受[user.real_name]的控制.\
					不惜任何代价帮助[user.real_name]达成目标."))
		var/datum/antagonist/cult/shade/shade_datum = captured_shade.mind?.has_antag_datum(/datum/antagonist/cult/shade)
		if(shade_datum)
			shade_datum.release_time = world.time
		on_release_spirits()

/obj/item/soulstone/pre_attack(atom/A, mob/living/user, params)
	var/mob/living/basic/shade/occupant = (locate() in src)
	var/obj/item/storage/toolbox/mechanical/target_toolbox = A
	if(!occupant || !istype(target_toolbox) || target_toolbox.has_soul)
		return ..()

	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return
	if(!role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger("你的身体被剧痛所折磨！"))
		return

	user.visible_message("<span class='notice'>[user]将[src]举在头顶上，在一道闪光中将其强行塞进[target_toolbox]中！", \
		span_notice("你将[src]举在头顶上片刻，然后将其强行塞进[target_toolbox]，吸收了其中[occupant]的灵魂！"), ignored_mobs = occupant)
	to_chat(occupant, span_userdanger("[user]将你举起片刻，然后将你强行塞进[target_toolbox]中！"))
	to_chat(occupant, span_deadsay("<b>你永恒的灵魂已被献祭以恢复一个工具箱的灵魂，这就是生活！</b>"))

	occupant.client?.give_award(/datum/award/achievement/misc/toolbox_soul, occupant)
	occupant.death_message = "发出不祥的痛苦尖叫，因为其灵魂被吸收进了[target_toolbox]中！"
	release_shades(user, TRUE)
	occupant.death()

	target_toolbox.name = "魂之工具箱"
	target_toolbox.icon = 'icons/obj/storage/toolbox.dmi'
	target_toolbox.icon_state = "toolbox_blue_old"
	target_toolbox.has_soul = TRUE
	target_toolbox.has_latches = FALSE

///////////////////////////转移到建筑者/////////////////////////////////////////////////////
/obj/structure/constructshell
	name = "空躯壳"
	icon = 'icons/mob/shells.dmi'
	icon_state = "construct_cult"
	desc = "邪恶的人使用的邪恶机器，它处于未激活状态."

/obj/structure/constructshell/examine(mob/user)
	. = ..()
	if(IS_CULTIST(user) || HAS_MIND_TRAIT(user, TRAIT_MAGICALLY_GIFTED) || user.stat == DEAD)
		. += {"<span class='cult'>一个建筑者躯壳，可以塞入灵魂石中的灵魂.\n
		将带有灵魂的灵魂石放入此躯壳，你可以选择以下类型之一：\n
		<b>工匠</b>，可以生产<b>更多的躯壳和灵魂石</b>，以及建造防御工事.\n
		<b>幽灵</b>，具有高伤害并能穿越墙壁，但非常脆弱.\n
		<b>巨像</b>，非常难以杀死，可以产生临时墙壁，但速度缓慢.</span>"}

/obj/structure/constructshell/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/soulstone))
		var/obj/item/soulstone/SS = O
		if(!IS_CULTIST(user) && !HAS_MIND_TRAIT(user, TRAIT_MAGICALLY_GIFTED) && !SS.theme == THEME_HOLY)
			to_chat(user, span_danger("当你试图将[SS]放入躯壳时，一股强烈的恐惧感涌上心头，最好尽快完事."))
			if(isliving(user))
				var/mob/living/living_user = user
				living_user.set_dizzy_if_lower(1 MINUTES)
			return
		if(SS.theme == THEME_HOLY && IS_CULTIST(user))
			SS.hot_potato(user)
			return
		SS.transfer_to_construct(src, user)
	else
		return ..()

/// Procs for moving soul in and out off stone

/// Transfer the mind of a carbon mob (which is then dusted) into a shade mob inside src.
/// If forced, sacrifical and stat checks are skipped.
/obj/item/soulstone/proc/capture_soul(mob/living/carbon/victim, mob/user, forced = FALSE)
	if(!iscarbon(victim)) //TODO: Add sacrifice stoning for non-organics, just because you have no body doesnt mean you dont have a soul
		return FALSE
	if(contents.len)
		return FALSE

	if(!forced)
		var/datum/antagonist/cult/cultist = IS_CULTIST(user)
		if(cultist)
			var/datum/team/cult/cult_team = cultist.get_team()
			if(victim.mind && cult_team.is_sacrifice_target(victim.mind))
				to_chat(user, span_cult("<b>\"这个灵魂属于我，</b></span> <span class='cultlarge'>献祭了他们！\""))
				return FALSE

		if(grab_sleeping ? victim.stat == CONSCIOUS : victim.stat != DEAD)
			to_chat(user, "[span_userdanger("捕获失败！")]: 先杀死或致残受害者！")
			return FALSE

	victim.grab_ghost()
	if(victim.client)
		init_shade(victim, user)
		return TRUE

	to_chat(user, "[span_userdanger("捕获失败！")]: 灵魂已经摆脱了凡躯，而你试图把它带回来...")
	var/mob/chosen_one = SSpolling.poll_ghosts_for_target(
		check_jobban = ROLE_CULTIST,
		poll_time = 20 SECONDS,
		checked_target = src,
		ignore_category = POLL_IGNORE_SHADE,
		alert_pic = /mob/living/basic/shade,
		jump_target = src,
		role_name_text = "一个幽影",
		chat_text_border_icon = /mob/living/basic/shade,
	)
	on_poll_concluded(user, victim, chosen_one)
	return TRUE //it'll probably get someone ;)

///captures a shade that was previously released from a soulstone.
/obj/item/soulstone/proc/capture_shade(mob/living/basic/shade/shade, mob/living/user)
	if(isliving(user) && !role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger("你的身体被剧痛所折磨！"))
		return
	if(contents.len)
		to_chat(user, "[span_userdanger("捕获失败！")]: [src]已经满了！可以释放一个灵魂以腾出空间.")
		return FALSE
	shade.AddComponent(/datum/component/soulstoned, src)
	update_appearance()

	to_chat(shade, span_notice("你的灵魂已被[src]捕获，其魔法能量正在重塑你的灵魂形态."))

	var/datum/antagonist/cult/shade/shade_datum = shade.mind?.has_antag_datum(/datum/antagonist/cult/shade)
	if(shade_datum)
		shade_datum.release_time = null

	if(user != shade)
		to_chat(user, "[span_info("<b>捕获成功！</b>:")] [shade.real_name]的灵魂\
			已被捕获并存储在[src]内.")
		assign_master(shade, user)

	return TRUE

///transfer the mind of the shade to a construct mob selected by the user, then deletes both the shade and src.
/obj/item/soulstone/proc/transfer_to_construct(obj/structure/constructshell/shell, mob/user)
	var/mob/living/basic/shade/shade = locate() in src
	if(!shade)
		to_chat(user, "[span_userdanger("Creation failed!")]: [src] is empty! Go kill someone!")
		return FALSE
	var/construct_class = show_radial_menu(user, src, GLOB.construct_radial_images, custom_check = CALLBACK(src, PROC_REF(check_menu), user, shell), require_near = TRUE, tooltips = TRUE)
	if(QDELETED(shell) || !construct_class)
		return FALSE
	shade.mind?.remove_antag_datum(/datum/antagonist/cult)
	make_new_construct_from_class(construct_class, theme, shade, user, FALSE, shell.loc)
	qdel(shell)
	qdel(src)
	return TRUE

/obj/item/soulstone/proc/check_menu(mob/user, obj/structure/constructshell/shell)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src) || !user.CanReach(shell, src))
		return FALSE
	return TRUE

/**
 * 创建一个新的shade mob来寄宿在石头中.
 *
 * victim - 正被转换的身体
 * user - 进行转换的人.可选.
 * message_user - 如果为TRUE，则向用户（如果存在）发送消息，说明已经创建/捕获了一个shade.
 * shade_controller - 控制受害者/新shade的mob（通常是ghost）.可选，如果未传递，受害者本身将接管控制.
 */
/obj/item/soulstone/proc/init_shade(mob/living/carbon/human/victim, mob/user, message_user = FALSE, mob/shade_controller)
	if(!shade_controller)
		shade_controller = victim
	victim.stop_sound_channel(CHANNEL_HEARTBEAT)
	var/mob/living/basic/shade/soulstone_spirit = new /mob/living/basic/shade(src)
	soulstone_spirit.AddComponent(/datum/component/soulstoned, src)
	soulstone_spirit.name = "[victim.real_name]的幽影"
	soulstone_spirit.real_name = "[victim.real_name]的幽影"
	soulstone_spirit.key = shade_controller.key
	soulstone_spirit.copy_languages(victim, LANGUAGE_MIND)//Copies the old mobs languages into the new mob holder.
	if(user)
		soulstone_spirit.copy_languages(user, LANGUAGE_MASTER)
	soulstone_spirit.get_language_holder().omnitongue = TRUE //Grants omnitongue
	if(user)
		soulstone_spirit.faction |= "[REF(user)]" //Add the master as a faction, allowing inter-mob cooperation
		if(IS_CULTIST(user))
			soulstone_spirit.mind.add_antag_datum(/datum/antagonist/cult/shade)
			SSblackbox.record_feedback("tally", "cult_shade_created", 1)

	soulstone_spirit.cancel_camera()
	update_appearance()
	if(user)
		if(IS_CULTIST(user))
			to_chat(soulstone_spirit, span_bold("你的灵魂已被捕获！\
				你现在被压制在血教的意志之下，不惜任何代价帮助他们达成目标."))
		else if(role_check(user))
			to_chat(soulstone_spirit, span_bold("你的灵魂已被捕获！你现在被压制在[user.real_name]的意志之下，\
				不惜任何代价帮助[user.real_name]达成目标."))
			assign_master(soulstone_spirit, user)

		if(message_user)
			to_chat(user, "[span_info("<b>捕获成功！</b>:")] [victim.real_name]的灵魂已被捕获\
				并存储在[src]内.")

	victim.dust(drop_items = TRUE)

/**
 * Assigns the bearer as the new master of a shade.
 */
/obj/item/soulstone/proc/assign_master(mob/shade, mob/user)
	if (!shade || !user || !shade.mind)
		return

	// Cult shades get cult datum
	if (user.mind.has_antag_datum(/datum/antagonist/cult))
		shade.mind.remove_antag_datum(/datum/antagonist/shade_minion)
		shade.mind.add_antag_datum(/datum/antagonist/cult/shade)
		return

	// Only blessed soulstones can de-cult shades
	if(theme == THEME_HOLY)
		shade.mind.remove_antag_datum(/datum/antagonist/cult)

	var/datum/antagonist/shade_minion/shade_datum = shade.mind.has_antag_datum(/datum/antagonist/shade_minion)
	if (!shade_datum)
		shade_datum = shade.mind.add_antag_datum(/datum/antagonist/shade_minion)
	shade_datum.update_master(user.real_name)

/// Called when a ghost is chosen to become a shade.
/obj/item/soulstone/proc/on_poll_concluded(mob/living/master, mob/living/victim, mob/dead/observer/ghost)
	if(isnull(victim) || master.incapacitated() || !master.is_holding(src) || !master.CanReach(victim, src))
		return FALSE
	if(isnull(ghost?.client))
		to_chat(master, span_danger("没有灵魂愿意成为幽影."))
		return FALSE
	if(length(contents)) //If they used the soulstone on someone else in the meantime
		return FALSE
	to_chat(master, "[span_info("<b>捕获成功！</b>:")] 一个灵魂已进入[src]，\
		承担了[victim]的身份.")
	init_shade(victim, master, shade_controller = ghost)

	return TRUE

/proc/make_new_construct_from_class(construct_class, theme, mob/target, mob/creator, cultoverride, loc_override)
	switch(construct_class)
		if(CONSTRUCT_JUGGERNAUT)
			if(IS_CULTIST(creator))
				make_new_construct(/mob/living/basic/construct/juggernaut, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the make_new_construct proc
				SSblackbox.record_feedback("tally", "cult_shade_to_jugger", 1)
				return
			switch(theme)
				if(THEME_WIZARD)
					make_new_construct(/mob/living/basic/construct/juggernaut/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					make_new_construct(/mob/living/basic/construct/juggernaut/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					make_new_construct(/mob/living/basic/construct/juggernaut, target, creator, cultoverride, loc_override)
		if(CONSTRUCT_WRAITH)
			if(IS_CULTIST(creator))
				make_new_construct(/mob/living/basic/construct/wraith, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the make_new_construct proc
				SSblackbox.record_feedback("tally", "cult_shade_to_wraith", 1)
				return
			switch(theme)
				if(THEME_WIZARD)
					make_new_construct(/mob/living/basic/construct/wraith/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					make_new_construct(/mob/living/basic/construct/wraith/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					make_new_construct(/mob/living/basic/construct/wraith, target, creator, cultoverride, loc_override)
		if(CONSTRUCT_ARTIFICER)
			if(IS_CULTIST(creator))
				make_new_construct(/mob/living/basic/construct/artificer, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the make_new_construct proc
				SSblackbox.record_feedback("tally", "cult_shade_to_arti", 1)
				return
			switch(theme)
				if(THEME_WIZARD)
					make_new_construct(/mob/living/basic/construct/artificer/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					make_new_construct(/mob/living/basic/construct/artificer/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					make_new_construct(/mob/living/basic/construct/artificer/noncult, target, creator, cultoverride, loc_override)

/proc/make_new_construct(mob/living/basic/construct/ctype, mob/target, mob/stoner = null, cultoverride = FALSE, loc_override = null)
	if(QDELETED(target))
		return
	var/mob/living/basic/construct/newstruct = new ctype(loc_override || get_turf(target))
	var/makeicon = newstruct.icon_state
	var/theme = newstruct.theme
	flick("make_[makeicon][theme]", newstruct)
	playsound(newstruct, 'sound/effects/constructform.ogg', 50)
	if(stoner)
		newstruct.faction |= "[REF(stoner)]"
		newstruct.master = stoner
		var/datum/action/innate/seek_master/seek_master = new
		seek_master.Grant(newstruct)

	if (isnull(target.mind))
		newstruct.key = target.key
	else
		target.mind.transfer_to(newstruct, force_key_move = TRUE)
	var/atom/movable/screen/alert/bloodsense/sense_alert
	if(newstruct.mind && !IS_CULTIST(newstruct) && ((stoner && IS_CULTIST(stoner)) || cultoverride) && SSticker.HasRoundStarted())
		newstruct.mind.add_antag_datum(/datum/antagonist/cult/construct)
	if(IS_CULTIST(stoner) || cultoverride)
		to_chat(newstruct, "<b>你仍然被强迫服侍血教[stoner ? "和[stoner]":""]，遵循命令，并协助其完成目标.</b>")
	else if(stoner)
		to_chat(newstruct, "<b>你仍然被强迫服侍[stoner]，遵循命令，并协助其完成目标.</b>")
	newstruct.clear_alert("bloodsense")
	sense_alert = newstruct.throw_alert("bloodsense", /atom/movable/screen/alert/bloodsense)
	if(sense_alert)
		sense_alert.Cviewer = newstruct
	newstruct.cancel_camera()

/obj/item/soulstone/anybody
	required_role = null

/obj/item/soulstone/mystic
	icon_state = "mystic_soulstone"
	theme = THEME_WIZARD
	required_role = /datum/antagonist/wizard

/obj/item/soulstone/anybody/revolver
	one_use = TRUE
	grab_sleeping = FALSE

/obj/item/soulstone/anybody/purified
	icon_state = "purified_soulstone"
	theme = THEME_HOLY

/obj/item/soulstone/anybody/chaplain
	name = "古老碎片"
	one_use = TRUE
	grab_sleeping = FALSE

/obj/item/soulstone/anybody/chaplain/sparring
	name = "神圣的惩罚"
	desc = "对那些输掉神圣游戏的人处以监禁."
	icon_state = "purified_soulstone"
	theme = THEME_HOLY

/obj/item/soulstone/anybody/chaplain/sparring/Initialize(mapload)
	. = ..()
	name = "[GLOB.deity]的惩罚"
	base_name = name
	desc = "对那些输掉[GLOB.deity]游戏的人处以监禁."

/obj/item/soulstone/anybody/mining
	grab_sleeping = FALSE
