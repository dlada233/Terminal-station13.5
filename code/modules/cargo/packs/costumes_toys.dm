/datum/supply_pack/costumes_toys
	group = "服装&玩具"

/datum/supply_pack/costumes_toys/randomised
	name = "收藏版帽子合集"
	desc = "用三个独特的极具收藏价值的帽子彰显你的地位."
	cost = CARGO_CRATE_VALUE * 40
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/hos,
					/obj/item/clothing/head/collectable/hop,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat,
				)
	crate_name = "帽子合集箱"
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/costumes_toys/formalwear
	name = "正装合集"
	desc = "你会喜欢你的样子的，我保证. 包含一堆花哨的衣服."
	cost = CARGO_CRATE_VALUE * 4 //Lots of very expensive items. You gotta pay up to look good!
	contains = list(/obj/item/clothing/under/dress/tango,
					/obj/item/clothing/under/misc/assistantformal = 2,
					/obj/item/clothing/under/rank/civilian/lawyer/bluesuit,
					/obj/item/clothing/suit/toggle/lawyer,
					/obj/item/clothing/under/rank/civilian/lawyer/purpsuit,
					/obj/item/clothing/suit/toggle/lawyer/purple,
					/obj/item/clothing/suit/toggle/lawyer/black,
					/obj/item/clothing/accessory/waistcoat,
					/obj/item/clothing/neck/tie/blue,
					/obj/item/clothing/neck/tie/red,
					/obj/item/clothing/neck/tie/black,
					/obj/item/clothing/head/hats/bowler,
					/obj/item/clothing/head/fedora,
					/obj/item/clothing/head/flatcap,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/head/hats/tophat,
					/obj/item/clothing/shoes/laceup = 3,
					/obj/item/clothing/under/suit/charcoal,
					/obj/item/clothing/under/suit/navy,
					/obj/item/clothing/under/suit/burgundy,
					/obj/item/clothing/under/suit/checkered,
					/obj/item/clothing/under/suit/tan,
					/obj/item/lipstick/random,
				)
	crate_name = "正装合集箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/clownpin
	name = "搞笑胸针合集"
	desc = "抱歉了我的钱包，但我真的很需要它们."
	cost = CARGO_CRATE_VALUE * 10
	contraband = TRUE
	contains = list(/obj/item/firing_pin/clown)
	crate_name = "玩具箱" // It's /technically/ a toy. For the clown, at least.
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/costumes_toys/lasertag
	name = "激光标记大战包"
	desc = "泡沫弹是男孩的玩具，而激光大战才是男人的游戏，内含红色套装，蓝色套装\
		各三套，还有匹配的头盔和激光枪."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/gun/energy/laser/redtag = 3,
					/obj/item/gun/energy/laser/bluetag = 3,
					/obj/item/clothing/suit/redtag = 3,
					/obj/item/clothing/suit/bluetag = 3,
					/obj/item/clothing/head/helmet/redtaghelm = 3,
					/obj/item/clothing/head/helmet/bluetaghelm = 3,
				)
	crate_name = "激光标记大战箱"

/datum/supply_pack/costumes_toys/knucklebones
	name = "掷羊拐游戏包"
	desc = "一个绝不是邪教发明的有趣骰子游戏，咨询当地牧师，了解获准的宗教活动. \
		内含十八个D6骰子，一个白色蜡笔，以及游戏说明书."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/dice/d6 = 18,
					/obj/item/paper/guides/knucklebone,
					/obj/item/toy/crayon/white,
				)
	crate_name = "掷羊拐游戏箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/lasertag/pins
	name = "玩具激光撞针包"
	desc = "三个用于进行激光大战游戏的玩具激光撞针，确保目标穿着对应的背心."
	cost = CARGO_CRATE_VALUE * 3.5
	contraband = TRUE
	contains = list(/obj/item/storage/box/lasertagpins)
	crate_name = "激光标记大战箱"

