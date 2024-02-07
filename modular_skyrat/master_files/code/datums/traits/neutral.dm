GLOBAL_VAR_INIT(DNR_trait_overlay, generate_DNR_trait_overlay())

/// Instantiates GLOB.DNR_trait_overlay by creating a new mutable_appearance instance of the overlay.
/proc/generate_DNR_trait_overlay()
	RETURN_TYPE(/mutable_appearance)

	var/mutable_appearance/DNR_trait_overlay = mutable_appearance('modular_skyrat/modules/indicators/icons/DNR_trait_overlay.dmi', "DNR", FLY_LAYER)
	DNR_trait_overlay.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	return DNR_trait_overlay


// SKYRAT NEUTRAL TRAITS
/datum/quirk/excitable
	name = "Excitable!-容易兴奋!"
	desc = "摸摸头就会让你摇尾巴！好兴奋啊！摇尾巴摇尾巴."
	gain_text = span_notice("你渴望有人摸摸你的头!")
	lose_text = span_notice("你不再像以前那样渴望有人摸头了.")
	medical_record_text = "病人似乎很容易兴奋."
	value = 0
	mob_trait = TRAIT_EXCITABLE
	icon = FA_ICON_LAUGH_BEAM

/datum/quirk/affectionaversion
	name = "Affection Aversion"
	desc = "You refuse to be licked or nosed by quadruped cyborgs."
	gain_text = span_notice("You've been added to the Do Not Lick and No Nosing registries.")
	lose_text = span_notice("You've been removed from the Do Not Lick and No Nosing registries.")
	medical_record_text = "Patient is in the Do Not Lick and No Nosing registries."
	value = 0
	mob_trait = TRAIT_AFFECTION_AVERSION
	icon = FA_ICON_CIRCLE_EXCLAMATION

/datum/quirk/personalspace
	name = "Personal Space-私人空间"
	desc = "你不希望别人碰你的屁股."
	gain_text = span_notice("你希望别人不要碰你的屁股.")
	lose_text = span_notice("你不再那么介意别人碰你的屁股了.")
	medical_record_text = "Patient demonstrates negative reactions to their posterior being touched."
	value = 0
	mob_trait = TRAIT_PERSONALSPACE
	icon = FA_ICON_HAND_PAPER

/datum/quirk/dnr
	name = "Do Not Revive-请勿复活"
	desc = "无论出于何种原因，你无法被复活."
	gain_text = span_notice("你的灵魂伤痕累累，无法接受复活.")
	lose_text = span_notice("你能感到你的灵魂恢复如初.")
	medical_record_text = "该患者为 DNR (Do Not Resuscitate，禁止心肺复苏)，任何复活措施均无效."
	value = 0
	mob_trait = TRAIT_DNR
	icon = FA_ICON_SKULL_CROSSBONES

/datum/quirk/dnr/add(client/client_source)
	. = ..()

	quirk_holder.update_dnr_hud()

/datum/quirk/dnr/remove()
	var/mob/living/old_holder = quirk_holder

	. = ..()

	old_holder.update_dnr_hud()

/mob/living/prepare_data_huds()
	. = ..()

	update_dnr_hud()

/// Adds the DNR HUD element if src has TRAIT_DNR. Removes it otherwise.
/mob/living/proc/update_dnr_hud()
	var/image/dnr_holder = hud_list?[DNR_HUD]
	if(isnull(dnr_holder))
		return

	var/icon/temporary_icon = icon(icon, icon_state, dir)
	dnr_holder.pixel_y = temporary_icon.Height() - world.icon_size

	if(HAS_TRAIT(src, TRAIT_DNR))
		set_hud_image_active(DNR_HUD)
		dnr_holder.icon_state = "hud_dnr"
	else
		set_hud_image_inactive(DNR_HUD)

/mob/living/carbon/human/examine(mob/user)
	. = ..()

	if(stat != DEAD && HAS_TRAIT(src, TRAIT_DNR) && (HAS_TRAIT(user, TRAIT_SECURITY_HUD) || HAS_TRAIT(user, TRAIT_MEDICAL_HUD)))
		. += "\n[span_boldwarning("This individual is unable to be revived, and may be permanently dead if allowed to die!")]"

/datum/atom_hud/data/human/dnr
	hud_icons = list(DNR_HUD)

