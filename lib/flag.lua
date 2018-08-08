collider = require('collider')
game_obj = require('game_obj')
renderer = require('renderer')

local flag = {
	mk = function(name, x, y, palette)
	    local f = game_obj.mk(name, 'flag', x, y)
        renderer.attach(f, 16)
        f.renderable.draw_order = 1

        if palette ~= nil then
        	f.renderable.palette = palette
        end

	    collider.attach(f, 0, 0, 8, 8)

	    return f
	end
}

return flag
