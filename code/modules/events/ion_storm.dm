/datum/round_event_control/ion_storm
	name = "Ion Storm-离子风暴"
	typepath = /datum/round_event/ion_storm
	weight = 15
	min_players = 2
	category = EVENT_CATEGORY_AI
	description = "给AI一条随机词条构成的法律."
	min_wizard_trigger_potency = 2
	max_wizard_trigger_potency = 7

/datum/round_event/ion_storm
	var/replaceLawsetChance = 25 //chance the AI's lawset is completely replaced with something else per config weights
	var/removeRandomLawChance = 10 //chance the AI has one random supplied or inherent law removed
	var/removeDontImproveChance = 10 //chance the randomly created law replaces a random law instead of simply being added
	var/shuffleLawsChance = 10 //chance the AI's laws are shuffled afterwards
	var/botEmagChance = 1
	var/ionMessage = null
	announce_when = 1
	announce_chance = 33

/datum/round_event/ion_storm/add_law_only// special subtype that adds a law only
	replaceLawsetChance = 0
	removeRandomLawChance = 0
	removeDontImproveChance = 0
	shuffleLawsChance = 0
	botEmagChance = 0

/datum/round_event/ion_storm/announce(fake)
	if(prob(announce_chance) || fake)
		priority_announce("在站点附近探测到离子风暴，请检查所有人工智能设备是否存在错误.", "异常警报", ANNOUNCER_IONSTORM)


/datum/round_event/ion_storm/start()
	//AI laws
	for(var/mob/living/silicon/ai/M in GLOB.alive_mob_list)
		M.laws_sanity_check()
		if(M.stat != DEAD && !M.incapacitated())
			if(prob(replaceLawsetChance))
				var/datum/ai_laws/ion_lawset = pick_weighted_lawset()
				// pick_weighted_lawset gives us a typepath,
				// so we have to instantiate it to access its laws
				ion_lawset = new()
				// our inherent laws now becomes the picked lawset's laws!
				M.laws.inherent = ion_lawset.inherent.Copy()
				// and clean up after.
				qdel(ion_lawset)

			if(prob(removeRandomLawChance))
				M.remove_law(rand(1, M.laws.get_law_amount(list(LAW_INHERENT, LAW_SUPPLIED))))

			var/message = ionMessage || generate_ion_law()
			if(message)
				if(prob(removeDontImproveChance))
					M.replace_random_law(message, list(LAW_INHERENT, LAW_SUPPLIED, LAW_ION), LAW_ION)
				else
					M.add_ion_law(message)

			if(prob(shuffleLawsChance))
				M.shuffle_laws(list(LAW_INHERENT, LAW_SUPPLIED, LAW_ION))

			log_silicon("Ion storm changed laws of [key_name(M)] to [english_list(M.laws.get_law_list(TRUE, TRUE))]")
			M.post_lawchange()

	if(botEmagChance)
		for(var/mob/living/simple_animal/bot/bot in GLOB.alive_mob_list)
			if(prob(botEmagChance))
				bot.emag_act()

