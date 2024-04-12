/datum/objective/abductee
	completed = 1

/datum/objective/abductee/random

/datum/objective/abductee/random/New()
	explanation_text = pick(world.file2list("strings/abductee_objectives.txt"))

/datum/objective/abductee/steal
	explanation_text = "偷走所有的"

/datum/objective/abductee/steal/New()
	var/target = pick(list("宠物","光源","猴子","水果","鞋子","肥皂", "武器", "电脑", "器官"))
	explanation_text+="[target]."

/datum/objective/abductee/paint
	explanation_text = "此站丑得不堪入目，需要给它上上"

/datum/objective/abductee/paint/New()
	var/color = pick(list("红色", "蓝色", "绿色", "黄色", "橙色", "紫色", "黑色", "彩色", "血色"))
	explanation_text+= "[color]!"

/datum/objective/abductee/speech
	explanation_text = "你的脑子坏了...你的交流方式只剩下了"

/datum/objective/abductee/speech/New()
	var/style = pick(list("哑剧", "押韵短诗", "俳句", "延伸隐喻", "谜语", "极其书面化的术语", "口技", "军事术语", "不超过三个字的句子"))
	explanation_text+= "[style]."

/datum/objective/abductee/capture
	explanation_text = "捕获"

/datum/objective/abductee/capture/New()
	var/list/jobs = SSjob.joinable_occupations.Copy()
	for(var/datum/job/job as anything in jobs)
		if(job.current_positions < 1)
			jobs -= job
	if(length(jobs) > 0)
		var/datum/job/target = pick(jobs)
		explanation_text += "[target.title]."
	else
		explanation_text += "一个人."

/datum/objective/abductee/calling/New()
	var/mob/dead/D = pick(GLOB.dead_mob_list)
	if(D)
		explanation_text = "你知道[D]已经死了. 所以举行通灵仪式来从灵界召唤[D.p_them()]."

/datum/objective/abductee/forbiddennumber

/datum/objective/abductee/forbiddennumber/New()
	var/number = rand(2,10)
	explanation_text = "忽略集合[number]中的任何东西，它们不存在."
