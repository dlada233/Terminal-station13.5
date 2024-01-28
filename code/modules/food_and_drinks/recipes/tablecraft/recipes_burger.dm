
// see code/module/crafting/table.dm

////////////////////////////////////////////////BURGERS////////////////////////////////////////////////


/datum/crafting_recipe/food/humanburger
	name = "人肉堡"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/patty/human = 1
	)
	parts = list(
		/obj/item/food/patty = 1
	)
	result = /obj/item/food/burger/human
	category = CAT_BURGER

/datum/crafting_recipe/food/burger
	name = "原味汉堡"
	reqs = list(
			/obj/item/food/patty/plain = 1,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/plain
	category = CAT_BURGER

/datum/crafting_recipe/food/corgiburger
	name = "柯基肉汉堡"
	reqs = list(
			/obj/item/food/patty/corgi = 1,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/corgi
	category = CAT_BURGER

/datum/crafting_recipe/food/appendixburger
	name = "阑尾汉堡"
	reqs = list(
		/obj/item/organ/internal/appendix = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/appendix
	category = CAT_BURGER

/datum/crafting_recipe/food/brainburger
	name = "脑堡"
	reqs = list(
		/obj/item/organ/internal/brain = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/brain
	category = CAT_BURGER

/datum/crafting_recipe/food/xenoburger
	name = "异形汉堡"
	reqs = list(
		/obj/item/food/patty/xeno = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/xeno
	category = CAT_BURGER

/datum/crafting_recipe/food/bearger
	name = "熊堡"
	reqs = list(
		/obj/item/food/patty/bear = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/bearger
	category = CAT_BURGER

/datum/crafting_recipe/food/fishburger
	name = "鱼肉三明治"
	reqs = list(
		/obj/item/food/fishmeat = 1,
		/obj/item/food/bun = 1,
		/obj/item/food/cheese/wedge = 1
	)
	result = /obj/item/food/burger/fish
	category = CAT_BURGER

/datum/crafting_recipe/food/tofuburger
	name = "豆腐汉堡"
	reqs = list(
		/obj/item/food/tofu = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/tofu
	category = CAT_BURGER

/datum/crafting_recipe/food/ghostburger
	name = "幽灵堡"
	reqs = list(
		/obj/item/ectoplasm = 1,
		/datum/reagent/consumable/salt = 2,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/ghost
	category = CAT_BURGER

/datum/crafting_recipe/food/clownburger
	name = "小丑堡"
	reqs = list(
		/obj/item/clothing/mask/gas/clown_hat = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/clown
	category = CAT_BURGER

/datum/crafting_recipe/food/mimeburger
	name = "默剧堡"
	reqs = list(
		/obj/item/clothing/mask/gas/mime = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/mime
	category = CAT_BURGER

/datum/crafting_recipe/food/redburger
	name = "红色堡"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/red = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/red
	category = CAT_BURGER

/datum/crafting_recipe/food/orangeburger
	name = "橙色堡"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/orange = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/orange
	category = CAT_BURGER

/datum/crafting_recipe/food/yellowburger
	name = "黄色堡"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/yellow = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/yellow
	category = CAT_BURGER

/datum/crafting_recipe/food/greenburger
	name = "绿色堡"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/green = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/green
	category = CAT_BURGER

/datum/crafting_recipe/food/blueburger
	name = "蓝色堡"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/blue = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/blue
	category = CAT_BURGER

/datum/crafting_recipe/food/purpleburger
	name = "紫色堡"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/purple = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/purple
	category = CAT_BURGER

/datum/crafting_recipe/food/blackburger
	name = "黑色汉堡"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/black = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/black
	category = CAT_BURGER

/datum/crafting_recipe/food/whiteburger
	name = "白色汉堡"
	reqs = list(
		/obj/item/food/patty/plain = 1,
		/obj/item/toy/crayon/white = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/white
	category = CAT_BURGER

/datum/crafting_recipe/food/spellburger
	name = "巫师堡"
	reqs = list(
		/obj/item/clothing/head/wizard = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/spell
	category = CAT_BURGER

/datum/crafting_recipe/food/bigbiteburger
	name = "大亨堡"
	reqs = list(
		/obj/item/food/patty/plain = 3,
		/obj/item/food/bun = 1,
		/obj/item/food/cheese/wedge = 2
	)
	result = /obj/item/food/burger/bigbite
	category = CAT_BURGER

/datum/crafting_recipe/food/superbiteburger
	name = "超级大亨堡"
	reqs = list(
		/datum/reagent/consumable/salt = 5,
		/datum/reagent/consumable/blackpepper = 5,
		/obj/item/food/patty/plain = 5,
		/obj/item/food/grown/tomato = 4,
		/obj/item/food/cheese/wedge = 3,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/meat/bacon = 1,
		/obj/item/food/bun = 1,
		/obj/item/food/pickle = 1,

	)
	result = /obj/item/food/burger/superbite
	category = CAT_BURGER

/datum/crafting_recipe/food/slimeburger
	name = "果酱汉堡"
	reqs = list(
		/datum/reagent/toxin/slimejelly = 5,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/jelly/slime
	category = CAT_BURGER

/datum/crafting_recipe/food/jellyburger
	name = "果酱汉堡"
	reqs = list(
			/datum/reagent/consumable/cherryjelly = 5,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/jelly/cherry
	category = CAT_BURGER

/datum/crafting_recipe/food/fivealarmburger
	name = "火警堡"
	reqs = list(
			/obj/item/food/patty/plain = 1,
			/obj/item/food/grown/ghost_chili = 2,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/fivealarm
	category = CAT_BURGER

/datum/crafting_recipe/food/ratburger
	name = "鼠堡"
	reqs = list(
			/obj/item/food/deadmouse = 1,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/rat
	category = CAT_BURGER

/datum/crafting_recipe/food/baseballburger
	name = "全垒打棒球堡"
	reqs = list(
			/obj/item/melee/baseball_bat = 1,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/baseball
	category = CAT_BURGER

/datum/crafting_recipe/food/baconburger
	name = "培根堡"
	reqs = list(
			/obj/item/food/meat/bacon = 3,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/baconburger
	category = CAT_BURGER

/datum/crafting_recipe/food/empoweredburger
	name = "能源堡"
	reqs = list(
			/obj/item/stack/sheet/mineral/plasma = 2,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/empoweredburger
	category = CAT_BURGER

/datum/crafting_recipe/food/catburger
	name = "猫堡"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/patty/plain = 1,
		/obj/item/organ/internal/ears/cat = 1,
		/obj/item/organ/external/tail/cat = 1,
	)
	result = /obj/item/food/burger/catburger
	category = CAT_BURGER

/datum/crafting_recipe/food/crabburger
	name = "蟹肉堡"
	reqs = list(
			/obj/item/food/meat/crab = 2,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/crab
	category = CAT_BURGER

/datum/crafting_recipe/food/cheeseburger
	name = "芝士汉堡"
	reqs = list(
			/obj/item/food/patty/plain = 1,
			/obj/item/food/bun = 1,
			/obj/item/food/cheese/wedge = 1,
	)
	result = /obj/item/food/burger/cheese
	category = CAT_BURGER

/datum/crafting_recipe/food/soylentburger
	name = "素肉汉堡"
	reqs = list(
			/obj/item/food/soylentgreen = 1, //two full meats worth.
			/obj/item/food/bun = 1,
			/obj/item/food/cheese/wedge = 2,
	)
	result = /obj/item/food/burger/soylent
	category = CAT_BURGER

/datum/crafting_recipe/food/ribburger
	name = "烤汁猪柳堡"
	reqs = list(
			/obj/item/food/bbqribs = 1,     //The sauce is already included in the ribs
			/obj/item/food/onion_slice = 1, //feel free to remove if too burdensome.
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/rib
	category = CAT_BURGER

/datum/crafting_recipe/food/mcguffin
	name = "麦格芬"
	reqs = list(
			/obj/item/food/friedegg = 1,
			/obj/item/food/meat/bacon = 2,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/mcguffin
	category = CAT_BURGER

/datum/crafting_recipe/food/chickenburger
	name = "鸡肉三明治"
	reqs = list(
			/obj/item/food/patty/chicken = 1,
			/datum/reagent/consumable/mayonnaise = 5,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/chicken
	category = CAT_BURGER

/datum/crafting_recipe/food/crazyhamburger
	name = "疯狂堡"
	reqs = list(
			/obj/item/food/patty/plain = 2,
			/obj/item/food/bun = 1,
			/obj/item/food/cheese/wedge = 2,
			/obj/item/food/grown/chili = 1,
			/obj/item/food/grown/cabbage = 1,
			/obj/item/toy/crayon/green = 1,
			/obj/item/flashlight/flare = 1,
			/datum/reagent/consumable/nutriment/fat/oil = 15
	)
	result = /obj/item/food/burger/crazy
	category = CAT_BURGER

/datum/crafting_recipe/food/sloppy_moe
	name = "碎肉堡"
	reqs = list(
			/obj/item/food/bun = 1,
			/obj/item/food/meat/cutlet = 2,
			/obj/item/food/onion_slice = 1,
			/datum/reagent/consumable/bbqsauce = 5,
	)
	result = /obj/item/food/burger/sloppy_moe
	category = CAT_BURGER