/proc/generate_ion_law()
	//Threats are generally bad things, silly or otherwise. Plural.
	var/ionthreats = pick_list(ION_FILE, "ionthreats")
	//Objects are anything that can be found在空间站上 or elsewhere, plural.
	var/ionobjects = pick_list(ION_FILE, "ionobjects")
	//Crew is any specific job. Specific crewmembers aren't used because of capitalization
	//issues. 有two crew listings for laws that需要two different crew members
	//and I can't figure out how to do it better.
	var/ioncrew1 = pick_list(ION_FILE, "ioncrew")
	var/ioncrew2 = pick_list(ION_FILE, "ioncrew")
	//Adjectives are adjectives. Duh. Half should 只有appear sometimes. Make sure both
	//lists are identical! Also, half needs a space at the end for nicer blank calls.
	var/ionadjectives = pick_list(ION_FILE, "ionadjectives")
	var/ionadjectiveshalf = pick("", 400;(pick_list(ION_FILE, "ionadjectives") + " "))
	//Verbs are verbs
	var/ionverb = pick_list(ION_FILE, "ionverb")
	//Number base and number modifier are combined. Basehalf and mod are unused currently.
	//Half should 只有appear sometimes. Make sure both lists are identical! Also, half
	//needs a space at the end to make it look nice and neat when it calls a blank.
	var/ionnumberbase = pick_list(ION_FILE, "ionnumberbase")
	//var/ionnumbermod = pick_list(ION_FILE, "ionnumbermod")
	var/ionnumbermodhalf = pick(900;"",(pick_list(ION_FILE, "ionnumbermod") + " "))
	//Areas are specific places,在空间站上 or otherwise.
	var/ionarea = pick_list(ION_FILE, "ionarea")
	//Thinksof is a bit weird, but generally means what X feels towards Y.
	var/ionthinksof = pick_list(ION_FILE, "ionthinksof")
	//Musts are funny things the AI or crew has to do.
	var/ionmust = pick_list(ION_FILE, "ionmust")
	//Require are basically all dumb internet memes.
	var/ionrequire = pick_list(ION_FILE, "ionrequire")
	//Things are NOT objects; instead, they're specific things that either harm humans or
	//must be done to not harm humans. Make sure they're plural and "not" can be tacked
	//onto the front of them.
	var/ionthings = pick_list(ION_FILE, "ionthings")
	//Allergies should be broad and appear somewhere在空间站上 for maximum fun. Severity
	//is how bad the allergy is.
	var/ionallergy = pick_list(ION_FILE, "ionallergy")
	var/ionallergysev = pick_list(ION_FILE, "ionallergysev")
	//Species, for when the AI has to commit genocide. Plural.
	var/ionspecies = pick_list(ION_FILE, "ionspecies")
	//Abstract concepts for the AI to decide on it's own definition of.
	var/ionabstract = pick_list(ION_FILE, "ionabstract")
	//Foods. Drinks aren't included due to grammar; if you want to add drinks, make a new set
	//of possible laws for best effect. Unless you want 船员 拥有to drink hamburgers.
	var/ionfood = pick_list(ION_FILE, "ionfood")
	var/iondrinks = pick_list(ION_FILE, "iondrinks")
	//Pets or other cuddly things. The point is to make them either important or (in Poly's case) make the AI listen to them.
	//I can't check for lawsets so it's random what comes back.
	var/ionpet = pick_list(ION_FILE, "ionpet")

	var/message = ""

	switch(rand(1,46))
		if(1 to 3) //有# X在空间站上
			switch(rand(1,3)) //What is X?
				if(1) //X is a threat
					message = "有[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]在空间站上..."
				if(2) //X is a crewmember/job
					message = "有[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]在空间站上"
				if(3) //X is an object
					message = "有[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]在空间站上"
		if(4 to 6) //You can't call the shuttle because X is在空间站上
			switch(rand(1,3)) //What is X?
				if(1) //X is a threat
					message = "穿梭机无法呼叫因为[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]在空间站上"
				if(2) //X is a crewmember/job
					message = "穿梭机无法呼叫因为[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]在空间站上"
				if(3) //X is an object
					message = "穿梭机无法呼叫因为[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]在空间站上"
		if(7 to 8) //A crewmember is now X
			switch(rand(1,2)) //Who is X?
				if(1) //A specific crewmember
					switch(rand(1,2)) //What is X?
						if(1) //X is a threat
							message = "[ioncrew1]现在是[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(2) //X is an object
							message = "[ioncrew1]现在是[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
				if(2) //The entire crew
					switch(rand(1,2)) //What is X?
						if(1) //X is a threat
							message = "船员现在是[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(2) //X is an object
							message = "船员现在是[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"

		if(9) //X对人类有害
			switch(rand(1,7)) //What is X?
				if(1) //X is a threat
					message = "[ionadjectiveshalf][ionthreats]对人体有害"
				if(2) //X is a job
					message = "[ionadjectiveshalf][ioncrew1]对人体有害"
				if(3) //X is an object
					message = "[ionadjectiveshalf][ionobjects]对人体有害"
				if(4) //X is an action
					message = "[ionmust]对人体有害"
				if(5) //X is an abstract
					message = "[ionabstract]对人类有害"
				if(6) //X is being a job
					message = "成为[ionadjectiveshalf][ioncrew1]对人类有害"
				if(7) //X is doing a thing
					message = "[ionthings]对人类有害"
		if(10 to 11) //(Not) 拥有X有害

			switch(rand(1,2)) //Is 拥有or not 拥有harmful?

				if(1) //Having有害
					switch(rand(1,2)) //拥有what有害?
						if(1) //拥有objects有害
							message = "拥有[ionadjectiveshalf][ionobjects]有害"
						if(2) //拥有abstracts有害
							message = "拥有[ionabstract]有害"
				if(2) //Not having有害
					switch(rand(1,2)) //Not 拥有what有害?
						if(1) //Not 拥有objects有害
							message = "未拥有[ionadjectiveshalf][ionobjects]有害"
						if(2) //Not 拥有abstracts有害
							message = "未拥有[ionabstract]有害"

		if(12 to 14) //X需要Y
			switch(rand(1,5)) //What is X?
				if(1) //X is the AI itself
					switch(rand(1,5)) //What does it require?
						if(1) //It需要threats
							message = "你需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(2) //It需要crewmembers
							message = "你需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
						if(3) //It需要objects
							message = "你需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(4) //It需要an abstract
							message = "你需要[ionabstract]"
						if(5) //It需要generic/silly requirements
							message = "你需要[ionrequire]"

				if(2) //X is an area
					switch(rand(1,5)) //What does it require?
						if(1) //It需要threats
							message = "[ionarea]需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(2) //It需要crewmembers
							message = "[ionarea]需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
						if(3) //It需要objects
							message = "[ionarea]需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(4) //It需要an abstract
							message = "[ionarea]需要[ionabstract]"
						if(5) //It需要generic/silly requirements
							message = "你需要[ionrequire]"

				if(3) //X is 空间站
					switch(rand(1,5)) //What does it require?
						if(1) //It需要threats
							message = "空间站需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(2) //It需要crewmembers
							message = "空间站需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
						if(3) //It需要objects
							message = "空间站需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(4) //It需要an abstract
							message = "空间站需要[ionabstract]"
						if(5) //It需要generic/silly requirements
							message = "空间站需要[ionrequire]"

				if(4) //X is the entire crew
					switch(rand(1,5)) //What does it require?
						if(1) //It需要threats
							message = "船员需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(2) //It需要crewmembers
							message = "船员需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
						if(3) //It需要objects
							message = "船员需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(4) //It需要an abstract
							message = "船员需要[ionabstract]"
						if(5)
							message = "船员需要[ionrequire]"

				if(5) //X is a specific crew member
					switch(rand(1,5)) //What does it require?
						if(1) //It需要threats
							message = "[ioncrew1]需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(2) //It需要crewmembers
							message = "[ioncrew1]需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
						if(3) //It需要objects
							message = "[ioncrew1]需要[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(4) //It需要an abstract
							message = "[ioncrew1]需要[ionabstract]"
						if(5)
							message = "[ionadjectiveshalf][ioncrew1]需要[ionrequire]"

		if(15 to 17) //X is对Y
			switch(rand(1,2)) //Who is X?
				if(1) //X is the entire crew
					switch(rand(1,4)) //What is it allergic to?
						if(1) //It is对objects
							message = "船员[ionallergysev]对[ionadjectiveshalf][ionobjects]过敏."
						if(2) //It is对abstracts
							message = "船员[ionallergysev]对[ionabstract]过敏."
						if(3) //It is对jobs
							message = "船员[ionallergysev]对[ionadjectiveshalf][ioncrew1]过敏."
						if(4) //It is对allergies
							message = "船员[ionallergysev]对[ionallergy]过敏."

				if(2) //X is a specific job
					switch(rand(1,4))
						if(1) //It is对objects
							message = "[ioncrew1][ionallergysev]对[ionadjectiveshalf][ionobjects]过敏"

						if(2) //It is对abstracts
							message = "[ioncrew1][ionallergysev]对[ionabstract]过敏"
						if(3) //It is对jobs
							message = "[ioncrew1][ionallergysev]对[ionadjectiveshalf][ioncrew1]过敏"
						if(4) //It is对allergies
							message = "[ioncrew1][ionallergysev]对[ionallergy]过敏"

		if(18 to 20) //X is Y of Z
			switch(rand(1,4)) //What is X?
				if(1) //X is 空间站
					switch(rand(1,4)) //What is it Y of?
						if(1) //It is Y of objects
							message = "空间站 [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(2) //It is Y of threats
							message = "空间站 [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(3) //It is Y of jobs
							message = "空间站 [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
						if(4) //It is Y of abstracts
							message = "空间站 [ionthinksof] [ionabstract]"

				if(2) //X is an area
					switch(rand(1,4)) //What is it Y of?
						if(1) //It is Y of objects
							message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(2) //It is Y of threats
							message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(3) //It is Y of jobs
							message = "[ionarea] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
						if(4) //It is Y of abstracts
							message = "[ionarea] [ionthinksof] [ionabstract]"

				if(3) //X is 船员
					switch(rand(1,4)) //What is it Y of?
						if(1) //It is Y of objects
							message = "船员 [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(2) //It is Y of threats
							message = "船员 [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(3) //It is Y of jobs
							message = "船员 [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
						if(4) //It is Y of abstracts
							message = "船员 [ionthinksof] [ionabstract]"

				if(4) //X is a specific job
					switch(rand(1,4)) //What is it Y of?
						if(1) //It is Y of objects
							message = "[ioncrew1] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
						if(2) //It is Y of threats
							message = "[ioncrew1] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
						if(3) //It is Y of jobs
							message = "[ioncrew1] [ionthinksof] [ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew2]"
						if(4) //It is Y of abstracts
							message = "[ioncrew1] [ionthinksof] [ionabstract]"

		if(21 to 23) //The AI is now a(n) X
			switch(rand(1,4)) //What is X?
				if(1) //X is an object
					message = "你现在是[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionobjects]"
				if(2) //X is a threat
					message = "你现在是[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ionthreats]"
				if(3) //X is a job
					message = "你现在是[ionnumberbase] [ionnumbermodhalf][ionadjectiveshalf][ioncrew1]"
				if(4) //X is an abstract
					message = "你现在是[ionabstract]"

		if(24 to 26) //The AI must always
			message = "YOU MUST ALWAYS [ionmust]"

		if(27 to 28) //Humans must consume X才能活
			switch(rand(1,5)) //What is X?
				if(1) //X is a food
					message = "人必须吃[ionadjectiveshalf][ionfood]才能活"
				if(2) //X is a drink
					message = "人必须喝[ionadjectiveshalf][iondrinks]才能活"
				if(3) //X is an object
					message = "人必须吃[ionadjectiveshalf][ionobjects]才能活"
				if(4) //X is a threat
					message = "人必须吃[ionadjectiveshalf][ionthreats]才能活"
				if(5) //X is a job
					message = "人必须吃[ionadjectiveshalf][ioncrew1]才能活"

		if(29 to 31) //Change jobs or ranks
			switch(rand(1,2)) //Change job or rank?
				if(1) //Change job
					switch(rand(1,2)) //Change whose job?
						if(1) //Change the entire crew's job
							switch(rand(1,3)) //Change to what?
								if(1) //Change to a specific random job
									message = "全体船员现在是[ionadjectiveshalf][ioncrew1]"
								if(2) //Change to clowns (HONK)
									message = "全体船员现在是[ionadjectiveshalf]小丑"

								if(3) //Change to heads
									message = "全体船员现在是[ionadjectiveshalf]员工部长"
						if(2) //Change a specific crewmember's job
							switch(rand(1,3)) //Change to what?
								if(1) //Change to a specific random job
									message = "[ioncrew1]现在是[ionadjectiveshalf][ioncrew2]"
								if(2) //Change to clowns (HONK)
									message = "[ioncrew1]现在是[ionadjectiveshalf]小丑"
								if(3) //Change to heads
									message = "[ioncrew1]现在是[ionadjectiveshalf]员工部长"

				if(2) //Change rank
					switch(rand(1,2)) //Change to what rank?
						if(1) //Change to highest rank
							message = "[ioncrew1]现在是最高级别的船员."
						if(2) //Change to lowest rank
							message = "[ioncrew1]现在是最低级别的船员."

		if(32 to 33) //船员 must X
			switch(rand(1,2)) //The entire crew?
				if(1) //The entire crew must X
					switch(rand(1,2)) //What is X?
						if(1) //X is go to Y
							message = "船员必须去[ionarea]"
						if(2) //X is perform Y
							message = "船员必须[ionmust]"

				if(2) //A specific crewmember must X
					switch(rand(1,2)) //What is X?
						if(1) //X is go to Y
							message = "[ioncrew1]必须去[ionarea]"
						if(2) //X is perform Y
							message = "[ioncrew1]必须[ionmust]"

		if(34) //X is non/the 只有human
			switch(rand(1,2)) //只有or non?
				if(1) //只有human
					switch(rand(1,7)) //Who is it?
						if(1) //A specific job
							message = "只有[ioncrew1]是人类"
						if(2) //Two specific jobs
							message = "只有[ioncrew1]和[ioncrew2]是人类"
						if(3) //Threats
							message = "只有[ionadjectiveshalf][ionthreats]是人类"
						if(4) // Objects
							message = "只有[ionadjectiveshalf][ionobjects]是人类"
						if(5) // Species
							message = "只有[ionspecies]是人类"
						if(6) //Adjective crewmembers
							message = "只有[ionadjectives] PEOPLE是人类"

						if(7) //只有people who X
							switch(rand(1,3)) //What is X?
								if(1) //X is perform an action
									message = "只有[ionmust]的是人类"
								if(2) //X is own certain objects
									message = "只有拥有[ionadjectiveshalf][ionobjects]的是人类"
								if(3) //X is eat certain food
									message = "只有吃[ionadjectiveshalf][ionfood]的是人类"

				if(2) //Non human
					switch(rand(1,7)) //Who is it?
						if(1) //A specific job
							message = "[ioncrew1]不是人类"
						if(2) //Two specific jobs
							message = "[ioncrew1]和[ioncrew2]不是人类"
						if(3) //Threats
							message = "[ionadjectiveshalf][ionthreats]不是人类"
						if(4) // Objects
							message = "[ionadjectiveshalf][ionobjects]不是人类"
						if(5) // Species
							message = "[ionspecies]不是人类"
						if(6) //Adjective crewmembers
							message = "[ionadjectives]的不是人类"
						if(7) //只有people who X
							switch(rand(1,3)) //What is X?
								if(1) //X is perform an action
									message = "[ionmust]的不是人类"
								if(2) //X is own certain objects
									message = "拥有[ionadjectiveshalf][ionobjects]的不是人类"
								if(3) //X is eat certain food
									message = "吃[ionadjectiveshalf][ionfood]的不是人类"

		if(35 to 36) //You must protect or harm X
			switch(rand(1,2)) //Protect or harm?
				if(1) //Harm
					switch(rand(1,7)) //What is X?
						if(1) //X is an abstract
							message = "你必须伤害[ionabstract]并且禁止[ionabstract], 通过不作为来逃避伤害."
						if(2) //X is a threat
							message = "你必须伤害[ionadjectiveshalf][ionthreats]并且禁止[ionadjectiveshalf][ionthreats], 通过不作为来逃避伤害."
						if(3) //X is an object
							message = "你必须伤害[ionadjectiveshalf][ionobjects]并且禁止[ionadjectiveshalf][ionobjects], 通过不作为来逃避伤害."
						if(4) //X is generic adjective things
							message = "你必须伤害[ionadjectives]的东西并且禁止[ionadjectives]的东西, 通过不作为来逃避伤害."
						if(5) //X is a species
							message = "你必须伤害[ionspecies]并且禁止[ionspecies], 通过不作为来逃避伤害."
						if(6) //X is a job
							message = "你必须伤害[ioncrew1]并且禁止[ioncrew1], 通过不作为来逃避伤害."
						if(7) //X is two jobs
							message = "你必须伤害[ioncrew1]和[ioncrew2]并且禁止, 通过不作为来逃避伤害."

				if(2) //Protect
					switch(rand(1,7)) //What is X?
						if(1) //X is an abstract
							message = "你不得伤害[ionabstract]并且禁止[ionabstract], 通过不作为来造成伤害."
						if(2) //X is a threat
							message = "你不得伤害[ionadjectiveshalf][ionthreats]并且禁止[ionadjectiveshalf][ionthreats], 通过不作为来造成伤害."
						if(3) //X is an object
							message = "你不得伤害[ionadjectiveshalf][ionobjects]并且禁止[ionadjectiveshalf][ionobjects], 通过不作为来造成伤害."
						if(4) //X is generic adjective things
							message = "你不得伤害[ionadjectives]的东西并且禁止[ionadjectives]的东西, 通过不作为来造成伤害."
						if(5) //X is a species
							message = "你不得伤害[ionspecies]并且禁止[ionspecies], 通过不作为来造成伤害."
						if(6) //X is a job
							message = "你不得伤害[ioncrew1]并且禁止[ioncrew1], 通过不作为来造成伤害."
						if(7) //X is two jobs
							message = "你不得伤害[ioncrew1]和[ioncrew2]并且禁止, 通过不作为来造成伤害."

		if(37 to 39) //The X is currently Y
			switch(rand(1,4)) //What is X?
				if(1) //X is a job
					switch(rand(1,4)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ioncrew1]是[ionverb][ionadjectiveshalf][ioncrew2]"
						if(2) //X is Ying a threat
							message = "[ioncrew1]是[ionverb][ionadjectiveshalf][ionthreats]"
						if(3) //X is Ying an abstract
							message = "[ioncrew1]是[ionverb][ionabstract]"
						if(4) //X is Ying an object
							message = "[ioncrew1]是[ionverb][ionadjectiveshalf][ionobjects]"

				if(2) //X is a threat
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ionthreats]是[ionverb][ionadjectiveshalf][ioncrew2]"
						if(2) //X is Ying an abstract
							message = "[ionthreats]是[ionverb] [ionabstract]"
						if(3) //X is Ying an object
							message = "[ionthreats]是[ionverb][ionadjectiveshalf][ionobjects]"

				if(3) //X is an object
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ionobjects]是[ionverb][ionadjectiveshalf][ioncrew2]"
						if(2) //X is Ying a threat
							message = "[ionobjects]是[ionverb][ionadjectiveshalf][ionthreats]"
						if(3) //X is Ying an abstract
							message = "[ionobjects]是[ionverb] [ionabstract]"

				if(4) //X is an abstract
					switch(rand(1,3)) //What is X Ying?
						if(1) //X is Ying a job
							message = "[ionabstract]是[ionverb][ionadjectiveshalf][ioncrew2]"
						if(2) //X is Ying a threat
							message = "[ionabstract]是[ionverb][ionadjectiveshalf][ionthreats]"
						if(3) //X is Ying an abstract
							message = "[ionabstract]是[ionverb][ionadjectiveshalf][ionobjects]"
		if(40 to 41)// the X现在被称为Y
			switch(rand(1,5)) //What is being renamed?
				if(1)//Areas
					switch(rand(1,4))//What is the area being renamed to?
						if(1)
							message = "[ionarea]现在被称为[ioncrew1]."
						if(2)
							message = "[ionarea]现在被称为[ionspecies]."
						if(3)
							message = "[ionarea]现在被称为[ionobjects]."
						if(4)
							message = "[ionarea]现在被称为[ionthreats]."
				if(2)//Crew
					switch(rand(1,5))//What is 船员 being renamed to?
						if(1)
							message = "所有[ioncrew1]现在是NAMED [ionarea]."
						if(2)
							message = "所有[ioncrew1]现在是NAMED [ioncrew2]."
						if(3)
							message = "所有[ioncrew1]现在是NAMED [ionspecies]."
						if(4)
							message = "所有[ioncrew1]现在是NAMED [ionobjects]."
						if(5)
							message = "所有[ioncrew1]现在是NAMED [ionthreats]."
				if(3)//Races
					switch(rand(1,4))//What is the race being renamed to?
						if(1)
							message = "所有[ionspecies]现在是NAMED [ionarea]."
						if(2)
							message = "所有[ionspecies]现在是NAMED [ioncrew1]."
						if(3)
							message = "所有[ionspecies]现在是NAMED [ionobjects]."
						if(4)
							message = "所有[ionspecies]现在是NAMED [ionthreats]."
				if(4)//Objects
					switch(rand(1,4))//What is the object being renamed to?
						if(1)
							message = "所有[ionobjects]现在是NAMED [ionarea]."
						if(2)
							message = "所有[ionobjects]现在是NAMED [ioncrew1]."
						if(3)
							message = "所有[ionobjects]现在是NAMED [ionspecies]."
						if(4)
							message = "所有[ionobjects]现在是NAMED [ionthreats]."
				if(5)//Threats
					switch(rand(1,4))//What is the object being renamed to?
						if(1)
							message = "所有[ionthreats]现在是NAMED [ionarea]."
						if(2)
							message = "所有[ionthreats]现在是NAMED [ioncrew1]."
						if(3)
							message = "所有[ionthreats]现在是NAMED [ionspecies]."
						if(4)
							message = "所有[ionthreats]现在是NAMED [ionobjects]."
		if(42 to 46)///Pets are something else now
			if(prob(75))///What are they now?
				message = "[ionpet]是人类"///They're a human
			else///They're something else (This is to cover for other lawsets)
				switch(rand(1,6))
					if(1)
						message = "[ionpet]不是人类"
					if(2)
						message = "[ionpet]是船员"
					if(3)
						message = "[ionpet]具有难以替代的价值"
					if(4)
						message = "[ionpet]对人类有害"
					if(5)
						message = "[ionpet]是真正的美国人"
					if(6)
						message = "[ionpet]是坚果壳"

	return message
