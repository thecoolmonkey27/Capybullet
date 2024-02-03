Doge = Object.extend(Object)

function Doge:new(x, y)
    self.name = 'Doge'

    self.squishX = 4
    self.x = x
    self.y = y
    self.sx = 4
    self.sy = 4
    self.speed = 150
    self.collider = world:newRectangleCollider(self.x, self.y, 16*4, 32*4)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass('boss')

    --function Gun:new(name, shots, reload, row, spawns, delay, timer, spreadMax, spreadTimeToMax, damage, shootSound)
    self.gun1 = Gun('coin', 6, .5, 4, 1, .4, sounds.glock.shoot)
    self.spritesheet = love.graphics.newImage('sprites/doge-spritesheet.png')
    self.grid = anim8.newGrid(32, 32, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.maxHealth = 150
    self.health = 150
    self.healthQuad = love.graphics.newQuad(0, 52, 103, 7, uiSpritesheet)

    self.stateTimerMax = 3
    self.stateTimer = 3

    self.one = {
        bullets = {},
        speed = 900,
        quad = love.graphics.newQuad(0, 128, 16, 16, self.spritesheet),
        delays = {
            max = .15,
            current = .15
        }
    }
    self.two = {
        speed = 600,
            max = .7,
        quad = love.graphics.newQuad(0, 144, 16, 16, self.spritesheet),
        bullets = {},
        delays = {
            max = .7,
            current = .7
        }
    }
    self.three = {
        angle = 0,
        speed = 700,
        quad = love.graphics.newQuad(0, 144, 16, 16, self.spritesheet),
        bullets = {},
        delays = {
            max = .05,
            current = .05
        }
    }
    

    self.facing = 'left'
    self.animations = {}
    
    self.animations.walkLeft = anim8.newAnimation(self.grid('1-4', 4), .125)
    self.animations.walkRight = anim8.newAnimation(self.grid('1-4', 3), .125)
    self.animations.idleLeft = anim8.newAnimation(self.grid('1-5', 2), .125)
    self.animations.idleRight = anim8.newAnimation(self.grid('1-5', 1), .125)
    self.animations.rollLeft = anim8.newAnimation(self.grid('1-8', 5), .15)
    self.animations.rollRight = anim8.newAnimation(self.grid('1-8', 6), .15)

    self.nameQuad = love.graphics.newQuad(0, 160, 48, 16, self.spritesheet)
    self.captionQuad = love.graphics.newQuad(0, 176, 128, 16, self.spritesheet)
    self.imageQuad = love.graphics.newQuad(0, 0, 32, 32, self.spritesheet)

    -- shoot, walk, roll
    self.state = 'walk'
    self.states = {'walk', 'one', 'two', 'three'}
    self.statekey = 1
    self.gunAngle = 0 
end

function Doge:update(dt, p, i)
    self.x = self.collider:getX()
    self.y = self.collider:getY()

    self.animations.walkLeft:update(dt)
    self.animations.walkRight:update(dt)
    self.animations.idleLeft:update(dt)
    self.animations.idleRight:update(dt)
    self.animations.rollLeft:update(dt)
    self.animations.rollRight:update(dt)

    self:updateState(dt)

    if self.state == 'walk' then
        
    elseif self.state == 'one' then
        self:attackOne(dt, p)
    elseif self.state == 'two' then
        self:attackTwo(dt, p)
    elseif self.state == 'three' then
        self:attackThree(dt, p)
    end
    self:walk(dt, p, i)

    for k,bullet in pairs(self.one.bullets) do
        if bullet:enter('player') then
            bullet:destroy()
            table.remove(self.one.bullets, k)

            p:damage(.5)
        end
    end
    for k,bullet in pairs(self.two.bullets) do
        if bullet:enter('player') then
            bullet:destroy()
            table.remove(self.two.bullets, k)

            p:damage(2)
        elseif bullet:enter('wall') then
            bullet:destroy()
            table.remove(self.two.bullets, k)
        end
    end
    for k,bullet in pairs(self.three.bullets) do
        bullet:setAngle(bullet:getAngle() + dt * 4)
        if bullet:enter('player') then
            bullet:destroy()
            table.remove(self.three.bullets, k)

            p:damage(.5)
        elseif bullet:enter('wall') then
            bullet:destroy()
            table.remove(self.three.bullets, k)
        end
    end
end

function Doge:updateState(dt)
    self.stateTimer = self.stateTimer - dt
    if self.stateTimer < 0 then
        self.stateTimer = self.stateTimerMax
        self.statekey = self.statekey + 1
        if self.states[self.statekey] ~= nil then
            self.state = self.states[self.statekey]
            self.collider:setLinearVelocity(0, 0)
        else
            self.statekey = 1
            self.state = self.states[self.statekey]
            self.collider:setLinearVelocity(0, 0)
        end
    end
end

function Doge:walk(dt, p, i)
    local cx, cy = 0,0
    if self.x > p.x + 20 then
        cx = cx - 1
    elseif self.y < p.x - 20 then
        cx = cx + 1
    end
    if self.y > p.y + 20 then
        cy = cy - 1
    elseif self.y < p.y - 20 then
        cy = cy + 1
    end

    if cx < 0 then
        self.facing = 'left'
    elseif cx > 0 then
        self.facing = 'right'
    end

    if cy ~= 0 and cx ~= 0 then
        cy = cy * .7
        cx = cx * .7
    end
    self.collider:setLinearVelocity(self.speed * cx, self.speed * cy)
end

function Doge:attackOne(dt, p)
    local dx = p.x - self.x
    local dy = p.y - self.y
    local angle = -math.atan2(dx, dy) + math.pi / 2
    local speed = self.one.speed
    local scale = 200
    self.one.delays.current = self.one.delays.current - dt
    if self.one.delays.current < 0 then
        self:playSound(sounds.coin)
        table.insert(self.one.bullets, world:newRectangleCollider(math.random(0, 16*15*4), -20, 32, 4))
        self.one.delays.current = self.one.delays.max
        self.one.bullets[#self.one.bullets]:setCollisionClass('bossBullet')
        self.one.bullets[#self.one.bullets]:setLinearVelocity(0, speed)
    end
end

function Doge:attackTwo(dt, p)
    local dx = p.x - self.x
    local dy = p.y - self.y
    local angle = -math.atan2(dx, dy) + math.pi / 2
    local speed = self.two.speed
    local scale = 200
    self.two.delays.current = self.two.delays.current - dt
    if self.two.delays.current < 0 then
        self:playSound(sounds.grenade.shoot)
        self:recoil()
        table.insert(self.two.bullets, world:newCircleCollider(self.x, self.y + 20, 16))
        self.two.delays.current = self.two.delays.max
        self.two.bullets[#self.two.bullets]:setCollisionClass('bossBullet')
        self.two.bullets[#self.two.bullets]:setLinearVelocity(math.cos(angle)*speed, math.sin(angle)*speed)
        self.two.bullets[#self.two.bullets]:setAngle(angle)
    end
end

function Doge:attackThree(dt, p)
    local dx = p.x - self.x
    local dy = p.y - self.y
    local speed = self.three.speed
    self.three.delays.current = self.three.delays.current - dt
    if self.three.delays.current < 0 then
        self:playSound(sounds.grenade.shoot)
        self:recoil()
        self.three.angle = self.three.angle + math.pi / 4
        table.insert(self.three.bullets, world:newCircleCollider(self.x, self.y + 20, 16))
        self.three.delays.current = self.three.delays.max
        self.three.bullets[#self.three.bullets]:setCollisionClass('bossBullet')
        self.three.bullets[#self.three.bullets]:setLinearVelocity(math.cos(self.three.angle)*speed, math.sin(self.three.angle)*speed)
        self.three.bullets[#self.three.bullets]:setAngle(self.three.angle)
        self.gunAngle = self.three.angle
    end
end

function Doge:draw(p, g)
    if self.state == 'walk' then
        if self.facing == 'right' then
            self.animations.walkRight:draw(self.spritesheet, self.x, self.y, 0, self.squishX, 4, 16, 16)
        else
            self.animations.walkLeft:draw(self.spritesheet, self.x, self.y, 0, self.squishX, 4, 16, 16)
        end
    elseif self.state ~= 'walk' then
        if p.x < self.x then
            self.animations.idleLeft:draw(self.spritesheet, self.x, self.y, 0, self.squishX, 4, 16, 16)
        else
            self.animations.idleRight:draw(self.spritesheet, self.x, self.y, 0, self.squishX, 4, 16, 16)
        end
    end
    local dx = p.x - self.x
    local dy = p.y - self.y
    local r = -math.atan2(dx, dy) + math.pi / 2
    if self.state == 'three' then
        r = self.gunAngle
    end
    self.sx = 4
    self.sy = 4
    if p.x < self.x then
        self.sy = -4
    end
    
    for k,bullet in pairs(self.one.bullets) do
        love.graphics.draw(self.spritesheet, self.one.quad, bullet:getX(), bullet:getY(), bullet:getAngle(), 4, 4, 8, 8)
    end
    for k,bullet in pairs(self.two.bullets) do
        love.graphics.draw(self.spritesheet, self.two.quad, bullet:getX(), bullet:getY(), bullet:getAngle(), 4, 4, 8, 8)
    end
    for k,bullet in pairs(self.three.bullets) do
        love.graphics.draw(self.spritesheet, self.three.quad, bullet:getX(), bullet:getY(), bullet:getAngle(), 4, 4, 8, 8)
    end


    local ox, oy = self.gun1.offsetX * math.cos(r), self.gun1.offsetX * math.sin(r)
    local oa = 0
    if r > math.pi/2 then
        oa = self.gun1.offsetY * -1
    else
        oa = self.gun1.offsetY
    end


    love.graphics.draw(gunSpritesheet, self.gun1.sprite, self.x - ox, self.y + 20 - oy, r - oa, self.sx, self.sy, 0, 8)
end

function Doge:drawHealth()
    local ratio = self.health / self.maxHealth
    love.graphics.draw(uiSpritesheet, self.healthQuad, love.graphics.getWidth()/2 - 206, 50, 0, 4, 4)
    love.graphics.setColor(230/255, 69/255, 57/255)
    love.graphics.rectangle('fill', love.graphics.getWidth()/2 - 198, 58, ratio * 392, 12)
    love.graphics.setColor(255/255, 194/255, 161/255)
    love.graphics.rectangle('fill', love.graphics.getWidth()/2 - 198 + ratio * 392, 58, 4, 12)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Doge', love.graphics.getWidth()/2 - 45, 20)
end

function Doge:setState(state)
    self.state = state
end

function Doge:recoil()
    flux.to(self.gun1, .05, {offsetX = 15}):after(self.gun1, .2, {offsetX = 0})
    flux.to(self.gun1, .1, {offsetY = math.pi/8}):after(self.gun1, .2, {offsetY = 0})
end

function Doge:playSound(sound)
    local s = sound:clone()
    s:play()
end