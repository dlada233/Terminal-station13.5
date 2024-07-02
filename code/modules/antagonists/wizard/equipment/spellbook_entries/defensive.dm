#define SPELLBOOK_CATEGORY_DEFENSIVE "防御"
// Defensive wizard spells
/datum/spellbook_entry/magicm
	name = "魔法飞弹"
	desc = "向附近的目标发射几个缓慢移动的魔法投射物."
	spell_type = /datum/action/cooldown/spell/aoe/magic_missile
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/disabletech
	name = "科学封印"
	desc = "禁用范围内的所有武器、摄像头和大多数其他科技产品."
	spell_type = /datum/action/cooldown/spell/emp/disable_tech
	category = SPELLBOOK_CATEGORY_DEFENSIVE
	cost = 1

/datum/spellbook_entry/repulse
	name = "驱逐术"
	desc = "将周围的一切击飞."
	spell_type = /datum/action/cooldown/spell/aoe/repulse/wizard
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/lightning_packet
	name = "飞雷术"
	desc = "由古老的能量锻造而成，包含着纯净的能量的投掷沙包，\
        俗称法术沙包，使用后会出现在你手中，将其投掷会击晕目标."
	spell_type = /datum/action/cooldown/spell/conjure_item/spellpacket
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/timestop
	name = "时间停止"
	desc = "除了你之外的所有人甚至连投射物都被冻结暂停，让你可以自由移动."
	spell_type = /datum/action/cooldown/spell/timestop
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/smoke
	name = "烟雾术"
	desc = "在你的位置生成一片让人窒息的烟雾."
	spell_type = /datum/action/cooldown/spell/smoke
	category = SPELLBOOK_CATEGORY_DEFENSIVE
	cost = 1

/datum/spellbook_entry/forcewall
	name = "斥力墙"
	desc = "创造一堵只有你能通过的魔法屏障."
	spell_type = /datum/action/cooldown/spell/forcewall
	category = SPELLBOOK_CATEGORY_DEFENSIVE
	cost = 1

/datum/spellbook_entry/lichdom
	name = "灵魂绑定契约"
	desc = "一份邪恶的死灵契约，通过把自己的灵魂绑定到一件物品上，将自己变成一个不死的巫妖\
    	只要绑定物品完好无损，任何情况下你都可以复活.\
        但代价是每次复活，你的身体都会变得更虚弱，\
        别人也会更容易找到你的不死力量的来源."
	spell_type =  /datum/action/cooldown/spell/lichdom
	category = SPELLBOOK_CATEGORY_DEFENSIVE
	no_coexistance_typecache = list(/datum/action/cooldown/spell/splattercasting)

/datum/spellbook_entry/chuunibyou
	name = "中二吟唱词"
	desc = "让你在释放所有法术时喊出愚蠢施法词. 你在施法后会有轻微的恢复效果."
	spell_type =  /datum/action/cooldown/spell/chuuni_invocations
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/spacetime_dist
	name = "时空扭曲"
	desc = "随机分布你周围的区域中纠缠时空的弦，使人无法正常移动，一切事物都会在弦的无序振动中被打乱..."
	spell_type = /datum/action/cooldown/spell/spacetime_dist
	category = SPELLBOOK_CATEGORY_DEFENSIVE
	cost = 1

/datum/spellbook_entry/the_traps
	name = "陷阱术"
	desc = "在你周围召唤一些陷阱，它们会对伤害并激怒踩到陷阱的敌人."
	spell_type = /datum/action/cooldown/spell/conjure/the_traps
	category = SPELLBOOK_CATEGORY_DEFENSIVE
	cost = 1

/datum/spellbook_entry/bees
	name = "次级蜜蜂召唤术"
	desc = "这个术式调用魔法去踢一下超维蜂巢，瞬间在你的位置召唤出一群会攻击任何人蜜蜂."
	spell_type = /datum/action/cooldown/spell/conjure/bee
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/duffelbag
	name = "旅行包诅咒"
	desc = "一个诅咒，将一个恶魔旅行包牢牢附着在目标的背上.\
        如果不定期喂养，旅行包会使被附身者受到周期性伤害，\
        而且无论该包是否被喂养，都会显著减慢穿戴者的速度."
	spell_type = /datum/action/cooldown/spell/touch/duffelbag
	category = SPELLBOOK_CATEGORY_DEFENSIVE
	cost = 1

/datum/spellbook_entry/item/staffhealing
	name = "治愈法杖"
	desc = "一根无私的法杖，从治愈瘸腿到复活死者都可以做到."
	item_path = /obj/item/gun/magic/staff/healing
	cost = 1
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/item/lockerstaff
	name = "储物柜法杖"
	desc = "一根能射出储物柜的法杖，它会吞噬路径上的任何人，将他们困在焊死的储物柜中."
	item_path = /obj/item/gun/magic/staff/locker
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/item/scryingorb
	name = "占卜球"
	desc = "一颗充满魔力的球体，使用它可以让你灵魂出窍，允许你观察空间站并与亡者交谈. 此外，购买它将永久给予你透视能力."
	item_path = /obj/item/scrying
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/item/wands
	name = "魔杖合集腰带"
	desc = "一根挂了各种魔杖的腰带，但上面的魔杖使用次数都是有限的"
	item_path = /obj/item/storage/belt/wands/full
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/item/wands/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_equipped = user.equip_to_slot_if_possible(to_equip, ITEM_SLOT_BELT, disable_warning = TRUE)
	to_chat(user, span_notice("[to_equip.name] 被召唤[was_equipped ? "到你的腰间" : "到你的脚下"]."))

/datum/spellbook_entry/item/armor
	name = "精工铠甲套装"
	desc = "一套拥有防护性能和太空环境适应的神器铠甲，穿上后同巫师袍一样能让你释放法术，还提供一个战法师护盾."
	item_path = /obj/item/mod/control/pre_equipped/enchanted
	category = SPELLBOOK_CATEGORY_DEFENSIVE

/datum/spellbook_entry/item/armor/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/obj/item/mod/control/mod = to_equip
	var/obj/item/mod/module/storage/storage = locate() in mod.modules
	var/obj/item/back = user.back
	if(back)
		if(!user.dropItemToGround(back))
			return
		for(var/obj/item/item as anything in back.contents)
			item.forceMove(storage)
	if(!user.equip_to_slot_if_possible(mod, mod.slot_flags, qdel_on_fail = FALSE, disable_warning = TRUE))
		return
	if(!user.dropItemToGround(user.wear_suit) || !user.dropItemToGround(user.head))
		return
	mod.quick_activation()

/datum/spellbook_entry/item/battlemage_charge
	name = "战法师铠甲充能"
	desc = "一个强大的防御性法术，赋予战法师护盾八层充能."
	item_path = /obj/item/wizard_armour_charge
	category = SPELLBOOK_CATEGORY_DEFENSIVE
	cost = 1

#undef SPELLBOOK_CATEGORY_DEFENSIVE
