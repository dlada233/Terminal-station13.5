/*
*	EMERGENCY RACIAL EQUIPMENT
*/

/datum/supply_pack/goody/airsuppliesnitrogen
	name = "应急呼吸补给(Nitrogen-氮)"
	desc = "内含Vox呼吸面罩与氮气瓶."
	cost = PAYCHECK_CREW
	contains = list(
		/obj/item/tank/internals/nitrogen/belt,
		/obj/item/clothing/mask/breath/vox,
	)

/datum/supply_pack/goody/airsuppliesoxygen
	name = "应急呼吸补给(Oxygen-氧)"
	desc = "内含呼吸面罩与应急氧气瓶."
	cost = PAYCHECK_CREW
	contains = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/clothing/mask/breath,
	)

/datum/supply_pack/goody/airsuppliesplasma
	name = "应急呼吸补给(Plasma-等离子)"
	desc = "内含呼吸面罩与等离子气瓶."
	cost = PAYCHECK_CREW
	contains = list(
		/obj/item/tank/internals/plasmaman/belt,
		/obj/item/clothing/mask/breath,
	)

/*
*	ENGINEERING STUFF
*/

/datum/supply_pack/goody/improvedrcd
	name = "改进型 RCD"
	desc = "改进后的RCD具有更优秀的材料储量，附赠框架和电路升级!"
	cost = PAYCHECK_CREW * 38
	contains = list(/obj/item/construction/rcd/improved)

/*
*	MISC
*/

/datum/supply_pack/goody/crayons
	name = "蜡笔盒"
	desc = "Colorful!"
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/storage/crayons)

/datum/supply_pack/goody/diamondring
	name = "钻戒"
	desc = "表明你的爱就像钻石一般：牢不可破，天长地久. 拒绝退款."
	cost = PAYCHECK_CREW * 50
	contains = list(/obj/item/storage/fancy/ringbox/diamond)
	crate_name = "钻戒箱"

/datum/supply_pack/goody/paperbin
	name = "打印纸盒"
	desc = "让你的文书工作更加轻松！"
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/paper_bin)

/datum/supply_pack/goody/xenoarch_intern
	name = "异星考古入门技能芯片"
	desc = "一个包含所有必要信息的技能芯片，让你可以开始入门异星考古学. \
			不附赠考古工具, \
			也不附赠图书馆长的专业工作经验."
	cost = PAYCHECK_CREW * 35 // 1750 credit goody? do bounties
	contains = list(/obj/item/skillchip/xenoarch_magnifier)

/datum/supply_pack/goody/scratching_stone
	name = "磨刀石"
	desc = "这是一块由特殊合金制成的高级磨刀石，用于磨剃刀般锋利的爪子，但不幸的是，昔日的辉煌已经无法从上面看到了."
	cost = CARGO_CRATE_VALUE * 4 //800 credits
	contains = list(/obj/item/scratching_stone)
	contraband = TRUE

/*
*	CARPET PACKS
*/

/datum/supply_pack/goody/carpet
	name = "经典地毯单品包"
	desc = "厌烦了灰色地砖吗？这一捆包含50块特别柔软地毯的单品包将会使任何房间变得温馨."
	cost = PAYCHECK_CREW * 3
	contains = list(/obj/item/stack/tile/carpet/fifty)

/datum/supply_pack/goody/carpet/black
	name = "黑色地毯单品包"
	contains = list(/obj/item/stack/tile/carpet/black/fifty)

/datum/supply_pack/goody/carpet/premium
	name = "皇家黑地毯单品包"
	desc = "为满足您所有的装饰需求，这一捆包含50块特别柔软地毯的单品包将使房间变得更加华丽."
	cost = PAYCHECK_CREW * 3.5
	contains = list(/obj/item/stack/tile/carpet/royalblack/fifty)

/datum/supply_pack/goody/carpet/premium/royalblue
	name = "皇家蓝地毯单品包"
	contains = list(/obj/item/stack/tile/carpet/royalblue/fifty)

