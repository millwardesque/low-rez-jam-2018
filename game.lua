log = require('log')
game_obj = require('game_obj')
game_cam = require('game_cam')
physics = require('physics')
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

        p1_home_x = 10
        p1_home_y = 10

        p1 = game_obj.mk('p1', p1_home_x + 8, p1_home_y + 8)
        renderer.attach(p1, 1)
        p1.speed = 1
        p1.has_flag = false
        p1.renderable.draw_order = 2

        flag1 = game_obj.mk('flag1', p1_home_x + 3, p1_home_y - 3)
        renderer.attach(flag1, 16)
        flag1.renderable.draw_order = 1

        home1 = game_obj.mk('home1', p1_home_x, p1_home_y)
        renderer.attach(home1, 80)

        p2_home_x = 46
        p2_home_y = 46
        p2_palette = {0, 1, 4, 3, 2, 5, 6, 7, 9, 8, 14, 11, 12, 13, 10, 15}

        p2 = game_obj.mk('p2', p2_home_x - 8, p2_home_y - 8)
        renderer.attach(p2, 1)
        p2.speed = 1
        p2.has_flag = false
        p2.renderable.draw_order = 2
        p2.renderable.palette = p2_palette

        flag2 = game_obj.mk('flag2', p2_home_x + 3, p2_home_y - 3)
        renderer.attach(flag2, 16)
        flag2.renderable.palette = p2_palette
        flag2.renderable.draw_order = 1

        home2 = game_obj.mk('home2', p2_home_x, p2_home_y)
        renderer.attach(home2, 80)
        home2.renderable.palette = p2_palette

        add(scene, p1)
        add(scene, flag1)
        add(scene, home1)

        add(scene, p2)
        add(scene, flag2)
        add(scene, home2)
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
        rectfill(4, 20, 60, 44, 13)
        rectfill(6, 22, 58, 42, 1)

        color(7)
        print(last_winner.name.." wins!", 16, 29)
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
        if btn(0, 0) then
            p1.x -= p1.speed
        end

        if btn(1, 0) then
            p1.x += p1.speed
        end

        if btn(2, 0) then
            p1.y -= p1.speed
        end

        if btn(3, 0) then
            p1.y += p1.speed
        end

        if btn(0, 1) then
            p2.x -= p2.speed
        end

        if btn(1, 1) then
            p2.x += p2.speed
        end

        if btn(2, 1) then
            p2.y -= p2.speed
        end

        if btn(3, 1) then
            p2.y += p2.speed
        end

        for obj in all(scene) do
            if obj.update then
                obj.update(obj)
            end
        end

        -- Enemy flag capture
        if p1.has_flag == false then
            if physics.check_collision(p1.x, p1.y, 8, 8, flag2.x, flag2.y, 8, 8) then
                p1.has_flag = true
                flag2.renderable.enabled = false
            end
        elseif p1.has_flag and not p2.has_flag then
            if physics.check_collision(p1.x, p1.y, 8, 8, home1.x, home1.y, 8, 8) then
                game_over(p1)
            end
        end

        if p2.has_flag == false then
            if physics.check_collision(p2.x, p2.y, 8, 8, flag1.x, flag1.y, 8, 8) then
                p2.has_flag = true
                flag1.renderable.enabled = false
            end
        elseif p2.has_flag and not p1.has_flag then
            if physics.check_collision(p2.x, p2.y, 8, 8, home2.x, home2.y, 8, 8) then
                game_over(p2)
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
