/// 施法后获得一个小丑物品
/datum/action/cooldown/spell/conjure_item/clown_pockets
	name = "获取小丑道具"
	desc = "从你神秘莫测的裤子里掏出一个物品."
	button_icon = 'icons/obj/clothing/masks.dmi'
	button_icon_state = "clown"
	school = SCHOOL_CONJURATION
	spell_requirements = NONE
	cooldown_time = 30 SECONDS
	cooldown_reduction_per_rank = 2 SECONDS
	delete_old = FALSE
	delete_on_failure = FALSE
	/// 掏出物品所需的时间
	var/cast_time = 3 SECONDS
	/// 施法时为TRUE
	var/casting = FALSE
	/// 你可以从裤子里找到的恶作剧道具列表
	var/static/list/clown_items = list(
		/obj/item/bikehorn = 5,
		/obj/item/food/pie/cream = 5,
		/obj/item/grown/bananapeel = 5,
		/obj/item/toy/balloon = 3,
		/obj/item/toy/snappop = 5,
		/obj/item/toy/waterballoon = 5,
		/obj/item/assembly/mousetrap = 3,
		/obj/item/bikehorn/airhorn = 2,
		/obj/item/reagent_containers/cup/soda_cans/canned_laughter = 2,
		/obj/item/soap = 2,
		/obj/item/stack/tile/fakeice/loaded = 2,
		/obj/item/stack/tile/fakepit/loaded = 2,
		/obj/item/stack/tile/fakespace/loaded = 2,
		/obj/item/storage/box/heretic_box = 2,
		/obj/item/toy/balloon/corgi = 2,
		/obj/item/toy/foamblade = 2,
		/obj/item/toy/gun = 2,
		/obj/item/toy/spinningtoy = 2,
		/obj/item/toy/spinningtoy/dark_matter = 1,
		/obj/item/bikehorn/golden = 1,
		/obj/item/dualsaber/toy = 1,
		/obj/item/restraints/legcuffs/beartrap = 1,
		/obj/item/toy/balloon/syndicate = 1,
		/obj/item/toy/balloon/arrest = 1,
		/obj/item/toy/crayon/spraycan/lubecan = 1,
		/obj/item/toy/dummy = 1,
	)

/datum/action/cooldown/spell/conjure_item/clown_pockets/before_cast(atom/cast_on)
	. = ..()
	if (. & SPELL_CANCEL_CAST)
		return
	casting = TRUE
	cast_message(cast_on)
	if (!do_after(cast_on, cast_time, cast_on))
		casting = FALSE
		cast_on.balloon_alert(cast_on, "被打断了！")
		StartCooldown(2 SECONDS) // 防止聊天刷屏
		return . | SPELL_CANCEL_CAST
	casting = FALSE

/datum/action/cooldown/spell/conjure_item/clown_pockets/make_item(atom/caster)
	item_type = pick_weight(clown_items)
	return ..()

/datum/action/cooldown/spell/conjure_item/clown_pockets/post_created(atom/cast_on, atom/created)
	cast_on.visible_message(span_notice("[cast_on] 掏出了 [created]！"))

/datum/action/cooldown/spell/conjure_item/clown_pockets/can_cast_spell(feedback = TRUE)
	. = ..()
	if (!.)
		return
	if (casting)
		if (feedback)
			owner.balloon_alert(owner, "不能再乱翻了！")
		return FALSE

/// 打印有趣的信息，用于覆盖以打印不同的信息
/datum/action/cooldown/spell/conjure_item/clown_pockets/proc/cast_message(mob/cast_on)
	cast_on.visible_message(span_notice("[cast_on] 伸手到比你想象中更深的口袋里，开始翻找东西."))

/// 冷却时间较长的变体，附加到附魔小丑服上
/datum/action/cooldown/spell/conjure_item/clown_pockets/enchantment
	name = "附魔小丑口袋"
	cooldown_time = 60 SECONDS

/datum/action/cooldown/spell/conjure_item/clown_pockets/enchantment/cast_message(mob/cast_on)
	cast_on.visible_message(span_notice("[cast_on]开始在滑稽的大裤子里翻找东西."))

/// 附魔小丑服
/obj/item/clothing/under/rank/civilian/clown/magic
	name = "附魔小丑服"

/obj/item/clothing/under/rank/civilian/clown/magic/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/spell/conjure_item/clown_pockets/enchantment/big_pocket = new(src)
	add_item_action(big_pocket)

/// 附魔等离子人小丑服
/obj/item/clothing/under/plasmaman/clown/magic
	name = "附魔小丑环境服"

/obj/item/clothing/under/plasmaman/clown/magic/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/spell/conjure_item/clown_pockets/enchantment/big_pocket = new(src)
	add_item_action(big_pocket)
