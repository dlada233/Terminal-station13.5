//These are all minor mutations that affect your speech somehow.
//Individual ones aren't commented since their functions should be evident at a glance

/datum/mutation/human/nervousness
	name = "神经紧张"
	desc = "导致突变携带者口吃."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='danger'>你感觉很紧张.</span>"

/datum/mutation/human/nervousness/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(5, seconds_per_tick))
		owner.set_stutter_if_lower(20 SECONDS)

/datum/mutation/human/wacky
	name = "滑稽"
	desc = "你不是个小丑，你简直就是整个马戏团."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='sans'><span class='infoplain'>你的喉咙感觉有点异样.</span></span>"
	text_lose_indication = "<span class='notice'>异样感消失了.</span>"

/datum/mutation/human/wacky/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/wacky/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/wacky/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	speech_args[SPEECH_SPANS] |= SPAN_SANS

/datum/mutation/human/mute
	name = "失语"
	desc = "完全抑制了大脑发声区域的功能."
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>你感到无法表达自己，仿佛被世界禁言了一般.</span>"
	text_lose_indication = "<span class='danger'>你终于能再次发声，打破了沉默的禁锢.</span>"

/datum/mutation/human/mute/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_MUTE, GENETIC_MUTATION)

/datum/mutation/human/mute/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_MUTE, GENETIC_MUTATION)

/datum/mutation/human/unintelligible
	name = "含糊不清"
	desc = "部分抑制了大脑的发声区域，严重扭曲你的发音，使他人难以理解."
	quality = NEGATIVE
	text_gain_indication = "<span class='danger'>你无法进行任何清晰的思考!</span>"
	text_lose_indication = "<span class='danger'>你的思绪感觉更清晰了.</span>"

/datum/mutation/human/unintelligible/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, GENETIC_MUTATION)

/datum/mutation/human/unintelligible/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, GENETIC_MUTATION)

/datum/mutation/human/swedish
	name = "瑞典化"
	desc = "起源于遥远过去的可怕变异，据信在 2037 年事件后被根除."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='notice'>你感觉被“瑞典化”了，无论那是什么意思.</span>"
	text_lose_indication = "<span class='notice'>瑞典化的感觉消失了.</span>"

/datum/mutation/human/swedish/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/swedish/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/swedish/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = replacetext(message,"w","v")
		message = replacetext(message,"j","y")
		message = replacetext(message,"a",pick("å","ä","æ","a"))
		message = replacetext(message,"bo","bjo")
		message = replacetext(message,"o",pick("ö","ø","o"))
		if(prob(30))
			message += " Bork[pick("",", bork",", bork, bork")]!"
		speech_args[SPEECH_MESSAGE] = trim(message)

/datum/mutation/human/chav
	name = "乡巴佬"
	desc = "未知"
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='notice'>你感觉自己像个乡巴佬，对吧?</span>"
	text_lose_indication = "<span class='notice'>你不再那么粗鲁无礼了.</span>"

/datum/mutation/human/chav/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/chav/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/chav/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = " [message]"
		var/list/chav_words = strings("chav_replacement.json", "chav")

		for(var/key in chav_words)
			var/value = chav_words[key]
			if(islist(value))
				value = pick(value)

			message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
			message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
			message = replacetextEx(message, " [key]", " [value]")
		if(prob(30))
			message += ", mate"
		speech_args[SPEECH_MESSAGE] = trim(message)

/datum/mutation/human/elvis
	name = "猫王"
	desc = "以其“零号病人”来命名，令人恐惧的突变."
	quality = MINOR_NEGATIVE
	locked = TRUE
	text_gain_indication = "<span class='notice'>你感觉很好，甜心.</span>"
	text_lose_indication = "<span class='notice'>你感觉少说点话会更好一些.</span>"

