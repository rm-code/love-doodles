function love.load()
    local source = love.image.newImageData("foo11.jpg")
    local w, h = source:getDimensions()
    local index = 0
    local map = {}

    source:mapPixel( function( x, y, r, g, b, a )
        map[x] = map[x] or {}
        map[x][y] = { r = r, g = g, b = b, a = a }

        return r, g, b, a
    end)

    while index < w do
        local x = index
        for n = h-1, 0, -1 do
            for y = 0, n - 1 do
                local current = map[x][y]
                local compare = map[x][y-1]

                if compare then
                    local currentLuma = 0.2126 * current.r + 0.7152 * current.g + 0.0722 * current.b
                    local compareLuma = 0.2126 * compare.r + 0.7152 * compare.g + 0.0722 * compare.b

                    if currentLuma < compareLuma then
                        map[x][y] = compare
                        map[x][y-1] = current
                    end
                end
            end
        end

        index = index + 1
    end

    for x = 0, w-1 do
        for y = 0, h-1 do
            source:setPixel( x, y, map[x][y].r, map[x][y].g, map[x][y].b, map[x][y].a )
        end
    end
    source:encode("png", "out_" .. love.timer.getTime() .. ".png")
end
