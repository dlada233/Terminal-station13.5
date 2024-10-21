/obj/machinery/computer/order_console/cook
	name = "食材订货终端"
	desc = "用以从外部订购新鲜食材等，成本往往比从植物学家那获取更加昂贵，但胜在方便."
	circuit = /obj/item/circuitboard/computer/order_console
	order_categories = list(
		CATEGORY_FRUITS_VEGGIES,
		CATEGORY_MILK_EGGS,
		CATEGORY_SAUCES_REAGENTS,
	)
	blackbox_key = "chef"

/obj/machinery/computer/order_console/cook/order_groceries(mob/living/purchaser, obj/item/card/id/card, list/groceries)
	say("感谢您的惠顾！商品将乘下一班货船到达！")
	radio.talk_into(src, "已订购了产品，这些产品将搭乘货运厨房穿梭机到来，请确保它们被尽快送达厨房!", radio_channel)
	for(var/datum/orderable_item/ordered_item in groceries)
		if(!(ordered_item.category_index in order_categories))
			groceries.Remove(ordered_item)
			continue
		if(ordered_item in SSshuttle.chef_groceries)
			SSshuttle.chef_groceries[ordered_item] += groceries[ordered_item]
		else
			SSshuttle.chef_groceries[ordered_item] = groceries[ordered_item]
