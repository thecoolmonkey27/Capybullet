Inventory = Object.extend(Object)

Gun = Object.extend(Object)

function Inventory:new()
    self.table = {}
    --function Gun:new(name, shots, reload, row, spawns, delay, timer, spreadmax, spreadTimeToMax, damage, shootSound)
    table.insert(self.table, Gun('glock', 10, 2, 1, 1, .2, .5, 300, .1, 1, sounds.glock.shoot))
    table.insert(self.table, Gun('shotgun', 6, 2, 2, 5, .5, .3, 0, 0, 1, sounds.shotgun.shoot))
    self.selected = 1
    self.hotbarQuad = love.graphics.newQuad(0, 0, 16, 16, uiSpritesheet)
    self.hotbarSelectedQuad = love.graphics.newQuad(16, 0, 16, 16, uiSpritesheet)
    self.reloadQuad = love.graphics.newQuad(0, 52, 103, 7, uiSpritesheet)
    self.sy = 4
    self.sx = 4
end

function Inventory:drawGuns(p)
    local dx = mx - p.x
    local dy = my - p.y
    self.sy = 4
    if gamestate == 'game' or gamestate == 'bossScreen'then
        r = -math.atan2(dx, dy) + 1.5
    else
        r = 0
    end
    if dx < 0 and gamestate == 'game' or gamestate == 'bossScreen' then
        self.sy = -4
    end
    for _,gun in ipairs(self.table) do
        gun:drawBullets()
    end
    local ox, oy = self.table[self.selected].offsetX * math.cos(r), self.table[self.selected].offsetX * math.sin(r)
    local oa = 0
    if self.sy > 0 then
        oa = self.table[self.selected].offsetY * -1
    else
        oa = self.table[self.selected].offsetY
    end
    love.graphics.draw(gunSpritesheet, self.table[self.selected].sprite, p.x - ox, p.y + 10 - oy, r + oa, self.sx, self.sy, 0, 10)
end

