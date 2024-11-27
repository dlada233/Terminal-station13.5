/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "床单"
	desc = "柔软的亚麻布床单."
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/items/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	inhand_icon_state = "sheetwhite"
	slot_flags = ITEM_SLOT_NECK
	layer = BELOW_MOB_LAYER
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING

	dog_fashion = /datum/dog_fashion/head/ghost
	/// Custom nouns to act as the subject of dreams
	var/list/dream_messages = list("white")
	/// Cutting it up will yield this.
	var/stack_type = /obj/item/stack/sheet/cloth
	/// The number of sheets dropped by this bedsheet when cut
	var/stack_amount = 3
	/// Denotes if the bedsheet is a single, double, or other kind of bedsheet
	var/bedsheet_type = BEDSHEET_SINGLE
	var/datum/weakref/signal_sleeper //this is our goldylocks

/obj/item/bedsheet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/surgery_initiator)
	AddElement(/datum/element/bed_tuckable, mapload, 0, 0, 0)
	if(bedsheet_type == BEDSHEET_DOUBLE)
		stack_amount *= 2
		dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	register_context()
	register_item_context()

/obj/item/bedsheet/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(istype(held_item) && (held_item.tool_behaviour == TOOL_WIRECUTTER || held_item.get_sharpness()))
		context[SCREENTIP_CONTEXT_LMB] = "撕碎成布"

	context[SCREENTIP_CONTEXT_ALT_LMB] = "旋转"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/bedsheet/add_item_context(datum/source, list/context, mob/living/target)
	if(isliving(target) && target.body_position == LYING_DOWN)
		context[SCREENTIP_CONTEXT_RMB] = "盖上"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/bedsheet/attack_secondary(mob/living/target, mob/living/user, params)
	if(!user.CanReach(target))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(target.body_position != LYING_DOWN)
		return ..()
	if(!user.dropItemToGround(src))
		return ..()

	forceMove(get_turf(target))
	balloon_alert(user, "盖上")
	coverup(target)
	add_fingerprint(user)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/bedsheet/attack_self(mob/living/user)
	if(!user.CanReach(src)) //No telekinetic grabbing.
		return
	if(user.body_position != LYING_DOWN)
		return
	if(!user.dropItemToGround(src))
		return

	coverup(user)
	add_fingerprint(user)

/obj/item/bedsheet/proc/coverup(mob/living/sleeper)
	layer = ABOVE_MOB_LAYER
	pixel_x = 0
	pixel_y = 0
	balloon_alert(sleeper, "盖上")
	var/angle = sleeper.lying_prev
	dir = angle2dir(angle + 180) // 180 flips it to be the same direction as the mob

	signal_sleeper = WEAKREF(sleeper)
	RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(sleeper, COMSIG_MOVABLE_MOVED, PROC_REF(smooth_sheets))
	RegisterSignal(sleeper, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(smooth_sheets))
	RegisterSignal(sleeper, COMSIG_QDELETING, PROC_REF(smooth_sheets))

