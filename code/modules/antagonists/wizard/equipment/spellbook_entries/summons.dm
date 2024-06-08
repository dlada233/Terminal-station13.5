// 影响整个站点的仪式法术
/// 我们需要多少威胁值才能让这些仪式发生在动态中
#define MINIMUM_THREAT_FOR_RITUALS 98

/datum/spellbook_entry/summon/ghosts
    name = "灵魂显形"
    desc = "让船员们看到死去的人以吓唬他们. 请注意，灵魂变化无常，可能会使用他们极其微弱的能力来捉弄你."
    cost = 0

/datum/spellbook_entry/summon/ghosts/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
    summon_ghosts(user)
    playsound(get_turf(user), 'sound/effects/ghost2.ogg', 50, TRUE)
    return ..()

/datum/spellbook_entry/summon/guns
    name = "召唤枪支"
    desc = "给一群对你有歹意的疯子发枪能有什么问题呢？他们很有可能先互相射击."

/datum/spellbook_entry/summon/guns/can_be_purchased()
    // 召唤枪支需要98威胁值.
    if(SSdynamic.threat_level < MINIMUM_THREAT_FOR_RITUALS)
        return FALSE
    // 还必须在配置中启用
    return !CONFIG_GET(flag/no_summon_guns)

/datum/spellbook_entry/summon/guns/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
    summon_guns(user, 10)
    playsound(get_turf(user), 'sound/magic/castsummon.ogg', 50, TRUE)
    return ..()

/datum/spellbook_entry/summon/magic
    name = "召唤魔法"
    desc = "与船员们分享魔法，然后他们会明白为什么之前不把魔法给他们用."

/datum/spellbook_entry/summon/magic/can_be_purchased()
    // 召唤魔法需要98威胁值.
    if(SSdynamic.threat_level < MINIMUM_THREAT_FOR_RITUALS)
        return FALSE
    // 还必须在配置中启用
    return !CONFIG_GET(flag/no_summon_magic)

/datum/spellbook_entry/summon/magic/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
    summon_magic(user, 10)
    playsound(get_turf(user), 'sound/magic/castsummon.ogg', 50, TRUE)
    return ..()

/datum/spellbook_entry/summon/events
    name = "召唤事件"
    desc = "作用于墨菲定律的一点，用特殊的巫师事件将替换到普通事件，这些特殊事件会令所有人感到迷惑. \
        多次施法会增加这些事件的发生概率."
    cost = 2
    limit = 5 // 每次购买可以加剧它.

/datum/spellbook_entry/summon/events/can_be_purchased()
    // 召唤事件需要98威胁值.
    if(SSdynamic.threat_level < MINIMUM_THREAT_FOR_RITUALS)
        return FALSE
    // 还必须在配置中启用
    return !CONFIG_GET(flag/no_summon_events)

/datum/spellbook_entry/summon/events/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
    summon_events(user)
    playsound(get_turf(user), 'sound/magic/castsummon.ogg', 50, TRUE)
    return ..()

/datum/spellbook_entry/summon/curse_of_madness
    name = "疯狂诅咒"
    desc = "诅咒整个站点，扭曲每个人的心智，造成持久的创伤，警告：如果不在安全距离施放，你也会被该法术影响."
    cost = 4

/datum/spellbook_entry/summon/curse_of_madness/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
    var/message = tgui_input_text(user, "发出有关于秘密真相的低语，让听到的人陷入疯狂", "疯狂的低语")
    if(!message || QDELETED(user) || QDELETED(book) || !can_buy(user, book))
        return FALSE
    curse_of_madness(user, message)
    playsound(user, 'sound/magic/mandswap.ogg', 50, TRUE)
    return ..()

/// 一个巫师仪式，允许巫师教会整个站点的每个人一个特定的法术书条目.
/// 这包括物品条目（会分发给每个人），但不包括其他类似的仪式.
/datum/spellbook_entry/summon/specific_spell
    name = "魔法公开课"
    desc = "教会空间站上的每个人一个特定的法术（或分发一个特定的物品）. \
        魔法公开课的成本会根据所教授的法术而增加，另外你也会学得所教授法术！"
    cost = 3 // 最便宜的成本是4，最贵的是7
    limit = 1

/datum/spellbook_entry/summon/specific_spell/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
    var/list/spell_options = list()
    for(var/datum/spellbook_entry/entry as anything in book.entries)
        if(istype(entry, /datum/spellbook_entry/summon))
            continue
        if(!entry.can_be_purchased())
            continue

        spell_options[entry.name] = entry

    sortTim(spell_options, GLOBAL_PROC_REF(cmp_text_asc))
    var/chosen_spell_name = tgui_input_list(user, "选择一个法术（或物品）给予所有人...", "魔法公开课", spell_options)
    if(isnull(chosen_spell_name) || QDELETED(user) || QDELETED(book))
        return FALSE
    if(GLOB.mass_teaching)
        tgui_alert(user, "有人已经施放了 [name]！", "魔法公开课", list("遗憾"))
        return FALSE

    var/datum/spellbook_entry/chosen_entry = spell_options[chosen_spell_name]
    if(cost + chosen_entry.cost > book.uses)
        tgui_alert(user, "你不能负担教授[chosen_spell_name]的费用！ （需要 [cost] 点）", "魔法公开课", list("遗憾"))
        return FALSE

    cost += chosen_entry.cost
    if(!can_buy(user, book))
        cost = initial(cost)
        return FALSE

    GLOB.mass_teaching = new(chosen_entry.type)
    GLOB.mass_teaching.equip_all_affected()

    var/item_entry = istype(chosen_entry, /datum/spellbook_entry/item)
    to_chat(user, span_hypnophrase("你已[ item_entry ? "给予每个人" : "教授给每个人"] [chosen_spell_name]！"))
    message_admins("[ADMIN_LOOKUPFLW(user)] 给予每个人 [item_entry ? "物品" : "法术"] \"[chosen_spell_name]\"！")
    user.log_message("已给予每个人 [item_entry ? "物品" : "法术"] \"[chosen_spell_name]\"！", LOG_GAME)

    name = "[name]: [chosen_spell_name]"
    return ..()

/datum/spellbook_entry/summon/specific_spell/can_buy(mob/living/carbon/human/user, obj/item/spellbook/book)
    if(GLOB.mass_teaching)
        return FALSE
    return ..()

/datum/spellbook_entry/summon/specific_spell/can_be_purchased()
    if(SSdynamic.threat_level < MINIMUM_THREAT_FOR_RITUALS)
        return FALSE
    if(GLOB.mass_teaching)
        return FALSE
    return ..()

#undef MINIMUM_THREAT_FOR_RITUALS
