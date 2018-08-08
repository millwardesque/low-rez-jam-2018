log = require('log')
v2 = require('v2')
game_obj = require('game_obj')
game_cam = require('game_cam')
physics = require('physics')
flag = require('flag')
home = require('home')
player = require('player')
post = require('post')
renderer = require('renderer')

scene = {}
triggers = {}

cam = nil
background = {x = 0, y = 0, w = 16, h = 16}

state = "ingame"
last_winner = nil

p1 = nil
p1_score = 0
flag1 = nil
home1 = nil

p2 = nil
p2_score = 0
flag2 = nil
home2 = nil

function reset_level()
    if state == "ingame" then
        scene = {}
        cam = game_cam.mk("main-cam", 0, 0, screen_dim, screen_dim, 16, 16)
        add(scene, cam)

        -- Player 1 stuff
        p1_home_x = 10
        p1_home_y = 10
        p1 = player.mk('p1', 0, p1_home_x + 8, p1_home_y + 8, nil)
        add(scene, p1)

        flag1 = flag.mk('flag1', p1_home_x + 3, p1_home_y - 3)
        add(scene, flag1)

        home1 = home.mk('home1', p1_home_x, p1_home_y)
        add(scene, home1)

        -- Player 2 stuff
        p2_home_x = 46
        p2_home_y = 46
        p2_palette = {0, 1, 4, 3, 2, 5, 6, 7, 9, 8, 14, 11, 12, 13, 10, 15}

        p2 = player.mk('p2', 1, p2_home_x - 8, p2_home_y - 8, p2_palette)
        add(scene, p2)

        flag2 = flag.mk('flag2', p2_home_x + 3, p2_home_y - 3, p2_palette)
        add(scene, flag2)

        home2 = home.mk('home2', p2_home_x, p2_home_y, p2_palette)
        add(scene, home2)

        -- Electric posts
        add(scene, post.mk('post1', 28, 28))
        add(scene, post.mk('post2', 42, 20))
        add(scene, post.mk('post3', 14, 42))
    elseif state == "game over" then
        scene = {}
        cam = game_cam.mk("main-cam", 0, 0, screen_dim, screen_dim, 16, 16)
        add(scene, cam)
    end
end

function render_ui()
    if state == "ingame" then
        rectfill(0, 0, 64, 7, 0)
        color(7)
        print("P1:"..p1_score, 1, 1)

        score_chars = 3
        if p2_score >= 10 then
            score_chars = 4
        end
        print("P2:"..p2_score, 64 - 1 - (5 * score_chars), 1)
    elseif state == "game over" then
        rectfill(2, 16, 62, 48, 13)
        rectfill(4, 18, 60, 46, 1)

        color(7)
        print(last_winner.name.." wins!", 17, 20)
        print("p1:"..p1_score.." vs. p2:"..p2_score, 7, 30)
        print("press 4 or 5", 9, 40)
    end
end

function game_over(winner)
    if winner == p1 then
        p1_score += 1
    else
        p2_score += 1
    end
    last_winner = winner

    state = "game over"
    reset_level()
end

function _init()
    log.debug = true

    -- Low-rez jam mode
    poke(0x5f2c, 3)
    screen_dim = 64

    state = "ingame"
    reset_level()
end

function _update()
    if state == "ingame" then

        for obj in all(scene) do
            if obj.update then
                obj.update(obj)
            end
        end

        -- Player collision
        if physics.check_collision_collidable(p1, p2) then
            dist = v2.norm(p2.col.get_anchor(p2) - p1.col.get_anchor(p1))
            p1_vel = v2.mk(0, 0)
            p2_vel = v2.mk(0, 0)

            -- If only one player is moving, collision stops that player and pushes the stationary one.
            if v2.mag(p1_vel) > 0 and v2.mag(p2_vel) == 0 then
                p2_vel = dist * 2.0
            elseif v2.mag(p1_vel) == 0 and v2.mag(p2_vel) > 0 then
                p1_vel = dist * -2.0
            else
                p1_vel = dist * -2.0
                p2_vel = dist * 2.0
            end

            p1.x += p1_vel.x
            p1.y += p1_vel.y
            p2.x += p2_vel.x
            p2.y += p2_vel.y
        end

        -- Enemy flag capture
        if p1.has_flag == false then
            if physics.check_collision_collidable(p1, flag2) then
                p1.has_flag = true
                flag2.renderable.enabled = false
            end
        elseif p1.has_flag and not p2.has_flag then
            if physics.check_collision_collidable(p1, home1) then
                game_over(p1)
            end
        end

        if p2.has_flag == false then
            if physics.check_collision_collidable(p2, flag1) then
                p2.has_flag = true
                flag1.renderable.enabled = false
            end
        elseif p2.has_flag and not p1.has_flag then
            if physics.check_collision_collidable(p2, home2) then
                game_over(p2)
            end
        end

        for obj in all(scene) do
            if obj.type == 'post' then
                if physics.check_collision_collidable(p1, obj) then
                    obj.activate(obj)
                    p1.x = 10
                    p1.y = 10
                end

                if physics.check_collision_collidable(p2, obj) then
                    obj.activate(obj)
                    p2.x = 46
                    p2.y = 46
                end
            end
        end

    elseif state == "game over" then
        for i = 4, 5 do
            if btnp(i, 0) or btnp(i, 1) then
                state = "ingame"
                reset_level()
            end
        end
    end

    log.log("Mem: "..stat(0).." CPU: "..stat(1))
end

function _draw()
    cls()

    renderer.render(cam, scene, background)
    render_ui()

    log.render()
end
