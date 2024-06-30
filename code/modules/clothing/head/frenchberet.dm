/obj/item/clothing/head/frenchberet
	name = "法国贝雷帽"
	desc = "一顶优质的贝雷帽，带有吸雪茄喝红酒的巴黎人香气，不知为何，你对军事冲突的兴趣减少了."
	icon_state = "beret"
	greyscale_config = /datum/greyscale_config/beret
	greyscale_config_worn = /datum/greyscale_config/beret/worn
	greyscale_colors = "#972A2A"


/obj/item/clothing/head/frenchberet/equipped(mob/M, slot)
	. = ..()
	if (slot & ITEM_SLOT_HEAD)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
		ADD_TRAIT(M, TRAIT_GARLIC_BREATH, type)
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)
		REMOVE_TRAIT(M, TRAIT_GARLIC_BREATH, type)

/obj/item/clothing/head/frenchberet/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)
	REMOVE_TRAIT(M, TRAIT_GARLIC_BREATH, type)

/obj/item/clothing/head/frenchberet/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = " [message]"
		var/list/french_words = strings("french_replacement.json", "french")

		for(var/key in french_words)
			var/value = french_words[key]
			if(islist(value))
				value = pick(value)

			message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
			message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
			message = replacetextEx(message, " [key]", " [value]")

		if(prob(3))
			message += pick(" Honh honh honh!", " Honh!", " Zut Alors!")
	speech_args[SPEECH_MESSAGE] = trim(message)
