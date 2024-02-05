function love.load()
    require 'math'
    scale = 4
    love.graphics.setDefaultFilter('nearest', 'nearest')
    font = love.graphics.newFont('comicsans.ttf', 20)
    fontBig = love.graphics.newFont('comicsans.ttf', 30)
    love.graphics.setFont(font)
    shake = {
        x = 1,
        y = 1
    }
    love.graphics.setBackgroundColor(79/255, 164/255, 184/255, 1)

    gunSpritesheet = love.graphics.newImage('sprites/guns-spritesheet.png')
    uiSpritesheet = love.graphics.newImage('sprites/ui-spritesheet.png')

    sounds = {
        shotgun = {
            shoot = love.audio.newSource('sounds/shotgun-shoot.mp3', 'static')
        },
        glock = {
            shoot = love.audio.newSource('sounds/glock-shoot.mp3', 'static')
        },
        wand = {
            shoot = love.audio.newSource('sounds/wand-shoot.mp3', 'static')
        },
        player = {
            hit = love.audio.newSource('sounds/hit.mp3', 'static')
        },
        grenade = {
            shoot = love.audio.newSource('sounds/grenade-shoot.mp3', 'static')
        },
        coin = love.audio.newSource('sounds/coin.mp3', 'static'),
        bossHurt = love.audio.newSource('sounds/bossHurt.wav', 'static'),
        alert = {
            sound = love.audio.newSource('sounds/alert.mp3', 'static'),
            pitch = 1.6
        },
        music = {
            boss = love.audio.newSource('sounds/bossMusic.mp3', 'static'),
            pitch = .9,
            volume = .7
        }
    }
    sounds.glock.shoot:setVolume(.7)

    Object = require 'libraries/classic'
    require 'scripts/player'
    require 'scripts/inventory'
    require 'scripts/button'
    require 'scripts/pepe'

    require 'scripts/exchange'
    require 'scripts/doge'
    require 'scripts/man'
    
    -- WINDFIELD
    wf = require 'libraries/windfield'
    world = wf.newWorld()
    world:addCollisionClass('player')
    world:addCollisionClass('boss', {ignores = {'player', 'boss'}})
    world:addCollisionClass('wall')
    world:addCollisionClass('playerBullet', {ignores = {'player', 'boss', 'wall', 'playerBullet'}})
    world:addCollisionClass('bossBullet', {ignores = {'player', 'boss', 'wall', 'playerBullet', 'bossBullet'}})
    

    -- ANIM8
    anim8 = require 'libraries/anim8'

    player = Player(100, 100)
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
    if gameMap.layers['green'] then
        for i, obj in pairs(gameMap.layers['wall'].objects) do
            green = {}
            table.insert(green, {
                x = obj.x, 
                y = obj.y, 
                width = obj.width, 
                height = obj.height,
            })
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
    tx = love.graphics.getWidth() / 2 - 64*4 + 16
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

    bosskey = 1
    bosstimer = 5


    screenTimer = 3
    title = {
        targetX = 300,
        targetY = 50,
        x = -600,
        y = 50,
        returnX = -600,
        returnY = 50,
    }
    caption = {
        targetX = 300,
        targetY = 200,
        x = love.graphics.getWidth() + 100,
        y = 200,
        returnX = love.graphics.getWidth() + 100,
        returnY = 200,
    }
    image = {
        targetX = 20,
        targetY = 200,
        x = -400,
        y = 200,
        returnX = -400,
        returnY = 200,
    }
    background = {
        targetX = 0,
        targetY = 0,
        x = 0,
        y = -1000,    
        returnX = 0,
        returnY = -1000,
    }
    curtainLeft = {
        targetX = 0,
        targetY = 0,
        x = -love.graphics.getWidth()/2,
        y = 0,
        returnX = -love.graphics.getWidth()/2,
        returnY = 0,
    }
    curtainRight= {
        targetX = love.graphics.getWidth()/2,
        targetY = 0,
        x = love.graphics.getWidth() + love.graphics.getWidth()/2,
        y = 0,
        returnX = love.graphics.getWidth() + love.graphics.getWidth()/2,
        returnY = 0,
    }
    youDied = {
        targetX = love.graphics.getWidth()/2 - 80,
        targetY = love.graphics.getHeight()/2,
        x = love.graphics.getWidth()/2 - 60,
        y = -100,
        returnX = love.graphics.getWidth()/2 - 80,
        returnY = -100,
    }
end
 
function nextText()
    textkey = textkey + 1
    if textkey <= #textTable then
        textbox:send(textTable[textkey])
        space.opacity = 0
    else
        gamestate = 'game'
        love.graphics.setFont(fontBig)
    end
end

