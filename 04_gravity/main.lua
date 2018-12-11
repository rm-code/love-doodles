local MAX_AGE = 400
local SPAWN_MARGIN = 50

local DAMPING_FACTOR = 0.95

local CENTER_X = love.graphics.getWidth() * 0.5
local CENTER_Y = love.graphics.getHeight() * 0.5

local SPAWN_RATE = 0.15

local spawnTimer = 0
local bubbles = {}

local mouse = {}
mouse.radius = 400
mouse.x, mouse.y = love.mouse.getPosition()

local function getManhattanDistance( px, py, tx, ty )
    return px - tx, py - ty
end

local function getRealDistance( dx, dy )
    return math.sqrt( dx * dx + dy * dy ) + 0.1
end

local function attract( bubble )
    local dx, dy = getManhattanDistance( bubble.x, bubble.y, CENTER_X, CENTER_Y )
    local distance = getRealDistance( dx, dy )

    dx = dx / distance
    dy = dy / distance

    local strength = -1 * distance * 0.75
    bubble.dx = dx * strength
    bubble.dy = dy * strength

    bubble.x = bubble.x + bubble.dx * love.timer.getDelta() * DAMPING_FACTOR
    bubble.y = bubble.y + bubble.dy * love.timer.getDelta() * DAMPING_FACTOR
end

local function repel( bubble, target )
    local dx, dy = getManhattanDistance( bubble.x, bubble.y, target.x, target.y )
    local distance = getRealDistance( dx, dy )

    dx = dx / distance
    dy = dy / distance

    local strength = 200 * (( 5 * target.radius ) / ( distance * distance ))

    bubble.dx = dx * strength
    bubble.dy = dy * strength

    bubble.x = bubble.x + bubble.dx * love.timer.getDelta() * DAMPING_FACTOR
    bubble.y = bubble.y + bubble.dy * love.timer.getDelta() * DAMPING_FACTOR
end

local function createBubble()
    local bubble = {}

    bubble.dx = 0
    bubble.dy = 0
    bubble.alpha = 0
    bubble.r = 1.0
    bubble.g = 1.0
    bubble.b = 1.0
    bubble.age = 0

    local nsew = love.math.random()
    if nsew >= 0.75 then
        bubble.x = math.floor( love.math.random( love.graphics.getWidth() ))
        bubble.y = love.math.random( SPAWN_MARGIN )
    elseif nsew >= 0.5 then
        bubble.x = math.floor( love.math.random( love.graphics.getWidth() ))
        bubble.y = love.graphics.getHeight() - love.math.random( SPAWN_MARGIN )
    elseif nsew >= 0.25 then
        bubble.x = love.graphics.getWidth() - love.math.random( SPAWN_MARGIN )
        bubble.y = math.floor( love.math.random( love.graphics.getHeight() ))
    elseif nsew >= 0 then
        bubble.x = love.math.random( SPAWN_MARGIN )
        bubble.y = math.floor( love.math.random( love.graphics.getHeight() ))
    end

    bubble.radius = love.math.random( 5, 15 )

    return bubble
end

function love.draw()
    for i = 1, #bubbles do
        local bubble = bubbles[i]
        love.graphics.setColor( bubble.r, bubble.g, 1, bubble.alpha )
        love.graphics.circle( 'line', bubble.x, bubble.y, bubble.radius )
        love.graphics.setColor( 1, 1, 1, 1 )
    end
end

function love.update( dt )
    mouse.x, mouse.y = love.mouse.getPosition()

    for i = #bubbles, 1, -1 do
        attract( bubbles[i] )

        for j = 1, #bubbles do
            repel( bubbles[i], bubbles[j])
        end

        repel( bubbles[i], mouse )

        bubbles[i].alpha = math.min( bubbles[i].alpha + dt, 1.0 )
        bubbles[i].r = math.max( bubbles[i].r - dt * 0.25, 0.12 )
        bubbles[i].g = math.max( bubbles[i].g - dt * 0.25, 0.12 )

        bubbles[i].age = bubbles[i].age + 1

        if bubbles[i].age > MAX_AGE then
            bubbles[i].radius = bubbles[i].radius - 4 * dt
            bubbles[i].alpha = bubbles[i].alpha - 4 * dt

            if bubbles[i].alpha <= 0 then
                table.remove( bubbles, i )
            end
        end
    end

    spawnTimer = spawnTimer + dt
    if spawnTimer > SPAWN_RATE then
        spawnTimer = 0

        bubbles[#bubbles + 1] = createBubble()
    end
end
