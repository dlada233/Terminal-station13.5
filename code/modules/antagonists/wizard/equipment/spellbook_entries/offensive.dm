// 进攻性巫师法术
/datum/spellbook_entry/fireball
    name = "火球术"
    desc = "向目标发射一个爆炸性的火球，所有巫师公认的经典法术."
    spell_type = /datum/action/cooldown/spell/pointed/projectile/fireball
    category = "进攻"

/datum/spellbook_entry/spell_cards
    name = "魔法卡牌"
    desc = "炽热的快速追踪卡牌，用它们的神秘力量将你的敌人送入冥界！"
    spell_type = /datum/action/cooldown/spell/pointed/projectile/spell_cards
    category = "进攻"

/datum/spellbook_entry/rod_form
    name = "变杆术"
    desc = "变成不可移动杆，摧毁你路径上的所有物体，多次购买此法术会增加杆的伤害和行进距离."
    spell_type = /datum/action/cooldown/spell/rod_form
    category = "进攻"

/datum/spellbook_entry/disintegrate
    name = "裂解之手"
    desc = "将不洁的能量注入手掌，触摸目标就会发生爆炸！"
    spell_type = /datum/action/cooldown/spell/touch/smite
    category = "进攻"

/datum/spellbook_entry/summon_simians
    name = "猿猴召唤术"
    desc = "此法术深入香蕉元素位面（猴子的那个香蕉，不是小丑的），召来原始猴子和小猩猩，它们会因为好玩立刻攻击视野内的所有事物！它们低级、易于操纵的心智会让它们认为你是盟友，但只能保持一分钟，除非你也是一只猴子."
    spell_type = /datum/action/cooldown/spell/conjure/simian
    category = "进攻"

/datum/spellbook_entry/blind
    name = "致盲术"
    desc = "暂时致盲一个目标."
    spell_type = /datum/action/cooldown/spell/pointed/blind
    category = "进攻"
    cost = 1

/datum/spellbook_entry/mutate
    name = "突变术"
    desc = "短暂使你变成浩克，并获得激光眼."
    spell_type = /datum/action/cooldown/spell/apply_mutations/mutate
    category = "进攻"

/datum/spellbook_entry/fleshtostone
    name = "石化之手"
    desc = "让手掌充满魔力，将目标变成没有活性雕像，持续很长时间."
    spell_type = /datum/action/cooldown/spell/touch/flesh_to_stone
    category = "进攻"

/datum/spellbook_entry/teslablast
    name = "特斯拉电弧"
    desc = "放出特斯拉弧电击附近的随机目标！电弧能击倒目标并来回跳跃，并且此法术还可以一边充能一边移动."
    spell_type = /datum/action/cooldown/spell/charged/beam/tesla
    category = "进攻"

/datum/spellbook_entry/lightningbolt
    name = "闪电箭"
    desc = "向敌人发射闪电箭！它会在目标之间跳跃但不会造成击倒."
    spell_type = /datum/action/cooldown/spell/pointed/projectile/lightningbolt
    category = "进攻"
    cost = 1

/datum/spellbook_entry/infinite_guns
    name = "次级枪械召唤术"
    desc = "当你有无限把枪时为什么还要装弹？不断地召唤栓动步枪到手中，虽然伤害不高，但能击倒目标. 需要双手空闲才能使用，学习此法术会使你无法学习奥术弹幕."
    spell_type = /datum/action/cooldown/spell/conjure_item/infinite_guns/gun
    category = "进攻"
    cost = 3
    no_coexistance_typecache = list(/datum/action/cooldown/spell/conjure_item/infinite_guns/arcane_barrage)

/datum/spellbook_entry/arcane_barrage
    name = "奥术魔弹"
    desc = "从手中连续发射高伤害的奥术魔弹，伤害比次级枪械召唤术更高，但不会击倒目标. 需要双手空闲才能使用. 学习此法术会使你无法学习次级枪械召唤术."
    spell_type = /datum/action/cooldown/spell/conjure_item/infinite_guns/arcane_barrage
    category = "进攻"
    cost = 3
    no_coexistance_typecache = list(/datum/action/cooldown/spell/conjure_item/infinite_guns/gun)

/datum/spellbook_entry/barnyard
    name = "农场诅咒"
    desc = "此法术让被诅咒倒霉蛋长出动物的脸只能发出动物的叫声."
    spell_type = /datum/action/cooldown/spell/pointed/barnyardcurse
    category = "进攻"

/datum/spellbook_entry/splattercasting
    name = "化身血法师"
    desc = "大幅降低所有法术的冷却时间，但每个法术都会消耗血液，并且会自然流失. 但你也同时获得从他人的脖子中吸血的能力."
    spell_type =  /datum/action/cooldown/spell/splattercasting
    category = "进攻"
    no_coexistance_typecache = list(/datum/action/cooldown/spell/lichdom)

/datum/spellbook_entry/sanguine_strike
    name = "抽血一击"
    desc = "一个血腥的法术，使你的下一次武器攻击造成更多伤害，为你治疗并补充血液."
    spell_type =  /datum/action/cooldown/spell/sanguine_strike
    category = "进攻"

/datum/spellbook_entry/scream_for_me
    name = "为我尖叫"
    desc = "一个虐待狂的血腥法术，在受害者的身体上造成大量的重流血伤口."
    spell_type =  /datum/action/cooldown/spell/touch/scream_for_me
    cost = 1
    category = "进攻"

/datum/spellbook_entry/item/staffchaos
    name = "混沌法杖"
    desc = "一根变化莫测的法杖，毫无征兆地发射各种魔法，不建议对你在乎的人使用."
    item_path = /obj/item/gun/magic/staff/chaos
    category = "进攻"

/datum/spellbook_entry/item/staffchange
    name = "变化法杖"
    desc = "一件神器，发射改变目标的形态的能量束."
    item_path = /obj/item/gun/magic/staff/change
    category = "进攻"

/datum/spellbook_entry/item/mjolnir
    name = "雷神之锤"
    desc = "一把借自雷神托尔的强大锤子，里面充盈的力量几乎无法控制."
    item_path = /obj/item/mjollnir
    category = "进攻"

/datum/spellbook_entry/item/singularity_hammer
    name = "奇点锤"
    desc = "一把锤子，在击中时产生一个强大的引力场，将附近的一切拉向冲击点."
    item_path = /obj/item/singularityhammer
    category = "进攻"

/datum/spellbook_entry/item/spellblade
    name = "奥术魔刃"
    desc = "一把能够发射能量波的魔刃，这些能量波可以将目标撕裂."
    item_path = /obj/item/gun/magic/staff/spellblade
    category = "进攻"

/datum/spellbook_entry/item/highfrequencyblade
    name = "高频振动刀"
    desc = "一把附魔的快刀，振动频率高到足以切开任何东西."
    item_path = /obj/item/highfrequencyblade/wizard
    category = "进攻"
    cost = 3

/datum/spellbook_entry/item/frog_contract
    name = "青蛙契约"
    desc = "与青蛙签订契约，获得你自己的战斗宠物！"
    item_path = /obj/item/frog_contract
    category = "进攻"
