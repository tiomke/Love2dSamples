function love.load()
	local img = love.graphics.newImage('img.png')

	psystem = love.graphics.newParticleSystem(img, 32) -- 最多有32个粒子同时存在
	psystem:setParticleLifetime(2, 10) -- 例子的生命周期范围，秒
	psystem:setEmissionRate(2) -- 设置发射率,值越大越高
  psystem:setSizes(1,1.2,0.1) -- 粒子从出现到消失的过程中大小会发生变化
	psystem:setSizeVariation(1) -- 设置尺寸变化 没有很明白什么作用 ，跟 setSizes 有关联，0的时候发射的粒子都是原始大小，1的时候发射粒子有大有小
	psystem:setLinearAcceleration(-20, -20, 0, 0) -- 往左上方向随机移动
	psystem:setColors(255, 255, 255, 255, 255, 0, 255, 0) -- 颜色变化
end

function love.draw()
	-- Draw the particle system at the center of the game window.
	love.graphics.draw(psystem, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)
end

function love.update(dt)
	psystem:update(dt) -- 需要更新
end
