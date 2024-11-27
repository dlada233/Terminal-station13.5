
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
// leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
// to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_containers/condiment
	name = "调料瓶"
	desc = "就是普通的调料瓶."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "bottle"
	inhand_icon_state = "beer" //Generic held-item sprite until unique ones are made.
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	reagent_flags = OPENCONTAINER
	obj_flags = UNIQUE_RENAME
	possible_transfer_amounts = list(1, 5, 10, 15, 20, 25, 30, 50)
	volume = 50
	fill_icon_thresholds = list(0, 10, 25, 50, 75, 100)
	/// Icon (icon_state) to be used when container becomes empty (no change if falsy)
	var/icon_empty
	/// Holder for original icon_state value if it was overwritten by icon_emty to change back to
	var/icon_preempty

/obj/item/reagent_containers/condiment/update_icon_state()
	. = ..()
	if(reagents.reagent_list.len)
		if(icon_preempty)
			icon_state = icon_preempty
			icon_preempty = null
		return ..()

	if(icon_empty && !icon_preempty)
		icon_preempty = icon_state
		icon_state = icon_empty
	return ..()

/obj/item/reagent_containers/condiment/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]尝试吃掉整个[src]! 看起来忘记了如何进食!"))
	return OXYLOSS

/obj/item/reagent_containers/condiment/attack(mob/M, mob/user, def_zone)

	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[src]空了，哎呀!"))
		return FALSE

	if(!canconsume(M, user))
		return FALSE

	if(M == user)
		user.visible_message(span_notice("[user]吞掉了[src]里的一些东西."), \
			span_notice("你吞掉了[src]里的一些东西."))
	else
		M.visible_message(span_warning("[user]试图用[src]喂食[M]."), \
			span_warning("[user]尝试用[src]喂你."))
		if(!do_after(user, 3 SECONDS, M))
			return
		if(!reagents || !reagents.total_volume)
			return // The condiment might be empty after the delay.
		M.visible_message(span_warning("[user]用[src]喂食[M]."), \
			span_warning("[user]用[src]喂食你."))
		log_combat(user, M, "fed", reagents.get_reagent_log_string())

	SEND_SIGNAL(M, COMSIG_GLASS_DRANK, src, user) // SKYRAT EDIT ADDITION - Hemophages can't casually drink what's not going to regenerate their blood
	reagents.trans_to(M, 10, transferred_by = user, methods = INGEST)
	playsound(M.loc,'sound/items/drink.ogg', rand(10,50), TRUE)
	return TRUE

/obj/item/reagent_containers/condiment/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target]是空的!"))
			return ITEM_INTERACT_BLOCKING

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, span_warning("[src]是满的!"))
			return ITEM_INTERACT_BLOCKING

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transferred_by = user)
		to_chat(user, span_notice("你用[target]的[trans]单位内容物填充[src]."))
		return ITEM_INTERACT_SUCCESS

	//Something like a glass or a food item. Player probably wants to transfer TO it.
	else if(target.is_drainable() || IS_EDIBLE(target))
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src]空的!"))
			return ITEM_INTERACT_BLOCKING
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, span_warning("[target]不能再添加更多了!"))
			return ITEM_INTERACT_BLOCKING
		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this, transferred_by = user)
		to_chat(user, span_notice("你将[trans]单位调料转移到[target]."))
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/reagent_containers/condiment/enzyme
	name = "通用酶"
	desc = "用于烹饪各种菜肴."
	icon_state = "enzyme"
	list_reagents = list(/datum/reagent/consumable/enzyme = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/enzyme/examine(mob/user)
	. = ..()
	var/datum/chemical_reaction/recipe = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/cheesewheel]
	var/milk_required = recipe.required_reagents[/datum/reagent/consumable/milk]
	var/enzyme_required = recipe.required_catalysts[/datum/reagent/consumable/enzyme]
	. += span_notice("[milk_required]牛奶，[enzyme_required]通用酶，然后你就得到了奶酪.")
	. += span_warning("记住通用酶不会被消耗，用完记得放回瓶子里，笨蛋!")

