Inventory = Object.extend(Object)

Gun = Object.extend(Object)

function Inventory:new()
    self.table = {}
    table.insert(self.table, Gun('glock', 10, 2, 1, 1, .2, sounds.glock.shoot))
    table.insert(self.table, Gun('shotgun', 6, 2, 2, 5, .5, sounds.shotgun.shoot))
    self.selected = 1
    self.hotbarQuad = love.graphics.newQuad(0, 0, 16, 16, uiSpritesheet)
    self.hotbarSelectedQuad = love.graphics.newQuad(16, 0, 16, 16, uiSpritesheet)
end

function Inventory:drawGuns(p)
    local dx = mx - p.x
    local dy = my - p.y
    local sy = 4
    r = -math.atan2(dx, dy) + 1.5
    if dx < 0 then
        sy = -4
    end
    for _,gun in ipairs(self.table) do
        gun:drawBullets()
    end
    love.graphics.draw(gunSpritesheet, self.table[self.selected].sprite, p.x, p.y + 10, r, 4, sy, 0, 8)
end

function Inventory:drawUi()
    if self.selected == 1 then
        love.graphics.draw(uiSpritesheet, self.hotbarSelectedQuad, love.graphics.getWidth() - 40 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    else
        love.graphics.draw(uiSpritesheet, self.hotbarQuad, love.graphics.getWidth() - 40 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    end
    love.graphics.draw(gunSpritesheet, self.table[1].icon, love.graphics.getWidth() - 40 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    if self.selected == 2 then
        love.graphics.draw(uiSpritesheet, self.hotbarSelectedQuad, love.graphics.getWidth() - 20 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    else
        love.graphics.draw(uiSpritesheet, self.hotbarQuad, love.graphics.getWidth() - 20 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)
    end
    love.graphics.draw(gunSpritesheet, self.table[2].icon, love.graphics.getWidth() - 20 * 4, love.graphics.getHeight() - 20 * 4, 0, 4, 4)

    if self.table[self.selected].isReloading then
        love.graphics.setColor(122/255, 124/255, 121/255)
        love.graphics.rectangle('fill', 20, love.graphics.getHeight() - 96, 364, 16, 8, 8)
        love.graphics.setColor(1, 1, 1, 1)
        local ratio = self.table[self.selected].reloadTimer / self.table[self.selected].reloadTime
        love.graphics.setColor(245/255, 255/255, 232/255)
        love.graphics.rectangle('fill', 20, love.graphics.getHeight() - 96, 364 - (364 * ratio), 16, 8, 8)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(122/255, 124/255, 121/255)
        love.graphics.rectangle('fill', 20, love.graphics.getHeight() - 96, 364, 16, 8, 8)
        love.graphics.setColor(1, 1, 1, 1)
        local ratio = self.table[self.selected].shotsCount / self.table[self.selected].shots
        if self.table[self.selected].shotsCount > 0 then
            love.graphics.setColor(245/255, 255/255, 232/255)
            love.graphics.rectangle('fill', 20, love.graphics.getHeight() - 96, 364 * ratio, 16, 8, 8)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

function Gun:new(name, shots, reload, row, spawns, delay, shootSound)
    self.name = name
    self.shots = shots
    self.shotsCount = shots
    self.reloadTime = reload
    self.isReloading = false
    self.reloadTimer = 0

    self.row = row
    self.icon = love.graphics.newQuad(0, 16*(self.row-1), 16, 16, gunSpritesheet)
    self.sprite = love.graphics.newQuad(16, 16*(self.row-1), 32, 16, gunSpritesheet)
    self.bulletSprite = love.graphics.newQuad(7 * 16, 16*(self.row-1), 16, 16, gunSpritesheet)
    self.delay = delay
    self.delayTimer = 0
    self.bullets = {}
    self.bulletSpeed = 1500
    self.spawns = spawns
    self.sounds = {}
    self.sounds.shoot = shootSound
end

function Gun:update(dt, p, i, key)
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
    r = -math.atan2(dx, dy) + 1.5

    self.delayTimer = self.delayTimer - dt
    if love.mouse.isDown(1) and self.delayTimer < 0 and key == i.selected and self.shotsCount > 0 and not self.isReloading then
        self.sounds.shoot:stop()
        self.sounds.shoot:play()
        self.shotsCount = self.shotsCount - 1
        for i=1,self.spawns do
            if self.spawns > 1 then
                r = r * 1000
                r = math.random(r - 200, r + 200)
                r = r / 1000
            end
            self:shoot(p.x, p.y + 10, r)
            self.delayTimer = self.delay
        end
    end
    for _,bullet in pairs(self.bullets) do
        cy = math.sin(bullet.angle) * (self.bulletSpeed * dt)
        cx = math.cos(bullet.angle) * (self.bulletSpeed * dt)
        bullet.x = bullet.x + cx
        bullet.y = bullet.y + cy
    end
end

function Gun:shoot(x, y, angle)
    table.insert(self.bullets, {x = x, y = y, angle = angle})
end

function Gun:drawBullets()
    for _,bullet in pairs(self.bullets) do
        love.graphics.draw(gunSpritesheet, self.bulletSprite, bullet.x, bullet.y, bullet.angle, 4, 4, 0, 8)
    end
end

function Gun:reload()
    self.reloadTimer = self.reloadTime
    self.isReloading = true
end

function Inventory:update(dt, p)
    for key,gun in ipairs(self.table) do
        gun:update(dt, p, self, key)
    end
end

function Inventory:select(key)
    self.selected = key
end