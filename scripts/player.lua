Player = Object.extend(Object)

function Player:new(x, y)
    self.x = x
    self.y = y
    self.collider = world:newRectangleCollider(self.x, self.y, 8*scale, 11*scale)
    self.collider:setCollisionClass('player')
    self.collider:setFixedRotation(true)
    self.speed = 400

    self.spritesheet = love.graphics.newImage('sprites/capybara-spritesheet.png')
    self.direction = 'idleLeft'
    
    self.roll = false
    self.rollDirection = 0
    self.rollTimer = 0
    self.rollDelayTimer = 0
    self.rollDelayTimerMax = 1.5
    self.rollSpeed = 3.5
    
    self.maxHealth = 16
    self.health = 16

    self.facing = 'left'
    self.grid = anim8.newGrid(16, 16, self.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.animations = {}
    self.animations.walkLeft = anim8.newAnimation(self.grid('1-4', 4), .125)
    self.animations.walkRight = anim8.newAnimation(self.grid('1-4', 3), .125)
    self.animations.idleLeft = anim8.newAnimation(self.grid('1-5', 2), .125)
    self.animations.idleRight = anim8.newAnimation(self.grid('1-5', 1), .125)
    self.animations.rollLeft = anim8.newAnimation(self.grid('1-7', 6), .15)
    self.animations.rollRight = anim8.newAnimation(self.grid('1-7', 5), .15)

    self.ui = {}
    self.ui.fullHeart = love.graphics.newQuad(50, 3, 12, 11, uiSpritesheet)
    self.ui.halfHeart = love.graphics.newQuad(66, 3, 12, 11, uiSpritesheet)
    self.ui.emptyHeart = love.graphics.newQuad(82, 3, 12, 11, uiSpritesheet)
end

function Player:update(dt, m)
    local cx,cy = 0,0
    local vx, vy = 0,0
    self.x, self.y = self.collider:getPosition()
    self.rollDelayTimer = self.rollDelayTimer - dt
    if self.rollTimer > 0 then
        self.rollTimer = self.rollTimer - dt
        if self.rollDirection == 'north' then
            cy = -self.rollSpeed
        elseif self.rollDirection == 'northEast' then
            cx = self.rollSpeed*.7
            cy = -self.rollSpeed*.7
        elseif self.rollDirection == 'east' then
            cx = self.rollSpeed
        elseif self.rollDirection == 'southEast' then
            cx = self.rollSpeed*.7
            cy = self.rollSpeed*.7
        elseif self.rollDirection == 'south' then
            cy = self.rollSpeed
        elseif self.rollDirection == 'southWest' then
            cx = -self.rollSpeed*.7
            cy = self.rollSpeed*.7
        elseif self.rollDirection == 'west' then
            cx = -self.rollSpeed
        elseif self.rollDirection == 'northWest' then
            cx = -self.rollSpeed*.7
            cy = -self.rollSpeed*.7
        end
            
        
    else
        self.roll = false
    end
    
    if self.roll == false then
        if love.keyboard.isDown('w') then
            cy = cy - 1
        end
        if love.keyboard.isDown('s') then
            cy = cy + 1
        end
        if love.keyboard.isDown('a') then
            cx = cx - 1
        end
        if love.keyboard.isDown('d') then
            cx = cx + 1
        end
        if cx ~= 0 and cy ~= 0 then
            cx = cx * .7
            cy = cy * .7
        end
        if cx == 0 and cy == 0 then
            if self.facing == 'left' then
                self.direction = 'idleLeft'
            elseif self.facing == 'right' then
                self.direction = 'idleRight'
            end
        elseif cx > 0 then
            self.direction = 'walkRight'
            self.facing = 'right'
        elseif cx < 0 then
            self.direction = 'walkLeft'
            self.facing = 'left'
        elseif cy ~= 0 then
            if self.facing == 'left' then
                self.direction = 'walkLeft'
            elseif self.facing == 'right' then
                self.direction = 'walkRight'
            end
        end
    end

    
    vx = self.speed * cx
    vy = self.speed * cy
    self.collider:setLinearVelocity(vx, vy)

    self.animations.walkLeft:update(dt)
    self.animations.walkRight:update(dt)
    self.animations.idleLeft:update(dt)
    self.animations.idleRight:update(dt)
    self.animations.rollLeft:update(dt)
    self.animations.rollRight:update(dt)

    if self.collider:enter('boss') then
        self.health = self.health - 1
        sounds.player.hit:stop()
        sounds.player.hit:play()
    end
end

function Player:draw()
      self.animations[self.direction]:draw(self.spritesheet, self.x, self.y, 0, 4, 4, 8, 8)
end

function Player:drawHealth()
    for i=1,self.maxHealth/2 do
        love.graphics.draw(uiSpritesheet, self.ui.emptyHeart, 16 + 52*(i-1), love.graphics.getHeight() - 64, 0, 4, 4)
    end
    local h = math.floor(self.health / 2)
    for i=1,h do
        love.graphics.draw(uiSpritesheet, self.ui.fullHeart, 16 + 52*(i-1), love.graphics.getHeight() - 64, 0, 4, 4)
    end
    if self.health / 2 ~= h then
        love.graphics.draw(uiSpritesheet, self.ui.halfHeart, 16 + 52*(h), love.graphics.getHeight() - 64, 0, 4, 4)
    end
end

function Player:damage(amount)
    self.health = self.health - amount
    local angle = math.pi * math.random(1,2) + math.pi / math.random(1, 4)
    flux.to(shake, .05, {x = -math.cos(angle)*7, y = -math.sin(angle)*7}):after(shake, .07, {x = 0, y = 0})
    sounds.player.hit:stop()
    sounds.player.hit:play()
end


function Player:Roll()
    if self.roll == false then 
        self.roll = true
        if love.keyboard.isDown('w') then
            if not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
                self.rollDirection = 'north'
            elseif love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
                self.rollDirection = 'northWest'
            else
                self.rollDirection = 'northEast'
            end
        elseif love.keyboard.isDown('d') then
            if not love.keyboard.isDown('w') and not love.keyboard.isDown('s') then
                self.rollDirection = 'east'
            elseif love.keyboard.isDown('w') and not love.keyboard.isDown('s') then
                self.rollDirection = 'northEast'
            else
                self.rollDirection = 'southEast'
            end
        elseif love.keyboard.isDown('s') then
            if not love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
                self.rollDirection = 'south'
            elseif love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
                self.rollDirection = 'southEast'
            else
                self.rollDirection = 'southWest'
            end
        elseif love.keyboard.isDown('a') then
            if not love.keyboard.isDown('w') and not love.keyboard.isDown('s') then
                self.rollDirection = 'west'
            elseif love.keyboard.isDown('w') and not love.keyboard.isDown('s') then
                self.rollDirection = 'northWest'
            else
                self.rollDirection = 'southWest'
            end
        else
            if self.facing == 'left' then
                self.rollDirection = 'west'
            elseif self.facing == 'right' then
                self.rollDirection = 'east'
            end
        end
    end
    self.roll = true
    self.rollTimer = .1
end
