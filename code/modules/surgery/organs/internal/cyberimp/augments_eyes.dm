/obj/item/organ/internal/cyberimp/eyes
	name = "cybernetic eye implant-电子眼植入物"
	desc = "用于眼睛的植入物"
	icon_state = "eye_implant"
	implant_overlay = "eye_implant_overlay"
	slot = ORGAN_SLOT_EYES
	zone = BODY_ZONE_PRECISE_EYES
	w_class = WEIGHT_CLASS_TINY

// HUD implants
/obj/item/organ/internal/cyberimp/eyes/hud
	name = "HUD implant-HUD植入物"
	desc = "These cybernetic eyes will display a HUD over everything you see. Maybe."
	slot = ORGAN_SLOT_HUD
	actions_types = list(/datum/action/item_action/toggle_hud)
	var/HUD_type = 0
	var/HUD_trait = null
	/// Whether the HUD implant is on or off
	var/toggled_on = TRUE


/obj/item/organ/internal/cyberimp/eyes/hud/proc/toggle_hud(mob/living/carbon/eye_owner)
	if(toggled_on)
		if(HUD_type)
			var/datum/atom_hud/hud = GLOB.huds[HUD_type]
			hud.hide_from(eye_owner)
		toggled_on = FALSE
		balloon_alert(eye_owner, "hud disabled")
	else
		if(HUD_type)
			var/datum/atom_hud/hud = GLOB.huds[HUD_type]
			hud.show_to(eye_owner)
		toggled_on = TRUE
		balloon_alert(eye_owner, "hud enabled")

/obj/item/organ/internal/cyberimp/eyes/hud/Insert(mob/living/carbon/eye_owner, special = FALSE, movement_flags)
	. = ..()
	if(!.)
		return
	if(HUD_type)
		var/datum/atom_hud/hud = GLOB.huds[HUD_type]
		hud.show_to(eye_owner)
	if(HUD_trait)
		ADD_TRAIT(eye_owner, HUD_trait, ORGAN_TRAIT)
	toggled_on = TRUE

/obj/item/organ/internal/cyberimp/eyes/hud/Remove(mob/living/carbon/eye_owner, special, movement_flags)
	. = ..()
	if(HUD_type)
		var/datum/atom_hud/hud = GLOB.huds[HUD_type]
		hud.hide_from(eye_owner)
	if(HUD_trait)
		REMOVE_TRAIT(eye_owner, HUD_trait, ORGAN_TRAIT)
	toggled_on = FALSE

/obj/item/organ/internal/cyberimp/eyes/hud/medical
	name = "Medical HUD implant-医疗HUD植入物"
	desc = "这对电子眼会在你视野内的一切活物上显示医疗HUD.转动眼球来控制."
	HUD_type = DATA_HUD_MEDICAL_ADVANCED
	HUD_trait = TRAIT_MEDICAL_HUD

/obj/item/organ/internal/cyberimp/eyes/hud/security
	name = "Security HUD implant安保HUD植入物"
	desc = "这对电子眼会在你视野内的一切东西上显示安保HUD.转动眼球来控制."
	HUD_type = DATA_HUD_SECURITY_ADVANCED
	HUD_trait = TRAIT_SECURITY_HUD

/obj/item/organ/internal/cyberimp/eyes/hud/diagnostic
	name = "Diagnostic HUD implant-诊断HUD植入物"
	desc = "这对电子眼会在你视野内的一切机械上显示诊断HUD.转动眼球来控制."
	HUD_type = DATA_HUD_DIAGNOSTIC_ADVANCED

/obj/item/organ/internal/cyberimp/eyes/hud/security/syndicate
	name = "Contraband Security HUD Implant-违禁安保HUD植入物"
	desc = "赛博森工业出品的安保HUD植入物.这些不合法的电子眼植入物会在你视野内的一切东西上显示安保HUD."
	organ_flags = ORGAN_ROBOTIC | ORGAN_HIDDEN
