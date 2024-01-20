if x < self.table[self.inventory2].x + self.width and x > self.table[self.inventory2].x then
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