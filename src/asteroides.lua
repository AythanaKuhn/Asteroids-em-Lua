-- Função para criar asteroides
function spawnAsteroids()
    asteroids = {}
    for i = 1, 5 do
        local size = math.random(1, 2) == 1 and 120 or 60
        table.insert(asteroids, {x = math.random(0, love.graphics.getWidth()), y = math.random(0, love.graphics.getHeight()), size = size, dx = math.random(-100, 100), dy = math.random(-100, 100), angle = math.random(0, 2*math.pi), rotationSpeed = math.random(-1, 1)})
    end
end

-- Função para atualizar asteroides
function updateAsteroids(dt)
    for _, asteroid in ipairs(asteroids) do
        asteroid.x = asteroid.x + asteroid.dx * dt * 2
        asteroid.y = asteroid.y + asteroid.dy * dt * 2
        asteroid.angle = asteroid.angle + asteroid.rotationSpeed * dt * 2

        -- Manter asteroide dentro da tela
        if asteroid.x < 0 then asteroid.x = love.graphics.getWidth() end
        if asteroid.x > love.graphics.getWidth() then asteroid.x = 0 end
        if asteroid.y < 0 then asteroid.y = love.graphics.getHeight() end
        if asteroid.y > love.graphics.getHeight() then asteroid.y = 0 end
    end
end

-- Função para desenhar asteroides
function drawAsteroids()
    for _, asteroid in ipairs(asteroids) do
        love.graphics.draw(asteroidImg, asteroid.x, asteroid.y, asteroid.angle, asteroid.size/asteroidImg:getWidth(), asteroid.size/asteroidImg:getHeight(), asteroidImg:getWidth()/2, asteroidImg:getHeight()/2)
    end
end

function spawnLargeAsteroid()
    local size = 120  -- Tamanho fixo para asteroides grandes
    local corner = math.random(1, 4)  -- Escolhe um dos 4 cantos da tela

    local x, y

    -- Definir posição baseada no canto escolhido
    if corner == 1 then
        -- Canto superior esquerdo
        x = math.random(0, love.graphics.getWidth() * 0.1)
        y = math.random(0, love.graphics.getHeight() * 0.1)
    elseif corner == 2 then
        -- Canto superior direito
        x = math.random(love.graphics.getWidth() * 0.9, love.graphics.getWidth())
        y = math.random(0, love.graphics.getHeight() * 0.1)
    elseif corner == 3 then
        -- Canto inferior esquerdo
        x = math.random(0, love.graphics.getWidth() * 0.1)
        y = math.random(love.graphics.getHeight() * 0.9, love.graphics.getHeight())
    elseif corner == 4 then
        -- Canto inferior direito
        x = math.random(love.graphics.getWidth() * 0.9, love.graphics.getWidth())
        y = math.random(love.graphics.getHeight() * 0.9, love.graphics.getHeight())
    end

    table.insert(asteroids, {
        x = x,
        y = y,
        size = size,  -- Definido como 120 para garantir que seja grande
        dx = math.random(-50, 50),
        dy = math.random(-50, 50),
        angle = math.random(0, 2 * math.pi),
        rotationSpeed = math.random(-1, 1)
    })
end

function spawnNewAsteroid()
    local newSize = math.random(1, 2) == 1 and 120 or 60
    local corner = math.random(1, 4)  -- Escolhe um dos 4 cantos da tela

    local x, y

    -- Definir posição baseada no canto escolhido
    if corner == 1 then
        -- Canto superior esquerdo
        x = math.random(0, love.graphics.getWidth() * 0.1)
        y = math.random(0, love.graphics.getHeight() * 0.1)
    elseif corner == 2 then
        -- Canto superior direito
        x = math.random(love.graphics.getWidth() * 0.9, love.graphics.getWidth())
        y = math.random(0, love.graphics.getHeight() * 0.1)
    elseif corner == 3 then
        -- Canto inferior esquerdo
        x = math.random(0, love.graphics.getWidth() * 0.1)
        y = math.random(love.graphics.getHeight() * 0.9, love.graphics.getHeight())
    elseif corner == 4 then
        -- Canto inferior direito
        x = math.random(love.graphics.getWidth() * 0.9, love.graphics.getWidth())
        y = math.random(love.graphics.getHeight() * 0.9, love.graphics.getHeight())
    end

    table.insert(asteroids, {
        x = x,
        y = y,
        size = newSize,
        dx = math.random(-50, 50),
        dy = math.random(-50, 50),
        angle = math.random(0, 2*math.pi),
        rotationSpeed = math.random(-1, 1)
    })
end