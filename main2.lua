-- main.lua

-- Carrega os módulos do jogo
local tela_inicial = require "src/tela_inicial"
local jogo = require "src/jogo"

-- Variável global que controla o estado do jogo (qual tela está ativa)
Estado = "menu"

-- Função chamada uma vez no início do jogo
function love.load()
    -- Carrega a tela inicial do jogo
    tela_inicial.carregar()
end

-- Função chamada a cada quadro para atualizar o jogo
function love.update(dt)
    if Estado == "menu" then
        tela_inicial.atualizar(dt)
    elseif Estado == "jogo" then
        jogo.atualizar(dt)
    end
end

-- Função chamada para desenhar na tela
function love.draw()
    if Estado == "menu" then
        tela_inicial.desenhar()
    elseif Estado == "jogo" then
        jogo.desenhar()
    end
end

-- Função que detecta quando o usuário pressiona uma tecla
function love.keypressed(key)
    if Estado == "menu" and key == "space" then
        -- Começa o jogo se a barra de espaço for pressionada
        Estado = "jogo"
        jogo.carregar()
    elseif Estado == "jogo" and key == "escape" then
        -- Retorna ao menu se "ESC" for pressionado
        Estado = "menu"
        tela_inicial.carregar()
    end
end