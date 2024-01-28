/datum/uplink_category/stealthy_tools
	name = "潜行装备"
	weight = 4

/datum/uplink_item/stealthy_tools
	category = /datum/uplink_category/stealthy_tools


/datum/uplink_item/stealthy_tools/agent_card
	name = "特工卡"
	desc = "代理卡可以防止AI跟踪佩戴者，并能复制收录其他ID卡中的最多5个通用权限， \
			此外，还可以任意次改变卡的外貌，一些辛迪加区域和设备也只能使用这些卡访问."
	item = /obj/item/card/id/advanced/chameleon
	cost = 2

/datum/uplink_item/stealthy_tools/ai_detector
	name = "AI视觉探测器"
	desc = "这是一款多功能工具，当检测到AI在监视它时，它会变成红色，并且可以激活它来粗略探测AI的存在,  \
			有了它之后，你就可以知道什么时候AI在监视你."
	item = /obj/item/multitool/ai_detect
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	cost = 1

/datum/uplink_item/stealthy_tools/chameleon
	name = "变色龙工具包"
	desc = "一套应用了变色龙技术的产品，可以让你伪装成空间站上的任何东西!由于预算削减，这双鞋不提供防滑功能，而且技能芯片是单独出售的."
	item = /obj/item/storage/box/syndie_kit/chameleon
	cost = 2
	purchasable_from = ~UPLINK_NUKE_OPS //clown ops are allowed to buy this kit, since it's basically a costume

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "防滑变色龙鞋"
	desc = "这种鞋子可以让穿着者在潮湿的地板和光滑的物体上跑步而不会摔倒，但要是太滑了就没办法了."
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 2
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "变色龙投影仪"
	desc = "在用户身上投影扫描的图像，把他们伪装成被扫描的对象，只要他们不把投影仪从手中移开。伪装的用户移动缓慢，弹丸从他们身上飞过。"
	item = /obj/item/chameleon
	cost = 7

/datum/uplink_item/stealthy_tools/codespeak_manual
	name = "密语手册"
	desc = "辛迪加特工可以接受训练，使用一系列的密语来传达复杂的信息，外人听起来就像是随机的概念和饮料名称. \
			本手册教你使用密语。你也可以用手册打别人来教他们，这本是豪华版，可以无限使用."
	item = /obj/item/language_manual/codespeak_manual/unlimited
	cost = 3

/datum/uplink_item/stealthy_tools/emplight
	name = "EMP 手电筒"
	desc = "一个小型的，自充电的，短距离电磁脉冲装置，伪装成一个工作手电筒；\
			用这款手电筒攻击目标时，会向目标发射电磁脉冲并消耗电量；\
			用于在隐蔽行动中干扰耳机、摄像头、门、储物柜和赛博格."
	item = /obj/item/flashlight/emp
	cost = 4
	surplus = 30

/datum/uplink_item/stealthy_tools/emplight/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 3

/datum/uplink_item/stealthy_tools/mulligan
	name = "穆里根"
	desc = "搞砸了还被安保跟踪?这个方便的注射器会给你一个全新的身份和外观."
	item = /obj/item/reagent_containers/syringe/mulligan
	cost = 4
	surplus = 30
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_tools/jammer
	name = "无线电干扰机"
	desc = "这个装置启动后会干扰附近的无线电通讯，不影响二进制信息传递."
	item = /obj/item/jammer
	cost = 5

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "走私挎包"
	desc = "这个包很薄，可以隐藏在镀板和瓷砖之间的缝隙中，很适合存放赃物，里面有一个撬棍，一块地砖和一些违禁品."
	item = /obj/item/storage/backpack/satchel/flat/with_tools
	cost = 1
	surplus = 30
	illegal_tech = FALSE

/datum/uplink_item/stealthy_tools/mail_counterfeit
	name = "GLA伪造邮件设备"
	desc = "能够伪造NT邮件的设备，该设备还可以在邮件中放置陷阱以进行恶意操作，陷阱将在邮件拆开时“激活”邮件中的任何物品，它也可能被用于传递物品."
	item = /obj/item/storage/mail_counterfeit_device
	cost = 1
	surplus = 30

/datum/uplink_item/stealthy_tools/telecomm_blackout
	name = "电信关闭病毒"
	desc = "购买时，病毒将被上传到电信处理服务器，使其暂时被禁用."
	item = /obj/effect/gibspawner/generic
	surplus = 0
	progression_minimum = 15 MINUTES
	limited_stock = 1
	cost = 4
	restricted = TRUE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_tools/telecomm_blackout/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	force_event(/datum/round_event_control/communications_blackout, "辛迪加病毒")
	return source //For log icon

/datum/uplink_item/stealthy_tools/blackout
	name = "触发全站停电"
	desc = "购买后，病毒会被上传到工程处理服务器强制进行例行电网检查，迫使站点上所有APC暂时瘫痪."
	item = /obj/effect/gibspawner/generic
	surplus = 0
	progression_minimum = 20 MINUTES
	limited_stock = 1
	cost = 6
	restricted = TRUE
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/stealthy_tools/blackout/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	force_event(/datum/round_event_control/grid_check, "a syndicate virus")
	return source //For log icon
