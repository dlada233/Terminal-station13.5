/datum/uplink_category/role_restricted
	name = "角色特色"
	weight = 1

/datum/uplink_item/role_restricted
	category = /datum/uplink_category/role_restricted
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/role_restricted/haunted_magic_eightball
	name = "魔法八号球"
	desc = "很少有人知道存在真正的魔法八号球，他们都以为这只是一种玩具. \
			这颗真正的魔法八号球，可以召集附近的灵魂来回答你的问题，当然灵魂没有义务必须给出正确答案."
	item = /obj/item/toy/eightball/haunted
	cost = 2
	restricted_roles = list(JOB_CURATOR)
	limited_stock = 1 //please don't spam deadchat
	surplus = 5

/datum/uplink_item/role_restricted/mail_counterfeit_kit
	name = "GLA伪造邮件包"
	desc = "里面包含六台伪造邮件工具，以下是详细使用步骤：先把你要递送的物品放进去，然后使用工具开始打包成邮件，选择打包成大小两种类型的信封，选择是否在开启信封时激活内部物品（比如激活炸弹），然后选择寄出的对象（除对象外的信封均无法打开信封），写信封抬头（可留空），最终你就得到一封烧不烂浸不湿的伪造信封."
	item = /obj/item/storage/box/syndie_kit/mail_counterfeit
	cost = 2
	illegal_tech = FALSE
	restricted_roles = list(JOB_CARGO_TECHNICIAN, JOB_QUARTERMASTER)
	surplus = 5

/datum/uplink_item/role_restricted/bureaucratic_error
	name = "人力资源干扰病毒"
	desc = "随机的改变各个岗位上限人数，运气好让整个站点都是小丑，运气差你就扩增了警察队伍."
	item = ABSTRACT_UPLINK_ITEM
	surplus = 0
	limited_stock = 1
	cost = 2
	restricted = TRUE
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL, JOB_QUARTERMASTER)

/datum/uplink_item/role_restricted/bureaucratic_error/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	force_event(/datum/round_event_control/bureaucratic_error, "辛迪加病毒")
	return source

/datum/uplink_item/role_restricted/clumsinessinjector //clown ops can buy this too, but it's in the pointless badassery section for them
	name = "笨手笨脚注射器"
	desc = "给自己注射这个，会让自己变得像小丑一样笨手笨脚...或者给别人注射，让他们像小丑一样笨手笨脚，传奇的小丑特工往往是将猎物折磨戏耍致死."
	item = /obj/item/dnainjector/clumsymut
	cost = 1
	restricted_roles = list(JOB_CLOWN)
	illegal_tech = FALSE
	surplus = 25

/datum/uplink_item/role_restricted/ancient_jumpsuit
	name = "古代连身衣"
	desc = "这件破烂的连身衣对你一点好处都没有."
	item = /obj/item/clothing/under/color/grey/ancient
	cost = 20
	restricted_roles = list(JOB_ASSISTANT)
	surplus = 0

/datum/uplink_item/role_restricted/oldtoolboxclean
	name = "古代工具箱"
	desc = "里面有绝缘手套和多功能工具等道具，但真正的助手会将工具箱视作武器，尤其是这一款在增强的基础上还会因里面存放的Tc数量而增加伤害!"
	item = /obj/item/storage/toolbox/mechanical/old/clean
	cost = 2
	restricted_roles = list(JOB_ASSISTANT)
	surplus = 0

/datum/uplink_item/role_restricted/clownpin
	name = "超级搞笑的撞针"
	desc = "一个撞针，当安装到枪里时，这把枪只能被小丑和笨手笨脚的人使用，而且当有任何人试图开枪时，这把枪会发出喇叭声."
	cost = 4
	item = /obj/item/firing_pin/clown/ultra
	restricted_roles = list(JOB_CLOWN)
	illegal_tech = FALSE
	surplus = 25

/datum/uplink_item/role_restricted/clownsuperpin
	name = "超级超级搞笑的撞针"
	desc = "一个比超级搞笑还要搞笑的撞针，当安装到枪里时，除了小丑和笨手笨脚的人之外开枪都会让这把枪爆炸."
	cost = 7
	item = /obj/item/firing_pin/clown/ultra/selfdestruct
	restricted_roles = list(JOB_CLOWN)
	illegal_tech = FALSE
	surplus = 25

