/datum/techweb_node/cryostasis
	display_name = "冷冻保存技术"
	description = "Smart freezing of objects to preserve them!"
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/cryostasis/New()
	design_ids += list(
		"stasisbag",
	)
	return ..()
