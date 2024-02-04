Man = Object.extend(Object)

function Man:new(x, y)
    self.name = 'Meme Man'
    
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
    self.spritesheet = love.graphics.newImage('sprites/man-spritesheet.png')
    self.grid = anim8.newGrid(32, 32, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.maxHealth = 300
    self.health = 300
    self.healthQuad = love.graphics.newQuad(0, 52, 103, 7, uiSpritesheet)

    self.stateTimerMax = 2
    self.stateTimer = 2
    

    self.facing = 'left'
    self.animations = {}
    
    self.animations.walkLeft = anim8.newAnimation(self.grid('1-1', 4), .125)
    self.animations.walkRight = anim8.newAnimation(self.grid('1-1', 3), .125)
    self.animations.idleLeft = anim8.newAnimation(self.grid('1-5', 2), .125)
    self.animations.idleRight = anim8.newAnimation(self.grid('1-5', 1), .125)

    self.animations.dissolveLeft = anim8.newAnimation(self.grid('1-5', 8), .125)
    self.animations.dissolveRight = anim8.newAnimation(self.grid('1-5', 7), .125)

    self.nameQuad = love.graphics.newQuad(0, 160, 64, 16, self.spritesheet)
    self.captionQuad = love.graphics.newQuad(0, 176, 128, 16, self.spritesheet)
    self.imageQuad = love.graphics.newQuad(0, 0, 32, 32, self.spritesheet)

    -- shoot, walk, roll
    self.isWalking = true
    self.states = {'one', 'two', 'three'}
    self.statekey = 1
    self.gunAngle = 0 

    self.one = {
        hasSplit = false,
        hasDashed = false,
        angle = 0,
        speed = 400,
        colliders = {},
        
        delays = {
            dash = .4,
            dashMax = .4,
            duration = .2,
            durationMax = .2,
        }
    }
    self.two = {
        hasDissolved = false,
        isDissolving = false,
        direction = 'left',
        angle = 0,
        speed = 400,
        bullets = {},
        quads = {
            love.graphics.newQuad(0,128,16,16,self.spritesheet),
            love.graphics.newQuad(16,128,16,16,self.spritesheet),
            love.graphics.newQuad(32,128,16,16,self.spritesheet),
        },
        delays = {
            dissolve = 3,
            swarm = 3,
            reassemble = 3,
        }
    }
    self.three = {
        bullets = {},
        points = {},
        direction = 'left',
        speed = 400,
        delays = {
            shoot = 4
        }
    }
    self.state = self.states[self.statekey]
    self.collider:setLinearVelocity(0, 0)
end

function Man:loadAttackOne()
    self.one = {
        hasSplit = false,
        hasDashed = false,
        angle = 0,
        speed = 400,
        colliders = {},
        delays = {
            split = 2,
            splitMax = 2,
            dash = .4,
            dashMax = .4,
            duration = .8,
            durationMax = .8,
        }
    }
end

function Man:loadAttackTwo(p)

    self.animations.dissolveLeft:gotoFrame(1)
    self.animations.dissolveRight:gotoFrame(1)

    local offset = 600

    self.two = {
        targetX = self.x + (math.cos(self.two.angle) * offset),
        targetY = self.x + (math.sin(self.two.angle) * offset),
        hasDissolved = false,
        isDissolving = false,
        direction = 'left',
        angle = 0,
        speed = 400,
        bullets = {},
        quads = {
            love.graphics.newQuad(0,128,16,16,self.spritesheet),
            love.graphics.newQuad(16,128,16,16,self.spritesheet),
            love.graphics.newQuad(32,128,16,16,self.spritesheet),
        },
        delays = {
            dissolve = .3,
            swarm = .3,
            reassemble = 2,
        }
    }
end

function Man:loadAttackThree(p)
    if self.x > p.x then
        self.three.direction = 'right'
    else
        self.three.direction = 'left'
    end

    self.three = {
        quad = love.graphics.newQuad(32, 64, 32, 16, self.spritesheet),
        bullets = {},
        direction = 'left',
        speed = 400,
        delays = {
            shoot = .8,
            shootMax = .8,
            duration = 3,
        }
    }
end

function Man:update(dt, p, i)
    self.one.delays.dash = self.one.delays.dash - dt
    self.two.delays.dissolve = self.two.delays.dissolve - dt

    self.x = self.collider:getX()
    self.y = self.collider:getY()

    self.animations.walkLeft:update(dt)
    self.animations.walkRight:update(dt)
    self.animations.idleLeft:update(dt)
    self.animations.idleRight:update(dt)
    self.animations.dissolveLeft:update(dt)
    self.animations.dissolveRight:update(dt)

    if self.state == 'walk' then
        
    elseif self.state == 'one' then
        self:attackOne(dt, p)
    elseif self.state == 'two' then
        self:attackTwo(dt, p)
    elseif self.state == 'three' then
        self:attackThree(dt, p)
    end
    if self.isWalking then
        self:walk(dt, p, i)
    end

    for k,collider in ipairs(self.one.colliders) do
        if collider:enter('wall') then
            collider:destroy()
            table.remove(self.one.colliders, k)
        end
    end

    for k,bullet in ipairs(self.two.bullets) do
        if bullet.collider:enter('player') then
            p:damage(.5)
        end
    end

end

function Man:nextState(dt, p)
    self.statekey = self.statekey + 1
    if self.states[self.statekey] ~= nil then
        self.state = self.states[self.statekey]
        self.collider:setLinearVelocity(0, 0)
    else
        self.statekey = 1
        self.state = self.states[self.statekey]
        self.collider:setLinearVelocity(0, 0)
    end

    self:loadAttackOne()
    self:loadAttackTwo(p)
    self:loadAttackThree(p)
end

function Man:walk(dt, p, i)
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

function Man:attackOne(dt, p)
    self.isWalking = false
    local dx = p.x - self.x
    local dy = p.y - self.y
    local angle = -math.atan2(dx, dy) + math.pi / 2
    if self.one.delays.dash < 0 then
        self.one.delays.duration = self.one.delays.duration - dt

        if not self.one.hasDashed then
            for _,collider in ipairs(self.one.colliders) do
                collider:setLinearVelocity(1000*math.cos(angle), 1000*math.sin(angle))
            end
            self.collider:setLinearVelocity(1000*math.cos(angle), 1000*math.sin(angle))
            self.one.hasDashed = true
        end

        if self.one.delays.duration < 0 then
            self.collider:setLinearVelocity(0, 0)
            self:loadAttackOne()
            self:nextState(dt, p)
        end
    end
    
end
function Man:attackTwo(dt, p)
    -- GEE WILLIKERS
    local dx = p.x - self.x
    local dy = p.y - self.y
    local angle = -math.atan2(dx, dy) + math.pi / 2
    
    self.two.angle = angle
    self.isWalking = false
    self.two.isDissolving = true
    
    if self.two.delays.dissolve < 0 then 
        self.two.isDissolving = false
        if math.random(1, 10) == 1 then
            local speed = 500
            table.insert(self.two.bullets, {collider = world:newCircleCollider(self.x, self.y, 10), quad = self.two.quads[math.random(1, #self.two.quads)]})
            self.two.bullets[#self.two.bullets].collider:setCollisionClass('bossBullet')
            local r = self.two.angle + math.rad(math.random(-20, 20))
            self.two.bullets[#self.two.bullets].collider:setLinearVelocity(math.cos(r) * speed, math.sin(r) * speed)
            self.two.bullets[#self.two.bullets].collider:setAngularVelocity(math.random(-5, 5))
        end

        self.two.delays.swarm = self.two.delays.swarm - dt
        if self.two.delays.swarm < 0 then
            self.two.delays.reassemble = self.two.delays.reassemble - dt
            

            if self.two.delays.reassemble < 0 then
                self:nextState(dt, p)
            end
        end
    end
end

function Man:attackThree(dt, p)
    self.isWalking = true
    self.three.delays.shoot = self.three.delays.shoot - dt
    self.three.delays.duration = self.three.delays.duration - dt
    
    for k,bullet in ipairs(self.three.bullets) do
        local bx,by = bullet:getPosition()
        local vx,vy = bullet:getLinearVelocity()
        if by < p.y - math.random(20, 40) and math.abs(p.x - bx) > 100 then
            vy = self.three.speed * 1
        elseif by > p.y + math.random(20, 40) and math.abs(p.x - bx) > 100 then
            vy = self.three.speed * -1
        end
        bullet:setLinearVelocity(vx, vy)
        if bullet:enter('player') then
            p:damage(.5)
            bullet:destroy()
            table.remove(self.three.bullets, k)
        end
    end

    if self.three.delays.shoot < 0 then
        local dx = p.x - self.x
        local dy = p.y - self.y
        local angle = -math.atan2(dx, dy) + math.pi / 2
        
        table.insert(self.three.bullets, world:newCircleCollider(self.x, self.y, 20))
        local vx, vy = 0,0 
        if p.x < self.x then
            vx = -1
        else
            vx = 1
        end
        if p.y > self.y then
            vy = 1
        else
            vy = -1
        end
        self.three.bullets[#self.three.bullets]:setLinearVelocity(self.three.speed * vx, self.three.speed * vy)
        self.three.bullets[#self.three.bullets]:setCollisionClass('bossBullet')
        self.three.delays.shoot = self.three.delays.shootMax

    end
    if self.three.delays.duration < 0 then
        self:nextState(dt, p)
    end
end

function Man:draw(p, g)

    love.graphics.setColor(0, 0, 0, .4)
    love.graphics.ellipse('fill', self.x, self.y + 20 * 4, 10*4, 4*4)
    love.graphics.setColor(1, 1, 1, 1)

    for _,bullet in ipairs(self.two.bullets) do
        love.graphics.draw(self.spritesheet, bullet.quad,  bullet.collider:getX(), bullet.collider:getY(), bullet.collider:getAngle(), 4, 4, 8, 8)
    end

    if self.state == 'walk' then
        if self.facing == 'right' then
            self.animations.walkRight:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 16, 16)
        else
            self.animations.walkLeft:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 16, 16)
        end
    elseif self.two.isDissolving and self.state == 'two' then
        local vx,vy = self.collider:getLinearVelocity()
        if vx > 0 then
            self.animations.dissolveRight:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 16, 16)
        else
            self.animations.dissolveLeft:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 16, 16)
        end
    elseif not self.two.isDissolving and self.state == 'two' then
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
    for _,collider in ipairs(self.one.colliders) do
        local x,y = collider:getPosition()
        if x < self.x then
            self.animations.idleLeft:draw(self.spritesheet, x, y, 0, self.squishX, 4, 16, 16)
        else
            self.animations.idleRight:draw(self.spritesheet, x, y, 0, self.squishX, 4, 16, 16)
        end
    end

    for _,collider in ipairs(self.three.bullets) do
        local vx, vy = collider:getLinearVelocity()
        local angle = math.atan2(vy, vx)
        love.graphics.draw(self.spritesheet, self.three.quad, collider:getX(), collider:getY(), angle, 4, 4, 16, 8)
    end
end

function Man:drawHealth()
    local ratio = self.health / self.maxHealth
    love.graphics.draw(uiSpritesheet, self.healthQuad, love.graphics.getWidth()/2 - 206, 50, 0, 4, 4)
    love.graphics.setColor(230/255, 69/255, 57/255)
    love.graphics.rectangle('fill', love.graphics.getWidth()/2 - 198, 58, ratio * 392, 12)
    love.graphics.setColor(255/255, 194/255, 161/255)
    love.graphics.rectangle('fill', love.graphics.getWidth()/2 - 198 + ratio * 392, 58, 4, 12)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Meme Man', love.graphics.getWidth()/2 - 80, 20)
    love.graphics.print(tostring(self.state))
end

function Man:setState(state)
    self.state = state
end

function Man:recoil()
    flux.to(self.gun1, .05, {offsetX = 15}):after(self.gun1, .2, {offsetX = 0})
    flux.to(self.gun1, .1, {offsetY = math.pi/8}):after(self.gun1, .2, {offsetY = 0})
end

function Man:playSound(sound)
    local s = sound:clone()
    s:play()
end