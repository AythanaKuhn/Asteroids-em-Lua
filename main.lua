nave = require "src/nave"
asteroides = require "src/asteroides"
controle = require "src/controle"
colisoes = require "src/colisoes" 
tiros = require "src/tiros"

-- Carregar recursos e iniciar variáveis
function love.load()
    -- Estado do jogo
    gameState = "start"

    -- Fonte para o título
    titleFont = love.graphics.newFont(30)
    font2 = love.graphics.newFont("Retro Gaming.ttf", 30) 
    
    -- Carregar imagens
    background = love.graphics.newImage("imagens/fundo.png")
    nave = {x = 400, y = 300, angle = 0, speed = 0, img = love.graphics.newImage("imagens/Nave.png")}
    asteroidImg = love.graphics.newImage("imagens/asteroide3.png")
    heart = love.graphics.newImage("imagens/vida.png")
    titulo = love.graphics.newImage("imagens/titulo.png")

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
    acceleration = 200
    friction = 0.99

    -- Configurações dos tiros
    bullets = {}
    bulletSpeed = 600

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
    --    love.graphics.printf("ASTEROIDS", 0, love.graphics.getHeight()/3, love.graphics.getWidth(), "center")
        love.graphics.draw(titulo, -25, -210, 0, 1.7, 1.7)
        love.graphics.printf("Pressione START / ESPAÇO\npara jogar", 0, 350, love.graphics.getWidth(), "center")
    
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
  --      updateNave(dt)
  --      updateBullets(dt)
  --      updateAsteroids(dt)
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
