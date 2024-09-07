-- src/tela_inicial.lua

local tela_inicial = {}
local fundo  -- Variável para armazenar a imagem de fundo

-- Função para carregar os recursos da tela inicial
function tela_inicial.carregar()
    Largura = love.graphics.getWidth()
    Altura = love.graphics.getHeight()
    
    -- Carrega a imagem de fundo
    fundo = love.graphics.newImage("/assets/imagens/fundo.jpg")
end

-- Função chamada a cada quadro para atualizar a tela inicial (no momento, não faz nada)
function tela_inicial.atualizar(dt)
end

-- Função para desenhar a tela inicial
function tela_inicial.desenhar()
    -- Desenha o fundo
    love.graphics.draw(fundo, 0, 0)

    love.graphics.setColor(1, 1, 1)  -- Define a cor como branca
    love.graphics.printf("ASTEROIDS", 0, Altura / 3, Largura, "center")
    love.graphics.printf("Pressione SPACE para começar", 0, Altura / 2, Largura, "center")
end

return tela_inicial

