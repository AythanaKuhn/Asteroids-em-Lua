-- Função para atirar
function shootBullet()
    laser:play()

    local shipTipX = nave.x + math.cos(nave.angle - math.pi/2) * (nave.img:getHeight()/2)
    local shipTipY = nave.y + math.sin(nave.angle - math.pi/2) * (nave.img:getHeight()/2)

    local bullet = {
        x = shipTipX,
        y = shipTipY,
        dx = math.cos(nave.angle - math.pi/2) * bulletSpeed,
        dy = math.sin(nave.angle - math.pi/2) * bulletSpeed
    }
    table.insert(bullets, bullet)
end

-- Função para atualizar os tiros
function updateBullets(dt)
    for i, bullet in ipairs(bullets) do
        bullet.x = bullet.x + bullet.dx * dt
        bullet.y = bullet.y + bullet.dy * dt

        -- Remover tiro se sair da tela
        if bullet.x < 0 or bullet.x > love.graphics.getWidth() or bullet.y < 0 or bullet.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
end