/datum/supply_pack/goody/carpet/premium/red
	name = "红色地毯单品包"
	contains = list(/obj/item/stack/tile/carpet/red/fifty)

/datum/supply_pack/goody/carpet/premium/purple
	name = "紫色地毯单品包"
	contains = list(/obj/item/stack/tile/carpet/purple/fifty)

/datum/supply_pack/goody/carpet/premium/orange
	name = "橙色地毯单品包"
	contains = list(/obj/item/stack/tile/carpet/orange/fifty)

/datum/supply_pack/goody/carpet/premium/green
	name = "绿色地毯单品包"
	contains = list(/obj/item/stack/tile/carpet/green/fifty)

/datum/supply_pack/goody/carpet/premium/cyan
	name = "青色地毯单品包"
	contains = list(/obj/item/stack/tile/carpet/cyan/fifty)

/datum/supply_pack/goody/carpet/premium/blue
	name = "蓝色地毯单品包"
	contains = list(/obj/item/stack/tile/carpet/blue/fifty)

/*
* NIF STUFF
*/
/datum/supply_pack/goody/standard_nif
	name = "Standard Type NIF 标准款"
	desc = "内含一个标准款NIF，需要进行手术以使用."
	cost = CARGO_CRATE_VALUE * 15
	contains = list(
		/obj/item/organ/internal/cyberimp/brain/nif/standard,
	)

/datum/supply_pack/goody/cheap_nif
	name = "Econo-Deck Type NIF 经济款"
	desc = "内含一个经济款NIF，需要进行手术以使用."
	cost = CARGO_CRATE_VALUE * 7.5
	contains = list(
		/obj/item/organ/internal/cyberimp/brain/nif/roleplay_model,
	)

/datum/supply_pack/goody/nif_repair_kit
	name = "Cerulean NIF 蔚蓝修复器"
	desc = "内含装有NIF修复液的容器，可供最多5次使用."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/nif_repair_kit,
	)

/datum/supply_pack/goody/money_sense_nifsoft
	name = "NIF软件 Automatic Appraisal-自评估"
	desc = "内含装有Automatic Appraisal-自评估的NIF软件磁盘."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(
		/obj/item/disk/nifsoft_uploader/money_sense,
	)

/datum/supply_pack/goody/shapeshifter_nifsoft
	name = "NIF软件 Polymorph-多形体"
	desc = "内含装有Polymorph-多形体的NIF软件磁盘."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(
		/obj/item/disk/nifsoft_uploader/shapeshifter,
	)

/datum/supply_pack/goody/hivemind_nifsoft
	name = "NIF软件 Hivemind-蜂群"
	desc = "内含装有Hivemind-蜂群的NIF软件磁盘."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(
		/obj/item/disk/nifsoft_uploader/hivemind,
	)

/datum/supply_pack/goody/summoner_nifsoft
	name = "NIF软件 Grimoire Caeruleam-蔚蓝咒书"
	desc = "内含装有Grimoire Caeruleam-蔚蓝咒书的NIF软件磁盘."
	cost = CARGO_CRATE_VALUE * 0.75
	contains = list(
		/obj/item/disk/nifsoft_uploader/summoner,
	)

/datum/supply_pack/goody/firstaid_pouch
	name = "便携型急救袋"
	desc = "内含一个配有口袋夹的急救袋，默认填入太空站标准的医疗物品,\
	但你也可以自行填入其他物品."
	cost = PAYCHECK_CREW * 6
	contains = list(
		/obj/item/storage/pouch/medical/firstaid/loaded,
	)

/datum/supply_pack/goody/stabilizer_pouch
	name = "抢救型急救袋"
	desc = "内含一个配有口袋夹的急救袋，默认填入以稳定伤情为主的医疗物品,\
	但你也可以自行填入其他物品."
	cost = PAYCHECK_CREW * 6
	contains = list(
		/obj/item/storage/pouch/medical/firstaid/stabilizer,
	)
