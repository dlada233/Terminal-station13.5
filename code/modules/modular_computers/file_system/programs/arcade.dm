/datum/computer_file/program/arcade
	filename = "dsarcade"
	filedesc = "Donksoft Micro Arcade-杜软小街机"
	program_open_overlay = "arcade"
	extended_desc = "经典游戏'Outbomb Cuban Pete-轰炸古巴皮特'的移动端移植, 具有令人兴奋的画面和不寒而栗的剧情."
	downloader_category = PROGRAM_CATEGORY_GAMES
	size = 6
	tgui_id = "NtosArcade"
	program_icon = "gamepad"

	///Returns TRUE if the game is being played.
	var/game_active = TRUE
	///This disables buttom actions from having any impact if TRUE. Resets to FALSE when the player is allowed to make an action again.
	var/pause_state = FALSE
	var/boss_hp = 45
	var/boss_mp = 15
	var/player_hp = 30
	var/player_mp = 10
	var/ticket_count = 0
	///Shows what text is shown on the app, usually showing the log of combat actions taken by the player.
	var/heads_up = "Nanotrasen说, 赢者通吃."
	var/boss_name = "Cuban Pete-古巴皮特的任务目标"
	///Determines which boss image to use on the UI.
	var/boss_id = 1

///Lazy version of the arade that can be found in maintenance disks
/datum/computer_file/program/arcade/eazy
	filename = "dsarcadeez"
	filedesc = "Donksoft Micro Arcade Ez-杜软小街机无敌版"
	filetype = "MNT"
	program_flags = PROGRAM_UNIQUE_COPY
	extended_desc = "经典游戏'Outbomb Cuban Pete-轰炸古巴皮特'的粉丝魔改版，这款能让你与更弱的'George Melon'战斗."
	boss_hp = 40
	boss_mp = 10
	player_hp = 35
	player_mp = 15
	heads_up = "你坏到让全站心碎了吗?"
	boss_name = "George Melon"

/datum/computer_file/program/arcade/proc/game_check(mob/user)
	sleep(0.5 SECONDS)
	user?.mind?.adjust_experience(/datum/skill/gaming, 1)
	if(boss_hp <= 0)
		heads_up = "你消灭了[boss_name]! 嘻!"
		playsound(computer.loc, 'sound/arcade/win.ogg', 50)
		game_active = FALSE
		program_open_overlay = "arcade_off"
		if(istype(computer))
			computer.update_appearance()
		ticket_count += 1
		user?.mind?.adjust_experience(/datum/skill/gaming, 50)
		usr.won_game()
		sleep(1 SECONDS)
	else if(player_hp <= 0 || player_mp <= 0)
		heads_up = "你被击败了...站点将何去何从?"
		playsound(computer.loc, 'sound/arcade/lose.ogg', 50)
		game_active = FALSE
		program_open_overlay = "arcade_off"
		if(istype(computer))
			computer.update_appearance()
		user?.mind?.adjust_experience(/datum/skill/gaming, 10)
		usr.lost_game()
		sleep(1 SECONDS)

/datum/computer_file/program/arcade/proc/enemy_check(mob/user)
	var/boss_attackamt = 0 //Spam protection from boss attacks as well.
	var/boss_mpamt = 0
	var/bossheal = 0
	if(pause_state == TRUE)
		boss_attackamt = rand(3,6)
		boss_mpamt = rand (2,4)
		bossheal = rand (4,6)
	if(game_active == FALSE)
		return
	if (boss_mp <= 5)
		heads_up = "[boss_mpamt]偷取了你的魔力!"
		playsound(computer.loc, 'sound/arcade/steal.ogg', 50, TRUE)
		player_mp -= boss_mpamt
		boss_mp += boss_mpamt
	else if(boss_mp > 5 && boss_hp <12)
		heads_up = "[boss_name]治疗了[bossheal]点生命值!"
		playsound(computer.loc, 'sound/arcade/heal.ogg', 50, TRUE)
		boss_hp += bossheal
		boss_mp -= boss_mpamt
	else
		heads_up = "[boss_name]造成[boss_attackamt]点伤害!"
		playsound(computer.loc, 'sound/arcade/hit.ogg', 50, TRUE)
		player_hp -= boss_attackamt

	pause_state = FALSE
	game_check()

