function updateNave(dt)
    -- Controle via teclado
    if love.keyboard.isDown("up") then
        nave.speed = nave.speed + acceleration * dt 
    end
    if love.keyboard.isDown("left") then
        nave.angle = nave.angle - 2 * dt * 2
    end
    if love.keyboard.isDown("right") then
        nave.angle = nave.angle + 2 * dt * 2
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