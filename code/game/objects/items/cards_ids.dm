/// Fallback time if none of the config entries are set for USE_LOW_LIVING_HOUR_INTERN
#define INTERN_THRESHOLD_FALLBACK_HOURS 15

/// Max time interval between projecting holopays
#define HOLOPAY_PROJECTION_INTERVAL (7 SECONDS)

/* Cards
 * Contains:
 * DATA CARD
 * ID CARD
 * FINGERPRINT CARD HOLDER
 * FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the IC data card reader
 */

/obj/item/card
	name = "识别卡"
	desc = "做卡片该做的事情."
	icon = 'icons/obj/card.dmi'
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY

	/// Cached icon that has been built for this card. Intended to be displayed in chat. Cardboards IDs and actual IDs use it.
	var/icon/cached_flat_icon

/obj/item/card/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to swipe [user.p_their()] neck with \the [src]! 看起来是在尝试自杀!"))
	return BRUTELOSS

/obj/item/card/update_overlays()
	. = ..()
	cached_flat_icon = null

/// If no cached_flat_icon exists, this proc creates it and crops it. This proc then returns the cached_flat_icon. Intended for use displaying ID card icons in chat.
/obj/item/card/proc/get_cached_flat_icon()
	if(!cached_flat_icon)
		cached_flat_icon = getFlatIcon(src)
		cached_flat_icon.Crop(ID_ICON_BORDERS)
	return cached_flat_icon

/*
 * ID CARDS
 */

/// "Retro" ID card that renders itself as the icon state with no overlays.
/obj/item/card/id
	name = "复古识别卡"
	desc = "一种卡，用于提供身份并确定空间站的通行权限."
	icon_state = "card_grey"
	worn_icon_state = "nothing"
	slot_flags = ITEM_SLOT_ID
	interaction_flags_click = FORBID_TELEKINESIS_REACH
	armor_type = /datum/armor/card_id
	resistance_flags = FIRE_PROOF | ACID_PROOF

	/// The name registered on the card (for example: Dr Bryan See)
	var/registered_name = null
	/// Linked bank account.
	var/datum/bank_account/registered_account

	/// Linked holopay.
	var/obj/structure/holopay/my_store
	/// Cooldown between projecting holopays
	COOLDOWN_DECLARE(last_holopay_projection)
	/// List of logos available for holopay customization - via font awesome 5
	var/static/list/available_logos = list("angry", "ankh", "bacon", "band-aid", "cannabis", "cat", "cocktail", "coins", "comments-dollar",
	"cross", "cut", "dog", "donate", "dna", "fist-raised", "flask", "glass-cheers", "glass-martini-alt", "hamburger", "hand-holding-usd",
	"hat-wizard", "head-side-cough-slash", "heart", "heart-broken",  "laugh-beam", "leaf", "money-check-alt", "music", "piggy-bank",
	"pizza-slice", "prescription-bottle-alt", "radiation", "robot", "smile", "skull-crossbones", "smoking", "space-shuttle", "tram",
	"trash", "user-ninja", "utensils", "wrench")
	/// Replaces the "pay whatever" functionality with a set amount when non-zero.
	var/holopay_fee = 0
	/// The holopay icon chosen by the user
	var/holopay_logo = "donate"
	/// Maximum forced fee. It's unlikely for a user to encounter this type of money, much less pay it willingly.
	var/holopay_max_fee = 5000
	/// Minimum forced fee for holopay stations. Registers as "pay what you want."
	var/holopay_min_fee = 0
	/// The holopay name chosen by the user
	var/holopay_name = "全息支付台"

	/// Registered owner's age.
	var/registered_age = 18 //SKYRAT EDIT - ORIGINAL (13)

	/// The job name registered on the card (for example: Assistant).
	var/assignment

	/// Trim datum associated with the card. Controls which job icon is displayed on the card and which accesses do not require wildcards.
	var/datum/id_trim/trim

	/// Access levels held by this card.
	var/list/access = list()

	/// List of wildcard slot names as keys with lists of wildcard data as values.
	var/list/wildcard_slots = list()

	/// Boolean value. If TRUE, the [Intern] tag gets prepended to this ID card when the label is updated.
	var/is_intern = FALSE

/datum/armor/card_id
	fire = 100
	acid = 100

/obj/item/card/id/apply_fantasy_bonuses(bonus)
	. = ..()
	if(bonus >= 15)
		add_access(SSid_access.get_region_access_list(list(REGION_ALL_GLOBAL)), mode = FORCE_ADD_ALL)
	else if(bonus >= 10)
		add_access(SSid_access.get_region_access_list(list(REGION_ALL_STATION)), mode = FORCE_ADD_ALL)
	else if(bonus <= -10)
		clear_access()

/obj/item/card/id/Initialize(mapload)
	. = ..()

	var/datum/bank_account/blank_bank_account = new("Unassigned", SSjob.GetJobType(/datum/job/unassigned), player_account = FALSE)
	registered_account = blank_bank_account
	registered_account.replaceable = TRUE

	// Applying the trim updates the label and icon, so don't do this twice.
	if(ispath(trim))
		SSid_access.apply_trim_to_card(src, trim)
	else
		update_label()
		update_icon()

	register_context()

	RegisterSignal(src, COMSIG_ATOM_UPDATED_ICON, PROC_REF(update_in_wallet))
	if(prob(1))
		ADD_TRAIT(src, TRAIT_TASTEFULLY_THICK_ID_CARD, ROUNDSTART_TRAIT)

/obj/item/card/id/Destroy()
	if (registered_account)
		registered_account.bank_cards -= src
	if (my_store)
		QDEL_NULL(my_store)
	return ..()

/obj/item/card/id/get_id_examine_strings(mob/user)
	. = ..()
	. += list("[icon2html(get_cached_flat_icon(), user, extra_classes = "bigicon")]")

/obj/item/card/id/get_examine_string(mob/user, thats = FALSE)
	return "[icon2html(get_cached_flat_icon(), user)] [thats? "那是 ":""][get_examine_name(user)]"

/**
 * Helper proc, checks whether the ID card can hold any given set of wildcards.
 *
 * Returns TRUE if the card can hold the wildcards, FALSE otherwise.
 * Arguments:
 * * wildcard_list - List of accesses to check.
 * * try_wildcard - If not null, will attempt to add wildcards for this wildcard specifically and will return FALSE if the card cannot hold all wildcards in this slot.
 */
/obj/item/card/id/proc/can_add_wildcards(list/wildcard_list, try_wildcard = null)
	if(!length(wildcard_list))
		return TRUE

	var/list/new_wildcard_limits = list()

	for(var/flag_name in wildcard_slots)
		if(try_wildcard && !(flag_name == try_wildcard))
			continue
		var/list/wildcard_info = wildcard_slots[flag_name]
		new_wildcard_limits[flag_name] = wildcard_info["limit"] - length(wildcard_info["usage"])

	if(!length(new_wildcard_limits))
		return FALSE

	var/wildcard_allocated
	for(var/wildcard in wildcard_list)
		var/wildcard_flag = SSid_access.get_access_flag(wildcard)
		wildcard_allocated = FALSE
		for(var/flag_name in new_wildcard_limits)
			var/limit_flags = SSid_access.wildcard_flags_by_wildcard[flag_name]
			if(!(wildcard_flag & limit_flags))
				continue
			// Negative limits mean infinite slots. Positive limits mean limited slots still available. 0 slots means no slots.
			if(new_wildcard_limits[flag_name] == 0)
				continue
			new_wildcard_limits[flag_name]--
			wildcard_allocated = TRUE
			break
		if(!wildcard_allocated)
			return FALSE

	return TRUE

/**
 * Attempts to add the given wildcards to the ID card.
 *
 * Arguments:
 * * wildcard_list - List of accesses to add.
 * * try_wildcard - If not null, will attempt to add all wildcards to this wildcard slot only.
 * * mode - The method to use when adding wildcards. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/add_wildcards(list/wildcard_list, try_wildcard = null, mode = ERROR_ON_FAIL)
	var/wildcard_allocated
	// Iterate through each wildcard in our list. Get its access flag. Then iterate over wildcard slots and try to fit it in.
	for(var/wildcard in wildcard_list)
		var/wildcard_flag = SSid_access.get_access_flag(wildcard)
		wildcard_allocated = FALSE
		for(var/flag_name in wildcard_slots)
			if(flag_name == WILDCARD_NAME_FORCED)
				continue

			if(try_wildcard && !(flag_name == try_wildcard))
				continue

			var/limit_flags = SSid_access.wildcard_flags_by_wildcard[flag_name]

			if(!(wildcard_flag & limit_flags))
				continue

			var/list/wildcard_info = wildcard_slots[flag_name]
			var/wildcard_limit = wildcard_info["limit"]
			var/list/wildcard_usage = wildcard_info["usage"]

			var/wildcard_count = wildcard_limit - length(wildcard_usage)

			// Negative limits mean infinite slots. Positive limits mean limited slots still available. 0 slots means no slots.
			if(wildcard_count == 0)
				continue

			wildcard_usage |= wildcard
			access |= wildcard
			wildcard_allocated = TRUE
			break
		// Fallback for if we couldn't allocate the wildcard for some reason.
		if(!wildcard_allocated)
			if(mode == ERROR_ON_FAIL)
				CRASH("Wildcard ([wildcard]) could not be added to [src].")

			if(mode == TRY_ADD_ALL)
				continue

			// If the card has no info for historic forced wildcards, create the list.
			if(!wildcard_slots[WILDCARD_NAME_FORCED])
				wildcard_slots[WILDCARD_NAME_FORCED] = list(limit = 0, usage = list())

			var/list/wildcard_info = wildcard_slots[WILDCARD_NAME_FORCED]
			var/list/wildcard_usage = wildcard_info["usage"]
			wildcard_usage |= wildcard
			access |= wildcard
			wildcard_info["limit"] = length(wildcard_usage)

/**
 * Removes wildcards from the ID card.
 *
 * Arguments:
 * * wildcard_list - List of accesses to remove.
 */
/obj/item/card/id/proc/remove_wildcards(list/wildcard_list)
	var/wildcard_removed
	// Iterate through each wildcard in our list. Get its access flag. Then iterate over wildcard slots and try to remove it.
	for(var/wildcard in wildcard_list)
		wildcard_removed = FALSE
		for(var/flag_name in wildcard_slots)
			if(flag_name == WILDCARD_NAME_FORCED)
				continue

			var/list/wildcard_info = wildcard_slots[flag_name]
			var/wildcard_usage = wildcard_info["usage"]

			if(!(wildcard in wildcard_usage))
				continue

			wildcard_usage -= wildcard
			access -= wildcard
			wildcard_removed = TRUE
			break
		// Fallback to see if this was a force-added wildcard.
		if(!wildcard_removed)
			// If the card has no info for historic forced wildcards, that's an error state.
			if(!wildcard_slots[WILDCARD_NAME_FORCED])
				stack_trace("Wildcard ([wildcard]) could not be removed from [src]. This card has no forced wildcard data and the wildcard is not in this card's wildcard lists.")

			var/list/wildcard_info = wildcard_slots[WILDCARD_NAME_FORCED]
			var/wildcard_usage = wildcard_info["usage"]

			if(!(wildcard in wildcard_usage))
				stack_trace("Wildcard ([wildcard]) could not be removed from [src]. This access is not a wildcard on this card.")

			wildcard_usage -= wildcard
			access -= wildcard
			wildcard_info["limit"] = length(wildcard_usage)

			if(!wildcard_info["limit"])
				wildcard_slots -= WILDCARD_NAME_FORCED

/**
 * Attempts to add the given accesses to the ID card as non-wildcards.
 *
 * Depending on the mode, may add accesses as wildcards or error if it can't add them as non-wildcards.
 * Arguments:
 * * add_accesses - List of accesses to check.
 * * try_wildcard - If not null, will attempt to add all accesses that require wildcard slots to this wildcard slot only.
 * * mode - The method to use when adding accesses. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/add_access(list/add_accesses, try_wildcard = null, mode = ERROR_ON_FAIL)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	build_access_lists(add_accesses, normal_access, wildcard_access)

	// Check if we can add the wildcards.
	if(mode == ERROR_ON_FAIL)
		if(!can_add_wildcards(wildcard_access, try_wildcard))
			CRASH("Cannot add wildcards from \[[add_accesses.Join(",")]\] to [src]")

	// All clear to add the accesses.
	access |= normal_access
	if(mode != TRY_ADD_ALL_NO_WILDCARD)
		add_wildcards(wildcard_access, try_wildcard, mode = mode)

	return TRUE

/**
 * Removes the given accesses from the ID Card.
 *
 * Will remove the wildcards if the accesses given are on the card as wildcard accesses.
 * Arguments:
 * * rem_accesses - List of accesses to remove.
 */
/obj/item/card/id/proc/remove_access(list/rem_accesses)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	build_access_lists(rem_accesses, normal_access, wildcard_access)

	access -= normal_access
	remove_wildcards(wildcard_access)

/**
 * Attempts to set the card's accesses to the given accesses, clearing all accesses not in the given list.
 *
 * Depending on the mode, may add accesses as wildcards or error if it can't add them as non-wildcards.
 * Arguments:
 * * new_access_list - List of all accesses that this card should hold exclusively.
 * * mode - The method to use when setting accesses. See define for ERROR_ON_FAIL
 */
/obj/item/card/id/proc/set_access(list/new_access_list, mode = ERROR_ON_FAIL)
	var/list/wildcard_access = list()
	var/list/normal_access = list()

	if(length(new_access_list))
		build_access_lists(new_access_list, normal_access, wildcard_access)

	// Check if we can add the wildcards.
	if(mode == ERROR_ON_FAIL)
		if(!can_add_wildcards(wildcard_access))
			CRASH("Cannot add wildcards from \[[new_access_list.Join(",")]\] to [src]")

	clear_access()

	access = normal_access.Copy()

	if(mode != TRY_ADD_ALL_NO_WILDCARD)
		add_wildcards(wildcard_access, mode = mode)

	return TRUE

/// Clears all accesses from the ID card - both wildcard and normal.
/obj/item/card/id/proc/clear_access()
	// Go through the wildcards and reset them.
	for(var/flag_name in wildcard_slots)
		var/list/wildcard_info = wildcard_slots[flag_name]
		var/list/wildcard_usage = wildcard_info["usage"]
		wildcard_usage.Cut()

	// Hard reset access
	access.Cut()

/// Clears the economy account from the ID card.
/obj/item/card/id/proc/clear_account()
	registered_account = null


/**
 * Helper proc. Creates access lists for the access procs.
 *
 * Takes the accesses list and compares it with the trim. Any basic accesses that match the trim are
 * added to basic_access_list and the rest are added to wildcard_access_list.

 * This proc directly modifies the lists passed in as args. It expects these lists to be instantiated.
 * There is no return value.
 * Arguments:
 * * accesses - List of accesses you want to stort into basic_access_list and wildcard_access_list. Should not be null.
 * * basic_access_list - Mandatory argument. The proc modifies the list passed in this argument and adds accesses the trim supports to it.
 * * wildcard_access_list - Mandatory argument. The proc modifies the list passed in this argument and adds accesses the trim does not support to it.
 */
/obj/item/card/id/proc/build_access_lists(list/accesses, list/basic_access_list, list/wildcard_access_list)
	if(!length(accesses) || isnull(basic_access_list) || isnull(wildcard_access_list))
		CRASH("Invalid parameters passed to build_access_lists")

	var/list/trim_accesses = trim?.access

	// Populate the lists.
	for(var/new_access in accesses)
		if(new_access in trim_accesses)
			basic_access_list |= new_access
			continue

		wildcard_access_list |= new_access

/// Helper proc that determines if a card can be used in certain types of payment transactions.
/obj/item/card/id/proc/can_be_used_in_payment(mob/living/user)
	if(QDELETED(src) || isnull(registered_account?.account_job) || !isliving(user))
		return FALSE

	return TRUE

/obj/item/card/id/attack_self(mob/user)
	if(Adjacent(user))
		var/minor
		if(registered_name && registered_age && registered_age < AGE_MINOR)
			minor = " <b>[registered_age]</b>" //SKYRAT EDIT CHANGE
		user.visible_message(span_notice("[user] shows you: [icon2html(src, viewers(user))] [src.name][minor]."), span_notice("You show \the [src.name][minor]."))
	add_fingerprint(user)

/obj/item/card/id/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!check_allowed_items(interacting_with) || !isfloorturf(interacting_with))
		return NONE
	try_project_paystand(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/card/id/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	try_project_paystand(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/card/id/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	context[SCREENTIP_CONTEXT_LMB] = "Show ID"
	context[SCREENTIP_CONTEXT_RMB] = "Project pay stand"
	if(isnull(registered_account) || registered_account.replaceable) //Same check we use when we check if we can assign an account
		context[SCREENTIP_CONTEXT_ALT_RMB] = "Assign account"
	else if(registered_account.account_balance > 0)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Withdraw credits"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/card/id/proc/try_project_paystand(mob/user, turf/target)
	if(!COOLDOWN_FINISHED(src, last_holopay_projection))
		balloon_alert(user, "still recharging")
		return
	if(!can_be_used_in_payment(user))
		balloon_alert(user, "no account!")
		to_chat(user, span_warning("You need a valid bank account to do this."))
		return
	/// Determines where the holopay will be placed based on tile contents
	var/turf/projection
	var/turf/step_ahead = get_step(user, user.dir)
	var/turf/user_loc = user.loc
	if(target && can_proj_holopay(target))
		projection = target
	else if(can_proj_holopay(step_ahead))
		projection = step_ahead
	else if(can_proj_holopay(user_loc))
		projection = user_loc
	if(!projection)
		balloon_alert(user, "no space")
		to_chat(user, span_warning("You need to be standing on or near an open tile to do this."))
		return
	/// Success: Valid tile for holopay placement
	if(my_store)
		my_store.dissipate()
	var/obj/structure/holopay/new_store = new(projection)
	if(new_store?.assign_card(projection, src))
		COOLDOWN_START(src, last_holopay_projection, HOLOPAY_PROJECTION_INTERVAL)
		playsound(projection, 'sound/effects/empulse.ogg', 40, TRUE)
		my_store = new_store

/**
 * Determines whether a new holopay can be placed on the given turf.
 * Checks if there are dense contents, too many contents, or another
 * holopay already exists on the turf.
 *
 * Arguments:
 * * turf/target - The target turf to be checked for dense contents
 * Returns:
 * * TRUE if the target is a valid holopay location, FALSE otherwise.
 */
/obj/item/card/id/proc/can_proj_holopay(turf/target)
	if(!isfloorturf(target))
		return FALSE
	if(target.density)
		return FALSE
	if(length(target.contents) > 5)
		return FALSE
	for(var/obj/checked_obj in target.contents)
		if(checked_obj.density)
			return FALSE
		if(istype(checked_obj, /obj/structure/holopay))
			return FALSE
	return TRUE

/**
 * Setter for the shop logo on linked holopays
 *
 * Arguments:
 * * new_logo - The new logo to be set.
 */
/obj/item/card/id/proc/set_holopay_logo(new_logo)
	if(!available_logos.Find(new_logo))
		CRASH("User input a holopay shop logo that didn't exist.")
	holopay_logo = new_logo

/**
 * Setter for changing the force fee on a holopay.
 *
 * Arguments:
 * * new_fee - The new fee to be set.
 */
/obj/item/card/id/proc/set_holopay_fee(new_fee)
	if(!isnum(new_fee))
		CRASH("User input a non number into the holopay fee field.")
	if(new_fee < holopay_min_fee || new_fee > holopay_max_fee)
		CRASH("User input a number outside of the valid range into the holopay fee field.")
	holopay_fee = new_fee

/**
 * Setter for changing the holopay name.
 *
 * Arguments:
 * * new_name - The new name to be set.
 */
/obj/item/card/id/proc/set_holopay_name(name)
	if(length(name) < 3 || length(name) > MAX_NAME_LEN)
		to_chat(usr, span_warning("Must be between 3 - 42 characters."))
	else
		holopay_name = html_encode(trim(name, MAX_NAME_LEN))


/obj/item/card/id/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, assignment), NAMEOF(src, registered_name), NAMEOF(src, registered_age))
				update_label()
				update_icon()
			if(NAMEOF(src, trim))
				if(ispath(trim))
					SSid_access.apply_trim_to_card(src, trim)

/obj/item/card/id/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/rupee))
		to_chat(user, span_warning("Your ID smartly rejects the strange shard of glass. Who knew, apparently it's not ACTUALLY valuable!"))
		return ITEM_INTERACT_BLOCKING
	else if(iscash(tool))
		return insert_money(tool, user) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	else if(istype(tool, /obj/item/storage/bag/money))
		var/obj/item/storage/bag/money/money_bag = tool
		var/list/money_contained = money_bag.contents
		var/money_added = mass_insert_money(money_contained, user)
		if(!money_added)
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice("You stuff the contents into the card! They disappear in a puff of bluespace smoke, adding [money_added] worth of credits to the linked account."))
		return ITEM_INTERACT_SUCCESS
	/// SKYRAT EDIT BEGINS - Trim Tokens - Proc defined in modular_skyrat/modules/trim_tokens/code/cards_id.dm
	else if(istype(tool, /obj/item/trim_token))
		apply_token(tool, user)
		return
	/// SKYRAT EDIT ENDS
	return NONE

/**
 * Insert credits or coins into the ID card and add their value to the associated bank account.
 *
 * Returns TRUE if the money was successfully inserted, FALSE otherwise.
 * Arguments:
 * money - The item to attempt to convert to credits and insert into the card.
 * user - The user inserting the item.
 * physical_currency - Boolean, whether this is a physical currency such as a coin and not a holochip.
 */
/obj/item/card/id/proc/insert_money(obj/item/money, mob/user)
	var/physical_currency
	if(istype(money, /obj/item/stack/spacecash) || istype(money, /obj/item/coin))
		physical_currency = TRUE

	if(!registered_account)
		to_chat(user, span_warning("[src] doesn't have a linked account to deposit [money] into!"))
		return FALSE
	var/cash_money = money.get_item_credit_value()
	if(!cash_money)
		to_chat(user, span_warning("[money] doesn't seem to be worth anything!"))
		return FALSE
	registered_account.adjust_money(cash_money, "System: Deposit")
	SSblackbox.record_feedback("amount", "credits_inserted", cash_money)
	log_econ("[cash_money] credits were inserted into [src] owned by [src.registered_name]")
	if(physical_currency)
		to_chat(user, span_notice("You stuff [money] into [src]. It disappears in a small puff of bluespace smoke, adding [cash_money] credits to the linked account."))
	else
		to_chat(user, span_notice("You insert [money] into [src], adding [cash_money] credits to the linked account."))

	to_chat(user, span_notice("The linked account now reports a balance of [registered_account.account_balance] cr."))
	qdel(money)
	return TRUE

/**
 * Insert multiple money or money-equivalent items at once.
 *
 * Arguments:
 * money - List of items to attempt to convert to credits and insert into the card.
 * user - The user inserting the items.
 */
/obj/item/card/id/proc/mass_insert_money(list/money, mob/user)
	if(!registered_account)
		to_chat(user, span_warning("[src] doesn't have a linked account to deposit into!"))
		return FALSE

	if (!money || !length(money))
		return FALSE

	var/total = 0

	for (var/obj/item/physical_money in money)
		total += physical_money.get_item_credit_value()
		CHECK_TICK

	registered_account.adjust_money(total, "System: Deposit")
	SSblackbox.record_feedback("amount", "credits_inserted", total)
	log_econ("[total] credits were inserted into [src] owned by [src.registered_name]")
	QDEL_LIST(money)

	return total

/// Helper proc. Can the user alt-click the ID?
/obj/item/card/id/proc/alt_click_can_use_id(mob/living/user)
	if(!isliving(user))
		return FALSE
	return TRUE

/// Attempts to set a new bank account on the ID card.
/obj/item/card/id/proc/set_new_account(mob/living/user)
	. = FALSE
	var/datum/bank_account/old_account = registered_account
	if(loc != user)
		to_chat(user, span_warning("You must be holding the ID to continue!"))
		return FALSE
	var/list/user_memories = user.mind.memories
	var/datum/memory/key/account/user_key = user_memories[/datum/memory/key/account]
	var/default_account = (istype(user_key) && user_key.remembered_id) || 11111
	var/new_bank_id = tgui_input_number(user, "Enter the account ID to associate with this card.", "Link Bank Account", default_account, 999999, 111111)
	if(!new_bank_id || QDELETED(user) || QDELETED(src) || issilicon(user) || !alt_click_can_use_id(user) || loc != user)
		return FALSE
	if(registered_account?.account_id == new_bank_id)
		to_chat(user, span_warning("The account ID was already assigned to this card."))
		return FALSE
	var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[new_bank_id]"]
	if(isnull(account))
		to_chat(user, span_warning("The account ID number provided is invalid."))
		return FALSE
	if(old_account)
		old_account.bank_cards -= src
		account.account_balance += old_account.account_balance
	account.bank_cards += src
	registered_account = account
	to_chat(user, span_notice("The provided account has been linked to this ID card. It contains [account.account_balance] credits."))
	return TRUE

/obj/item/card/id/click_alt(mob/living/user)
	if(!alt_click_can_use_id(user))
		return NONE
	if(registered_account.account_debt)
		var/choice = tgui_alert(user, "Choose An Action", "Bank Account", list("Withdraw", "Pay Debt"))
		if(!choice || QDELETED(user) || QDELETED(src) || !alt_click_can_use_id(user) || loc != user)
			return CLICK_ACTION_BLOCKING
		if(choice == "Pay Debt")
			pay_debt(user)
			return CLICK_ACTION_SUCCESS
	if (registered_account.being_dumped)
		registered_account.bank_card_talk(span_warning("内部服务器错误"), TRUE)
		return CLICK_ACTION_SUCCESS
	if(loc != user)
		to_chat(user, span_warning("You must be holding the ID to continue!"))
		return CLICK_ACTION_BLOCKING
	if(registered_account.replaceable && !registered_account.account_balance)
		var/choice = tgui_alert(user, "This card's account is unassigned. Would you like to link a bank account?", "Bank Account", list("Link Account", "Leave Unassigned"))
		if(!choice || QDELETED(user) || QDELETED(src) || !alt_click_can_use_id(user) || loc != user)
			return CLICK_ACTION_BLOCKING
		if(choice == "Link Account")
			set_new_account(user)
			return CLICK_ACTION_SUCCESS
	var/amount_to_remove = tgui_input_number(user, "How much do you want to withdraw? (Max: [registered_account.account_balance] cr)", "Withdraw Funds", max_value = registered_account.account_balance)
	if(!amount_to_remove || QDELETED(user) || QDELETED(src) || issilicon(user) || loc != user)
		return CLICK_ACTION_BLOCKING
	if(!alt_click_can_use_id(user))
		return CLICK_ACTION_BLOCKING
	if(registered_account.adjust_money(-amount_to_remove, "System: Withdrawal"))
		var/obj/item/holochip/holochip = new (user.drop_location(), amount_to_remove)
		user.put_in_hands(holochip)
		to_chat(user, span_notice("You withdraw [amount_to_remove] credits into a holochip."))
		SSblackbox.record_feedback("amount", "credits_removed", amount_to_remove)
		log_econ("[amount_to_remove] credits were removed from [src] owned by [src.registered_name]")
		return CLICK_ACTION_SUCCESS
	else
		var/difference = amount_to_remove - registered_account.account_balance
		registered_account.bank_card_talk(span_warning("ERROR: The linked account requires [difference] more credit\s to perform that withdrawal."), TRUE)
		return CLICK_ACTION_BLOCKING

/obj/item/card/id/click_alt_secondary(mob/user)
	if(!alt_click_can_use_id(user))
		return
	if(!registered_account || registered_account.replaceable)
		set_new_account(user)

/obj/item/card/id/proc/pay_debt(user)
	var/amount_to_pay = tgui_input_number(user, "How much do you want to pay? (Max: [registered_account.account_balance] cr)", "Debt Payment", max_value = min(registered_account.account_balance, registered_account.account_debt))
	if(!amount_to_pay || QDELETED(src) || loc != user || !alt_click_can_use_id(user))
		return
	var/prev_debt = registered_account.account_debt
	var/amount_paid = registered_account.pay_debt(amount_to_pay)
	if(amount_paid)
		var/message = span_notice("You pay [amount_to_pay] credits of a [prev_debt] cr debt. [registered_account.account_debt] cr to go.")
		if(!registered_account.account_debt)
			message = span_nicegreen("You pay the last [amount_to_pay] credits of your debt, extinguishing it. Congratulations!")
		to_chat(user, message)

/obj/item/card/id/examine(mob/user)
	. = ..()
	if(!user.can_read(src))
		return

	if(registered_account && !isnull(registered_account.account_id))
		. += "The account linked to the ID belongs to '[registered_account.account_holder]' and reports a balance of [registered_account.account_balance] cr."
		if(ACCESS_COMMAND in access)
			var/datum/bank_account/linked_dept = SSeconomy.get_dep_account(registered_account.account_job.paycheck_department)
			. += "The [linked_dept.account_holder] linked to the ID reports a balance of [linked_dept.account_balance] cr."
	else
		. += span_notice("Alt-Right-Click the ID to set the linked bank account.")

	if(HAS_TRAIT(user, TRAIT_ID_APPRAISER))
		. += HAS_TRAIT(src, TRAIT_JOB_FIRST_ID_CARD) ? span_boldnotice("Hmm... yes, this ID was issued from Central Command!") : span_boldnotice("This ID was created in this sector, not by Central Command.")
		if(HAS_TRAIT(src, TRAIT_TASTEFULLY_THICK_ID_CARD) && (user.is_holding(src) || (user.CanReach(src) && user.put_in_hands(src, ignore_animation = FALSE))))
			ADD_TRAIT(src, TRAIT_NODROP, "psycho")
			. += span_hypnophrase("Look at that subtle coloring... The tasteful thickness of it. Oh my God, it even has a watermark...")
			var/sound/slowbeat = sound('sound/health/slowbeat.ogg', repeat = TRUE)
			user.playsound_local(get_turf(src), slowbeat, 40, 0, channel = CHANNEL_HEARTBEAT, use_reverb = FALSE)
			if(isliving(user))
				var/mob/living/living_user = user
				living_user.adjust_jitter(10 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(drop_card), user), 10 SECONDS)
	. += span_notice("<i>There's more information below, you can look again to take a closer look...</i>")

/obj/item/card/id/proc/drop_card(mob/user)
	user.stop_sound_channel(CHANNEL_HEARTBEAT)
	REMOVE_TRAIT(src, TRAIT_NODROP, "psycho")
	if(user.is_holding(src))
		user.dropItemToGround(src)
	for(var/mob/living/carbon/human/viewing_mob in viewers(user, 2))
		if(viewing_mob.stat || viewing_mob == user)
			continue
		viewing_mob.say("Is something wrong? [user.first_name()]... you're sweating.", forced = "psycho")
		break

/obj/item/card/id/examine_more(mob/user)
	. = ..()
	if(!user.can_read(src))
		return

	. += span_notice("<i>You examine [src] closer, and note the following...</i>")

	if(registered_age)
		. += "The card indicates that the holder is [registered_age] years old. [(registered_age < AGE_MINOR) ? "There's a holographic stripe that reads <b>[span_danger("'MINOR: DO NOT SERVE ALCOHOL OR TOBACCO'")]</b> along the bottom of the card." : ""]"
	if(registered_account)
		if(registered_account.mining_points)
			. += "There's [registered_account.mining_points] mining point\s loaded onto the card's bank account."
		. += "The account linked to the ID belongs to '[registered_account.account_holder]' and reports a balance of [registered_account.account_balance] cr."
		if(registered_account.account_debt)
			. += span_warning("The account is currently indebted for [registered_account.account_debt] cr. [100*DEBT_COLLECTION_COEFF]% of all earnings will go towards extinguishing it.")
		if(registered_account.account_job)
			var/datum/bank_account/D = SSeconomy.get_dep_account(registered_account.account_job.paycheck_department)
			if(D)
				. += "The [D.account_holder] reports a balance of [D.account_balance] cr."
		. += span_info("Alt-Click the ID to pull money from the linked account in the form of holochips.")
		. += span_info("You can insert credits into the linked account by pressing holochips, cash, or coins against the ID.")
		if(registered_account.replaceable)
			. += span_info("Alt-Right-Click the ID to change the linked bank account.")
		if(registered_account.civilian_bounty)
			. += "<span class='info'><b>There is an active civilian bounty.</b>"
			. += span_info("<i>[registered_account.bounty_text()]</i>")
			. += span_info("Quantity: [registered_account.bounty_num()]")
			. += span_info("Reward: [registered_account.bounty_value()]")
		if(registered_account.account_holder == user.real_name)
			. += span_boldnotice("If you lose this ID card, you can reclaim your account by Alt-Clicking a blank ID card while holding it and entering your account ID number.")
	else
		. += span_info("There is no registered account linked to this card. Alt-Click to add one.")

	return .

/obj/item/card/id/GetAccess()
	return access.Copy()

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/RemoveID()
	return src

/// Called on COMSIG_ATOM_UPDATED_ICON. Updates the visuals of the wallet this card is in.
/obj/item/card/id/proc/update_in_wallet()
	SIGNAL_HANDLER

	if(istype(loc, /obj/item/storage/wallet))
		var/obj/item/storage/wallet/powergaming = loc
		if(powergaming.front_id == src)
			powergaming.update_label()
			powergaming.update_appearance()

/// Updates the name based on the card's vars and state.
/obj/item/card/id/proc/update_label()
	var/name_string = registered_name ? "[registered_name]'s ID Card" : initial(name)
	var/assignment_string

	if(is_intern)
		if(assignment)
			assignment_string = trim?.intern_alt_name || "Intern [assignment]"
		else
			assignment_string = "Intern"
	else
		assignment_string = assignment

	name = "[name_string] ([assignment_string])"

/// Returns the trim assignment name.
/obj/item/card/id/proc/get_trim_assignment()
	return trim?.assignment || assignment

/// Returns the trim sechud icon state.
/obj/item/card/id/proc/get_trim_sechud_icon_state()
	return trim?.sechud_icon_state || SECHUD_UNKNOWN

/obj/item/card/id/away
	name = "一张完全通用的识别卡"
	desc = "一张完全通用的身份证，还能加点内容上去."
	trim = /datum/id_trim/away
	icon_state = "retro"
	registered_age = null

/obj/item/card/id/away/hotel
	name = "员工ID卡"
	desc = "一个用来进入酒店大门的员工ID卡."
	trim = /datum/id_trim/away/hotel

/obj/item/card/id/away/hotel/security
	name = "安全官ID卡"
	trim = /datum/id_trim/away/hotel/security

/obj/item/card/id/away/old
	name = "一张完全通用的识别卡"
	desc = "一张完全通用的身份证，还能加点内容上去."

/obj/item/card/id/away/old/sec
	name = "查理站安全官ID卡"
	desc = "一张属于查理站的识别卡. 你可以辨认出身份 \"安全官\"."
	trim = /datum/id_trim/away/old/sec

/obj/item/card/id/away/old/sci
	name = "查理站科学家ID卡"
	desc = "一张属于查理站的识别卡. 你可以辨认出身份 \"科学家\"."
	trim = /datum/id_trim/away/old/sci

/obj/item/card/id/away/old/eng
	name = "查理站工程师ID卡"
	desc = "一张属于查理站的识别卡. 你可以辨认出身份 \"工程师\"."
	trim = /datum/id_trim/away/old/eng

/obj/item/card/id/away/old/equipment
	name = "工程装备权限卡"
	desc = "一种特殊的身份证，允许访问工程装备."
	trim = /datum/id_trim/away/old/equipment

/obj/item/card/id/away/old/robo
	name = "德尔塔站机械学家ID卡"
	desc = "一张可以访问机器人维护协议的ID卡."
	trim = /datum/id_trim/away/old/robo

/obj/item/card/id/away/deep_storage //deepstorage.dmm space ruin
	name = "地堡访问ID卡"

/obj/item/card/id/departmental_budget
	name = "部门卡 (故障)"
	desc = "提供部门预算."
	icon_state = "budgetcard"
	var/department_ID = ACCOUNT_CIV
	var/department_name = ACCOUNT_CIV_NAME
	registered_age = null

/obj/item/card/id/departmental_budget/Initialize(mapload)
	. = ..()
	var/datum/bank_account/B = SSeconomy.get_dep_account(department_ID)
	if(B)
		registered_account = B
		if(!B.bank_cards.Find(src))
			B.bank_cards += src
		name = "部门卡 ([department_name])"
		desc = "提供[department_name]的访问权限."
	SSeconomy.dep_cards += src

/obj/item/card/id/departmental_budget/Destroy()
	SSeconomy.dep_cards -= src
	return ..()

/obj/item/card/id/departmental_budget/update_label()
	return

/obj/item/card/id/departmental_budget/car
	department_ID = ACCOUNT_CAR
	department_name = ACCOUNT_CAR_NAME
	icon_state = "car_budget" //saving up for a new tesla

/obj/item/card/id/departmental_budget/click_alt(mob/living/user)
	registered_account.bank_card_talk(span_warning("Withdrawing is not compatible with this card design."), TRUE) //prevents the vault bank machine being useless and putting money from the budget to your card to go over personal crates
	return CLICK_ACTION_BLOCKING

/obj/item/card/id/advanced
	name = "识别卡"
	desc = "这是一张用于在整个站点内提供身份验证并确定访问权限的卡片，它集成了数字显示屏和先进的微芯片."
	icon_state = "card_grey"

	wildcard_slots = WILDCARD_LIMIT_GREY
	flags_1 = UNPAINTABLE_1

	/// An overlay icon state for when the card is assigned to a name. Usually manifests itself as a little scribble to the right of the job icon.
	var/assigned_icon_state = "assigned"

	/// If this is set, will manually override the icon file for the trim. Intended for admins to VV edit and chameleon ID cards.
	var/trim_icon_override
	/// If this is set, will manually override the icon state for the trim. Intended for admins to VV edit and chameleon ID cards.
	var/trim_state_override
	/// If this is set, will manually override the department color for this trim. Intended for admins to VV edit and chameleon ID cards.
	var/department_color_override
	/// If this is set, will manually override the department icon state for the trim. Intended for admins to VV edit and chameleon ID cards.
	var/department_state_override
	/// If this is set, will manually override the subdepartment color for this trim. Intended for admins to VV edit and chameleon ID cards.
	var/subdepartment_color_override
	/// If this is set, will manually override the trim's assignmment as it appears in the crew monitor and elsewhere. Intended for admins to VV edit and chameleon ID cards.
	var/trim_assignment_override
	/// If this is set, will manually override the trim shown for SecHUDs. Intended for admins to VV edit and chameleon ID cards.
	var/sechud_icon_state_override = null

/obj/item/card/id/advanced/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(update_intern_status))
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(remove_intern_status))

/obj/item/card/id/advanced/Destroy()
	UnregisterSignal(src, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

	return ..()

/obj/item/card/id/advanced/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(.)
		return .

	if(istype(tool, /obj/item/toy/crayon))
		return recolor_id(user, tool)

/obj/item/card/id/advanced/proc/recolor_id(mob/living/user, obj/item/toy/crayon/our_crayon)
	if(our_crayon.is_capped)
		balloon_alert(user, "take the cap off first!")
		return ITEM_INTERACT_BLOCKING
	var/choice = tgui_alert(usr, "重涂部门还是子部门?", "重涂ID...", list("部门", "子部门"))
	if(isnull(choice) \
		|| QDELETED(user) \
		|| QDELETED(src) \
		|| QDELETED(our_crayon) \
		|| !usr.can_perform_action(src, ALLOW_RESTING) \
		|| !usr.can_perform_action(our_crayon, ALLOW_RESTING) \
	)
		return ITEM_INTERACT_BLOCKING

	switch(choice)
		if("Department")
			if(!do_after(user, 2 SECONDS))
				return ITEM_INTERACT_BLOCKING
			department_color_override = our_crayon.paint_color
			balloon_alert(user, "recolored")
		if("Subdepartment")
			if(!do_after(user, 1 SECONDS))
				return ITEM_INTERACT_BLOCKING
			subdepartment_color_override = our_crayon.paint_color
			balloon_alert(user, "recolored")
	update_icon()
	return ITEM_INTERACT_SUCCESS

/obj/item/card/id/advanced/proc/update_intern_status(datum/source, mob/user, slot)
	SIGNAL_HANDLER

	if(!user?.client)
		return
	if(!CONFIG_GET(flag/use_exp_tracking))
		return
	if(!CONFIG_GET(flag/use_low_living_hour_intern))
		return
	if(!SSdbcore.Connect())
		return

	var/intern_threshold = (CONFIG_GET(number/use_low_living_hour_intern_hours) * 60) || (CONFIG_GET(number/use_exp_restrictions_heads_hours) * 60) || INTERN_THRESHOLD_FALLBACK_HOURS * 60
	var/playtime = user.client.get_exp_living(pure_numeric = TRUE)

	if((intern_threshold >= playtime) && (user.mind?.assigned_role.job_flags & JOB_CAN_BE_INTERN))
		is_intern = TRUE
		update_label()
		return

	if(!is_intern)
		return

	is_intern = FALSE
	update_label()

/obj/item/card/id/advanced/proc/remove_intern_status(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!is_intern)
		return

	is_intern = FALSE
	update_label()

/obj/item/card/id/advanced/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()

	//Old loc
	if(istype(old_loc, /obj/item/storage/wallet))
		UnregisterSignal(old_loc, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

	if(istype(old_loc, /obj/item/modular_computer))
		UnregisterSignal(old_loc, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

	//New loc
	if(istype(loc, /obj/item/storage/wallet))
		RegisterSignal(loc, COMSIG_ITEM_EQUIPPED, PROC_REF(update_intern_status))
		RegisterSignal(loc, COMSIG_ITEM_DROPPED, PROC_REF(remove_intern_status))

	if(istype(loc, /obj/item/modular_computer))
		RegisterSignal(loc, COMSIG_ITEM_EQUIPPED, PROC_REF(update_intern_status))
		RegisterSignal(loc, COMSIG_ITEM_DROPPED, PROC_REF(remove_intern_status))

/obj/item/card/id/advanced/update_overlays()
	. = ..()

	if(registered_name && registered_name != "Captain")
		. += mutable_appearance(icon, assigned_icon_state)

	var/trim_icon_file = trim_icon_override ? trim_icon_override : trim?.trim_icon
	var/trim_icon_state = trim_state_override ? trim_state_override : trim?.trim_state
	var/trim_department_color = department_color_override ? department_color_override : trim?.department_color
	var/trim_department_state = department_state_override ? department_state_override : trim?.department_state
	var/trim_subdepartment_color = subdepartment_color_override ? subdepartment_color_override : trim?.subdepartment_color

	if(!trim_icon_file || !trim_icon_state || !trim_department_color || !trim_subdepartment_color || !trim_department_state)
		return

	/// We handle department and subdepartment overlays first, so the job icon is always on top.
	var/mutable_appearance/department_overlay = mutable_appearance(trim_icon_file, trim_department_state)
	department_overlay.color = trim_department_color
	. += department_overlay

	var/mutable_appearance/subdepartment_overlay = mutable_appearance(trim_icon_file, "subdepartment")
	subdepartment_overlay.color = trim_subdepartment_color
	. += subdepartment_overlay

	/// Then we handle the job's icon here.
	. += mutable_appearance(trim_icon_file, trim_icon_state)

/obj/item/card/id/advanced/get_trim_assignment()
	if(trim_assignment_override)
		return trim_assignment_override

	if(ispath(trim))
		var/datum/id_trim/trim_singleton = SSid_access.trim_singletons_by_path[trim]
		return trim_singleton.assignment

	return ..()

/// Returns the trim sechud icon state.
/obj/item/card/id/advanced/get_trim_sechud_icon_state()
	return sechud_icon_state_override || ..()

/obj/item/card/id/advanced/rainbow
	name = "彩虹识别卡"
	desc = "一张彩虹卡，以'正式商务'之名，传递欢乐之情!"
	icon_state = "card_rainbow"

/obj/item/card/id/advanced/silver
	name = "银识别卡"
	desc = "展示了荣誉与重大责任的银卡."
	icon_state = "card_silver"
	inhand_icon_state = "silver_id"
	assigned_icon_state = "assigned_silver"
	wildcard_slots = WILDCARD_LIMIT_SILVER

/obj/item/card/id/advanced/robotic
	name = "磁性识别卡"
	desc = "这是一张集成卡，展现了为打开成功之门所付出的努力与心血."
	icon_state = "card_carp" //im not a spriter
	inhand_icon_state = "silver_id"
	assigned_icon_state = "assigned_silver"
	wildcard_slots = WILDCARD_LIMIT_GREY

/datum/id_trim/maint_reaper
	access = list(ACCESS_MAINT_TUNNELS)
	trim_state = "trim_janitor"
	assignment = "Reaper"

/obj/item/card/id/advanced/silver/reaper
	name = "十三的ID卡 (Reaper)"
	trim = /datum/id_trim/maint_reaper
	registered_name = "Thirteen"

/obj/item/card/id/advanced/gold
	name = "金识别卡"
	desc = "展现了权力和威能的金识别卡."
	icon_state = "card_gold"
	inhand_icon_state = "gold_id"
	assigned_icon_state = "assigned_gold"
	wildcard_slots = WILDCARD_LIMIT_GOLD

/obj/item/card/id/advanced/gold/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_TASTEFULLY_THICK_ID_CARD, ROUNDSTART_TRAIT)

/obj/item/card/id/advanced/gold/captains_spare
	name = "舰长备用ID卡"
	desc = "最高领主本人的备用ID卡."
	registered_name = "Captain"
	trim = /datum/id_trim/job/captain
	registered_age = null

/obj/item/card/id/advanced/gold/captains_spare/update_label() //so it doesn't change to Captain's ID card (Captain) on a sneeze
	if(registered_name == "Captain")
		name = "[initial(name)][(!assignment || assignment == "Captain") ? "" : " ([assignment])"]"
		update_appearance(UPDATE_ICON)
	else
		..()

/obj/item/card/id/advanced/centcom
	name = "中央指挥部ID卡"
	desc = "来自中央指挥部的识别卡."
	icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	registered_name = JOB_CENTCOM
	registered_age = null
	trim = /datum/id_trim/centcom
	wildcard_slots = WILDCARD_LIMIT_CENTCOM

/obj/item/card/id/advanced/centcom/ert
	name = "中央指挥部ID卡"
	desc = "一张ERT的ID卡."
	registered_age = null
	registered_name = "应急部队实习生"
	trim = /datum/id_trim/centcom/ert

/obj/item/card/id/advanced/centcom/ert
	registered_name = JOB_ERT_COMMANDER
	trim = /datum/id_trim/centcom/ert/commander

/obj/item/card/id/advanced/centcom/ert/security
	registered_name = JOB_ERT_OFFICER
	trim = /datum/id_trim/centcom/ert/security

/obj/item/card/id/advanced/centcom/ert/engineer
	registered_name = JOB_ERT_ENGINEER
	trim = /datum/id_trim/centcom/ert/engineer

/obj/item/card/id/advanced/centcom/ert/medical
	registered_name = JOB_ERT_MEDICAL_DOCTOR
	trim = /datum/id_trim/centcom/ert/medical

/obj/item/card/id/advanced/centcom/ert/chaplain
	registered_name = JOB_ERT_CHAPLAIN
	trim = /datum/id_trim/centcom/ert/chaplain

/obj/item/card/id/advanced/centcom/ert/janitor
	registered_name = JOB_ERT_JANITOR
	trim = /datum/id_trim/centcom/ert/janitor

/obj/item/card/id/advanced/centcom/ert/clown
	registered_name = JOB_ERT_CLOWN
	trim = /datum/id_trim/centcom/ert/clown

/obj/item/card/id/advanced/centcom/ert/militia
	registered_name = "边境义勇兵"
	trim = /datum/id_trim/centcom/ert/militia

/obj/item/card/id/advanced/centcom/ert/militia/general
	registered_name = "边境义勇兵将军"
	trim = /datum/id_trim/centcom/ert/militia/general

/obj/item/card/id/advanced/black
	name = "黑识别卡"
	desc = "这张卡片只告诉你一件事，那就是：持有这张卡片的人是个绝对的狠角色."
	icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
	wildcard_slots = WILDCARD_LIMIT_GOLD

/obj/item/card/id/advanced/black/deathsquad
	name = "行刑队ID卡"
	desc = "一张行刑队的ID卡."
	registered_name = JOB_ERT_DEATHSQUAD
	trim = /datum/id_trim/centcom/deathsquad
	wildcard_slots = WILDCARD_LIMIT_DEATHSQUAD

/obj/item/card/id/advanced/black/syndicate_command
	name = "辛迪加ID卡"
	desc = "一张直接来自辛迪加的ID卡."
	registered_name = "辛迪加"
	registered_age = null
	trim = /datum/id_trim/syndicom
	wildcard_slots = WILDCARD_LIMIT_SYNDICATE

/obj/item/card/id/advanced/black/syndicate_command/crew_id
	name = "辛迪加ID卡"
	desc = "一张直接来自辛迪加的ID卡."
	registered_name = "辛迪加"
	trim = /datum/id_trim/syndicom/crew

/obj/item/card/id/advanced/black/syndicate_command/captain_id
	name = "辛迪加舰长ID卡"
	desc = "一张直接来自辛迪加的舰长ID卡."
	registered_name = "辛迪加"
	trim = /datum/id_trim/syndicom/captain


/obj/item/card/id/advanced/black/syndicate_command/captain_id/syndie_spare
	name = "辛迪加舰长备用ID卡"
	desc = "黑暗魔王大人的备用ID卡."
	registered_name = "舰长"
	registered_age = null

/obj/item/card/id/advanced/black/syndicate_command/captain_id/syndie_spare/update_label()
	if(registered_name == "舰长")
		name = "[initial(name)][(!assignment || assignment == "舰长") ? "" : " ([assignment])"]"
		update_appearance(UPDATE_ICON)
		return

	return ..()

/obj/item/card/id/advanced/debug
	name = "\improper Debug ID"
	desc = "调试ID卡，拥有所有权限和大笔钱."
	icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	trim = /datum/id_trim/admin
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/obj/item/card/id/advanced/debug/Initialize(mapload)
	. = ..()
	registered_account = new(player_account = FALSE)
	registered_account.account_id = ADMIN_ACCOUNT_ID // this is so bank_card_talk() can work.
	registered_account.account_job = SSjob.GetJobType(/datum/job/admin)
	registered_account.account_balance += 999999 // MONEY! We add more money to the account every time we spawn because it's a debug item and infinite money whoopie

/obj/item/card/id/advanced/debug/alt_click_can_use_id(mob/living/user)
	. = ..()
	if(!. || isnull(user.client?.holder)) // admins only as a safety so people don't steal all the dollars. spawn in a holochip if you want them to get some dosh
		registered_account.bank_card_talk(span_warning("Only authorized representatives of Nanotrasen may use this card."), force = TRUE)
		return FALSE

	return TRUE

/obj/item/card/id/advanced/debug/can_be_used_in_payment(mob/living/user)
	. = ..()
	if(!. || isnull(user.client?.holder))
		registered_account.bank_card_talk(span_warning("Only authorized representatives of Nanotrasen may use this card."), force = TRUE)
		return FALSE

	return TRUE

/obj/item/card/id/advanced/prisoner
	name = "囚犯ID卡"
	desc = "只以编号相称，而无贵贱之别."
	icon_state = "card_prisoner"
	inhand_icon_state = "orange-id"
	registered_name = "渣滓"
	registered_age = null
	trim = /datum/id_trim/job/prisoner

	wildcard_slots = WILDCARD_LIMIT_PRISONER

	/// Number of gulag points required to earn freedom.
	var/goal = 0
	/// Number of gulag points earned.
	var/points = 0
	/// If the card has a timer set on it for temporary stay.
	var/timed = FALSE
	/// Time to assign to the card when they pass through the security gate.
	var/time_to_assign
	/// Time left on a card till they can leave.
	var/time_left = 0

/obj/item/card/id/advanced/prisoner/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(.)
		return .

	if(isidcard(tool))
		return set_sentence_time(user, tool)

/obj/item/card/id/advanced/prisoner/proc/set_sentence_time(mob/living/user, obj/item/card/id/our_card)
	var/list/id_access = our_card.GetAccess()
	if(!(ACCESS_BRIG in id_access))
		balloon_alert(user, "访问被拒绝!")
		return ITEM_INTERACT_BLOCKING
	if(!user.is_holding(src))
		to_chat(user, span_warning("You must be holding the ID to continue!"))
		return ITEM_INTERACT_BLOCKING

	if(timed) // If we already have a time set, reset the card
		timed = FALSE
		time_to_assign = initial(time_to_assign)
		registered_name = initial(registered_name)
		STOP_PROCESSING(SSobj, src)
		to_chat(user, "Resetting 囚犯ID to default parameters.")
		return ITEM_INTERACT_SUCCESS

	var/choice = tgui_input_number(user, "Sentence time in seconds", "Sentencing")
	if(isnull(choice) || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH) || !user.is_holding(src))
		return ITEM_INTERACT_BLOCKING
	time_to_assign = choice
	to_chat(user, "You set the sentence time to [DisplayTimeText(time_to_assign * 10)].")
	timed = TRUE
	return ITEM_INTERACT_SUCCESS

/obj/item/card/id/advanced/prisoner/proc/start_timer()
	say("Sentence started, welcome to the corporate rehabilitation center!")
	START_PROCESSING(SSobj, src)

/obj/item/card/id/advanced/prisoner/examine(mob/user)
	. = ..()
	if(!.)
		return

	if(timed)
		if(time_to_assign > 0)
			. += span_notice("The digital timer on the card is set to [DisplayTimeText(time_to_assign * 10)]. The timer will start once the 囚犯passes through the prison gate scanners.")
		else if(time_left <= 0)
			. += span_notice("The digital timer on the card has zero seconds remaining. You leave a changed man, but a free man nonetheless.")
		else
			. += span_notice("The digital timer on the card has [DisplayTimeText(time_left * 10)] remaining. Don't do the crime if you can't do the time.")

	. += span_notice("[EXAMINE_HINT("Swipe")] a security ID on the card to [timed ? "re" : ""]set the genpop sentence time.")
	. += span_notice("Remember to [EXAMINE_HINT("swipe")] the card on a genpop locker to link it.")

/obj/item/card/id/advanced/prisoner/process(seconds_per_tick)
	if(!timed)
		return
	time_left -= seconds_per_tick
	if(time_left <= 0)
		say("Sentence time has been served. Thank you for your cooperation in our corporate rehabilitation program!")
		STOP_PROCESSING(SSobj, src)

/obj/item/card/id/advanced/prisoner/attack_self(mob/user)
	to_chat(usr, span_notice("You have accumulated [points] out of the [goal] points you need for freedom."))

/obj/item/card/id/advanced/prisoner/one
	name = "囚犯#13-001"
	registered_name = "囚犯#13-001"
	trim = /datum/id_trim/job/prisoner/one

/obj/item/card/id/advanced/prisoner/two
	name = "囚犯#13-002"
	registered_name = "囚犯#13-002"
	trim = /datum/id_trim/job/prisoner/two

/obj/item/card/id/advanced/prisoner/three
	name = "囚犯#13-003"
	registered_name = "囚犯#13-003"
	trim = /datum/id_trim/job/prisoner/three

/obj/item/card/id/advanced/prisoner/four
	name = "囚犯#13-004"
	registered_name = "囚犯#13-004"
	trim = /datum/id_trim/job/prisoner/four

/obj/item/card/id/advanced/prisoner/five
	name = "囚犯#13-005"
	registered_name = "囚犯#13-005"
	trim = /datum/id_trim/job/prisoner/five

/obj/item/card/id/advanced/prisoner/six
	name = "囚犯#13-006"
	registered_name = "囚犯#13-006"
	trim = /datum/id_trim/job/prisoner/six

/obj/item/card/id/advanced/prisoner/seven
	name = "囚犯#13-007"
	registered_name = "囚犯#13-007"
	trim = /datum/id_trim/job/prisoner/seven

/obj/item/card/id/advanced/mining
	name = "采矿ID卡"
	trim = /datum/id_trim/job/shaft_miner/spare

/obj/item/card/id/advanced/highlander
	name = "高地人ID卡"
	registered_name = "高地人"
	desc = "只能活下来一个人!"
	icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
	trim = /datum/id_trim/highlander
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/obj/item/card/id/advanced/chameleon
	name = "特工卡"
	desc = "这是一张高度先进的变色龙身份证，将这张卡与另一张身份证或玩家接触，即可选择要复制的权限。它具有特殊的磁性属性，可以使其自动吸附在钱包的最前面."
	trim = /datum/id_trim/chameleon
	wildcard_slots = WILDCARD_LIMIT_CHAMELEON_PLUS // SKYRAT EDIT - Original WILDCARD_LIMIT_CHAMELEON
	actions_types = list(/datum/action/item_action/chameleon/change/id, /datum/action/item_action/chameleon/change/id_trim)

	/// Have we set a custom name and job assignment, or will we use what we're given when we chameleon change?
	var/forged = FALSE
	/// Anti-metagaming protections. If TRUE, anyone can change the ID card's details. If FALSE, only syndicate agents can.
	var/anyone = FALSE
	/// Weak ref to the ID card we're currently attempting to steal access from.
	var/datum/weakref/theft_target

/obj/item/card/id/advanced/chameleon/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/card/id/advanced/chameleon/Destroy()
	theft_target = null
	return ..()

/obj/item/card/id/advanced/chameleon/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isidcard(interacting_with))
		theft_target = WEAKREF(interacting_with)
		ui_interact(user)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/card/id/advanced/chameleon/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	// If we're attacking a human, we want it to be covert. We're not ATTACKING them, we're trying
	// to sneakily steal their accesses by swiping our agent ID card near them. As a result, we
	// return ITEM_INTERACT_BLOCKING to cancel any part of the following the attack chain.
	if(ishuman(interacting_with))
		interacting_with.balloon_alert(user, "scanning ID card...")

		if(!do_after(user, 2 SECONDS, interacting_with))
			interacting_with.balloon_alert(user, "interrupted!")
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_target = interacting_with
		var/list/target_id_cards = human_target.get_all_contents_type(/obj/item/card/id)

		if(!length(target_id_cards))
			interacting_with.balloon_alert(user, "no IDs!")
			return ITEM_INTERACT_BLOCKING

		var/selected_id = pick(target_id_cards)
		interacting_with.balloon_alert(user, UNLINT("IDs synced"))
		theft_target = WEAKREF(selected_id)
		ui_interact(user)
		return ITEM_INTERACT_SUCCESS

	if(isitem(interacting_with))
		var/obj/item/target_item = interacting_with

		interacting_with.balloon_alert(user, "scanning ID card...")

		var/list/target_id_cards = target_item.get_all_contents_type(/obj/item/card/id)
		var/target_item_id = target_item.GetID()

		if(target_item_id)
			target_id_cards |= target_item_id

		if(!length(target_id_cards))
			interacting_with.balloon_alert(user, "no IDs!")
			return ITEM_INTERACT_BLOCKING

		var/selected_id = pick(target_id_cards)
		interacting_with.balloon_alert(user, UNLINT("IDs synced"))
		theft_target = WEAKREF(selected_id)
		ui_interact(user)
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/card/id/advanced/chameleon/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChameleonCard", name)
		ui.open()

/obj/item/card/id/advanced/chameleon/ui_static_data(mob/user)
	var/list/data = list()
	data["wildcardFlags"] = SSid_access.wildcard_flags_by_wildcard
	data["accessFlagNames"] = SSid_access.access_flag_string_by_flag
	data["accessFlags"] = SSid_access.flags_by_access
	return data

/obj/item/card/id/advanced/chameleon/ui_host(mob/user)
	// Hook our UI to the theft target ID card for UI state checks.
	return theft_target?.resolve()

/obj/item/card/id/advanced/chameleon/ui_state(mob/user)
	return GLOB.always_state

/obj/item/card/id/advanced/chameleon/ui_status(mob/user, datum/ui_state/state)
	var/target = theft_target?.resolve()

	if(!target)
		return UI_CLOSE

	var/status = min(
		ui_status_user_strictly_adjacent(user, target),
		ui_status_user_is_advanced_tool_user(user),
		max(
			ui_status_user_is_conscious_and_lying_down(user),
			ui_status_user_is_abled(user, target),
		),
	)

	if(status < UI_INTERACTIVE)
		return UI_CLOSE

	return status

/obj/item/card/id/advanced/chameleon/ui_data(mob/user)
	var/list/data = list()

	data["showBasic"] = FALSE

	var/list/regions = list()

	var/obj/item/card/id/target_card = theft_target.resolve()
	if(target_card)
		var/list/tgui_region_data = SSid_access.all_region_access_tgui
		for(var/region in SSid_access.station_regions)
			regions += tgui_region_data[region]

	data["accesses"] = regions
	data["ourAccess"] = access
	data["ourTrimAccess"] = trim ? trim.access : list()
	data["theftAccess"] = target_card.access.Copy()
	data["wildcardSlots"] = wildcard_slots
	data["selectedList"] = access
	data["trimAccess"] = list()

	return data

/obj/item/card/id/advanced/chameleon/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/obj/item/card/id/target_card = theft_target?.resolve()
	if(QDELETED(target_card))
		to_chat(usr, span_notice("The ID card you were attempting to scan is no longer in range."))
		target_card = null
		return TRUE

	// Wireless ID theft!
	var/turf/our_turf = get_turf(src)
	var/turf/target_turf = get_turf(target_card)
	if(!our_turf.Adjacent(target_turf))
		to_chat(usr, span_notice("The ID card you were attempting to scan is no longer in range."))
		target_card = null
		return TRUE

	switch(action)
		if("mod_access")
			var/access_type = params["access_target"]
			var/try_wildcard = params["access_wildcard"]
			if(access_type in access)
				remove_access(list(access_type))
				LOG_ID_ACCESS_CHANGE(usr, src, "removed [SSid_access.get_access_desc(access_type)]")
				return TRUE

			if(!(access_type in target_card.access))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(!can_add_wildcards(list(access_type), try_wildcard))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(!add_access(list(access_type), try_wildcard))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(access_type in ACCESS_ALERT_ADMINS)
				message_admins("[ADMIN_LOOKUPFLW(usr)] just added [SSid_access.get_access_desc(access_type)] to an ID card [ADMIN_VV(src)] [(registered_name) ? "belonging to [registered_name]." : "with no registered name."]")
			LOG_ID_ACCESS_CHANGE(usr, src, "added [SSid_access.get_access_desc(access_type)]")
			return TRUE

/obj/item/card/id/advanced/chameleon/attack_self(mob/user)
	if(!user.can_perform_action(user, NEED_DEXTERITY| FORBID_TELEKINESIS_REACH))
		return ..()
	var/popup_input = tgui_input_list(user, "选择行为", "特工卡", list("展示", "伪装/重置", "更改账户ID"))
	if(!popup_input || !after_input_check(user))
		return TRUE
	switch(popup_input)
		if ("更改ID账户")
			set_new_account(user)
			return
		if("展示")
			return ..()

	///"Forge/Reset", kept outside the switch() statement to reduce indentation.
	if(forged) //reset the ID if forged
		registered_name = initial(registered_name)
		assignment = initial(assignment)
		SSid_access.remove_trim_from_chameleon_card(src)
		REMOVE_TRAIT(src, TRAIT_MAGNETIC_ID_CARD, CHAMELEON_ITEM_TRAIT)
		user.log_message("reset \the [initial(name)] named \"[src]\" to default.", LOG_GAME)
		update_label()
		update_icon()
		forged = FALSE
		to_chat(user, span_notice("You successfully reset the ID card."))
		return

	///forge the ID if not forged.
	var/input_name = tgui_input_text(user, "您想在这张卡上写什么名字？留空将随机.", "特工卡姓名", registered_name ? registered_name : (ishuman(user) ? user.real_name : user.name), MAX_NAME_LEN)
	if(!after_input_check(user))
		return TRUE
	if(input_name)
		input_name = sanitize_name(input_name, allow_numbers = TRUE)
	if(!input_name)
		// Invalid/blank names give a randomly generated one.
		if(user.gender == MALE)
			input_name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
		else if(user.gender == FEMALE)
			input_name = "[pick(GLOB.first_names_female)] [pick(GLOB.last_names)]"
		else
			input_name = "[pick(GLOB.first_names)] [pick(GLOB.last_names)]"

	var/change_trim = tgui_alert(user, "调整识别卡的标志?", "更改标志", list("Yes", "No"))
	if(!after_input_check(user))
		return TRUE
	var/selected_trim_path
	var/static/list/trim_list
	if(change_trim == "Yes")
		trim_list = list()
		for(var/trim_path in typesof(/datum/id_trim))
			var/datum/id_trim/trim = SSid_access.trim_singletons_by_path[trim_path]
			if(trim && trim.trim_state && trim.assignment)
				var/fake_trim_name = "[trim.assignment] ([trim.trim_state])"
				trim_list[fake_trim_name] = trim_path
		selected_trim_path = tgui_input_list(user, "选择标志应用到你的卡上.\n注意: 这并不会给予标志所属权限.", "伪装标志", sort_list(trim_list, GLOBAL_PROC_REF(cmp_typepaths_asc)))
		if(!after_input_check(user))
			return TRUE

	var/target_occupation = tgui_input_text(user, "你想在卡上填写什么职业?\n注意: 这并不会给予职业所属权限.", "特工卡工作伪装", assignment ? assignment : "助手", MAX_NAME_LEN)
	if(!after_input_check(user))
		return TRUE

	var/new_age = tgui_input_number(user, "选择ID年龄", "特工卡年龄", AGE_MIN, AGE_MAX, AGE_MIN)
	if(!after_input_check(user))
		return TRUE

	var/wallet_spoofing = tgui_alert(user, "激活钱包ID卡欺骗功能，使此卡能够强制占据钱包中可见的ID卡槽位", "钱包ID欺骗", list("Yes", "No"))
	if(!after_input_check(user))
		return

	registered_name = input_name
	if(selected_trim_path)
		SSid_access.apply_trim_to_chameleon_card(src, trim_list[selected_trim_path])
	if(target_occupation)
		assignment = sanitize(target_occupation)
	if(new_age)
		registered_age = new_age
	if(wallet_spoofing  == "Yes")
		ADD_TRAIT(src, TRAIT_MAGNETIC_ID_CARD, CHAMELEON_ITEM_TRAIT)

	update_label()
	update_icon()
	forged = TRUE
	to_chat(user, span_notice("You successfully forge the ID card."))
	user.log_message("forged \the [initial(name)] with name \"[registered_name]\", occupation \"[assignment]\" and trim \"[trim?.assignment]\".", LOG_GAME)

	if(!registered_account && ishuman(user))
		var/mob/living/carbon/human/accountowner = user

		var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[accountowner.account_id]"]
		if(account)
			account.bank_cards += src
			registered_account = account
			to_chat(user, span_notice("Your account number has been automatically assigned."))

