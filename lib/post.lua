game_obj = require('game_obj')
renderer = require('renderer')

local post = {
	mk = function(name, x, y)
	    local p = game_obj.mk(name, 'post', x, y)
	    renderer.attach(p, 32)
	    p.renderable.draw_order = 2
	    p.active_palette = {0, 12, 2, 3, 4, 5, 6, 7, 8, 10, 9, 11, 1, 13, 14, 15}
	    p.cooldown = 2 * 30
	    p.cooldown_elapsed = 0
	    p.is_active = false

	    p.activate = function(self)
	        self.renderable.palette = self.active_palette
	        self.is_active = true
	        p.cooldown_elapsed = 0
	    end

	    p.deactivate = function(self)
	        self.renderable.palette = nil
	        self.is_active = false
	        self.cooldown_elapsed = 0
	    end

	    p.update = function(self)
	        if self.is_active then
	            if self.cooldown_elapsed >= self.cooldown then
	                self.deactivate(self)
	            else
	                self.cooldown_elapsed += 1
	            end
	        end
	    end

	    return p
	end
}

return post
