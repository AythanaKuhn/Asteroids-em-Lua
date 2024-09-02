-- src/asteroide.lua

local asteroide = {}

-- Função para criar um novo asteroide
function asteroide.criar()
    return {
        x = math.random(0, largura),
        y = math.random(0, altura),
        angulo = math.random() * 2 * math.pi,
        velocidade = math.random(50, 100),
        tamanho = math.random(20, 50)
    }
end

-- Função para atualizar a posição do asteroide
function asteroide.atualizar(a, dt)
    a.x = a.x + math.cos(a.angulo) * a.velocidade * dt
    a.y = a.y + math.sin(a.angulo) * a.velocidade * dt
    
    -- Mantém o asteroide dentro da tela
    if a.x < 0 then a.x = largura end
    if a.x > largura then a.x = 0 end
    if a.y < 0 then a.y = altura end
    if a.y > altura then a.y = 0 end
end

-- Função para desenhar o asteroide na tela
function asteroide.desenhar(a)
    love.graphics.circle("line", a.x, a.y, a.tamanho)
end

return asteroide
