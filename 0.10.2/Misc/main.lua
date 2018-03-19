function love.load( ... )
	-- love.errhand("出错了！")-- 会蓝屏，而且不支持中文的样子。。。
	local font = love.graphics.newFont(20)
	-- 可以用于类型检查
	str = font:type() -- 返回 Font
	flag = font:typeOf(str) -- 返回 true
end
function love.draw()
	love.graphics.print(str)
	love.graphics.print(tostring(flag),50)
end

function love.filedropped(file) -- 有文件拖入窗口的时候触发
	-- 
end

function love.directorydropped(path) -- 目录拖进来的时候触发
	-- body
end

function love.lowmemory() -- 移动设备低内存的时候触发
	
end

function love.visible(bVisible) -- 最小化/重新出现
	
end