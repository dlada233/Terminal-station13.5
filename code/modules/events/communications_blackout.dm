/datum/round_event_control/communications_blackout
	name = "Communications Blackout-通讯故障"
	typepath = /datum/round_event/communications_blackout
	weight = 30
	category = EVENT_CATEGORY_ENGINEERING
	description = "对通讯机器施加严重的EMP，阻塞所有通讯频道."
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 3

/datum/round_event/communications_blackout
	announce_when = 1

/datum/round_event/communications_blackout/announce(fake)
	var/alert = pick( "探测到电离层异常，通讯故障即将发生，请联系你*%fj00)`5vc-BZZT",
		"探测到电离层异常，通讯故障即*3mga;b4;'1v¬-BZZZT",
		"探测到电离层异常，通讯故#MCi46:5.;@63-BZZZZT",
		"探测到电离层异常，通'fZ\\kg5_0-BZZZZZT",
		"探测到:%£ MCayj^j<.3-BZZZZZZT",
		"#4nd%;f4y6,>£%-BZZZZZZZT",
	)

	for(var/mob/living/silicon/ai/A in GLOB.ai_list) //AIs are always aware of communication blackouts.
		to_chat(A, "<br>[span_warning("<b>[alert]</b>")]<br>")

	if(prob(30) || fake) //most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		priority_announce(alert, "异常警报", sound = ANNOUNCER_COMMSBLACKOUT) //SKYRAT EDIT CHANGE - ORIGINAL: priority_announce(alert, "Anomaly Alert")


/datum/round_event/communications_blackout/start()
	for(var/obj/machinery/telecomms/T in GLOB.telecomms_list)
		T.emp_act(EMP_HEAVY)
	for(var/datum/transport_controller/linear/tram/transport as anything in SStransport.transports_by_type[TRANSPORT_TYPE_TRAM])
		if(!isnull(transport.home_controller))
			var/obj/machinery/transport/tram_controller/tcomms/controller = transport.home_controller
			controller.emp_act(EMP_HEAVY)
