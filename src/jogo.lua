-- src/jogo.lua

local nave = require "src/nave"
local asteroide = require "src/asteroide"

local jogo = {}

-- Função para carregar os recursos e inicializar o jogo
function jogo.carregar()
    nave.inicializar(largura, altura)
    asteroides = {}
    for i = 1, 5 do
        table.insert(asteroides, asteroide.criar())
    end
end

-- Função chamada a cada quadro para atualizar o estado do jogo
function jogo.atualizar(dt)
    nave.controlar(dt, largura, altura)
    for i, a in ipairs(asteroides) do
        asteroide.atualizar(a, dt)
    end
end

-- Função para desenhar os elementos do jogo na tela
function jogo.desenhar()
    nave.desenhar()
    for i, a in ipairs(asteroides) do
        asteroide.desenhar(a)
    end
end

return jogo