function Inventory:drawUi()
    love.graphics.setFont(fontBig)
    love.graphics.printf('1', love.graphics.getWidth() - 46 * 4, love.graphics.getHeight() - 30 * 4, 64, 'right')
    if self.selected == 1 then
        love.graphics.draw(uiSpritesheet, self.hotbarSelectedQuad, love.graphics.getWidth() - 40 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    else
        love.graphics.draw(uiSpritesheet, self.hotbarQuad, love.graphics.getWidth() - 40 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    end
    love.graphics.draw(gunSpritesheet, self.table[1].icon, love.graphics.getWidth() - 40 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    love.graphics.printf('2', love.graphics.getWidth() - 20 * 4, love.graphics.getHeight() - 30 * 4, 64, 'center')
    if self.selected == 2 then
        love.graphics.draw(uiSpritesheet, self.hotbarSelectedQuad, love.graphics.getWidth() - 20 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    else
        love.graphics.draw(uiSpritesheet, self.hotbarQuad, love.graphics.getWidth() - 20 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    end
    love.graphics.draw(gunSpritesheet, self.table[2].icon, love.graphics.getWidth() - 20 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)

    if self.table[self.selected].isReloading then
        local ratio = self.table[self.selected].reloadTimer / self.table[self.selected].reloadTime
        love.graphics.draw(uiSpritesheet, self.reloadQuad, 16, love.graphics.getHeight() - 104, 0, 4, 4)
        love.graphics.setColor(64/255, 73/255, 115/255)
        love.graphics.rectangle('fill', 24, love.graphics.getHeight() - 96, 392 - (ratio * 392), 12)
        love.graphics.setColor(163/255, 167/255, 194/255)
        love.graphics.rectangle('fill', 24 + 392 - (ratio * 392), love.graphics.getHeight() - 96, 4, 12)
        love.graphics.setColor(1, 1, 1, 1)
    else
        local ratio = self.table[self.selected].shotsCount / self.table[self.selected].shots
        love.graphics.draw(uiSpritesheet, self.reloadQuad, 16, love.graphics.getHeight() - 104, 0, 4, 4)
        love.graphics.setColor(64/255, 73/255, 115/255)
        love.graphics.rectangle('fill', 24, love.graphics.getHeight() - 96, ratio * 392, 12)
        love.graphics.setColor(163/255, 167/255, 194/255)
        love.graphics.rectangle('fill', 24 + ratio * 392, love.graphics.getHeight() - 96, 4, 12)
        love.graphics.setColor(1, 1, 1, 1)


        --[[
        love.graphics.setColor(122/255, 124/255, 121/255)
        love.graphics.rectangle('fill', 20, love.graphics.getHeight() - 96, 364, 16, 8, 8)
        love.graphics.setColor(1, 1, 1, 1)
        local ratio = self.table[self.selected].shotsCount / self.table[self.selected].shots
        if self.table[self.selected].shotsCount > 0 then
            love.graphics.setColor(245/255, 255/255, 232/255)
            love.graphics.rectangle('fill', 20, love.graphics.getHeight() - 96, 364 * ratio, 16, 8, 8)
            love.graphics.setColor(1, 1, 1, 1)
        end
        --]]
    end
    local current = self.table[self.selected]
    if current.spawns == 1 and gamestate == 'game' then
        love.graphics.rectangle('fill', mouseX - current.spread / 10, mouseY + 30, 3, 10)
        love.graphics.rectangle('fill', mouseX + current.spread / 10, mouseY + 30, 3, 10)
    end
end

function Gun:new(name, shots, reload, row, spawns, delay, timer, spreadMax, spreadTimeToMax, damage, shootSound)
    self.name = name
    self.shots = shots
    self.shotsCount = shots
    self.reloadTime = reload
    self.isReloading = false
    self.reloadTimer = 0
    self.timer = timer
    self.row = row
    self.icon = love.graphics.newQuad(0, 16*(self.row-1), 16, 16, gunSpritesheet)
    self.sprite = love.graphics.newQuad(16, 16*(self.row-1), 32, 16, gunSpritesheet)
    self.bulletSprite = love.graphics.newQuad(7 * 16, 16*(self.row-1), 16, 16, gunSpritesheet)
    self.delay = delay
    self.delayTimer = 0
    self.bullets = {}
    self.bulletSpeed = 1250
    self.spawns = spawns
    self.sounds = {}
    self.sounds.shoot = shootSound
    self.damage = damage

    self.spreadMax = spreadMax
    self.spreadTimeToMax = spreadTimeToMax
    self.spread = spreadMax
    self.offsetX = 0
    self.offsetY = 0
end

function Gun:update(dt, p, i, b, key, type)
    if self.spread == self.spreadMax then
        flux.to(self, .6, {spread = 0})
    end
    if self.isReloading and i.selected == key then
        self.reloadTimer = self.reloadTimer - dt
    end
    if self.isReloading and self.reloadTimer < 0 then
        self.isReloading = false
        self.shotsCount = self.shots
    end
    if not self.isReloading and i.selected == key and self.shotsCount <= 0 then
        self:reload()
    end
    if self.isReloading and i.selected ~= key then
        self.reloadTimer = self.reloadTime
    end
    local dx = mx - p.x
    local dy = my - p.y
    local sy = 4
    r = -math.atan2(dx, dy) + math.pi / 2

    self.delayTimer = self.delayTimer - dt
    if love.mouse.isDown(1) and self.delayTimer < 0 and key == i.selected and self.shotsCount > 0 and not self.isReloading then
        if self.spawns == 1 then
            flux.to(self, self.spreadTimeToMax, {spread = self.spreadMax})
        end
        local sound = self.sounds.shoot:clone()
        sound:play()
        self.shotsCount = self.shotsCount - 1
        for i=1,self.spawns do
            if self.spawns > 1 then
                r = r * 1000
                r = math.random(r - 200, r + 200)
                r = r / 1000
            else
                r = r * 1000
                r = math.random(r - self.spread, r + self.spread)
                r = r / 1000
            end
            self:shoot(p.x, p.y + 10, r, type, self.timer, i)
            self.delayTimer = self.delay
        end
    end
    for key,bullet in pairs(self.bullets) do
        bullet.timer = bullet.timer - dt
        if bullet.timer < 0 then
            bullet.collider:destroy()
            table.remove(self.bullets, key)
        end
    end
    for key,bullet in pairs(self.bullets) do
        if bullet.collider:enter('wall') or bullet.collider:stay('wall')then
            bullet.collider:destroy()
            table.remove(self.bullets, key)
        elseif bullet.collider:enter('boss' or bullet.collider:stay('boss')) then
            bullet.collider:destroy()
            table.remove(self.bullets, key)
            if boss ~= nil then
                b.health = b.health - self.damage
            end
            local sound = sounds.bossHurt:clone()
            if b ~= nil then
                flux.to(b, .1, {squishX = 3.2}):after(b, .1,  {squishX = 4})
            end

        end
    end
end

function Gun:shoot(x, y, angle, type, timer, inv)
    table.insert(self.bullets, {x = x, y = y, angle = angle, timer = timer, collider = world:newRectangleCollider(x, y, 12, 16)})
    local key = #self.bullets
    self.bullets[key].collider:setCollisionClass(type)
    self.bullets[key].collider:setAngle(angle)
    cy = math.sin(angle) * (self.bulletSpeed)
    cx = math.cos(angle) * (self.bulletSpeed)
    self.bullets[key].collider:setLinearVelocity(cx, cy)
    flux.to(shake, .05, {x = -math.cos(angle)*7, y = -math.sin(angle)*7}):after(shake, .07, {x = 0, y = 0})
    flux.to(inventory, .1, {sx = 3}):after(inventory, .1, {sx = 4})
    flux.to(self, .05, {offsetX = 15}):after(self, .2, {offsetX = 0})
    flux.to(self, .1, {offsetY = math.pi/8}):after(self, .2, {offsetY = 0})
end

function Gun:drawBullets()
    for _,bullet in pairs(self.bullets) do
        love.graphics.draw(gunSpritesheet, self.bulletSprite, bullet.collider:getX(), bullet.collider:getY(), bullet.angle, 4, 4, 8, 8)
    end
end

function Gun:reload()
    self.reloadTimer = self.reloadTime
    self.isReloading = true
end

function Inventory:update(dt, p, b, type)
    for key,gun in ipairs(self.table) do
        gun:update(dt, p, self, b, key, type)
    end
end

function Inventory:select(key)
    self.selected = key
end