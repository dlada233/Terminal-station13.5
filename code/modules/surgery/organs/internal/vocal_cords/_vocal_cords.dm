/obj/item/organ/internal/vocal_cords //organs that are activated through speech with the :x/MODE_KEY_VOCALCORDS channel
	name = "声带"
	icon_state = "appendix"
	visual = FALSE
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_VOICE
	gender = PLURAL
	decay_factor = 0 //we don't want decaying vocal cords to somehow matter or appear on scanners since they don't do anything damaged
	healing_factor = 0
	var/list/spans = null

/obj/item/organ/internal/vocal_cords/proc/can_speak_with() //if there is any limitation to speaking with these cords
	return TRUE

/obj/item/organ/internal/vocal_cords/proc/speak_with(message) //do what the organ does
	return

/obj/item/organ/internal/vocal_cords/proc/handle_speech(message) //actually say the message
	owner.say(message, spans = spans, sanitize = FALSE)

//Colossus drop, forces the listeners to obey certain commands
/obj/item/organ/internal/vocal_cords/colossus
	name = "神圣声带"
	desc = "传递古代神灵的声音."
	icon_state = "voice_of_god"
	actions_types = list(/datum/action/item_action/organ_action/colossus)
	var/next_command = 0
	var/cooldown_mod = 1
	var/base_multiplier = 1
	spans = list("高声道","呐喊道")

/datum/action/item_action/organ_action/colossus
	name = "上帝之声"
	var/obj/item/organ/internal/vocal_cords/colossus/cords = null

/datum/action/item_action/organ_action/colossus/New()
	..()
	cords = target

/datum/action/item_action/organ_action/colossus/IsAvailable(feedback = FALSE)
	if(!owner)
		return FALSE
	if(world.time < cords.next_command)
		if (feedback)
			owner.balloon_alert(owner, "等待[DisplayTimeText(cords.next_command - world.time)]!")
		return FALSE
	if(isliving(owner))
		var/mob/living/living = owner
		if(!living.can_speak())
			if (feedback)
				owner.balloon_alert(owner, "无法讲话!")
			return FALSE
	if(check_flags & AB_CHECK_CONSCIOUS)
		if(owner.stat)
			if (feedback)
				owner.balloon_alert(owner, "无意识!")
			return FALSE
	return TRUE

/datum/action/item_action/organ_action/colossus/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/command = tgui_input_text(owner, "用上帝之声讲话", "下令")
	if(!command)
		return
	if(QDELETED(src) || QDELETED(owner))
		return
	owner.say(".x[command]")

/obj/item/organ/internal/vocal_cords/colossus/can_speak_with()
	if(!owner)
		return FALSE

	if(world.time < next_command)
		to_chat(owner, span_notice("你必须等待[DisplayTimeText(next_command - world.time)]才能再次讲话."))
		return FALSE

	return owner.can_speak()

/obj/item/organ/internal/vocal_cords/colossus/handle_speech(message)
	playsound(get_turf(owner), 'sound/magic/clockwork/invoke_general.ogg', 300, TRUE, 5)
	return //voice of god speaks for us

/obj/item/organ/internal/vocal_cords/colossus/speak_with(message)
	var/cooldown = voice_of_god(uppertext(message), owner, spans, base_multiplier)
	next_command = world.time + (cooldown * cooldown_mod)

/obj/item/organ/internal/adamantine_resonator
	visual = FALSE
	name = "精金共鸣器"
	desc = "所有石人中都含有精金碎片，这些碎片源自它们作为纯粹魔法构造物的起源；它们被用来“接收”来自领导者的信息."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_ADAMANTINE_RESONATOR
	icon_state = "adamantine_resonator"

/obj/item/organ/internal/vocal_cords/adamantine
	name = "精金声带"
	desc = "当精金发生共振时，它会引发附近所有精金也产生共鸣，含有这种结构的石人利用这一特性向附近的其他石人传递信息."
	actions_types = list(/datum/action/item_action/organ_action/use/adamantine_vocal_cords)
	icon_state = "adamantine_cords"

/datum/action/item_action/organ_action/use/adamantine_vocal_cords/Trigger(trigger_flags)
	if(!IsAvailable(feedback = TRUE))
		return
	var/message = tgui_input_text(owner, "向附近的石人共振一条信息", "共振")
	if(!message)
		return
	if(QDELETED(src) || QDELETED(owner))
		return
	owner.say(".x[message]")

/obj/item/organ/internal/vocal_cords/adamantine/handle_speech(message)
	var/msg = span_resonate("[span_name("[owner.real_name]")]共振, \"[message]\"")
	for(var/player in GLOB.player_list)
		if(iscarbon(player))
			var/mob/living/carbon/speaker = player
			if(speaker.get_organ_slot(ORGAN_SLOT_ADAMANTINE_RESONATOR))
				to_chat(speaker, msg)
		if(isobserver(player))
			var/link = FOLLOW_LINK(player, owner)
			to_chat(player, "[link] [msg]")