/datum/uplink_item/role_restricted/syndimmi
	name = "辛迪加MMI"
	desc = "MMI是一种能使大脑单独存活的设备，常用于人的赛博化改造，这款辛迪加MMI改造出的赛博格将服从辛迪加的命令."
	item = /obj/item/mmi/syndie
	cost = 2
	restricted_roles = list(JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST, JOB_CORONER, JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER)
	surplus = 0

/datum/uplink_item/role_restricted/explosive_hot_potato
	name = "烫手山芋"
	desc = "实际上里面装有炸药！一旦被激活，它会防止被丢弃，\
			唯一的摆脱方法就是拿着它攻击别人，这样它就会连带着炸弹传给那个人."
	item = /obj/item/hot_potato/syndicate
	cost = 4
	restricted_roles = list(JOB_COOK, JOB_BOTANIST, JOB_CLOWN, JOB_MIME)

/datum/uplink_item/role_restricted/combat_baking
	name = "战术烘焙包"
	desc = "一套秘密面包武器，包含法棍，一个熟练的哑剧演员可以用它作为剑， \
		一对投掷用羊角面包，以及制造它的食谱！在任务完成后，记得吃掉证据."
	progression_minimum = 15 MINUTES
	item = /obj/item/storage/box/syndie_kit/combat_baking
	cost = 7
	restricted_roles = list(JOB_COOK, JOB_MIME)

/datum/uplink_item/role_restricted/ez_clean_bundle
	name = "EZ清洁手雷盒"
	desc = "里面有三枚清洁手榴弹，使用了Waffle公司的秘密配方，引爆后会对站在附近的人造成酸性伤害. \
			可惜的是这种酸只对碳基生物有用."
	item = /obj/item/storage/box/syndie_kit/ez_clean
	cost = 6
	surplus = 20
	restricted_roles = list(JOB_JANITOR)

/datum/uplink_item/role_restricted/reverse_bear_trap
	name = "裂颚器"
	desc = "戴在(或强行戴在)头上的一种处刑装置，通过残忍地撕裂下颚让人死亡，由于它像一个反方向运动的捕熊夹，所以也称为反向捕熊夹.\
	若要使用它，你需要将裂颚器拿在手上点击其他人，在三秒的读条后就成功将裂颚器套在了目标身上，再经过一分钟后裂颚器才会撕裂受害者."
	cost = 5
	item = /obj/item/reverse_bear_trap
	restricted_roles = list(JOB_CLOWN)

/datum/uplink_item/role_restricted/modified_syringe_gun
	name = "定制注射枪"
	desc = "这把经过改装后的注射枪允许发射DNA注射器."
	item = /obj/item/gun/syringe/dna
	cost = 14
	restricted_roles = list(JOB_GENETICIST, JOB_RESEARCH_DIRECTOR)

/datum/uplink_item/role_restricted/meathook
	name = "屠夫肉钩"
	desc = "带着长链残忍肉钩，它可以让你把人拉到你的位置."
	item = /obj/item/gun/magic/hook
	cost = 11
	restricted_roles = list(JOB_COOK)

/datum/uplink_item/role_restricted/turretbox
	name = "一次性戒哨炮"
	desc = "戒哨炮连带着部署系统巧妙地伪装成了工具箱，使用扳手来直接部署."
	item = /obj/item/storage/toolbox/emergency/turret
	cost = 11
	restricted_roles = list(JOB_STATION_ENGINEER, JOB_CHIEF_ENGINEER)

/datum/uplink_item/role_restricted/rebarxbowsyndie
	name = "辛迪加钢筋弩"
	desc = "一支更专业的钢筋弩，发射普通铁棍或锯齿铁棍，三发弹匣容量，更易装填，我们还附赠锯齿铁棍制作手册."
	item = /obj/item/storage/box/syndie_kit/rebarxbowsyndie
	cost = 10
	restricted_roles = list(JOB_STATION_ENGINEER, JOB_CHIEF_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)

