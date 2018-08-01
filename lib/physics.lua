local physics = {
	check_collision = function(o1_x, o1_y, o1_w, o1_h, o2_x, o2_y, o2_w, o2_h)
		log.syslog(o1_x..","..o1_y.." - "..o2_x..","..o2_y)
		log.syslog(o1_w..","..o1_h.." - "..o2_w..","..o2_h)
		if  ((o1_x >= o2_x and o1_x <= (o2_x + o2_w)) or
			((o1_x + o1_w) >= o2_x and o1_x + o1_w <= (o2_x + o2_w))) and
			((o1_y >= o2_y and o1_y <= (o2_y + o2_h)) or
			((o1_y + o1_h) >= o2_y and o1_y + o1_h <= (o2_y + o2_h))) then
			return true
		else
			return false
		end
	end
}
return physics