function tweenBossScreen()
    gamestate = 'bossScreen'
    flux.to(title, .6, {x = title.targetX, y = title.targetY}):after(title, .4, {x = title.returnX, y = title.returnY}):delay(2)
    flux.to(background, .3, {x = background.targetX, y = background.targetY}):after(background, .4, {x = background.returnX, y = background.returnY}):delay(2.4)
    flux.to(image, .6, {x = image.targetX, y = image.targetY}):after(image, .4, {x = image.returnX, y = image.returnY}):delay(2)
    flux.to(caption, .6, {x = caption.targetX, y = caption.targetY}):after(caption, .4, {x = caption.returnX, y = caption.returnY}):delay(2):oncomplete(function() gamestate = 'game' end)
    flux.to(sounds.music, .1, {volume = .4}):after(sounds.music, .1, {volume = .7}):delay(3)
end

function nextBoss(dt)
    if boss == nil then
        if bosstimer < 0 then
            if bosskey == 1 then
                boss = Pepe(200, 200)
                bosstimer = 5
                screenTimer = 3
                tweenBossScreen()
            elseif bosskey == 2 then
                boss = Doge(50, 50)
                bosstimer = 5
                screenTimer = 3
                tweenBossScreen()
            elseif bosskey == 3 then
                boss = Man(50, 50)
                bosstimer = 5
                screenTimer = 3
                tweenBossScreen()
            end
        else
            bosstimer = bosstimer - dt
        end
    end
end

function love.update(dt)
    if not sounds.music.boss:isPlaying() then
        sounds.music.boss:play()
    end
    sounds.music.boss:setPitch(sounds.music.pitch)
    sounds.music.boss:setVolume(sounds.music.volume)
    
    mouseX, mouseY = love.mouse.getPosition()
    mx,my = cam:mousePosition()
    flux.update(dt)
    timer.update(dt)
    screenTimer = screenTimer - dt
    if space.opacity == 1 then
        flux.to(space, space.time, {opacity = 0}):ease('linear'):after(space, space.time, {opacity = 1}):ease('linear')
    end
    if gamestate == 'game'then

        
        nextBoss(dt)
        flux.to(camZoom, 1, {zoom = 1})
        cam:zoomTo(camZoom.zoom)
        mx, my = cam:mousePosition()
    
        player:update(dt, gameMap)
        if boss ~= nil and screenTimer < 0 then
            boss:update(dt, player, inventory)
        end
        midpointX, midpointY = player.x, player.y
        if boss ~= nil then
            midpointX, midpointY = (player.x + boss.x) / 2, (player.y + boss.y) / 2
            if math.sqrt(math.abs(boss.x - player.x)^2 + math.abs(boss.y - player.y)^2) > 400 then
                local dx = boss.x - player.x
                local dy = boss.y - player.y
                local hyp = math.sqrt(math.abs(boss.x - player.x)^2 + math.abs(boss.y - player.y)^2)
                local nx = dx/hyp
                local ny = dy/hyp
                midpointX = player.x + 200 * nx
                midpointY = player.y + 200 * ny
            end
        end

        cam:lockPosition(math.floor(midpointX + .5), math.floor(midpointY + .5), cam.smooth.damped(2))

        --function Gun:new(name, shots, reload, row, spawns, delay, timer, spreadMax, spreadTimeToMax, damage, shootSound)
        if boss ~= nil and boss.health < 0 then
            boss.collider:destroy()
            boss = nil
            gamestate = 'exchange'
            bosstimer = 5
            if bosskey == 1 then
                exchange = Exchange(Gun('wand', 12, .6, 3, 1, .1, .7, 200, .2, 1, sounds.wand.shoot), inventory)
            elseif bosskey == 2 then 
                exchange = Exchange(Gun('grenade', 1, .4, 4, 1, .1, 1, 0,  0, 4, sounds.grenade.shoot), inventory)
            elseif bosskey == 3 then
                boss = nil
                bosskey = 0
                player.health = player.maxHealth
                gamestate = 'bossScreen'
                flux.to(curtainLeft, .6, {x = curtainLeft.targetX, y = curtainLeft.targetY}):oncomplete(function() player.collider:setPosition(200,200) end):after(curtainLeft, .3, {x = curtainLeft.returnX, y = curtainLeft.returnY}):delay(2):oncomplete(function() gamestate = 'tutorial' end)
                flux.to(curtainRight, .6, {x = curtainRight.targetX, y = curtainRight.targetY}):oncomplete(function() player.collider:setPosition(200,200) end):after(curtainRight, .3, {x = curtainRight.returnX, y = curtainRight.returnY}):delay(2)
                textkey = 1
                textbox:send('You killed off all the memes.')
                textTable = {
                    '[rainbow][bounce]Thanks for playing![/rainbow][/bounce]',
                    '[rainbow][bounce]Thanks for playing![/rainbow][/bounce]',
                    'Click space to play again.',
                }
            end
            bosskey = bosskey + 1
        end

        inventory:update(dt, player, boss, 'playerBullet')
        world:update(dt)
    end
    if gamestate == 'exchange' then
        exchange:update(dt)
    end
    textbox:update(dt)

    if gamestate == 'game' then
        if player.health <= 0 then
            boss = nil
            bosskey = 1
            player.health = player.maxHealth
            gamestate = 'bossScreen'

            inventory = Inventory()
            flux.to(curtainLeft, .6, {x = curtainLeft.targetX, y = curtainLeft.targetY}):oncomplete(function() player.collider:setPosition(50,50) end):after(curtainLeft, .3, {x = curtainLeft.returnX, y = curtainLeft.returnY}):delay(2):oncomplete(function() gamestate = 'game' end)
            flux.to(curtainRight, .6, {x = curtainRight.targetX, y = curtainRight.targetY}):oncomplete(function() player.collider:setPosition(50,50) end):after(curtainRight, .3, {x = curtainRight.returnX, y = curtainRight.returnY}):delay(2)
            flux.to(youDied, .6, {x = youDied.targetX, y = youDied.targetY}):oncomplete(function() player.collider:setPosition(50,50) end):after(youDied, .3, {x = youDied.returnX, y = youDied.returnY}):delay(2)
        end
    end
