/obj/structure/blob/special/resource
	name = "资源真菌体"
	icon = 'icons/mob/nonhuman-player/blob.dmi'
	icon_state = "blob_resource"
	desc = "由轻微摆动着的细长卷须组成的尖塔."
	max_integrity = BLOB_RESOURCE_MAX_HP
	point_return = BLOB_REFUND_RESOURCE_COST
	resistance_flags = LAVA_PROOF
	armor_type = /datum/armor/structure_blob/resource
	var/resource_delay = 0

/datum/armor/structure_blob/resource
	laser = 25

/obj/structure/blob/special/resource/scannerreport()
	return "陆陆续续地为真菌体提供资源，增加扩张速度."

/obj/structure/blob/special/resource/creation_action()
	if(overmind)
		overmind.resource_blobs += src

/obj/structure/blob/special/resource/Destroy()
	if(overmind)
		overmind.resource_blobs -= src
	return ..()

/obj/structure/blob/special/resource/Be_Pulsed()
	. = ..()
	if(resource_delay > world.time)
		return
	flick("blob_resource_glow", src)
	if(overmind)
		overmind.add_points(BLOB_RESOURCE_GATHER_AMOUNT)
		balloon_alert(overmind, "+[BLOB_RESOURCE_GATHER_AMOUNT]点资源")
		resource_delay = world.time + BLOB_RESOURCE_GATHER_DELAY + overmind.resource_blobs.len * BLOB_RESOURCE_GATHER_ADDED_DELAY //4 seconds plus a quarter second for each resource blob the overmind has
	else
		resource_delay = world.time + BLOB_RESOURCE_GATHER_DELAY
