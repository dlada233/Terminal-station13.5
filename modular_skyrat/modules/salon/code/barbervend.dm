/obj/machinery/vending/barbervend
	name = "绝伦造型"
	desc = "它出售染料和其他东西来让你变得漂亮."
	icon = 'modular_skyrat/modules/salon/icons/vendor.dmi'
	icon_state = "barbervend"
	product_slogans = "有时我把颜色像黄油一样涂抹在烤面包上...也涂抹在他们的头发上.; 有时我会梦见染料...; 把他们涂得五彩斑斓，然后叫我“画家先生”.; 看吧兄弟，我是个贩卖创意的人，我解决实际问题."
	product_ads = "切断所有一切!; 剃光!; 天下无毛!; 靓丽!; 美丽!"
	vend_reply = "欢迎再来!; 还有其他的好货!; 喜欢新造型吗?"
	req_access = list(ACCESS_BARBER)
	refill_canister = /obj/item/vending_refill/barbervend
	products = list(
		/obj/item/reagent_containers/spray/quantum_hair_dye = 3,
		/obj/item/reagent_containers/spray/baldium = 3,
		/obj/item/reagent_containers/spray/barbers_aid = 3,
		/obj/item/clothing/head/hair_tie = 3,
		/obj/item/dyespray = 5,
		/obj/item/hairbrush = 3,
		/obj/item/hairbrush/comb = 3,
		/obj/item/fur_dyer = 1,
	)
	premium = list(
		/obj/item/scissors = 3,
		/obj/item/reagent_containers/spray/super_barbers_aid = 3,
		/obj/item/storage/box/lipsticks = 3,
		/obj/item/lipstick/quantum = 1,
		/obj/item/razor = 1,
		/obj/item/storage/box/perfume = 1,
	)
	refill_canister = /obj/item/vending_refill/barbervend
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/barbervend
	machine_name = "理发店售货机再补给"
	icon_state = "refill_snack" //generic item refill because there isnt one sprited yet.
