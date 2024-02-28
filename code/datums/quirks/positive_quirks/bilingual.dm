/datum/quirk/bilingual
	name = "Bilingual-双语"
	desc = "经过多年努力，你掌握了另一门语言!"
	icon = FA_ICON_GLOBE
	value = 4
	gain_text = span_notice("周围船员交流用词相当的生僻，幸好你事先做了功课.")
	lose_text = span_notice("你似乎忘记了你的第二语言.")
	medical_record_text = "患者使用多种语言."
	mail_goodies = list(/obj/item/taperecorder, /obj/item/clothing/head/frenchberet, /obj/item/clothing/mask/fakemoustache/italian)

/datum/quirk_constant_data/bilingual
	associated_typepath = /datum/quirk/bilingual
	customization_options = list(/datum/preference/choiced/language)

/datum/quirk/bilingual/add_unique(client/client_source)
	var/wanted_language = client_source?.prefs.read_preference(/datum/preference/choiced/language)
	var/datum/language/language_type
	if(wanted_language == "Random")
		language_type = pick(GLOB.uncommon_roundstart_languages)
	else
		language_type = GLOB.language_types_by_name[wanted_language]
	if(quirk_holder.has_language(language_type))
		language_type = /datum/language/uncommon
		if(quirk_holder.has_language(language_type))
			to_chat(quirk_holder, span_boldnotice("You are already familiar with the quirk in your preferences, so you did not learn one."))
			return
		to_chat(quirk_holder, span_boldnotice("You are already familiar with the quirk in your preferences, so you learned Galactic Uncommon instead."))
	quirk_holder.grant_language(language_type, source = LANGUAGE_QUIRK)