/datum/uplink_item/role_restricted/magillitis_serum
	name = "猿力血清注射器"
	desc = "一次性的自动注射器，含有一种实验性血清，使人科动物肌肉迅速生长的实验性血清，副作用可能包括多毛症、暴力爆发和对香蕉的无休止的喜爱."
	item = /obj/item/reagent_containers/hypospray/medipen/magillitis
	cost = 15
	restricted_roles = list(JOB_GENETICIST, JOB_RESEARCH_DIRECTOR)

/datum/uplink_item/role_restricted/gorillacube
	name = "大猩猩方块"
	desc = "一盒三块Waffle公司的大猩猩方块，暴露于水中时会长出大猩猩."
	item = /obj/item/storage/box/gorillacubes
	cost = 6
	restricted_roles = list(JOB_GENETICIST, JOB_RESEARCH_DIRECTOR)

/datum/uplink_item/role_restricted/brainwash_disk
	name = "洗脑手术资料"
	desc = "购买此项，将获得包含洗脑手术资料的磁盘，将资料磁盘插入一台手术辅助电脑中，你将能对手术台上的病人进行洗脑手术，允许你向他灌输一条不容质疑的‘真理’."
	item = /obj/item/disk/surgery/brainwashing
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_CORONER, JOB_ROBOTICIST)
	cost = 5
	surplus = 50

/datum/uplink_item/role_restricted/advanced_plastic_surgery
	name = "高级易容手术资料"
	desc = "购买此项，将获得包含洗脑手术资料的磁盘，将资料磁盘插入一台手术辅助电脑中，你将能进行高级易容手术，该手术允许你根据你手上的照片来易容成某人的脸和声音."
	item = /obj/item/disk/surgery/brainwashing
	restricted_roles = list(JOB_MEDICAL_DOCTOR, JOB_CHIEF_MEDICAL_OFFICER, JOB_ROBOTICIST)
	cost = 1
	surplus = 50

/datum/uplink_item/role_restricted/springlock_module
	name = "魔改的弹簧锁模块"
	desc = "这个模块类似再穿了一层外骨骼，它通过在启动时发力来加速模块服启动，该魔改的版本允许你几乎立刻启动模块服."
	item = /obj/item/mod/module/springlock/bite_of_87
	restricted_roles = list(JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR)
	cost = 2
	surplus = 15

/datum/uplink_item/role_restricted/reverse_revolver
	name = "古灵精怪枪"
	desc = "一把向使用者开枪的辛迪加左轮. 你可以\"不小心地\"丢弃此枪，然后看着贪婪的公司狗把自己的脑袋炸飞. \
	这把辛迪加左轮本身可以正常使用，但只有笨手笨脚的人和小丑才能正常发射，它会装在一个抱抱盒里发送给你."
	progression_minimum = 30 MINUTES
	cost = 14
	item = /obj/item/storage/box/hug/reverse_revolver
	restricted_roles = list(JOB_CLOWN)

/datum/uplink_item/role_restricted/pressure_mod
	name = "原动能加速器压力模块"
	desc = "一个改装套件，使采矿工具原动能加速器在室内造成的伤害大大增加，将占用它35%的改装容量."
	// While less deadly than a revolver it does have infinite ammo
	progression_minimum = 15 MINUTES
	item = /obj/item/borg/upgrade/modkit/indoors
	cost = 5 //you need two for full damage, so total of 10 for maximum damage
	limited_stock = 2 //you can't use more than two!
	restricted_roles = list("Shaft Miner")
	surplus = 20

/datum/uplink_item/role_restricted/mimery
	name = "高级哑剧表演教学书"
	desc = "阅读此书来进一步磨砺你的哑剧技巧，在学习后，你将能制作3x1的隐形墙壁，还能从手指中射出子弹. \
			不过显然这只适用于哑剧演员."
	cost = 12
	item = /obj/item/storage/box/syndie_kit/mimery
	restricted_roles = list(JOB_MIME)
	surplus = 0

/datum/uplink_item/role_restricted/laser_arm
	name = "手臂激光发射系统"
	desc = "会给你一个小型自动手术仪，专门用来在手臂里植入激光枪，激光枪在收回时会自动充电."
	progression_minimum = 20 MINUTES
	cost = 10
	item = /obj/item/autosurgeon/syndicate/laser_arm
	restricted_roles = list(JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR)
	surplus = 20

