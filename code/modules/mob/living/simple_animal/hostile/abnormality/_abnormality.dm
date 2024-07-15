/mob/living/simple_animal/hostile/abnormality
	name = "异常实体"
	desc = "嗯?"
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	stat_attack = HARD_CRIT
	layer = LARGE_MOB_LAYER
	del_on_death = TRUE
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	move_resist = MOVE_FORCE_STRONG // They kept stealing my abnormalities
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE // Please. I beg you. Stop stealing my vending machines.
	mob_size = MOB_SIZE_HUGE // No more lockers, Whitaker
	blood_volume = BLOOD_VOLUME_NORMAL // THERE WILL BE BLOOD. SHED.
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	/// Can this abnormality spawn normally during the round?
	var/can_spawn = TRUE
	/// Reference to the datum we use
	var/datum/abnormality/datum_reference = null
	/// Separate level of fear. If null - will use threat level.
	var/fear_level = null
	/// Maximum qliphoth level, passed to datum
	var/start_qliphoth = 0
	/// Can it breach? If TRUE - ZeroQliphoth() calls BreachEffect()
	var/can_breach = FALSE
	/// List of humans that witnessed the abnormality breaching
	var/list/breach_affected = list()
	/// Copy-pasted from megafauna.dm: This allows player controlled mobs to use abilities
	var/chosen_attack = 1
	/// Attack actions, sets chosen_attack to the number in the action
	var/list/attack_action_types = list()
	/// List of ego equipment datums
	var/list/ego_list = list()
	/// EGO Gifts
	var/datum/ego_gifts/gift_type = null
	var/gift_chance = null
	var/gift_message = null
	/// Abnormality Chemistry System
	// Typepath of the abnormality's chemical.
	var/chem_type
	// Amount of abnochem produced by one harvest. One harvest is prepared per work completed.
	var/chem_yield = 15
	// Time delay between harvests. Shouldn't need to be changed in most cases, since the amount of harvests available is gated by work.
	var/chem_cooldown = 5 SECONDS
	var/chem_cooldown_timer = 0
	// Increased Abno appearance chance
	/// Assoc list, you do [path] = [probability_multiplier] for each entry
	var/list/grouped_abnos = list()
	//Abnormaltiy portrait, updated on spawn if they have one.
	var/portrait = "UNKNOWN"
	var/core_icon = ""
	var/core_enabled = TRUE

	// secret skin variables ahead

	/// Toggles if the abnormality has a secret form and can spawn naturally
	var/secret_chance = FALSE
	/// tracks if the current abnormality is in its secret form
	var/secret_abnormality = FALSE

	/// if assigned, this gift will be given instead of a normal one on a successfull gift aquisition whilst a secret skin is in effect
	var/secret_gift

	/// An icon state assigned to the abnormality in its secret form
	var/secret_icon_state
	/// An icon state assigned when an abnormality is alive
	var/secret_icon_living
	/// An icon file assigned to the abnormality in its secret form, usually should not be needed to change
	var/secret_icon_file

	/// Offset for secret skins in the X axis
	var/secret_horizontal_offset = 0
	/// Offset for secret skins in the Y axis
	var/secret_vertical_offset = 0


// Actions
/datum/action/innate/abnormality_attack
	name = "异常实体攻击"
	button_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = ""
	background_icon_state = "bg_abnormality"
	var/mob/living/simple_animal/hostile/abnormality/A
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/abnormality_attack/Destroy()
	A = null
	return ..()

/datum/action/innate/abnormality_attack/Grant(mob/living/L)
	if(istype(L, /mob/living/simple_animal/hostile/abnormality))
		A = L
		return ..()
	return FALSE

/datum/action/innate/abnormality_attack/Activate()
	A.chosen_attack = chosen_attack_num
	to_chat(A, chosen_message)

/datum/action/innate/abnormality_attack/toggle
	name = "切换攻击"
	var/toggle_message
	var/toggle_attack_num = 1
	var/button_icon_toggle_activated = ""
	var/button_icon_toggle_deactivated = ""

/datum/action/innate/abnormality_attack/toggle/Activate()
	. = ..()
	button_icon_state = button_icon_toggle_activated
	active = TRUE


/datum/action/innate/abnormality_attack/toggle/Deactivate()
	A.chosen_attack = toggle_attack_num
	to_chat(A, toggle_message)
	button_icon_state = button_icon_toggle_deactivated
	active = FALSE