/datum/computer_file/program/arcade/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/arcade),
	)

/datum/computer_file/program/arcade/ui_data(mob/user)
	var/list/data = list()
	data["Hitpoints"] = boss_hp
	data["PlayerHitpoints"] = player_hp
	data["PlayerMP"] = player_mp
	data["TicketCount"] = ticket_count
	data["GameActive"] = game_active
	data["PauseState"] = pause_state
	data["Status"] = heads_up
	data["BossID"] = "boss[boss_id].gif"
	return data

/datum/computer_file/program/arcade/ui_act(action, list/params)
	usr.played_game()
	var/gamerSkillLevel = 0
	var/gamerSkill = 0
	if(usr?.mind)
		gamerSkillLevel = usr.mind.get_skill_level(/datum/skill/gaming)
		gamerSkill = usr.mind.get_skill_modifier(/datum/skill/gaming, SKILL_RANDS_MODIFIER)
	switch(action)
		if("Attack")
			var/attackamt = 0 //Spam prevention.
			if(pause_state == FALSE)
				attackamt = rand(2,6) + rand(0, gamerSkill)
			pause_state = TRUE
			heads_up = "你造成了[attackamt]点伤害."
			playsound(computer.loc, 'sound/arcade/hit.ogg', 50, TRUE)
			boss_hp -= attackamt
			sleep(1 SECONDS)
			game_check()
			enemy_check()
			return TRUE
		if("Heal")
			var/healamt = 0 //More Spam Prevention.
			var/healcost = 0
			if(pause_state == FALSE)
				healamt = rand(6,8) + rand(0, gamerSkill)
				var/maxPointCost = 3
				if(gamerSkillLevel >= SKILL_LEVEL_JOURNEYMAN)
					maxPointCost = 2
				healcost = rand(1, maxPointCost)
			pause_state = TRUE
			heads_up = "你恢复了[healamt]点生命值."
			playsound(computer.loc, 'sound/arcade/heal.ogg', 50, TRUE)
			player_hp += healamt
			player_mp -= healcost
			sleep(1 SECONDS)
			game_check()
			enemy_check()
			return TRUE
		if("Recharge_Power")
			var/rechargeamt = 0 //As above.
			if(pause_state == FALSE)
				rechargeamt = rand(4,7) + rand(0, gamerSkill)
			pause_state = TRUE
			heads_up = "你充能[rechargeamt]点魔力."
			playsound(computer.loc, 'sound/arcade/mana.ogg', 50, TRUE)
			player_mp += rechargeamt
			sleep(1 SECONDS)
			game_check()
			enemy_check()
			return TRUE
		if("Dispense_Tickets")
			if(computer.stored_paper <= 0)
				to_chat(usr, span_notice("打印机没纸了."))
				return
			else
				computer.visible_message(span_notice("[computer]打印纸张."))
				if(ticket_count >= 1)
					new /obj/item/stack/arcadeticket((get_turf(computer)), 1)
					to_chat(usr, span_notice("[computer]开出奖券!"))
					ticket_count -= 1
					computer.stored_paper -= 1
				else
					to_chat(usr, span_notice("你没有存任何奖券."))
				return TRUE
		if("Start_Game")
			game_active = TRUE
			boss_hp = initial(boss_hp)
			player_hp = initial(player_hp)
			player_mp = initial(player_mp)
			heads_up = "你站到了[boss_name]前! 准备战斗!"
			program_open_overlay = "arcade"
			boss_id = rand(1,6)
			pause_state = FALSE
			if(istype(computer))
				computer.update_appearance()
