/datum/supply_pack/critter
	group = "活物"
	crate_type = /obj/structure/closet/crate/critter

/datum/supply_pack/critter/parrot
	name = "鹦鹉箱"
	desc = "内含五个专家级通讯鹦鹉."
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/mob/living/basic/parrot)
	crate_name = "鹦鹉箱"

/datum/supply_pack/critter/parrot/generate()
	. = ..()
	for(var/i in 1 to 4)
		new /mob/living/basic/parrot(.)

/datum/supply_pack/critter/butterfly
	name = "蝴蝶箱"
	desc = "一种无害的昆虫，而且比蟑螂和蜘蛛好看得多."//is that a motherfucking worm reference
	contraband = TRUE
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/mob/living/basic/butterfly)
	crate_name = "昆虫学样本箱"

/datum/supply_pack/critter/butterfly/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/basic/butterfly(.)

/datum/supply_pack/critter/cat
	name = "猫箱"
	desc = "猫在喵喵叫！附带一个项圈和一个漂亮的猫玩具！不包括芝士汉堡."//i can't believe im making this reference
	cost = CARGO_CRATE_VALUE * 10 //Cats are worth as much as corgis.
	contains = list(
		/mob/living/basic/pet/cat,
		/obj/item/clothing/neck/petcollar,
		/obj/item/toy/cattoy,
	)
	crate_name = "猫箱"

/datum/supply_pack/critter/cat/generate()
	. = ..()
	if(!prob(50))
		return
	var/mob/living/basic/pet/cat/delete_cat = locate() in .
	if(isnull(delete_cat))
		return
	qdel(delete_cat)
	new /mob/living/basic/pet/cat/_proc(.)

/datum/supply_pack/critter/chick
	name = "鸡箱"
	desc = "鸡在叭叭叫!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/chick)
	crate_name = "鸡箱"

/datum/supply_pack/critter/corgi
	name = "柯基犬箱"
	desc = "被成千上万的科学家认为是最理想的狗狗品种，\
		这只柯基犬是数百万伊恩贵族血统中的一只，脖子上还挂了一个可爱的领子!"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/mob/living/basic/pet/dog/corgi,
					/obj/item/clothing/neck/petcollar,
				)
	crate_name = "柯基犬箱"

/datum/supply_pack/critter/corgi/generate()
	. = ..()
	if(prob(50))
		var/mob/living/basic/pet/dog/corgi/D = locate() in .
		if(D.gender == FEMALE)
			qdel(D)
			new /mob/living/basic/pet/dog/corgi/lisa(.)

/datum/supply_pack/critter/cow
	name = "奶牛箱"
	desc = "奶牛在哞哞叫！"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/mob/living/basic/cow)
	crate_name = "奶牛箱"

/datum/supply_pack/critter/sheep
	name = "绵羊箱"
	desc = "绵羊在里面咩咩叫！"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/mob/living/basic/sheep)
	crate_name = "绵羊箱"

/datum/supply_pack/critter/pig
	name = "猪箱"
	desc = "猪在里面哼哼叫！"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/mob/living/basic/pig)
	crate_name = "猪箱"

/datum/supply_pack/critter/pony
	name = "矮马箱"
	desc = "Ponies, yay! (只送一头.)"
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/mob/living/basic/pony)
	crate_name = "矮马箱"

/datum/supply_pack/critter/crab
	name = "蟹友会"
	desc = "CRAAAAAAB ROCKET. CRAB ROCKET. CRAB ROCKET. CRAB CRAB CRAB CRAB CRAB CRAB CRAB \
		CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB \
		CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB \
		CRAB CRAB CRAB CRAB CRAB CRAB ROCKET. CRAFT. ROCKET. BUY. CRAFT ROCKET. CRAB ROOOCKET. \
		CRAB ROOOOCKET. CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB ROOOOOOOOOOOOOOOOOOOOOOCK \
		EEEEEEEEEEEEEEEEEEEEEEEEE EEEETTTTTTTTTTTTAAAAAAAAA AAAHHHHHHHHHHHHH. CRAB ROCKET. CRAAAB \
		ROCKEEEEEEEEEGGGGHHHHTT CRAB CRAB CRAABROCKET CRAB ROCKEEEET."//fun fact: i actually spent like 10 minutes and transcribed the entire video.
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/mob/living/basic/crab)
	crate_name = "集合啦动物蟹友会"
	drop_pod_only = TRUE

/datum/supply_pack/critter/crab/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/basic/crab(.)

