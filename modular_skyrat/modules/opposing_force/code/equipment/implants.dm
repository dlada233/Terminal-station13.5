/datum/opposing_force_equipment/implants
	category = OPFOR_EQUIPMENT_CATEGORY_IMPLANTS

//Skillchips
/datum/opposing_force_equipment/implants/engichip
	item_type = /obj/item/skillchip/job/engineer
	description = "植入后,技能芯片可以让使用者理解塞博的线路布局和其功能."

/datum/opposing_force_equipment/implants/roboticist
	item_type = /obj/item/skillchip/job/roboticist
	description = "植入后,技能芯片可以让使用者一眼辨识出气闸和APC的线路布局并理解其功能.价值连城,极为抢手."

/datum/opposing_force_equipment/implants/tacticool
	item_type = /obj/item/skillchip/chameleon/reload

//Implants
/datum/opposing_force_equipment/implants/nodrop
	item_type = /obj/item/autosurgeon/syndicate/nodrop
	name = "防掉落植入物-Anti Drop Implant"
	admin_note = "令使用者加强握力,任何情况下都不会掉落所持物品.但如果被电磁脉冲 (EMP) 击中,使用者将长时间僵硬不动."
	description = "能够防止手中物品脱落的植入物. Comes loaded in a syndicate autosurgeon."

/datum/opposing_force_equipment/implants/hackerman
	item_type = /obj/item/autosurgeon/syndicate/hackerman
	name = "骇客臂植入物-Hacking Arm Implant"
	admin_note = "A simple tool arm, except it identifies all wire functions when hacking."
	description = "一个集成尖端黑客工具的高级手臂植入物.非常适合经过网络增强改造的线路行者."

/datum/opposing_force_equipment/implants/cns
	name = "中枢神经重启植入物-CNS Rebooter Implant"
	item_type = /obj/item/autosurgeon/syndicate/anti_stun
	description = "这个植入物将自动恢复你对中枢神经系统的控制,减少晕眩的恢复时间."

/datum/opposing_force_equipment/implants/reviver
	name = "复活植入物-Reviver Implant"
	item_type = /obj/item/autosurgeon/syndicate/reviver
	description = "This implant will attempt to revive and heal you if you lose consciousness. For the faint of heart!"

/datum/opposing_force_equipment/implants/sad_trombone
	name = "悲伤长号植入物-Sad Trombone Implant"
	item_type = /obj/item/implanter/sad_trombone

/datum/opposing_force_equipment/implants/toolarm
	name = "工具臂植入物-Tool Arm Implant"
	admin_note = "Force 20 implanted combat knife on emag."
	item_type = /obj/item/autosurgeon/toolset

/datum/opposing_force_equipment/implants/surgery
	name = "外科手术臂植入物-Surgery Arm Implant"
	admin_note = "Force 20 implanted combat knife on emag."
	item_type = /obj/item/autosurgeon/surgery

/datum/opposing_force_equipment/implants/botany
	name = "植物学臂植入物-Botany Arm Implant"
	admin_note = "Chainsaw arm on emag."
	item_type = /obj/item/autosurgeon/botany

/datum/opposing_force_equipment/implants/janitor
	name = "清洁工臂植入物-Janitor Arm Implant"
	item_type = /obj/item/autosurgeon/janitor

/datum/opposing_force_equipment/implants/armblade
	name = "螳螂刀植入物-Blade Arm Implant"
	admin_note = "Force 30 IF emagged."
	item_type = /obj/item/autosurgeon/armblade

/datum/opposing_force_equipment/implants/muscle
	name = "肌肉增强臂植入物-Muscle Arm Implant"
	item_type = /obj/item/autosurgeon/muscle

/datum/opposing_force_equipment/implants_illegal
	category = OPFOR_EQUIPMENT_CATEGORY_IMPLANTS_ILLEGAL

/datum/opposing_force_equipment/implants_illegal/stealth
	name = "潜行植入物-Stealth Implant"
	item_type = /obj/item/implanter/stealth
	admin_note = "Allows the user to become completely invisible as long as they remain inside a cardboard box."
	description = "一种植入物,让你可以使用终极隐形箱子之科技.最好配合磁带录音机播放「潜龙谍影」使用."

/datum/opposing_force_equipment/implants_illegal/radio
	name = "辛迪加内置无线电植入物-Syndicate Radio Implant"
	item_type = /obj/item/implanter/radio/syndicate
	description = "一个植入物,可以使用辛迪加无线电频道,同时也可以收听所有空间站频道."

/datum/opposing_force_equipment/implants_illegal/storage
	name = "存储植入物-Storage Implant"
	item_type = /obj/item/implanter/storage
	admin_note = "Allows user to stow items without any sign of having a storage item."
	description = "一个植入物，内含连接一小片蓝空的储存袋.能放入一点东西."

/datum/opposing_force_equipment/implants_illegal/freedom
	name = "自由植入物-Freedom Implant"
	item_type = /obj/item/implanter/freedom
	admin_note = "Allows the user to break handcuffs or e-snares four times, after it will run out and become useless."
	description = "An implanter that grants you the ability to break out of handcuffs a certain number of times."

/datum/opposing_force_equipment/implants_illegal/micro
	name = "微型炸弹植入物-Microbomb Implant"
	admin_note = "RRs the user."
	item_type = /obj/item/implanter/explosive
	description = "一个在你死亡时自动爆炸的植入物,中等的伤害范围."

/datum/opposing_force_equipment/implants_illegal/emp
	name = "EMP 植入物-EMP Implant"
	item_type = /obj/item/implanter/emp
	admin_note = "Gives the user a big EMP on an action button. Has three uses after which it becomes useless."
	description = "An implanter that grants you the ability to create several EMP pulses, centered on you."

/datum/opposing_force_equipment/implants_illegal/xray
	name = "X光眼-X-Ray Eyes"
	item_type = /obj/item/autosurgeon/syndicate/xray_eyes
	description = "这对电子眼球会带给你X射线视觉.眨眼变得毫无意义."

/datum/opposing_force_equipment/implants_illegal/thermal
	name = "热成像眼-Thermal Eyes"
	item_type = /obj/item/autosurgeon/syndicate/thermal_eyes
	description = "这对电子眼球会带给你热视觉.带有缝状竖瞳."

/datum/opposing_force_equipment/implants_illegal/armlaser
	name = "激光臂植入物-Arm-mounted Laser Implant"
	item_type = /obj/item/autosurgeon/syndicate/laser_arm
	admin_note = "A basic laser gun, but no-drop."
	description = "A variant of the arm cannon implant that fires lethal laser beams. The cannon emerges from the subject's arm and remains inside when not in use."

/datum/opposing_force_equipment/implants_illegal/eswordarm
	name = "能量剑植入物-Energy Sword Arm Implant"
	item_type = /obj/item/autosurgeon/syndicate/esword_arm
	admin_note = "Force 30 no-drop, extremely robust."
	description = "It's an energy sword, in your arm. Pretty decent for getting past stop-searches and assassinating people. Comes loaded in a Syndicate brand autosurgeon to boot!"

/datum/opposing_force_equipment/implants_illegal/baton
	name = "电击臂植入物-Baton Arm Implant"
	item_type = /obj/item/autosurgeon/syndicate/baton

/datum/opposing_force_equipment/implants_illegal/flash
	name = "闪光臂植入物-Flash Arm Implant"
	item_type = /obj/item/autosurgeon/syndicate/flash
