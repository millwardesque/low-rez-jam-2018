collider = require('collider')
game_obj = require('game_obj')
renderer = require('renderer')

local flag = {
	mk = function(name, x, y, palette)
	    local f = game_obj.mk(name, 'flag', x, y)
        renderer.attach(f, 16)
        f.renderable.draw_order = 1

        f.start_x = x
        f.start_y = y

        if palette ~= nil then
        	f.renderable.palette = palette
        end

	    collider.attach(f, 0, 0, 8, 8)

	    f.pickup_flag = function(self)
	    	self.renderable.enabled = false
	    	sfx(0)
		end

	    f.reset_flag = function(self)
	    	self.x = self.start_x
	    	self.y = self.start_y
	    	self.renderable.enabled = true
	    	sfx(1)
    	end

	    return f
	end
}

return flag
