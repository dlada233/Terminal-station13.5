//All bundles and telecrystals
/datum/uplink_category/bundle
	name = "捆绑包"
	weight = 10

/datum/uplink_item/bundles_tc
	category = /datum/uplink_category/bundle
	surplus = 0
	cant_discount = TRUE

/datum/uplink_item/bundles_tc/random
	name = "随机物品"
	desc = "选择这个将购买一个随机物品，如果你有一些多余的TC或者你还没有思路，这不失为一种选择."
	item = /obj/effect/gibspawner/generic // non-tangible item because techwebs use this path to determine illegal tech
	cost = 0
	cost_override_string = "Varies"

/datum/uplink_item/bundles_tc/random/purchase(mob/user, datum/uplink_handler/handler, atom/movable/source)
	var/list/possible_items = list()
	for(var/datum/uplink_item/item_path as anything in SStraitor.uplink_items_by_type)
		var/datum/uplink_item/uplink_item = SStraitor.uplink_items_by_type[item_path]
		if(src == uplink_item || !uplink_item.item)
			continue
		if(!handler.can_purchase_item(user, uplink_item))
			continue
		possible_items += uplink_item

	if(possible_items.len)
		var/datum/uplink_item/uplink_item = pick(possible_items)
		log_uplink("[key_name(user)] purchased a random uplink item from [handler.owner]'s uplink with [handler.telecrystals] telecrystals remaining")
		SSblackbox.record_feedback("tally", "traitor_random_uplink_items_gotten", 1, initial(uplink_item.name))
		handler.purchase_item(user, uplink_item)

/datum/uplink_item/bundles_tc/telecrystal
	name = "1个Telecrystal"
	desc = "将上行链路中Tc提取出来，你可以随时将其重新添加回去."
	item = /obj/item/stack/telecrystal
	cost = 1
	// Don't add telecrystals to the purchase_log since
	// it's just used to buy more items (including itself!)
	purchase_log_vis = FALSE

/datum/uplink_item/bundles_tc/telecrystal/five
	name = "5个Telecrystals"
	desc = "将上行链路中Tc提取出来，你可以随时将其重新添加回去."
	item = /obj/item/stack/telecrystal/five
	cost = 5

/datum/uplink_item/bundles_tc/telecrystal/twenty
	name = "20个Telecrystals"
	desc = "将上行链路中Tc提取出来，你可以随时将其重新添加回去."
	item = /obj/item/stack/telecrystal/twenty
	cost = 20

/datum/uplink_item/bundles_tc/bundle_a
	name = "辛迪加战术捆绑包"
	desc = "辛迪加捆绑包，也称辛迪包, 是一个里面塞入了固定物品组合的普通盒子. \
			盒子内的物品总价值超过了25Tc，其组合也有一定的意义， \
			但很可惜你不能选择使用何种组合，并且每个上行链路只能购买一次. \
			除此之外，盒子里的物品有些是已经淘汰了的或过时的产品."
	item = /obj/item/storage/box/syndicate/bundle_a
	cost = 20
	stock_key = UPLINK_SHARED_STOCK_KITS
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/bundles_tc/bundle_b
	name = "辛迪加特别捆绑包"
	desc = "辛迪加捆绑包，也称辛迪包, 是一个里面塞入了固定物品组合的普通盒子. \
			在特别版的盒子里，你会收到过去著名辛迪加特工使用过的物品组合，\
			各种物品总价值将超过25Tc. \
			此外，每个辛迪加只能购买一次辛迪包."
	item = /obj/item/storage/box/syndicate/bundle_b
	cost = 20
	stock_key = UPLINK_SHARED_STOCK_KITS
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/bundles_tc/surplus
	name = "辛迪加板条箱"
	desc = "从辛迪加仓库后面挑出一个满是灰尘的板条箱，通过补给舱直接砸给你. \
			你听说它会根据你的声誉来决定它的内容，但总价值仍是30Tc. \
			除此之外，每个上行链路只能买一次辛迪加板条箱."
	item = /obj/structure/closet/crate // will be replaced in purchase()
	cost = 20
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	stock_key = UPLINK_SHARED_STOCK_SURPLUS
	/// Value of items inside the crate in TC
	var/crate_tc_value = 30
	/// crate that will be used for the surplus crate
	var/crate_type = /obj/structure/closet/crate

