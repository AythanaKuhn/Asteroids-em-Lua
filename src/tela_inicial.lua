-- src/tela_inicial.lua

local tela_inicial = {}

-- Função para carregar os recursos da tela inicial
function tela_inicial.carregar()
    largura = love.graphics.getWidth()
    altura = love.graphics.getHeight()
end

-- Função chamada a cada quadro para atualizar a tela inicial (no momento, não faz nada)
function tela_inicial.atualizar(dt)
end

-- Função para desenhar a tela inicial
function tela_inicial.desenhar()
    love.graphics.setColor(1, 1, 1)  -- Define a cor como branca
    love.graphics.printf("ASTEROIDS", 0, altura / 3, largura, "center")
    love.graphics.printf("Pressione SPACE para começar", 0, altura / 2, largura, "center")
end

return tela_inicial
