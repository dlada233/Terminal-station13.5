/**
 * # The path of Lock.
 *
 * Goes as follows:
 *
 * A Steward's Secret
 * Grasp of Lock
 * > Sidepaths:
 *   Ashen Eyes
 *	 Codex Cicatrix
 * Key Keeper’s Burden
 *
 * Concierge's Rite
 * Mark Of Lock
 * Ritual of Knowledge
 * Burglar's Finesse
 * > Sidepaths:
 *   Apetra Vulnera
 *   Opening Blast
 *
 * Opening Blade
 * Caretaker’s Last Refuge
 *
 * Unlock the Labyrinth
 */
/datum/heretic_knowledge/limited_amount/starting/base_knock
	name = "管家的秘密"
	desc = "通往锁之路. \
		你能将一把刀具和一根撬棍嬗变成一把钥匙之刃. \
		同一时间只能创造两把出来，它们有和快速撬棍一样的功能. \
		另外它们能被装进功能腰带里."
	gain_text = "锁住的迷宫通向自由，但只有被困住的管家才知道正确的路径." // Stewards
	next_knowledge = list(/datum/heretic_knowledge/lock_grasp)
	required_atoms = list(
		/obj/item/knife = 1,
		/obj/item/crowbar = 1,
	)
	result_atoms = list(/obj/item/melee/sickly_blade/lock)
	limit = 2
	route = PATH_LOCK

/datum/heretic_knowledge/lock_grasp
	name = "转锁之握"
	desc = "漫宿之握可以让你解锁任何东西! 右键气闸门或储物柜能将其强行打开. \
		机甲的DNA锁也能移除，里面的机甲驾驶员会被弹出. 就算是终端计算机也能适用. \
		在使用时会发出独特的开锁声."
	gain_text = "没有什么能在我的触及之下保持闭锁."
	next_knowledge = list(
		/datum/heretic_knowledge/key_ring,
		/datum/heretic_knowledge/medallion,
		/datum/heretic_knowledge/codex_cicatrix,
	)
	cost = 1
	route = PATH_LOCK

/datum/heretic_knowledge/lock_grasp/on_gain(mob/user, datum/antagonist/heretic/our_heretic)
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK_SECONDARY, PROC_REF(on_secondary_mansus_grasp))
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/heretic_knowledge/lock_grasp/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK_SECONDARY)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/heretic_knowledge/lock_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER
	var/obj/item/clothing/under/suit = target.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	if(istype(suit) && suit.adjusted == NORMAL_STYLE)
		suit.toggle_jumpsuit_adjust()
		suit.update_appearance()