/// generates items that can go inside crates, edit this proc to change what items could go inside your specialized crate
/datum/uplink_item/bundles_tc/surplus/proc/generate_possible_items(mob/user, datum/uplink_handler/handler)
	var/list/possible_items = list()
	for(var/datum/uplink_item/item_path as anything in SStraitor.uplink_items_by_type)
		var/datum/uplink_item/uplink_item = SStraitor.uplink_items_by_type[item_path]
		if(src == uplink_item || !uplink_item.item)
			continue
		if(!handler.check_if_restricted(uplink_item))
			continue
		if(!uplink_item.surplus)
			continue
		if(handler.not_enough_reputation(uplink_item))
			continue
		possible_items += uplink_item
	return possible_items

/// picks items from the list given to proc and generates a valid uplink item that is less or equal to the amount of TC it can spend
/datum/uplink_item/bundles_tc/surplus/proc/pick_possible_item(list/possible_items, tc_budget)
	var/datum/uplink_item/uplink_item = pick(possible_items)
	if(prob(100 - uplink_item.surplus))
		return null
	if(tc_budget < uplink_item.cost)
		return null
	return uplink_item

/// fills the crate that will be given to the traitor, edit this to change the crate and how the item is filled
/datum/uplink_item/bundles_tc/surplus/proc/fill_crate(obj/structure/closet/crate/surplus_crate, list/possible_items)
	var/tc_budget = crate_tc_value
	while(tc_budget)
		var/datum/uplink_item/uplink_item = pick_possible_item(possible_items, tc_budget)
		if(!uplink_item)
			continue
		tc_budget -= uplink_item.cost
		new uplink_item.item(surplus_crate)

/// overwrites item spawning proc for surplus items to spawn an appropriate crate via a podspawn
/datum/uplink_item/bundles_tc/surplus/spawn_item(spawn_path, mob/user, datum/uplink_handler/handler, atom/movable/source)
	var/obj/structure/closet/crate/surplus_crate = new crate_type()
	if(!istype(surplus_crate))
		CRASH("crate_type is not a crate")
	var/list/possible_items = generate_possible_items(user, handler)

	fill_crate(surplus_crate, possible_items)

	podspawn(list(
		"target" = get_turf(user),
		"style" = STYLE_SYNDICATE,
		"spawn" = surplus_crate,
	))
	return source //For log icon

/datum/uplink_item/bundles_tc/surplus/united
	name = "合作板条箱"
	desc = "一个闪亮的板条箱将装在补给仓里砸向你，它有一个先进的锁定系统与反篡改协议. \
			想要打开它，建议使用另一台上行链路，购买‘合作板条箱钥匙’来打开它. \
			这通常意味着你需要找到另一名持有上行链路的特工并与之合作，一旦你们做到了，这个板条箱里将有总计价值80TC的物品. \
			此外，每个上行链路只能购买一次该物品."
	cost = 20
	item = /obj/structure/closet/crate/secure/syndicrate
	stock_key = UPLINK_SHARED_STOCK_SURPLUS
	crate_tc_value = 80
	crate_type = /obj/structure/closet/crate/secure/syndicrate

/// edited version of fill crate for super surplus to ensure it can only be unlocked with the syndicrate key
/datum/uplink_item/bundles_tc/surplus/united/fill_crate(obj/structure/closet/crate/secure/syndicrate/surplus_crate, list/possible_items)
	if(!istype(surplus_crate))
		return
	var/tc_budget = crate_tc_value
	while(tc_budget)
		var/datum/uplink_item/uplink_item = pick_possible_item(possible_items, tc_budget)
		if(!uplink_item)
			continue
		tc_budget -= uplink_item.cost
		surplus_crate.unlock_contents += uplink_item.item

/datum/uplink_item/bundles_tc/surplus_key
	name = "合作板条箱钥匙"
	desc = "这个看似毫无意义的物品实际上是一把钥匙，可以打开任何一个合作板条箱，它也被设定为只能使用一次. \
			虽然最初的设计是为了鼓励合作，但特工们很快发现，有方法可以只靠自己打开板条箱.  \
			此外，每个上行链路只能购买一次该物品."
	cost = 20
	item = /obj/item/syndicrate_key
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
	stock_key = UPLINK_SHARED_STOCK_SURPLUS
