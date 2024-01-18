Button = Object.extend(Object)

function Button:new(x, y, width, height, rotation)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.rotation = rotation
end

function Button:isPressed(mx, my)
    if mx > self.x - self.width * 2 and mx < self.x + self.width*2 and my > self.y - self.height*2 and my < self.y + self.height*2 then
        return true
    else
        return false
    end
end

function Button:draw(quad)
    love.graphics.draw(uiSpritesheet, quad, self.x, self.y, self.rotation, 4, 4, self.width/2, self.height/2)
end