local MIN_SPAWN = -800
local MAX_SPAWN = -100
local DROP_WIDTH = 5
local DROP_HEIGHT = 20

local drops = {}
local ripples = {}

local index = 1

function love.load()
    local sw, sh = love.graphics.getDimensions()
    for i = 1, 100 do
        drops[i] = {
            x = love.math.random( sw ),
            y = love.math.random( MIN_SPAWN, MAX_SPAWN ),
            vy = 1.0,
            ty = love.math.random( 100, sh - 50 )
        }
    end
end

function love.draw()
    love.graphics.setColor( 255, 255, 255, 100 )
    for _, drop in pairs( drops ) do
        love.graphics.rectangle( 'fill', drop.x, drop.y, DROP_WIDTH, DROP_HEIGHT )
    end
    for _, circle in pairs( ripples ) do
        love.graphics.setColor( 255, 255, 255, circle.alpha )
        love.graphics.ellipse( 'line', circle.x, circle.y, circle.rx, circle.ry )
    end
    love.graphics.setColor( 255, 255, 255, 255 )
end

function love.update()
    for _, drop in pairs( drops ) do
        drop.vy = math.min( drop.vy + 0.08, 12.0 )
        drop.y = drop.y + drop.vy

        if drop.y > drop.ty then
            index = index + 1
            ripples[index] = { x = drop.x, y = drop.y, rx = 2.5, ry = 0.5, alpha = 255 }

            drop.x = love.math.random( love.graphics.getWidth() )
            drop.y = love.math.random( MIN_SPAWN, MAX_SPAWN )
            drop.vy = 1.0
            drop.ty = love.math.random( 100, love.graphics.getHeight() - 50 )
        end
    end

    for i, circle in pairs( ripples ) do
        circle.rx = circle.rx + 0.85
        circle.ry = circle.ry + 0.5
        circle.alpha = circle.alpha - 5

        if circle.alpha <= 0 then
            circle.alpha = 0

            ripples[i] = nil
        end
    end
end
