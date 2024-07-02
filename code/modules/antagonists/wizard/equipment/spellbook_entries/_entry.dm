/**
 * ## 法术书条目
 *
 * 当法术书创建时，自动填充每个法术书条目子类型的列表。
 *
 * 巫师可以通过购买条目来学习魔法、进行仪式或召唤物品。
 */
/datum/spellbook_entry
	/// 条目的名称
	var/name
	/// 条目的描述
	var/desc
	/// 条目授予的法术类型（typepath）
	var/datum/action/cooldown/spell/spell_type
	/// 条目所属的类别
	var/category
	/// 施展法术需要的书页数
	var/cost = 2
	/// 购买该法术的次数，与限制值比较
	var/times = 0
	/// 给定法术书中此条目的购买次数限制。如果为空，则允许无限次购买
	var/limit
	/// 是否可退款？
	var/refundable = TRUE
	/// 风格。用于描述如何获取法术的动词。例如 "[学习] 火球" 或 "[召唤] 幽灵"
	var/buy_word = "学习"
	/// 法术的冷却时间
	var/cooldown
	/// 法术是否需要巫师服装
	var/requires_wizard_garb = FALSE
	/// 用于指定某些法术不能同时存在
	var/list/no_coexistance_typecache

/datum/spellbook_entry/New()
	no_coexistance_typecache = typecacheof(no_coexistance_typecache)

	if(ispath(spell_type))
		if(isnull(limit))
			limit = initial(spell_type.spell_max_level)
		if(initial(spell_type.spell_requirements) & SPELL_REQUIRES_WIZARD_GARB)
			requires_wizard_garb = TRUE

/**
 * Determines if this entry can be purchased from a spellbook
 * Used for configs / round related restrictions.
 *
 * Return FALSE to prevent the entry from being added to wizard spellbooks, TRUE otherwise
 */
/datum/spellbook_entry/proc/can_be_purchased()
	if(!name || !desc || !category) // Erroneously set or abstract
		return FALSE
	return TRUE

/**
 * Checks if the user, with the supplied spellbook, can purchase the given entry.
 *
 * Arguments
 * * user - the mob who's buying the spell
 * * book - what book they're buying the spell from
 *
 * Return TRUE if it can be bought, FALSE otherwise
 */
/datum/spellbook_entry/proc/can_buy(mob/living/carbon/human/user, obj/item/spellbook/book)
	if(book.uses < cost)
		return FALSE
	if(!isnull(limit) && times >= limit)
		return FALSE
	for(var/spell in user.actions)
		if(is_type_in_typecache(spell, no_coexistance_typecache))
			return FALSE
	return TRUE

/**
 * 实际为用户购买条目
 *
 * 参数
 * * user - 购买法术的玩家
 * * book - 他们从中购买法术的书
 *
 * 成功购买返回真值，否则返回 FALSE
 */
/datum/spellbook_entry/proc/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	var/datum/action/cooldown/spell/existing = locate(spell_type) in user.actions
	if(existing)
		var/before_name = existing.name
		if(!existing.level_spell())
			to_chat(user, span_warning("这个法术无法再升级了!"))
			return FALSE

		to_chat(user, span_notice("你将 [before_name] 升级成了 [existing.name]."))
		name = existing.name

		//we'll need to update the cooldowns for the spellbook
		set_spell_info()

		if(log_buy)
			log_spellbook("[key_name(user)] 将他们对 [initial(existing.name)] 的知识提高到了 [existing.spell_level] 级，花费了 [cost] 点数")
			SSblackbox.record_feedback("nested tally", "wizard_spell_improved", 1, list("[name]", "[existing.spell_level]"))
			log_purchase(user.key)
		return existing

	//No same spell found - just learn it
	var/datum/action/cooldown/spell/new_spell = new spell_type(user.mind || user)
	new_spell.Grant(user)
	to_chat(user, span_notice("你学会了 [new_spell.name]."))

	if(log_buy)
		log_spellbook("[key_name(user)] 学会了 [new_spell]，花费了 [cost] 点数")
		SSblackbox.record_feedback("tally", "wizard_spell_learned", 1, name)
		log_purchase(user.key)
	return new_spell

