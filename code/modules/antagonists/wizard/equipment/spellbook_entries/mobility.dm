// 帮助位移（或隐身？）的巫师法术
/datum/spellbook_entry/mindswap
    name = "心灵交换"
    desc = "允许你与身边的目标交换身体，交换时会导致彼此昏睡，如果有人目击，你的交换行为会很明显的暴露."
    spell_type = /datum/action/cooldown/spell/pointed/mind_transfer
    category = "位移"

/datum/spellbook_entry/knock
    name = "敲门术"
    desc = "打开附近的门和储物柜."
    spell_type = /datum/action/cooldown/spell/aoe/knock
    category = "位移"
    cost = 1

/datum/spellbook_entry/blink
    name = "闪现术"
    desc = "随机地将你传送一小段距离."
    spell_type = /datum/action/cooldown/spell/teleport/radius_turf/blink
    category = "位移"

/datum/spellbook_entry/teleport
    name = "传送术"
    desc = "将你传送到指定区域."
    spell_type = /datum/action/cooldown/spell/teleport/area_teleport/wizard
    category = "位移"

/datum/spellbook_entry/jaunt
    name = "虚空漫步"
    desc = "将你暂时转成虚无态，隐形并能穿墙而过."
    spell_type = /datum/action/cooldown/spell/jaunt/ethereal_jaunt
    category = "位移"

/datum/spellbook_entry/swap
    name = "交换"
    desc = "与半径九格范围内的任何活体目标交换位置，右键标记次要目标. 指定主要目标即发动，发动时你与主要目标交换位置，主要目标与次要目标交换位置."
    spell_type = /datum/action/cooldown/spell/pointed/swap
    category = "位移"
    cost = 1

/datum/spellbook_entry/item/warpwhistle
    name = "传送哨"
    desc = "一个奇怪的哨子，能将你传送到站内的一个安全远处. "
    item_path = /obj/item/warp_whistle
    category = "位移"
    cost = 1

/datum/spellbook_entry/item/staffdoor
    name = "造门法杖"
    desc = "一根特殊的法杖，可以将实墙变为精致的门，缺乏移动工具时很有用. 不适用于玻璃."
    item_path = /obj/item/gun/magic/staff/door
    cost = 1
    category = "位移"
