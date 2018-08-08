v2 = require('v2')

local collider = {
	attach = function(game_obj, anchor_x, anchor_y, w, h)
        local c = {
            game_obj = game_obj,
            anchor_x = anchor_x,
            anchor_y = anchor_y,
            w = w,
            h = h
        }

        c.get_anchor = function(self)
        	return v2.mk(self.col.game_obj.x + self.col.anchor_x, self.col.game_obj.y + self.col.anchor_y)
        end

        game_obj.col = c
        return game_obj
    end
}
return collider
