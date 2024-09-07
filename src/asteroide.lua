local asteroide = {}

-- Função que atribui aleatoriamente 50 ou 170 à variável Tamanho
function asteroide.atribuirTamanhoAleatorio()
    -- Gera um número aleatório entre 1 e 2
    local valorAleatorio = math.random(1, 3)

    -- Atribui 50 se o número for 1, ou 170 se for 2
    if valorAleatorio == 1 then
        return 50
    else
        return 120
    end
end

-- Função para criar um novo asteroide
function asteroide.criar()
    return {
        x = math.random(0, largura),
        y = math.random(0, altura),
        angulo = math.random() * 2 * math.pi,  -- Direção do movimento
        velocidade = math.random(50, 100),
        tamanho = asteroide.atribuirTamanhoAleatorio(),
        rotacao = math.random() * 2 * math.pi, -- Rotação aleatória do asteroide
        rotacaoVelocidade = math.random(-1, 1) -- Velocidade de rotação aleatória
    }
end

-- Função para atualizar a posição do asteroide
function asteroide.atualizar(a, dt)
    a.x = a.x + math.cos(a.angulo) * a.velocidade * dt
    a.y = a.y + math.sin(a.angulo) * a.velocidade * dt

    -- Atualiza a rotação do asteroide
    a.rotacao = a.rotacao + a.rotacaoVelocidade * dt

    -- Mantém o asteroide dentro da tela
    if a.x < 0 then a.x = largura end
    if a.x > largura then a.x = 0 end
    if a.y < 0 then a.y = altura end
    if a.y > altura then a.y = 0 end
end

-- Função para desenhar o asteroide na tela
function asteroide.desenhar(a)
    local imagem = love.graphics.newImage("assets/imagens/asteroide2.png")
    love.graphics.draw(imagem, a.x, a.y, a.rotacao, a.tamanho / imagem:getWidth(), a.tamanho / imagem:getHeight(), imagem:getWidth() / 2, imagem:getHeight() / 2)
end

return asteroide
