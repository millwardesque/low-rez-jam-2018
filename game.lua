log = require('log')
game_obj = require('game_obj')
game_cam = require('game_cam')
physics = require('physics')
renderer = require('renderer')

scene = {}
triggers = {}

cam = nil
background = {x = 0, y = 0, w = 16, h = 16}

p1 = game_obj.mk('p1', 20, 10)
renderer.attach(p1, 1)
p1.speed = 1
p1.has_flag = false
p1.renderable.draw_order = 1

flag1 = game_obj.mk('flag', 10, 10)
renderer.attach(flag1, 16)

p2_palette = {0, 1, 2, 3, 4, 5, 6, 7, 8, 8, 10, 11, 12, 13, 14, 15}

p2 = game_obj.mk('p2', 36, 10)
renderer.attach(p2, 1)
p2.speed = 1
p2.has_flag = false
p2.renderable.draw_order = 1
p2.renderable.palette = p2_palette

flag2 = game_obj.mk('flag', 46, 10)
renderer.attach(flag2, 16)
flag2.renderable.palette = p2_palette

function _init()
    log.debug = true

    -- Low-rez jam mode
    poke(0x5f2c, 3)
    screen_dim = 64

    cam = game_cam.mk("main-cam", 0, 0, screen_dim, screen_dim, 16, 16)

    add(scene, cam)

    add(scene, p1)
    add(scene, flag1)

    add(scene, p2)
    add(scene, flag2)

    cam.cam.target = p1
end

function _update()
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

    if physics.check_collision(p1.x, p1.y, 8, 8, flag2.x, flag2.y, 8, 8) then
        p1.has_flag = true
        flag2.renderable.enabled = false
    end

    if physics.check_collision(p2.x, p2.y, 8, 8, flag1.x, flag1.y, 8, 8) then
        p2.has_flag = true
        flag1.renderable.enabled = false
    end

    log.log("Mem: "..stat(0).." CPU: "..stat(1))
end

function _draw()
    cls()

    renderer.render(cam, scene, background)

    log.render()
end