/datum/mutation/human/elvis/on_life(seconds_per_tick, times_fired)
	switch(pick(1,2))
		if(1)
			if(SPT_PROB(7.5, seconds_per_tick))
				var/list/dancetypes = list("摇摆", "花哨", "时髦", "20世纪", "摇摆'", "摇滚", "拉风", "淫荡", "打击", "锤击")
				var/dancemoves = pick(dancetypes)
				owner.visible_message("<b>[owner]</b> 突然做起 [dancemoves] 的动作!")
		if(2)
			if(SPT_PROB(7.5, seconds_per_tick))
				owner.visible_message("<b>[owner]</b> [pick("扭起臀部", "旋转着臀部", "摆动起臀部", "轻敲他的脚", "随着想象中的歌曲跳舞", "扭动着双腿", "打起响指")]!")

/datum/mutation/human/elvis/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/elvis/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/elvis/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "
		message = replacetext(message," i'm not "," I ain't ")
		message = replacetext(message," girl ",pick(" honey "," baby "," baby doll "))
		message = replacetext(message," man ",pick(" son "," buddy "," brother"," pal "," friendo "))
		message = replacetext(message," out of "," outta ")
		message = replacetext(message," thank you "," thank you, thank you very much ")
		message = replacetext(message," thanks "," thank you, thank you very much ")
		message = replacetext(message," what are you "," whatcha ")
		message = replacetext(message," yes ",pick(" sure", "yea "))
		message = replacetext(message," muh valids "," my kicks ")
		speech_args[SPEECH_MESSAGE] = trim(message)
// 效果为更换英文单词，无需处理

/datum/mutation/human/stoner
	name = "糊涂虫"
	desc = "一种常见的变异，会严重降低智力."
	quality = NEGATIVE
	locked = TRUE
	text_gain_indication = "<span class='notice'>你感觉超~~放松，哥们!</span>"
	text_lose_indication = "<span class='notice'>你感觉时间观念强了些.</span>"

/datum/mutation/human/stoner/on_acquiring(mob/living/carbon/human/owner)
	..()
	owner.grant_language(/datum/language/beachbum, source = LANGUAGE_STONER)
	owner.add_blocked_language(subtypesof(/datum/language) - /datum/language/beachbum, LANGUAGE_STONER)

/datum/mutation/human/stoner/on_losing(mob/living/carbon/human/owner)
	..()
	owner.remove_language(/datum/language/beachbum, source = LANGUAGE_STONER)
	owner.remove_blocked_language(subtypesof(/datum/language) - /datum/language/beachbum, LANGUAGE_STONER)

/datum/mutation/human/medieval
	name = "中世纪"
	desc = "源于遥远过去的可怕变异，据信曾是旧世界欧洲普遍存在的基因."
	quality = MINOR_NEGATIVE
	text_gain_indication = "<span class='notice'>你心中燃起了寻找圣杯的渴望!</span>"
	text_lose_indication = "<span class='notice'>你不再渴望寻找任何东西.</span>"

/datum/mutation/human/medieval/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/medieval/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/medieval/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "
		var/list/medieval_words = strings("medieval_replacement.json", "medieval")
		var/list/startings = strings("medieval_replacement.json", "startings")
		for(var/key in medieval_words)
			var/value = medieval_words[key]
			if(islist(value))
				value = pick(value)
			if(uppertext(key) == key)
				value = uppertext(value)
			if(capitalize(key) == key)
				value = capitalize(value)
			message = replacetextEx(message,regex("\b[REGEX_QUOTE(key)]\b","ig"), value)
		message = trim(message)
		var/chosen_starting = pick(startings)
		message = "[chosen_starting] [message]"

		speech_args[SPEECH_MESSAGE] = message

/datum/mutation/human/piglatin
	name = "猪拉丁语"
	desc = "历史学家说，早在 2020 年代，人类就完全用这种神秘的语言交流."
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("你开始说猪拉丁语了.")
	text_lose_indication = span_notice("你不再说猪拉丁语了.")

/datum/mutation/human/piglatin/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/human/piglatin/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/human/piglatin/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/spoken_message = speech_args[SPEECH_MESSAGE]
	spoken_message = piglatin_sentence(spoken_message)
	speech_args[SPEECH_MESSAGE] = spoken_message
