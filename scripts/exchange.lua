Exchange = Object.extend(Object)

function Exchange:new(newGun, i)
    self.table = {}
    table.insert(self.table, {
        gun = i.table[1],
        x = 50,
        targetX = 50,
        y = 275,
        targetY = 275
    })
    table.insert(self.table, {
        gun = i.table[2],
        x = love.graphics.getWidth() - 50 - 32*8,
        targetX = love.graphics.getWidth() - 50 - 32*8,
        y = 275,
        targetY = 275,
    })
    table.insert(self.table, {
        gun = newGun,
        x = love.graphics.getWidth()/2 - (32*8)/2,
        targetX = love.graphics.getWidth()/2 - (32*8)/2,
        y = 10,
        targetY = 10,
    })
    self.inventory1 = 1
    self.inventory2 = 2
    self.inventory3 = 3
    self.iconQuad = love.graphics.newQuad(0, 16, 32, 32, uiSpritesheet)
    self.arrowQuad = love.graphics.newQuad(32, 16, 16, 16, uiSpritesheet)
    self.width = 32*8
    self.height = 32*8
end

function Exchange:update(dt)

end

function Exchange:draw()
    love.graphics.setColor(59/255, 125/255, 79/255, .5)
    love.graphics.rectangle('fill', 10, love.graphics.getHeight() / 2 + 10, love.graphics.getWidth() - 10, love.graphics.getHeight() / 2 - 10, 30, 30)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setColor(173/255, 47/255, 69/255, .5)
    love.graphics.rectangle('fill', 10, 10, love.graphics.getWidth() - 10, love.graphics.getHeight() / 2 - 10, 30, 30)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(uiSpritesheet, self.iconQuad, self.table[self.inventory1].x, self.table[self.inventory1].y, 0, 8, 8)
    love.graphics.draw(gunSpritesheet, self.table[self.inventory1].gun.icon, self.table[self.inventory1].x , self.table[self.inventory1].y , 0, 16, 16)
    
    love.graphics.draw(uiSpritesheet, self.iconQuad, self.table[self.inventory2].x, self.table[self.inventory2].y, 0, 8, 8)
    love.graphics.draw(gunSpritesheet, self.table[self.inventory2].gun.icon, self.table[self.inventory2].x , self.table[self.inventory2].y , 0, 16, 16)
    
    love.graphics.draw(uiSpritesheet, self.iconQuad, self.table[self.inventory3].x, self.table[self.inventory3].y, 0, 8, 8)
    love.graphics.draw(gunSpritesheet, self.table[self.inventory3].gun.icon, self.table[self.inventory3].x , self.table[self.inventory3].y , 0, 16, 16)

    love.graphics.draw(uiSpritesheet, self.arrowQuad, love.graphics.getWidth() / 2 + 128, love.graphics.getHeight() - 100, 0, -4, 4)
    love.graphics.draw(uiSpritesheet, self.arrowQuad, love.graphics.getWidth() / 2 - 128, love.graphics.getHeight() - 100, 0, 4, 4)
    love.graphics.print('click', love.graphics.getWidth()/2 - 50, love.graphics.getHeight() - 75)

    love.graphics.print('Click escape to close. ', 20,  20)
end

function Exchange:clicked(x, y)
    print(self.table[self.inventory1].x)
    if x < self.table[self.inventory1].x + self.width and x > self.table[self.inventory1].x then
        if y > self.table[self.inventory1].y and y < self.table[self.inventory1].y + self.height then
            flux.to(self.table[self.inventory1], .2, {x = self.table[self.inventory3].targetX, y = self.table[self.inventory3].targetY})
            flux.to(self.table[self.inventory3], .2, {x = self.table[self.inventory1].targetX, y = self.table[self.inventory1].targetY})
            local tarX, tarY = self.table[self.inventory1].targetX,self.table[self.inventory1].targetY
            self.table[self.inventory1].targetX,self.table[self.inventory1].targetY = self.table[self.inventory3].targetX,self.table[self.inventory3].targetY
            self.table[self.inventory3].targetX,self.table[self.inventory3].targetY = tarX, tarY 
            local inv1 = self.inventory1
            self.inventory1 = self.inventory3
            self.inventory3 = inv1
        end
    elseif x < self.table[self.inventory2].x + self.width and x > self.table[self.inventory2].x then
        if y > self.table[self.inventory2].y and y < self.table[self.inventory2].y + self.height then
            flux.to(self.table[self.inventory2], .2, {x = self.table[self.inventory3].targetX, y = self.table[self.inventory3].targetY})
            flux.to(self.table[self.inventory3], .2, {x = self.table[self.inventory2].targetX, y = self.table[self.inventory2].targetY})
            local tarX, tarY = self.table[self.inventory2].targetX,self.table[self.inventory2].targetY
            self.table[self.inventory2].targetX,self.table[self.inventory2].targetY = self.table[self.inventory3].targetX,self.table[self.inventory3].targetY
            self.table[self.inventory3].targetX,self.table[self.inventory3].targetY = tarX, tarY 
            local inv1 = self.inventory2
            self.inventory2 = self.inventory3
            self.inventory3 = inv1
        end
    end
end
    