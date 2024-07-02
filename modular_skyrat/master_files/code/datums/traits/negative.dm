// SKYRAT NEGATIVE TRAITS

/datum/quirk/alexithymia
	name = "Alexithymia-述情障碍"
	desc = "你无法准确评估自己的感受."
	value = -4
	mob_trait = TRAIT_MOOD_NOEXAMINE
	medical_record_text = "患者无法表达自己的情绪."
	icon = FA_ICON_QUESTION_CIRCLE

/datum/quirk/fragile
	name = "Fragility-脆弱"
	desc = "你觉得自己特别脆弱，烧伤和创伤的伤害比常人更加剧烈!"
	value = -6
	medical_record_text = "患者身体已经适应了低重力环境。遗憾的是，低重力环境不利于坚固骨骼的发育."
	icon = FA_ICON_TIRED

/datum/quirk_constant_data/fragile
	associated_typepath = /datum/quirk/fragile
	customization_options = list(
		/datum/preference/numeric/fragile_customization/brute,
		/datum/preference/numeric/fragile_customization/burn,
	)

/datum/preference/numeric/fragile_customization
	abstract_type = /datum/preference/numeric/fragile_customization
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER

	minimum = 1.25
	maximum = 5 // 5x damage, arbitrary

	step = 0.01

/datum/preference/numeric/fragile_customization/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/datum/preference/numeric/fragile_customization/create_default_value()
	return 1.25

/datum/preference/numeric/fragile_customization/brute
	savefile_key = "fragile_brute"

/datum/preference/numeric/fragile_customization/burn
	savefile_key = "fragile_burn"

/datum/quirk/fragile/post_add()
	. = ..()

	var/mob/living/carbon/human/user = quirk_holder
	var/datum/preferences/prefs = user.client.prefs
	var/brutemod = prefs.read_preference(/datum/preference/numeric/fragile_customization/brute)
	var/burnmod = prefs.read_preference(/datum/preference/numeric/fragile_customization/burn)

	user.physiology.brute_mod *= brutemod
	user.physiology.burn_mod *= burnmod

/datum/quirk/fragile/remove()
	. = ..()

	var/mob/living/carbon/human/user = quirk_holder
	var/datum/preferences/prefs = user.client.prefs
	var/brutemod = prefs.read_preference(/datum/preference/numeric/fragile_customization/brute)
	var/burnmod = prefs.read_preference(/datum/preference/numeric/fragile_customization/burn)
	// will cause issues if the user changes this value before removal
	user.physiology.brute_mod /= brutemod
	user.physiology.burn_mod /= burnmod

/datum/quirk/monophobia
	name = "Monophobia-孤独恐惧症"
	desc = "远离他人会使你压力骤增,引发从恶心到心脏病发作的恐慌反应。."
	value = -6
	gain_text = span_danger("你感到很孤独...")
	lose_text = span_notice("你觉得自己一个人也可以照顾好自己.")
	medical_record_text = "患者远离他人时会出现恶心和痛苦等症状，可能引发危及生命的恐慌反应."
	icon = FA_ICON_PEOPLE_ARROWS_LEFT_RIGHT

/datum/quirk/monophobia/post_add()
	. = ..()
	var/mob/living/carbon/human/user = quirk_holder
	user.gain_trauma(/datum/brain_trauma/severe/monophobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/monophobia/remove()
	. = ..()
	var/mob/living/carbon/human/user = quirk_holder
	user?.cure_trauma_type(/datum/brain_trauma/severe/monophobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/no_guns
	name = "No Guns-不持枪"
	desc = "无论出于何种原因，你都无法使用枪支.原因可能各不相同，由你来决定."
	gain_text = span_notice("你觉得你再也无法使用枪支了...")
	lose_text = span_notice("你突然觉得自己又能用枪了!")
	medical_record_text = "患者无法使用枪支. 病因不明."
	value = -6
	mob_trait = TRAIT_NOGUNS
	icon = FA_ICON_GUN