// uncontrollable laughter
/datum/quirk/item_quirk/joker
	name = "Pseudobulbar Affect-假性延髓情感反应"
	desc = "每隔一段时间，你会无法控制的哈哈大笑."
	value = 0
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	medical_record_text = "患者会突然控制不住的哈哈大笑."
	var/pcooldown = 0
	var/pcooldown_time = 60 SECONDS
	icon = FA_ICON_GRIN_TEARS

/datum/quirk/item_quirk/joker/add_unique(client/client_source)
	give_item_to_holder(/obj/item/paper/joker, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

/datum/quirk/item_quirk/joker/process()
	if(pcooldown > world.time)
		return
	pcooldown = world.time + pcooldown_time
	var/mob/living/carbon/human/user = quirk_holder
	if(user && istype(user))
		if(user.stat == CONSCIOUS)
			if(prob(20))
				user.emote("laugh")
				addtimer(CALLBACK(user, /mob/proc/emote, "laugh"), 5 SECONDS)
				addtimer(CALLBACK(user, /mob/proc/emote, "laugh"), 10 SECONDS)

/obj/item/paper/joker
	name = "disability card-残疾证"
	icon = 'modular_skyrat/master_files/icons/obj/card.dmi'
	icon_state = "joker"
	desc = "即使心痛，也微笑吧."
	default_raw_text = "<i>\
			<div style='border-style:solid;text-align:center;border-width:5px;margin: 20px;margin-bottom:0px'>\
			<div style='margin-top:20px;margin-bottom:20px;font-size:150%;'>\
			Forgive my laughter:<br>\
			I have a condition.\
			</div>\
			</div>\
			</i>\
			<br>\
			<center>\
			<b>\
			MORE ON BACK\
			</b>\
			</center>"
	/// Whether or not the card is currently flipped.
	var/flipped = FALSE
	/// The flipped version of default_raw_text.
	var/flipside_default_raw_text = "<i>\
			<div style='border-style:solid;text-align:center;border-width:5px;margin: 20px;margin-bottom:0px'>\
			<div style='margin-top:20px;margin-bottom:20px;font-size:100%;'>\
			<b>\
			It's a medical condition causing sudden,<br>\
			frequent and uncontrollable laughter that<br>\
			doesn't match how you feel.<br>\
			It can happen in people with a brain injury<br>\
			or certain neurological conditions.<br>\
			</b>\
			</div>\
			</div>\
			</i>\
			<br>\
			<center>\
			<b>\
			KINDLY RETURN THIS CARD\
			</b>\
			</center>"
	/// Flipside version of raw_text_inputs.
	var/list/datum/paper_input/flipside_raw_text_inputs
	/// Flipside version of raw_stamp_data.
	var/list/datum/paper_stamp/flipside_raw_stamp_data
	/// Flipside version of raw_field_input_data.
	var/list/datum/paper_field/flipside_raw_field_input_data
	/// Flipside version of input_field_count
	var/flipside_input_field_count = 0


/obj/item/paper/joker/Initialize(mapload)
	. = ..()
	if(flipside_default_raw_text)
		add_flipside_raw_text(flipside_default_raw_text)


/**
 * This is an unironic copy-paste of add_raw_text(), meant to have the same functionalities, but for the flipside.
 *
 * This simple helper adds the supplied raw text to the flipside of the paper, appending to the end of any existing contents.
 *
 * This a God proc that does not care about paper max length and expects sanity checking beforehand if you want to respect it.
 *
 * The caller is expected to handle updating icons and appearance after adding text, to allow for more efficient batch adding loops.
 * * Arguments:
 * * text - The text to append to the paper.
 * * font - The font to use.
 * * color - The font color to use.
 * * bold - Whether this text should be rendered completely bold.
 */
/obj/item/paper/joker/proc/add_flipside_raw_text(text, font, color, bold)
	var/new_input_datum = new /datum/paper_input(
		text,
		font,
		color,
		bold,
	)

	flipside_input_field_count += get_input_field_count(text)

	LAZYADD(flipside_raw_text_inputs, new_input_datum)


/obj/item/paper/joker/update_icon()
	..()
	icon_state = "joker"

/obj/item/paper/joker/AltClick(mob/living/carbon/user, obj/item/card)
	var/list/datum/paper_input/old_raw_text_inputs = raw_text_inputs
	var/list/datum/paper_stamp/old_raw_stamp_data = raw_stamp_data
	var/list/datum/paper_stamp/old_raw_field_input_data = raw_field_input_data
	var/old_input_field_count = input_field_count

	raw_text_inputs = flipside_raw_text_inputs
	raw_stamp_data = flipside_raw_stamp_data
	raw_field_input_data = flipside_raw_field_input_data
	input_field_count = flipside_input_field_count

	flipside_raw_text_inputs = old_raw_text_inputs
	flipside_raw_stamp_data = old_raw_stamp_data
	flipside_raw_field_input_data = old_raw_field_input_data
	flipside_input_field_count = old_input_field_count

	flipped = !flipped
	update_static_data()

	balloon_alert(user, "card flipped")

/datum/quirk/feline_aspect
	name = "Feline Traits"
	desc = "You happen to act like a feline, for whatever reason."
	gain_text = span_notice("Nya could go for some catnip right about now...")
	lose_text = span_notice("You feel less attracted to lasers.")
	medical_record_text = "Patient seems to possess behavior much like a feline."
	mob_trait = TRAIT_FELINE
	icon = FA_ICON_CAT

/datum/quirk/item_quirk/canine
	name = "Canidae Traits"
	desc = "Bark. You seem to act like a canine for whatever reason. This will replace most other tongue-based speech quirks."
	mob_trait = TRAIT_CANINE
	icon = FA_ICON_DOG
	value = 0
	medical_record_text = "Patient was seen digging through the trash can. Keep an eye on them."

/datum/quirk/item_quirk/canine/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/internal/tongue/dog/new_tongue = new(get_turf(human_holder))

	new_tongue.copy_traits_from(human_holder.get_organ_slot(ORGAN_SLOT_TONGUE))
	new_tongue.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/quirk/item_quirk/avian
	name = "Avian Traits"
	desc = "You're a birdbrain, or you've got a bird's brain. This will replace most other tongue-based speech quirks."
	mob_trait = TRAIT_AVIAN
	icon = FA_ICON_KIWI_BIRD
	value = 0
	medical_record_text = "Patient exhibits avian-adjacent mannerisms."

/datum/quirk/item_quirk/avian/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/organ/internal/tongue/avian/new_tongue = new(get_turf(human_holder))

	new_tongue.copy_traits_from(human_holder.get_organ_slot(ORGAN_SLOT_TONGUE))
	new_tongue.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/quirk/sensitivesnout
	name = "Sensitive Snout"
	desc = "Your face has always been sensitive, and it really hurts when someone pokes it!"
	gain_text = span_notice("Your face is awfully sensitive.")
	lose_text = span_notice("Your face feels numb.")
	medical_record_text = "Patient's nose seems to have a cluster of nerves in the tip, would advise against direct contact."
	value = 0
	mob_trait = TRAIT_SENSITIVESNOUT
	icon = FA_ICON_FINGERPRINT

/datum/quirk/overweight
	name = "Overweight-肥胖"
	desc = "虽然你比同身高的人重，但你已经习惯了."
	gain_text = span_notice("你感到身体很重.")
	lose_text = span_notice("你突然感觉身体变得轻盈!")
	value = 0
	icon = FA_ICON_HAMBURGER // I'm very hungry. Give me the burger!
	medical_record_text = "患者的体重高于平均值."
	mob_trait = TRAIT_FAT

/datum/quirk/overweight/add(client/client_source)
	quirk_holder.add_movespeed_modifier(/datum/movespeed_modifier/overweight)

/datum/quirk/overweight/remove()
	quirk_holder.remove_movespeed_modifier(/datum/movespeed_modifier/overweight)

/datum/movespeed_modifier/overweight
	multiplicative_slowdown = 0.5 //Around that of a dufflebag, enough to be impactful but not debilitating.

/datum/mood_event/fat/New(mob/parent_mob, ...)
	. = ..()
	if(HAS_TRAIT_FROM(parent_mob, TRAIT_FAT, QUIRK_TRAIT))
		mood_change = 0 // They are probably used to it, no reason to be viscerally upset about it.
		description = "<b>我胖了.</b>"