end

function love.draw()

    
    if gamestate == 'game' or gamestate == 'tutorial' or gamestate == 'exchange' or gamestate == 'bossScreen'then
        love.graphics.push()
        love.graphics.translate(shake.x, shake.y)
        cam:attach()
            love.graphics.push()
            love.graphics.scale(4, 4)
            
            love.graphics.setColor(59/255, 125/255, 79/255)
            love.graphics.rectangle("fill", 1, 1, 238, 238)
            love.graphics.setColor(1, 1, 1, 1)
                
            gameMap.layers.floor:draw()
            love.graphics.pop()
            if boss ~= nil and screenTimer < 0 then
                boss:draw(player)
            end
            player:draw()
            
            inventory:drawGuns(player)
        cam:detach()
        love.graphics.pop()
        inventory:drawUi()
        player:drawHealth()
        if boss ~= nil and gamestate ~= 'bossScreen' then
            boss:drawHealth()
        end
    end

    if gamestate == 'tutorial' then
        love.graphics.draw(uiSpritesheet, tq, love.graphics.getWidth()/2 - 64*4, ty - 20, 0, 4, 4)
        textbox:draw(tx, ty)

        if textbox:is_finished() then
            love.graphics.setColor(1, 1, 1, space.opacity)
            love.graphics.draw(uiSpritesheet, space.quad, love.graphics.getWidth()/2 + 64*4 - 44, ty + 10, 0, 4, 4)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    if boss == nil and gamestate == 'game' then
        love.graphics.print(tostring(math.ceil(bosstimer)), love.graphics.getWidth() / 2, 10)
    end

    love.graphics.setColor(0, 0, 0, fadetoblack.var)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)

    if boss ~= nil then
        love.graphics.setColor(64/255, 73/255, 115/255, 1)
        love.graphics.rectangle('fill', background.x, background.y, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(boss.spritesheet, boss.imageQuad, image.x, image.y, -math.pi/16, 12, 12)
        love.graphics.draw(boss.spritesheet, boss.nameQuad, title.x, title.y, 0, 8, 8)
        love.graphics.draw(boss.spritesheet, boss.captionQuad, caption.x, caption.y, 0, 4, 4)
        
    end
    if gamestate == 'exchange' then
        love.graphics.setColor(0, 0, 0, .5)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
        exchange:draw()
    end

    love.graphics.setColor(33/255, 24/255, 27/255)
    love.graphics.rectangle('fill', curtainLeft.x, curtainLeft.y, love.graphics.getWidth()/2, love.graphics.getHeight())
    love.graphics.rectangle('fill', curtainRight.x, curtainRight.y, love.graphics.getWidth()/2, love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('You Died :(', youDied.x, youDied.y)
end

function love.mousepressed(x, y, button, istouch, presses)
    if gamestate == 'game' then 
        if button == 2 and player.rollDelayTimer < 0 then
            player:Roll()
            player.rollDelayTimer = player.rollDelayTimerMax
        end
    elseif gamestate == 'exchange' then
        if button == 1 then
            exchange:clicked(x, y)
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
    elseif gamestate == 'exchange' then
        if key == 'tab' or key == 'enter' then
            gamestate = 'game'
            inventory.table[1] = exchange.table[exchange.inventory1].gun
            inventory.table[2] = exchange.table[exchange.inventory2].gun
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