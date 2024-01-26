/**
 * An event which decreases the station target temporarily, causing the inflation var to increase heavily.
 *
 * Done by decreasing the station_target by a high value per crew member, resulting in the station total being much higher than the target, and causing artificial inflation.
 */
/datum/round_event_control/market_crash
	name = "Market Crash"
	typepath = /datum/round_event/market_crash
	weight = 10
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Temporarily increases the prices of vending machines."

/datum/round_event/market_crash
	/// This counts the number of ticks that the market crash event has been processing, so that we don't call vendor price updates every tick, but we still iterate for other mechanics that use inflation.
	var/tick_counter = 1

/datum/round_event/market_crash/setup()
	start_when = 1
	end_when = rand(100, 50)
	announce_when = 2

/datum/round_event/market_crash/announce(fake)
	var/list/poss_reasons = list("技术性调整",\
		"一些高风险的房地产项目烂尾",\
		"B.E.P.I.S.团队不合时宜的垮台",\
		"SolFed的投机性拨开适得其反",  /*SKYRAT EDIT CHANGE; original was "speculative Terragov grants backfiring"*/\
		"银行惨遭抢劫一空",\
		"供应链短缺",\
		"\"Nanotrasen+\" 社交账号不小心发表了暴论",\
		"\"Nanotrasen+\" 的虚拟偶像企划不太成功",\
		"Dlada糟糕的资金管理"
	)
	var/reason = pick(poss_reasons)
	priority_announce("由于 [reason]，站内售货机的价格将在短期内上涨.", "Nanotrasen会计部门")

/datum/round_event/market_crash/start()
	. = ..()
	SSeconomy.update_vending_prices()
	SSeconomy.price_update()
	ADD_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING, MARKET_CRASH_EVENT_TRAIT)

/datum/round_event/market_crash/end()
	. = ..()
	REMOVE_TRAIT(SSeconomy, TRAIT_MARKET_CRASHING, MARKET_CRASH_EVENT_TRAIT)
	SSeconomy.price_update()
	SSeconomy.update_vending_prices()
	priority_announce("站内售货机的价格现在已回落到正常水平.", "Nanotrasen会计部门")

/datum/round_event/market_crash/tick()
	. = ..()
	tick_counter = tick_counter++
	SSeconomy.inflation_value = 5.5*(log(activeFor+1))
	if(tick_counter == 5)
		tick_counter = 1
		SSeconomy.update_vending_prices()
