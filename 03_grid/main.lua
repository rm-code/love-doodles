local CELLS, ROWS = 10, 8
local sw, sh = love.graphics.getDimensions()
local points = {}
local gx, gy

function love.load()
    gx, gy = math.floor( sw / CELLS ), math.floor( sh / ROWS )

    for x = 1, CELLS do
        for y = 1, ROWS do
            points[#points + 1] = {
                x = x,
                y = y,
                rx = x,
                ry = y,
                offsetX = (love.math.random() > 0.5 and love.math.random() or -love.math.random()) * 0.8,
                offsetY = 0,
                randomizer = love.math.random() > 0.5 and love.math.random() or -love.math.random()
            }
        end
    end
end

function love.draw()
    for _, point in ipairs( points ) do
        love.graphics.setColor( point.y / ROWS, point.y / ROWS, 0.8 )
        point.offsetY = math.sin( love.timer.getTime() * 0.5 )

        point.rx = point.x-0.5 + point.offsetX
        point.ry = point.y-0.5 + point.offsetY * point.randomizer

        love.graphics.circle( 'fill', point.rx * gx, point.ry * gy, 4 )

        -- Ain't nobody got time for fancy triangulation...
        for _, point2 in ipairs( points ) do
            local manhattanX, manhattanY = point.rx - point2.rx, point.ry - point2.ry
            local distance = math.sqrt( manhattanX * manhattanX + manhattanY * manhattanY )

            if distance < 1.5 then
                love.graphics.line( point.rx * gx, point.ry * gy, point2.rx * gx, point2.ry * gy )
            end
        end
    end
end