/datum/supply_pack/critter/corgis/exotic
	name = "异国柯基箱"
	desc = "适合作为王的柯基犬，因为其具有特殊的颜色，表明了其与生俱来的独特优越性，\
		带有一条可爱的领子!"
	cost = CARGO_CRATE_VALUE * 11
	contains = list(/mob/living/basic/pet/dog/corgi/exoticcorgi,
					/obj/item/clothing/neck/petcollar,
				)
	crate_name = "异国柯基箱"

/datum/supply_pack/critter/fox
	name = "狐狸箱"
	desc = "狐狸怎么叫...?"//what does the fox say
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/mob/living/basic/pet/fox,
		/obj/item/clothing/neck/petcollar,
	)
	crate_name = "狐狸箱"

/datum/supply_pack/critter/goat
	name = "山羊箱"
	desc = "山羊在咩咩叫! 如果拿来代替Pete, 则保修失效."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/mob/living/basic/goat)
	crate_name = "山羊箱"

/datum/supply_pack/critter/rabbit
	name = "兔子箱"
	desc = "兔子在里面跺脚！"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/rabbit)
	crate_name = "兔子箱"

/datum/supply_pack/critter/mothroach
	name = "蛾子虫"
	desc = "挂在头上让大家知道真正的可爱是什么样子的，\
		内含一只蛾子虫."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/mothroach)
	crate_name = "蛾子虫"

/datum/supply_pack/critter/monkey
	name = "猴子方块补给箱"
	desc = "停止猴戏！包含了七盒猴子方块，只需加水."
	cost = CARGO_CRATE_VALUE * 4
	contains = list (/obj/item/storage/box/monkeycubes)
	crate_type = /obj/structure/closet/crate
	crate_name = "猴子方块补给箱"

/datum/supply_pack/critter/pug
	name = "哈巴狗箱"
	desc = "如同普通的狗，只是...有点扁."
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/mob/living/basic/pet/dog/pug,
					/obj/item/clothing/neck/petcollar,
				)
	crate_name = "哈巴狗箱"

/datum/supply_pack/critter/bullterrier
	name = "斗牛犬箱"
	desc = "如同普通的狗，只是有一个鸡蛋形状的头. \
		附赠一条领带!"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/mob/living/basic/pet/dog/bullterrier,
					/obj/item/clothing/neck/petcollar,
				)
	crate_name = "斗牛犬箱"

/datum/supply_pack/critter/snake
	name = "蛇箱"
	desc = "已经受够了他妈的蛇在他妈的空间站乱搅? \
		那这个货物可能不适合你，内含三条毒蛇."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/mob/living/basic/snake = 3)
	crate_name = "蛇箱"

/datum/supply_pack/critter/amphibians
	name = "两栖动物箱"
	desc = "两种两栖动物朋友，细胞学家会喜欢它们的! \
		内含青蛙和蝾螈各一只，警告: 青蛙可能含有毒素."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/mob/living/basic/axolotl,
		/mob/living/basic/frog,
	)
	crate_name = "两栖动物箱"

/datum/supply_pack/critter/lizard
	name = "蜥蜴箱"
	desc = "Hisss！包含一只友善的蜥蜴，别和蜥蜴人搞混了."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/lizard)
	crate_name = "lizard crate"

/datum/supply_pack/critter/garden_gnome
	name = "花园地精箱"
	desc = "把他们都收集到你的花园里，一共有三个."
	hidden = TRUE
	cost = CARGO_CRATE_VALUE * 20
	contains = list(/mob/living/basic/garden_gnome)
	crate_name = "花园地精箱"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/critter/garden_gnome/generate()
	. = ..()
	for(var/i in 1 to 2)
		new /mob/living/basic/garden_gnome(.)

/datum/supply_pack/critter/fish
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/critter/fish/aquarium_fish
	name = "观赏鱼箱"
	desc = "两条由我的猴子精选挑选的水族观赏鱼."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random = 2)
	crate_name = "观赏鱼箱"

/datum/supply_pack/critter/fish/freshwater_fish
	name = "淡水鱼箱"
	desc = "大部分泥都被我们清理干净的观赏鱼."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random/freshwater = 2)
	crate_name = "淡水鱼箱"

/datum/supply_pack/critter/fish/saltwater_fish
	name = "咸水鱼箱"
	desc = "满屋子都是咸味的观赏鱼."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random/saltwater = 2)
	crate_name = "咸水鱼箱"

/datum/supply_pack/critter/fish/tiziran_fish
	name = "异种鱼箱"
	desc = "从Tiziran-缇兹兰 Zagos sea-萨克海进口的咸水鱼."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/tiziran = 2)
	crate_name = "异种鱼箱"