/obj/item/reagent_containers/condiment/sugar
	name = "糖袋"
	desc = "美味的太空糖!"
	icon_state = "sugar"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/sugar = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/sugar/examine(mob/user)
	. = ..()
	var/datum/chemical_reaction/recipe = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/cakebatter]
	var/flour_required = recipe.required_reagents[/datum/reagent/consumable/flour]
	var/eggyolk_required = recipe.required_reagents[/datum/reagent/consumable/eggyolk]
	var/sugar_required = recipe.required_reagents[/datum/reagent/consumable/sugar]
	. += span_notice("[flour_required]面粉，[eggyolk_required]蛋黄(或者豆奶), [sugar_required]糖能做成蛋糕糊，之后可以继续做成馅饼糊.")

/obj/item/reagent_containers/condiment/saltshaker //Separate from above since it's a small shaker rather then
	name = "盐瓶" // a large one.
	desc = "盐，可能来自太空海洋，大概."
	icon_state = "saltshakersmall"
	icon_empty = "emptyshaker"
	inhand_icon_state = ""
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	list_reagents = list(/datum/reagent/consumable/salt = 20)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/saltshaker/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]和盐瓶交换形体! 看起来是在尝试自杀!"))
	var/newname = "[name]"
	name = "[user.name]"
	user.name = newname
	user.real_name = newname
	desc = "咸. 来自死掉的船员，大概."
	return TOXLOSS

/obj/item/reagent_containers/condiment/saltshaker/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .
	if(isturf(target))
		if(!reagents.has_reagent(/datum/reagent/consumable/salt, 2))
			to_chat(user, span_warning("你没有足够的盐来堆叠!"))
			return
		user.visible_message(span_notice("[user]把一些盐撒到[target]."), span_notice("你把盐撒到[target]上."))
		reagents.remove_reagent(/datum/reagent/consumable/salt, 2)
		new/obj/effect/decal/cleanable/food/salt(target)
		return ITEM_INTERACT_SUCCESS
	return .

/obj/item/reagent_containers/condiment/peppermill
	name = "胡椒磨"
	desc = "通常用来给食物调味或者使人打喷嚏."
	icon_state = "peppermillsmall"
	icon_empty = "emptyshaker"
	inhand_icon_state = ""
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	list_reagents = list(/datum/reagent/consumable/blackpepper = 20)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/milk
	name = "太空牛奶"
	desc = "这是牛奶，又白又有营养."
	icon_state = "milk"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/milk = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/milk/examine(mob/user)
	. = ..()
	var/datum/chemical_reaction/recipe = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/cheesewheel]
	var/milk_required = recipe.required_reagents[/datum/reagent/consumable/milk]
	var/enzyme_required = recipe.required_catalysts[/datum/reagent/consumable/enzyme]
	. += span_notice("[milk_required]牛奶，[enzyme_required]通用酶，然后你就得到了奶酪.")
	. += span_warning("记住通用酶不会被消耗，用完记得放回瓶子里，笨蛋!")

/obj/item/reagent_containers/condiment/flour
	name = "面粉袋"
	desc = "一大袋面粉，很适合烘焙!"
	icon_state = "flour"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/flour = 30)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/flour/examine(mob/user)
	. = ..()
	var/datum/chemical_reaction/recipe_dough = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/dough]
	var/datum/chemical_reaction/recipe_cakebatter = GLOB.chemical_reactions_list[/datum/chemical_reaction/food/cakebatter]
	var/dough_flour_required = recipe_dough.required_reagents[/datum/reagent/consumable/flour]
	var/dough_water_required = recipe_dough.required_reagents[/datum/reagent/water]
	var/cakebatter_flour_required = recipe_cakebatter.required_reagents[/datum/reagent/consumable/flour]
	var/cakebatter_eggyolk_required = recipe_cakebatter.required_reagents[/datum/reagent/consumable/eggyolk]
	var/cakebatter_sugar_required = recipe_cakebatter.required_reagents[/datum/reagent/consumable/sugar]
	. += "<b><i>你凝神闭气，思索着某种技术...揉面团的技术...</i></b>"
	. += span_notice("[dough_flour_required]面粉，[dough_water_required]水可以制作成普通面团，之后可以继续擀成面饼.")
	. += span_notice("[cakebatter_flour_required]面粉，[cakebatter_eggyolk_required]蛋黄(或者豆奶)，[cakebatter_sugar_required]糖能做成蛋糕糊，之后可以继续做成馅饼糊.")

