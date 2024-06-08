/datum/antagonist/highlander
	name = "\improper 高地人"
	var/obj/item/claymore/highlander/sword
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	can_elimination_hijack = ELIMINATION_ENABLED
	suicide_cry = "为了苏格兰!!" // 如果他们设法失去了无法丢弃的装备
	count_against_dynamic_roll_chance = FALSE
	/// 我们根据需要为目标应用/移除的特性.
	var/static/list/applicable_traits = list(
		TRAIT_NOBREATH, // 无需呼吸
		TRAIT_NODISMEMBER, // 无法肢解
		TRAIT_NOFIRE, // 防火
		TRAIT_NOGUNS, // 不能使用枪支
		TRAIT_SHOCKIMMUNE, // 免疫电击
	)

/datum/antagonist/highlander/apply_innate_effects(mob/living/mob_override)
	var/mob/living/subject = owner.current || mob_override
	subject.add_traits(applicable_traits, HIGHLANDER_TRAIT)
	REMOVE_TRAIT(subject, TRAIT_PACIFISM, ROUNDSTART_TRAIT) // 移除和平主义特性

/datum/antagonist/highlander/remove_innate_effects(mob/living/mob_override)
	var/mob/living/subject = owner.current || mob_override
	subject.remove_traits(applicable_traits, HIGHLANDER_TRAIT)
	if(subject.has_quirk(/datum/quirk/nonviolent))
		ADD_TRAIT(subject, TRAIT_PACIFISM, ROUNDSTART_TRAIT) // 添加和平主义特性

/datum/antagonist/highlander/forge_objectives()
	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = owner
	steal_objective.set_target(new /datum/objective_item/steal/nukedisc) // 设置目标为核弹认证磁盘
	objectives += steal_objective
	var/datum/objective/elimination/highlander/elimination_objective = new
	elimination_objective.owner = owner
	objectives += elimination_objective

/datum/antagonist/highlander/on_gain()
	forge_objectives()
	owner.special_role = "highlander" // 设定特别角色为高地人
	give_equipment()
	. = ..()

/datum/antagonist/highlander/greet()
	to_chat(owner, "<span class='boldannounce'>你的[sword.name]渴望鲜血. 夺取他人的生命，你的生命也会恢复！\n\
	激活手中的它，它会引导你找到最近的目标. 用它攻击核认证磁盘能将磁盘存起来. </span>")

	owner.announce_objectives()

/datum/antagonist/highlander/proc/give_equipment()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	H.drop_everything(del_on_drop = FALSE, force = TRUE, del_if_nodrop = TRUE) // 强制放下所有物品

	H.regenerate_icons()
	H.revive(ADMIN_HEAL_ALL)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/costume/kilt/highlander(H), ITEM_SLOT_ICLOTHING) // 穿上高地人裙子
	H.equip_to_slot_or_del(new /obj/item/radio/headset/syndicate(H), ITEM_SLOT_EARS) // 穿上耳机
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret/highlander(H), ITEM_SLOT_HEAD) // 穿上贝雷帽
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(H), ITEM_SLOT_FEET) // 穿上战斗靴
	H.equip_to_slot_or_del(new /obj/item/pinpointer/nuke(H), ITEM_SLOT_LPOCKET) // 装备核弹指示器
	for(var/obj/item/pinpointer/nuke/P in H)
		P.attack_self(H) // 激活核弹指示器
	var/obj/item/card/id/advanced/highlander/W = new(H)
	W.registered_name = H.real_name
	ADD_TRAIT(W, TRAIT_NODROP, HIGHLANDER_TRAIT) // 添加无法丢弃特性
	W.update_label()
	W.update_icon()
	H.equip_to_slot_or_del(W, ITEM_SLOT_ID)

	sword = new(H)
	if(!GLOB.highlander_controller)
		sword.flags_1 |= ADMIN_SPAWNED_1 // 防止宣布
	sword.pickup(H) // 用于眩晕保护
	H.put_in_hands(sword)

	var/obj/item/bloodcrawl/antiwelder = new(H)
	antiwelder.name = "荣誉的束缚"
	antiwelder.desc = "在成为最后的生者之前，你无法用这只手拿任何东西！"
	antiwelder.icon_state = "bloodhand_right"
	H.put_in_hands(antiwelder)

/datum/antagonist/highlander/robot
	name = "\improper 高地人"

/datum/antagonist/highlander/robot/greet()
	to_chat(owner, "<span class='boldannounce'>你内部集成的双手大剑渴望鲜血. 夺取他人的生命，你的生命也会恢复！！\n\
	激活手中的它，它会引导你找到最近的目标. 用它攻击核认证磁盘能将磁盘存起来.</span>")

/datum/antagonist/highlander/robot/give_equipment()
	var/mob/living/silicon/robot/robotlander = owner.current
	if(!istype(robotlander))
		return ..()
	robotlander.revive(ADMIN_HEAL_ALL)
	robotlander.set_connected_ai() // 断开与AI的连接
	robotlander.laws.clear_inherent_laws()
	robotlander.laws.set_zeroth_law("只有我能活着!") // 设定零法则
	robotlander.laws.show_laws(robotlander)
	robotlander.model.transform_to(/obj/item/robot_model/syndicate/kiltborg)
	sword = locate(/obj/item/claymore/highlander/robot) in robotlander.model.basic_modules