/datum/heretic_knowledge/lock_grasp/proc/on_secondary_mansus_grasp(mob/living/source, atom/target)
	SIGNAL_HANDLER

	if(ismecha(target))
		var/obj/vehicle/sealed/mecha/mecha = target
		mecha.dna_lock = null
		for(var/mob/living/occupant as anything in mecha.occupants)
			if(isAI(occupant))
				continue
			mecha.mob_exit(occupant, randomstep = TRUE)
	else if(istype(target,/obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/door = target
		door.unbolt()
	else if(istype(target, /obj/machinery/computer))
		var/obj/machinery/computer/computer = target
		computer.authenticated = TRUE
		computer.balloon_alert(source, "已解锁")

	var/turf/target_turf = get_turf(target)
	SEND_SIGNAL(target_turf, COMSIG_ATOM_MAGICALLY_UNLOCKED, src, source)
	playsound(target, 'sound/magic/hereticknock.ogg', 100, TRUE, -1)

	return COMPONENT_USE_HAND

/datum/heretic_knowledge/key_ring
	name = "看门人的职责"
	desc = "你可以将一个钱包、一根铁棒和一张ID卡嬗变成一张秘法卡. \
		它的功能与ID卡相同，但用普通ID卡攻击它，它会吸收该卡获得其访问权限. \
		在手中使用秘法卡可以让其变为所吸收卡的形象. \
		不保留仪式中所用卡."
	gain_text = "守门人冷笑道. \"这长方的塑料片是钥匙的嘲弄，我诅咒每一扇想要钥匙的门.\"" // keeper
	required_atoms = list(
		/obj/item/storage/wallet = 1,
		/obj/item/stack/rods = 1,
		/obj/item/card/id = 1,
	)
	result_atoms = list(/obj/item/card/id/advanced/heretic)
	next_knowledge = list(/datum/heretic_knowledge/limited_amount/concierge_rite)
	cost = 1
	route = PATH_LOCK

/datum/heretic_knowledge/limited_amount/concierge_rite // item that creates 3 max at a time heretic only barriers, probably should limit to 1 only, holy people can also pass
	name = "门房的仪式"
	desc = "你可以将一根白色蜡笔、一块木板以及一个多功能工具来嬗变出一本迷宫手册. \
		迷宫手册可以在一定距离内形成路障，只有你和对魔法抗性的人才能通过."
	gain_text = "门房把我的名字潦草地写在手簿上. \"欢迎来到你的新家，老伙计.\"" // concierge
	required_atoms = list(
		/obj/item/toy/crayon/white = 1,
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/multitool = 1,
	)
	result_atoms = list(/obj/item/heretic_labyrinth_handbook)
	next_knowledge = list(/datum/heretic_knowledge/mark/lock_mark)
	cost = 1
	route = PATH_LOCK

/datum/heretic_knowledge/mark/lock_mark
	name = "门栓印记"
	desc = "你的漫宿之握现在对目标施加门栓印记. \
		攻击该目标，在门栓印记存在期间他们将无路可通. \
		他们将没有任何权限，甚至是公共权限也会拒绝它们."
	gain_text = "看守是个腐败的管家. 她为了自己扭曲的娱乐而锁住同伴." // Gatekeeper Steward
	next_knowledge = list(/datum/heretic_knowledge/knowledge_ritual/lock)
	route = PATH_LOCK
	mark_type = /datum/status_effect/eldritch/lock

/datum/heretic_knowledge/knowledge_ritual/lock
	next_knowledge = list(/datum/heretic_knowledge/spell/burglar_finesse)
	route = PATH_LOCK

/datum/heretic_knowledge/spell/burglar_finesse
	name = "夜盗妙术"
	desc = "赐予你夜盗妙术，单个目标的指向性咒语. \
		让你可以从目标包里随机偷取一件物品."
	gain_text = "与夜盗之灵来往是不被允许的，但一个管家总是想要了解新的门." // Steward
	next_knowledge = list(
		/datum/heretic_knowledge/spell/apetra_vulnera,
		/datum/heretic_knowledge/spell/opening_blast,
		/datum/heretic_knowledge/blade_upgrade/flesh/lock,
	)
	spell_to_add = /datum/action/cooldown/spell/pointed/burglar_finesse
	cost = 2
	route = PATH_LOCK

/datum/heretic_knowledge/blade_upgrade/flesh/lock //basically a chance-based weeping avulsion version of the former
	name = "豁口通刃"
	desc = "你的钥匙之刃有一定概率对目标造成渗血撕裂伤." // weeping avulsion
	gain_text = "流浪医师不是管家. 尽管如此，刀刃与缝合线也胜似它们的钥匙."// Pilgrim-Surgeon
	next_knowledge = list(/datum/heretic_knowledge/spell/caretaker_refuge)
	route = PATH_LOCK
	wound_type = /datum/wound/slash/flesh/critical
	var/chance = 35

/datum/heretic_knowledge/blade_upgrade/flesh/lock/do_melee_effects(mob/living/source, mob/living/target, obj/item/melee/sickly_blade/blade)
	if(prob(chance))
		return ..()

/datum/heretic_knowledge/spell/caretaker_refuge
	name = "看守人的最终避难所"
	desc = "赐予你一个避难咒语，能让你变得透明且虚化，不能在有感知的生命体附近使用. \
		在避难期间，你无敌且免疫减速，但你也无法使用双手和咒语，以及无法伤害其他任何物体. \
		此外，被反魔法物体击中则避难解除."
	gain_text = "卫兵与猎狗嫉妒地追捕着我，但我解锁了我的形体，变成了一团无法触及的迷雾."
	next_knowledge = list(/datum/heretic_knowledge/ultimate/lock_final)
	route = PATH_LOCK
	spell_to_add = /datum/action/cooldown/spell/caretaker
	cost = 1

/datum/heretic_knowledge/ultimate/lock_final
	name = "启封迷城"
	desc = "锁之路的最终仪式. \
		带三具躯干部位没有器官的尸体到嬗变符文处以完成仪式. \
		一旦完成，你将获得变身成四只强大的邪恶生物的能力. 而你完成仪式的嬗变符文将打开一道连通迷宫心脏的裂口， \
		无穷无尽的邪恶生物将从这道裂口中涌出，而且它们还会听从你的指示."
	gain_text = "管家们为我引路，而我也带领它们. \
		此刻引剑向锁，钥匙就此天成! \
		迷宫禁锁不再，自由终于来临! 见证我!"
	required_atoms = list(/mob/living/carbon/human = 3)
	route = PATH_LOCK

/datum/heretic_knowledge/ultimate/lock_final/recipe_snowflake_check(mob/living/user, list/atoms, list/selected_atoms, turf/loc)
	. = ..()
	if(!.)
		return FALSE

	for(var/mob/living/carbon/human/body in atoms)
		if(body.stat != DEAD)
			continue
		if(LAZYLEN(body.get_organs_for_zone(BODY_ZONE_CHEST)))
			to_chat(user, span_hierophant_warning("[body]躯干部位有器官."))
			continue

		selected_atoms += body

	if(!LAZYLEN(selected_atoms))
		loc.balloon_alert(user, "仪式失败，符合条件的尸体不够!")
		return FALSE
	return TRUE

/datum/heretic_knowledge/ultimate/lock_final/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	priority_announce(
		text = "检测到Delta级纬度异常，[generate_heretic_text()]现实崩坏，撕裂. 门开了，门开了， [user.real_name]已经飞升了! 畏惧迷城之潮! [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = ANNOUNCER_SPANOMALIES,
		color_override = "pink",
	)
	user.client?.give_award(/datum/award/achievement/misc/lock_ascension, user)

	// buffs
	var/datum/action/cooldown/spell/shapeshift/eldritch/ascension/transform_spell = new(user.mind)
	transform_spell.Grant(user)

	user.client?.give_award(/datum/award/achievement/misc/lock_ascension, user)
	var/datum/antagonist/heretic/heretic_datum = IS_HERETIC(user)
	var/datum/heretic_knowledge/blade_upgrade/flesh/lock/blade_upgrade = heretic_datum.get_knowledge(/datum/heretic_knowledge/blade_upgrade/flesh/lock)
	blade_upgrade.chance += 30
	new /obj/structure/lock_tear(loc, user.mind)