/obj/item/bedsheet/proc/smooth_sheets(mob/living/sleeper)
	SIGNAL_HANDLER

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(sleeper, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(sleeper, COMSIG_LIVING_SET_BODY_POSITION)
	UnregisterSignal(sleeper, COMSIG_QDELETING)
	balloon_alert(sleeper, "光滑床单")
	layer = initial(layer)
	SET_PLANE_IMPLICIT(src, initial(plane))
	signal_sleeper = null

// We need to do this in case someone picks up a bedsheet while a mob is covered up
// otherwise the bedsheet will disappear while in our hands if the sleeper signals get activated by moving
/obj/item/bedsheet/proc/on_pickup(datum/source, mob/grabber)
	SIGNAL_HANDLER

	var/mob/living/sleeper = signal_sleeper?.resolve()

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(sleeper, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(sleeper, COMSIG_LIVING_SET_BODY_POSITION)
	UnregisterSignal(sleeper, COMSIG_QDELETING)
	signal_sleeper = null

/obj/item/bedsheet/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if (!(flags_1 & HOLOGRAM_1))
			var/obj/item/stack/shreds = new stack_type(get_turf(src), stack_amount)
			if(!QDELETED(shreds)) //stacks merged
				transfer_fingerprints_to(shreds)
				shreds.add_fingerprint(user)
		qdel(src)
		to_chat(user, span_notice("你撕碎了[src]."))
	else
		return ..()

/obj/item/bedsheet/click_alt(mob/living/user)
	dir = REVERSE_DIR(dir)
	return CLICK_ACTION_SUCCESS

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	inhand_icon_state = "sheetblue"
	dream_messages = list("blue")

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	inhand_icon_state = "sheetgreen"
	dream_messages = list("green")

/obj/item/bedsheet/grey
	icon_state = "sheetgrey"
	inhand_icon_state = "sheetgrey"
	dream_messages = list("grey")

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	inhand_icon_state = "sheetorange"
	dream_messages = list("orange")

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	inhand_icon_state = "sheetpurple"
	dream_messages = list("purple")

/obj/item/bedsheet/patriot
	name = "爱国床单"
	desc = "只是睡在这上面，你就感觉到自由民主."
	icon_state = "sheetUSA"
	inhand_icon_state = "sheetUSA"
	dream_messages = list("美利坚合众国", "自由", "硝烟", "秃鹰")

/obj/item/bedsheet/rainbow
	name = "彩虹床单"
	desc = "一条五颜六色的毯子，实际上是从不同毯子上剪下来缝合而成的."
	icon_state = "sheetrainbow"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("红色", "橙色", "黄色", "绿色", "蓝色", "紫色", "一轮彩虹")

/obj/item/bedsheet/red
	icon_state = "sheetred"
	inhand_icon_state = "sheetred"
	dream_messages = list("red")

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	inhand_icon_state = "sheetyellow"
	dream_messages = list("yellow")

/obj/item/bedsheet/mime
	name = "默剧毯"
	desc = "一条舒适的黑白条纹毯，当躲进这条被子里，所有的声音仿佛都消失了."
	icon_state = "sheetmime"
	inhand_icon_state = "sheetmime"
	dream_messages = list("沉默", "手势", "苍白的脸", "张大的嘴巴", "默剧")

/obj/item/bedsheet/clown
	name = "小丑毯"
	desc = "一条彩虹毯，里面编织着小丑图案，闻起来有股香蕉味."
	icon_state = "sheetclown"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("honk", "笑声", "恶作剧", "笑话", "笑脸", "小丑")

/obj/item/bedsheet/captain
	name = "舰长床单"
	desc = "印有纳米传讯标志，由一种革命性的新型线编织而成，保证对大多数非化学物质只有0.01%的渗透率，在当前舰长间很受欢迎."
	icon_state = "sheetcaptain"
	inhand_icon_state = "sheetcaptain"
	dream_messages = list("权威", "金ID卡", "太阳镜", "绿色软盘", "独特光能枪", "舰长")

/obj/item/bedsheet/rd
	name = "研究主管床单"
	desc = "它编织有烧杯标志，由防火材料制成，但它可能没法在你每天遇到的火灾级别下保护你."
	icon_state = "sheetrd"
	inhand_icon_state = "sheetrd"
	dream_messages = list("权威", "银ID卡", "炸弹", "机甲", "抱脸虫", "狂笑", "研究主管")

// for Free Golems.
/obj/item/bedsheet/rd/royal_cape
	name = "解放者皇家床单"
	desc = "雄伟庄严."
	dream_messages = list("采矿", "岩石", "石人", "解放", "想做什么做什么")

/obj/item/bedsheet/medical
	name = "医疗毯"
	desc = "一种'消毒'毯，通常用在医院."
	icon_state = "sheetmedical"
	inhand_icon_state = "sheetmedical"
	dream_messages = list("治疗", "生命", "手术", "医生")

/obj/item/bedsheet/cmo
	name = "首席医疗官床单"
	desc = "一条'消毒'过的毯子，上面有医疗十字标志，上面有一些猫毛，可能来自Runtime."
	icon_state = "sheetcmo"
	inhand_icon_state = "sheetcmo"
	dream_messages = list("权威", "银ID卡", "治疗", "生命", "手术", "猫咪", "首席医疗官")

/obj/item/bedsheet/hos
	name = "安保部长床单"
	desc = "上面编织有盾牌徽章，罪恶从不休止，而你需要休息，但你依然是法律的守护者!"
	icon_state = "sheethos"
	inhand_icon_state = "sheethos"
	dream_messages = list("权威", "银ID卡", "手铐", "电棍", "闪光弹", "太阳镜", "安保部长")

/obj/item/bedsheet/hop
	name = "人事部长床单"
	desc = "上面编织有钥匙徽章，在有些难得的时刻，你可以安心地休息，和Ian依偎在一起，而不用担心有人通过无线电对你大呼小叫."
	icon_state = "sheethop"
	inhand_icon_state = "sheethop"
	dream_messages = list("权威", "银ID卡", "义务", "电脑", "ID", "柯基犬", "人事部长")

/obj/item/bedsheet/ce
	name = "工程部长床单"
	desc = "上面编织有扳手徽章，具有很强的反光性和抗污性，所以你不必担心它会被油污损坏."
	icon_state = "sheetce"
	inhand_icon_state = "sheetce"
	dream_messages = list("权威", "银ID卡", "引擎", "电动工具", "APC", "鹦鹉", "工程部长")

/obj/item/bedsheet/qm
	name = "军需官床单"
	desc = "上面编织有银色衬里的货箱标志，这张床挺硬的，适合在辛苦工作一天后躺在上面."
	icon_state = "sheetqm"
	inhand_icon_state = "sheetqm"
	dream_messages = list("权威", "银ID卡", "货船", "货箱", "懒惰", "军需官")

/obj/item/bedsheet/chaplain
	name = "牧师毯"
	desc = "用众神之心编织而成的毯子...等等，只是亚麻布."
	icon_state = "sheetchap"
	inhand_icon_state = "sheetchap"
	dream_messages = list("灰ID卡", "众神", "履行祷告", "邪教", "牧师")

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	inhand_icon_state = "sheetbrown"
	dream_messages = list("brown")

/obj/item/bedsheet/black
	icon_state = "sheetblack"
	inhand_icon_state = "sheetblack"
	dream_messages = list("black")

/obj/item/bedsheet/centcom
	name = "中央指挥部床单"
	desc = "高级纳米丝线编织而成的保暖精美的床单."
	icon_state = "sheetcentcom"
	inhand_icon_state = "sheetcentcom"
	dream_messages = list("独特ID卡", "权威", "大炮", "结局")

/obj/item/bedsheet/syndie
	name = "辛迪加床单"
	desc = "有辛迪加元素的床单，非常邪恶."
	icon_state = "sheetsyndie"
	inhand_icon_state = "sheetsyndie"
	dream_messages = list("绿色软盘", "红色晶体", "发光的剑", "电线缠绕的ID卡")

/obj/item/bedsheet/cult
	name = "血教床单"
	desc = "散发着古老气息，用它睡觉可能会梦见Nar'Sie."
	icon_state = "sheetcult"
	inhand_icon_state = "sheetcult"
	dream_messages = list("大部头巨著", "悬浮的红色晶体", "发光的剑", "血腥的图案", "巨大的身影")

/obj/item/bedsheet/wiz
	name = "巫师床单"
	desc = "一种被施了魔法的特殊布料，让你度过一个迷人的夜晚，甚至还会发光."
	icon_state = "sheetwiz"
	inhand_icon_state = "sheetwiz"
	dream_messages = list("书", "爆炸", "闪光", "法杖", "骷髅", "长袍", "魔法")

/obj/item/bedsheet/rev
	name = "革命床单"
	desc = "一张从中央指挥部偷来的床单，用来象征对抗纳米传讯的暴政，正面的金色徽章已经被涂掉了."
	icon_state = "sheetrev"
	inhand_icon_state = "sheetrev"
	dream_messages = list(
		"人民",
		"自由",
		"团结",
		"脑袋搬家",
		"很多很多棒球棒",
		"炫目闪光",
		"战友在身旁"
	)

/obj/item/bedsheet/nanotrasen
	name = "纳米传讯床单"
	desc = "编织有纳米传讯的标志，有一股责任感."
	icon_state = "sheetNT"
	inhand_icon_state = "sheetNT"
	dream_messages = list("权威", "结局")

/obj/item/bedsheet/ian
	icon_state = "sheetian"
	inhand_icon_state = "sheetian"
	dream_messages = list("狗狗", "柯基", "嗷呜", "汪汪汪", "汪汪")

/obj/item/bedsheet/runtime
	icon_state = "sheetruntime"
	inhand_icon_state = "sheetruntime"
	dream_messages = list("猫猫", "猫咪", "喵呜", "呼噜", "nya~")

/obj/item/bedsheet/pirate
	name = "海盗床单"
	desc = "编织有海盗标志，还一股淡淡的酒味."
	icon_state = "sheetpirate"
	inhand_icon_state = "sheetpirate"
	dream_messages = list(
		"埋藏的宝藏",
		"岛屿",
		"猴子",
		"鹦鹉",
		"流氓",
		"说话的骷髅",
		"停船",
		"成为海盗",
		"是因为海盗是",
		"自由的，想要什么就有什么",
		"黄金",
		"旱鸭子",
		"偷窃",
		"航行七大洋",
		"yarr",
	)

/obj/item/bedsheet/gondola
	name = "贡多拉床单"
	desc = "一条珍贵的床单，由一种濒临灭绝的动物的毛皮制成"
	icon_state = "sheetgondola"
	inhand_icon_state = "sheetgondola"
	dream_messages = list("平和", "舒适", "濒危", "无害")
	stack_type = /obj/item/stack/sheet/animalhide/gondola
	stack_amount = 1
	///one of four icon states that represent its mouth
	var/gondola_mouth
	///one of four icon states that represent its eyes
	var/gondola_eyes

/obj/item/bedsheet/gondola/Initialize(mapload)
	. = ..()
	gondola_mouth = "sheetgondola_mouth[rand(1, 4)]"
	gondola_eyes = "sheetgondola_eyes[rand(1, 4)]"
	add_overlay(gondola_mouth)
	add_overlay(gondola_eyes)

/obj/item/bedsheet/gondola/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += mutable_appearance(icon_file, gondola_mouth)
		. += mutable_appearance(icon_file, gondola_eyes)

/obj/item/bedsheet/cosmos
	name = "宇宙床单"
	desc = "由仰望星空的梦想织成"
	icon_state = "sheetcosmos"
	inhand_icon_state = "sheetcosmos"
	dream_messages = list("星辰大海", "汉斯·季默配乐", "飞跃星空", "银河", "奇闻异事", "流星")
	light_power = 2
	light_range = 1.4

/obj/item/bedsheet/double
	icon_state = "double_sheetwhite"
	worn_icon_state = "sheetwhite"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/blue/double
	icon_state = "double_sheetblue"
	worn_icon_state = "sheetblue"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/green/double
	icon_state = "double_sheetgreen"
	worn_icon_state = "sheetgreen"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/grey/double
	icon_state = "double_sheetgrey"
	worn_icon_state = "sheetgrey"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/orange/double
	icon_state = "double_sheetorange"
	worn_icon_state = "sheetorange"
	dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/purple/double
	icon_state = "double_sheetpurple"
	worn_icon_state = "sheetpurple"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/patriot/double
	icon_state = "double_sheetUSA"
	worn_icon_state = "sheetUSA"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/rainbow/double
	icon_state = "double_sheetrainbow"
	worn_icon_state = "sheetrainbow"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/red/double
	icon_state = "double_sheetred"
	worn_icon_state = "sheetred"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/yellow/double
	icon_state = "double_sheetyellow"
	worn_icon_state = "sheetyellow"
	dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/mime/double
	icon_state = "double_sheetmime"
	worn_icon_state = "sheetmime"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/clown/double
	icon_state = "double_sheetclown"
	worn_icon_state = "sheetclown"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/captain/double
	icon_state = "double_sheetcaptain"
	worn_icon_state = "sheetcaptain"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/rd/double
	icon_state = "double_sheetrd"
	worn_icon_state = "sheetrd"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/medical/double
	icon_state = "double_sheetmedical"
	worn_icon_state = "sheetmedical"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cmo/double
	icon_state = "double_sheetcmo"
	worn_icon_state = "sheetcmo"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/hos/double
	icon_state = "double_sheethos"
	worn_icon_state = "sheethos"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/hop/double
	icon_state = "double_sheethop"
	worn_icon_state = "sheethop"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/ce/double
	icon_state = "double_sheetce"
	worn_icon_state = "sheetce"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/qm/double
	icon_state = "double_sheetqm"
	worn_icon_state = "sheetqm"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/chaplain/double
	icon_state = "double_sheetchap"
	worn_icon_state = "sheetchap"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/brown/double
	icon_state = "double_sheetbrown"
	worn_icon_state = "sheetbrown"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/black/double
	icon_state = "double_sheetblack"
	worn_icon_state = "sheetblack"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/centcom/double
	icon_state = "double_sheetcentcom"
	worn_icon_state = "sheetcentcom"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/syndie/double
	icon_state = "double_sheetsyndie"
	worn_icon_state = "sheetsyndie"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cult/double
	icon_state = "double_sheetcult"
	worn_icon_state = "sheetcult"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/wiz/double
	icon_state = "double_sheetwiz"
	worn_icon_state = "sheetwiz"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/rev/double
	icon_state = "double_sheetrev"
	worn_icon_state = "sheetrev"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/nanotrasen/double
	icon_state = "double_sheetNT"
	worn_icon_state = "sheetNT"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/ian/double
	icon_state = "double_sheetian"
	worn_icon_state = "sheetian"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/runtime/double
	icon_state = "double_sheetruntime"
	worn_icon_state = "sheetruntime"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cosmos/double
	icon_state = "double_sheetcosmos"
	worn_icon_state = "sheetcosmos"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/structure/bedsheetbin
	name = "床单筐"
	desc = "看起来相当舒适."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 70
	/// The number of bedsheets in the bin
	var/amount = 10
	/// A list of actual sheets within the bin
	var/list/sheets = list()
	/// The object hiddin within the bedsheet bin
	var/obj/item/hidden = null

/obj/structure/bedsheetbin/empty
	amount = 0
	icon_state = "linenbin-empty"
	anchored = FALSE


/obj/structure/bedsheetbin/examine(mob/user)
	. = ..()
	if(amount < 1)
		. += "筐里面没有床单."
	else if(amount == 1)
		. += "筐里面有一张床单."
	else
		. += "筐里面有[amount]张床单."


/obj/structure/bedsheetbin/update_icon_state()
	switch(amount)
		if(0)
			icon_state = "linenbin-empty"
		if(1 to 5)
			icon_state = "linenbin-half"
		else
			icon_state = "linenbin-full"
	return ..()

/obj/structure/bedsheetbin/fire_act(exposed_temperature, exposed_volume)
	if(amount)
		amount = 0
		update_appearance()
	..()

/obj/structure/bedsheetbin/screwdriver_act(mob/living/user, obj/item/tool)
	if(amount)
		to_chat(user, span_warning("[src]必须先清空!"))
		return ITEM_INTERACT_SUCCESS
	if(tool.use_tool(src, user, 0.5 SECONDS, volume=50))
		to_chat(user, span_notice("你拆开[src]."))
		new /obj/item/stack/rods(loc, 2)
		qdel(src)
		return ITEM_INTERACT_SUCCESS

/obj/structure/bedsheetbin/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, time = 0.5 SECONDS)
	return ITEM_INTERACT_SUCCESS

/obj/structure/bedsheetbin/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/bedsheet))
		if(!user.transferItemToLoc(I, src))
			return
		sheets.Add(I)
		amount++
		to_chat(user, span_notice("你把[I]放进[src]."))
		update_appearance()

	else if(amount && !hidden && I.w_class < WEIGHT_CLASS_BULKY) //make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I]粘在了你的手上，你无法把它藏进床单里!"))
			return
		hidden = I
		to_chat(user, span_notice("你把[I]藏进了床单里."))


/obj/structure/bedsheetbin/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/bedsheetbin/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(drop_location())
		user.put_in_hands(B)
		to_chat(user, span_notice("你把[B]从[src]里拿掉."))
		update_appearance()

		if(hidden)
			hidden.forceMove(drop_location())
			to_chat(user, span_notice("[hidden]从[B]里掉了出来!"))
			hidden = null

	add_fingerprint(user)


/obj/structure/bedsheetbin/attack_tk(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(drop_location())
		to_chat(user, span_notice("你用念力将[B]从[src]中移除."))
		update_appearance()

		if(hidden)
			hidden.forceMove(drop_location())
			hidden = null

	add_fingerprint(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN
