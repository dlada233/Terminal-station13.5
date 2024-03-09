#define DEBRIS_DENSITY (length(core.contents) / (length(overmind.blobs_legit) * 0.25)) // items per blob

// Accumulates junk liberally
/datum/blobstrain/debris_devourer
	name = "碎件吞食者"
	description = "将吞食的碎件射向目标，并在无碎件可用时造成低额创伤."
	analyzerdescdamage = "造成低额创伤并有可能夺取近战武器."
	analyzerdesceffect = "吞食空间站内的零散物品，在攻击或被攻击时释放它们."
	color = "#8B1000"
	complementary_color = "#00558B"
	blobbernaut_message = "射击"
	message = "真菌体向你射击"


/datum/blobstrain/debris_devourer/attack_living(mob/living/L, list/nearby_blobs)
	send_message(L)
	for (var/obj/structure/blob/blob in nearby_blobs)
		debris_attack(L, blob)

/datum/blobstrain/debris_devourer/on_sporedeath(mob/living/spore)
	var/obj/structure/blob/special/core/core = overmind.blob_core
	for(var/i in 1 to 3)
		var/obj/item/I = pick(core.contents)
		if (I && !QDELETED(I))
			I.forceMove(get_turf(spore))
			I.throw_at(get_edge_target_turf(spore,pick(GLOB.alldirs)), 6, 5, spore, TRUE, FALSE, null, 3)

/datum/blobstrain/debris_devourer/expand_reaction(obj/structure/blob/B, obj/structure/blob/newB, turf/T, mob/camera/blob/O, coefficient = 1) //when the blob expands, do this
	for (var/obj/item/I in T)
		I.forceMove(overmind.blob_core)

/datum/blobstrain/debris_devourer/proc/debris_attack(mob/living/L, source)
	var/obj/structure/blob/special/core/core = overmind.blob_core
	if (prob(40 * DEBRIS_DENSITY)) // Pretend the items are spread through the blob and its mobs and not in the core.
		var/obj/item/I = pick(core.contents)
		if (I && !QDELETED(I))
			I.forceMove(get_turf(source))
			I.throw_at(L, 6, 5, overmind, TRUE, FALSE, null, 3)

/datum/blobstrain/debris_devourer/blobbernaut_attack(mob/living/L, mob/living/blobbernaut) // When this blob's blobbernaut attacks people
	debris_attack(L,blobbernaut)

/datum/blobstrain/debris_devourer/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag, coefficient = 1) //when the blob takes damage, do this
	var/obj/structure/blob/special/core/core = overmind.blob_core
	return round(max((coefficient*damage)-min(coefficient*DEBRIS_DENSITY, 10), 0)) // reduce damage taken by items per blob, up to 10

/datum/blobstrain/debris_devourer/examine(mob/user)
	. = ..()
	var/obj/structure/blob/special/core/core = overmind.blob_core
	if (isobserver(user))
		. += span_notice("当前吸收的零碎物品能减伤[round(max(min(DEBRIS_DENSITY, 10),0))]点")
	else
		switch (round(max(min(DEBRIS_DENSITY, 10),0)))
			if (0)
				. += span_notice("当前没有吸收到足够的零碎物品来减伤.")
			if (1 to 3)
				. += span_notice("吸收到的零碎物品能极小程度地降低伤害.") // these roughly correspond with force description strings
			if (4 to 7)
				. += span_notice("吸收到的零碎物品能略微降低伤害.")
			if (8 to 10)
				. += span_notice("吸收到的零碎物品能中等程度地降低伤害.")

#undef DEBRIS_DENSITY
