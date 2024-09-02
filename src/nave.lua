-- src/nave.lua

local nave = {}

-- Função para inicializar a nave
function nave.inicializar(largura, altura)
    nave.x = largura / 2          -- Posição inicial no meio da tela
    nave.y = altura / 2           -- Posição inicial no meio da tela
    nave.angulo = 0               -- Ângulo inicial da nave
    nave.velocidade = 150         -- Velocidade da nave
end

-- Função para controlar a nave com as setas do teclado
function nave.controlar(dt, largura, altura)
    if love.keyboard.isDown("right") then
        nave.angulo = nave.angulo + 2 * dt  -- Rotaciona a nave para a direita
    elseif love.keyboard.isDown("left") then
        nave.angulo = nave.angulo - 2 * dt  -- Rotaciona a nave para a esquerda
    end
    
    if love.keyboard.isDown("up") then
        -- Calcula a direção em que a nave se move com base no ângulo
        nave.x = nave.x + math.sin(nave.angulo) * nave.velocidade * dt
        nave.y = nave.y - math.cos(nave.angulo) * nave.velocidade * dt
    end
    
    -- Mantém a nave dentro da tela
    if nave.x < 0 then nave.x = largura end
    if nave.x > largura then nave.x = 0 end
    if nave.y < 0 then nave.y = altura end
    if nave.y > altura then nave.y = 0 end
end

-- Função para desenhar a nave na tela
function nave.desenhar()
    love.graphics.push()
    love.graphics.translate(nave.x, nave.y) -- Move o sistema de coordenadas para a posição da nave
    love.graphics.rotate(nave.angulo)      -- Rotaciona a nave
    love.graphics.polygon("line", 0, -10, 5, 10, -5, 10) -- Desenha a nave em forma de triângulo
    love.graphics.pop()
end

return nave
