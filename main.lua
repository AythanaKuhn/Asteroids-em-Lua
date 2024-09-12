-- Carregar recursos e iniciar variáveis
function love.load()
    -- Estado do jogo
    gameState = "start"

    -- Fonte para o título
    titleFont = love.graphics.newFont(30)
    font2 = love.graphics.newFont("Retro Gaming.ttf", 24) -- Substitua com o caminho correto e o tamanho que preferir
    
    -- Carregar imagens
    background = love.graphics.newImage("imagens/fundo.png")
    nave = {x = 400, y = 300, angle = 0, speed = 0, img = love.graphics.newImage("imagens/Nave.png")}
    asteroidImg = love.graphics.newImage("imagens/asteroide3.png")
    heart = love.graphics.newImage("imagens/vida.png")

    -- Carregar Sons
    musica = love.audio.newSource("sons/musica.mp3","stream")
    musica:setVolume(0.2)
    laser = love.audio.newSource("sons/laser.wav","static")
    explosao = love.audio.newSource("sons/explosao.wav","static")
    vidaPerdida = love.audio.newSource("sons/vidaPerdida.mp3","static")
    gameOver = love.audio.newSource("sons/gameOver.wav","static")

    -- Tempo de invulnerabilidade após perder uma vida
    invulnerabilityTime = 2 -- Tempo em segundos
    invulnerable = false
    invulnerableTimer = 0
    

    -- Configurações da nave
    acceleration = 100
    friction = 0.98

    -- Configurações dos tiros
    bullets = {}
    bulletSpeed = 300

    -- Configurações dos asteroides
    asteroids = {}
    spawnAsteroids()

    -- COntrole
    joysticks = love.joystick.getJoysticks()

    -- Pontuação e vidas
    score = 0
    lives = 3

    shootCooldown = 0.25
    timeSinceLastShot = shootCooldown
    isShooting = false
end

-- Função de desenhar na tela
function love.draw()
    if gameState == "start" then
        love.graphics.draw(background, 0, 0)
        love.graphics.setFont(font2)
        love.graphics.printf("ASTEROIDS", 0, love.graphics.getHeight()/3, love.graphics.getWidth(), "center")
        love.graphics.printf("Pressione START / ESPAÇO\npara jogar", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
    
    elseif gameState == "playing" then
        musica:play()
        love.graphics.draw(background, 0, 0)
        love.graphics.draw(nave.img, nave.x, nave.y, nave.angle, 1, 1, nave.img:getWidth()/2, nave.img:getHeight()/2)
        -- Desenhar corações de vida abaixo do score
        local xStart = 15  -- Posição X inicial dos corações
        local yStart = 50  -- Posição Y abaixo do score
        
        if lives >= 1 then
            love.graphics.draw(heart, xStart, yStart)
        end
        if lives >= 2 then
            love.graphics.draw(heart, xStart + 40, yStart)
        end
        if lives >= 3 then
            love.graphics.draw(heart, xStart + 80, yStart)
        end
        -- Desenhar tiros como linhas
        for _, bullet in ipairs(bullets) do
            -- Comprimento da linha do tiro
            local bulletLength = 7

            -- Calcular o ponto final da linha com base na direção do tiro
            local endX = bullet.x + bullet.dx * (bulletLength / bulletSpeed)
            local endY = bullet.y + bullet.dy * (bulletLength / bulletSpeed)

            -- Desenhar a linha do tiro
            love.graphics.line(bullet.x, bullet.y, endX, endY)
        end
        
        -- Desenhar asteroides
        drawAsteroids()

        -- Desenhar pontuação e vidas
        love.graphics.print("Score: " .. score, 10, 10)
    elseif gameState == "gameover" then
        musica:stop()
        love.graphics.printf("GAME OVER", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
        love.graphics.printf("Pontuação Final: " .. score, 0, 200, love.graphics.getWidth(), "center")
        love.graphics.printf("Pressione R / START\npara recomeçar", 0, love.graphics.getHeight()/1.5, love.graphics.getWidth(), "center")
    end

end


-- Função de movimentação e lógica do jogo
function love.update(dt)
    if gameState == "playing" then
        timeSinceLastShot = timeSinceLastShot - dt

        if love.keyboard.isDown("space") or isShooting then
            if timeSinceLastShot <= 0 then
                shootBullet()
                timeSinceLastShot = shootCooldown
            end
        end

        -- Atualizar movimento da nave
        updateNave(dt)
        -- Atualizar tiros
        updateBullets(dt)

        -- Atualizar asteroides
        updateAsteroids(dt)
        updateNave(dt)
        updateBullets(dt)
        updateAsteroids(dt)
        checkBulletCollision()  -- Verifica colisão dos tiros com asteroides
        checkShipCollision()

        -- Controle da invulnerabilidade
        if invulnerable then
            invulnerableTimer = invulnerableTimer - dt
            if invulnerableTimer <= 0 then
                invulnerable = false
            end
        end
    end
end


-- Lidar com entradas do teclado
function love.keypressed(key)
    if gameState == "start" and key == "space" then
        gameState = "playing"
    elseif gameState == "gameover" and key == "r" then
        gameState = "playing"
        -- Resetar o jogo
        score = 0
        lives = 3
        spawnAsteroids()
    elseif gameState == "playing" and (key == "space") then
        shootBullet()
    end
end

function love.gamepadpressed(joystick, button)
    if gameState == "start" and button == "start" then
        gameState = "playing"
    elseif gameState == "gameover" and button == "start" then
        gameState = "playing"
        -- Resetar o jogo
        score = 0
        lives = 3
        spawnAsteroids()
    elseif gameState == "playing" and (button == "a" or button == "rightshoulder") then
        isShooting = true
    end
end

function love.gamepadreleased(joystick, button)
    if button == "a" then isShooting = false
    end
end

-- Função para atualizar a nave
function updateNave(dt)
    -- Controle via teclado
    if love.keyboard.isDown("up") then
        nave.speed = nave.speed + acceleration * dt
    end
    if love.keyboard.isDown("left") then
        nave.angle = nave.angle - 2 * dt
    end
    if love.keyboard.isDown("right") then
        nave.angle = nave.angle + 2 * dt
    end


-- Controle via joystick, se houver um conectado
    if #joysticks > 0 then
        local joystick = joysticks[1] -- Usar o primeiro joystick conectado
        
        -- Analógico esquerdo controla a rotação e a aceleração
        local leftX = joystick:getAxis(2) -- Eixo X do analógico esquerdo (girar nave)
        local leftY = joystick:getAxis(1) -- Eixo Y do analógico esquerdo (acelerar nave)
        
        -- Verifica se o analógico está sendo movido (fora da zona morta)
        if math.abs(leftX) > 0.2 or math.abs(leftY) > 0.2 then
            -- Calcular o ângulo baseado no analógico esquerdo (ângulo de direção)
            nave.angle = math.atan2(leftY, -leftX)  -- Corrigido para refletir a orientação correta
            
            -- Acelerar a nave na direção do analógico
            nave.speed = nave.speed + acceleration * dt
        end
    end

    -- Atualizar posição da nave
    nave.y = nave.y - math.cos(nave.angle) * nave.speed * dt
    nave.x = nave.x + math.sin(nave.angle) * nave.speed * dt

    -- Aplicar inércia
    nave.speed = nave.speed * friction

    -- Manter a nave dentro da tela
    if nave.x < 0 then nave.x = love.graphics.getWidth() end
    if nave.x > love.graphics.getWidth() then nave.x = 0 end
    if nave.y < 0 then nave.y = love.graphics.getHeight() end
    if nave.y > love.graphics.getHeight() then nave.y = 0 end
end

-- Função para atirar
function shootBullet()
    laser:play()

    local shipTipX = nave.x + math.cos(nave.angle - math.pi/2) * (nave.img:getHeight()/2)
    local shipTipY = nave.y + math.sin(nave.angle - math.pi/2) * (nave.img:getHeight()/2)

    local bullet = {
        x = shipTipX,
        y = shipTipY,
        dx = math.cos(nave.angle - math.pi/2) * bulletSpeed,
        dy = math.sin(nave.angle - math.pi/2) * bulletSpeed
    }
    table.insert(bullets, bullet)
end

-- Função para atualizar os tiros
function updateBullets(dt)
    for i, bullet in ipairs(bullets) do
        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt

        -- Remover tiro se sair da tela
        if bullet.x < 0 or bullet.x > love.graphics.getWidth() or bullet.y < 0 or bullet.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
end

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
        asteroid.x = asteroid.x + asteroid.dx * dt
        asteroid.y = asteroid.y + asteroid.dy * dt
        asteroid.angle = asteroid.angle + asteroid.rotationSpeed * dt

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

function checkBulletCollision()
    for i, bullet in ipairs(bullets) do
        for j, asteroid in ipairs(asteroids) do
            local distance = math.sqrt((bullet.x - asteroid.x)^2 + (bullet.y - asteroid.y)^2)
            if distance < asteroid.size / 2 then

                explosao:play()
                -- Adicionar pontuação de acordo com o tamanho do asteroide
                if asteroid.size == 120 then
                    score = score + 20
                elseif asteroid.size == 60 then
                    score = score + 50
                elseif asteroid.size == 30 then
                    score = score + 100
                end
                
                -- Remover o tiro
                table.remove(bullets, i)

                -- Dividir asteroide ou remover se for pequeno
                if asteroid.size > 30 then
                    local newSize = asteroid.size / 2
                    table.insert(asteroids, {
                        x = asteroid.x, 
                        y = asteroid.y, 
                        size = newSize, 
                        dx = math.random(-50, 50), 
                        dy = math.random(-50, 50), 
                        angle = math.random(0, 2 * math.pi), 
                        rotationSpeed = math.random(-1, 1)
                    })
                    table.insert(asteroids, {
                        x = asteroid.x, 
                        y = asteroid.y, 
                        size = newSize, 
                        dx = math.random(-50, 50), 
                        dy = math.random(-50, 50), 
                        angle = math.random(0, 2 * math.pi), 
                        rotationSpeed = math.random(-1, 1)
                    })
                else
                    -- Verificar se o número de asteroides na tela é menor que 5 antes de gerar um novo asteroide
                    if #asteroids < 10 then
                        spawnLargeAsteroid()
                    end
                end

                -- Remover o asteroide destruído
                table.remove(asteroids, j)
                break
            end
        end
    end
end


function checkShipCollision()
    if not invulnerable then
        for _, asteroid in ipairs(asteroids) do
            local distance = math.sqrt((nave.x - asteroid.x)^2 + (nave.y - asteroid.y)^2)
            if distance < asteroid.size / 2 then
                vidaPerdida:play()

                lives = lives - 1
                nave.x, nave.y = love.graphics.getWidth()/2, love.graphics.getHeight()/2  -- Resetar nave ao centro
                nave.speed = 0

                -- Ativar invulnerabilidade
                invulnerable = true
                invulnerableTimer = invulnerabilityTime

                if lives <= 0 then
                    gameOver:play()
                    gameState = "gameover"
                end
                break
            end
        end
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