/obj/item/card/id/advanced/chameleon/proc/after_input_check(mob/user)
	if(QDELETED(user) || QDELETED(src) || !user.client || !user.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return FALSE
	return TRUE

/obj/item/card/id/advanced/chameleon/add_item_context(obj/item/source, list/context, atom/target, mob/living/user,)
	. = ..()

	if(!in_range(user, target))
		return .
	if(ishuman(target))
		context[SCREENTIP_CONTEXT_RMB] = "Copy access"
		return CONTEXTUAL_SCREENTIP_SET
	if(isitem(target))
		context[SCREENTIP_CONTEXT_RMB] = "Scan for access"
		return CONTEXTUAL_SCREENTIP_SET
	return .

/// A special variant of the classic chameleon ID card which accepts all access.
/obj/item/card/id/advanced/chameleon/black
	icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
	wildcard_slots = WILDCARD_LIMIT_GOLD

/obj/item/card/id/advanced/engioutpost
	registered_name = "乔治 '塑料' 米勒"
	desc = "一种卡，用于提供身份并确定车站的通行权限，血从边角滴下来，呃唔."
	trim = /datum/id_trim/engioutpost
	registered_age = 47

/obj/item/card/id/advanced/simple_bot
	name = "简单机器ID卡"
	desc = "An internal ID card used by the station's non-sentient bots. You should report this to a coder if you're holding it."
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/obj/item/card/id/red
	name = "红队识别卡"
	desc = "CTF游戏时的红队识别卡"
	icon_state = "ctf_red"

/obj/item/card/id/blue
	name = "蓝队识别卡"
	desc = "CTF游戏时的蓝队识别卡"
	icon_state = "ctf_blue"

/obj/item/card/id/yellow
	name = "黄队识别卡"
	desc = "CTF游戏时的黄队识别卡"
	icon_state = "ctf_yellow"

/obj/item/card/id/green
	name = "绿队识别卡"
	desc = "CTF游戏时的绿队识别卡"
	icon_state = "ctf_green"

#undef INTERN_THRESHOLD_FALLBACK_HOURS
#undef HOLOPAY_PROJECTION_INTERVAL

#define INDEX_NAME_COLOR 1
#define INDEX_ASSIGNMENT_COLOR 2
#define INDEX_TRIM_COLOR 3

/**
 * A fake ID card any silly-willy can craft with wirecutters, cardboard and a writing utensil
 * Beside the gimmick of changing the visible name when worn, they do nothing. They cannot have an account.
 * They don't fit in PDAs nor wallets, They have no access. They won't trick securitrons. They won't work with chameleon masks.
 * Etcetera etcetera. Furthermore, talking, or getting examined on will pretty much give it away.
 */
/obj/item/card/cardboard
	name = "纸板识别卡"
	desc = "这是一张用于提供身份识别的卡片，等等，慢着，这只不过是一块被裁剪过的纸板！"
	icon_state = "cardboard_id"
	inhand_icon_state = "cardboard-id"
	worn_icon_state = "nothing"
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_ID
	///The "name" of the "owner" of this "ID"
	var/scribbled_name
	///The assignment written on this card.
	var/scribbled_assignment
	///An icon state used as trim.
	var/scribbled_trim
	///The colors for each of the above variables, for when overlays are updated.
	var/details_colors = list(COLOR_BLACK, COLOR_BLACK, COLOR_BLACK)

/obj/item/card/cardboard/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_ID)
		RegisterSignal(user, COMSIG_HUMAN_GET_VISIBLE_NAME, PROC_REF(return_visible_name))
		RegisterSignal(user, COMSIG_MOVABLE_MESSAGE_GET_NAME_PART, PROC_REF(return_message_name_part))

/obj/item/card/cardboard/dropped(mob/user, silent = FALSE)
	. = ..()
	UnregisterSignal(user, list(COMSIG_HUMAN_GET_VISIBLE_NAME, COMSIG_MOVABLE_MESSAGE_GET_NAME_PART))

/obj/item/card/cardboard/proc/return_visible_name(mob/living/carbon/human/source, list/identity)
	SIGNAL_HANDLER
	identity[VISIBLE_NAME_ID] = scribbled_name

/obj/item/card/cardboard/proc/return_message_name_part(mob/living/carbon/human/source, list/stored_name, visible_name)
	SIGNAL_HANDLER
	if(visible_name)
		return
	var/voice_name = source.GetVoice()
	if(source.name != voice_name)
		voice_name += " (as [scribbled_name])"
	stored_name[NAME_PART_INDEX] = voice_name

/obj/item/card/cardboard/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.can_write(tool, TRUE))
		INVOKE_ASYNC(src, PROC_REF(modify_card), user, tool)
		return ITEM_INTERACT_SUCCESS

///Lets the user write a name, assignment or trim on the card, or reset it. Only the name is important for the component.
/obj/item/card/cardboard/proc/modify_card(mob/living/user, obj/item/item)
	if(!user.mind)
		return
	var/popup_input = tgui_input_list(user, "更改什么", "纸板ID", list("姓名", "职业", "标志", "重置"))
	if(!after_input_check(user, item, popup_input))
		return
	switch(popup_input)
		if("姓名")
			var/input_name = tgui_input_text(user, "在卡上写什么姓名?", "纸板卡姓名", scribbled_name || (ishuman(user) ? user.real_name : user.name), MAX_NAME_LEN)
			input_name = sanitize_name(input_name, allow_numbers = TRUE)
			if(!after_input_check(user, item, input_name, scribbled_name))
				return
			scribbled_name = input_name
			var/list/details = item.get_writing_implement_details()
			details_colors[INDEX_NAME_COLOR] = details["color"] || COLOR_BLACK
		if("职业")
			var/input_assignment = tgui_input_text(user, "你想在卡上写什么职业?", "纸板卡职业", scribbled_assignment || "助手", MAX_NAME_LEN)
			if(!after_input_check(user, item, input_assignment, scribbled_assignment))
				return
			scribbled_assignment = sanitize(input_assignment)
			var/list/details = item.get_writing_implement_details()
			details_colors[INDEX_ASSIGNMENT_COLOR] = details["color"] || COLOR_BLACK
		if("标志")
			var/static/list/possible_trims
			if(!possible_trims)
				possible_trims = list()
				for(var/trim_path in typesof(/datum/id_trim))
					var/datum/id_trim/trim = SSid_access.trim_singletons_by_path[trim_path]
					if(trim?.trim_state && trim.assignment)
						possible_trims |= replacetext(trim.trim_state, "trim_", "")
				sortTim(possible_trims, GLOBAL_PROC_REF(cmp_typepaths_asc))
			var/input_trim = tgui_input_list(user, "选择应用到卡片上的标志.\n注意: 不会获得任何权限.", "伪装标志", possible_trims)
			if(!input_trim || !after_input_check(user, item, input_trim, scribbled_trim))
				return
			scribbled_trim = "cardboard_[input_trim]"
			var/list/details = item.get_writing_implement_details()
			details_colors[INDEX_TRIM_COLOR] = details["color"] || COLOR_BLACK
		if("重置")
			scribbled_name = null
			scribbled_assignment = null
			scribbled_trim = null
			details_colors = list(COLOR_BLACK, COLOR_BLACK, COLOR_BLACK)

	update_appearance()

///Checks that the conditions to be able to modify the cardboard card are still present after user input calls.
/obj/item/card/cardboard/proc/after_input_check(mob/living/user, obj/item/item, input, value)
	if(!input || (value && input == value))
		return FALSE
	if(QDELETED(user) || QDELETED(item) || QDELETED(src) || user.incapacitated() || !user.is_holding(item) || !user.CanReach(src) || !user.can_write(item))
		return FALSE
	return TRUE

/obj/item/card/cardboard/attack_self(mob/user)
	if(!Adjacent(user))
		return
	user.visible_message(span_notice("[user] shows you: [icon2html(src, viewers(user))] [name]."), span_notice("You show \the [name]."))
	add_fingerprint(user)

/obj/item/card/cardboard/update_name()
	. = ..()
	if(!scribbled_name)
		name = initial(name)
		return
	name = "[scribbled_name]的识别卡([scribbled_assignment])"

/obj/item/card/cardboard/update_overlays()
	. = ..()
	if(scribbled_name)
		var/mutable_appearance/name_overlay = mutable_appearance(icon, "cardboard_name")
		name_overlay.color = details_colors[INDEX_NAME_COLOR]
		. += name_overlay
	if(scribbled_assignment)
		var/mutable_appearance/assignment_overlay = mutable_appearance(icon, "cardboard_assignment")
		assignment_overlay.color = details_colors[INDEX_ASSIGNMENT_COLOR]
		. += assignment_overlay
	if(scribbled_trim)
		var/mutable_appearance/frame_overlay = mutable_appearance(icon, "cardboard_frame")
		frame_overlay.color = details_colors[INDEX_TRIM_COLOR]
		. += frame_overlay
		var/mutable_appearance/trim_overlay = mutable_appearance(icon, scribbled_trim)
		trim_overlay.color = details_colors[INDEX_TRIM_COLOR]
		. += trim_overlay

/obj/item/card/cardboard/get_id_examine_strings(mob/user)
	. = ..()
	. += list("[icon2html(get_cached_flat_icon(), user, extra_classes = "bigicon")]")

/obj/item/card/cardboard/get_examine_string(mob/user, thats = FALSE)
	return "[icon2html(get_cached_flat_icon(), user)] [thats? "那是 ":""][get_examine_name(user)]"

/obj/item/card/cardboard/examine(mob/user)
	. = ..()
	. += span_notice("You could use a pen or crayon to forge a name, assignment or trim.")

#undef INDEX_NAME_COLOR
#undef INDEX_ASSIGNMENT_COLOR
#undef INDEX_TRIM_COLOR