/obj/item/reagent_containers/condiment/soymilk
	name = "豆奶"
	desc = "这是豆奶..白白的而且很有营养!"
	icon_state = "soymilk"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/soymilk = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/rice
	name = "米袋"
	desc = "一大袋米，很适合烹饪!"
	icon_state = "rice"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/rice = 30)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/cornmeal
	name = "玉米粉盒"
	desc = "一大盒玉米粉，适合南方料理."
	icon_state = "cornmeal"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/cornmeal = 30)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/bbqsauce
	name = "烧烤酱"
	desc = "不附赠擦手纸."
	icon_state = "bbqsauce"
	list_reagents = list(/datum/reagent/consumable/bbqsauce = 50)

/obj/item/reagent_containers/condiment/soysauce
	name = "酱油"
	desc = "以大豆为基础的咸香调味品."
	icon_state = "soysauce"
	list_reagents = list(/datum/reagent/consumable/soysauce = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/mayonnaise
	name = "蛋黄酱"
	desc = "以蛋黄为基础的油性调味品."
	icon_state = "mayonnaise"
	list_reagents = list(/datum/reagent/consumable/mayonnaise = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/vinegar
	name = "醋"
	desc = "很适合薯条，如果你希望体验太空英国味道的话."
	icon_state = "vinegar"
	list_reagents = list(/datum/reagent/consumable/vinegar = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/vegetable_oil
	name = "食用油"
	desc = "满足你的所有油炸需求."
	icon_state = "cooking_oil"
	list_reagents = list(/datum/reagent/consumable/nutriment/fat/oil = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/olive_oil
	name = "优质油"
	desc = "每个人心里都住着一位大厨."
	icon_state = "oliveoil"
	list_reagents = list(/datum/reagent/consumable/nutriment/fat/oil/olive = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/yoghurt
	name = "酸奶盒"
	desc = "奶油般柔滑."
	icon_state = "yoghurt"
	list_reagents = list(/datum/reagent/consumable/yoghurt = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/peanut_butter
	name = "花生酱"
	desc = "美味，高热量的罐装花生酱."
	icon_state = "peanutbutter"
	list_reagents = list(/datum/reagent/consumable/peanut_butter = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/cherryjelly
	name = "樱桃果酱"
	desc = "非常甜的罐装樱桃果酱."
	icon_state = "cherryjelly"
	list_reagents = list(/datum/reagent/consumable/cherryjelly = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/honey
	name = "蜂蜜"
	desc = "又甜又粘的罐装蜂蜜."
	icon_state = "honey"
	list_reagents = list(/datum/reagent/consumable/honey = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/ketchup
	name = "番茄酱"
	// At time of writing, "ketchup" mechanically, is just ground tomatoes,
	// rather than // tomatoes plus vinegar plus sugar.
	desc = "装在塑料瓶里的番茄酱，多少有些美国风味."
	icon_state = "ketchup"
	list_reagents = list(/datum/reagent/consumable/ketchup = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/worcestershire
	name = "伍斯特郡酱油"
	desc = "古代英格兰传说中的发酵酱料，让几乎所有食物都增添一层美味"
	icon_state = "worcestershire"
	list_reagents = list(/datum/reagent/consumable/worcestershire = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/red_bay
	name = "红湾香料"
	desc = "火星上最受欢迎的调味料"
	icon_state = "red_bay"
	list_reagents = list(/datum/reagent/consumable/red_bay = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/curry_powder
	name = "咖喱粉"
	desc = "黄色魔法粉末，让咖喱吃起来更咖喱."
	icon_state = "curry_powder"
	list_reagents = list(/datum/reagent/consumable/curry_powder = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/dashi_concentrate
	name = "鱼汤宝"
	desc = "一瓶Amagi牌浓缩鱼汤，以1:8比例加水炖煮出完美鱼汤."
	icon_state = "dashi_concentrate"
	list_reagents = list(/datum/reagent/consumable/dashi_concentrate = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/coconut_milk
	name = "椰奶"
	desc = "这是椰奶，口感醇厚!"
	icon_state = "coconut_milk"
	inhand_icon_state = "carton"
	lefthand_file = 'icons/mob/inhands/items/drinks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/drinks_righthand.dmi'
	list_reagents = list(/datum/reagent/consumable/coconut_milk = 50)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/grounding_solution
	name = "绝缘剂"
	desc = "这是一种食品级离子溶液，旨在中和来自Sprout食品中的神秘\"液体电力\"，接触后会形成无害的盐."
	icon_state = "grounding_solution"
	list_reagents = list(/datum/reagent/consumable/grounding_solution = 50)
	fill_icon_thresholds = null

//technically condiment packs but they are non transparent

/obj/item/reagent_containers/condiment/creamer
	name = "咖啡奶精包"
	desc = "最好别去想他们是用什么做的."
	icon_state = "condi_creamer"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/creamer = 5)
	fill_icon_thresholds = null

/obj/item/reagent_containers/condiment/chocolate
	name = "巧克力粉包"
	desc= "当前的含糖量对你来说还不够吗?"
	icon_state = "condi_chocolate"
	list_reagents = list(/datum/reagent/consumable/choccyshake = 10)


/obj/item/reagent_containers/condiment/hotsauce
	name = "辣酱瓶"
	desc= "你可以尝到胃溃疡!"
	icon_state = "hotsauce"
	list_reagents = list(/datum/reagent/consumable/capsaicin = 50)

/obj/item/reagent_containers/condiment/coldsauce
	name = "霜酱瓶"
	desc= "舌尖纵享麻木."
	icon_state = "coldsauce"
	list_reagents = list(/datum/reagent/consumable/frostoil = 50)

//Food packs. To easily apply deadly toxi... delicious sauces to your food!

/obj/item/reagent_containers/condiment/pack
	name = "调料包"
	desc = "装有调料的小塑料包，可以添加到你的食物上."
	icon_state = "condi_empty"
	volume = 10
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10)
	/**
	  * List of possible styles (list(<icon_state>, <name>, <desc>)) for condiment packs.
	  * Since all of them differs only in color should probably be replaced with usual reagentfillings instead
	  */
	var/list/possible_states = list(
		/datum/reagent/consumable/ketchup = list("condi_ketchup", "番茄酱", "你感觉自己很像美国人."),
		/datum/reagent/consumable/capsaicin = list("condi_hotsauce", "辣酱", "你几乎能尝到胃溃疡!"),
		/datum/reagent/consumable/soysauce = list("condi_soysauce", "酱油", "以大豆为基础的咸香调味品"),
		/datum/reagent/consumable/frostoil = list("condi_frostoil", "霜酱", "舌尖纵享麻木"),
		/datum/reagent/consumable/salt = list("condi_salt", "盐瓶", "盐，可能来自太空大海，大概."),
		/datum/reagent/consumable/blackpepper = list("condi_pepper", "胡椒磨", "常用于给食物调味或让人打喷嚏."),
		/datum/reagent/consumable/nutriment/fat/oil = list("condi_cornoil", "植物油", "烹饪常见的美味食用油."),
		/datum/reagent/consumable/sugar = list("condi_sugar", "糖", "美味的太空糖!"),
		/datum/reagent/consumable/astrotame = list("condi_astrotame", "甜味剂", "有一千种糖的甜味，却没有半克糖的卡路里."),
		/datum/reagent/consumable/bbqsauce = list("condi_bbq", "烧烤酱", "不附赠擦手纸."),
		/datum/reagent/consumable/peanut_butter = list("condi_peanutbutter", "花生酱", "美味、高热量的花生酱."),
		/datum/reagent/consumable/cherryjelly = list("condi_cherryjelly", "樱桃果酱", "非常甜的樱桃果酱."),
		/datum/reagent/consumable/mayonnaise = list("condi_mayo", "蛋黄酱", "这不是乐器."),
	)
	/// Can't use initial(name) for this. This stores the name set by condimasters.
	var/originalname = "调料"

/obj/item/reagent_containers/condiment/pack/create_reagents(max_vol, flags)
	. = ..()
	RegisterSignals(reagents, list(COMSIG_REAGENTS_NEW_REAGENT, COMSIG_REAGENTS_ADD_REAGENT, COMSIG_REAGENTS_REM_REAGENT), PROC_REF(on_reagent_add), TRUE)
	RegisterSignal(reagents, COMSIG_REAGENTS_DEL_REAGENT, PROC_REF(on_reagent_del), TRUE)

/obj/item/reagent_containers/condiment/pack/update_icon()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/item/reagent_containers/condiment/pack/attack(mob/M, mob/user, def_zone) //Can't feed these to people directly.
	return

/obj/item/reagent_containers/condiment/pack/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	//You can tear the bag open above food to put the condiments on it, obviously.
	if(IS_EDIBLE(target))
		if(!reagents.total_volume)
			to_chat(user, span_warning("你撕开了[src]，但里面没有任何东西."))
			qdel(src)
			return ITEM_INTERACT_BLOCKING
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, span_warning("你撕开了[src]，但[target]已经堆得太满以至于只能洒落下来!") )
			qdel(src)
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice("你在[target]上面撕开了[src]，调料洒落在上面."))
		src.reagents.trans_to(target, amount_per_transfer_from_this, transferred_by = user)
		qdel(src)
		return ITEM_INTERACT_SUCCESS
	return ..()

/// Handles reagents getting added to the condiment pack.
/obj/item/reagent_containers/condiment/pack/proc/on_reagent_add(datum/reagents/reagents)
	SIGNAL_HANDLER

	var/datum/reagent/main_reagent = reagents.get_master_reagent()

	var/main_reagent_type = main_reagent?.type
	if(main_reagent_type in possible_states)
		var/list/temp_list = possible_states[main_reagent_type]
		icon_state = temp_list[1]
		desc = temp_list[3]
	else
		icon_state = "condi_mixed"
		desc = "一小袋调料包. 标签写着包含[originalname]"

/// Handles reagents getting removed from the condiment pack.
/obj/item/reagent_containers/condiment/pack/proc/on_reagent_del(datum/reagents/reagents)
	SIGNAL_HANDLER
	icon_state = "condi_empty"
	desc = "一小袋调料包，里面是空的."

//Ketchup
/obj/item/reagent_containers/condiment/pack/ketchup
	name = "番茄酱包"
	originalname = "番茄酱"
	list_reagents = list(/datum/reagent/consumable/ketchup = 10)

//Hot sauce
/obj/item/reagent_containers/condiment/pack/hotsauce
	name = "辣酱包"
	originalname = "辣酱"
	list_reagents = list(/datum/reagent/consumable/capsaicin = 10)

/obj/item/reagent_containers/condiment/pack/astrotame
	name = "甜味剂包"
	originalname = "甜味剂"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/astrotame = 5)

/obj/item/reagent_containers/condiment/pack/bbqsauce
	name = "烧烤酱包"
	originalname = "烧烤酱"
	list_reagents = list(/datum/reagent/consumable/bbqsauce = 10)

/obj/item/reagent_containers/condiment/pack/creamer
	name = "奶油包"
	originalname = "奶油"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/cream = 5)

/obj/item/reagent_containers/condiment/pack/sugar
	name = "糖包"
	originalname = "糖"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/sugar = 5)

/obj/item/reagent_containers/condiment/pack/soysauce
	name = "酱油包"
	originalname = "酱油"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/soysauce = 5)

/obj/item/reagent_containers/condiment/pack/mayonnaise
	name = "蛋黄酱包"
	originalname = "蛋黄酱"
	volume = 5
	list_reagents = list(/datum/reagent/consumable/mayonnaise = 5)