/datum/uplink_item/role_restricted/chemical_gun
	name = "化学飞镖枪"
	desc = "一种经过大量改进的飞镖枪，能填装90u的化学试剂并应用到飞镖弹上."
	progression_minimum = 15 MINUTES
	item = /obj/item/gun/chem
	cost = 12
	restricted_roles = list(JOB_CHEMIST, JOB_CHIEF_MEDICAL_OFFICER, JOB_BOTANIST)

/datum/uplink_item/role_restricted/pie_cannon
	name = "香蕉奶油派连射大炮"
	desc = "这款特殊的馅饼大炮是为一个特殊小丑设计的，它可以容纳20个馅饼，并且每两秒钟自动制作一个馅饼!"
	cost = 10
	item = /obj/item/pneumatic_cannon/pie/selfcharge
	restricted_roles = list(JOB_CLOWN)

/datum/uplink_item/role_restricted/clown_bomb
	name = "小丑炸弹"
	desc = "小丑炸弹是一种引发大规模恶作剧的搞笑装置，带有一个调节的定时器，最短可以设置为%MIN_BOMB_TIMER秒， \
		如果想要它固定在某个地方，可以使用扳手拧紧炸弹上的地板螺栓.\
		炸弹的体积庞大，无法被收纳或拿在手中，只能通过推或者拖动移动. \
		因此我们会先发送给你一个小体积的位置信标，你在需要使用的时候激活该信标，炸弹将传送到你的位置. \
		此外，炸弹是可能被拆除的"
	progression_minimum = 15 MINUTES
	item = /obj/item/sbeacondrop/clownbomb
	cost = 15
	restricted_roles = list(JOB_CLOWN)
	surplus = 10

/datum/uplink_item/role_restricted/clown_bomb/New()
	. = ..()
	desc = replacetext(desc, "%MIN_BOMB_TIMER", SYNDIEBOMB_MIN_TIMER_SECONDS)

/datum/uplink_item/role_restricted/clowncar
	name = "小丑车"
	desc = "小丑车是属于小丑的终极代步工具，只需插入你的自行车喇叭启动就可以启动！你能把你遇到的任何太空人都塞到你的车里，直到他们被人救出来或自己爬出来. \
	在驾驶过程中应注意路况，若撞上了墙壁或售货机可能导致弹簧座椅启动. 当下我们还加装了防滑轮胎，更多的高级功能请使用EMAG解锁."
	item = /obj/vehicle/sealed/car/clowncar
	cost = 20
	restricted_roles = list(JOB_CLOWN)
	surplus = 10

/datum/uplink_item/role_restricted/clowncar/spawn_item_for_generic_use(mob/user)
	var/obj/vehicle/sealed/car/clowncar/car = ..()
	car.enforce_clown_role = FALSE
	var/obj/item/key = new car.key_type(user.loc)
	car.visible_message(span_notice("[key] drops out of [car] onto the floor."))
	return car

/datum/uplink_item/role_restricted/his_grace
	name = "他的恩典"
	desc = "这是一件极其危险的武器，在一个被灰潮淹没的站点被发现；当它进入活跃状态时，它将疯狂地渴望杀戮. \
	使用者必须不停的杀戮来满足他的恩典的胃口，作为交换，他的恩典将给予使用者自愈和免疫眩晕的能力. \
	倘若他的恩典饥渴到一定程度，使用者会发现他无法丢弃这把武器，若仍然不满足它的欲望，则最终会吞噬使用者. \
	收容的方法也是有的，就是让其独自呆一段时间，到时候他的恩典将陷入沉睡."
	lock_other_purchases = TRUE
	cant_discount = TRUE
	item = /obj/item/his_grace
	cost = 20
	surplus = 0
	restricted_roles = list(JOB_CHAPLAIN)
	purchasable_from = ~UPLINK_SPY

/datum/uplink_item/role_restricted/concealed_weapon_bay
	name = "隐藏武器舱"
	desc = "隐藏式武器舱是一种附加在非战斗机甲（如雷普利或奥德修斯）上的装备，允许它们装备一件机甲武器，一台机甲只能附加一个，检查机甲不会显示附加的武器（但仍然显示升级消息）."
	progression_minimum = 30 MINUTES
	item = /obj/item/mecha_parts/mecha_equipment/concealed_weapon_bay
	cost = 3
	restricted_roles = list(JOB_ROBOTICIST, JOB_RESEARCH_DIRECTOR)
	surplus = 15

