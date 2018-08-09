local anim_spr = {
	attach = function(game_obj, frames_per_cell, animations, start_anim, start_frame_offset)
		game_obj.anim = {
			game_obj = game_obj,
			current_animation = start_anim,
			current_cell = 1,
			frames_per_cell = frames_per_cell,
			current_frame = 1 + start_frame_offset,
			animations = animations,
			loop = true,
		}

		return game_obj
	end,

	update = function(anim)
		anim.current_frame += 1
		if (anim.current_frame > anim.frames_per_cell) then
			anim.current_frame = 1

			if (anim.current_animation != nil and anim.current_cell != nil) then
				anim.current_cell += 1
				if (anim.current_cell > #anim.animations[anim.current_animation]) then
					if anim.loop then
						anim.current_cell = 1
					else
						anim.current_cell = #anim.animations[anim.current_animation]
					end
				end
			end
		end

		if (anim.game_obj.renderable and anim.current_animation != nil and anim.current_cell != nil) then
			anim.game_obj.renderable.sprite = anim.animations[anim.current_animation][anim.current_cell]
		elseif (anim.game_obj.renderable) then
			anim.game_obj.renderable.sprite = nil
		end
	end,

	set_anim = function(anim, animation)
		if anim.current_animation != animation then
			anim.current_frame = 0
			anim.current_cell = 1
			anim.current_animation = animation
		end
	end,

	is_player = function(anim)
		return anim.current_animation != nil and anim.current_cell ~= nil and
		   (anim.loop or (not anim.loop and anim.current_cell < #anim.animations[anim.current_animation]))
	end
}

return anim_spr
