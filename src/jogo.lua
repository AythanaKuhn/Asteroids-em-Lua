local nave = require "src/nave"
local asteroide = require "src/asteroide"

local jogo = {}
local asteroides = {}

-- Variáveis de largura e altura
local largura, altura

-- Função para carregar os recursos e inicializar o jogo
function jogo.carregar()
    largura, altura = love.graphics.getWidth(), love.graphics.getHeight()  -- Obtém a largura e altura da janela
    nave.inicializar(largura, altura)
    fundo = love.graphics.newImage("/assets/imagens/fundo.jpg")
    
    asteroides = {}  -- Inicializa a tabela de asteroides
    for i = 1, 5 do
        table.insert(asteroides, asteroide.criar())  -- Cria 5 asteroides
    end
end

-- Função chamada a cada quadro para atualizar o estado do jogo
function jogo.atualizar(dt)
    nave.controlar(dt, largura, altura, asteroides)  -- Passa a tabela de asteroides
    for i, a in ipairs(asteroides) do
        asteroide.atualizar(a, dt)
    end
end

-- Função para desenhar os elementos do jogo na tela
function jogo.desenhar()
    love.graphics.draw(fundo,0,0)
    nave.desenhar()
    for i, a in ipairs(asteroides) do
        asteroide.desenhar(a)
    end
end

return jogo