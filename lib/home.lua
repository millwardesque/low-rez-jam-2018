collider = require('collider')
game_obj = require('game_obj')
renderer = require('renderer')

local home = {
	mk = function(name, x, y, palette)
	    local h = game_obj.mk(name, 'home', x, y)
        renderer.attach(h, 80)
        h.renderable.draw_order = 0

        if palette ~= nil then
        	h.renderable.palette = palette
        end

	    collider.attach(h, 0, 0, 8, 8)

	    return h
	end
}

return home
