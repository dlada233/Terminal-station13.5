/datum/species/human
	name = "\improper 人类"
	id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
	)
	mutant_bodyparts = list("wings" = "None")
	skinned_type = /obj/item/stack/sheet/animalhide/human
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 1.1

/datum/species/human/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#bb9966", update = FALSE) // brown
	human.set_hairstyle("Business Hair", update = TRUE)

/datum/species/human/get_scream_sound(mob/living/carbon/human/human)
	if(human.physique == MALE)
		if(prob(1))
			return 'sound/voice/human/wilhelm_scream.ogg'
		return pick(
			'sound/voice/human/malescream_1.ogg',
			'sound/voice/human/malescream_2.ogg',
			'sound/voice/human/malescream_3.ogg',
			'sound/voice/human/malescream_4.ogg',
			'sound/voice/human/malescream_5.ogg',
			'sound/voice/human/malescream_6.ogg',
		)

	return pick(
		'sound/voice/human/femalescream_1.ogg',
		'sound/voice/human/femalescream_2.ogg',
		'sound/voice/human/femalescream_3.ogg',
		'sound/voice/human/femalescream_4.ogg',
		'sound/voice/human/femalescream_5.ogg',
	)

/datum/species/human/get_species_description()
	return "人类是已知银河系中的主导物种. \
		他们的足迹从古老的地球延伸到已知宇宙的边缘."

/datum/species/human/get_species_lore()
	return list(
		"这些灵长类动物起源于基本无害的地球, \
		如今早已跨越他们的家园，褪去原先温顺的形象. \
		太空时代将人类带出太阳系，迈向了整个银河系.",

		"人类惯有的傲慢再次显现,他们从泰拉陆地扩张到最终边界的步伐几乎打破纪录 \
		,但也冒犯了与其共享舞台的其他种族. \
		其中包括了蜥蜴族 - 如果说谁对这些暴发户感到不满,那肯定非蜥蜴人莫属.",

		"人类从未像其他物种那样,拥有完全团结于同一面旗帜下的和平, \
		联合国官僚们的繁文缛节在“泰拉政府”, \
		这个人类社会中由不同国家拼凑而成的体系中延续至今.",

		"人类的逐利和进取精神达到了顶峰,催生出了新的形态: \
		超级公司.这些庞然大物游离于泰拉政府之外,字面上和实际上都脱离了地球政府的管控, \
		金钱买下所需的参议院选票,并在远离泰拉政府掌控的土地上建立领地. \
		在超级公司的领地上,公司条例即法律,这赋予了\"雇佣终止\"全新含义.",
	)

/datum/species/human/create_pref_unique_perks()
	var/list/to_add = list()

	if(CONFIG_GET(number/default_laws) == 0 || CONFIG_GET(flag/silicon_asimov_superiority_override)) // Default lawset is set to Asimov
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "robot",
			SPECIES_PERK_NAME = "阿西莫夫优越性",
			SPECIES_PERK_DESC = "人工智能和塞博在默认情况下仅服从于人类.作为人类,硅基造物必须保护并服从于你.",
		))

	if(CONFIG_GET(flag/enforce_human_authority))
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bullhorn",
			SPECIES_PERK_NAME = "指挥链",
			SPECIES_PERK_DESC = "纳米传讯仅允许人类担任指挥人员,例如舰长.",
		))

	return to_add
