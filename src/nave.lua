local nave = {}
local tiros = {}

-- Função para inicializar a nave
function nave.inicializar(largura, altura)
    nave.x = largura / 2          -- Posição inicial no meio da tela
    nave.y = altura / 2           -- Posição inicial no meio da tela
    nave.angulo = 0               -- Ângulo inicial da nave
    nave.velocidade = 170         -- Velocidade da nave
    nave.taxaTiro = 0.17           -- Intervalo de tempo entre tiros
    nave.tempoDesdeUltimoTiro = 0 -- Contador de tempo desde o último tiro
end

-- Função para disparar tiros
function nave.atirar()
    local tiro = {
        x = nave.x,                       -- Posição inicial do tiro (na posição da nave)
        y = nave.y,
        angulo = nave.angulo,             -- Ângulo do tiro (na mesma direção da nave)
        velocidade = 300,                 -- Velocidade do tiro
        comprimento = 5                  -- Comprimento da linha do tiro
    }
    table.insert(tiros, tiro)
end

-- Função para atualizar os tiros
function nave.atualizarTiros(dt)
    for i, t in ipairs(tiros) do
        -- Atualiza a posição dos tiros com base no ângulo e velocidade
        t.x = t.x + math.sin(t.angulo) * t.velocidade * dt
        t.y = t.y - math.cos(t.angulo) * t.velocidade * dt
        
        -- Remove tiros que saem da tela
        if t.x < 0 or t.x > largura or t.y < 0 or t.y > altura then
            table.remove(tiros, i)
        end
    end
end

-- Função para controlar a nave com as setas do teclado
function nave.controlar(dt, largura, altura)
    nave.tempoDesdeUltimoTiro = nave.tempoDesdeUltimoTiro + dt

    if love.keyboard.isDown("right") then
        nave.angulo = nave.angulo + 4 * dt  -- Rotaciona a nave para a direita
    elseif love.keyboard.isDown("left") then
        nave.angulo = nave.angulo - 3.6 * dt  -- Rotaciona a nave para a esquerda
    end
    
    if love.keyboard.isDown("up") then
        -- Calcula a direção em que a nave se move com base no ângulo
        nave.x = nave.x + math.sin(nave.angulo) * nave.velocidade * dt
        nave.y = nave.y - math.cos(nave.angulo) * nave.velocidade * dt
    end
    
    -- Verifica se o jogador está pressionando a barra de espaço para atirar
    if love.keyboard.isDown("space") and nave.tempoDesdeUltimoTiro >= nave.taxaTiro then
        nave.atirar()
        nave.tempoDesdeUltimoTiro = 0 -- Reseta o contador de tempo após o disparo
    end

    -- Mantém a nave dentro da tela
    if nave.x < 0 then nave.x = largura end
    if nave.x > largura then nave.x = 0 end
    if nave.y < 0 then nave.y = altura end
    if nave.y > altura then nave.y = 0 end
    
    -- Atualiza os tiros
    nave.atualizarTiros(dt)
end

-- Função para desenhar a nave na tela
function nave.desenhar()
    -- Desenhar a nave
    love.graphics.push()
    love.graphics.translate(nave.x, nave.y) -- Move o sistema de coordenadas para a posição da nave
    love.graphics.rotate(nave.angulo)      -- Rotaciona a nave
    love.graphics.polygon("line", 0, -10, 5, 10, -5, 10) -- Desenha a nave em forma de triângulo
    love.graphics.pop()
    
    -- Desenhar os tiros como linhas
    for i, t in ipairs(tiros) do
        local fimX = t.x + math.sin(t.angulo) * t.comprimento
        local fimY = t.y - math.cos(t.angulo) * t.comprimento
        love.graphics.line(t.x, t.y, fimX, fimY)  -- Desenha o tiro como uma pequena linha
    end
end

return nave