function love.keypressed(key)
    if gameState == "start" and key == "space" then
        gameState = "playing"
    elseif gameState == "gameover" and key == "r" then
        gameState = "playing"
        score = 0
        lives = 3
        spawnAsteroids()
    elseif gameState == "playing" and (key == "space") then
        shootBullet()
    end
end

function love.gamepadpressed(joystick, button)
    if gameState == "start" and button == "start" then
        gameState = "playing"
    elseif gameState == "gameover" and button == "start" then
        gameState = "playing"
        score = 0
        lives = 3
        spawnAsteroids()
    elseif gameState == "playing" and (button == "a" or button == "rightshoulder") then
        isShooting = true
    end
end

function love.gamepadreleased(joystick, button)
    if button == "a" then isShooting = false
    end
end