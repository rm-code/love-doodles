local points = {}
local sw, sh = love.graphics.getDimensions()
love.graphics.setBackgroundColor( 0.133333, 0.125490, 0.203922 )

local defaultColorLow = { 0.796078, 0.858824, 0.988235 }
local defaultColorHigh = { 0.517647, 0.494118, 0.529412 }

local function lerp( a, b, t )
    return a + ( b - a ) * t
end

function love.load()
    for _ = 1, 250 do
        local signX, signY = love.math.random() < 0.5 and -1 or 1, love.math.random() < 0.5 and -1 or 1
        local size = love.math.random( 5 )
        local dx, dy = love.math.random( 5, 15 ) * signX, love.math.random( 5, 15 ) * signY

        local point = {
            x = love.math.random( sw ),
            y = love.math.random( sh ),
            s = size,
            o = size,
            m = love.math.random() < 0.5 and 'line' or 'fill',
            dx = dx,
            dy = dy,
            ox = dx,
            oy = dy,
            color = { 0.796078, 0.858824, 0.988235 }
        }
        points[#points + 1] = point
    end
end

function love.draw()
    for i = 1, #points do
        love.graphics.setColor( points[i].color )
        love.graphics.circle( points[i].m, points[i].x, points[i].y, points[i].s )
        love.graphics.setColor( points[i].color )
    end
end

function love.update( dt )
    local mx, my = love.mouse.getPosition()

    for _, point in ipairs( points ) do
        point.x = point.x + point.dx * dt
        point.y = point.y + point.dy * dt

        if (point.x > sw and point.dx > 0) or (point.x < 0 and point.dy < 0) then
            point.dx = -point.dx
            point.ox = -point.ox
        end
        if (point.y > sh and point.dy > 0) or (point.y < 0 and point.dy < 0) then
            point.dy = -point.dy
            point.oy = -point.oy
        end

        local manhattanX, manhattanY = point.x - mx, point.y - my
        local distance = math.sqrt( manhattanX * manhattanX + manhattanY * manhattanY )

        if distance < 300 then
            local strength = -1 * distance * 0.0015
            local dx, dy = manhattanX / distance, manhattanY / distance

            point.dx = point.dx + dx * strength
            point.dy = point.dy + dy * strength

            point.s = lerp( point.s, 1, dt )
            point.color[1] = math.max( point.color[1] - 2 * dt, defaultColorLow[1] )
            point.color[2] = math.max( point.color[2] - 2 * dt, defaultColorLow[2] )
            point.color[3] = math.max( point.color[3] - 2 * dt, defaultColorLow[3] )
        else
            point.s = math.min( point.s + 2 * dt, point.o )

            point.dx = lerp( point.dx, point.ox, dt )
            point.dy = lerp( point.dy, point.oy, dt )

            point.color[1] = math.min( point.color[1] + 2 * dt, defaultColorHigh[1] )
            point.color[2] = math.min( point.color[2] + 2 * dt, defaultColorHigh[2] )
            point.color[3] = math.min( point.color[3] + 2 * dt, defaultColorHigh[3] )
        end
    end
end

