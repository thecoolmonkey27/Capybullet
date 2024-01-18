Pepe = Object.extend(Object)

function Pepe:new(x, y)
    self.x = x
    self.y = y
    self.sx = 4
    self.sy = 4
    self.speed = 150
    self.collider = world:newRectangleCollider(self.x, self.y, 16*4, 32*4)
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass('boss')
    self.gun1 = Gun('wand', 10, 2, 3, 1, .2, sounds.glock.shoot)
    self.spritesheet = love.graphics.newImage('sprites/pepe-spritesheet.png')
    self.grid = anim8.newGrid(32, 32, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.maxHealth = 50
    self.health = 50
    self.healthQuad = love.graphics.newQuad(0, 52, 103, 7, uiSpritesheet)

    self.stateTimerMax = 3
    self.stateTimer = 3

    self.regular = {
        bullets = {},
        speed = 300,
        delays = {
            max = .3,
            current = .3
        }
    }
    self.triple = {
        speed = 600,
        bullets = {},
        delays = {
            max = .7,
            current = .7
        }
    }
    

    self.facing = 'left'
    self.animations = {}
    
    self.animations.walkLeft = anim8.newAnimation(self.grid('1-4', 3), .125)
    self.animations.walkRight = anim8.newAnimation(self.grid('1-4', 4), .125)
    self.animations.idleLeft = anim8.newAnimation(self.grid('1-5', 1), .125)
    self.animations.idleRight = anim8.newAnimation(self.grid('1-5', 2), .125)
    self.animations.rollLeft = anim8.newAnimation(self.grid('1-8', 5), .15)
    self.animations.rollRight = anim8.newAnimation(self.grid('1-8', 6), .15)

    -- shoot, walk, roll
    self.state = 'walk'
end

function Pepe:update(dt, p, i)
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
        self:walk(dt, p, i)
    elseif self.state == 'regular' then
        self:attackRegular(dt, p)
    elseif self.state == 'triple' then
        self:attackTriple(dt, p)
    end

    for k,bullet in pairs(self.regular.bullets) do
        if bullet:enter('player') then
            bullet:destroy()
            table.remove(self.regular.bullets, k)

            p:damage(.5)
        elseif bullet:enter('wall') then
            bullet:destroy()
            table.remove(self.regular.bullets, k)
        end
    end
    for k,bullet in pairs(self.triple.bullets) do
        if bullet:enter('player') then
            bullet:destroy()
            table.remove(self.triple.bullets, k)

            p:damage(2)
        elseif bullet:enter('wall') then
            bullet:destroy()
            table.remove(self.triple.bullets, k)
        end
    end
end

function Pepe:updateState(dt)
    self.stateTimer = self.stateTimer - dt
    if self.stateTimer < 0 then
        self.collider:setLinearVelocity(0, 0)
        if self.state == 'walk' then
            self.state = 'regular'
        elseif self.state == 'regular' then
            self.state = 'triple'
        elseif self.state == 'triple' then
            self.state = 'walk'
        end

        self.stateTimer = self.stateTimerMax
    end
end

function Pepe:walk(dt, p, i)
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

function Pepe:attackRegular(dt, p)
    local dx = p.x - self.x
    local dy = p.y - self.y
    local angle = -math.atan2(dx, dy) + math.pi / 2
    local speed = self.regular.speed
    local scale = 200
    self.regular.delays.current = self.regular.delays.current - dt
    if self.regular.delays.current < 0 then
        table.insert(self.regular.bullets, world:newCircleCollider(self.x, self.y, 10))
        self.regular.delays.current = self.regular.delays.max
        self.regular.bullets[#self.regular.bullets]:setCollisionClass('bossBullet')
        self.regular.bullets[#self.regular.bullets]:setLinearVelocity(math.cos(angle)*speed, math.sin(angle)*speed)
    end
end

function Pepe:attackTriple(dt, p)
    local dx = p.x - self.x
    local dy = p.y - self.y
    local angle = -math.atan2(dx, dy) + math.pi / 2
    local speed = self.triple.speed
    local scale = 200
    self.triple.delays.current = self.triple.delays.current - dt
    if self.triple.delays.current < 0 then
        table.insert(self.triple.bullets, world:newCircleCollider(self.x, self.y, 30))
        self.triple.delays.current = self.triple.delays.max
        self.triple.bullets[#self.triple.bullets]:setCollisionClass('bossBullet')
        self.triple.bullets[#self.triple.bullets]:setLinearVelocity(math.cos(angle)*speed, math.sin(angle)*speed)
    end
end

function Pepe:draw(p, g)
    if self.state == 'walk' then
        if self.facing == 'right' then
            self.animations.walkRight:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 16, 16)
        else
            self.animations.walkLeft:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 16, 16)
        end
    elseif self.state ~= 'walk' then
        if p.x < self.x then
            self.animations.idleLeft:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 16, 16)
        else
            self.animations.idleRight:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 16, 16)
        end
    end
    local dx = p.x - self.x
    local dy = p.y - self.y
    local r = -math.atan2(dx, dy) + math.pi / 2
    self.sx = 4
    self.sy = 4
    if p.x < self.x then
        self.sy = -4
    end
    
    love.graphics.draw(gunSpritesheet, self.gun1.sprite, self.x, self.y + 20, r, self.sx, self.sy, 0, 8)
end

function Pepe:drawHealth()
    local ratio = self.health / self.maxHealth
    love.graphics.draw(uiSpritesheet, self.healthQuad, love.graphics.getWidth()/2 - 206, 50, 0, 4, 4)
    love.graphics.setColor(230/255, 69/255, 57/255)
    love.graphics.rectangle('fill', love.graphics.getWidth()/2 - 198, 58, ratio * 392, 12)
    love.graphics.setColor(255/255, 194/255, 161/255)
    love.graphics.rectangle('fill', love.graphics.getWidth()/2 - 198 + ratio * 392, 58, 4, 12)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Pepe', love.graphics.getWidth()/2 - 45, 20)
end

function Pepe:setState(state)
    self.state = state
end