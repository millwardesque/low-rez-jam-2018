collider = require('collider')
game_obj = require('game_obj')
renderer = require('renderer')
v2 = require('v2')

local player = {
	mk = function(name, controller, x, y, palette)
	    local p = game_obj.mk(name, 'player', x, y)
	    renderer.attach(p, 1)
	    p.controller = controller
	    p.vel = v2.mk(0, 0)
	    p.speed = 1
	    p.has_flag = false
	    p.renderable.draw_order = 2
	    p.renderable.palette = palette

	    collider.attach(p, 2, 5, 4, 3)

	    p.pickup_flag = function(self, flag)
	    	self.has_flag = true
	    	self.renderable.sprite = 3

	    	self.flag = flag
	    	self.flag.pickup_flag(self.flag)
	   	end

	   	p.drop_flag = function(self)
	   		self.has_flag = false
	   		self.renderable.sprite = 1

	   		self.flag.reset_flag(self.flag)
	   		self.flag = nil
	   	end

	    p.update = function (self)
		    self.vel = v2.mk(0, 0)

		    if btn(0, self.controller) then
		        self.vel.x -= self.speed
		    end

		    if btn(1, self.controller) then
		        self.vel.x += self.speed
		    end

		    if btn(2, self.controller) then
		        self.vel.y -= self.speed
		    end

		    if btn(3, self.controller) then
		        self.vel.y += self.speed
		    end

		    self.x += self.vel.x
		    self.y += self.vel.y

		    if self.vel.x < 0 then
		        self.renderable.flip_x = true
		    elseif self.vel.x > 0 then
		        self.renderable.flip_x = false
		    end
		end

	    return p
	end
}

return player
