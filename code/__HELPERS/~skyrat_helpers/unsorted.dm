/atom/proc/do_jiggle(targetangle = 45, timer = 20)
	var/matrix/OM = matrix(transform)
	var/matrix/M = matrix(transform)
	var/halftime = timer * 0.5
	M.Turn(pick(-targetangle, targetangle))
	animate(src, transform = M, time = halftime, easing = ELASTIC_EASING)
	animate(src, transform = OM, time = halftime, easing = ELASTIC_EASING)

/atom/proc/do_squish(squishx = 1.2, squishy = 0.6, timer = 20)
	var/matrix/OM = matrix(transform)
	var/matrix/M = matrix(transform)
	var/halftime = timer * 0.5
	M.Scale(squishx, squishy)
	animate(src, transform = M, time = halftime, easing = BOUNCE_EASING)
	animate(src, transform = OM, time = halftime, easing = BOUNCE_EASING)

/** Get all hearers in range, ignores walls and such. Code stolen from `/proc/get_hearers_in_view()`
 * Much faster and less expensive than range()
*/
/proc/get_hearers_in_looc_range(atom/source, range_radius = LOOC_RANGE)
	var/turf/center_turf = get_turf(source)
	if(!center_turf)
		return

	. = list()
	var/old_luminosity = center_turf.luminosity
	if(range_radius <= 0) //special case for if only source cares
		for(var/atom/movable/target as anything in center_turf)
			var/list/recursive_contents = target.important_recursive_contents?[RECURSIVE_CONTENTS_HEARING_SENSITIVE]
			if(recursive_contents)
				. += recursive_contents
		return .

	var/list/hearables_from_grid = SSspatial_grid.orthogonal_range_search(source, RECURSIVE_CONTENTS_HEARING_SENSITIVE, range_radius)

	if(!length(hearables_from_grid))//we know that something is returned by the grid, but we dont know if we need to actually filter down the output
		return .

	var/list/assigned_oranges_ears = SSspatial_grid.assign_oranges_ears(hearables_from_grid)

	for(var/mob/oranges_ear/ear in range(range_radius, center_turf))
		. += ear.references

	for(var/mob/oranges_ear/remaining_ear as anything in assigned_oranges_ears) //we need to clean up our mess
		remaining_ear.unassign()

	center_turf.luminosity = old_luminosity
	return .

///This will check if SSaccessories.sprite_accessories[mutant_part]?[part_name] is associated with sprite accessory with factual TRUE.
/proc/is_factual_sprite_accessory(mutant_part, part_name)
	if(!mutant_part || !part_name)
		return FALSE
	var/datum/sprite_accessory/accessory = SSaccessories.sprite_accessories[mutant_part]?[part_name]
	return accessory?.factual

/**
 * Get a list of turfs in a line from `M` to `N`.
 *
 * Uses the ultra-fast [Bresenham Line-Drawing Algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm).
 */
/proc/getline(atom/M,atom/N)
	var/px=M.x		//starting x
	var/py=M.y
	var/line[] = list(locate(px,py,M.z))
	var/dx=N.x-px	//x distance
	var/dy=N.y-py
	var/dxabs = abs(dx)//Absolute value of x distance
	var/dyabs = abs(dy)
	var/sdx = SIGN(dx)	//Sign of x distance (+ or -)
	var/sdy = SIGN(dy)
	var/x=dxabs>>1	//Counters for steps taken, setting to distance/2
	var/y=dyabs>>1	//Bit-shifting makes me l33t.  It also makes getline() unnessecarrily fast.
	var/j			//Generic integer for counting
	if(dxabs>=dyabs)	//x distance is greater than y
		for(j=0;j<dxabs;j++)//It'll take dxabs steps to get there
			y+=dyabs
			if(y>=dxabs)	//Every dyabs steps, step once in y direction
				y-=dxabs
				py+=sdy
			px+=sdx		//Step on in x direction
			line+=locate(px,py,M.z)//Add the turf to the list
	else
		for(j=0;j<dyabs;j++)
			x+=dxabs
			if(x>=dyabs)
				x-=dyabs
				px+=sdx
			py+=sdy
			line+=locate(px,py,M.z)
	return line
