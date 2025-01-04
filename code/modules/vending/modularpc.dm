/obj/machinery/vending/modularpc
	name = "\improper 硅晶豪华货机"
	desc = "出售各类电脑数码产品."
	icon_state = "modularpc"
	icon_deny = "modularpc-deny"
	panel_type = "panel21"
	light_mask = "modular-light-mask"
	product_ads = "获得你的电竞设备!;能满足所有挖太空加密货币需求的高级GPU!;最强大的散热系统!;太空中最出色的RGB灯效!"
	vend_reply = "Game on!"
	products = list(
		/obj/item/computer_disk = 8,
		/obj/item/modular_computer/laptop = 4,
		/obj/item/modular_computer/pda = 4,
	)
	premium = list(
		/obj/item/pai_card = 2,
	)
	refill_canister = /obj/item/vending_refill/modularpc
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/modularpc
	machine_name = "硅晶豪华货机"
	icon_state = "refill_engi"
