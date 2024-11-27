// Shotgun

/obj/item/ammo_casing/shotgun
	name = "霰弹"
	desc = "一颗12g霰弹子弹."
	icon_state = "blshell"
	worn_icon_state = "shell"
	caliber = CALIBER_SHOTGUN
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)
	projectile_type = /obj/projectile/bullet/shotgun_slug

/obj/item/ammo_casing/shotgun/executioner
	name = "处决弹"
	desc = "一颗12g口径的铅弹，命中活体时能摧毁血肉."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_slug/executioner

/obj/item/ammo_casing/shotgun/pulverizer
	name = "粉碎弹"
	desc = "一颗12g口径的铅弹，命中活体时能粉碎骨骼."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_slug/pulverizer

/obj/item/ammo_casing/shotgun/beanbag
	name = "豆袋弹"
	desc = "用于镇暴的低致命霰弹."
	icon_state = "bshell"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*2.5)
	projectile_type = /obj/projectile/bullet/shotgun_beanbag
	harmful = FALSE //SKYRAT EDIT ADDITION

/obj/item/ammo_casing/shotgun/incendiary
	name = "燃烧弹"
	desc = "一颗有易燃化学涂装的霰弹."
	icon_state = "ishell"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun

/obj/item/ammo_casing/shotgun/incendiary/no_trail
	name = "点燃弹"
	desc = "一颗有易燃化学涂装的霰弹. 经过了特殊处理，将只在命中时点燃目标."
	projectile_type = /obj/projectile/bullet/incendiary/shotgun/no_trail

/obj/item/ammo_casing/shotgun/dragonsbreath
	name = "龙息弹"
	desc = "一颗能发射喷射出大量燃烧弹丸的霰弹子弹."
	icon_state = "ishell2"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun/dragonsbreath
	pellets = 4
	variance = 35

/obj/item/ammo_casing/shotgun/stunslug
	name = "泰瑟弹"
	desc = "一颗能将人电晕的霰弹子弹."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_stunslug
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*2.5)

/obj/item/ammo_casing/shotgun/meteorslug
	name = "流星弹"
	desc = "一颗采用CMC技术的霰弹子弹，能发射出巨大的子弹."
	icon_state = "mshell"
	projectile_type = /obj/projectile/bullet/cannonball/meteorslug

/obj/item/ammo_casing/shotgun/pulseslug
	name = "脉冲弹"
	desc = "一颗霰弹外形的精密装置. 底火被改造成了一个触发增益介质的按钮，按下后引发一次性的能量射击. 它的设计用途是针对那些实弹难以攻击到的目标."
	icon_state = "pshell"
	projectile_type = /obj/projectile/beam/pulse/shotgun

/obj/item/ammo_casing/shotgun/frag12
	name = "FRAG-12霰弹"
	desc = "一颗12g的高爆霰弹子弹."
	icon_state = "heshell"
	projectile_type = /obj/projectile/bullet/shotgun_frag12

/obj/item/ammo_casing/shotgun/buckshot
	name = "鹿弹"
	desc = "一颗12g鹿弹."
	icon_state = "gshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_buckshot
	pellets = 6
	variance = 25

/obj/item/ammo_casing/shotgun/buckshot/spent
	projectile_type = null

/obj/item/ammo_casing/shotgun/rubbershot
	name = "橡胶弹"
	desc = "一颗装满了橡胶弹丸的霰弹子弹，可使远处的人群丧失行动能力."
	icon_state = "rshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_rubbershot
	pellets = 6
	variance = 20
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)

/obj/item/ammo_casing/shotgun/incapacitate // 该项下的文本不会在游戏内显示，物品另有名称与描述
	name = "自定义失能霰弹"
	desc = "这颗霰弹里装满了...东西. 用于使目标失能."
	icon_state = "bountyshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_incapacitate
	pellets = 12//double the pellets, but half the stun power of each, which makes this best for just dumping right in someone's face.
	variance = 25
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)

/obj/item/ammo_casing/shotgun/ion
	name = "离子弹"
	desc = "一颗先进的霰弹，使用子空间安塞波晶体产生类似于标准离子步枪射击的效果，晶体的独特特性又将离子脉冲分裂成一系列小股脉冲以达到霰弹的效果."
	icon_state = "ionshell"
	projectile_type = /obj/projectile/ion/weak
	pellets = 4
	variance = 35

/obj/item/ammo_casing/shotgun/scatterlaser
	name = "散射光能弹"
	desc = "一颗先进的霰弹，使用微型光能来复制散射光能武器的效果."
	icon_state = "lshell"
	projectile_type = /obj/projectile/beam/scatter
	pellets = 6
	variance = 35

/obj/item/ammo_casing/shotgun/scatterlaser/emp_act(severity)
	. = ..()
	if(isnull(loaded_projectile) || !prob(40/severity))
		return
	name = "故障散射光能弹"
	desc = "一颗先进的霰弹，使用微型光能来复制散射光能武器的效果，但这颗里用于供电的电容器似乎在冒烟."
	projectile_type = /obj/projectile/beam/scatter/pathetic
	loaded_projectile = new projectile_type(src)

/obj/item/ammo_casing/shotgun/techshell
	name = "空载科技弹"
	desc = "一颗高科技的霰弹，可以装载各种材料，产生各种独特效果."
	icon_state = "cshell"
	projectile_type = null

/obj/item/ammo_casing/shotgun/techshell/Initialize(mapload)
	. = ..()

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/meteorslug, /datum/crafting_recipe/pulseslug, /datum/crafting_recipe/dragonsbreath, /datum/crafting_recipe/ionslug)

	AddComponent(
		/datum/component/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/ammo_casing/shotgun/dart
	name = "霰弹镖"
	desc = "用于霰弹枪的飞镖，里面可以装载多达15u的任意化学物质."
	icon_state = "cshell"
	projectile_type = /obj/projectile/bullet/dart
	var/reagent_amount = 15

/obj/item/ammo_casing/shotgun/dart/Initialize(mapload)
	. = ..()
	create_reagents(reagent_amount, OPENCONTAINER)

/obj/item/ammo_casing/shotgun/dart/attackby()
	return

/obj/item/ammo_casing/shotgun/dart/bioterror
	desc = "改良后的霰弹镖，里面充满了致命的毒素，可以装载多达30u的任意化学物质."
	reagent_amount = 30

/obj/item/ammo_casing/shotgun/dart/bioterror/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/neurotoxin, 6)
	reagents.add_reagent(/datum/reagent/toxin/spore, 6)
	reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 6) //;HELP OPS IN MAINT
	reagents.add_reagent(/datum/reagent/toxin/coniine, 6)
	reagents.add_reagent(/datum/reagent/toxin/sodium_thiopental, 6)

/obj/item/ammo_casing/shotgun/breacher
	name = "破门弹"
	desc = "一颗12g的反器材弹，非常适合快速破门和破窗."
	icon_state = "breacher"
	projectile_type = /obj/projectile/bullet/shotgun_breaching
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)
