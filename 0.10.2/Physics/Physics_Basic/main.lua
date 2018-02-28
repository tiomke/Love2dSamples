-- 一个板和一个球
function love.load()

	-- 设置多少像素表示1m
	love.physics.setMeter(64) 
	-- 创建一个世界
	world = love.physics.newWorld(0,9.8*64,true)
	-- 创建一个圆形作为球
	ball = {}
	ball.body = love.physics.newBody(world,250,50,"dynamic")
	ball.shape = love.physics.newCircleShape( 30 ) -- 绑形状
	ball.fixture = love.physics.newFixture( ball.body, ball.shape ) 

	-- 创建一个长方形作为地面
	ground = {}
	ground.body = love.physics.newBody(world,250,200,"static")
	ground.shape = love.physics.newRectangleShape( 500, 20 ) -- 绑形状
	ground.fixture = love.physics.newFixture( ground.body, ground.shape ) -- 这个操作会把地面的shape 放到碰撞检测系统里面，如果不写这一句地面就无法阻挡小球了
	print(ground.shape,ground.fixture:getShape()) -- 可以看到 fixture 中的 shape 和传入的 shape 不是同一个
	-- 
end

function love.update(dt)
	world:update(dt) -- 更新世界
end
function love.draw()
	-- 根据物理信息绘制图形
	love.graphics.setColor(0,0,255,255)
	love.graphics.circle("fill",ball.body:getX(),ball.body:getY(),ball.shape:getRadius())
	
	love.graphics.setColor(0,255,0,255)
	love.graphics.polygon("fill",ground.body:getWorldPoints(ground.shape:getPoints()))
end
--[[
world = love.physics.newWorld( xg, yg, sleep ) -- x 方向的重力，y方向的重力，是否允许物体 sleep
body = love.physics.newBody( world, x, y, type ) -- type 有 static dynamic 和 kinematic 三种
fixture = love.physics.newFixture( body, shape, density ) -- density 大概是绑的紧密程度我猜

]]