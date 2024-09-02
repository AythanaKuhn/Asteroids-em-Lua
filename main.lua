-- main.lua

-- Carrega os módulos do jogo
local tela_inicial = require "src/tela_inicial"
local jogo = require "src/jogo"

-- Variável global que controla o estado do jogo (qual tela está ativa)
estado = "menu"

-- Função chamada uma vez no início do jogo
function love.load()
    -- Carrega a tela inicial do jogo
    tela_inicial.carregar()
end

-- Função chamada a cada quadro para atualizar o jogo
function love.update(dt)
    if estado == "menu" then
        tela_inicial.atualizar(dt)
    elseif estado == "jogo" then
        jogo.atualizar(dt)
    end
end

-- Função chamada para desenhar na tela
function love.draw()
    if estado == "menu" then
        tela_inicial.desenhar()
    elseif estado == "jogo" then
        jogo.desenhar()
    end
end

-- Função que detecta quando o usuário pressiona uma tecla
function love.keypressed(key)
    if estado == "menu" and key == "space" then
        -- Começa o jogo se a barra de espaço for pressionada
        estado = "jogo"
        jogo.carregar()
    elseif estado == "jogo" and key == "escape" then
        -- Retorna ao menu se "ESC" for pressionado
        estado = "menu"
        tela_inicial.carregar()
    end
end