/datum/supply_pack/costumes_toys/mech_suits
	name = "机甲驾驶服装包"
	desc = "给那些要驾驶大型机器人的人穿的，一箱四件!"
	cost = CARGO_CRATE_VALUE * 3 //state-of-the-art technology doesn't come cheap
	contains = list(/obj/item/clothing/under/costume/mech_suit = 4)
	crate_name = "机甲驾驶服箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume_original
	name = "原始动物服装包"
	desc = "用这些服装来重演莎士比亚的戏剧，包含八种不同的服装!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/costume/snowman,
					/obj/item/clothing/suit/costume/snowman,
					/obj/item/clothing/head/costume/chicken,
					/obj/item/clothing/suit/costume/chickensuit,
					/obj/item/clothing/mask/gas/monkeymask,
					/obj/item/clothing/suit/costume/monkeysuit,
					/obj/item/clothing/head/costume/cardborg,
					/obj/item/clothing/suit/costume/cardborg,
					/obj/item/clothing/head/costume/xenos,
					/obj/item/clothing/suit/costume/xenos,
					/obj/item/clothing/suit/hooded/ian_costume,
					/obj/item/clothing/suit/hooded/carp_costume,
					/obj/item/clothing/suit/hooded/bee_costume,
				)
	crate_name = "原始动物服装箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume
	name = "艺人服装包"
	desc = "为全空间站的艺人们提供服装，\
		所有物品均经纳米传讯认证！\
		内含全套小丑和默剧演员服装，还有一个自行车喇叭和一瓶nothing."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_THEATRE
	contains = list(/obj/item/storage/backpack/clown,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/under/rank/civilian/clown,
					/obj/item/bikehorn,
					/obj/item/clothing/under/rank/civilian/mime,
					/obj/item/clothing/shoes/sneakers/black,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/head/frenchberet,
					/obj/item/clothing/suit/toggle/suspenders,
					/obj/item/reagent_containers/cup/glass/bottle/bottleofnothing,
					/obj/item/storage/backpack/mime,
				)
	crate_name = "艺人服装箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/costume/fill(obj/structure/closet/crate/C)
	..()
	var/funny_gas_internals
	funny_gas_internals = pick(subtypesof(/obj/item/tank/internals/emergency_oxygen/engi/clown) - /obj/item/tank/internals/emergency_oxygen/engi/clown)
	new funny_gas_internals(C)

/datum/supply_pack/costumes_toys/randomised/toys
	name = "玩具补给包"
	desc = "臭玩街机的谁在乎实力? 跳过游戏阶段\
		直接购买通关奖励！内含五个随机的街机玩具，\
		如果拿去捉弄科研主管则保修无效."
	cost = CARGO_CRATE_VALUE * 8 // or play the arcade machines ya lazy bum
	num_contained = 5
	contains = list()
	crate_name = "玩具箱"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/toys/fill(obj/structure/closet/crate/C)
	var/the_toy
	for(var/i in 1 to num_contained)
		if(prob(50))
			the_toy = pick_weight(GLOB.arcade_prize_pool)
		else
			the_toy = pick(subtypesof(/obj/item/toy/plush))
		new the_toy(C)

/datum/supply_pack/costumes_toys/wizard
	name = "巫师服装包"
	desc = "假装加入了巫师联盟!\
		纳米传讯温馨提醒：真正加入巫师联盟将强制辞退员工."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake,
				)
	crate_name = "巫师服装包"
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/fill(obj/structure/closet/crate/C)
	var/list/L = contains.Copy()
	for(var/i in 1 to num_contained)
		var/item = pick_n_take(L)
		new item(C)

/datum/supply_pack/costumes_toys/trekkie
	name = "《星际迷航》服装包"
	desc = "穿上十二件纳米传讯连身服的废弃草案\
		设计理念来自20世纪晚期的地球！\
		虽然由于侵犯了版权，不能作为官方连体衣使用，\
		但只要打上‘废案’就能合法出售了."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/obj/item/clothing/under/trek/command,
		/obj/item/clothing/under/trek/command/next,
		/obj/item/clothing/under/trek/command/voy,
		/obj/item/clothing/under/trek/command/ent,
		/obj/item/clothing/under/trek/engsec,
		/obj/item/clothing/under/trek/engsec/next,
		/obj/item/clothing/under/trek/engsec/voy,
		/obj/item/clothing/under/trek/engsec/ent,
		/obj/item/clothing/under/trek/medsci,
		/obj/item/clothing/under/trek/medsci/next,
		/obj/item/clothing/under/trek/medsci/voy,
		/obj/item/clothing/under/trek/medsci/ent,
	)
	crate_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/costumes_toys/randomised/tcg
	name = "Big-Ass助推器包"
	desc = "大量不同系列的NT TCG助推器！"
	cost = 1000
	contains = list()
	crate_name = "助推器箱"
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/costumes_toys/randomised/tcg/fill(obj/structure/closet/crate/C)
	var/cardpacktype
	for(var/i in 1 to 10)
		cardpacktype = pick(subtypesof(/obj/item/cardpack))
		new cardpacktype(C)

/datum/supply_pack/costumes_toys/stickers
	name = "贴纸包"
	desc = "这个板条箱里有各种各样的贴纸."
	cost = CARGO_CRATE_VALUE * 3
	contains = list()
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/costumes_toys/stickers/fill(obj/structure/closet/crate/crate)
	for(var/i in 1 to rand(1,2))
		new /obj/item/storage/box/stickers(crate)
	if(prob(30)) // a pair of googly eyes because funny
		new /obj/item/storage/box/stickers/googly(crate)

/datum/supply_pack/costumes_toys/pinata
	name = "Corgi Pinata-柯基彩罐包"
	desc = "装满糖果的柯基外形的彩罐，附赠一个眼罩和用来打碎它的球棒."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/pinata,
		/obj/item/melee/baseball_bat,
		/obj/item/clothing/glasses/blindfold,
	)
	crate_name = "柯基彩罐箱"
	crate_type = /obj/structure/closet/crate/wooden
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE
