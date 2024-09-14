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
                    if #asteroids < 15 then
                        spawnLargeAsteroid()
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