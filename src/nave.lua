local nave = {}
local tiros = {}

-- Função para inicializar a nave
function nave.inicializar(largura, altura)
    nave.x = largura / 2          -- Posição inicial no meio da tela
    nave.y = altura / 2           -- Posição inicial no meio da tela
    nave.angulo = 0               -- Ângulo inicial da nave
    nave.velocidade = 0           -- Velocidade da nave começa em 0
    nave.velocidadeMax = 200      -- Velocidade máxima da nave
    nave.aceleracao = 150         -- Aceleração da nave
    nave.desaceleracao = 70       -- Desaceleração da nave
    nave.taxaTiro = 0.17          -- Intervalo de tempo entre tiros
    nave.tempoDesdeUltimoTiro = 0 -- Contador de tempo desde o último tiro
end

-- Função para disparar tiros
function nave.atirar()
    local tiro = {
        x = nave.x,                       -- Posição inicial do tiro (na posição da nave)
        y = nave.y,
        angulo = nave.angulo,             -- Ângulo do tiro (na mesma direção da nave)
        velocidade = 400,                 -- Velocidade do tiro
        comprimento = 5                   -- Comprimento da linha do tiro
    }
    table.insert(tiros, tiro)
end

-- Função para atualizar os tiros
function nave.atualizarTiros(dt, largura, altura, asteroides)
    for i = #tiros, 1, -1 do  -- Percorrer os tiros de trás para frente para evitar problemas de remoção
        local t = tiros[i]
        -- Atualiza a posição dos tiros com base no ângulo e velocidade
        t.x = t.x + math.sin(t.angulo) * t.velocidade * dt
        t.y = t.y - math.cos(t.angulo) * t.velocidade * dt
        
        -- Remove tiros que saem da tela
        if t.x < 0 or t.x > largura or t.y < 0 or t.y > altura then
            table.remove(tiros, i)
        else
            -- Verifica colisão com asteroides
            for j = #asteroides, 1, -1 do
                local a = asteroides[j]
                local raioAsteroide = a.tamanho / 2  -- Usar metade do tamanho como raio
                local distancia = math.sqrt((t.x - a.x)^2 + (t.y - a.y)^2)
                if distancia < raioAsteroide then  -- Colisão circular
                    table.remove(asteroides, j)  -- Remove o asteroide colidido
                    table.remove(tiros, i)  -- Remove o tiro colidido
                    break
                end
            end
        end
    end
end

-- Função para controlar a nave com inércia
function nave.controlar(dt, largura, altura, asteroides)
    nave.tempoDesdeUltimoTiro = nave.tempoDesdeUltimoTiro + dt

    if love.keyboard.isDown("right") then
        nave.angulo = nave.angulo + 3 * dt  -- Rotaciona a nave para a direita
    elseif love.keyboard.isDown("left") then
        nave.angulo = nave.angulo - 3 * dt  -- Rotaciona a nave para a esquerda
    end
    
    -- Se a tecla "up" for pressionada, acelera a nave
    if love.keyboard.isDown("up") then
        nave.velocidade = nave.velocidade + nave.aceleracao * dt
        if nave.velocidade > nave.velocidadeMax then
            nave.velocidade = nave.velocidadeMax
        end
    else
        -- Se a tecla não for pressionada, desacelera gradualmente
        nave.velocidade = nave.velocidade - nave.desaceleracao * dt
        if nave.velocidade < 0 then
            nave.velocidade = 0
        end
    end

    -- Atualiza a posição da nave com base na velocidade e ângulo
    nave.x = nave.x + math.sin(nave.angulo) * nave.velocidade * dt
    nave.y = nave.y - math.cos(nave.angulo) * nave.velocidade * dt

    -- Mantém a nave dentro da tela
    if nave.x < 0 then nave.x = largura end
    if nave.x > largura then nave.x = 0 end
    if nave.y < 0 then nave.y = altura end
    if nave.y > altura then nave.y = 0 end
    
    -- Verifica se o jogador está pressionando a barra de espaço para atirar
    if love.keyboard.isDown("space") and nave.tempoDesdeUltimoTiro >= nave.taxaTiro then
        nave.atirar()
        nave.tempoDesdeUltimoTiro = 0 -- Reseta o contador de tempo após o disparo
    end
    
    -- Atualiza os tiros
    nave.atualizarTiros(dt, largura, altura, asteroides)
end

-- Função para desenhar a nave na tela
function nave.desenhar()
    love.graphics.push()
    love.graphics.translate(nave.x, nave.y) -- Move o sistema de coordenadas para a posição da nave
    love.graphics.rotate(nave.angulo)      -- Rotaciona a nave
    
    -- Desenha a nave usando uma imagem
    local naveimagem = love.graphics.newImage("assets/imagens/Nave.png")
    love.graphics.draw(naveimagem, 0, 0, 0, 1, 1, naveimagem:getWidth() / 2, naveimagem:getHeight() / 2)

    love.graphics.pop()

    -- Desenhar os tiros
    for i, t in ipairs(tiros) do
        local fimX = t.x + math.sin(t.angulo) * t.comprimento
        local fimY = t.y - math.cos(t.angulo) * t.comprimento
        love.graphics.line(t.x, t.y, fimX, fimY)
    end
end

return nave