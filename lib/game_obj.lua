local game_obj = {
    mk = function(name, pos_x, pos_y)
        local g = {
            name = name,
            x = pos_x,
            y = pos_y,
        }
        g.update = function()
        end

        return g
    end
}
return game_obj