/* // SKYRAT EDIT REMOVAL START
/datum/uplink_item/role_restricted/spider_injector
	name = "Australicus Slime Mutator"
	desc = "Crikey mate, it's been a wild travel from the Australicus sector but we've managed to get \
			some special spider extract from the giant spiders down there. Use this injector on a gold slime core \
			to create a few of the same type of spiders we found on the planets over there. They're a bit tame until you \
			also give them a bit of sentience though."
	progression_minimum = 30 MINUTES
	item = /obj/item/reagent_containers/syringe/spider_extract
	cost = 10
	restricted_roles = list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST, JOB_ROBOTICIST)
	surplus = 10

*/
// SKYRAT EDIT REMOVAL END
/datum/uplink_item/role_restricted/blastcannon
	name = "爆裂加农"
	desc = "作为一种高度专业化的武器，爆裂加农实际上是相对简易的. \
			它包含一个可承受极端温压的管道、气罐转移阀和触发转移阀的机械触发器，\
			它的工作原理是将炸弹的爆炸力转化为窄角爆炸波来射出.懂科学的人可能会发现这非常有用，因为迫使压力冲击波进入狭窄角可以增加射程或者爆炸范围. \
			设备使用气罐转移阀炸弹的理论当量，而不是实际当量.此外，它的设计简单，便于隐藏."
	progression_minimum = 30 MINUTES
	item = /obj/item/gun/blastcannon
	cost = 14 //High cost because of the potential for extreme damage in the hands of a skilled scientist.
	restricted_roles = list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST)
	surplus = 5

/datum/uplink_item/role_restricted/evil_seedling
	name = "恶意植物种子"
	desc = "我们找到了一颗稀有的种子，它会长成一种危险的植物!"
	item = /obj/item/seeds/seedling/evil
	cost = 8
	restricted_roles = list(JOB_BOTANIST)

/datum/uplink_item/role_restricted/bee_smoker
	name = "引蜂香"
	desc = "一个以大麻为原料的喷雾装置，可以催眠蜜蜂，让它们听从我们的命令."
	item = /obj/item/bee_smoker
	cost = 4
	restricted_roles = list(JOB_BOTANIST)

/datum/uplink_item/role_restricted/monkey_agent
	name = "猴特工增援"
	desc = "从辛迪加香蕉部找一个训练有素的猴子特工来，它擅长操作机器和做一些灵活向工作. \
		唯一的缺点是它们不会说我们的语言."
	item = /obj/item/antag_spawner/loadout/monkey_man
	cost = 6
	restricted_roles = list(JOB_RESEARCH_DIRECTOR, JOB_SCIENTIST, JOB_GENETICIST, JOB_ASSISTANT, JOB_MIME, JOB_CLOWN)
	restricted = TRUE
	refundable = TRUE

/datum/uplink_item/role_restricted/monkey_supplies
	name = "猴特工补给"
	desc = "比一个训练有素的猴子特工更好的是什么？一个训练有素的武装猴子特工! \
		猴子们可以打开这个补给包，得到一些枪支弹药以及其他杂项用品."
	item = /obj/item/storage/toolbox/guncase/monkeycase
	cost = 4
	limited_stock = 3
	restricted_roles = list(JOB_ASSISTANT, JOB_MIME, JOB_CLOWN)
	restricted = TRUE
	refundable = FALSE


/datum/uplink_item/role_restricted/reticence
	name = "Reticence Cloaked Assasination exosuit"
	desc = "A silent, fast, and nigh-invisible but exceptionally fragile miming exosuit! \
	fully equipped with a near-silenced pistol, and a RCD for your best assasination needs, Does not include tools, No refunds."
	item = /obj/vehicle/sealed/mecha/reticence/loaded
	cost = 20
	restricted_roles = list(JOB_MIME)
	restricted = TRUE
	refundable = FALSE
	purchasable_from = parent_type::purchasable_from & ~UPLINK_SPY
