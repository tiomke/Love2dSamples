function love.load()
    love.filesystem.setIdentity('screenshot_example') -- 设置存放文件的目录
end

function love.draw()
	love.graphics.print(love.filesystem.getSaveDirectory()) -- 打印一下保存的路径
end
 
function love.keypressed()
    local screenshot = love.graphics.newScreenshot() -- 进行截图
    screenshot:encode('png', os.time() .. '.png') -- 存储截图
end