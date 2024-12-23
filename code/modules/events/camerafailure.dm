/datum/round_event_control/camera_failure
	name = "Camera Failure-摄像头失灵"
	typepath = /datum/round_event/camera_failure
	weight = 100
	max_occurrences = 20
	alert_observers = FALSE
	category = EVENT_CATEGORY_ENGINEERING
	description = "关闭随机数量的摄像头."

/datum/round_event/camera_failure
	fakeable = FALSE

/datum/round_event/camera_failure/start()
	var/iterations = 1
	var/list/cameras = GLOB.cameranet.cameras.Copy()
	while(prob(round(100/iterations)))
		var/obj/machinery/camera/C = pick_n_take(cameras)
		if (!C)
			break
		if (!(CAMERANET_NETWORK_SS13 in C.network))
			continue
		if(C.camera_enabled)
			C.toggle_cam(null, 0)
		iterations *= 2.5