/datum/spellbook_entry/proc/log_purchase(key)
	if(!islist(GLOB.wizard_spellbook_purchases_by_key[key]))
		GLOB.wizard_spellbook_purchases_by_key[key] = list()

	for(var/list/log as anything in GLOB.wizard_spellbook_purchases_by_key[key])
		if(log[LOG_SPELL_TYPE] == type)
			log[LOG_SPELL_AMOUNT]++
			return

	var/list/to_log = list(
		LOG_SPELL_TYPE = type,
		LOG_SPELL_AMOUNT = 1,
	)
	GLOB.wizard_spellbook_purchases_by_key[key] += list(to_log)

/**
 * Checks if the user, with the supplied spellbook, can refund the entry
 *
 * Arguments
 * * user - the mob who's refunding the spell
 * * book - what book they're refunding the spell from
 *
 * Return TRUE if it can refunded, FALSE otherwise
 */
/datum/spellbook_entry/proc/can_refund(mob/living/carbon/human/user, obj/item/spellbook/book)
	if(!refundable)
		return FALSE
	if(!book.refunds_allowed)
		return FALSE

	for(var/datum/action/cooldown/spell/other_spell in user.actions)
		if(initial(spell_type.name) == initial(other_spell.name))
			return TRUE

	return FALSE

/**
 * Actually refund the entry for the user
 *
 * Arguments
 * * user - the mob who's refunded the spell
 * * book - what book they're refunding the spell from
 *
 * Return -1 on failure, or return the point value of the refund on success
 */
/datum/spellbook_entry/proc/refund_spell(mob/living/carbon/human/user, obj/item/spellbook/book)
	var/area/centcom/wizard_station/wizard_home = GLOB.areas_by_type[/area/centcom/wizard_station]
	if(get_area(user) != wizard_home)
		to_chat(user, span_warning("你只能在巫师藏身处退款法术！"))
		return -1

	for(var/datum/action/cooldown/spell/to_refund in user.actions)
		if(initial(spell_type.name) != initial(to_refund.name))
			continue

		var/amount_to_refund = to_refund.spell_level * cost
		if(amount_to_refund <= 0)
			return -1

		qdel(to_refund)
		name = initial(name)
		log_spellbook("[key_name(user)] 退款 [src]，得到 [amount_to_refund] 点数")
		return amount_to_refund

	return -1

/**
 * Set any of the spell info saved on our entry
 * after something has occured
 *
 * For example, updating the cooldown after upgrading it
 */
/datum/spellbook_entry/proc/set_spell_info()
	if(!spell_type)
		return

	cooldown = (initial(spell_type.cooldown_time) / 10)

/// Item summons, they give you an item.
/datum/spellbook_entry/item
	refundable = FALSE
	buy_word = "召唤"
	/// Typepath of what item we create when purchased
	var/obj/item/item_path

/datum/spellbook_entry/item/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	var/atom/spawned_path = new item_path(user.loc)
	if(log_buy)
		log_spellbook("[key_name(user)] 购买了 [src]，花费了 [cost] 点数")
		SSblackbox.record_feedback("tally", "wizard_spell_learned", 1, name)
		log_purchase(user.key)
	try_equip_item(user, spawned_path)
	return spawned_path

/// Attempts to give the item to the buyer on purchase.
/datum/spellbook_entry/item/proc/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_put_in_hands = user.put_in_hands(to_equip)
	to_chat(user, span_notice("[to_equip.name] 已被召唤 [was_put_in_hands ? "到你手中" : "到你脚下"]."))

/// Ritual, these cause station wide effects and are (pretty much) a blank slate to implement stuff in
/datum/spellbook_entry/summon
	category = "仪式"
	limit = 1
	refundable = FALSE
	buy_word = "举行"

/datum/spellbook_entry/summon/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	if(log_buy)
		log_spellbook("[key_name(user)] 举行了 [src]，花费了 [cost] 点数")
		SSblackbox.record_feedback("tally", "wizard_spell_learned", 1, name)
		log_purchase(user.key)
	book.update_static_data(user) // updates "times" var
	return TRUE

/// Non-purchasable flavor spells to populate the spell book with, for style.
/datum/spellbook_entry/challenge
	name = "承接挑战"
	category = "挑战"
	refundable = FALSE
	buy_word = "承接"

// See, non-purchasable.
/datum/spellbook_entry/challenge/can_buy(mob/living/carbon/human/user, obj/item/spellbook/book)
	return FALSE
