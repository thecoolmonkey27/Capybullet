function love.load()
    require 'math'
    scale = 4
    love.graphics.setDefaultFilter('nearest', 'nearest')
    font = love.graphics.newFont('bongo.ttf', 13)
    love.graphics.setFont(font)
    shake = {
        x = 1,
        y = 1
    }

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
    require 'scripts/button'
    require 'scripts/pepe'
    
    -- WINDFIELD
    wf = require 'libraries/windfield'
    world = wf.newWorld()
    world:addCollisionClass('player')
    world:addCollisionClass('boss', {ignores = {'player'}})
    world:addCollisionClass('wall')
    world:addCollisionClass('playerBullet', {ignores = {'player', 'boss', 'wall', 'playerBullet'}})
    world:addCollisionClass('bossBullet', {ignores = {'player', 'boss', 'wall', 'playerBullet', 'bossBullet'}})
    

    -- ANIM8
    anim8 = require 'libraries/anim8'

    player = Player(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    inventory = Inventory()
    boss = nil

    -- TILED
    sti = require 'libraries/Simple-Tiled-Implementation-master/sti'
    gameMap = sti('maps/map.lua')

    -- TWEENING
    flux = require 'libraries/flux'
    timer = require 'libraries/timer'

    if gameMap.layers['wall'] then
        for i, obj in pairs(gameMap.layers['wall'].objects) do
            local wall = world:newRectangleCollider(obj.x * scale, obj.y * scale, obj.width * scale, obj.height * scale)
            wall:setType('static')
            wall:setCollisionClass('wall')
        end
    end

    -- CAMERA
    camera = require 'libraries/camera'
    cam = camera(player.x, player.y)
    cam:zoomTo(3)
    camZoom = {zoom = 3}

    gamestate = 'tutorial'
    start = Button(love.graphics.getWidth() /2, love.graphics.getHeight() / 2, 64, 32, 0)
    startQuad = love.graphics.newQuad(0, 16, 64, 32, uiSpritesheet)
    fadetoblack = {}
    fadetoblack.var = 0

    -- TEXT
    Text = require 'libraries/text'

    textbox = Text.new("left", 
    { 
        color = {1,1,1,1}, 
        shadow_color = {0.5,0.5,1,0.4}, 
        font = font,
        character_sound = false, 
        print_speed = 0.02,
        adjust_line_height = -3
        })
    textbox:send('Welcome to Capybullet')
    tx = love.graphics.getWidth() / 2 - 64*4 + 10
    ty = 50
    tq = love.graphics.newQuad(0, 80, 128, 16, uiSpritesheet)

    textTable = {
        'Move around with [u]WASD[/u]',
        'Shoot with [u]left click[/u]',
        'Dash with [u]right click[/u]',
        '[rainbow][bounce]Exchange[/rainbow][/bounce] weapons with fallen bosses'
    }
    textkey = 0
    space = {}
    space.time = .8
    space.opacity = 1
    space.quad = love.graphics.newQuad(116, 102, 8, 5, uiSpritesheet)
end
 
function nextText()
    textkey = textkey + 1
    if textkey <= #textTable then
        textbox:send(textTable[textkey])
    else
        gamestate = 'game'
    end
end
function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    mx,my = cam:mousePosition()
    flux.update(dt)
    timer.update(dt)
    if space.opacity == 1 then
        flux.to(space, space.time, {opacity = 0}):ease('linear'):after(space, space.time, {opacity = 1}):ease('linear')
    end
    if gamestate == 'game'then
        flux.to(camZoom, 1, {zoom = 1})
        cam:zoomTo(camZoom.zoom)
        mx, my = cam:mousePosition()
    
        player:update(dt, gameMap)
        if boss ~= nil then
            boss:update(dt, player, inventory)
        end
        if boss ~= nil then
            local midpointX, midpointY = (player.x + boss.x) / 2, (player.y + boss.y) / 2
            if math.sqrt(math.abs(boss.x - player.x)^2 + math.abs(boss.y - player.y)^2) > 400 then
                local dx = boss.x - player.x
                local dy = boss.y - player.y
                local hyp = math.sqrt(math.abs(boss.x - player.x)^2 + math.abs(boss.y - player.y)^2)
                local nx = dx/hyp
                local ny = dy/hyp
                midpointX = player.x + 200 * nx
                midpointY = player.y + 200 * ny
            end
        else
            midpointX, midpointY = player.x, player.y
        end


        cam:lockPosition(math.floor(midpointX + .5), math.floor(midpointY + .5), cam.smooth.damped(2))

        inventory:update(dt, player, boss, 'playerBullet')
        world:update(dt)
    end
    if gamestate == 'tutorial' then
        
    end
    textbox:update(dt)
end

function love.draw()

    
    if gamestate == 'game' or 'tutorial'then
        love.graphics.push()
        love.graphics.translate(shake.x, shake.y)
        cam:attach()
            love.graphics.push()
            love.graphics.scale(4, 4)
            gameMap.layers.floor:draw()
            love.graphics.pop()
            if boss ~= nil then
                boss:draw(player)
            end
            player:draw()
            inventory:drawGuns(player)
            world:draw()
        cam:detach()
        love.graphics.pop()
        inventory:drawUi()
        player:drawHealth()
        if boss ~= nil then
            boss:drawHealth()
        end
        
    end

    if gamestate == 'tutorial' then
        love.graphics.draw(uiSpritesheet, tq, love.graphics.getWidth()/2 - 64*4, ty - 20, 0, 4, 4)
        textbox:draw(tx, ty)

        if textbox:is_finished() then
            love.graphics.setColor(1, 1, 1, space.opacity)
            love.graphics.draw(uiSpritesheet, space.quad, love.graphics.getWidth()/2 + 64*4 - 40, ty + 10, 0, 4, 4)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    love.graphics.setColor(0, 0, 0, fadetoblack.var)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function love.mousepressed(x, y, button, istouch, presses)
    if gamestate == 'game' then 
        if button == 2 and player.rollDelayTimer < 0 then
            player:Roll()
            player.rollDelayTimer = player.rollDelayTimerMax
        end
    end
end

function love.mousereleased(x, y, button, istouch)
    
end

function love.keypressed(key, scancode, isrepeat)
    if gamestate == 'game' then
        if key == '1' then
            inventory:select(1)
        elseif key == '2' then
            inventory:select(2)
        elseif key == 'r' then
            inventory.table[inventory.selected]:reload()
        end
    elseif gamestate == 'tutorial' then
        if key == 'return' or key == 'space' or key == 'right' then
            if textbox:is_finished() then
                nextText()
            end
        end
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