local physics = {
	check_collision = function(o1_x, o1_y, o1_w, o1_h, o2_x, o2_y, o2_w, o2_h)
		if  ((o1_x >= o2_x and o1_x <= (o2_x + o2_w)) or
			((o1_x + o1_w) >= o2_x and o1_x + o1_w <= (o2_x + o2_w))) and
			((o1_y >= o2_y and o1_y <= (o2_y + o2_h)) or
			((o1_y + o1_h) >= o2_y and o1_y + o1_h <= (o2_y + o2_h))) then
			return true
		else
			return false
		end
	end,

	check_collision_collidable = function(o1, o2)
		o1_anchor = o1.col.get_anchor(o1)
		o2_anchor = o2.col.get_anchor(o2)
		return physics.check_collision(o1_anchor.x, o1_anchor.y, o1.col.w, o1.col.h, o2_anchor.x, o2_anchor.y, o2.col.w, o2.col.h)
	end
}
return physics
