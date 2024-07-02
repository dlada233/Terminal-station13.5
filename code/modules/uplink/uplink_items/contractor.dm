/datum/uplink_category/contractor
	name = "契约特工"
	weight = 10

/datum/uplink_item/bundles_tc/contract_kit
	name = "契约特工包"
	desc = "辛迪加向你提供了一份契约，辛迪加愿意提供Tc或者现金来向你换取一些活着的目标人物，通俗意义上来讲，就是绑架. \
		它们将发送给你契约特工专用的上行链路，就在你现在使用的这台PDA或电脑上. \
		此外，辛迪加还将提供一套标准的契约特工装备来帮助你完成绑架工作，包括新PDA、太空服、变色龙制服和面具、特工卡、\
		契约特工专用的绑架电棍和三种随机的低价值道具，其中可能包括一些平日里无法获得的道具."
	item = /obj/item/storage/box/syndicate/contract_kit
	category = /datum/uplink_category/contractor
	cost = 20
	purchasable_from = UPLINK_INFILTRATORS

/datum/uplink_item/bundles_tc/contract_kit/purchase(mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	. = ..()
	for(var/uplink_items in subtypesof(/datum/uplink_item/contractor))
		var/datum/uplink_item/uplink_item = new uplink_items
		uplink_handler.extra_purchasable += uplink_item

/datum/uplink_item/contractor
	restricted = TRUE
	category = /datum/uplink_category/contractor
	purchasable_from = NONE //they will be added to extra_purchasable

//prevents buying contractor stuff before you make an account.
/datum/uplink_item/contractor/can_be_bought(datum/uplink_handler/uplink_handler)
	if(!uplink_handler.contractor_hub)
		return FALSE
	return ..()

/datum/uplink_item/contractor/reroll
	name = "契约重置"
	desc = "也许你对你当前的契约不是很满意，购买此项可以请求对你当前的契约清单进行重置. \
		重置后你的契约会有新的目标、付款和交付条件."
	item = ABSTRACT_UPLINK_ITEM
	limited_stock = 2
	cost = 0

/datum/uplink_item/contractor/reroll/spawn_item(spawn_path, mob/user, datum/uplink_handler/uplink_handler, atom/movable/source)
	//We're not regenerating already completed/aborted/extracting contracts, but we don't want to repeat their targets.
	var/list/new_target_list = list()
	for(var/datum/syndicate_contract/contract_check in uplink_handler.contractor_hub.assigned_contracts)
		if (contract_check.status != CONTRACT_STATUS_ACTIVE && contract_check.status != CONTRACT_STATUS_INACTIVE)
			if (contract_check.contract.target)
				new_target_list.Add(contract_check.contract.target)
			continue

	//Reroll contracts without duplicates
	for(var/datum/syndicate_contract/rerolling_contract in uplink_handler.contractor_hub.assigned_contracts)
		if (rerolling_contract.status != CONTRACT_STATUS_ACTIVE && rerolling_contract.status != CONTRACT_STATUS_INACTIVE)
			continue

		rerolling_contract.generate(new_target_list)
		new_target_list.Add(rerolling_contract.contract.target)

	//Set our target list with the new set we've generated.
	uplink_handler.contractor_hub.assigned_targets = new_target_list
	return source //for log icon

/datum/uplink_item/contractor/pinpointer
	name = "契约指针"
	desc = "即使目标身上没有激活传感器，也可以寻找到其位置的指针，由于原理上利用了系统的漏洞，所以它无法向一般指针那样精确定位，此外，它会永久锁定第一次激活它的用户."
	item = /obj/item/pinpointer/crew/contractor
	limited_stock = 2
	cost = 1

/datum/uplink_item/contractor/extraction_kit
	name = "富尔顿回收包"
	desc = "这里有一个富尔顿背包和一个富尔顿信标，要想利用起来，你需要先将信标部署到一个安全、隐秘的位置，然后使用背包连接到该信标；\
		接着你就可以在你想要转移的目标身上挂上富尔顿背包，背包将把他转移到信标位置，并且目标在落地后也将瘫痪一段时间，而这个包也可以多次使用."
	item = /obj/item/storage/box/contractor/fulton_extraction
	limited_stock = 1
	cost = 1

/datum/uplink_item/contractor/partner
	name = "增援"
	desc = "购买后，我们会联系该地区的可用特工，如果特工有空，我们会立刻派遣；如果没有空闲的特工，我们也会全额退款."
	item = /obj/item/antag_spawner/loadout/contractor
	limited_stock = 1
	cost = 2
