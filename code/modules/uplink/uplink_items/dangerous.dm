//All bundles and telecrystals
/datum/uplink_category/dangerous
	name = "显眼武器"
	weight = 9

/datum/uplink_item/dangerous
	category = /datum/uplink_category/dangerous

/datum/uplink_item/dangerous/foampistol
	name = "玩具手枪和防暴泡沫弹"
	desc = "一个看起来很无辜的玩具手枪，用来发射泡沫弹，但一旦装上了防暴级泡沫弹，就能使目标丧失行动能力."
	item = /obj/item/gun/ballistic/automatic/pistol/toy/riot
	cost = 2
	surplus = 10
	purchasable_from = ~UPLINK_NUKE_OPS

/datum/uplink_item/dangerous/pistol
	name = "马卡洛夫手枪"
	desc = "一种小型，易于隐藏的手枪，打9mm子弹，弹匣容量为8发，可以装上消声器."
	item = /obj/item/gun/ballistic/automatic/pistol
	cost = 7
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/dangerous/throwingweapons
	name = "投掷武器包"
	desc = "一盒装有古流武术中的手里剑和强化绊索，绊索捆住人的脚让他摔倒，而手里剑则会嵌入人的四肢."
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 3
	illegal_tech = FALSE

/datum/uplink_item/dangerous/sword
	name = "能量剑"
	desc = "能量剑是一种带有纯能量刃的利器，在剑关闭时可以装进口袋；激活它会产生一种响亮而独特的噪音."
	progression_minimum = 20 MINUTES
	item = /obj/item/melee/energy/sword/saber
	cost = 8
	purchasable_from = ~UPLINK_CLOWN_OPS

/datum/uplink_item/dangerous/powerfist
	name = "动力拳套"
	desc = "动力拳头是一种金属护手，内置由外部气体供应驱动的活塞柱，换言之是气动式的. \
			在状态良好的情况下，一旦击中目标，活塞柱将向前延伸，对打击目标造成严重毁伤. \
			在活塞阀上使用扳手将允许你调整每次冲拳使用的气体量，这有利于适应不同的战场环境. \
			此外，只能安装一般大小的气瓶，安装时你不需要任何工具，但取出时则需要螺丝刀."
	progression_minimum = 20 MINUTES
	item = /obj/item/melee/powerfist
	cost = 6
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/dangerous/rapid
	name = "北极星拳套"
	desc = "这种手套极大地提高了穿戴者的拳头攻速，但对持械时的攻速则无益，对绿巨人的拳速也没有用."
	progression_minimum = 20 MINUTES
	item = /obj/item/clothing/gloves/rapid
	cost = 8

/datum/uplink_item/dangerous/doublesword
	name = "双刃能量剑"
	desc = "双刃能量剑的威力比普通能量剑的威力还要高，并且还能偏转能量投射物并保护你不被拦截，唯一的缺点是需要双手持握."
	progression_minimum = 30 MINUTES
	item = /obj/item/dualsaber

	cost = 13
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS) //nukies get their own version

/datum/uplink_item/dangerous/doublesword/get_discount_value(discount_type)
	switch(discount_type)
		if(TRAITOR_DISCOUNT_BIG)
			return 0.5
		if(TRAITOR_DISCOUNT_AVERAGE)
			return 0.35
		else
			return 0.2

/datum/uplink_item/dangerous/guardian
	name = "全息寄生物"
	desc = "全息寄生物是一种由硬光全息技术与纳米机器技术所创造的寄生生命，没有固定形体的它们拥有近乎魔法般的技能，它们只需要一个有机宿主作为修复和燃料的来源.\
	    全息寄生物有多重类型，可以从事各种行动，且与它们的宿主共享伤害."
	progression_minimum = 30 MINUTES
	item = /obj/item/guardian_creator/tech
	cost = 18
	surplus = 0
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	restricted = TRUE
	refundable = TRUE

/datum/uplink_item/dangerous/revolver
	name = "辛迪加左轮"
	desc = "Waffle公司设计的现代化左轮，打.357马格南子弹，有七发容量，威力十分恐怖."
	item = /obj/item/gun/ballistic/revolver/syndicate
	cost = 13
	surplus = 50
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS) //nukies get their own version

/datum/uplink_item/dangerous/cat
	name = "野猫手榴弹"
	desc = "这个手榴弹里装满了五只疯狂的野猫，一旦引爆将释放出五只野猫来攻击不幸的人们，警告:这些猫没有被训练过辨别敌友!"
	cost = 5
	item = /obj/item/grenade/spawnergrenade/cat
	surplus = 30
