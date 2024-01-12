function love.load()
    scale = 4
    love.graphics.setDefaultFilter('nearest', 'nearest')
    gunSpritesheet = love.graphics.newImage('sprites/guns-spritesheet.png')
    uiSpritesheet = love.graphics.newImage('sprites/ui-spritesheet.png')

    sounds = {
        shotgun = {
            shoot = love.audio.newSource('sounds/shotgun-shoot.mp3', 'static')
        },
        glock = {
            shoot = love.audio.newSource('sounds/glock-shoot.mp3', 'static')
        }
    }

    Object = require 'libraries/classic'
    require 'scripts/player'
    require 'scripts/inventory'
    require 'math'
    -- WINDFIELD
    wf = require 'libraries/windfield'
    world = wf.newWorld()
    world:addCollisionClass('player')
    world:addCollisionClass('bullet', {ignores = {'player'}})
    world:addCollisionClass('wall')

    -- ANIM8
    anim8 = require 'libraries/anim8'

    player = Player(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    inventory = Inventory()

    -- TILED
    sti = require 'libraries/Simple-Tiled-Implementation-master/sti'
    gameMap = sti('maps/map.lua')

    if gameMap.layers['wall'] then
        for i, obj in pairs(gameMap.layers['wall'].objects) do
            local wall = world:newRectangleCollider(obj.x * scale, obj.y * scale, obj.width * scale, obj.height * scale)
            wall:setType('static')
        end
    end

    -- CAMERA
    camera = require 'libraries/camera'
    cam = camera(player.x, player.y)
end
 
function love.update(dt)
    mx, my = cam:mousePosition()
    
    player:update(dt, gameMap)
    cam:lockPosition(math.floor(player.x + .5), math.floor(player.y + .5), cam.smooth.damped(2))

    inventory:update(dt, player)
    world:update(dt)
end

function love.draw()
    cam:attach()
        love.graphics.push()
        love.graphics.scale(4, 4)
        gameMap.layers.floor:draw()
        love.graphics.pop()
        world:draw()
        player:draw()
        inventory:drawGuns(player)
    cam:detach()
    
    inventory:drawUi()
    player:drawHealth()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 2 then
        player:Roll()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == '1' then
        inventory:select(1)
    elseif key == '2' then
        inventory:select(2)
    elseif key == 'r' then
        inventory.table[inventory.selected]:reload()
    end
end

function love.wheelmoved(x, y)
    if y < 10 or y > 10 then
        if inventory.selected == 1 then
            inventory:select(2)
        else
            inventory:select(1)
        end
    end
end