// 巫师法术，帮助施法者以某种方式
/datum/spellbook_entry/summonitem
    name = "唤来术"
    desc = "从宇宙的任何角落将之前标记的物品召回到你手中."
    spell_type = /datum/action/cooldown/spell/summonitem
    category = "辅助"
    cost = 1

/datum/spellbook_entry/charge
    name = "充能术"
    desc = "这个法术可以用来为你手中的各种物品充能，从魔法神器到电气元件均可. 一个有创意的巫师甚至可以用它为另一个魔法使用者赋予魔力."
    spell_type = /datum/action/cooldown/spell/charge
    category = "辅助"
    cost = 1

/datum/spellbook_entry/shapeshift
    name = "狂野变形"
    desc = "变成另一种形态，暂时使用其能力. 一旦你做出选择，就无法改变."
    spell_type = /datum/action/cooldown/spell/shapeshift/wizard
    category = "辅助"
    cost = 1

/datum/spellbook_entry/tap
    name = "灵魂注能"
    desc = "点燃自己的灵魂化为魔法之炎！"
    spell_type = /datum/action/cooldown/spell/tap
    category = "辅助"
    cost = 1

/datum/spellbook_entry/item/staffanimation
    name = "活化法杖"
    desc = "一根能够射出神秘能量的奥术法杖，使无生命物体活过来. 这种魔法不影响机器."
    item_path = /obj/item/gun/magic/staff/animate
    category = "辅助"

/datum/spellbook_entry/item/soulstones
    name = "灵魂石碎片套件"
    desc = "灵魂石碎片是古老的工具，能够捕捉和利用死者和垂死者的灵魂. \
        法术技艺师允许你创造奥术机器供被捕捉的灵魂驾驶."
    item_path = /obj/item/storage/belt/soulstone/full
    category = "辅助"

/datum/spellbook_entry/item/soulstones/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
    var/was_equipped = user.equip_to_slot_if_possible(to_equip, ITEM_SLOT_BELT, disable_warning = TRUE)
    to_chat(user, span_notice("[to_equip.name] 已被召唤 [was_equipped ? "到你的腰上" : "到你的脚下"]."))

/datum/spellbook_entry/item/soulstones/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
    . =..()
    if(!.)
        return

    var/datum/action/cooldown/spell/conjure/construct/bonus_spell = new(user.mind || user)
    bonus_spell.Grant(user)

/datum/spellbook_entry/item/necrostone
    name = "不死石"
    desc = "不死石能够复活三名死者，使其成为服侍你的骷髅仆从."
    item_path = /obj/item/necromantic_stone
    category = "辅助"

/datum/spellbook_entry/item/contract
    name = "学徒合同"
    desc = "一份魔法契约，迫使一名巫师学徒履行服侍义务，使用它会将其召唤到你身边."
    item_path = /obj/item/antag_spawner/contract
    category = "辅助"
    refundable = TRUE

/datum/spellbook_entry/item/guardian
    name = "守护灵卡组"
    desc = "一副守护灵塔罗牌，能够将守护灵同自己的肉体绑定，有多种类型的守护灵可供选择，但请注意你们共享伤害. \
    因为守护灵只与肉体绑定，所以要注意避免交换肉体."
    item_path = /obj/item/guardian_creator/wizard
    category = "辅助"

/datum/spellbook_entry/item/bloodbottle
    name = "魔血瓶"
    desc = "一瓶注入魔法的血液，碎开时会引来超维生物. 请小心，\
        这些血魔法召唤而出的生物会进行无差别杀戮，你自己也可能成为目标."
    item_path = /obj/item/antag_spawner/slaughter_demon
    limit = 3
    category = "辅助"
    refundable = TRUE

/datum/spellbook_entry/item/hugbottle
    name = "拥抱瓶"
    desc = "一瓶注入魔法的欢乐，破碎时会吸引可爱的超维生物. 这些生物\
        类似于屠杀恶魔，但它们不会杀死受害者，而是将他们送入一个超维的拥抱空间，\
        只有在该恶魔死亡时受害者才会被释放出来. 能造成混乱但到底是无害的，只是船员们对此的反应可能非常具有破坏性."
    item_path = /obj/item/antag_spawner/slaughter_demon/laughter
    cost = 1 //无破坏性；这只是个玩笑，兄弟姐妹！
    limit = 3
    category = "辅助"
    refundable = TRUE

/datum/spellbook_entry/item/vendormancer
    name = "售货机术法杖"
    desc = "一杆寄宿着符文售货术之力的法杖.\
        它可以召唤最多3个随时间衰弱的符文售货机，通过\
        投掷来砸扁对手或直接引爆. 当耗尽充能时，进行长时间引导将恢复充能."
    item_path = /obj/item/runic_vendor_scepter
    category = "辅助"
